@isTest
public class BuscadorBPfleet_CONT_TEST {
    
    @testSetup
    public static void setup(){
        Test.startTest();
        insert new GeneralCatalog__c(ApproverBPSmall__c=UserInfo.getUserId(),ApproverBPCorporate__c=UserInfo.getUserId());
        Test.stopTest();
    }
    
	@isTest
    public static void metodo1(){
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
        insert acc;
        EntidadLegal__c el=new EntidadLegal__c(RFC__c='AAHJ343534KG3',Name='AAHJ343534KG3');
        insert el;
        EntidadCuenta__c ec=new EntidadCuenta__c(Cuenta__c=Acc.Id,Name='AAHJ343534KG3',EntidadLegal__c=el.Id);
        insert ec;
        BuscadorBPfleet_CONT.getRecordTypeBP('Lead', 'BPfleet');
        BuscadorBPfleet_CONT.getDatosBuscar('AAHJ343534KG3', 'test');
        BuscadorBPfleet_CONT.crearColaboracion('AAHJ343534KG3');
    }
    @isTest
    public static void metodo2(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Ventas' LIMIT 1];
        User u= new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;
        System.runAs(u){
            Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert acc;
            EntidadLegal__c el=new EntidadLegal__c(RFC__c='AAHJ343534KG3',Name='AAHJ343534KG3',Estatus__c='Completa');
            insert el;
            EntidadCuenta__c ec=new EntidadCuenta__c(Cuenta__c=Acc.Id,Name='AAHJ343534KG3',EntidadLegal__c=el.Id);
            insert ec;
            Opportunity opp=new Opportunity(Familia__c='Combustible',Name='BP',AccountId=acc.Id,Entidad_Cuenta__c=ec.Id,CloseDate=Date.today().addMonths(1),StageName='Cotización');
            insert opp;
        }
        Profile profBP = [SELECT Id FROM Profile WHERE Name = 'BPfleet Sales' LIMIT 1];
        User uBP= new User(LastName = 'lastt', Email = 'puser0t00@amamama.com', Username = 'puser0t00@amamama.com' + System.currentTimeMillis(), CompanyName = 'TESTw', Title = 'titlee', Alias = 'aliasTes', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profBP.Id);
        insert uBP;
        System.runAs(uBP){
            BuscadorBPfleet_CONT.crearColaboracion('AAHJ343534KG3');
            BuscadorBPfleet_CONT.getStatus(new Set<String>{'AAHJ343538KG3'});
            BuscadorBPfleet_CONT.getStatus(new Set<String>{'AAHJ343534KG3'});
        }
    }
}