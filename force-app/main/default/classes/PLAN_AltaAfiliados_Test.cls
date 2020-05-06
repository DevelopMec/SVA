@isTest
public class PLAN_AltaAfiliados_Test {
    
   @testSetup
    public static void testSetup(){
      
    }
    @isTest
    public static void test1(){
        Test.startTest();
        insert new GeneralCatalog__c(Key__c='POS-AC',value__c='12');
        PlantillaContrato__c pc=new PlantillaContrato__c(Name='Contrato Afiliados');
        insert pc;
        List<sObject> objs = new List<sObject>();
        Id pricebookId = Test.getStandardPricebookId();        
        Product2 p = new Product2(ContractTemplate__c=pc.Id,Family = 'Benefits', Familia__c = 'BE',IsAffiliate__c = true, Name = 'Restaurante - Afiliación', ProductCode = 'com-AF', SegmentoVenta__c = 'Key;Large;Medium;Small', ProductType__c = 'Afiliación',NombreSistemas__c = 'Comida - Afiliación');
        Account acc = new Account(Name = 'Cuenta Afiliados', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');        
        objs.add(p);
        objs.add(acc);        
        insert objs;        
        objs.clear();        
        Opportunity opp = new Opportunity(IsApprovedCreditEval__c='No',AccountId = acc.Id, Name = 'Prueba Afiliados', StageName = '	Pre Análisis', CloseDate = System.today());                
        Contact cont = new Contact(Phone='6354737654',LastName = 'Contacto Afiliados', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Quien administra Plataforma'); 
        Contact con = new Contact(Phone='6354737854',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto Afiliate', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');
        EntidadLegal__c el=new EntidadLegal__c(Estatus__c='Completa',Cuenta__c=acc.Id,RazonSocial__c='test',Name='HIJD93061278A',RFC__c='HIJD93061278A',RecordTypeId=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId());
        insert el;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);        
        Concepto__c c = new Concepto__c(TipoCargo__c = '% Participación Papel', Producto__c = p.Id, Importe__c = 4.0,FieldText__c='PercentagePaperParticipation__c',RecordTypeId=Schema.SObjectType.Concepto__c.getRecordTypeInfosByDeveloperName().get('Conceptos').getRecordTypeId());
        Concepto__c c1 = new Concepto__c(TipoCargo__c = '% Participación Electrónico', Producto__c = p.Id, Importe__c = 4.0,Obligatorio__c = true,RecordTypeId=Schema.SObjectType.Concepto__c.getRecordTypeInfosByDeveloperName().get('Conceptos').getRecordTypeId());
        objs.add(opp);
        objs.add(cont);
        objs.add(con);
        objs.add(pbe);
        objs.add(c);
        objs.add(c1);        
        insert objs; 
        objs.clear();
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);        
        objs.add(quot);        
        insert objs;        
        objs.clear();        
        opp.SyncedQuoteId = quot.Id;
        update opp;        
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe.Id, Product2Id = p.Id, ServiceDate = System.today().addDays(5));        
        objs.add(qli);        
        insert objs;        
        objs.clear();        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe.Id, PartidaPresupuesto__c = qli.Id, ServiceDate = System.today().addDays(5));
        objs.add(oli);
        insert objs;
        objs.clear();       
        ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id,PrecioFinal__c=1);
        objs.add(pcon);
        insert objs;
        objs.clear();
        Contrato2__c contract = new Contrato2__c(Name='contrato',PartidaPresupuesto__c=qli.Id);
        objs.add(contract);
        insert objs;
        objs.clear();
        Test.stopTest();
        PageReference pageRef = Page.PLAN_AltaAfiliadosDES_VF; // Add your VF page Name here
        pageRef.getParameters().put('contractId',contract.Id);
        Test.setCurrentPage(pageRef);
        PLAN_AltaAfiliados_Ctrl plan = new PLAN_AltaAfiliados_Ctrl();
        
    }

}