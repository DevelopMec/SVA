@isTest
private class GenerarContratoControllerTest {
    @isTest 
    static void myUnitTest(){
        
            Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp;
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', opp.Id);
            apexPages.StandardController std = new apexPages.StandardController(opp);
            GenerarContratoController convertir = new GenerarContratoController(std);
    }
    @isTest 
    static void dos(){
        
            Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', opp.Id);
            apexPages.StandardController std = new apexPages.StandardController(opp);
            GenerarContratoController convertir = new GenerarContratoController(std);
    }

}