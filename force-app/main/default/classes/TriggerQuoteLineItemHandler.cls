public without sharing class TriggerQuoteLineItemHandler extends TriggerHandler {
    
    private Map<Id, QuoteLineItem> newMap;
    private Map<Id, QuoteLineItem> oldMap;
    private List<QuoteLineItem> newList;
    private List<QuoteLineItem> oldList;
    
    public TriggerQuoteLineItemHandler() {
        this.newMap = (Map<Id, QuoteLineItem>) trigger.newMap;
        this.oldMap = (Map<Id, QuoteLineItem>) trigger.oldMap;
        this.newList = (List<QuoteLineItem>) trigger.new;
        this.oldList = (List<QuoteLineItem>) trigger.old;
    }
    
    
    
    public override void beforeUpdate() {
        System.debug('before: ' + this.newList);
    }
    public override void afterUpdate() {
        System.debug('after: ' + this.newList);
        actualizaOportunidad(newMap, newList);
    }
    
    public override void afterInsert() {
        actualizaOportunidad(newMap, newList);
    }
    
    public override void beforeDelete() {
        validaBorradoProductoCotizado(oldList);
    }   
    
    public void actualizaOportunidad(Map<Id, QuoteLineItem> qlim, List<QuoteLineItem> qlil) {
        Map<Id, Quote> quotesM = new Map<Id, Quote>();
        for(QuoteLineItem qli: qlil) {
            if(!quotesM.containsKey(qli.QuoteId) && qli.Escalonamiento__c == null) {
                quotesM.put(qli.QuoteId, new Quote(Id = qli.QuoteId));
            }
        }
        if(quotesM != null && quotesM.size() > 0) {
            Map<Id, Opportunity> opps = new Map<Id, Opportunity>();
            List<Quote> quotes = [SELECT Id, IsSyncing, OpportunityId,Opportunity.StageName FROM Quote WHERE Id IN: quotesM.keySet()];
            quotesM = new Map<Id, Quote>();
            for(Quote q: quotes) {
                if(q.IsSyncing) {quotesM.put(q.Id, q);}
                if(!opps.containsKey(q.OpportunityId)&&q.Opportunity.StageName=='Cotización') {
                    opps.put(q.OpportunityId, new Opportunity(Id = q.OpportunityId, CantidadTarjetas__c = 0));
                }
            }
            List<QuoteLineItem> setQli = new List<QuoteLineItem>();//DYAMPI
            List<QuoteLineItem> quotesl = [SELECT Id, CantidadTarjetas__c,Quote.Opportunity.CantidadTarjetas__c, Quote.OpportunityId,Escalonamiento__r.Id,Escalonamiento__r.CantidadTarjetas__c,Escalonamiento__r.Etapa__c, Escalonamiento__c, Etapa__c FROM QuoteLineItem WHERE QuoteId IN: quotesM.keySet()];
            Map<Id, Integer> counters = new Map<Id, Integer>();
            for(QuoteLineItem qli: quotesl) {
                if(qli.Escalonamiento__c == null && opps.containsKey(qli.Quote.OpportunityId) && qli.CantidadTarjetas__c != null && qli.Etapa__c != 'Perdida') {
                    opps.get(qli.Quote.OpportunityId).CantidadTarjetas__c += qli.CantidadTarjetas__c;
                }
                if(qli.Escalonamiento__c != null) {setQli.add(qli);}
            }
            if(opps != null && opps.values().size() > 0) {Database.update(opps.values());}
            if(setQli != null && setQli.size() > 0) {
                List<QuoteLineItem> qlis = setQli;
                for(QuoteLineItem qli: qlis) {qli.CantidadTarjetas__c = qli.Escalonamiento__r.CantidadTarjetas__c;}
                if(qlis != null && qlis.size() > 0) {Database.update(qlis);}
            }
        }
    }
    
    public void validaBorradoProductoCotizado(List<QuoteLineItem> qlis) {
        if(qlis != null) {
            for(QuoteLineItem qli: qlis) {
                if(qli.Etapa__c != null && qli.Etapa__c != 'Cotización') {qli.addError('No se puede eliminar, etapa es diferente a Cotización');}
            }
        }
    }
}