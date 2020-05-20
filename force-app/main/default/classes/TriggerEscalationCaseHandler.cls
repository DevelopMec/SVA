/**********************************************************************************
Developed by: Freeway Consulting
Author: Hector Diaz
Project:  "Edenred" 
Description: .
---------------------------------------------------------------------------------
Version       Date         Author                   Description
------ ---------- ---------------------------------------------------------------
1.0       11-Mayo-2020      Hector Diaz               Initial versionn
***************************************************************************************/
public without sharing class TriggerEscalationCaseHandler extends TriggerHandler {
    private Map<Id, escalation_History__c> newMap;
    private Map<Id, escalation_History__c> oldMap;
    private List<escalation_History__c> newList;
    private List<escalation_History__c> oldList;
    
    public TriggerEscalationCaseHandler() {       
        this.newMap = (Map<Id, escalation_History__c>) Trigger.newMap;
        this.oldMap = (Map<Id, escalation_History__c>) trigger.oldMap;
        this.newList = (List<escalation_History__c>) trigger.new;
        this.oldList = (List<escalation_History__c>) trigger.old;
    }
    
     public override void beforeInsert() {
        String IdTicket = '';
        System.debug('*** HMDH beforeInsert***');
        System.debug(newList);
        
        for(escalation_History__c objEscalationHistory : newList){
            IdTicket = objEscalationHistory.ticket__c;
        }
        System.debug('TICKET ID : ' + IdTicket);

        for(escalation_History__c objEscalionExist : [SELECT id,name,createdDate,Resolution_time_holidays__c FROM escalation_History__c WHERE ticket__c =: IdTicket ORDER BY createdDate DESC limit 1]){
            objEscalionExist.Resolution_time_holidays__c = WorkDays.getWorkDays(objEscalionExist.createdDate, Datetime.now());
            update objEscalionExist;
            System.debug('***ULTIMO ACTUALIZADO ');
            System.debug(objEscalionExist);
        } 
       
 
            
        
    }
    
}