package cmd

import (
	"fmt"
	"log"

	"github.com/quickfixgo/enum"
	"github.com/quickfixgo/field"
	fix "github.com/quickfixgo/quickfix"

	mdr "github.com/quickfixgo/fix42/marketdatarequest"
	//mdir "github.com/quickfixgo/fix42/marketdataincrementalrefresh"
	"github.com/quickfixgo/tag"
)

func newMdRequest(reqID, symbol string, depth int) *mdr.MarketDataRequest {
	mdreq := mdr.New(field.NewMDReqID(reqID), field.NewSubscriptionRequestType(enum.SubscriptionRequestType_SNAPSHOT_PLUS_UPDATES), field.NewMarketDepth(depth))
	nrsg := mdr.NewNoRelatedSymRepeatingGroup()
	nrs := nrsg.Add()
	nrs.Set(field.NewSymbol(symbol))
	mdreq.SetNoRelatedSym(nrsg)
	return &mdreq
}

func buildFixMdRequests(symbols []string) []fix.Messagable {
	reqs := make([]fix.Messagable, 0, len(symbols))
	for _, sym := range symbols {
		reqID := fmt.Sprintf("req-%s", sym)
		req := newMdRequest(reqID, sym, 1)
		reqs = append(reqs, req)
	}
	return reqs
}

type MarketData struct {
}

func (m *MarketData) Execute(keyboard <-chan string, publisher FIXPublisher) {
	log.Print("-> Market Data Request")
	log.Print("enter symbol: ")
	reqs := buildFixMdRequests([]string{<-keyboard})
	for _, req := range reqs {
		publisher.SendFIX(req)
	}
}

func (m *MarketData) Handle(msg *fix.Message) {
	msgtype, _ := msg.Header.GetString(tag.MsgType)
	if msgtype == "X" || msgtype == "W" {
		log.Printf("[MARKETDATA] %s", msg.String())
	}
}
