@isTest
public class Notificacion_SolicitudPausaOT_CONT_TEST {
    @isTest(seeAllData=true)
    public static void testgetDatos(){
        Account acc = [SELECT Id,Name FROM Account LIMIT 1];
        Opportunity opp = [SELECT Id,Name FROM Opportunity where Contrato2__c!=null LIMIT 1];
        Product2 p = [SELECT Id,Name FROM Product2 LIMIT 1]; 
        WorkOrder ot = new WorkOrder();
        ot.FechaInicio__c = System.today();
        ot.StartDate = System.today();
        ot.OT_Principal__c = true;
        ot.Estatus__c = 'Pedido de tarjetas';
        ot.IDProductoOpp__c = p.Id;
        ot.Oportunidad__c = opp.Id;
        ot.AccountId = acc.Id;
        ot.Codigo_AS400__c = '11-11-11111-111';
        ot.Personalizacion_de_Tarjetas__c = false;
        ot.LayoutPersonalizacionTarjetas__c = '';
        
        insert ot;
        Test.startTest();
        Notificacion_SolicitudPausaOT_CONT.getDatos(ot.Id);
        Notificacion_SolicitudPausaOT_CONT.solicitudPausa(ot.Id, 'motivos', 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.solicitaRevision(ot.Id, 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.pausarOT(ot.Id);
        Test.stopTest();
    }
    @isTest
    public static void testmethod2(){
        ServiceGroups__c  sg=new ServiceGroups__c();
        sg.Name='test';
        sg.RecordTypeId=Schema.SObjectType.ServiceGroups__c.getRecordTypeInfosByDeveloperName().get('WorkOrders').getRecordTypeId();
        insert sg;
        ServiceGroups__c  s2=new ServiceGroups__c();
        s2.Name='COORDINADORES MLK';
        s2.RecordTypeId=Schema.SObjectType.ServiceGroups__c.getRecordTypeInfosByDeveloperName().get('WorkOrders').getRecordTypeId();
        insert s2;
        ServiceGroupsUser__c sgu=new ServiceGroupsUser__c();
        sgu.ServiceGroup__c=sg.Id;
        sgu.User__c=UserInfo.getUserId();
        insert sgu;
        ServiceGroupsUser__c sgu2=new ServiceGroupsUser__c();
        sgu2.ServiceGroup__c=s2.Id;
        sgu2.User__c=UserInfo.getUserId();
        insert sgu2;
        
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' and Profile.Name LIKE '%Administrador del sistema%' AND IsActive = true ORDER BY Name LIMIT 1];
        
        System.runAs(uAdmin){
            List<Sobject> objectsToInsert = new List<Sobject>(); 
            
            //CUSTOM SETTING
            ContadorRegistros_CS__c contador = new ContadorRegistros_CS__c(Name = 'Corporate: TE-MTTO-KAM-CE-NE-SE-MRO', NumeroRegistro__c = -1);
            objectsToInsert.add(contador); 
            
            //PROFILES
            Profile prof = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Administrador del sistema%'];
            
            //ROLES
            Map<String,ID> userRolesMap = new Map<String,ID>();
            for (UserRole userRole : [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_Multiproducto_Region_Noroeste', 'Ejecutivo_Implementaciones_MLK')]) userRolesMap.put(userRole.DeveloperName, userRole.Id);
            
            //USUARIOS
            User u = new User(Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_Multiproducto_Region_Noroeste'), LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id );
            User userOT = new User(Segmento__c = 'MLK', UserRoleId = userRolesMap.get('Ejecutivo_Implementaciones_MLK'), LastName = 'imp', Email = 'imp@amamama.com', Username = 'imp@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Ordenes de trabajo', FiltroAsignacion_MSPL__c = 'MLK;Small');
            objectsToInsert.add(u);
            objectsToInsert.add(userOT);
            
            insert objectsToInsert;
            
            System.runAs(u){
                List<sObject> objs = new List<sObject>();
                
                //PRICEBOOK
                Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        
                Id pricebookId = Test.getStandardPricebookId();
                objs.add(pr);
                
                //PRODUCT
                Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
                objs.add(p);
                
                //Account
                Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
                objs.add(acc);
                
                insert objs;
                objs.clear();
                
                //PRICEBOOK
                Id pricebookId2 = pr.Id;
                
                //OPPORTUNITY
                Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba TESTWO', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false, ownerId = u.id);
                objs.add(opp);
                
                //CONTACT
                Contact cont = new Contact(Curp__c='BADD110313HCMLNS09',LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com',Funcion__c = 'Representante Legal');
                objs.add(cont);
                
                //PRICEBOOKENTRY
                PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
                objs.add(pbe);
                PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId2, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
                objs.add(pbe2);
                
                //ENTIDADES LEGALES
                EntidadLegal__c eL = new EntidadLegal__c(
                    ActaConstitutivaCliente__c = true,
                    AltaSHCP__c = true,
                    CURP__c = true,
                    ComprobanteDomicilioCliente__c = true,
                    Direccion_Cuenta__c = true,
                    FM3__c = true,
                    IdentificacionOficialCliente__c = true,
                    PoderNotarial__c = true,
                    RFCDoc__c = true,
                    RegistroPatronal__c = true,
                    Nombre__c = 'EL1',
                    RazonSocial__c = 'SA DE CV',Name = 'CUPU800825569'
                );
                objs.add(eL);
                insert objs;
                objs.clear();
                
                //QUOTE
                Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId2);
                objs.add(quot);
                
                insert objs;
                objs.clear();
                
                //QUOTELINEITEM
                QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));       
                objs.add(qli);
                
                insert objs;
                objs.clear();
                
                //CONTRATO
                Contrato2__c contrato = new Contrato2__c(
                    Cuenta__c = acc.Id,
                    Contacto__c  = cont.Id,
                    Entidad_Legal__c = eL.Id,
                    CodigoAs400__c = '11-11-11111-111',
                    PartidaPresupuesto__c = qli.Id,
                    Personalizacion_de_Tarjetas__c = false,
                    EtapaContrato__c = 'Autorizado',
                    CamposValidados__c = true,
                    RepresentanteLegal__c = cont.Name
                );
                objs.add(contrato);
                
                insert objs;
                objs.clear();
            }
        }
        
        Test.startTest();
        Account acc = [SELECT Id,Name FROM Account WHERE Name ='Cuenta prueba'];
        Opportunity opp = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Product2 p = [SELECT Id,Name FROM Product2 WHERE Name = 'Ticket Car 3.0']; 
        WorkOrder ot = new WorkOrder();
        ot.FechaInicio__c = System.today();
        ot.StartDate = System.today();
        ot.OT_Principal__c = true;
        ot.Estatus__c = 'Pedido de tarjetas';
        ot.IDProductoOpp__c = p.Id;
        ot.Oportunidad__c = opp.Id;
        ot.AccountId = acc.Id;
        ot.Codigo_AS400__c = '11-11-11111-111';
        ot.Personalizacion_de_Tarjetas__c = false;
        ot.LayoutPersonalizacionTarjetas__c = '';
        
        insert ot;
        
        opp.OwnerId=UserInfo.getUserId();
        update opp;
        
        Notificacion_SolicitudPausaOT_CONT.getDatos(ot.Id);
        Notificacion_SolicitudPausaOT_CONT.solicitudPausa(ot.Id, 'motivos', 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.solicitaRevision(ot.Id, 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.aceptapausa(ot.Id, 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.rechazarpausa(ot.Id, 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.pausarOT(ot.Id);
        Test.stopTest();
    }
    @isTest
    public static void testmethod3(){
        Test.startTest();
        //Notificacion_SolicitudPausaOT_CONT.getDatos(ot.Id);
        Notificacion_SolicitudPausaOT_CONT.solicitudPausa('3456789', 'motivos', 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.solicitaRevision('123456789', 'comentarios');
        //Notificacion_SolicitudPausaOT_CONT.aceptapausa('123456789', 'comentarios');
        //Notificacion_SolicitudPausaOT_CONT.rechazarpausa('123456789', 'comentarios');
        Notificacion_SolicitudPausaOT_CONT.pausarOT('1234567890');
        Test.stopTest();
    }
}