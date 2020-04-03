trigger TriggerAnexo on Anexo__c (before insert, before update) {
    TriggerHandlerAnexo.metodo(Trigger.new);
}