/**
	* @author calvarez@ctconsulting.com.mx
	* @date 06/04/2018
	* @description Clase de prueba para TriggerEntidadLegal
	* @group EstructuraCuentas
*/

@isTest
private class TriggerEntidadLegal_Test {

	@isTest
	static void testEntidadLegal() {

		Id recordTypeFisica = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();
		Id recordTypeMoral = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Moral').getRecordTypeId();

		Account acc = new Account( Name = 'testAccount', NumeroEmpleados__c = '1-25', NumeroVehiculos__c  = '1' );
        insert acc;

		EntidadLegal__c el = new EntidadLegal__c( Name = 'CUPU800825559', Nombre__c = 'EL Prueba', RecordTypeId = recordTypeFisica );
		el.Calle__c = 'Venustiano Carranza';
        el.NumeroExterior__c = '22';
        el.CodigoPostal__c = '11520';
        el.Colonia__c = 'Buenavista';
        insert el;
        
        el.Calle__c = 'Benito Juarez';
        el.NumeroExterior__c = '33';
        el.CodigoPostal__c = '11530';
        el.Colonia__c = 'Obregon';

		EntidadLegal__c el2 = new EntidadLegal__c( Name = 'CUPU800825569', Nombre__c = 'EL Prueba 2', RecordTypeId = recordTypeMoral );
		try {
			insert el2;
		} catch( Exception e ) {}

		el.Estatus__c = 'Completa';
		el.Nombre__c = 'Nombre actualizado';
		update el;

		EntidadCuenta__c ec = new EntidadCuenta__c( Cuenta__c = acc.Id, EntidadLegal__c = el.Id );
		insert ec;

		try {
			delete el;
		} catch( Exception e ) {}

	}

}