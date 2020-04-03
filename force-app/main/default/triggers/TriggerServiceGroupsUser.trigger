trigger TriggerServiceGroupsUser on ServiceGroupsUser__c (before insert,before update,after insert,after update,before delete) {
	new TriggerServiceGroupsUserHandler().run();
}