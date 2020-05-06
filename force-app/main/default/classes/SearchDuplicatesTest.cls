@istest
private  class SearchDuplicatesTest {
	@istest
    static void PruebaBusqueda(){
        Test.startTest();
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Ventas' LIMIT 1];
        User u= new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;
        System.runAs(u){
            Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25',CodigoClienteAS400__c='3');
            insert acc;
            EntidadLegal__c el=new EntidadLegal__c(RFC__c='HIJD93061278A',Name='HIJD93061278A',Estatus__c='Completa');
            insert el;
            EntidadCuenta__c ec=new EntidadCuenta__c(Cuenta__c=Acc.Id,Name='HIJD93061278A',EntidadLegal__c=el.Id);
            insert ec;
            Opportunity opp=new Opportunity(Familia__c='Combustible',Name='BP',FechaUltimaActividad__c=Date.today(),AccountId=acc.Id,Entidad_Cuenta__c=ec.Id,CloseDate=Date.today().addMonths(1),StageName='Cotización');
            insert opp;
            Task notif = new Task();
            notif.isAlert__c=true;
            notif.WhatId=opp.Id;
            notif.Subject='Test';
            notif.Description='Test';
            notif.OwnerId=UserInfo.getUserId();
            insert notif;
        }
        SearchDuplicates.GetEntidadLegal('','','');
        SearchDuplicates.GetEntidadLegal('1','2','s');
        SearchDuplicates.GetAccount('2','3');
        SearchDuplicates.GetAccount('','');
        SearchDuplicates.GetLead('');
        SearchDuplicates.GetContact('');
        SearchDuplicates.GetOpportunity(''); 
        SearchDuplicates.GetLead('1');
        SearchDuplicates.GetContact('2');
        SearchDuplicates.GetOpportunity('3'); 
        Test.stopTest();   
    }
}