/**
	* Author 		Desarrollo Freeway
	* Date 			30/10/2019
					Clases que cubre:
						-SendMailForClosedCases
**/

@isTest
private class SendMailForClosedCases_Test {
    
	@testSetup static void setup() {
        // Create test data          
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Test Contact';
        con.LastName = 'Test';
        con.Email = 'test@test.com'; 
        insert con;
        
        EntidadLegal__c entidadLegal = new EntidadLegal__c();
		entidadLegal.Name = 'HIJD93061278A';
		entidadLegal.Cuenta__c = acc.Id;
		insert entidadLegal;
        
        EntidadCuenta__c entidadC = [Select Id From EntidadCuenta__c Where Cuenta__c =: acc.Id AND EntidadLegal__c =: entidadLegal.Id Limit 1];
        
        Product2 product = new Product2();
        product.Name = 'Producto Test';
        product.Family = 'Ticket Restaurante';
        product.ProductCode = '1';
        insert product;
        
        ContratoFilial__c contratoFilial = new ContratoFilial__c();
        contratoFilial.Name = '11-22-33333-444';
        contratoFilial.Entidad_Cuenta__c = entidadC.Id;
        contratoFilial.Producto__c = product.Id;
        insert contratoFilial; 
    }
    
    @isTest static void testSendMailForClosedCases() {
        Account acc = [Select Id From Account Where Name = 'Test Account' Limit 1];
        Contact con = [Select Id From Contact Where FirstName = 'Test Contact' Limit 1];
        ContratoFilial__c cf = [Select Id From ContratoFilial__c Where Name = '11-22-33333-444' Limit 1];
        
        Case caso = new Case();
        caso.Type = 'Solicitud';
        caso.Origin = 'Web';
        caso.Status = 'Abierto';
        caso.AccountId = acc.Id;
        caso.ContactId = con.Id;
        caso.Contrato_Filial__c = cf.Id;
        insert caso;
        caso.Status = 'Concluido';
        update caso;
        //Delete al email message related to the case before starting the test.
        List<EmailMessage> messagesToDelete = new List<EmailMessage>([Select Subject,EmailTemplateId From EmailMessage Where ParentId =: caso.Id]);
        if(!messagesToDelete.isEmpty()){
            delete messagesToDelete;
        }
        Test.startTest();
        List<Case> closedCases = new List<Case>();
        closedCases.add(caso);
        SendMailForClosedCases.sendMailMessage(closedCases);
        Test.stopTest();      
        EmailMessage message = [Select Subject From EmailMessage Where ParentId =: caso.Id];
        System.assert(message.Subject != null, 'The method sends the email.');
    }
    
    @isTest static void testGetTemplatesMap() {
        Test.startTest();
    	Map<String,Id> templatesMap = SendMailForClosedCases.getTemplatesMap();
        Test.stopTest();
        System.assert(!templatesMap.isEmpty(), 'The method returns the email templates map.');
    }
    
}