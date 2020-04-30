@isTest
public class EC_ListaAS400_Ctrl_TEST {

	@isTest
	static void listaAS400() {
		Account acc = new Account( Name = 'testAccount', NumeroEmpleados__c = '1-25', NumeroVehiculos__c  = '1' );
        insert acc;

		Id recordTypeFisica = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();
        EntidadLegal__c el = new EntidadLegal__c( Name = 'CUPU800825559', Nombre__c = 'EL Prueba', RecordTypeId = recordTypeFisica );
		insert el;

        EC_ListaAS400_Ctrl.listaAS400( acc.Id );
        EC_ListaAS400_Ctrl.listaAS400( null );
        EC_ListaAS400_Ctrl.listaAS400( el.Id );
        EC_ListaAS400_Ctrl.getURL();

	}
}