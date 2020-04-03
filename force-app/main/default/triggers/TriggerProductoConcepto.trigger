trigger TriggerProductoConcepto on ProductoConcepto__c (after insert,after update) {
    new TriggerHandlerProductoConcepto().run();
}