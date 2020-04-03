@isTest 
private class PantallaIntermediaContratoControllerTest {
	@isTest 
    static void myUnitTest(){
        

            Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', AccountId=cta.Id );
            insert opp;
        	Contact contacto = new Contact(LastName='ksdas',AccountId=cta.Id, Email = 'test@mail.com');
        	insert contacto;
		
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', opp.Id);
			System.currentPageReference().getParameters().put('indice', '1');
            apexPages.StandardController std = new apexPages.StandardController(opp);
            PantallaIntermediaContratoController convertir = new PantallaIntermediaContratoController(std);
        	//convertir.guardar();
    }
    
	@isTest 
    static void myUnitTestDos(){
        

            Account cta = new Account(Name='cuenta',RegistroPatronal__c='dsadsa',SucursalFacturacion__c='dsa', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test', CloseDate=date.today(),Familia__c = 'familiaTest', AccountId=cta.Id );
            insert opp;
        	Contact contacto = new Contact( LastName='ksdas',AccountId=cta.Id, Email = 'test@mail.com');
        	insert contacto; 
		 
            opp.Facturacion1__c=contacto.Id;
            opp.Facturacion2__c=contacto.Id;
            opp.Pedidos__c=contacto.Id;
            opp.RecursosHumanos__c=contacto.Id;
        	upsert opp;
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', opp.Id);
			System.currentPageReference().getParameters().put('indice', '1');
            apexPages.StandardController std = new apexPages.StandardController(opp);
            PantallaIntermediaContratoController convertir = new PantallaIntermediaContratoController(std);
        	//convertir.guardar();
    }
}