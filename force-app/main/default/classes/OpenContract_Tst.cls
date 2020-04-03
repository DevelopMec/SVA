@isTest
public class OpenContract_Tst {
    
    @isTest
    public static void getQuoteItemId(){
        List<sObject> objs = new List<sObject>();
        Id pricebookId = Test.getStandardPricebookId();
        /*insert Product2*/
        Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta');

        /*insert Account*/
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');

        objs.add(p);
        objs.add(acc);

        insert objs;
        //System.debug('objs 1: ' + objs);
        objs.clear();

        /*insert Opportunity*/
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today());

        /*insert Contact*/
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Quien administra Plataforma');

        /*insert PricebookEntry*/
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        /*insert Concepto__c*/
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 1.2);
        objs.add(opp);
        objs.add(cont);
        objs.add(pbe);
        objs.add(c);
        objs.add(c1);

        insert objs;
        //System.debug('objs 2: ' + objs);
        objs.clear();

        /*insert Quote*/
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

        objs.add(quot);

        insert objs;
        //System.debug('objs 3: ' + objs);
        objs.clear();

        /*sincronize Quote to Opportunity */
        opp.SyncedQuoteId = quot.Id;
        update opp;

        /*insert QuoteLineItem */
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe.Id, Product2Id = p.Id, ServiceDate = System.today().addDays(5));

        objs.add(qli);

        insert objs;
        //System.debug('objs 4: ' + objs);
        objs.clear();
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe.Id, PartidaPresupuesto__c = qli.Id, ServiceDate = System.today().addDays(5));
        objs.add(oli);
        insert objs;
        objs.clear();
        /*insert ProductoComparado__c*/
        ProductoComparado__c pc = new ProductoComparado__c(ProductoCotizado__c = qli.Id, ProductoComparado__c = p.Id);

        /*insert ProductoConcepto__c*/
        ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id);
        ProductoConcepto__c pcon2 = new ProductoConcepto__c(Concepto__c = c1.Id, ProductoComparadoID__c = pc.Id);
        objs.add(pc);
        objs.add(pcon);
        objs.add(pcon2);
        insert objs;
        OpenContract.getQuoteItemId(opp.id);
    }
}