@isTest
private class TriggerTaskHandlerTest {

	@isTest
	static void itShould() {
		// Given
		// When
		Test.startTest();

			Lead lea = new Lead( ProductoInteres__c = 'Combustible', LastName = 'lastNameTest', Company = 'TestCompany', Puesto__c='Coordinador', LeadSource='Web', Email = 'test@mail.com',phone='6787654765', NumEmpleados__c = '1-25');
			insert lea;

			Opportunity opp = TestDataFactory_TEST.createOpportunity();

			List<task> t = new List<task>{ new task( Subject = 'Enviar información', Status = 'New', Priority = 'Normal', WhoId = lea.Id) };
	        insert t;  

	        t[0].Subject = 'Enviar información';
	        update t;

	        delete t;

	        Task t2 = new task( Subject = 'Enviar información', Status = 'New', Priority = 'Normal', WhatId = opp.Id);
	        insert t2;

        Test.stopTest();
		// Then
	}
}