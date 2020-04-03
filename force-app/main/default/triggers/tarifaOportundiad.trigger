trigger tarifaOportundiad on TarifaOportunidad__c (before delete, before insert, before update,after delete, after insert, after update) {
  new TriggerTarifaOportunidadHandler().run();
}