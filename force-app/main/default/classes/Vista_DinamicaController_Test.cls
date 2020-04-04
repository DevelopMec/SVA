/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @change	04/03/2020 	Modify records insertion in order to improve coverage and add testSetup method. Add method 
						updateAccountSolutions. 
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class Vista_DinamicaController_Test {
    
    @testSetup static void setup() {
        Account acc = new Account();
        acc.Name = 'ABCTest';
        insert acc;
        
        EntidadLegal__c entidadLegal = new EntidadLegal__c();
        entidadLegal.Name = 'ABCD112233XYZ';
        entidadLegal.Cuenta__c = acc.Id;
        insert entidadLegal;
        
        EntidadCuenta__c ec = [SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: acc.Id AND EntidadLegal__c =: entidadLegal.Id limit 1];
        
        Product2 prod = new Product2();
        prod.Name = 'Producto Test';
        prod.Family = 'Ticket Restaurante';
        prod.ProductCode = '1';
        insert prod;
        
        ContratoFilial__c contratoFilial = new ContratoFilial__c();
        contratoFilial.Name = '11-22-33333-444';
        contratoFilial.Entidad_Cuenta__c = ec.Id;
        contratoFilial.Producto__c = prod.Id;
        insert contratoFilial;
    }

    static testMethod void Vista(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'ABCTest'];
        Vista_DinamicaController.getentidades(acc.id);
        Vista_DinamicaController.getFamilia(acc.id, '');
        Vista_DinamicaController.getEjecutivos(acc.id);
    }
    
    //Coverage to updateAccountSolutions method.
    static testMethod void updateAccountSolutions(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'ABCTest'];
        List<EntidadCuenta__c> entidadadesList = [SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: acc.Id];
        Test.startTest();
        	Vista_DinamicaController.updateAccountSolutions(entidadadesList);
        Test.stopTest();
        acc = [SELECT Id, SolutionsText__c FROM Account WHERE Name = 'ABCTest'];
		System.assertEquals('Ticket Restaurante', acc.SolutionsText__c, 'The account has the correct solution.');
    }
    
}