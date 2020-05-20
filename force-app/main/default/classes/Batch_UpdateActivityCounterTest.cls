@isTest
private class Batch_UpdateActivityCounterTest {
    @isTest
    static void testTask() {
        Test.startTest();
        // WHO
        Lead lead = new Lead( 
            ProductoInteres__c = 'Combustible', 
            LastName = 'lastNameTest', 
            Company = 'TestCompany', 
            Puesto__c='Coordinador', 
            LeadSource='Web', 
            Email = 'test@mail.com',
            phone='6787654765', 
            NumEmpleados__c = '1-25'
        );
        insert lead;
        
        Account account = new Account(
            Name = 'Cuenta prueba', 
            NumberOfEmployees = 12, 
            NumeroEmpleados__c = '1-25'
        );
        insert account;
        
        Pricebook2 pr = new Pricebook2(
            Name='Edenred', 
            isActive=true
        );
        
        Id pricebookId2 = pr.Id;
        
        Opportunity opp = new Opportunity(
            AccountId = account.Id, 
            Name = 'Prueba', 
            Pricebook2Id = pricebookId2,
            StageName = 'Prospecting', 
            CloseDate = System.today().addDays(5),
            Solicitar_validaci_n_descuentos__c = false
        );
        insert opp;
        
        List<task> task = new List<task>{ 
            new task(
                Subject = 'Enviar información', 
                Status = 'Concluida', 
                Priority = 'Normal', 
                WhoId = lead.Id, ActivityType__c = null, EventNumber__c = null
            ),
                new task(
                    Subject = 'Enviar información', 
                    Status = 'Concluida', 
                    Priority = 'Normal', 
                    WhatId = account.Id, ActivityType__c = null, EventNumber__c = null
                ),
                new task(
                    Subject = 'Enviar información', 
                    Status = 'Concluida', 
                    Priority = 'Normal', 
                    WhatId = opp.Id, ActivityType__c = null, EventNumber__c = null
                )
                
                };
                    insert task;
        
        
        Id BatchActivityCounterTaskId = Database.executeBatch(new Batch_UpdateActivityCounterTask(), 50);
        Test.stopTest();             
    }
    
    @isTest
    static void testEvent() {
        Test.startTest();
        List<user> u=[Select Id from User where IsActive=true  and Id!=:UserInfo.getUserId() limit 2];
        DateTime myDateTime = DateTime.now(); 
        Lead lead = new Lead( 
            ProductoInteres__c = 'Combustible', 
            LastName = 'lastNameTest', 
            Company = 'TestCompany', 
            Puesto__c='Coordinador', 
            LeadSource='Web', 
            Email = 'test@mail.com',
            phone='6787654765', 
            NumEmpleados__c = '1-25'
        );
        insert lead;
        
        Account account = new Account(
            Name = 'Cuenta prueba', 
            NumberOfEmployees = 12, 
            NumeroEmpleados__c = '1-25'
        );
        insert account;
        
        Pricebook2 pr = new Pricebook2(
            Name='Edenred', 
            isActive=true
        );
        
        Id pricebookId2 = pr.Id;
        
        Opportunity opp = TestDataFactory_TEST.createOpportunity();
        
        List<Event> evento = new List<Event>{ 
            new Event(Acompanado_por__c=u[0].Id, StartDateTime = myDateTime, Subject = 'Capacitación', EndDateTime = myDateTime.addHours(1), ActivityDate = myDateTime.date(), WhatId = opp.Id, EstatusEvento__c = 'Finalizado',DireccionFin__c = 'daads', ActivityType__c = null, EventNumber__c = null),
                //new Event(Acompanado_por__c=u[0].Id, StartDateTime = myDateTime, Subject = 'Capacitación', EndDateTime = myDateTime.addHours(1), ActivityDate = myDateTime.date(), WhatId = account.Id, EstatusEvento__c = 'Finalizado',DireccionFin__c = 'daads',Familys__c ='Ticket Restaurante'),
                new Event(Acompanado_por__c=u[0].Id, StartDateTime = myDateTime, Subject = 'Capacitación', EndDateTime = myDateTime.addHours(1), ActivityDate = myDateTime.date(), WhoId = lead.Id, EstatusEvento__c = 'Finalizado',DireccionFin__c = 'daads', ActivityType__c = null, EventNumber__c = null)
                };
                    insert evento;
        Id BatchActivityCounterEventId = Database.executeBatch(new Batch_UpdateActivityCounterEvent(), 50);
        Test.stopTest();
    }   
}