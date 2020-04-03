@isTest
private class OpportunityClosing_Test{
    @isTest static void test_method_one(){
        Opportunity_closing__c cs = new Opportunity_closing__c();
        cs.No_follow_up_alert__c = 5;
        cs.No_follow_up_closing__c = 6;
        cs.No_client_operations_alert__c = 12;
        cs.No_client_operations_closing__c = 13;
        insert cs;
        
        Account a = new Account(
            Name = 'cuenta'
        );
        insert a;
        
        Contact c = new Contact(
            AccountId = a.Id,
            FirstName = 'Nombre',
            LastName = 'Apellido'
        );
        insert c;
        
        Opportunity opp1 = new Opportunity(
            AccountId = a.Id,
            Name = 'test Seguimiento',
            StageName = 'Cotización',
            CloseDate = system.today().addmonths(1),
            Contacto__c = c.Id
        );
        insert opp1;
        
        ContratoFilial__c cf = new ContratoFilial__c(
            Name = '01-01-00001-999',
            CodigoAS400__c = '01-01-00001-999'
        );
        insert cf;
        
        Opportunity opp2 = new Opportunity(
            AccountId = a.Id,
            Contrato_Filial__c = cf.Id,
            CodigoClienteAS400__c = '01-01-00001-999',
            Name = 'test Operaciones',
            StageName = 'Cotización',
            CloseDate = system.today().addmonths(1),
            Contacto__c = c.Id
        );
        insert opp2;
        
        Opportunity opp3 = new Opportunity(
            AccountId = a.Id,
            Name = 'test Seguimiento',
            StageName = 'Cotización',
            CloseDate = system.today().addmonths(1),
            Contacto__c = c.Id,
            Follow_up_alert__c = true
        );
        insert opp3;
        
        Opportunity opp4 = new Opportunity(
            AccountId = a.Id,
            Contrato_Filial__c = cf.Id,
            CodigoClienteAS400__c = '01-01-00001-999',
            Name = 'test Operaciones',
            StageName = 'Cotización',
            CloseDate = system.today().addmonths(1),
            Contacto__c = c.Id,
            Client_operations_alert__c = true
        );
        insert opp4;
        
        OpportunityClosing.FollowUpAlert();
        OpportunityClosing.FollowUpClosing();
        OpportunityClosing.ClientOperationsAlert();
        OpportunityClosing.ClientOperationsClosing();
    }
}