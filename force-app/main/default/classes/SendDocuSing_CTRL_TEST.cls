@isTest
public class SendDocuSing_CTRL_TEST {
    @testSetup
    public static void setup(){
        Test.startTest();
        insert new GeneralCatalog__c(Key__c='POS-AC',value__c='12');
        PlantillaContrato__c pc=new PlantillaContrato__c(Name='Contrato Ticket Car 4.0');
        insert pc;
        List<ContractSection__c> lisSecc=new List<ContractSection__c>();
        lisSecc.add(new ContractSection__c(Name='Facturación', ContractTemplate__c=pc.Id, SectionFields__c='ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;FrecuenciaFacturacion__c;Sucursal_Facturacion_Global__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c;Otros_correos__c;Modo_Transaccion__c', RequiredFields__c='ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;FrecuenciaFacturacion__c;Sucursal_Facturacion_Global__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c', Dependencies__c='{"ComoFactura__c": { "Consolidador": ["Sucursal_Facturacion_Global__c",  "Cliente_Facturacion_Global__c" ], "Estructura Órganizacional": [ "CEO__c" ], "Grupo de Facturación": [ "CEO__c", "TipoCliente__c" ], "camposDependientesOcultar": [ "Sucursal_Facturacion_Global__c", "Cliente_Facturacion_Global__c", "CEO__c", "CEO__c", "TipoCliente__c" ] }}', DisabledFields__c='Facturacion_Cargos__c;Facturacion_Plasticos__c', Order__c=1));
        lisSecc.add(new ContractSection__c(Name='Facturación', ContractTemplate__c=pc.Id, SectionFields__c='TipoPago__c;Linea_Operativa__c;Frecuencia_Liberacion_Automatica__c;Ventana_de_Riesgos__c;MontoGarantia__c', RequiredFields__c='TipoPago__c', Dependencies__c='{"TipoPago__c": { "Pospago": [ "Linea_Operativa__c", "Frecuencia_Liberacion_Automatica__c", "Ventana_de_Riesgos__c", "MontoGarantia__c" ], "camposDependientesOcultar": [ "Linea_Operativa__c", "Frecuencia_Liberacion_Automatica__c", "Ventana_de_Riesgos__c", "MontoGarantia__c" ] } }', DisabledFields__c='Linea_Operativa__c;Frecuencia_Liberacion_Automatica__c;Ventana_de_Riesgos__c;MontoGarantia__c', Order__c=2));
        insert lisSecc;
        List<sObject> objs = new List<sObject>();
        Id pricebookId = Test.getStandardPricebookId();        
        Product2 p = new Product2(ContractTemplate__c=pc.Id,Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 4.0', ProductCode = '30-TC4', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta');
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');        
        objs.add(p);
        objs.add(acc);        
        insert objs;        
        objs.clear();        
        Opportunity opp = new Opportunity(IsApprovedCreditEval__c='No',AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today());                
        Contact cont = new Contact(Phone='6354737654',LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Quien administra Plataforma');   
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);        
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1,FieldText__c='CargoRefactura__c');
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 1.2);
        objs.add(opp);
        objs.add(cont);
        objs.add(pbe);
        objs.add(c);
        objs.add(c1);        
        insert objs;  
        insert new OpportunityContactRole__c(ContactId__c=cont.Id,OpportunityId__c=opp.Id,Role__c='Quien Decide');
        objs.clear();        
        
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);        
        objs.add(quot);        
        insert objs;  
        
        objs.clear();        
        opp.SyncedQuoteId = quot.Id;
        update opp; 
        Test.stopTest();
    }
    @isTest
    public static void metodo1(){
        Quote q=[Select Id,OpportunityId from Quote limit 1];
        SendDocuSing_CTRL.generarInformacion(q.OpportunityId);
        QuoteDocument qDocument = new QuoteDocument(QuoteId = q.Id, Document = EncodingUtil.base64Decode('1wsdfhvjku'));
        insert qDocument;
        q.IdPDFPropuestaComercial__c=qDocument.Id;
        update q;
        Opportunity opp=[Select Id from Opportunity limit 1];
        SendDocuSing_CTRL.generarInformacion(q.OpportunityId);        
        SendDocuSing_CTRL.generarInformacion(q.Id);
        opp.OwnerId=[Select Id from User where Profile.Name LIKE '%Ventas%' and isActive=true limit 1].Id;
        update opp;
        SendDocuSing_CTRL.generarInformacion(q.OpportunityId);
    }
}