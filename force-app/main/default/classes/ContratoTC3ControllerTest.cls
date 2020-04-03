@isTest
private class ContratoTC3ControllerTest {
  /*  @isTest 
    static void testStandardUse() {

        //agrega calvarez 9mar2017 INICIO
        List<sObject> objs = new List<sObject>();
        Id pricebookId = Test.getStandardPricebookId();
        //insert Product2
        Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta');
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');

        objs.add(p);
        objs.add(acc);
        insert objs;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        //insert Opportunity
        Opportunity opp_c = new Opportunity(AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today());

        //insert Contact
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');

        ///insert PricebookEntry
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);

        //insert Concepto__c
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 1.2);
        objs.add(opp_c);
        objs.add(cont);
        objs.add(pbe);
        objs.add(c);
        objs.add(c1);

        insert objs;
        //System.debug('objs 2: ' + objs);
        objs.clear();

        //insert Quote
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp_c.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

        objs.add(quot);

        insert objs;
        //System.debug('objs 3: ' + objs);
        objs.clear();

        //sincronize Quote to Opportunity 
        opp_c.SyncedQuoteId = quot.Id;
        update opp_c;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp_c.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe.Id, ServiceDate = System.today().addDays(5));

        //insert QuoteLineItem 
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe.Id, Product2Id = p.Id, ServiceDate = System.today().addDays(5));

        objs.add(oli);
        objs.add(qli);

        insert objs;
        //agrega calvarez 9mar2017 FIN

        Producto__c producto = new 	Producto__c(Name='hsodia', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
        Account cta = new Account(Name='cuenta',
                                 Calle__c='fsafsa', NumeroExterior__c='3',
                                  NumeroInterior__c='2', CodigoPostal__c='4241',
                                  Colonia__c='241', Ciudad__c='sfasf', Estado__c='Campeche',
                                  RazonSocial__c='Bonitos', phone='55443322', NumeroEmpleados__c = '1 - 125'
                                 );
        insert cta;
        Contact contactoNuevo = new Contact(LastName='safa',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        contactoNuevo = new Contact(LastName='41',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        contactoNuevo = new Contact(LastName='51',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        contactoNuevo = new Contact(LastName='532',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                          Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                          CloseDate=date.today(),Familia__c = 'familiaTest', AccountId=cta.Id );
        insert opp;
        Tarifa__c nueva = new Tarifa__c();
        insert nueva;
        Tarifa__c escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
        escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
		TarifaOportunidad__c tarifa1= new TarifaOportunidad__c(  Producto__c=producto.Id, Importe__c=12.3, Porcentaje__c=0.2, Observaciones__c='Ninfuna',TipoCargo__c='21', TipoSolucion__c='21',Uso__c='213;21',Oportunidad__c=opp.Id,Tarifa__c=nueva.Id );         
           insert tarifa1; 
           
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
            System.currentPageReference().getParameters().put('id', opp.Id);
			System.currentPageReference().getParameters().put('idProd', qli.Id);
            apexPages.StandardController std = new apexPages.StandardController(opp);
            ContratoTC3Controller convertir = new ContratoTC3Controller(std);
        	convertir.contratoCuenta();
        	convertir.lstLineaImpresion= new list<ContratoTC3Controller.wrapLineaImpresion>();
        	convertir.agregarFechaFacturacion();
        	convertir.agregarFechaFacturacion();
        	convertir.lstFechaFacturacion[0].checked=true;
        	convertir.borrarFechaFacturacion();
        	convertir.agregarFechaFacturacion();
        
        	convertir.lineaImpresion='20';
        	convertir.agregarLineaImpresion();
        
        	convertir.lineaImpresion='10';
        	convertir.agregarLineaImpresion();
        	convertir.lstLineaImpresion.add(new ContratoTC3Controller.wrapLineaImpresion());
        	convertir.lstLineaImpresion[0].checked=true;
        
        	convertir.borrarLineaImpresion();
        	convertir.lineaImpresion='9';
        	convertir.agregarLineaImpresion();
        
        	convertir.lineaImpresion='11';
        	convertir.agregarLineaImpresion();
        
        	convertir.lineaImpresion='12';
        	convertir.agregarLineaImpresion();
        	List<SelectOption> getOtroPuesto = convertir.getOtroPuesto();
        	convertir.lstContacto[0].checked=true;
        	//convertir.nuevoContacto();
        	convertir.lstContacto[0].checked=true;
        
        	convertir.lstContacto[0].contacto=null;
        	//convertir.nuevoContacto.contacto=new Contact();
        	//convertir.nuevoContacto();
        
        	convertir.lstContacto[0].checked=true;
        	convertir.llenaCatalogoContacto();
        	convertir.catalogoContacto[0].checked=true;
       		convertir.agregarContactoExistente();
        	convertir.agregarDireccionCuenta();
        	convertir.agregarDireccion();
        	convertir.agregarDireccion();
        	convertir.agregarDireccion();
        	convertir.agregarDireccion();
        convertir.lstDireccion[0].checked=true;
        convertir.borrarDireccion();
        convertir.guardar();
        //convertir.afterGuardar();
        
        /*List<SelectOption> catSucursal= convertir.catSucursal;
        List<SelectOption> catOrigenVenta=convertir.catOrigenVenta;
        //List<SelectOption> catCompetidor=convertir.catCompetidor; comenta calvarez 9mar2017
        //List<SelectOption> catTipoPago=convertir.catTipoPago; comenta calvarez 9mar2017
        //List<SelectOption> catMedioPago=convertir.catMedioPago; comenta calvarez 9mar2017
        //List<SelectOption> catFrecuenciaLiberacionAutomatica=convertir.catFrecuenciaLiberacionAutomatica;
        //List<SelectOption> catTipoFacturacion=convertir.catTipoFacturacion; comenta calvarez 9mar2017
        //List<SelectOption> catFrecuenciaFacturacion=convertir.catFrecuenciaFacturacion;
        //List<SelectOption> catComoFactura=convertir.catComoFactura; comenta calvarez 9mar2017
        List<SelectOption> catTipoCliente=convertir.catTipoCliente;
        //List<SelectOption> catFacturacionComision=convertir.catFacturacionComision; comenta calvarez 9mar2017
        List<SelectOption> catFacturacionPlastico=convertir.catFacturacionPlastico;
        //List<SelectOption> catItemContratacion=convertir.catItemContratacion;
        List<SelectOption> catPuesto=convertir.catPuesto;
        //List<SelectOption> catFacturacionCargos=convertir.catFacturacionCargos;
        List<SelectOption> catManeja=convertir.catManeja;
        List<SelectOption> catRed=convertir.catRed;
        List<SelectOption> catOperacionModoOffline=convertir.catOperacionModoOffline;
        List<SelectOption> catDescripcionLineaImpresion=convertir.catDescripcionLineaImpresion;
        List<SelectOption> catFinanciamiento=convertir.catFinanciamiento;
        List<SelectOption> catTipoFinanciamiento=convertir.catTipoFinanciamiento;
        List<SelectOption> catTipoPlasticoTarjetaFinanciera=convertir.catTipoPlasticoTarjetaFinanciera;
        List<SelectOption> catTipoPlasticoTarjetaStock=convertir.catTipoPlasticoTarjetaStock;*/
       /* string tipoCargo=convertir.tipoCargo;
        string tipoRegistro=convertir.tipoRegistro;
        boolean tipoEscalo=convertir.tipoEscalo;
        boolean hideAjuste=convertir.hideAjuste;
        boolean hideAniversarioMes=convertir.hideAniversarioMes;
        boolean hideComision=convertir.hideComision;
        TarifaOportunidad__c tarifaOpp=convertir.tarifaOpp;
        ContratoTC3Controller.WrappedBonificaciones tarifaSelect=convertir.tarifaSelect;
        List<TarifaOportunidad__c> catalogoTarifas=convertir.catalogoTarifas;
        list<BonificacionEscalonamiento__c> lstBorrarBoniEsca=convertir.lstBorrarBoniEsca;
        ContratoTC3Controller.WrappedBonificaciones uno = new ContratoTC3Controller.WrappedBonificaciones();
        
        
    }
    
    @isTest 
    static void conContrato() {
        //agrega calvarez 9mar2017 INICIO
        List<sObject> objs = new List<sObject>();
        Id pricebookId = Test.getStandardPricebookId();
        //insert Product2
                Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta');
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');

        objs.add(p);
        objs.add(acc);
        insert objs;
        //System.debug('objs 1: ' + objs);
        objs.clear();
        //insert Opportunity
        Opportunity opp_c = new Opportunity(AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today());

        //insert Contact
        Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');

        //insert PricebookEntry
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);

        //insert Concepto__c
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
        Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 1.2);
        objs.add(opp_c);
        objs.add(cont);
        objs.add(pbe);
        objs.add(c);
        objs.add(c1);

        insert objs;
        //System.debug('objs 2: ' + objs);
        objs.clear();

        //insert Quote
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp_c.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

        objs.add(quot);

        insert objs;
        //System.debug('objs 3: ' + objs);
        objs.clear();

        //sincronize Quote to Opportunity 
        opp_c.SyncedQuoteId = quot.Id;
        update opp_c;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp_c.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe.Id, ServiceDate = System.today().addDays(5));

        //insert QuoteLineItem 
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe.Id, Product2Id = p.Id, ServiceDate = System.today().addDays(5));

        objs.add(oli);
        objs.add(qli);

        insert objs;
        //agrega calvarez 9mar2017 FIN

        Producto__c producto = new 	Producto__c(Name='hsodia', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
        Account cta = new Account(Name='cuenta',
                                 Calle__c='fsafsa', NumeroExterior__c='3',
                                  NumeroInterior__c='2', CodigoPostal__c='4241',
                                  Colonia__c='241', Ciudad__c='sfasf', Estado__c='Campeche',
                                  RazonSocial__c='Bonitos', phone='55443322', NumeroEmpleados__c = '1 - 125'
                                 );
        insert cta;
        Contact contactoNuevo = new Contact(LastName='safa',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        contactoNuevo = new Contact(LastName='41',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        contactoNuevo = new Contact(LastName='51',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        contactoNuevo = new Contact(LastName='532',AccountId= cta.Id, Phone = '123456789');
        insert contactoNuevo;
        Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                          Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                          CloseDate=date.today(),Familia__c = 'familiaTest', AccountId=cta.Id );
        insert opp;
        
        //------------------
        Contrato__c contratoPrueba = new Contrato__C(  OrigenVenta__c='dsa',
                                 NombreEjecutivo__c='dsadas',
                DireccionFactura__c='dsadas', Calle__c='ssadfas', NumeroExterior__c='dsda',
                NumeroInterior__c='dsa', Colonia__c='dsda', Ciudad__c='Campeche', CodigoPostal__c='53426',
                TipoPago__c='uno', ClaveTipoPago__c='2', MedioPago__c='sfsa', ClaveMedioPago__c='43',
                ClaveItemContratacion__c='24', ItemContratacion__c='gas', TipoFacturacion__c='fsfa',
                ClaveTipoFacturacion__c='967', FrecuenciaFacturacion__c='fsaf', 
                ClaveFrecuenciaFacturacion__c='241', FacturacionPlastico__c='fsafsa', 
                ClaveFacturacionPlastico__c='241', FacturacionComision__c='fsaf', 
                ClaveFacturacionComision__c='6262', ComoFactura__c='sfas', ClaveComoFactura__c='gsaa',
                ClaveOrigenVenta__c='421', Territorio__c=414,    
                                                         NumeroSolicitud__c='12',ClaveSucursal__c='32',Cuenta__c=cta.Id,oportunidad__c=opp.Id,RazonSocial__c='dsafsafa',RFC__c='fsfsafsa',Sucursal__c='fsssa');
        	upsert contratoPrueba;
        opp.ContratoTC3__c=contratoprueba.iD;
        UPSERT opp;
        Garantia__c garantiaNueva= new Garantia__c(Contrato__c=contratoPrueba.Id, TipoGarantia__c='Deposito en garantia', Monto__c=31.2 ,Observaciones__c='ninguna');
        insert garantiaNueva;
        garantiaNueva= new Garantia__c(Contrato__c=contratoPrueba.Id, TipoGarantia__c='Fianza', Monto__c=31.2 ,Observaciones__c='ninguna');
        insert garantiaNueva;
        garantiaNueva= new Garantia__c(Contrato__c=contratoPrueba.Id, TipoGarantia__c='Otra', Monto__c=31.2 ,Observaciones__c='ninguna');
        insert garantiaNueva;
        
        LineaImpresion__c lineas = new LineaImpresion__c(DescripcionLineaImpresion__c='fsavas',ClaveDescripcionLineaImpresion__c='123',Orden__c=2.1,Contrato__c=contratoPrueba.Id  );
        insert lineas;
        FechaFacturacion__c fechaFac= new FechaFacturacion__c(FechaInicio__c=(Date.today()-1) ,FechaFin__c=Date.today(), Contrato__c=contratoPrueba.Id);
        insert fechaFac;
         DireccionEntrega__c direccionEntrega=new DireccionEntrega__c(Calle__c='dsaf', ClaveDireccion__c='21', Descripcion__c='sfsafa',
                                                                      Direccion__c='sfsa', NumExterior__c='41', NumInterior__c='214', CodigoPostal__c='53426', 
                                                       Colonia__c='fsaf', Ciudad__c='Naucalpan', Estado__c='Campeche', AtencionA__c='sfsaf', Puesto__c='fsafa',
                                                                      Telefono__c='2223444', Extension__c=2, Email__c='algo@gmail.com', 
                                                                      Horario__c='total', NombrePersonalizar__c='nombrePerso', 
                                                       DireccionPersonalizar__c='fsafas', Observaciones__c='sfsafas',Estatus__c='alta' );
        insert direccionEntrega;
        //---------
        
        Tarifa__c nueva = new Tarifa__c();
        insert nueva;
        Tarifa__c escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
        escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
		TarifaOportunidad__c tarifa1= new TarifaOportunidad__c(  Producto__c=producto.Id, Importe__c=12.3, Porcentaje__c=0.2, Observaciones__c='Ninfuna',TipoCargo__c='21', TipoSolucion__c='21',Uso__c='213;21',Oportunidad__c=opp.Id,Tarifa__c=nueva.Id );         
           insert tarifa1; 
           
            //Test.setCurrentPageReference(new PageReference('Page.myPage'));
            /*comenta calvarez 2 junio 2017 Test.setCurrentPageReference(new PageReference('Page.ContratoTC3'));
            System.currentPageReference().getParameters().put('id', opp_c.Id);
			System.currentPageReference().getParameters().put('idProd', qli.Id);
            apexPages.StandardController std = new apexPages.StandardController(opp);
            ContratoTC3Controller convertir = new ContratoTC3Controller(std);*/

/*
            ApexPages.StandardController sc = new ApexPages.StandardController(opp);
            PageReference pageRef = Page.ContratoTC3;
            pageRef.getParameters().put('id', String.valueOf(opp.Id));
            pageRef.getParameters().put('idProd', String.valueOf(qli.Id));
            Test.setCurrentPage(pageRef);
            ContratoTC3Controller convertir = new ContratoTC3Controller(sc);


        	convertir.contratoCuenta();
        	convertir.lstLineaImpresion= new list<ContratoTC3Controller.wrapLineaImpresion>();
        	convertir.agregarFechaFacturacion();
        	convertir.agregarFechaFacturacion();
        	convertir.lstFechaFacturacion[0].checked=true;
        	convertir.borrarFechaFacturacion();
        	convertir.agregarFechaFacturacion();
        
        	convertir.lineaImpresion='20';
        	convertir.agregarLineaImpresion();
        
        	convertir.lineaImpresion='10';
        	convertir.agregarLineaImpresion();
        	convertir.lstLineaImpresion.add(new ContratoTC3Controller.wrapLineaImpresion());
        	convertir.lstLineaImpresion[0].checked=true;
        
        	convertir.borrarLineaImpresion();
        	convertir.lineaImpresion='9';
        	convertir.agregarLineaImpresion();
        
        	convertir.lineaImpresion='11';
        	convertir.agregarLineaImpresion();
        
        	convertir.lineaImpresion='12';
        	convertir.agregarLineaImpresion();
        	List<SelectOption> getOtroPuesto = convertir.getOtroPuesto();
        	convertir.lstContacto[0].checked=true;
        	//convertir.nuevoContacto();
        	convertir.lstContacto[0].checked=true;
        
        	convertir.lstContacto[0].contacto=null;
        	//convertir.nuevoContacto.contacto=new Contact();
        	//convertir.nuevoContacto();
        
        	convertir.lstContacto[0].checked=true;
        	convertir.llenaCatalogoContacto();
        	convertir.catalogoContacto[0].checked=true;
       		convertir.agregarContactoExistente();
        	convertir.agregarDireccionCuenta();
        	convertir.agregarDireccion();
        	convertir.agregarDireccion();
        	convertir.agregarDireccion();
        	convertir.agregarDireccion();
        convertir.lstDireccion[0].checked=true;
        convertir.borrarDireccion();
        convertir.guardaFechaFacturacion();
        convertir.guardar();

        //agrega calvarez 2 hunio 2017
        List<SelectOption> listaOpt = new List<SelectOption>();
        convertir.catSucursal = listaOpt;
        convertir.catOrigenVenta = listaOpt;
        convertir.catCompetidor = listaOpt;
        convertir.catTipoPago = listaOpt;
        convertir.catMedioPago = listaOpt;
        convertir.catFrecuenciaLiberacionAutomatica = listaOpt;
        convertir.catTipoFacturacion = listaOpt;
        convertir.catFrecuenciaFacturacion = listaOpt;
        convertir.catComoFactura = listaOpt;
        convertir.catTipoCliente = listaOpt;
        convertir.catFacturacionComision = listaOpt;
        convertir.catFacturacionPlastico = listaOpt;
        convertir.catItemContratacion = listaOpt;
        convertir.catPuesto = listaOpt;
        convertir.catFacturacionCargos = listaOpt;
        convertir.catManeja = listaOpt;
        convertir.catRed = listaOpt;
        convertir.catOperacionModoOffline = listaOpt;
        convertir.catDescripcionLineaImpresion = listaOpt;
        convertir.catFinanciamiento = listaOpt;
        convertir.catTipoFinanciamiento = listaOpt;
        convertir.catTipoPlasticoTarjetaFinanciera = listaOpt;
        convertir.catTipoPlasticoTarjetaStock = listaOpt;
        convertir.catMaquila = listaOpt;
        


        convertir.obtenerDatosContrato();
        convertir.nuevoContacto();
        convertir.nuevoContactoBoton();

        //convertir.afterGuardar();
        
        /*List<SelectOption> catSucursal= convertir.catSucursal;
        List<SelectOption> catOrigenVenta=convertir.catOrigenVenta;
        //List<SelectOption> catCompetidor=convertir.catCompetidor; comenta calvarez 9mar2017
        //List<SelectOption> catTipoPago=convertir.catTipoPago; comenta calvarez 9mar2017
        //List<SelectOption> catMedioPago=convertir.catMedioPago;
        //List<SelectOption> catFrecuenciaLiberacionAutomatica=convertir.catFrecuenciaLiberacionAutomatica;
        //List<SelectOption> catTipoFacturacion=convertir.catTipoFacturacion; comenta calvarez 9mar2017
        //List<SelectOption> catFrecuenciaFacturacion=convertir.catFrecuenciaFacturacion;
        //List<SelectOption> catComoFactura=convertir.catComoFactura; comenta calvarez 9mar2017
        //List<SelectOption> catTipoCliente=convertir.catTipoCliente;
        List<SelectOption> catFacturacionComision=convertir.catFacturacionComision;
        List<SelectOption> catFacturacionPlastico=convertir.catFacturacionPlastico;
        //List<SelectOption> catItemContratacion=convertir.catItemContratacion;
        List<SelectOption> catPuesto=convertir.catPuesto;
        //List<SelectOption> catFacturacionCargos=convertir.catFacturacionCargos;
        List<SelectOption> catManeja=convertir.catManeja;
        List<SelectOption> catRed=convertir.catRed;
        List<SelectOption> catOperacionModoOffline=convertir.catOperacionModoOffline;
        List<SelectOption> catDescripcionLineaImpresion=convertir.catDescripcionLineaImpresion;
        List<SelectOption> catFinanciamiento=convertir.catFinanciamiento;
        List<SelectOption> catTipoFinanciamiento=convertir.catTipoFinanciamiento;
        List<SelectOption> catTipoPlasticoTarjetaFinanciera=convertir.catTipoPlasticoTarjetaFinanciera;
        List<SelectOption> catTipoPlasticoTarjetaStock=convertir.catTipoPlasticoTarjetaStock;*/
    /*    string tipoCargo=convertir.tipoCargo;
        string tipoRegistro=convertir.tipoRegistro;
        boolean tipoEscalo=convertir.tipoEscalo;
        boolean hideAjuste=convertir.hideAjuste;
        boolean hideAniversarioMes=convertir.hideAniversarioMes;
        boolean hideComision=convertir.hideComision;
        TarifaOportunidad__c tarifaOpp=convertir.tarifaOpp;
        ContratoTC3Controller.WrappedBonificaciones tarifaSelect=convertir.tarifaSelect;
        List<TarifaOportunidad__c> catalogoTarifas=convertir.catalogoTarifas;
        list<BonificacionEscalonamiento__c> lstBorrarBoniEsca=convertir.lstBorrarBoniEsca;
        ContratoTC3Controller.WrappedBonificaciones uno = new ContratoTC3Controller.WrappedBonificaciones();
        
        
    }
*/
}