@isTest 
public without sharing class BatchSIGLO_Test {
    
    @testSetup
    public static void setup(){

        Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true, ProductCode = '222', SendToSIGLO__c = true, IDInterno__c = '29');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Account acc = new Account(Name = 'test');
        insert acc;

        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity oppFisica = new Opportunity(Name = 'oppFisica', StageName = 'Contrato', CloseDate = Date.Today(), Account = acc);
        oppList.add(oppFisica);

        Opportunity oppMoral = new Opportunity(Name = 'oppMoral', StageName = 'Contrato', CloseDate = Date.Today(), Account = acc);
        oppList.add(oppMoral);
        insert oppList;

        List<Quote> quoteList = new List<Quote>();
        Quote quoteFisica = new Quote(Name = 'test', OpportunityId = oppFisica.Id, Pricebook2Id = pricebookId, OperationsInDollars__c = 'Sí', TransactionsEstimatedNumber__c = 7);
        quoteList.add(quoteFisica);

        Quote quoteMoral = new Quote(Name = 'test', OpportunityId = oppMoral.Id, Pricebook2Id = pricebookId, TransactionsEstimatedNumber__c = 7);
        quoteList.add(quoteMoral);
        insert quoteList;

        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        QuoteLineItem qliFisica = new QuoteLineItem(QuoteId = quoteFisica.Id, PricebookEntryId = standardPrice.Id, Quantity = 3, UnitPrice = 3, Product2Id = prod.Id);
        qliList.add(qliFisica);

        QuoteLineItem qliMoral = new QuoteLineItem(QuoteId = quoteMoral.Id, PricebookEntryId = standardPrice.Id, Quantity = 3, UnitPrice = 3, Product2Id = prod.Id);
        qliList.add(qliMoral);
        insert qliList;

        Contact repLegal = new Contact(AccountId = acc.Id, LastName='sfsaf',Funcion__c = 'Representante Legal', Calle__c='callejon',Colonia__C='sanlorenzo',
                                       CodigoPostal__c='53426',Estado__c='Campeche',Ciudad__C='campeche', Curp__c = 'FEPM890204HASRRN08', Nationality__c = 'MEXICO', 
                                       Email = 'test@mail.com', Birthdate = Date.newInstance(1900, 01, 01), MaritalStatus__c = '003', Gender__c = 'Masculino', Phone = '1234');
        insert repLegal;
              
        Id pFisicaRecordTypeId = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();
        Id pMoralRecordTypeId = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Moral').getRecordTypeId();

        List<EntidadLegal__c> elList = new List<EntidadLegal__c>();
        EntidadLegal__c pFisica = new EntidadLegal__c(Name = 'CUPU800825569', CountryOrigin__c = 'MEXICO', 
                                                      RecordTypeId = pFisicaRecordTypeId, Estatus__c='Completa',
                                                      DeedDate__c = Date.newInstance(1900, 01, 01));
        elList.add(pFisica);

        EntidadLegal__c pMoral = new EntidadLegal__c(Name = 'CUU800825569', CountryOrigin__c = 'MEXICO', 
                                                     RecordTypeId = pMoralRecordTypeId, Estatus__c='Completa',
                                                     DeedDate__c = Date.newInstance(1900, 01, 01));
        elList.add(pMoral);
        insert elList;

        List<Contrato2__c> c2List = new List<Contrato2__c>();
        Contrato2__c contrato2Fisica = new Contrato2__c(Name = 'test', Contacto__c = repLegal.Id, PartidaPresupuesto__c = qliFisica.Id, Entidad_Legal__c = pFisica.Id);
        c2List.add(contrato2Fisica);

        Contrato2__c contrato2Moral = new Contrato2__c(Name = 'test', Contacto__c = repLegal.Id, PartidaPresupuesto__c = qliMoral.Id, Entidad_Legal__c = pMoral.Id);
        c2List.add(contrato2Moral);
        insert c2List;

        List<ContratoFilial__c> cfList = new List<ContratoFilial__c>();
        ContratoFilial__c cfFisico = new ContratoFilial__c(Name = 'test', Contrato_2__c = contrato2Moral.Id, isActive__c = true, Producto__c = prod.Id);
        cfList.add(cfFisico);

        ContratoFilial__c cfMoral = new ContratoFilial__c(Name = 'test', Contrato_2__c = contrato2Fisica.Id, isActive__c = true, Producto__c = prod.Id);
        cfList.add(cfMoral);
        insert cfList;

        /*List<EntidadCuenta__c> ecList = new List<EntidadCuenta__c>();
        EntidadCuenta__c ecMoral = new EntidadCuenta__c(Name = 'test', EntidadLegal__c = pMoral.Id, Cuenta__c = acc.Id);
        ecList.add(ecMoral);

        EntidadCuenta__c ecFisica = new EntidadCuenta__c(Name = 'test', EntidadLegal__c = pFisica.Id, Cuenta__c = acc.Id);
        ecList.add(ecFisica);
        insert ecList;

        List<ContactoEntidad__c> ceList = new List<ContactoEntidad__c>();
        /*ContactoEntidad__c ceMoral =  new ContactoEntidad__c(Entidad_Cuenta__c = ecMoral.Id, Contacto__c = repLegal.Id, Cuenta__c = acc.Id);
        ceList.add(ceMoral);

        ContactoEntidad__c ceFisica =  new ContactoEntidad__c(Entidad_Cuenta__c = ecFisica.Id, Contacto__c = repLegal.Id, Cuenta__c = acc.Id);
        ceList.add(ceFisica);
        insert ceList;*/

        oppFisica.Entidad_Legal__c = pFisica.Id;
        oppFisica.Contrato_Filial__c = cfFisico.Id;
        oppFisica.Amount = 3000000;
        //oppFisica.Entidad_Cuenta__c = ecFisica.Id;
        //oppFisica.StageName = 'Implementación';
        update oppFisica;

        oppMoral.Entidad_Legal__c = pMoral.Id;
        oppMoral.Contrato_Filial__c = cfMoral.Id;
        oppMoral.Amount = 3000000;
        //oppMoral.Entidad_Cuenta__c = ecMoral.Id;
        //oppMoral.StageName = 'Implementación';
        update oppMoral;

    }

    @isTest
    private static void DocumentsBatch(){
        BatchSIGLO_DocumentGenerator job = new BatchSIGLO_DocumentGenerator(0);

        Test.startTest();
        Id batchId = Database.executeBatch(job);
        Test.stopTest();
    }
    
    @isTest
    private static void DailyBatch(){
        BatchSIGLO_Daily job = new BatchSIGLO_Daily();

        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new SIGLO_CalloutMock());
        Id batchId = Database.executeBatch(job);
        Test.stopTest();
    }

}