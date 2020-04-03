/**
	* @author calvarez@ctconsulting.com.mx
	* @date 02/04/2018
	* @description Trigger de ContactoEntidad__c
	* @group EstructuraCuentas
*/
trigger TriggerContactoEntidad on ContactoEntidad__c ( after delete, after insert, after undelete, after update, before delete, before insert, before update ) {
	new TriggerContactoEntidadHandler().run();
}