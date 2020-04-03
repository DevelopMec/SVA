@isTest
private class TriggerEventHandlerTest {
    /*@testSetup
    public static void setup(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        User usuarioADV = new User(LastName = 'ADV', Email = 'adv@amamama.com', Username = 'adv@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Altas de Cliente', FiltroAsignacion_MSPL__c = 'Clientes OPAM;Clientes Edenred', UserRoleId = userRolesMap.get('Ejecutivo_de_Administracion_de_Ventas'), isActive = true);
        insert usuarioADV;
    }*/
    @isTest
    static void Method1(){
        List<user> u=[Select Id from User where IsActive=true  and Id!=:UserInfo.getUserId() limit 2];
        DateTime myDateTime = DateTime.now(); 
        
        Lead lea = new Lead(LastName = 'lastNameTest', Company = 'TestCompany', LeadSource='Cambaceo', Email = 'test@mail.com', NumEmpleados__c = '1-25',MobilePhone='0442325677654');
        insert lea;
        
        Test.startTest();
        
        Event myEvent = new Event( Acompanado_por__c=u[0].Id,StartDateTime = myDateTime, Subject = 'Capacitación', EndDateTime = myDateTime.addHours(1), ActivityDate = myDateTime.date(), WhoId = lea.Id); 
        insert myEvent;
        
        delete myEvent;
        
        Test.stopTest();
    }
    
    @isTest
    static void Method2(){
        List<user> u=[Select Id from User where IsActive=true  and Id!=:UserInfo.getUserId() limit 2];
        DateTime myDateTime = DateTime.now(); 
        
        Lead lea = new Lead(LastName = 'lastNameTest', Company = 'TestCompany', LeadSource='Cambaceo', Email = 'test@mail.com', NumEmpleados__c = '1-25',MobilePhone='0442325677654');
        insert lea;
        
        Test.startTest();
        
        Opportunity opp = TestDataFactory_TEST.createOpportunity();
        Event myEvent2 = new Event(Acompanado_por__c=u[0].Id, StartDateTime = myDateTime, Subject = 'Capacitación', EndDateTime = myDateTime.addHours(1), ActivityDate = myDateTime.date(), WhatId = opp.Id); 
        insert myEvent2;

        myEvent2.Subject='Implementación';
        update myEvent2;

        myEvent2.Acompanado_por__c=u[1].Id;
        update myEvent2;

        Test.stopTest();
    }
}