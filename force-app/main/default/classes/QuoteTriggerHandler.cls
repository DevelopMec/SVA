public without sharing class QuoteTriggerHandler extends TriggerHandler {
    
    private Map<Id, Quote> newMap;
    private Map<Id, Quote> oldMap;
    private List<Quote> newList;
    private List<Quote> oldList;
    
    public QuoteTriggerHandler() {
        this.newMap = (Map<Id, Quote>) trigger.newMap;
        this.oldMap = (Map<Id, Quote>) trigger.oldMap;
        this.newList = (List<Quote>) trigger.new;
        this.oldList = (List<Quote>) trigger.old;
    }
    
    public override void afterUpdate() {
        //Check if applicable for an approval process
        QuoteMultilevelApprovalProcess.makeCommentsRequired(newList, oldMap);
        QuoteMultilevelApprovalProcess.sendNextApprovalProcess(newList, oldMap);
        sendToSIGLO(newList);
    }

    //Valida si existe algun cambio en los campos que se envian a SIGLO
	 public void sendToSIGLO(List<Quote> newList){
        System.debug('-------SendToSIGLO---------');
        Set<Id> quoteIds = new Set<Id>();
        for(Quote newQuote : newMap.values()){
            Quote oldQuote = oldMap.get(newQuote.Id);
            if(newQuote.OperationsInDollars__c != oldQuote.OperationsInDollars__c || 
                newQuote.TransactionsEstimatedNumber__c != oldQuote.TransactionsEstimatedNumber__c ||
                newQuote.OpportunityId != oldQuote.OpportunityId){
                    quoteIds.add(newQuote.Id);
               }
        }

        if(!quoteIds.isEmpty()){
            List<Contrato2__c> contratoOpp = [SELECT PartidaPresupuesto__r.Quote.OperationsInDollars__c, PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c, 
                                                    PartidaPresupuesto__r.Quote.TotalPrice, PartidaPresupuesto__r.Quote.OpportunityId, PartidaPresupuesto__r.QuoteId
                                                    FROM Contrato2__c 
                                                    WHERE PartidaPresupuesto__r.QuoteId IN: quoteIds 
                                                    AND PartidaPresupuesto__r.Quote.OpportunityId != null];
            List<Id> oppIds = new List<Id>();
            for(Contrato2__c contrato : contratoOpp){oppIds.add(contrato.PartidaPresupuesto__r.Quote.OpportunityId);}

            List<Opportunity> oppList = [SELECT Id, SendToSIGLO__c FROM Opportunity WHERE Id IN: oppIds];
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(oppList);
            List<Opportunity> oppListUPD = new List<Opportunity>();

            for(Contrato2__c contrato : contratoOpp){
                Opportunity oppToUpdate = new Opportunity(Id=contrato.PartidaPresupuesto__r.Quote.OpportunityId, SendToSIGLO__c = true);
                oppListUPD.add(oppToUpdate);
            }

            if(!oppListUPD.isEmpty()){
                update oppListUPD;
            }
        }

    }
    
}