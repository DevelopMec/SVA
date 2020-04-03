/**
* ───────────────────────────────────────────────────────────────────────────────────────────────────┐
* @change	26/12/2019 Method guardaCotizacionInsertAcutaliza modified to include the string
						quotData when calling guardaCotizacion. testSetup modified to create an user.
* ───────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
private class PLAN_CuentaServiceTest {
    @testSetup
    public static void testSetup(){
        UserRole r = new UserRole(DeveloperName = 'EjecutivoCross', Name = 'Ejecutivo Cross');
		insert r;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Administrador del Sistema' OR Name='System Administrator']; 
        User testUser = new User(Alias = 'testus', Email = 'test_user@testorg.com', 
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = r.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test_user@testorg.com', isActive = true);
        insert testUser;
        User testUser2 = new User(ManagerId = testUser.Id, Alias = 'test2', Email = 'test_user2@testorg.com', 
            EmailEncodingKey = 'UTF-8', LastName = 'Testing2', LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = r.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test_user2@testorg.com', isActive = true);
        insert testUser2;
        System.runAs(testUser){
            Precio_Litro__c pl=new Precio_Litro__c();
            pl.Precio_por_litro__c=20;
            insert pl;
        }
    }
    @isTest
    static void guardaCotizacionInsertAcutaliza() {
        User testUser2 = [SELECT Id FROM User WHERE Email = 'test_user2@testorg.com'];
        
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
        
        Id pricebookId2 = pr.Id;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        
        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false);
        
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
        System.runAs(testUser2) {
            insert objs;
        }
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
        
        Test.startTest();
        
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
        String quotData = '{"userComment":"Test comments","approvalLevel":3}';
        System.runAs(testUser2) {
        	PLAN_CuentaService.guardaCotizacion(mapeoJSON1, quotData);
        }        
        
        Test.stopTest();
        
        
    }
    
    @isTest
    static void guardaCotizacionInsertActalizaError() {
        User testUser = [SELECT Id FROM User WHERE Email = 'test_user@testorg.com'];
        
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
        
        Id pricebookId2 = pr.Id;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        
        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false);
        
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
        System.runAs(testUser) {
            insert objs;
        }
        Test.startTest();
        
        String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';
        //Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);
        String quotData = '{"userComment":"Test comments","approvalLevel":3}';
        System.runAs(testUser) {
            try {
            	PLAN_CuentaService.guardaCotizacion(mapeoJSON, quotData);
            } catch  (Exception e) {
                System.assert(e.getMessage().contains('El propietario del registro no cuenta con un gestor para que apruebe la solicitud de aprobación.'),'The user does not have maneger.');
            }
        }
        
        Test.stopTest();   
    }
    
    @isTest
    static void guardaCotizacionEscalamientos() {
        
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
        Id pricebookId2 = pr.Id;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        
        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false);
        
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
        
        //Test.startTest();
        
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
        Test.startTest();
        String mapeoJSON3 = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","OpportunityId": "'+opp.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días","Id": "'+objQoute[0].Id+'"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": true}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'","Id": "'+objProductoComparado[0].getId()+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[0].getId()+'"},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[1].getId()+'"},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[2].getId()+'"},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[3].getId()+'"},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[4].getId()+'"}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {"'+objQouteLineItem[0].getId()+'": 0}}';
        
        PLAN_CuentaService.guardaCotizacion(mapeoJSON3, null);
        
        Test.stopTest();
        
        
        
        
    }
    @isTest
    static void guardaCotizacionDeleteIds() {
        
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
        
        Id pricebookId2 = pr.Id;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        
        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false);
        
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
        
        Test.startTest();
        
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
        
        
        String mapeoJSON4 = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","OpportunityId": "'+opp.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días","Id": "'+objQoute[0].Id+'"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Id": "'+objQouteLineItem[0].getId()+'","Escalonamiento1__c": true}],"ProductoComparado__c": [{}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[0].getId()+'"},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[1].getId()+'"},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null,"Id":"'+objProductoConcepto[2].getId()+'"}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {},"Ids2Delete": {"QuoteLineItem": ["'+qli3.Id+'"],"ProductoConcepto__c": [],"ProductoComparado__c": ["'+objProductoComparado[0].getId()+'"]},"IdsConEscalonamiento": {}}';
        
        PLAN_CuentaService.guardaCotizacion(mapeoJSON4, null);
        
        Test.stopTest();
        
        
    }
    @isTest
    static void metodosExtra() {
        
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
        
        Id pricebookId2 = pr.Id;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        
        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false);
        
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
        
        Test.startTest();
        
        String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';
        
        Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);
        
        List<Quote> objQoute = (List<Quote>)mapaR1.get('Instance_Quote');
        List<Database.UpsertResult> objQouteLineItem = (List<Database.UpsertResult>)mapaR1.get('Upsert_QuoteLineItem');
        List<Database.UpsertResult> objProductoComparado = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoComparado__c');
        List<Database.UpsertResult> objProductoConcepto = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoConcepto__c');
        
        String[] pL = new String[2];
        pL[0] = p.Id;
        pL[1] = p2.Id;
        
        String up = '[{"Id": "'+acc.Id+'","Name":"Test"}]';     
        PLAN_CuentaService.upsertSobjects('Account', up);
        try {
            PLAN_CuentaService.upsertSobjects('Account', '[{"Id": "'+acc.Id+'","Name":"Test"}');
        } catch( Exception ex ) {}
        
        
        PLAN_CuentaService.query('SELECT Id, Name FROM Quote');
        
        
        String[] obL = new String[2];
        obL[0] = 'Account';
        obL[1] = 'Quote';
        PLAN_CuentaService.describe(obL);
        
        String[] idL = new String[2];
        idL[0] = cont2.Id;
        idL[1] = cont3.Id;
        PLAN_CuentaService.deleteIds(idL);
        
        PLAN_CuentaService.guardaAnexoE( objQouteLineItem[0].id, 'Testing base 64 encode' , '123');
        
        Test.stopTest();
        
    }
    @isTest
    static void guardaPDFBase64() {
        
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
        
        Id pricebookId2 = pr.Id;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        
        //insert Opportunity
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false);
        
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
        
        Test.startTest();
        
        String mapeoJSON = '{"Opportunity": {"Id": "'+opp.Id+'"},"Quote": {"ContactId": "'+cont.Id+'","Familia__c": "Combustible","VigenciaCotizacion__c": "7 días"},"QuoteLineItem": [{"Product2Id": "'+p.Id+'","CantidadTarjetas__c": 98,"Quantity": 1,"UnitPrice": 178,"FormaPago__c": "TransferenciaElectronica","OpcionesMetodoPago__c": "BBVA Bancomer","TarjetaAsociada__c": 987,"ClabeInterbancaria__c": "737237373728292101","TipoAmex__c": null,"NivelConsumo__c": null,"OtroMetodoPago__c": null,"Cantidad_Descuento__c": 1,"Total_Descuento__c": 3,"Escalonamiento1__c": false}],"ProductoComparado__c": [{"ProductoComparado__c": "'+p2.Id+'"}],"IndexProductoComparado": {"0":0},"ProductoConcepto__c": [{"Concepto__c": "'+c.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 3,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 3,"VigenciaDescuento__c": null},{"Concepto__c": "'+c1.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c2.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": false,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c3.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null},{"Concepto__c": "'+c4.Id+'","Bonificacion__c": 0,"PrecioLista2__c": 0,"EsProductoComparado__c": true,"CantidadTarjetas__c": 0,"PrecioFinal__c": 135,"VigenciaDescuento__c": null}],"IndexPConceptoCotizado": {"0": 0,"1": 0,"2": 0},"IndexPConceptoComparado": {"0":0,"1":0},"Ids2Delete": {"QuoteLineItem": [],"ProductoConcepto__c": [],"ProductoComparado__c": []},"IdsConEscalonamiento": {}}';
        
        Map<String, Object> mapaR1 = PLAN_CuentaService.guardaCotizacion(mapeoJSON, null);
        
        List<Quote> objQoute = (List<Quote>)mapaR1.get('Instance_Quote');
        List<Database.UpsertResult> objQouteLineItem = (List<Database.UpsertResult>)mapaR1.get('Upsert_QuoteLineItem');
        List<Database.UpsertResult> objProductoComparado = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoComparado__c');
        List<Database.UpsertResult> objProductoConcepto = (List<Database.UpsertResult>)mapaR1.get('Upsert_ProductoConcepto__c');
        
        
        
        string base64 = 'Testing base 64 encode';
        
        // create a blob from our parameter value before we send it as part of the url
        Blob beforeblob = Blob.valueOf(base64);
        
        PLAN_CuentaService.guardaPDFBase64(''+objQoute[0].Id,base64);
        
        Test.stopTest();
        
        
    }
    
    
    
    
    
}