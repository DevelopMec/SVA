trigger BonificacionEscalonamiento on BonificacionEscalonamiento__c (before delete, before insert, before update,after delete, after insert, after update) {
    new TriggerBonificacionEscalonamientoHandler().run();
}