trigger TriggerContratoFilial on ContratoFilial__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new TriggerContratoFilialHandler().run();
}