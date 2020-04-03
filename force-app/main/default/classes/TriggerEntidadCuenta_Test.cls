/**
	* @author calvarez@ctconsulting.com.mx
	* @date 06/04/2018
	* @description Clase de prueba para TriggerEntidadCuenta
	* @group EstructuraCuentas
*/

@isTest
private class TriggerEntidadCuenta_Test {

	@isTest
	static void testEntidadCuenta() {

		Id recordTypeFisica = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();

		Account acc = new Account( Name = 'testAccount', NumeroEmpleados__c = '1-25', NumeroVehiculos__c  = '1-5' );
        insert acc;

		EntidadLegal__c el = new EntidadLegal__c( Name = 'CUPU800825569', RecordTypeId = recordTypeFisica );
		insert el;

		el.Estatus__c = 'Completa';
		update el;

		EntidadCuenta__c ec = new EntidadCuenta__c( Cuenta__c = acc.Id, EntidadLegal__c = el.Id );
		insert ec;

		ec.Cuenta__c = null;
		try { 
			update ec;
		} catch( Exception e ){} 

		ec.Cuenta__c = acc.Id;
		ec.EntidadLegal__c = null;
		try { 
			update ec;
		} catch( Exception e ){} 

		EntidadCuenta__c ec2 = new EntidadCuenta__c( Cuenta__c = acc.Id, EntidadLegal__c = el.Id );
		try { 
			insert ec2;
		} catch( Exception e ){} 


		try {
			delete el;
		} catch( Exception e ) {}

	}
}