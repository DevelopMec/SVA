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
    }
    
}