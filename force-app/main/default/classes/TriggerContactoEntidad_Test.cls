/**
	* @author calvarez@ctconsulting.com.mx
	* @date 06/04/2018
	* @description Clase de prueba para TriggerEntidadCuenta
	* @group EstructuraCuentas
*/

@isTest
private class TriggerContactoEntidad_Test {

	@isTest
	static void testEntidadCuenta() {

		Id recordTypeFisica = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();

		Account acc = new Account( Name = 'testAccount', NumeroEmpleados__c = '1-25', NumeroVehiculos__c  = '1' );
        insert acc;

		Contact cont = new Contact(Curp__c='BADD110313HCMLNS09',LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');
		insert cont;

		Contact cont2 = new Contact(Curp__c='BADD110313HCMLNS09',LastName = 'Contacto prueba', Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');
		insert cont2;

		Contact cont3 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
		insert cont3;

		EntidadLegal__c el = new EntidadLegal__c( Name = 'CUPU800825569', RecordTypeId = recordTypeFisica );
		insert el;

		el.Estatus__c = 'Completa';
		update el;

		EntidadCuenta__c ec = new EntidadCuenta__c( Cuenta__c = acc.Id, EntidadLegal__c = el.Id );
		insert ec;

		ContactoEntidad__c ce = new ContactoEntidad__c( Contacto__c = cont.Id, Entidad_Cuenta__c = ec.Id );
		insert ce;

		ce.Contacto__c = null;
		try { 
			update ce;
		} catch( Exception e ){} 

		ContactoEntidad__c ce2 = new ContactoEntidad__c( Contacto__c = cont.Id );
		try { 
			insert ce2;
		} catch( Exception e ){} 

		ContactoEntidad__c ce3 = new ContactoEntidad__c( Contacto__c = cont.Id, Entidad_Cuenta__c = ec.Id );
		try { 
			insert ce3;
		} catch( Exception e ){} 

		ContactoEntidad__c ce4 = new ContactoEntidad__c( Contacto__c = cont2.Id, Entidad_Cuenta__c = ec.Id );
		try { 
			insert ce4;
		} catch( Exception e ){} 

		ContactoEntidad__c ce5 = new ContactoEntidad__c( Contacto__c = cont3.Id, Entidad_Cuenta__c = ec.Id );
		try { 
			insert ce5;
		} catch( Exception e ){}

	}
}