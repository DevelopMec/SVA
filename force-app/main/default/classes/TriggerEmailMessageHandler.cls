public without sharing  class TriggerEmailMessageHandler extends triggerHandler{
    private List<EmailMessage> newList;
    private Map<Id, EmailMessage> oldMap;
    private Map<Id, EmailMessage> newMap;
    
    public TriggerEmailMessageHandler() {
        System.debug('::TriggerEmailMessageHandler::'+limits.getQueries());
        this.newList = (List<EmailMessage>) trigger.new;
        this.oldMap = (Map<Id, EmailMessage>) trigger.oldMap;
        this.newMap = (Map<Id, EmailMessage>) trigger.newMap;
    }
    public override void beforeUpdate(){
        
    }
    public override void beforeInsert(){
        
    }
    
    public override void afterUpdate(){
        
    }
}