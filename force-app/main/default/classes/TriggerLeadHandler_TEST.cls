/*************************
Cambios
Fecha       |   Autor               |   Descripción
01/11/2019  |   Desarrollo Freeway  |   Se modifica el método itShould para llenar los campos Giro__c y Subgiro_PL__c del prospecto y que esté en el estatus correcto antes de convertirlo.  
*************************/
@isTest
public class TriggerLeadHandler_TEST{
    static void Init(){
        Lead_Score__c ls = new Lead_Score__c();
        ls.Bonus_AreaTrabajo__c = 5;
        ls.Bonus_MobilePhone__c = 5;
        ls.Bonus_FechaCumpleanos__c = 5;
        ls.Bonus_Giro__c = 5;
        ls.Bonus_N_mero_de_veh_culos__c = 5;
        ls.Bonus_Puesto__c = 5;
        ls.Bonus_Sector__c = 5;
        ls.Bonus_Website__c = 5;
        ls.Bonus_Subgiro_PL__c = 5;
        ls.Bonus_Telefono2__c = 5;
        ls.Campaign__c = 5;
        ls.Campaign_No__c = 5;
        ls.Campaign_Yes__c = 5;
        ls.Status__c = 5;
        ls.Status_Contactado__c = 5;
        ls.Status_En_curso__c = 5;
        ls.Status_No_contactado__c = 5;
        ls.Status_No_interesado__c = 5;
        ls.Status_Sin_Segmento_Definido__c = 5;
        ls.Family__c = 5;
        ls.Family_1__c = 5;
        ls.Family_2__c = 5;
        ls.Family_3__c = 5;
        ls.Families__c = 5;
        ls.Families_Despensa_Combustible_Emp__c = 5;
        ls.Families_Otras__c = 5;
        ls.Origin__c = 5;
        ls.Origin_Otros__c = 5;
        ls.Origin_Redes_sociales_Email_mkt__c = 5;
        ls.Origin_SEO_SEA_Web_Citas_Rec_Ref_Tel__c = 5;
        ls.Segment__c = 5;
        ls.Segment_Middle_1__c = 5;
        ls.Segment_Middle_2_Large_Key__c = 5;
        ls.Segment_S1__c = 5;
        ls.Segment_S2__c = 5;
        ls.Segment_S3__c = 5;
        ls.Time__c = 5;
        ls.Time_1__c = 5;
        ls.Time_2__c = 5;
        ls.Time_3__c = 5;
        ls.Time_4__c = 5;
        ls.Time_5__c = 5;
        ls.Time_6__c = 5;
        insert ls;
    }
    
    @isTest
    static void itShould(){
        Init();
        
        Lead lea = new Lead(
            RFC__c = 'RFC_Test',
            ProductoInteres__c = 'Combustible',
            LastName = 'CLS_lastNameTest',
            Company = 'CLS_TestCompany',
            Puesto__c='Administrador',
            LeadSource='Web',
            Phone='8765434574',
            Email = 'CLS_test@mail.com',
            NumEmpleados__c = '1-25',
            CategoriaSolucion__c = 'Despensa',
            Telefono2__c = '1234567890',
            MobilePhone = '1234567890',
            AreaTrabajo__c = 'Atención a clientes',
            FechaCumpleanos__c = System.Today().addYears(-40),
            Website = 'www.sitio.com',
            N_mero_de_veh_culos__c = '6-25',
            Sector__c = 'Público',
            RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId());
        insert lea;

        Task t = new Task( Subject = 'Envío de cotización', Status = 'New', Priority = 'Normal', WhoId = lea.Id);
        insert t; 

        lea.Status = 'En curso';
        update lea;
		Test.startTest();
        lea.Giro__c = 'Construccion';
        lea.Subgiro_PL__c = 'Edificacion';     
        update lea;

        Database.LeadConvert prospectoConvertido =  new Database.LeadConvert();
        prospectoConvertido.setLeadId(lea.id);
        LeadStatus estatusConversion = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        prospectoConvertido.setConvertedStatus(estatusConversion.MasterLabel);
        Database.convertLead(prospectoConvertido);
        Test.stopTest();
    }

    @isTest
    static void metodo1() {
        Init();
        
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Ventas' LIMIT 1];
        User u= new User(ManagerId=UserInfo.getUserId(),LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;

        System.runAs(u){
            Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert acc;

            EntidadLegal__c el=new EntidadLegal__c(RFC__c='AAHJ343534KG3',Name='AAHJ343534KG3',Estatus__c='Completa');
            insert el;

            EntidadCuenta__c ec=new EntidadCuenta__c(Cuenta__c=Acc.Id,Name='AAHJ343534KG3',EntidadLegal__c=el.Id);
            insert ec;

            Opportunity opp=new Opportunity(Familia__c='Combustible',Name='BP',AccountId=acc.Id,Entidad_Cuenta__c=ec.Id,CloseDate=Date.today().addMonths(1),StageName='Cotización');
            insert opp;
        }

        Test.startTest();
        Lead lead2 = new Lead(StatusApprovalBPfleet__c='En espera de aprobación',RFC__c='AAHJ343534KG3', LastName = 'TestBP', Company = 'BPCompany', LeadSource='Web',Phone='9823657493', Email = 'test@test.com', NumEmpleados__c = '1-25',RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('BPfleet').getRecordTypeId());
        insert lead2;
        
        //Lead ltem=[Select Id,Approver__c,IdExecutiveNotification__c from Lead where Id=:lead2.Id];
        //System.debug('LEASSSSS:'+ltem);
        lead2.StatusApprovalBPfleet__c='Aprobado';
        update lead2;
        
        SolicitarAprobacionBPfleet_CONT.getInfo(lead2.Id);
        SolicitarAprobacionBPfleet_CONT.solicitarAprobacion(lead2.Id);
        Test.stopTest();
    }
}