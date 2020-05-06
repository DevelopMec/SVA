/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @creation	04/03/2020	Coverage to Batch_UpdateAccountSolutions class. 	
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class Batch_UpdateAccountSolutionsTest {
    
    @testSetup static void setup() {
		List<Account> accountList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'ABCTest';
        accountList.add(acc);

        for (Integer i = 0; i < 199; i++) {
        	Account acco = new Account();
        	acco.Name = 'ABCTest'+i;   
            accountList.add(acco);
        }
        insert accountList;
        
        EntidadLegal__c entidadLegal = new EntidadLegal__c();
        entidadLegal.Name = 'HIJD93061278A';
        entidadLegal.Cuenta__c = acc.Id;
        insert entidadLegal;
        
        EntidadCuenta__c ec = [SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: acc.Id AND EntidadLegal__c =: entidadLegal.Id limit 1];
        
        Product2 prod = new Product2();
        prod.Name = 'Producto Test';
        prod.Family = 'Vestimenta';
        prod.ProductCode = '1';
        insert prod;
        
        ContratoFilial__c contratoFilial = new ContratoFilial__c();
        contratoFilial.Name = '11-22-33333-444';
        contratoFilial.Entidad_Cuenta__c = ec.Id;
        contratoFilial.Producto__c = prod.Id;
        insert contratoFilial;
    }
   
    static testMethod void testBatch(){
        Account acc = [SELECT Id, SolutionsText__c FROM Account WHERE Name = 'ABCTest'];
        acc.SolutionsText__c = '';
        update acc;
        Test.startTest();
        	Batch_UpdateAccountSolutions myBatchObject = new Batch_UpdateAccountSolutions(); 
        	Id batchId = Database.executeBatch(myBatchObject, 200);
        Test.stopTest();
        acc = [SELECT Id, SolutionsText__c FROM Account WHERE Name = 'ABCTest'];
		System.assertEquals('Vestimenta', acc.SolutionsText__c, 'The account has the correct solution.');
    }
    
}