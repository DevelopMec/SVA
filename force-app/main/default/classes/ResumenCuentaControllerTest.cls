@isTest
private class ResumenCuentaControllerTest {
	@isTest 
    static void myUnitTest(){
    	
            //Database.LeadConvert lc = new database.LeadConvert();
            //lc.setLeadId(prospecto.Id);
            
            Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', cta.Id);
            apexPages.StandardController std = new apexPages.StandardController(cta);
            ResumenCuentaController convertir = new ResumenCuentaController(std);
    }
    
}