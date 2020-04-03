@isTest
public class AsignacionAutomatica_Tst {    
    @isTest
    private static void testBooleanController()
    {
        Profile Implementador = [SELECT Id FROM Profile WHERE Name='Coordinador de implementación'];
        Profile ADV = [SELECT Id FROM Profile WHERE Name='Administración de Ventas'];       
        User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='Implementador@Implementador.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = Implementador.Id,TimeZoneSidKey='America/Los_Angeles', UserName='ADV@ADV.org');
        insert u1;
        User u2 = new User(Alias = 'standt2',Country='United Kingdom',Email='demo1@ADV.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = ADV.Id,TimeZoneSidKey='America/Los_Angeles', UserName='Implementador@Implementador.org');
        insert u2;
        
        // now insert your test data
        test.startTest();
        AsignacionAutomatica.getProfileN();
        AsignacionAutomatica.getUsers();
        System.runAs(u1){
            AsignacionAutomatica.getUsers();
        }
         System.runAs(u2){
            AsignacionAutomatica.getUsers();
        }
        test.stopTest();
    }
    
    


}