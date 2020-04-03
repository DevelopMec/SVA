trigger TriggerContratoFilial on ContratoFilial__c (before insert) {
	new TriggerContratoFilialHandler().run();
}