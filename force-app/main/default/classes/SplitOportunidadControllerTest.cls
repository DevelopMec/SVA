@isTest
private class SplitOportunidadControllerTest {
	@isTest 
    static void testStandardUse() {
    	

            Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp;
        
            Opportunity opp2 = new Opportunity(Name = 'test2', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp2;
            SplitOportunidad__c oportunidadMonto = new SplitOportunidad__c(oportunidad__c = opp.Id);
        	oportunidadMonto.Fecha__c=Date.today();
        	oportunidadMonto.Monto__c=0.0;
        	
            
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', opp.Id);
			System.currentPageReference().getParameters().put('indice', '1');
            apexPages.StandardController std = new apexPages.StandardController(opp);
            SplitOportunidadController convertir = new SplitOportunidadController(std);
            Double total = convertir.total;
            convertir.agregar();
            convertir.guardar();
        
            
    }
    @isTest 
    static void testStandardUse2() {
    	

            Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp;
        
            SplitOportunidad__c oportunidadMonto = new SplitOportunidad__c(oportunidad__c = opp.Id);
        
        	oportunidadMonto.Fecha__c=Date.today();
        	oportunidadMonto.Monto__c=0.0;
        	insert oportunidadMonto;
            
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', opp.Id);
			System.currentPageReference().getParameters().put('indice', '0');
            apexPages.StandardController std = new apexPages.StandardController(opp);
            SplitOportunidadController convertir = new SplitOportunidadController(std);
            Double total = convertir.total;
            convertir.agregar();
            convertir.guardar();
        	convertir.eliminar();
        
            
    }
    
}