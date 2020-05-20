@isTest
public without sharing class TriggerOpportunityHandler_Test {
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 21/03/2018
        * @description Método para probar clase TriggerOpportunityHandler
    */
    
    /**
        * @changes
        * @12/03/2020 Desarrollo Freeway: Add method modificarOpotunidadTest to improve coverage.
        * @12/03/2020 Desarrollo Freeway: Add method validateRFCSolcionAssignmentTest to improve coverage.
        * @30/03/2020 Improve coverage. Add setup and ownerBUValidationTest methods.
        * @30/04/2020 sendPartnersAndAliancesMailTest method added to cover sendPartnersAndAliancesMail class method.
    */

    @testSetup
    public static void setup(){
        Test.startTest();
        insert new GeneralCatalog__c(ApproverBPSmall__c=UserInfo.getUserId(),ApproverBPCorporate__c=UserInfo.getUserId());
        Test.stopTest();
    }
    
    @isTest
    static void metodoPrueba(){
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND Profile.Name='Administrador del sistema' AND IsActive = true ORDER BY Name LIMIT 1];
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        System.runAs(uAdmin){
            Map<String,ID> userRolesMap = new Map<String,ID>();
            for (UserRole userRole : [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_de_Administracion_de_Ventas')]) userRolesMap.put(userRole.DeveloperName, userRole.Id);

            //CUSTOM SETTING/
            List<ContadorRegistros_CS__c> contador = new List<ContadorRegistros_CS__c>();
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_OPAM', NumeroRegistro__c = -1));
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_Edenred', NumeroRegistro__c = -1));
            insert contador;
            
            User usuarioADV = new User(LastName = 'ADV', Email = 'adv@amamama.com', Username = 'adv@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Altas de Cliente', FiltroAsignacion_MSPL__c = 'Clientes OPAM;Clientes Edenred', UserRoleId = userRolesMap.get('Ejecutivo_de_Administracion_de_Ventas'), isActive = true);
            insert usuarioADV;
        }
        
        User u = new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;

        List<sObject> objs = new List<sObject>();

        Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        

        Id pricebookId = Test.getStandardPricebookId();
        
        //insert Product2
        Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        Product2 p2 = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ecovale Combustible Edenred Diesel', ProductCode = '60-D', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        //insert Account
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');

        objs.add(pr);
        objs.add(p);
        objs.add(p2);
        objs.add(acc);
        insert objs;
        objs.clear();
        
        Id pricebookId2 = pr.Id;

        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false, OwnerId = u.Id, IdEjecutivoADV__c = u.Id);

        //insert Contact
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        Contact cont2 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        Contact cont3 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');

        //insert PricebookEntry
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId2, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);

        //insert Concepto__c
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 2.2);
        Concepto__c c2 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p2.Id, Importe__c = 3.3);
        Concepto__c c3 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 4.4);
        Concepto__c c4 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 5.5);
        
        objs.add(opp);
        objs.add(cont);
        objs.add(cont2);
        objs.add(cont3);
        objs.add(pbe);
        objs.add(pbe2);
        objs.add(c);
        objs.add(c1);
        objs.add(c2);
        objs.add(c3);
        objs.add(c4);
        insert objs;
        objs.clear();

        //insert Quote
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe2.Id, ServiceDate = System.today().addDays(5));

        //insert QuoteLineItem 
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));       

        //insert ProductoComparado__c
        ProductoComparado__c pc = new ProductoComparado__c(ProductoCotizado__c = qli.Id, ProductoComparado__c = p2.Id);
        
        //insert ProductoConcepto__c
        ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon2 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon3 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon4 = new ProductoConcepto__c(Concepto__c = c3.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        ProductoConcepto__c pcon5 = new ProductoConcepto__c(Concepto__c = c4.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        
        Precio_Litro__c pl=new Precio_Litro__c(Precio_por_litro__c=1);
        insert pl;
        
        String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';

        Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);

        List<Quote> objQoute = (List<Quote>)mapaR1.get('Instance_Quote');
        List<Database.UpsertResult> objQouteLineItem = (List<Database.UpsertResult>)mapaR1.get('Upsert_QuoteLineItem');
        List<Database.UpsertResult> objProductoComparado = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoComparado__c');
        List<Database.UpsertResult> objProductoConcepto = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoConcepto__c');
        
        QuoteLineItem qli3 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));
        QuoteLineItem qli4 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));

        QuoteLineItem qli5 = qli.clone(false,false,false,false);
        insert qli3;
        
        ProductoConcepto__c pcon6 = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon7 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon8 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);

        objs.add(pcon6);
        objs.add(pcon7);
        objs.add(pcon8);
        insert objs;

        String mapeoJSON1 = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","OpportunityId": "'+opp.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días","Id": "'+objQoute[0].Id+'"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Id": "'+objQouteLineItem[0].getId()+'","Escalonamiento1__c": true}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'","Id": "'+objProductoComparado[0].getId()+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[0].getId()+'"},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[1].getId()+'"},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[2].getId()+'"},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[3].getId()+'"},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[4].getId()+'"}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';

        opp.Description = 'Comentario de prueba';
        update opp;
        
        Attachment attOpp1 = new Attachment (parentId = opp.Id, Name = 'Contrato o Propuesta firmados', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp2 = new Attachment (parentId = opp.Id, Name = 'Id. de Cliente', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp3 = new Attachment (parentId = opp.Id, Name = 'Registro Patronal', Body = Blob.valueOf('Blah Blah'));
        List<Attachment> listaAtt = new List<Attachment>();
        listaAtt.add(attOpp1);
        listaAtt.add(attOpp2);
        listaAtt.add(attOpp3);
        insert listaAtt;

        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(new ContentVersion(Title = 'Contrato o Propuesta firmados', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Id. de Cliente', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Registro Patronal', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        insert cvs;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        List<ContentDocumentLink> lcdl = new List<ContentDocumentLink>();
        for( ContentDocument cd : documents) {
            lcdl.add(new ContentDocumentLink(LinkedEntityId = opp.Id, ContentDocumentId = cd.Id, ShareType = 'V'));
        }
        insert lcdl;

        System.debug('LIMITEEE:::'+Limits.getQueries());
        //qli.Id = (Id) result.get('Upsert_QuoteLineItem').get(0).get('id');
        
        List<QuoteLineItem> listQlis = [SELECT Id FROM QuoteLineItem WHERE Quote.OpportunityId =: opp.Id];
        Contrato2__c contrato2 = new Contrato2__c(EtapaContrato__c='Finalizado',PartidaPresupuesto__c = listQlis[0].Id, CodigoAS400__c = '11-11-12345-122', Personalizacion_de_Tarjetas__c = true);
        insert contrato2;
        Test.startTest();
        CatalogoDirecciones__c direccion = new CatalogoDirecciones__c();
        direccion.Calle_Tt__c = 'Lago Alberto';
        direccion.Ciudad_Tt__c = 'CDMX';
        direccion.CodigoPostal_Tt__c = '11420';
        direccion.Colonia_Tt__c = 'Polanco';
        direccion.CuentaID__c = acc.Id;
        direccion.DelegacionMunicipio_Tt__c = 'Miguel Hidalgo';
        direccion.Estado_Tt__c = 'CDMX';
        direccion.Name = 'Lago Alberto';
        direccion.Tipo_Pt__c ='Cuenta';
        
        insert direccion;
        
        Contrato_Direccion__c condir = new Contrato_Direccion__c();
        condir.ContratoID__c = contrato2.Id;
        condir.DireccionID__c = direccion.Id;
        insert condir;
        
        try{
            opp.StageName = 'Alta de cliente';
            update opp;
        }catch(Exception e){
            
        }

        System.debug('LIMITEEE2:::'+Limits.getQueries());
        Negocio__c nuevo= new Negocio__c(IdOportunidadOPAM__c = 422, IdCuentaOPAM__c = 12, EmailCSV__c = 'car@gmail.com', PantallaIntermediaCodigos__c = '30,3,50');
        insert nuevo;
        System.debug('LIMITEEE3:::'+Limits.getQueries());
        List<ContratoFilial__c> lin=new List<ContratoFilial__c>();
        lin.add(new ContratoFilial__c(CodigoAS400__c=contrato2.CodigoAS400__c, Name = contrato2.CodigoAS400__c ,Contrato_2__c = contrato2.Id, Entidad_Cuenta__c = contrato2.Entidad_Cuenta__c, IsPrime__c=true));
        lin.add(new ContratoFilial__c(CodigoAS400__c='11-11-12345-123', Name = contrato2.CodigoAS400__c ,Contrato_2__c = contrato2.Id, Entidad_Cuenta__c = contrato2.Entidad_Cuenta__c, IsPrime__c=false));
        insert lin;
        System.debug('LIMITEEE4:::'+Limits.getQueries());
        opp.StageName = 'Implementación';
        opp.CodigoClienteAS400__c = '1234';
        update opp;
        //update new Contrato2__c(Id=contrato2.Id,CustomersCreatedAs400__c=true);
        Test.stopTest();
    }

    @isTest
    public static void metodo2(){
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND Profile.Name='Administrador del sistema' AND IsActive = true ORDER BY Name LIMIT 1];
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        System.runAs(uAdmin){
            Map<String,ID> userRolesMap = new Map<String,ID>();
            for (UserRole userRole : [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_de_Administracion_de_Ventas')]) userRolesMap.put(userRole.DeveloperName, userRole.Id);

            //CUSTOM SETTING/
            List<ContadorRegistros_CS__c> contador = new List<ContadorRegistros_CS__c>();
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_OPAM', NumeroRegistro__c = -1));
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_Edenred', NumeroRegistro__c = -1));
            insert contador;
            
            User usuarioADV = new User(LastName = 'ADV', Email = 'adv@amamama.com', Username = 'adv@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Altas de Cliente', FiltroAsignacion_MSPL__c = 'Clientes OPAM;Clientes Edenred', UserRoleId = userRolesMap.get('Ejecutivo_de_Administracion_de_Ventas'), isActive = true);
            insert usuarioADV;
        }
        
        User u = new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;

        List<sObject> objs = new List<sObject>();

        Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        

        Id pricebookId = Test.getStandardPricebookId();
        
        //insert Product2
        Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        Product2 p2 = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ecovale Combustible Edenred Diesel', ProductCode = '60-D', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        //insert Account
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');

        objs.add(pr);
        objs.add(p);
        objs.add(p2);
        objs.add(acc);
        insert objs;
        objs.clear();

        Id pricebookId2 = pr.Id;

        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false, OwnerId = u.Id, IdEjecutivoADV__c = u.Id);

        //insert Contact
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        Contact cont2 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        Contact cont3 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');

        //insert PricebookEntry
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId2, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);

        //insert Concepto__c
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 2.2);
        Concepto__c c2 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p2.Id, Importe__c = 3.3);
        Concepto__c c3 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 4.4);
        Concepto__c c4 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 5.5);
        
        objs.add(opp);
        objs.add(cont);
        objs.add(cont2);
        objs.add(cont3);
        objs.add(pbe);
        objs.add(pbe2);
        objs.add(c);
        objs.add(c1);
        objs.add(c2);
        objs.add(c3);
        objs.add(c4);
        insert objs;
        objs.clear();

        //insert Quote
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe2.Id, ServiceDate = System.today().addDays(5));

        //insert QuoteLineItem 
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));       

        //insert ProductoComparado__c
        ProductoComparado__c pc = new ProductoComparado__c(ProductoCotizado__c = qli.Id, ProductoComparado__c = p2.Id);
        
        //insert ProductoConcepto__c
        ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon2 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon3 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon4 = new ProductoConcepto__c(Concepto__c = c3.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        ProductoConcepto__c pcon5 = new ProductoConcepto__c(Concepto__c = c4.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        
        Precio_Litro__c pl=new Precio_Litro__c(Precio_por_litro__c=1);
        insert pl;
        
        String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';

        Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);

        List<Quote> objQoute = (List<Quote>)mapaR1.get('Instance_Quote');
        List<Database.UpsertResult> objQouteLineItem = (List<Database.UpsertResult>)mapaR1.get('Upsert_QuoteLineItem');
        List<Database.UpsertResult> objProductoComparado = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoComparado__c');
        List<Database.UpsertResult> objProductoConcepto = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoConcepto__c');
        
        QuoteLineItem qli3 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));
        QuoteLineItem qli4 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));

        QuoteLineItem qli5 = qli.clone(false,false,false,false);
        insert qli3;
        
        ProductoConcepto__c pcon6 = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon7 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon8 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);

        objs.add(pcon6);
        objs.add(pcon7);
        objs.add(pcon8);
        insert objs;

        String mapeoJSON1 = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","OpportunityId": "'+opp.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días","Id": "'+objQoute[0].Id+'"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Id": "'+objQouteLineItem[0].getId()+'","Escalonamiento1__c": true}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'","Id": "'+objProductoComparado[0].getId()+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[0].getId()+'"},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[1].getId()+'"},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[2].getId()+'"},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[3].getId()+'"},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[4].getId()+'"}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';

        opp.Description = 'Comentario de prueba';
        update opp;
        
        Attachment attOpp1 = new Attachment (parentId = opp.Id, Name = 'Contrato o Propuesta firmados', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp2 = new Attachment (parentId = opp.Id, Name = 'Id. de Cliente', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp3 = new Attachment (parentId = opp.Id, Name = 'Registro Patronal', Body = Blob.valueOf('Blah Blah'));
        List<Attachment> listaAtt = new List<Attachment>();
        listaAtt.add(attOpp1);
        listaAtt.add(attOpp2);
        listaAtt.add(attOpp3);
        insert listaAtt;

        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(new ContentVersion(Title = 'Contrato o Propuesta firmados', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Id. de Cliente', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Registro Patronal', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        insert cvs;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        List<ContentDocumentLink> lcdl = new List<ContentDocumentLink>();
        for( ContentDocument cd : documents) {
            lcdl.add(new ContentDocumentLink(LinkedEntityId = opp.Id, ContentDocumentId = cd.Id, ShareType = 'V'));
        }
        insert lcdl;

        System.debug('LIMITEEE:::'+Limits.getQueries());
        //qli.Id = (Id) result.get('Upsert_QuoteLineItem').get(0).get('id');
        Test.startTest();
        EntidadLegal__c el=new EntidadLegal__c(RFC__c='HIJD93061278A',Name='HIJD93061278A');
        insert el;
        EntidadCuenta__c ec=new EntidadCuenta__c(Cuenta__c=Acc.Id,Name='HIJD93061278A',EntidadLegal__c=el.Id);
        insert ec;
        List<QuoteLineItem> listQlis = [SELECT Id FROM QuoteLineItem WHERE Quote.OpportunityId =: opp.Id];
        Contrato2__c contrato2 = new Contrato2__c(EtapaContrato__c='Finalizado',PartidaPresupuesto__c = listQlis[0].Id, CodigoAS400__c = '11-11-12345-122', Personalizacion_de_Tarjetas__c = true);
        insert contrato2;
        
        CatalogoDirecciones__c direccion = new CatalogoDirecciones__c();
        direccion.Calle_Tt__c = 'Lago Alberto';
        direccion.Ciudad_Tt__c = 'CDMX';
        direccion.CodigoPostal_Tt__c = '11420';
        direccion.Colonia_Tt__c = 'Polanco';
        direccion.CuentaID__c = acc.Id;
        direccion.DelegacionMunicipio_Tt__c = 'Miguel Hidalgo';
        direccion.Estado_Tt__c = 'CDMX';
        direccion.Name = 'Lago Alberto';
        direccion.Tipo_Pt__c ='Cuenta';
        insert direccion;
        
        Contrato_Direccion__c condir = new Contrato_Direccion__c();
        condir.ContratoID__c = contrato2.Id;
        condir.DireccionID__c = direccion.Id;
        insert condir;
        System.debug('LIMITEEE2:::'+Limits.getQueries());
        Negocio__c nuevo= new Negocio__c(IdOportunidadOPAM__c = 422, IdCuentaOPAM__c = 12, EmailCSV__c = 'car@gmail.com', PantallaIntermediaCodigos__c = '30,3,50');
        insert nuevo;
        System.debug('LIMITEEE3:::'+Limits.getQueries());
        List<ContratoFilial__c> lin=new List<ContratoFilial__c>();
        lin.add(new ContratoFilial__c(CodigoAS400__c=contrato2.CodigoAS400__c, Name = contrato2.CodigoAS400__c ,Contrato_2__c = contrato2.Id, Entidad_Cuenta__c = ec.Id, IsPrime__c=true));
        lin.add(new ContratoFilial__c(CodigoAS400__c='11-11-12345-123', Name = contrato2.CodigoAS400__c ,Contrato_2__c = contrato2.Id, Entidad_Cuenta__c = ec.Id, IsPrime__c=false));
        insert lin;
        Test.stopTest();
    }

    @isTest
    static void metodoPrueba2() {
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND Profile.Name='Administrador del sistema' AND IsActive = true ORDER BY Name LIMIT 1];
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        System.runAs(uAdmin){
            Map<String,ID> userRolesMap = new Map<String,ID>();
            for (UserRole userRole : [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_de_Administracion_de_Ventas')]) userRolesMap.put(userRole.DeveloperName, userRole.Id);

            //CUSTOM SETTING/
            List<ContadorRegistros_CS__c> contador = new List<ContadorRegistros_CS__c>();
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_OPAM', NumeroRegistro__c = -1));
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_Edenred', NumeroRegistro__c = -1));
            insert contador;
            
            User usuarioADV = new User(LastName = 'ADV', Email = 'adv@amamama.com', Username = 'adv@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Altas de Cliente', FiltroAsignacion_MSPL__c = 'Clientes OPAM;Clientes Edenred', UserRoleId = userRolesMap.get('Ejecutivo_de_Administracion_de_Ventas'), isActive = true);
            insert usuarioADV;
        }
        
        User u = new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;

        List<sObject> objs = new List<sObject>();

        Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        

        Id pricebookId = Test.getStandardPricebookId();
        
        //insert Product2
        Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        Product2 p2 = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ecovale Combustible Edenred Diesel', ProductCode = '60-D', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        //insert Account
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');

        objs.add(pr);
        objs.add(p);
        objs.add(p2);
        objs.add(acc);
        insert objs;
        objs.clear();

        Id pricebookId2 = pr.Id;

        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false, OwnerId = u.Id, IdEjecutivoADV__c = u.Id);

        //insert Contact
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        Contact cont2 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        Contact cont3 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');

        //insert PricebookEntry
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId2, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);

        //insert Concepto__c
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 2.2);
        Concepto__c c2 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p2.Id, Importe__c = 3.3);
        Concepto__c c3 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 4.4);
        Concepto__c c4 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 5.5);
        
        objs.add(opp);
        objs.add(cont);
        objs.add(cont2);
        objs.add(cont3);
        objs.add(pbe);
        objs.add(pbe2);
        objs.add(c);
        objs.add(c1);
        objs.add(c2);
        objs.add(c3);
        objs.add(c4);
        insert objs;
        objs.clear();

        //insert Quote
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe2.Id, ServiceDate = System.today().addDays(5));

        //insert QuoteLineItem 
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));       

        //insert ProductoComparado__c
        ProductoComparado__c pc = new ProductoComparado__c(ProductoCotizado__c = qli.Id, ProductoComparado__c = p2.Id);
        
        //insert ProductoConcepto__c
        ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon2 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon3 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon4 = new ProductoConcepto__c(Concepto__c = c3.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        ProductoConcepto__c pcon5 = new ProductoConcepto__c(Concepto__c = c4.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        
        Precio_Litro__c pl=new Precio_Litro__c(Precio_por_litro__c=1);
        insert pl;
        
        String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';

        Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);

        List<Quote> objQoute = (List<Quote>)mapaR1.get('Instance_Quote');
        List<Database.UpsertResult> objQouteLineItem = (List<Database.UpsertResult>)mapaR1.get('Upsert_QuoteLineItem');
        List<Database.UpsertResult> objProductoComparado = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoComparado__c');
        List<Database.UpsertResult> objProductoConcepto = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoConcepto__c');
        
        QuoteLineItem qli3 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));
        QuoteLineItem qli4 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));

        QuoteLineItem qli5 = qli.clone(false,false,false,false);
        insert qli3;
        
        ProductoConcepto__c pcon6 = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon7 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon8 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);

        objs.add(pcon6);
        objs.add(pcon7);
        objs.add(pcon8);
        insert objs;
        System.debug('LIMITEEE1:::'+Limits.getQueries());
        String mapeoJSON1 = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","OpportunityId": "'+opp.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días","Id": "'+objQoute[0].Id+'"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Id": "'+objQouteLineItem[0].getId()+'","Escalonamiento1__c": true}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'","Id": "'+objProductoComparado[0].getId()+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[0].getId()+'"},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[1].getId()+'"},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[2].getId()+'"},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[3].getId()+'"},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[4].getId()+'"}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';
        
        opp.Description = 'Comentario de prueba';
        update opp;
        
        Attachment attOpp1 = new Attachment (parentId = opp.Id, Name = 'Contrato o Propuesta firmados', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp2 = new Attachment (parentId = opp.Id, Name = 'Id. de Cliente', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp3 = new Attachment (parentId = opp.Id, Name = 'Registro Patronal', Body = Blob.valueOf('Blah Blah'));
        List<Attachment> listaAtt = new List<Attachment>();
        listaAtt.add(attOpp1);
        listaAtt.add(attOpp2);
        listaAtt.add(attOpp3);
        insert listaAtt;

        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(new ContentVersion(Title = 'Contrato o Propuesta firmados', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Id. de Cliente', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Registro Patronal', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        insert cvs;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        List<ContentDocumentLink> lcdl = new List<ContentDocumentLink>();
        for( ContentDocument cd : documents) {
            lcdl.add(new ContentDocumentLink(LinkedEntityId = opp.Id, ContentDocumentId = cd.Id, ShareType = 'V'));
        }
        insert lcdl;
        
        List<QuoteLineItem> listQlis = [SELECT Id FROM QuoteLineItem WHERE Quote.OpportunityId =: opp.Id];
        System.debug('LIMITEEE:::'+Limits.getQueries());
        Test.startTest();
        Contrato2__c contrato2 = new Contrato2__c(EtapaContrato__c='Finalizado',PartidaPresupuesto__c = listQlis[0].Id, CodigoAS400__c = '11-11-12345-122', Personalizacion_de_Tarjetas__c = true);
        insert contrato2;
        System.debug('LIMITEEE3.3:::'+Limits.getQueries());
        CatalogoDirecciones__c direccion = new CatalogoDirecciones__c();
        direccion.Calle_Tt__c = 'Lago Alberto';
        direccion.Ciudad_Tt__c = 'CDMX';
        direccion.CodigoPostal_Tt__c = '11420';
        direccion.Colonia_Tt__c = 'Polanco';
        direccion.CuentaID__c = acc.Id;
        direccion.DelegacionMunicipio_Tt__c = 'Miguel Hidalgo';
        direccion.Estado_Tt__c = 'CDMX';
        direccion.Name = 'Lago Alberto';
        direccion.Tipo_Pt__c ='Cuenta';
        
        insert direccion;
        
        Contrato_Direccion__c condir = new Contrato_Direccion__c();
        condir.ContratoID__c = contrato2.Id;
        condir.DireccionID__c = direccion.Id;
        insert condir;
        System.debug('LIMITEEE23:::'+Limits.getQueries());
        try{
            opp.StageName = 'Contrato';
            opp.CloseDate=Date.today();
            update opp;
            System.debug('LIMITEEE02:::'+Limits.getQueries());
            //opp.StageName = 'Alta de cliente';
            //update opp;
        }catch(Exception e){
            
        }
        System.debug('LIMITEEE2:::'+Limits.getQueries());
        Negocio__c nuevo= new Negocio__c(IdOportunidadOPAM__c = 422, IdCuentaOPAM__c = 12, EmailCSV__c = 'car@gmail.com', PantallaIntermediaCodigos__c = '30,3,50');
        insert nuevo;
        Test.stopTest();
    }

    @isTest
    static void metodoPrueba3() {
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND Profile.Name='Administrador del sistema' AND IsActive = true ORDER BY Name LIMIT 1];
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        System.runAs(uAdmin){
            Map<String,ID> userRolesMap = new Map<String,ID>();
            for (UserRole userRole : [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_de_Administracion_de_Ventas')]) userRolesMap.put(userRole.DeveloperName, userRole.Id);

            //CUSTOM SETTING
            List<ContadorRegistros_CS__c> contador = new List<ContadorRegistros_CS__c>();
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_OPAM', NumeroRegistro__c = -1));
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_Edenred', NumeroRegistro__c = -1));
            insert contador;
            
            User usuarioADV = new User(LastName = 'ADV', Email = 'adv@amamama.com', Username = 'adv@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Altas de Cliente', FiltroAsignacion_MSPL__c = 'Clientes OPAM;Clientes Edenred', UserRoleId = userRolesMap.get('Ejecutivo_de_Administracion_de_Ventas'), isActive = true);
            insert usuarioADV;
        }
        
        User u = new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;

        List<sObject> objs = new List<sObject>();

        Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        

        Id pricebookId = Test.getStandardPricebookId();
        
        //insert Product2
        Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        Product2 p2 = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ecovale Combustible Edenred Diesel', ProductCode = '60-D', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        //insert Account
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');

        objs.add(pr);
        objs.add(p);
        objs.add(p2);
        objs.add(acc);
        insert objs;
        objs.clear();

        Id pricebookId2 = pr.Id;

        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false, OwnerId = u.Id, IdEjecutivoADV__c = u.Id);

        //insert Contact
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId2, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        
        objs.add(cont);
        objs.add(opp);
        objs.add(pbe);
        objs.add(pbe2);
        insert objs;
        objs.clear();

        //insert Quote
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);
        insert quot;
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe2.Id, ServiceDate = System.today().addDays(5));
        insert oli;
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));        
        insert qli; 
        
        //Test de clase EscalonamientosOportunidad_CONT
        QuoteLineItem ql=[Select id,UnitPrice,ServiceDate,Escalonamiento__c,Quote.OpportunityId from QuoteLineItem where Id=:qli.Id];
        EscalonamientosOportunidad_CONT.getDatos('00d2345677654rf');
        List<QuoteLineItem> lq=new List<QuoteLineItem>();
        lq.add(ql);
        EscalonamientosOportunidad_CONT.guardarDatos(JSON.serialize(lq),'');
        Delete qli;
    }

    @isTest
    static void metodoPrueba4() {
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Ventas' LIMIT 1];
        UserRole role = [SELECT Id FROM UserRole WHERE Name = 'Ejecutivo Trademarketing' LIMIT 1];
        User u= new User(UserRoleId=role.Id,LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;
        Profile profBP = [SELECT Id FROM Profile WHERE Name = 'BPfleet Sales' LIMIT 1];
        UserRole roleBP = [SELECT Id FROM UserRole WHERE Name = 'Ejecutivo BP FS' LIMIT 1];
        User uBP= new User(UserRoleId=roleBP.Id,LastName = 'lastt', Email = 'puser0t00@amamama.com', Username = 'puser0t00@amamama.com' + System.currentTimeMillis(), CompanyName = 'TESTw', Title = 'titlee', Alias = 'aliasTes', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profBP.Id);
        insert uBP;
        Account acc;EntidadLegal__c el;EntidadCuenta__c ec;
        
        System.runAs(u){
             acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert acc;
            insert new AccountShare(AccountId=acc.Id,UserOrGroupId=uBP.Id,AccountAccessLevel='Read',ContactAccessLevel='None',CaseAccessLevel='None',OpportunityAccessLevel='None');
             el=new EntidadLegal__c(RFC__c='HIJD93061278A',Name='HIJD93061278A',Estatus__c='Completa');
            insert el;
             ec=new EntidadCuenta__c(Cuenta__c=Acc.Id,Name='HIJD93061278A',EntidadLegal__c=el.Id);
            insert ec;
            Opportunity opp=new Opportunity(Familia__c='Combustible',Name='BP',AccountId=acc.Id,Entidad_Cuenta__c=ec.Id,CloseDate=Date.today().addMonths(1),StageName='Cotización',RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('BPfleet').getRecordTypeId());
            insert opp;
        }
        
        Test.startTest();        
        System.runAs(uBP){
            Opportunity opp=new Opportunity(Familia__c='Combustible',Name='BP',AccountId=acc.Id,CloseDate=Date.today().addMonths(1),StageName='Cotización',RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('BPfleet').getRecordTypeId());
            insert opp;
            opp.Entidad_Cuenta__c=ec.Id;
            update opp;
            SolicitarAprobacionBPfleet_CONT.getInfo(opp.Id);
            SolicitarAprobacionBPfleet_CONT.solicitarAprobacion(opp.Id);
        }
        Test.stopTest();
    }

    @isTest
    static void metodoPrueba5() {
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND Profile.Name='Administrador del sistema' AND IsActive = true ORDER BY Name LIMIT 1];
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        System.runAs(uAdmin){
            Id accrecor = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();    
            Account account = new Account(
                Name = 'PRUEBA FLUJO',
                Type = 'Prospecto',
                RecordTypeId = accrecor,
                BillingCountry = 'Mexico',
                BillingCountryCode = 'MX',
                ShippingCountry = 'Mexico',
                ShippingCountryCode = 'MX',
                Phone = '1234567890',
                Calle__c = 'RODOLFO',
                Ciudad__c = 'Ciudad de México',
                CodigoClienteAS400__c = '12345',
                CodigoPostal__c = '11520',
                Colonia__c = 'Ampliacion Granada',
                DelegacionMunicipioFiscal__c = 'Miguel Hidalgo',
                Estado__c = 'Ciudad de México',
                NumeroExterior__c = '123',
                Sector__c = 'Privado',
                ClienteComplejo__c = false,
                NumeroEmpleados__c = '1-25',
                Nombre_Grupo_AS400__c = 'FREEWAY',
                RegimenFiscal__c = false,
                Giro__c = 'Comercio al por mayor',
                Subgiro__c = 'Com. al por mayor de camiones y de partes y refacciones nuevas',
                esConversionLead_Checkbox__c = false,
                Estatus_actualizacion__c = 'No contactado',
                UpdatedLastOrder__c = false);
            insert account;
            
            Contact contact = new Contact(
                AccountId = account.Id,
                LastName = 'America',
                FirstName = 'Capitan',
                Salutation = 'Sra.',
                OtherCountry = 'Mexico',
                OtherCountryCode = 'MX',
                MailingCountry = 'Mexico',
                MailingCountryCode = 'MX',
                Phone = '1234567890',
                Email = 'sinay.perez@edenred.com',
                //OwnerId = '005610000015qIXAAY',
                HasOptedOutOfEmail = false,
                HasOptedOutOfFax = false,
                DoNotCall = false,
                Activo__c = true,
                CopiarDireccionCuenta__c = false,
                Extranjero__c = false,
                Funcion__c = 'Representante Legal',
                Curp__c = 'PEGD911226MMCRYN04',
                FM3__c = false,
                isCurp__c = false,
                legal_id__c = false);
            insert contact;
            
            Id ELrecor = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId();
            EntidadLegal__c entidadlegal = new EntidadLegal__c(
                Name = 'PEGD121212E34',
                RecordTypeId = ELrecor,
                ActaConstitutivaCliente__c = false,
                AltaSHCP__c = false,
                CURP__c = false,
                Calle__c = 'RODOLFO',
                CodigoPostal__c = '11520',
                Colonia__c = 'Ampliacion Granada',
                ComprobanteDomicilioCliente__c = false,
                //Cuenta__c = account.Id,
                DelegacionMunicipioFiscal__c = 'Miguel Hidalgo',
                Direccion_Cuenta__c = false,
                Estado__c = 'Ciudad de México',
                Estatus__c = 'Completa',
                FM3__c = false,
                IdentificacionOficialCliente__c = false,
                NumeroExterior__c = '123',
                PoderNotarial__c = false,
                RazonSocial__c = 'FILIAL 1 AVENGERS',
                RegistroPatronal__c = false,
                RFCDoc__c = false,
                CargaInicial__c = false);
            insert entidadlegal;
            
            EntidadCuenta__c entidadcuenta = new EntidadCuenta__c(
                Name = 'PEGD121212E34',
                Cuenta__c = account.Id,
                EntidadLegal__c = entidadlegal.id,
                RFC_IDExterno__c = 'PEGD121212E34',
                isActive__c = false);
            insert entidadcuenta;
            
            Id migracionRrcdt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Migración').getRecordTypeId(); 
            Opportunity opp=new Opportunity(
                Name='BP',
                Familia__c='Ticket Restaurante',
                Producto_cotizacion__c='71-Ticket Restaurante Red Máxima CHIP CARNET (HT)',
                AccountId=account.Id,
                Entidad_Cuenta__c=entidadcuenta.Id,
                CloseDate=Date.today().addMonths(1),
                StageName='Cotización',
                Modify_opportunity__c=true,
                RecordTypeId=migracionRrcdt
            );
            insert opp;
            
            Opportunity opp4=new Opportunity(
                Name='BP',
                Familia__c='Ticket Restaurante',
                Producto_cotizacion__c='71-Ticket Restaurante Red Máxima CHIP CARNET (HT)',
                AccountId=account.Id,
                //Entidad_Cuenta__c=,
                CloseDate=Date.today().addMonths(1),
                StageName='Contrato',
                RecordTypeId=migracionRrcdt
            );
            insert opp4;
            
            Id ventaRrcdt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta nueva').getRecordTypeId();
            Opportunity opp2=new Opportunity(
                Name='BP',
                Familia__c='Ticket Restaurante',
                Producto_cotizacion__c='71-Ticket Restaurante Red Máxima CHIP CARNET (HT)',
                AccountId=account.Id,
                Entidad_Cuenta__c=entidadcuenta.Id,
                CloseDate=Date.today().addMonths(1),
                StageName='Cotización',
                RecordTypeId=ventaRrcdt
            );
            insert opp2;
  
            Id bpFleetRrcdt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BPfleet').getRecordTypeId();
             Opportunity opp5=new Opportunity(
                Name='BP',
                Familia__c='Ticket Restaurante',
                Producto_cotizacion__c='71-Ticket Restaurante Red Máxima CHIP CARNET (HT)',
                AccountId=account.Id,
                Entidad_Cuenta__c=entidadcuenta.Id,
                CloseDate=Date.today().addMonths(1),
                StageName='Contrato',
                RecordTypeId=bpFleetRrcdt
            );
            insert opp5;

        Opportunity opportunity = new Opportunity(
            AccountId = account.Id,
            RecordTypeId = ventaRrcdt,
            IsPrivate = false,
            Name = '223821-PRUEBA FLUJO - Despensa',
            StageName = 'Implementación',
            Amount = 12000.0,
            TotalOpportunityQuantity = 1.0,
            CloseDate = Date.newInstance(2019,11,27),
            LeadSource = 'Cambaceo',
            ForecastCategoryName = 'Commit',
            Familia__c = 'Despensa',
            Motivo__c = 'Contacto no quiso atender',
            TimestampContrato__c = DateTime.newInstance(2019,11,27,20,1225,73535),
            TimestampCotizacion__c = DateTime.newInstance(2019,11,19,23,1400,84003),
            TimestampImplementacion__c = DateTime.newInstance(2019,11,27,20,1226,73567),
            FechaUltimaActividad__c = DateTime.newInstance(2019,11,19,23,1406,84360),
            CantidadTarjetas__c = 1200.0,
            ActaConstitutivaCliente__c = false,
            AdjuntoA__c = false,
            AltaSHCP__c = false,
            CURP__c = false,
            CedulaRFC__c = false,
            CodigoClienteAS400__c = '01-32-12345-001',
            Codigo_Producto_cotizacion__c = '32',
            Competidor__c = 'Amex',
            ComprobanteDomicilioCliente__c = false,
            ComprobanteDomicilioFiscal__c = false,
            ConstanciaRFCCliente__c = false,
            ConstanciaRFC__c = false,
           
            ContratoFirmado__c = false,
            DocCompletos__c = false,
            EjecutivoADV__c = 'Juan Oswaldo Espinoza Rivas',
            Entidad_Cuenta__c = entidadcuenta.Id,
            Entidad_Legal__c = entidadlegal.Id,
            EnvioCSVOPAM__c = false,
            EnvioXMLTC30__c = false,
            Es_OPAM__c = false,
            Estatus__c = 'Cerrada',
            FM3__c = false,
            FechaFinADV__c = DateTime.newInstance(2019,11,19,23,1407,84422),
            FechaInicioADV__c = DateTime.newInstance(2019,11,19,23,1406,84360),
           // IdEjecutivoADV__c = User,
            IdentificacionOficialCliente__c = false,
            IdentificacionOficialVigente__c = false,
            NumeroAltaCliente__c = '16225',
            PoderNotarial__c = false,
            Producto_cotizacion__c = '32-Vale Despensas Red Premium chip',
            Rechazo_validaci_n_descuentos__c = false,
            RegistroPatronal__c = false,
            Solicitar_validaci_n_descuentos__c = false,
            VentaTrademarketing_Checkbox__c = false,
            isCelulaCitas__c = false,
            isConverted__c = false,
            Comentarios_Ejecutivo__c = 'Test',
            Maquila__c = false,
            //Contrato2__c = 'a0lR0000005UmrMIAS',
            TipoVenta__c = 'Simple',
            BPfleetApproval__c = false,
            bloqueoLP__c = false);
            Test.startTest(); 
            insert opportunity;
           
            Opportunity opportunity2 = new Opportunity(
                AccountId = account.Id,
                RecordTypeId = ventaRrcdt,
                IsPrivate = false,
                Name = '223896-PRUEBA FLUJO - Despensa',
                StageName = 'Contrato',
                CloseDate = Date.newInstance(2019,11,28),
                LeadSource = 'Cambaceo',
                ForecastCategoryName = 'Pipeline',
                //OwnerId = '005R0000004R1LxIAK',
                Familia__c = 'Despensa',
                TimestampContrato__c = DateTime.newInstance(2019,11,28,16,986,59191),
                TimestampCotizacion__c = DateTime.newInstance(2019,11,28,16,982,58979),
                FechaUltimaActividad__c = DateTime.newInstance(2019,11,28,18,1080,64800),
                ActaConstitutivaCliente__c = false,
                AdjuntoA__c = false,
                AltaSHCP__c = false,
                CURP__c = false,
                CedulaRFC__c = false,
                Competidor__c = 'Amex',
                ComprobanteDomicilioCliente__c = false,
                ComprobanteDomicilioFiscal__c = false,
                ConstanciaRFCCliente__c = false,
                ConstanciaRFC__c = false,
                Contacto__c = contact.Id,
                ContratoFirmado__c = false,
                DocCompletos__c = false,
                EjecutivoADV__c = 'Juan Oswaldo Espinoza Rivas',
                Entidad_Cuenta__c = entidadcuenta.Id,
                EnvioCSVOPAM__c = false,
                EnvioXMLTC30__c = false,
                Es_OPAM__c = false,
                FM3__c = false,
                FechaFinADV__c = DateTime.newInstance(2019,11,28,18,1080,64800),
                FechaInicioADV__c = DateTime.newInstance(2019,11,28,18,1080,64800),
                IdentificacionOficialCliente__c = false,
                IdentificacionOficialVigente__c = false,
                NumeroAltaCliente__c = '16225',
                PoderNotarial__c = false,
                Producto_cotizacion__c = '32-Vale Despensas Red Premium chip',
                Rechazo_validaci_n_descuentos__c = false,
                RegistroPatronal__c = false,
                Solicitar_validaci_n_descuentos__c = false,
                VentaTrademarketing_Checkbox__c = false,
                isCelulaCitas__c = false,
                isConverted__c = false,
                Comentarios_Ejecutivo__c = 'test',
                Maquila__c = false,
                TipoVenta__c = 'Simple',
                BPfleetApproval__c = false,
                bloqueoLP__c = false);
            insert opportunity2;
            
            Id incrementoRrcdt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Upselling (Incremento)').getRecordTypeId();
            Opportunity opp3=new Opportunity(
                Name='BP',
                Familia__c='Ticket Restaurante',
                Contacto__c=contact.Id,
                Motivo_incremento__c='Estacionalidad',
                Volumen_incremento__c=100.00,
                AccountId=account.Id,
                Entidad_Cuenta__c=entidadcuenta.Id,
                CloseDate=Date.today().addMonths(1),
                StageName='Planeada',
                RecordTypeId=incrementoRrcdt
            );
            insert opp3;
                
            TriggerOpportunityHandler.ValidateOpDuplicadedIncremento(opp3);   
        
            Test.stopTest();
        }
    }
    
    @isTest
    static void modificarOpotunidadTest(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        User u = new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;

        List<sObject> objs = new List<sObject>();

        Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        

        //Insert Account
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');

        objs.add(pr);
        objs.add(acc);
        insert objs;
        
        Id pricebookId2 = pr.Id;

        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,
                                          StageName = 'Planeada', CloseDate = System.today().addDays(5),
                                          Solicitar_validaci_n_descuentos__c = false, OwnerId = u.Id, IdEjecutivoADV__c = u.Id);
        insert opp;
        opp.StageName = 'Perdida';
        String errorMessage = '';
        Test.startTest();
        try {
            update opp;
        } catch(Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();
        System.assert(errorMessage.contains('No puede modificar la oportunidad en esta etapa'));
    }
    
    //Coverage to validateRFCSolcionAssignment method.
    @isTest
    static void validateRFCSolcionAssignmentTest(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        UserRole uRol = [SELECT Id FROM UserRole WHERE Name = 'Ejecutivo EB Metro' LIMIT 1];

        List<User> testUsers = new List<User>();
        User u = new User(UserRoleId = uRol.Id, LastName = 'last', Email = 'usertestadmin@amamama.com', Username = 'usertestadmin@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        User u2 = new User(LastName = 'last2', Email = 'usertestadmin2@amamama.com', Username = 'usertestadmin2@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias2', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
		testUsers.add(u);
        testUsers.add(u2);
        insert testUsers;
        System.runAs(u){
            List<sObject> objs = new List<sObject>();
            
            Pricebook2 pr = new Pricebook2(Name = 'Edenred', isActive = true);        
            
            Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            
            EntidadLegal__c el = new EntidadLegal__c(RFC__c = 'HIJD93061278A', Name = 'HIJD93061278A');

            Product2 prod = new Product2(Family = 'Vestimenta', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta', IsActive = true);

            objs.add(pr);
            objs.add(acc);
            objs.add(el);
            objs.add(prod);
            insert objs;
            
            Id pricebookId = pr.Id;
            EntidadCuenta__c ec = new EntidadCuenta__c(Cuenta__c = acc.Id, Name = 'HIJD93061278A', EntidadLegal__c = el.Id);
            insert ec;
            ContratoFilial__c contrato = new ContratoFilial__c(OwnerId = u2.Id, Producto__c = prod.Id, CodigoAS400__c = '123', Name = '123' , Entidad_Cuenta__c = ec.Id, IsPrime__c = true);
            insert contrato ;
            
            Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId,
                                              StageName = 'Planeada', CloseDate = System.today().addDays(5),
                                              Solicitar_validaci_n_descuentos__c = false, OwnerId = u.Id, IdEjecutivoADV__c = u.Id,
                                              Entidad_Cuenta__c = ec.Id, Familia__c = 'Vestimenta');
           
            String errorMessage = '';
            Test.startTest();
            try {
            	insert opp;
            } catch(Exception e) {
                errorMessage = e.getMessage();
            }
            Test.stopTest();
            System.assert(errorMessage.contains('Ya existe un ejecutivo asignado para ese RFC en esa solución.'));
        }
    }

    //Coverage to ownerBUValidation method.
    @isTest
    static void ownerBUValidationTest(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator' LIMIT 1];
        UserRole roleFleetAndMobility = [SELECT Id FROM UserRole WHERE Name = 'KAMs Fleet&Mobility' LIMIT 1];
        UserRole roleEBMetro = [SELECT Id FROM UserRole WHERE Name = 'Ejecutivo EB Metro' LIMIT 1];
        
        List<User> testUsers = new List<User>();
        User userFleet = new User(LastName = 'last', Email = 'usertestadmin@amamama.com', Username = 'usertestadmin@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, UserRoleId = roleFleetAndMobility.Id );
        User userMantenimiento = new User(LastName = 'last2', Email = 'usertestadmin2@amamama.com', Username = 'usertestadmin2@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias2', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, UserRoleId = roleEBMetro.Id);
        testUsers.add(userFleet);
        testUsers.add(userMantenimiento);
        insert testUsers;
        
        System.runAs(userMantenimiento){
            List<sObject> objs = new List<sObject>();
            
            Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        
            
            //Insert Account
            Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            
            objs.add(pr);
            objs.add(acc);
            insert objs;
            
            //Insert Opportunity
            Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pr.Id,
                                              StageName = 'Planeada', CloseDate = System.today().addDays(5),
                                              Solicitar_validaci_n_descuentos__c = false, Familia__c = 'Ayuda Social',
                                              OwnerChangeRequired__c = true);
            insert opp;
            opp.OwnerId = userFleet.Id;
            String errorMessage = '';
            Test.startTest();
            try {
                update opp;
            } catch(Exception e) {
                errorMessage = e.getMessage();
            }
            Test.stopTest();
            System.assert(errorMessage.contains('El ejecutivo asignado no corresponde a la business unit relacionada a la solución asociada a la oportunidad.'));
        }
    }
    
    @isTest
    static void sendPartnersAndAliancesMailTest(){
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND Profile.Name='Administrador del sistema' AND IsActive = true ORDER BY Name LIMIT 1];
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        System.runAs(uAdmin){
            Map<String,ID> userRolesMap = new Map<String,ID>();
            for (UserRole userRole : [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_de_Administracion_de_Ventas')]) userRolesMap.put(userRole.DeveloperName, userRole.Id);

            //CUSTOM SETTING/
            List<ContadorRegistros_CS__c> contador = new List<ContadorRegistros_CS__c>();
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_OPAM', NumeroRegistro__c = -1));
            contador.add(new ContadorRegistros_CS__c(Name = 'ADV_Edenred', NumeroRegistro__c = -1));
            insert contador;
            
            User usuarioADV = new User(LastName = 'ADV', Email = 'adv@amamama.com', Username = 'adv@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Altas de Cliente', FiltroAsignacion_MSPL__c = 'Clientes OPAM;Clientes Edenred', UserRoleId = userRolesMap.get('Ejecutivo_de_Administracion_de_Ventas'), isActive = true);
            insert usuarioADV;
        }
        
        User u = new User(LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        insert u;

        List<sObject> objs = new List<sObject>();

        Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        

        Id pricebookId = Test.getStandardPricebookId();
        
        //insert Product2
        Product2 p = new Product2(Family = 'Despensa', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        Product2 p2 = new Product2(Family = 'Despensa', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ecovale Combustible Edenred Diesel', ProductCode = '60-D', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        //insert Account
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');

        objs.add(pr);
        objs.add(p);
        objs.add(p2);
        objs.add(acc);
        insert objs;
        objs.clear();
        
        Id pricebookId2 = pr.Id;
        
        //insert Contact
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
		insert cont;
        
        //insert Opportunity
        Opportunity opp = new Opportunity(Contacto__c = cont.Id ,PartnersAliances__c = 'Acceso a salario ya trabajado - Minu', Familia__c = 'Despensa', RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('VentaNueva').getRecordTypeId(), AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false, OwnerId = u.Id, IdEjecutivoADV__c = u.Id);

        Contact cont2 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
        Contact cont3 = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');

        //insert PricebookEntry
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId2, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);

        //insert Concepto__c
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 2.2);
        Concepto__c c2 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p2.Id, Importe__c = 3.3);
        Concepto__c c3 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 4.4);
        Concepto__c c4 = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 5.5);
        
        objs.add(opp);
        objs.add(cont2);
        objs.add(cont3);
        objs.add(pbe);
        objs.add(pbe2);
        objs.add(c);
        objs.add(c1);
        objs.add(c2);
        objs.add(c3);
        objs.add(c4);
        insert objs;
        objs.clear();

        //insert Quote
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe2.Id, ServiceDate = System.today().addDays(5));

        //insert QuoteLineItem 
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));       

        //insert ProductoComparado__c
        ProductoComparado__c pc = new ProductoComparado__c(ProductoCotizado__c = qli.Id, ProductoComparado__c = p2.Id);
        
        //insert ProductoConcepto__c
        ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon2 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon3 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon4 = new ProductoConcepto__c(Concepto__c = c3.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        ProductoConcepto__c pcon5 = new ProductoConcepto__c(Concepto__c = c4.Id, ProductoComparadoID__c = pc.Id,EsProductoComparado__c = true);
        
        Precio_Litro__c pl=new Precio_Litro__c(Precio_por_litro__c=1);
        insert pl;
        
        String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Despensa","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';

        Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);

        List<Quote> objQoute = (List<Quote>)mapaR1.get('Instance_Quote');
        List<Database.UpsertResult> objQouteLineItem = (List<Database.UpsertResult>)mapaR1.get('Upsert_QuoteLineItem');
        List<Database.UpsertResult> objProductoComparado = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoComparado__c');
        List<Database.UpsertResult> objProductoConcepto = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoConcepto__c');
        
        QuoteLineItem qli3 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));
        QuoteLineItem qli4 = new QuoteLineItem(Escalonamiento__c = objQouteLineItem[0].getId(), Quantity = 3, UnitPrice = 44, QuoteId = objQoute[0].Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));

        QuoteLineItem qli5 = qli.clone(false,false,false,false);
        insert qli3;
        
        ProductoConcepto__c pcon6 = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon7 = new ProductoConcepto__c(Concepto__c = c1.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);
        ProductoConcepto__c pcon8 = new ProductoConcepto__c(Concepto__c = c2.Id, PartidaPresupuesto__c = qli3.Id,EsProductoComparado__c = false);

        objs.add(pcon6);
        objs.add(pcon7);
        objs.add(pcon8);
        insert objs;

        String mapeoJSON1 = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","OpportunityId": "'+opp.Id+'","Familia__c": "Despensa","VigenciaCotizacion__c": "7 días","Id": "'+objQoute[0].Id+'"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Id": "'+objQouteLineItem[0].getId()+'","Escalonamiento1__c": true}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'","Id": "'+objProductoComparado[0].getId()+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[0].getId()+'"},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[1].getId()+'"},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[2].getId()+'"},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[3].getId()+'"},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[4].getId()+'"}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';

        opp.Description = 'Comentario de prueba';
        update opp;
        
        Attachment attOpp1 = new Attachment (parentId = opp.Id, Name = 'Contrato o Propuesta firmados', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp2 = new Attachment (parentId = opp.Id, Name = 'Id. de Cliente', Body = Blob.valueOf('Blah Blah'));
        Attachment attOpp3 = new Attachment (parentId = opp.Id, Name = 'Registro Patronal', Body = Blob.valueOf('Blah Blah'));
        List<Attachment> listaAtt = new List<Attachment>();
        listaAtt.add(attOpp1);
        listaAtt.add(attOpp2);
        listaAtt.add(attOpp3);
        insert listaAtt;

        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(new ContentVersion(Title = 'Contrato o Propuesta firmados', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Id. de Cliente', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Registro Patronal', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        insert cvs;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        List<ContentDocumentLink> lcdl = new List<ContentDocumentLink>();
        for( ContentDocument cd : documents) {
            lcdl.add(new ContentDocumentLink(LinkedEntityId = opp.Id, ContentDocumentId = cd.Id, ShareType = 'V'));
        }
        insert lcdl;

        List<QuoteLineItem> listQlis = [SELECT Id FROM QuoteLineItem WHERE Quote.OpportunityId =: opp.Id];
        Contrato2__c contrato2 = new Contrato2__c(EtapaContrato__c='Finalizado',PartidaPresupuesto__c = listQlis[0].Id, CodigoAS400__c = '11-11-12345-122', Personalizacion_de_Tarjetas__c = true);
        insert contrato2;
        Test.startTest();
        CatalogoDirecciones__c direccion = new CatalogoDirecciones__c();
        direccion.Calle_Tt__c = 'Lago Alberto';
        direccion.Ciudad_Tt__c = 'CDMX';
        direccion.CodigoPostal_Tt__c = '11420';
        direccion.Colonia_Tt__c = 'Polanco';
        direccion.CuentaID__c = acc.Id;
        direccion.DelegacionMunicipio_Tt__c = 'Miguel Hidalgo';
        direccion.Estado_Tt__c = 'CDMX';
        direccion.Name = 'Lago Alberto';
        direccion.Tipo_Pt__c ='Cuenta';
        
        insert direccion;
        
        Contrato_Direccion__c condir = new Contrato_Direccion__c();
        condir.ContratoID__c = contrato2.Id;
        condir.DireccionID__c = direccion.Id;
        insert condir;
        
        try{
            opp.StageName = 'Alta de cliente';
            update opp;
        }catch(Exception e){
            
        }

        Negocio__c nuevo= new Negocio__c(IdOportunidadOPAM__c = 422, IdCuentaOPAM__c = 12, EmailCSV__c = 'car@gmail.com', PantallaIntermediaCodigos__c = '30,3,50');
        insert nuevo;
        List<ContratoFilial__c> lin=new List<ContratoFilial__c>();
        lin.add(new ContratoFilial__c(CodigoAS400__c=contrato2.CodigoAS400__c, Name = contrato2.CodigoAS400__c ,Contrato_2__c = contrato2.Id, Entidad_Cuenta__c = contrato2.Entidad_Cuenta__c, IsPrime__c=true));
        lin.add(new ContratoFilial__c(CodigoAS400__c='11-11-12345-123', Name = contrato2.CodigoAS400__c ,Contrato_2__c = contrato2.Id, Entidad_Cuenta__c = contrato2.Entidad_Cuenta__c, IsPrime__c=false));
        insert lin;
        opp.StageName = 'Implementación';
        opp.CodigoClienteAS400__c = '1234';
        update opp;
        Test.stopTest();
        List<Task> emailSend = [Select Id, Subject FROM Task WHERE WhatId =: opp.Id AND Subject Like '%: Alianza Edenred%'];
		System.assert(!emailSend.isEmpty(), 'El correo fue enviado');
    }

}