/**
	* @author calvarez@ctconsulting.com.mx
	* @date 2018
	* @description Trigger de EntidadLegal
	* @group EstructuraCuentas
*/
trigger TriggerEntidadLegal on EntidadLegal__c ( after delete, after insert, after undelete, after update, before delete, before insert, before update ) {
	new TriggerEntidadLegalHandler().run();
}