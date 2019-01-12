############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder

# set goroot env 
ENV GOROOT=/usr/local/go

# Install git. Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

# Add non-priveleged user
RUN adduser -D -g 1000 appuser

# Create directory tree for source code
RUN mkdir -p $GOPATH/src/github.com/bitfinexcom

# Set workdir (cd) for cloning repo into it
WORKDIR $GOPATH/src/github.com/bitfinexcom/

# Clone repo (into workdir)
RUN git clone --single-branch --branch feature-start-gw-shell https://github.com/valmac/bfxfixgw.git

# Set workdir (cd) to project folder
WORKDIR $GOPATH/src/github.com/bitfinexcom/bfxfixgw/

# Fetch dependencies.
RUN go get -d -v

# Optimized build the binary 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/bfxfixgw

# Create dir for settings and logs 
RUN mkdir /fix_settings

# Pass rights for appuser
RUN chown -R 1000:appuser /fix_settings

# Set library env
ENV FIX_SETTINGS_DIRECTORY=/fix_settings

############################
# STEP 2 build a small image
############################
FROM scratch

# Copy appuser credentials
COPY --from=builder /etc/passwd /etc/passwd

# Copy our static executable app
COPY --from=builder /go/bin/bfxfixgw /go/bin/bfxfixgw

# Declate the volume for settings and logs
VOLUME ["/fix_settings"]

# Set workdir (cd) to VOLUME, for logging
WORKDIR /fix_settings

# Activate application user 
USER appuser

# Run the 'bfxfixgw' application
ENTRYPOINT ["/go/bin/bfxfixgw","-orders","-ordcfg", "/orders_fix42.cfg", "-rest", "https://api.bitfinex.com/v2/","-ws", "wss://api.bitfinex.com/ws/2"]