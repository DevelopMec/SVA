@isTest
private class ConvertirControllerTest {
	@isTest 
    static void myUnitTest(){
        try{
            lead prospecto = new lead( ProductoInteres__c = 'ProductoTest', LastName = 'lastNameTest', Company = 'TestCompany', Puesto__c='CEO', LeadSource='Web', Status='Calificado');
            insert prospecto;
            Necesidad__c nec = new Necesidad__c(Familia__c = 'familiaTest',  lead__c = prospecto.id);
            insert nec;
            Account cta = new Account(Name='cuenta');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp;
            
            Test.startTest();
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', prospecto.Id);
            //Database.LeadConvert lc = new database.LeadConvert();
            //lc.setLeadId(prospecto.Id);
            
            apexPages.StandardController std = new apexPages.StandardController(prospecto);
            ConvertirController convertir = new ConvertirController(std);
            //convertir.idprospecto = ApexPages.currentPage().getParameters().put('id',prospecto.id);
            //convertir.campoProducto = 'test';
            //convertir.guardo = true;
            //convertir.getProductosPerfilados();
            convertir.convierte();
            
            Test.stopTest();
            
        }catch(Exception e){
            e.getMessage();
        }
	}
}