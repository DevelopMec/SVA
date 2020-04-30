trigger TriggerEstablishment on Establishment__c (before insert,after update,after insert,before update) {
    new TriggerEstablishmentHandler().run();
}