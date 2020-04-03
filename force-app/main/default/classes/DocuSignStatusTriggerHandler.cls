public without sharing class DocuSignStatusTriggerHandler extends triggerHandler{
    private List<dsfs__DocuSign_Status__c> newList;
    private Map<Id, dsfs__DocuSign_Status__c> oldMap;
    private Map<Id, dsfs__DocuSign_Status__c> newMap;
    Map<String,String> mapStatus;
    public DocuSignStatusTriggerHandler(){
        mapStatus=new Map<String,String>{'Delivered'=>'Entregado','Completed'=>'Completado','Sent'=>'Enviado'};
        this.newList = (List<dsfs__DocuSign_Status__c>) trigger.new;
        this.oldMap = (Map<Id, dsfs__DocuSign_Status__c>) trigger.oldMap;
        this.newMap = (Map<Id, dsfs__DocuSign_Status__c>) trigger.newMap;
    }
    public override void beforeUpdate(){
        validarEstatus(this.newList,this.oldMap);
    }
    public override void beforeInsert(){
        validarEstatus(this.newList,null);
    }
    public void validarEstatus(List<dsfs__DocuSign_Status__c> listStatus,Map<Id, dsfs__DocuSign_Status__c> oldMapStatus){
        for(dsfs__DocuSign_Status__c le : listStatus){
            if((trigger.isInsert&&mapStatus.containsKey(le.dsfs__Envelope_Status__c))||(trigger.isUpdate&&mapStatus.containsKey(le.dsfs__Envelope_Status__c)&&mapStatus.get(le.dsfs__Envelope_Status__c)!=oldMapStatus.get(le.Id).dsfs__Envelope_Status__c)){
                le.dsfs__Envelope_Status__c=mapStatus.get(le.dsfs__Envelope_Status__c);
            }
        }
    }
}