trigger EDR_escalationHistory  on escalation_History__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new TriggerEscalationCaseHandler().run();
}