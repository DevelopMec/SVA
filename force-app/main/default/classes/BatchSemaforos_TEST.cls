@isTest
public class BatchSemaforos_TEST {
    @testSetup
    public static void testSetup(){
        Profile prof = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Administrador del sistema%'];
        Map<String,ID> userRolesMap = new Map<String,ID>();
        for (UserRole userRole : [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_de_Migracion', 'Ejecutivo_Telesales_Inbound','Ejecutivo_Telesales_Outbound')]) userRolesMap.put(userRole.DeveloperName, userRole.Id);
        Test.startTest();
        List<User> usersInsert=new List<User>();
        User uG= new User(UsuarioTop__c=true,Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_de_Migracion'), LastName = 'gestor', Email = 'imp@test.com', Username = 'tgestor@test.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'gestor1', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        usersInsert.add(uG);
        User u= new User(ManagerId=uG.Id,UsuarioTop__c=true,Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_de_Migracion'), LastName = 'test1', Email = 'imp@amamama.com', Username = 'test1@test.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias1', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        usersInsert.add(u);
        User u2= new User(ManagerId=uG.Id,UsuarioTop__c=true,Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_Telesales_Inbound'), LastName = 'test2', Email = 'imp@amamama.com', Username = 'test2@test.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias2', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        usersInsert.add(u2);
        User u3= new User(ManagerId=uG.Id,UsuarioTop__c=true,Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_Telesales_Outbound'), LastName = 'test3', Email = 'imp@amamama.com', Username = 'test3@test.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias3', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        usersInsert.add(u3);
        User u4= new User(ManagerId=uG.Id,UsuarioTop__c=true,Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_de_Migracion'), LastName = 'test4', Email = 'imp@amamama.com', Username = 'test4@test.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias4', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        usersInsert.add(u4);
        User u5= new User(ManagerId=uG.Id,UsuarioTop__c=true,Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_Telesales_Inbound'), LastName = 'test5', Email = 'imp@amamama.com', Username = 'test5@test.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias5', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        usersInsert.add(u5);
        User u6= new User(ManagerId=uG.Id,UsuarioTop__c=true,Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_Telesales_Outbound'), LastName = 'test6', Email = 'imp@amamama.com', Username = 'test6@test.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias6', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        usersInsert.add(u6);
        
        insert usersInsert;
        
        Test.stopTest();
    }
	@isTest
    public static void SemaforosLeadScheduleTst(){
        Negocio__c neg=new Negocio__c(ReasignacionOportunidad_Cross_Sell__c='30;15;15;5',ReasignacionLead_Small__c='30;15;15;5', ReasignacionLeadTarea_MLK__c='30', ReasignacionOpportunity_Small__c='30;20;10;10', ReasignacionOpportunity_MLK__c='60;30', ReasignacionLeadConversion_MLK__c='60');
        insert neg;
        User u=[Select Id from User where Alias='alias1'];
        List<Lead> listInsert=new List<Lead>();
        Lead le = new Lead();
        le.Company = 'testCom';le.CountryCode = 'MX';
        le.FIrstName = 'test1';le.LastName = 'test1';
        le.phone = '6000000006';le.email = 'cos@nomvf.com';
        le.Status = 'No contactado';le.ProductoInteres__c = 'Empresarial';
        le.LeadSource = 'Cambaceo';le.NumEmpleados__c = '1-25';le.NumeroReasignacion__c=1;
        le.FechaReasignacion__c=DateTime.now().AddDays(-32);le.OwnerId=u.Id;
        listInsert.add(le);
        Lead le2 = new Lead();
        le2.Company = 'testCom';le2.CountryCode = 'MX';
        le2.FIrstName = 'test1';le2.LastName = 'test1';
        le2.phone = '6000000006';le2.email = 'cos@nomvf.com';
        le2.Status = 'No contactado';le2.ProductoInteres__c = 'Empresarial';
        le2.LeadSource = 'Cambaceo';le2.NumEmpleados__c = '1-25';
        le2.NumeroReasignacion__c=1;le2.FechaReasignacion__c=DateTime.now().AddDays(-32);
        le2.FechaUltimaActividad__c=DateTime.now().AddDays(-32);le2.OwnerId=u.Id;
        listInsert.add(le2);
        Lead le3 = new Lead();
        le3.Company = 'testCom';le3.CountryCode = 'MX';
        le3.FIrstName = 'test1';le3.LastName = 'test1';
        le3.phone = '6000000006';le3.email = 'cos@nomvf.com';
        le3.Status = 'No contactado';le3.ProductoInteres__c = 'Empresarial';
        le3.LeadSource = 'Cambaceo';le3.NumEmpleados__c = '1-25';le3.OwnerId=u.Id;
        le3.NumeroReasignacion__c=1;le3.FechaReasignacion__c=DateTime.now().AddDays(-72);
        listInsert.add(le3);
        
        
        User u2=[Select Id from User where Alias='alias4'];
        Lead le4 = new Lead();
        le4.Company = 'testCom';le4.CountryCode = 'MX';
        le4.FIrstName = 'test1';le4.LastName = 'test1';
        le4.phone = '6000000006';le4.email = 'cos@nomvf.com';
        le4.Status = 'No contactado';le4.ProductoInteres__c = 'Empresarial';
        le4.LeadSource = 'Cambaceo';le4.NumEmpleados__c = '1-25';
        le4.NumeroReasignacion__c=10;le4.FechaReasignacion__c=DateTime.now().AddDays(-32);
        le4.OwnerId=u.Id;
        listInsert.add(le4);
        
        Lead le5 = new Lead();
        le5.Company = 'testCom';le5.CountryCode = 'MX';
        le5.FIrstName = 'test1';le5.LastName = 'test1';
        le5.phone = '6000000006';le5.email = 'cos@nomvf.com';
        le5.Status = 'No contactado';le5.ProductoInteres__c = 'Empresarial';
        le5.LeadSource = 'Cambaceo';le5.NumEmpleados__c = '1-25';
        le5.NumeroReasignacion__c=11;le5.FechaReasignacion__c=DateTime.now().AddDays(-32);
        le5.OwnerId=u2.Id;
        listInsert.add(le5);
        
        Lead le6 = new Lead();
        le6.Company = 'testCom';le6.CountryCode = 'MX';
        le6.FIrstName = 'test1';le6.LastName = 'test1';
        le6.phone = '6000000006';le6.email = 'cos@nomvf.com';
        le6.Status = 'No contactado';le6.ProductoInteres__c = 'Empresarial';
        le6.LeadSource = 'Cambaceo';le6.NumEmpleados__c = '1-25';
        le6.NumeroReasignacion__c=12;le6.FechaReasignacion__c=DateTime.now().AddDays(-32);
        listInsert.add(le6);
        
        Lead le7 = new Lead();
        le7.Company = 'testCom';le7.CountryCode = 'MX';
        le7.FIrstName = 'test1';le7.LastName = 'test1';
        le7.phone = '6000000006';le7.email = 'cos@nomvf.com';
        le7.Status = 'No contactado';le7.ProductoInteres__c = 'Empresarial';
        le7.LeadSource = 'Cambaceo';le7.NumEmpleados__c = '1-25';
        le7.NumeroReasignacion__c=13;le7.FechaReasignacion__c=DateTime.now().AddDays(-32);
        listInsert.add(le7);
        
        insert listInsert;
        Test.startTest();
        TiempoReasignacionSemaforo.getInfoSemaforos(le7.Id);
        SemaforosSchedule sh=new SemaforosSchedule();
        System.schedule('test', '0 0 2 * * ?', sh);
        Test.stopTest();
    }
    
    @isTest
    public static void SemaforosOppScheduleTst(){
        Negocio__c neg=new Negocio__c(ReasignacionOportunidad_Cross_Sell__c='30;15;15;5',ReasignacionLead_Small__c='30;15;15;5', ReasignacionLeadTarea_MLK__c='30', ReasignacionOpportunity_Small__c='30;20;10;10', ReasignacionOpportunity_MLK__c='60;30', ReasignacionLeadConversion_MLK__c='60');
        insert neg;
        List<Opportunity> listInsert=new List<Opportunity>();
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
        insert acc;
        Opportunity op = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today());
        op.NumeroReasignacion__c=1;
        op.FechaReasignacion__c=DateTime.now().AddDays(-32);
        listInsert.add(op);
        Opportunity le2 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today());
        le2.NumeroReasignacion__c=1;
        le2.FechaReasignacion__c=DateTime.now().AddDays(-32);
        le2.FechaUltimaActividad__c=DateTime.now().AddDays(-32);
        listInsert.add(le2);
        
        Opportunity op2 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today().AddMonths(4));
        op2.NumeroReasignacion__c=1;
        op2.FechaReasignacion__c=DateTime.now().AddDays(-32);
        listInsert.add(op2);
        Opportunity op3 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today().AddMonths(4));
        op3.NumeroReasignacion__c=1;
        op3.FechaReasignacion__c=DateTime.now().AddDays(-32);
        op3.FechaUltimaActividad__c=DateTime.now().AddDays(-32);
        listInsert.add(op3);
        
        Opportunity le3 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today());
        le3.NumeroReasignacion__c=1;
        le3.FechaReasignacion__c=DateTime.now().AddDays(-82);
        listInsert.add(le3);
        
        User u=[Select Id from User where Alias='alias1'];
        User u2=[Select Id from User where Alias='alias4'];
        Opportunity le4 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today());
        le4.NumeroReasignacion__c=10;
        le4.FechaReasignacion__c=DateTime.now().AddDays(-32);
        le4.OwnerId=u.Id;
        listInsert.add(le4);
        
        Opportunity le5 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today());
        le5.NumeroReasignacion__c=11;le5.FechaReasignacion__c=DateTime.now().AddDays(-32);
        le5.OwnerId=u2.Id;
        listInsert.add(le5);
        
        Opportunity le6 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today());
        le6.NumeroReasignacion__c=12;le6.FechaReasignacion__c=DateTime.now().AddDays(-32);
        listInsert.add(le6);
        
        Opportunity le7 = new Opportunity(AccountId=acc.Id,Name='test', StageName='Cotización', CloseDate=Date.today());
        le7.NumeroReasignacion__c=13;le7.FechaReasignacion__c=DateTime.now().AddDays(-32);
        listInsert.add(le7);
        
        insert listInsert;
        Test.startTest();
        TiempoReasignacionSemaforo.getInfoSemaforos(le7.Id);
        SemaforosSchedule sh=new SemaforosSchedule();
        System.schedule('test', '0 0 2 * * ?', sh);
        Test.stopTest();
    }
}