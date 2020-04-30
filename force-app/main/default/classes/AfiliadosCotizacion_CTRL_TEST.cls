@isTest
public class AfiliadosCotizacion_CTRL_TEST {
    @testSetup
    public static void setup(){
        Test.startTest();
        List<sObject> objs = new List<sObject>();
        Pricebook2 pE=new Pricebook2(Name ='Edenred',IsActive=true);
        insert pE;
        Id pricebookId = Test.getStandardPricebookId();        
        Product2 p = new Product2(QuoteFields__c='IsPaper__c;affiliateProduct__c',IsAffiliate__c=true,IsActive=true,Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 4.0', ProductCode = '30-TC4', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta');
        Product2 pT = new Product2(QuoteFields__c='IsPaper__c;affiliateProduct__c',IsAffiliate__c=true,IsActive=true,Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta');
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');        
        objs.add(pT);
        objs.add(p);
        objs.add(acc);        
        insert objs;        
        objs.clear();         
        Opportunity opp = new Opportunity(Familia__c='Combustible',IsApprovedCreditEval__c='No',AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today());                
        Contact cont = new Contact(Phone='6354737654',LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Quien administra Plataforma');   
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true,UseStandardPrice=false);       
        objs.add(pbe);
        PricebookEntry pbeSec = new PricebookEntry(Pricebook2Id = pE.Id, Product2Id = p.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        objs.add(pbeSec);
        PricebookEntry pbeP = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pT.Id, UnitPrice = 10000, IsActive = true,UseStandardPrice=false);       
        objs.add(pbeP);
        PricebookEntry pbeSecP = new PricebookEntry(Pricebook2Id = pE.Id, Product2Id = pT.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        objs.add(pbeSecP);
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1,FieldText__c='CargoRefactura__c');
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 1.2);
        objs.add(opp);
        objs.add(cont);
        objs.add(c);
        objs.add(c1);        
        insert objs;
        Test.stopTest();
    }        
	@isTest
    public static void metodo1(){
        AfiliadosCotizacion_CTRL.crearCotizacion(new Quote(), new QuoteLineItem(), 'create');
        AfiliadosCotizacion_CTRL.getQuote('');
    }
    @isTest
    public static void metodo2(){
        Pricebook2 p=new Pricebook2(Name ='Edenred');
        insert p;
        AfiliadosCotizacion_CTRL.crearCotizacion(new Quote(), new QuoteLineItem(), 'create');
    }
    @isTest
    public static void metodo3(){
        Id pricebookId = Test.getStandardPricebookId(); 
        Opportunity opp=[Select Id from Opportunity limit 1];
        Contact cont=[Select Id from Contact limit 1];
        Concepto__c c=[Select Id from Concepto__c limit 1];
        Product2 p=[Select Id from Product2 where Name='Ticket Car 4.0' limit 1];
        Product2 pT=[Select Id from Product2 where Name='Ticket Car 3.0' limit 1];
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);               
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, Product2Id = p.Id, ServiceDate = System.today().addDays(5));                     
        
              
        AfiliadosCotizacion_CTRL.crearCotizacion(quot, qli, 'create');
        ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id,PrecioFinal__c=1);
        insert pcon;
        Test.startTest(); 
        AfiliadosCotizacion_CTRL.guardarTarifas(qli.Id, new List<ProductoConcepto__c>{pcon}, new Contrato2__c(Name='test',PartidaPresupuesto__c=qli.Id));
        QuoteLineItem qli2 = new QuoteLineItem(Id=qli.Id,Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, Product2Id = pT.Id, ServiceDate = System.today().addDays(5));                     
        AfiliadosCotizacion_CTRL.crearCotizacion(quot, qli2, 'update');
        AfiliadosCotizacion_CTRL.guardarTarifas(qli.Id, new List<ProductoConcepto__c>{pcon}, new Contrato2__c());        
        AfiliadosCotizacion_CTRL.getInfo(opp.Id);
        Test.stopTest();
    }
}