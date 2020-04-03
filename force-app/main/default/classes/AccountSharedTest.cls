@isTest
public class AccountSharedTest {
    @istest
    static void PruebaBusqueda(){
        Id idAccount;
        
        Account acc = new Account(Name='Test');
        insert acc;
        
        User usuario = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Ventas'].Id,
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        Database.SaveResult userId= Database.insert(usuario,false);
        
        AccountShare accShare = new AccountShare();
        accShare.AccountId = acc.Id;
        accShare.AccountAccessLevel = 'Edit';
        accShare.OpportunityAccessLevel = 'Read';
        accShare.CaseAccessLevel = 'Read';
        accShare.ContactAccessLevel = 'Read';
        accShare.UserOrGroupId=userId.getId();
        insert accShare;
        
        Task t = new Task();
        t.WhatId = acc.Id;
        t.isAlert__c = false;
        t.Status = 'No iniciada';
        t.Subject = 'Enviar información';
        t.ActivityDate = system.Today().addDays(5);
        insert t;
        
        t.Status = 'Concluida';
        update t;
        
        Task t2 = new Task();
        t2.WhatId = acc.Id;
        t2.isAlert__c = false;
        t2.Status = 'No iniciada';
        t2.Subject = 'Enviar información';
        t2.ActivityDate = system.Today().addDays(5);
        insert t2;
        
        t2.Status = 'Concluida';
        t2.TimestampCompletada__c = system.Now();
        update t2;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'prueba';
        opp.StageName = 'Planeada';
        opp.CloseDate = system.Today().addDays(30);
        insert opp;
        
        Amenaza__c am = new Amenaza__c();
        am.Cuenta__c = acc.Id;
        am.Type_of_threat__c = 'Downselling';
        insert am;
        
        acc.FechaUltimaActividad__c = null;
        update acc;
        
        Test.startTest();
        AccountShared.GetAccountShared(idAccount);
        AccountShared.GetAccountShared(acc.Id);
        AccountShared.InvokeAccountApproachLevel(new List<Id>{acc.Id});
        Test.stopTest();   
    }
}