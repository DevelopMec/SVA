@isTest public class TriggerWorkOrderHandler_Test {
    @testSetup static void SetUpData(){
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
        Precio_Litro__c pl=new Precio_Litro__c();
        pl.Precio_por_litro__c=17;
        insert pl;
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
                Product2 p2 = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ecovale Combustible Edenred Diesel', ProductCode = '60-D', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
                objs.add(p2);
                
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
                
                //CONCEPTOS
                Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
                objs.add(c);
                Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 2.2);
                objs.add(c1);
                Concepto__c c2 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p2.Id, Importe__c = 3.3);
                objs.add(c2);
                Concepto__c c3 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 4.4);
                objs.add(c3);
                Concepto__c c4 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 5.5);
                objs.add(c4);
                
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
                
                EntidadLegal__c eL2 = new EntidadLegal__c(
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
                    Nombre__c = 'EL2',
                    RazonSocial__c = 'SA DE CV',
                    Name = 'CUPO800825569'
                );
                objs.add(eL2);
                insert objs;
                objs.clear();
                
                //QUOTE
                Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId2);
                objs.add(quot);
                
                //OPPORTUNITYLINEITEM
                OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe2.Id, ServiceDate = System.today().addDays(5));
                objs.add(oli);
                
                insert objs;
                objs.clear();
                
                //QUOTELINEITEM
                QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));       
                objs.add(qli);
                
                //ATTACHMENTS
                Attachment attach = new Attachment();    
                attach.Name = 'Contrato o Propuesta firmados.pdf';
                Blob bodyBlob = Blob.valueOf('U');
                attach.body = bodyBlob;
                attach.parentId = opp.Id;
                objs.add(attach);
                
                Attachment attach2 = new Attachment();    
                attach2.Name = 'Id. de Cliente.pdf';
                Blob bodyBlob2 = Blob.valueOf('U');
                attach2.body = bodyBlob2;
                attach2.parentId = opp.Id;
                objs.add(attach2);
                
                Attachment attach3 = new Attachment();    
                attach3.Name = 'Registro Patronal.pdf';
                Blob bodyBlob3 = Blob.valueOf('U');
                attach3.body = bodyBlob3;
                attach3.parentId = opp.Id;
                objs.add(attach3);
                
                //ENTIDADES CUENTA
                EntidadCuenta__c eC = new EntidadCuenta__c(
                    Cuenta__c = acc.Id,
                    EntidadLegal__c = eL.Id,
                    Name = 'CUPI800825569'
                );
                objs.add(eC);
                
                EntidadCuenta__c eC2 = new EntidadCuenta__c(
                    Cuenta__c = acc.Id,
                    EntidadLegal__c = eL2.Id,
                    Name = 'CUPA800825569'
                );
                objs.add(eC2);
                
                insert objs;
                objs.clear();
                
                //CAMBIAR ETAPA DE OPORTUNIDAD A CONTRATO
                String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';
                //Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);
                Test.startTest();
                QuoteLineItem qliUP=[Select Id from QuoteLineItem where QuoteId=:quot.Id and Escalonamiento__c = null limit 1];
                qliUP.FormaPago__c='Deposito';
                update qliUP;
                
                opp.StageName = 'Contrato';
                opp.SyncedQuoteId = quot.Id;
                update opp;
                
                //CONTACTO ENTIDAD
                ContactoEntidad__c cE = new ContactoEntidad__c(
                    Contacto__c = cont.Id,
                    EntidadLegal__c = eL.Id,
                    Entidad_Cuenta__c = eC.Id
                );
                objs.add(cE);
                
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
                Test.stopTest();
            }
        }
    } 
    
    
    @isTest
    static void testWorkOrder(){
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
        
        ot.Estatus__c = 'Capacitación';
        ot.VolumenEmisionMensual2__c = 3242;
        ot.Motivo_del_estatus__c  ='test';
        ot.Numero_de_pedido__c = '122';
        ot.Fecha_de_pedido__c = date.today();
        ot.Fecha_estimada_de_entrega__c  = date.today();
        ot.Fecha_de_entrega__c = date.today();
        update ot;
        ot.Estatus__c = 'concluida';
        //ot.Oportunidad__c = opp.Id;
        ot.No_requiere_capacitacion__c = true;        
        String errorMessage = '';
        try {
        	update ot;
        } catch(Exception e) {
            errorMessage = e.getMessage();
        }
        System.assert(errorMessage.contains('No puede modificar la oportunidad en esta etapa'));
                
        WorkOrder ot2 = new WorkOrder();
        ot2.FechaInicio__c = System.today();
        ot2.StartDate = System.today();
        ot2.OT_Principal__c = false;
        ot2.Estatus__c = 'Pedido de tarjetas';
        ot2.IDProductoOpp__c = p.Id;
        ot2.Oportunidad__c = opp.Id;
        ot2.AccountId = acc.Id;
        ot2.Codigo_AS400__c = '11-11-11111-111';
        ot2.Personalizacion_de_Tarjetas__c = false;
        ot2.LayoutPersonalizacionTarjetas__c = '';
        insert ot2;
        
        ot2.Estatus__c = 'Capacitación';
        ot2.VolumenEmisionMensual2__c = 3242;
        ot2.Motivo_del_estatus__c  ='test';
        ot2.Numero_de_pedido__c = '122';
        ot2.Fecha_de_pedido__c = date.today();
        ot2.Fecha_estimada_de_entrega__c  = date.today();
        ot2.Fecha_de_entrega__c = date.today();
        update ot2;
        
        
        ot2.Estatus__c = 'concluida';
        //ot.Oportunidad__c = opp.Id;
        ot2.No_requiere_capacitacion__c = true;        
        errorMessage = '';
        try {
        	update ot2;
        } catch(Exception e) {
            errorMessage = e.getMessage();
        }
        
        ot2.Estatus__c = 'Cancelada';
        update ot2;
        Test.stopTest();
    }
    
}