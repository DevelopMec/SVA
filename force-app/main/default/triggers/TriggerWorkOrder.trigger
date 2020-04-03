trigger TriggerWorkOrder on WorkOrder (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	new TriggerWorkOrderHandler().run();
}