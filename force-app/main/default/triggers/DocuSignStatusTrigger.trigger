trigger DocuSignStatusTrigger on dsfs__DocuSign_Status__c (before insert,before Update) {
    new DocuSignStatusTriggerHandler().run();
}