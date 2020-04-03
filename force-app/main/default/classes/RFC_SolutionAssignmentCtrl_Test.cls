/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @creation	19/03/2020 	Coverage to RFC_SolutionAssignmentCtrl_Test [Freeway req. 2900].
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class RFC_SolutionAssignmentCtrl_Test {
    
    @testSetup
    public static void setup(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        List<User> testUsers = new List<User>();
        User u = new User(LastName = 'last', Email = 'usertestadmin@amamama.com', Username = 'usertestadmin@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        User u2 = new User(LastName = 'last2', Email = 'usertestadmin2@amamama.com', Username = 'usertestadmin2@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias2', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        testUsers.add(u);
        testUsers.add(u2);
        insert testUsers;
        System.runAs(u){
            List<sObject> objs = new List<sObject>();
            
            Pricebook2 pr = new Pricebook2(Name = 'Edenred', isActive = true);        
            
            Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            
            EntidadLegal__c el = new EntidadLegal__c(RFC__c = 'MRDE294817A7A', Name = 'MRDE294817A7A');
            
            Product2 prod = new Product2(Family = 'Vestimenta', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta', IsActive = true);
            
            objs.add(pr);
            objs.add(acc);
            objs.add(el);
            objs.add(prod);
            insert objs;
            
            Id pricebookId = pr.Id;
            EntidadCuenta__c ec = new EntidadCuenta__c(Cuenta__c = acc.Id, Name = 'MRDE294817A7A', EntidadLegal__c = el.Id);
            insert ec;
            ContratoFilial__c contrato = new ContratoFilial__c(Producto__c = prod.Id, CodigoAS400__c = '123', Name = '123' , Entidad_Cuenta__c = ec.Id, IsPrime__c = true);
            insert contrato ;
        }
    }
    
    @isTest
    static void getUserPermissionsTest(){
        User testUser = [SELECT Id FROM User WHERE Alias = 'alias'];
        System.runAs(testUser){         
            String errorMessage = '';
            Test.startTest();
            	Boolean userHasPermission = RFC_SolutionAssignmentCtrl.getUserPermissions();
            Test.stopTest();
            System.assertEquals(true, userHasPermission,'A system administrator has permission to edit the RFC-Solution assignment');
        }
    }
    
    @isTest
    static void getContratosFilialesTest(){
        User testUser = [SELECT Id FROM User WHERE Alias = 'alias'];
        Account acc = [SELECT Id FROM Account];
        System.runAs(testUser){         
            Test.startTest();
            	List<ContratoFilial__c> contratosList = RFC_SolutionAssignmentCtrl.getContratosFiliales(acc.Id);
            Test.stopTest();
            System.assert(!contratosList.isEmpty(),'The methos retuns the "contratos filiales" to be used in the RFC-Solution assignment list.');
        }
    }
    
    @isTest
    static void updateOwnersTest(){
        User testUser = [SELECT Id FROM User WHERE Alias = 'alias'];

        List<ContratoFilial__c> contratosToUpdate = [SELECT Entidad_Cuenta__r.Name, Producto__r.Family, OwnerId, Owner.Name, ModifyOwner__c
                                                    FROM ContratoFilial__c];
        Account acc = [SELECT Id FROM Account];
        System.runAs(testUser){  
            String StringError = null;
            Test.startTest();
            try {
                RFC_SolutionAssignmentCtrl.updateOwners(acc.Id, contratosToUpdate);
            } catch (Exception e) {
                StringError = e.getMessage();
            }
            Test.stopTest();
            System.assertEquals(null, StringError, 'The method update the contrato filial without errors.');
        }
    }

}