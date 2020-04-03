trigger LeadStatusLogTrigger on Lead_status_log__c (after insert, after update){
    new LeadStatusLogTriggerHandler().run();
}