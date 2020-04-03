@isTest
public class LeadStatusLogTrigger_Test{
    @istest
    static void MethodOne(){
        Test.startTest();
        
        Lead p = new Lead();
        p.Status = 'No contactado';
        p.Company = 'ACME';
        p.FirstName = 'Prueba';
        p.LastName = 'Lead';
        p.Phone = '0987654321';
        p.Email = 'correo@servidor.com';
        p.LeadSource = 'Recomendado';
        p.RFC__c = 'sfesaw3sfd';
        p.NumEmpleados__c = '1-25';
        p.CategoriaSolucion__c = 'Combustible';
        insert p;
        
        Lead_status_log__c bep = new Lead_status_log__c();
        bep.Lead__c = p.Id;
        bep.Status__c = 'No contactado';
        bep.Start__c = System.Now();
        insert bep;
        
        bep.Start__c = System.Now();
        update bep;
        
        p.Status = 'Contactado';
        update p;
        
        Test.stopTest();
    }
}