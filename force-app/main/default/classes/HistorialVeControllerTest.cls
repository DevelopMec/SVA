@isTest
private class HistorialVeControllerTest {
	@isTest 
    static void myUnitTest(){
        try{
            Account cuentaTest = new Account( name='Cuenta');
            insert cuentaTest;
            
            HistorialVE__c HVEC = new HistorialVE__C (cuenta__c = cuentaTest.id, 
                                                    Name='ABC', NombreCliente__c='Hola',VEMes06__c=200.00
                                                    );
            insert HVEC;
            System.debug(cuentaTest);
            Test.startTest();
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', cuentaTest.id);
            //Database.LeadConvert lc = new database.LeadConvert();
            //lc.setLeadId(prospecto.Id);
            
            apexPages.StandardController std = new apexPages.StandardController(cuentaTest);
            HistorialVeController HVE = new HistorialVeController(std);
            
            Test.stopTest();
            
        }catch(Exception e){
            e.getMessage();
        }
	}
}