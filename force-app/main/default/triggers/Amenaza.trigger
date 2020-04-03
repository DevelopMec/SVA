trigger Amenaza on Amenaza__c (before insert, before update) {
	new TriggerAmenazaHandler().run();
}