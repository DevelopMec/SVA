public with sharing class LeadStatusLogTriggerHandler extends TriggerHandler{
    private Map<Id, Lead_status_log__c> newMap;
    private Map<Id, Lead_status_log__c> oldMap;
    private List<Lead_status_log__c> newList;
    private List<Lead_status_log__c> oldList;

    public LeadStatusLogTriggerHandler() {
        this.newMap = (Map<Id, Lead_status_log__c>) trigger.newMap;
        this.oldMap = (Map<Id, Lead_status_log__c>) trigger.oldMap;
        this.newList = (List<Lead_status_log__c>) trigger.new;
        this.oldList = (List<Lead_status_log__c>) trigger.old;
    }
    
    Set<Id> pIds = new Set<Id>();
  
    public override void afterInsert(){
        for(Lead_status_log__c bep : this.newList){
            pIds.add(bep.Lead__c);
        }
        List<Lead> ls = [Select Id from Lead where Id in: pIds and isConverted = false];
        if(!ls.isEmpty()){
            List<AggregateResult> totales = [
                Select Lead__c, Max(Lead__r.Name), Max(Start__c) maxInicio, Min(Start__c) minInicio,
                       Max(End__c) maxFin, Min(End__c) minFin
                  From Lead_status_log__c
                 where Lead__c in: pIds
                 group by Lead__c
            ];
            Map<Id, AggregateResult> mars = new Map<Id, AggregateResult>();
            for(AggregateResult ar : totales){
                mars.put((Id)('' + ar.get('Lead__c')), ar);
            }
            
            for(Lead l : ls){
                if(mars.containsKey(l.Id)){
                    AggregateResult ar = mars.get(l.Id);
                    if(ar.get('maxInicio')!=null) l.MaxStart__c = (Datetime)ar.get('maxInicio');
                    else l.MaxStart__c = null;
                    if(ar.get('minInicio')!=null) l.MinStart__c = (Datetime)ar.get('minInicio');
                    else l.MinStart__c = null;
                    if(ar.get('maxFin')!=null) l.MaxEnd__c = (Datetime)ar.get('maxFin');
                    else l.MaxEnd__c = null;
                    if(ar.get('minFin')!=null) l.MinEnd__c = (Datetime)ar.get('minFin');
                    else l.MinEnd__c = null;
                }
            }
            update ls;
        }
    }
    
    public override void afterUpdate(){
        for(Lead_status_log__c bep : this.newList){
            pIds.add(bep.Lead__c);
        }
        List<Lead> ls = [Select Id from Lead where Id in: pIds and isConverted = false];
        if(!ls.isEmpty()){
            List<AggregateResult> totales = [
                Select Lead__c, Max(Lead__r.Name), Max(Start__c) maxInicio, Min(Start__c) minInicio,
                       Max(End__c) maxFin, Min(End__c) minFin
                  From Lead_status_log__c
                 where Lead__c in: pIds
                 group by Lead__c
            ];
            Map<Id, AggregateResult> mars = new Map<Id, AggregateResult>();
            for(AggregateResult ar : totales){
                mars.put((Id)('' + ar.get('Lead__c')), ar);
            }
            
            for(Lead l : ls){
                if(mars.containsKey(l.Id)){
                    AggregateResult ar = mars.get(l.Id);
                    if(ar.get('maxInicio')!=null) l.MaxStart__c = (Datetime)ar.get('maxInicio');
                    else l.MaxStart__c = null;
                    if(ar.get('minInicio')!=null) l.MinStart__c = (Datetime)ar.get('minInicio');
                    else l.MinStart__c = null;
                    if(ar.get('maxFin')!=null) l.MaxEnd__c = (Datetime)ar.get('maxFin');
                    else l.MaxEnd__c = null;
                    if(ar.get('minFin')!=null) l.MinEnd__c = (Datetime)ar.get('minFin');
                    else l.MinEnd__c = null;
                }
            }
            update ls;
        }
    }
}