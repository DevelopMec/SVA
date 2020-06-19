@isTest
public class AltaContrato_CONT_TEST {
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
    public static void metodo1(){
        QuoteLineItem qli=[Select Id from QuoteLineItem limit 1];
        AltaContrato_CONT.getInfoPlantilla(qli.Id);
        Test.startTest();
        AltaContrato_CONT.getInfoQli(qli.Id);
        Opportunity opp=[Select Id from Opportunity limit 1];
        AltaContrato_CONT.VerificaEstatusEvaluacionCredito(opp.Id);
        
        Delete [Select Id from ContractSection__c];
        AltaContrato_CONT.getInfoPlantilla(qli.Id);
        Test.stopTest();
    }
    @isTest
    public static void metodo2(){
        
        Account ac=[Select Id from Account where Name = 'Cuenta prueba' limit 1];
        Contact con = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con;
        System.debug('LIMIT1::'+Limits.getQueries());
        EntidadLegal__c el=new EntidadLegal__c(Estatus__c='Completa',Cuenta__c=ac.Id,RazonSocial__c='test',Name='HIJD93061278A',RFC__c='HIJD93061278A',RecordTypeId=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId());
        insert el;
        System.debug('LIMIT2::'+Limits.getQueries());
        EntidadCuenta__c ec=[Select Id from EntidadCuenta__c where Cuenta__c=:ac.Id and EntidadLegal__c=:el.Id];
        ContactoEntidad__c ce=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con.Id);
        insert ce;
        System.debug('LIMIT3::'+Limits.getQueries());
        
        Contact con2 = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba2', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con2;
        System.debug('LIMIT4::'+Limits.getQueries());
        ContactoEntidad__c ce2=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con2.Id);
        insert ce2;
        System.debug('LIMIT5::'+Limits.getQueries());
        QuoteLineItem qli=[Select Id from QuoteLineItem limit 1];
        Test.startTest();
        Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2; 
                        
        System.debug('LIMIT6::'+Limits.getQueries());
        ContratoFilial__c cf=new ContratoFilial__c(Contrato_2__c=c2.Id,Name='01-30-42424-323',CodigoAS400__c='01-30-42424-323');
        Affiliate__c  af=new Affiliate__c (Contract_2__c=c2.Id,Name='01-30-42424-323',codeAS400__c ='01-30-42424-323');
        insert cf;
        System.debug('LIMIT7::'+Limits.getQueries());
        List<OpportunityContactRole__c> lop=[Select Id from OpportunityContactRole__c];
        
        
        
        
        AltaContrato_CONT.getInfoPlantilla(qli.Id);
        AltaContrato_CONT.getInfoQli(qli.Id);
        AltaContrato_CONT.guardarInfo( c2, '', new list<String>() , false, null);
        Contrato2__c c2Te=[Select Id,PartidaPresupuesto__r.Quote.OpportunityId,PartidaPresupuesto__r.Quote.Opportunity.OwnerId from Contrato2__c where Id=:c2.Id];        
        AltaContrato_CONT.generarAfiliados(c2Te, new List<Affiliate__c>{af});
        AltaContrato_CONT.getEstablecimientosRefresh(ac.Id,c2Te.Id);
        AltaContrato_CONT.getMetodosPago(ac.Id);
        //AltaContrato_CONT.guardarInfo(lop, c2, new List<ContratoFilial__c>());
        c2.Id=null;
        //AltaContrato_CONT.guardarInfo(new List<OpportunityContactRole__c>(), c2, new List<ContratoFilial__c>());
        Test.stopTest();
    }
    @isTest
    public static void metodoAltaCliente(){
        new CreditEvaluation();
        Account ac=[Select Id from Account where Name = 'Cuenta prueba' limit 1];
        Contact con = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con;
        EntidadLegal__c el=new EntidadLegal__c(Estatus__c='Completa',Cuenta__c=ac.Id,RazonSocial__c='test',Name='HIJD93061278A',RFC__c='HIJD93061278A',RecordTypeId=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId());
        insert el;
        EntidadCuenta__c ec=[Select Id from EntidadCuenta__c where Cuenta__c=:ac.Id and EntidadLegal__c=:el.Id];
        ContactoEntidad__c ce=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con.Id);
        insert ce;
        
        Contact con2 = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba2', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con2;
        ContactoEntidad__c ce2=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con2.Id);
        insert ce2;
        Test.startTest(); 
        QuoteLineItem qli=[Select Id,Quote.OpportunityId from QuoteLineItem limit 1];
        Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2;
        ContratoFilial__c cf=new ContratoFilial__c(Contrato_2__c=c2.Id,Name='01-30-42424-323',CodigoAS400__c='01-30-42424-323');
        insert cf;
        List<OpportunityContactRole__c> lop=[Select Id from OpportunityContactRole__c];
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='TOK-AC');
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='AC');
       
		Test.setMock(HttpCalloutMock.class, new AltaCliente_WS_Mock(1));
        CON_ContractsContainer_CTRL.generarClientesAs400(c2.Id, qli.Id, qli.Quote.OpportunityId);
        CreateCustomerResponse r=new CreateCustomerResponse();
        CreateCustomerResponse.mensajesDTO msj=new CreateCustomerResponse.mensajesDTO();
        msj.code='';
        msj.level='';
        msj.text='';
        CreateCustomerResponse.ErrorDTO err=new CreateCustomerResponse.ErrorDTO();
        err.Status='';
        err.messages=new List<CreateCustomerResponse.mensajesDTO>{msj};
        CreateCustomerResponse.OperationDTO op=new CreateCustomerResponse.OperationDTO();
        op.espada_code='';
        op.folio='';
        op.process_date='';
        op.user_ref='';
        r.data=op;
        r.meta=err;
        Test.stopTest();
    }
    @isTest
    public static void metodoAltaCliente2(){
        
        Account ac=[Select Id from Account where Name = 'Cuenta prueba' limit 1];
        Contact con = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con;
        EntidadLegal__c el=new EntidadLegal__c(Estatus__c='Completa',Cuenta__c=ac.Id,RazonSocial__c='test',Name='HIJD93061278A',RFC__c='HIJD93061278A',RecordTypeId=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId());
        insert el;
        EntidadCuenta__c ec=[Select Id from EntidadCuenta__c where Cuenta__c=:ac.Id and EntidadLegal__c=:el.Id];
        ContactoEntidad__c ce=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con.Id);
        insert ce;
        
        Contact con2 = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba2', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con2;
        ContactoEntidad__c ce2=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con2.Id);
        insert ce2;
        
        QuoteLineItem qli=[Select Id,Quote.OpportunityId from QuoteLineItem limit 1];
        Test.startTest();
        Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2;
          
        ContratoFilial__c cf=new ContratoFilial__c(Contrato_2__c=c2.Id,Name='01-30-42424-323',CodigoAS400__c='01-30-42424-323');
        insert cf;
        List<OpportunityContactRole__c> lop=[Select Id from OpportunityContactRole__c];
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='TOK-AC');
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='AC');
              	
		Test.setMock(HttpCalloutMock.class, new AltaCliente_WS_Mock(2));
        CON_ContractsContainer_CTRL.generarClientesAs400(c2.Id, qli.Id, qli.Quote.OpportunityId);
        CON_ContractsContainer_CTRL.generarClientesAs400(c2.Id, qli.Id, qli.Quote.OpportunityId);
        AltaContrato_CONT.getInfoSendEmail(c2.Id);
        Test.stopTest();
    }
    @isTest
    public static void testTokenAltaCliente(){
        Test.startTest();        	
		Test.setMock(HttpCalloutMock.class, new AltaCliente_WS_Mock(3));
        AltaCliente_WS.getToken('endPoint', 'clientId', 'clientSecret', 'grantType', 'scope');
    }
    @isTest
    public static void getGruposPrime(){
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='GRPRIMETOK');
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='GRPRIME');        
        Test.startTest();        	
		Test.setMock(HttpCalloutMock.class, new GetGruposPrime_Mock(2));
        AltaContrato_CONT.getGruposPrime('30','1234');
        Test.stopTest();
    }
    @isTest
    public static void getGruposPrime2(){
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='GRPRIMETOK');
        insert new WSCredentials__c(EndPoint__c='test',ClientId__c='test',ClientSecret__c='test',Scope__c='test',GrantType__c='test',Name='GRPRIME');        
        Test.startTest();        	
		Test.setMock(HttpCalloutMock.class, new GetGruposPrime_Mock(1));
        AltaContrato_CONT.getGruposPrime('30','1234');
        Test.stopTest();
    }
    @isTest
    public static void validacionesADC(){        
        Account ac=[Select Id from Account where Name = 'Cuenta prueba' limit 1];
        Contact con = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con;
        EntidadLegal__c el=new EntidadLegal__c(Estatus__c='Completa',Cuenta__c=ac.Id,RazonSocial__c='test',Name='HIJD93061278A',RFC__c='HIJD93061278A',RecordTypeId=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId());
        insert el;
        EntidadCuenta__c ec=[Select Id from EntidadCuenta__c where Cuenta__c=:ac.Id and EntidadLegal__c=:el.Id];
        ContactoEntidad__c ce=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con.Id);
        insert ce;
        Contact con2 = new Contact(Phone='6354737654',CURP__c='AAPD940930HGRMNY09',LastName = 'Contacto prueba2', AccountId = ac.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal');   
        insert con2;
        ContactoEntidad__c ce2=new ContactoEntidad__c(Entidad_Cuenta__c=ec.Id,Contacto__c=con2.Id);
        insert ce2;
        Test.startTest(); 
        QuoteLineItem qli=[Select Id,Quote.OpportunityId from QuoteLineItem limit 1];
        Opportunity opp=[Select Id from Opportunity where Id=:qli.Quote.OpportunityId];
        Contrato2__c c2 = new Contrato2__c(CodigoAS400__c='01-30-16474-001',PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2;
        List<CON_ContractsContainer_CTRL.Sub> li=new List<CON_ContractsContainer_CTRL.Sub>();
        CON_ContractsContainer_CTRL.Sub tm=new CON_ContractsContainer_CTRL.Sub();
        tm.Name='01-30-16474-002';
        tm.CodigoAS400='01-30-16474-002';
        li.add(tm);
        CON_ContractsContainer_CTRL.updateContratoADV2(JSON.serialize(c2), JSON.serialize(opp), JSON.serialize(li));
        Contrato2__c c3 = new Contrato2__c(PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c3;
        c3.CodigoAS400__c='01-30-16474-001';
        CON_ContractsContainer_CTRL.updateContratoADV2(JSON.serialize(c3), JSON.serialize(opp), JSON.serialize(li));
    }
    @isTest
    public static void CON_ContractContainer_CTRL_Tes(){
        Account ac=[Select Id from Account where Name = 'Cuenta prueba' limit 1];
        CON_ContractsContainer_CTRL.getEntidadCuenta(ac.Id);
        QuoteLineItem qli=[Select Id ,Quote.OpportunityId from QuoteLineItem limit 1];
        Opportunity opp=[Select Id from Opportunity where Id=:qli.Quote.OpportunityId];
        Test.startTest();
                        
        EntidadLegal__c el=new EntidadLegal__c(Estado__c='test',Ciudad__c='test',Colonia__c='test',NumeroInterior__c='7',Estatus__c='Completa',Cuenta__c=ac.Id,RazonSocial__c='test',Name='HIJD93061278A',RFC__c='HIJD93061278A',RecordTypeId=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId());
        insert el;
        System.debug('LIMIT2::'+Limits.getQueries());
        EntidadCuenta__c ec=[Select Id from EntidadCuenta__c where Cuenta__c=:ac.Id and EntidadLegal__c=:el.Id];
        Contrato2__c c2 = new Contrato2__c(Entidad_Legal__c=el.Id,Entidad_Cuenta__c=ec.Id,PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2;  
        ContratoFilial__c cf=new ContratoFilial__c(Entidad_Cuenta__c=ec.id,Contrato_2__c=c2.Id,Name='01-30-42424-323',CodigoAS400__c='01-30-42424-323');
        Affiliate__c  af=new Affiliate__c (Contract_2__c=c2.Id,Name='01-30-42424-323',codeAS400__c ='01-30-42424-323');
        insert cf;
        insert af;
        ContratoFilial__c cf2=[Select Id,Entidad_Cuenta__r.EntidadLegal__r.Estado__c,Entidad_Cuenta__r.EntidadLegal__r.Ciudad__c,Entidad_Cuenta__r.EntidadLegal__r.Colonia__c,Entidad_Cuenta__r.EntidadLegal__r.CodigoPostal__c,Entidad_Cuenta__r.EntidadLegal__r.NumeroInterior__c,Entidad_Cuenta__r.EntidadLegal__r.NumeroExterior__c,Entidad_Cuenta__r.EntidadLegal__r.Calle__c,Entidad_Cuenta__r.EntidadLegal__r.Name,Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c,CodigoAS400__c from ContratoFilial__c where Id=:cf.Id];
        CON_ContractsContainer_CTRL.Sub st=new CON_ContractsContainer_CTRL.Sub();
        st.Name='test';
        st.CodigoAS400='01-30-42424-324';
        List<CON_ContractsContainer_CTRL.Sub> lt=new List<CON_ContractsContainer_CTRL.Sub>{st};        
        CON_ContractsContainer_CTRL.generaXMLExtras(qli.Quote.OpportunityId, c2.Id, new List<ContratoFilial__c>{cf2},JSON.serialize(lt));
        CON_ContractsContainer_CTRL.updateContratoAfiliadoADV2(JSON.serialize(c2), JSON.serialize(new Opportunity(Id=qli.Quote.OpportunityId)), JSON.serialize(lt));
        sObject ob=cf;
        ob.put('Id',af.Id);
        String idFil=JSON.serialize(new List<sObject>{ob});
        
        CON_ContractsContainer_CTRL.saveS400FilialesAfiliados(idFil);
    }
}