trigger TriggerHistorialVE on HistorialVE__c (before insert) {
	new TriggerHistorialHandler().run();
}