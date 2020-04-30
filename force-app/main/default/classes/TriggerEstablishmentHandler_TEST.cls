@isTest
public class TriggerEstablishmentHandler_TEST {
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
        Opportunity opp = new Opportunity(OwnerId=UserInfo.getUserId(),IsApprovedCreditEval__c='No',AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today());                
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
        Test.stopTest();
    }
    @isTest
    public static void metodo2(){
        Account ac=[Select Id from Account where Name = 'Cuenta prueba' limit 1];
        Contact con = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con;
        EntidadLegal__c el=new EntidadLegal__c(Estatus__c='Completa',Cuenta__c=ac.Id,RazonSocial__c='test',Name='JFHD635463KJ8',RFC__c='JFHD635463KJ8',RecordTypeId=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId());
        insert el;
        EntidadCuenta__c ec=[Select Id from EntidadCuenta__c where Cuenta__c=:ac.Id and EntidadLegal__c=:el.Id];
        ContactoEntidad__c ce=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con.Id);
        insert ce;
        Contact con2 = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba2', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con2;
        ContactoEntidad__c ce2=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con2.Id);
        insert ce2;
        QuoteLineItem qli=[Select Id from QuoteLineItem limit 1];
        Test.startTest();
        Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2;
        Establishment__c es=new Establishment__c(Contract__c =c2.Id,Name='test', Account__c=ac.Id);
        insert es;
        Affiliate__c  af=new Affiliate__c (Contract_2__c=c2.Id,Name='01-30-42424-323',codeAS400__c ='01-30-42424-323');
        insert af;
    }
}