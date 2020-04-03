/**
	* @author calvarez@ctconsulting.com.mx
	* @date 02/04/2018
	* @description Trigger de EntidadCuenta__c
	* @group EstructuraCuentas
*/
trigger TriggerEntidadCuenta on EntidadCuenta__c ( after delete, after insert, after undelete, after update, before delete, before insert, before update ) {
	new TriggerEntidadCuentaHandler().run();
}