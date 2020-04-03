@isTest
private class PLAN_CuentaTest {

	/*@testSetup static void setupData() {

		List<sObject> objs = new List<sObject>();

		Document document = new Document();
		document.Body = Blob.valueOf('{"Términos y Condiciones del Servicio": ["Para la prestación e implementación del servicio referido nos basaremos en la información que tu nos suministrarás; instrucciones que al efecto serán utilizadas para la elaboración de las tarjetas y dispersion de los fondos de las mismas.", "Esta propuesta no incluye ningún otro servicio no mencionado específicamente en esta comunicación. Sin embargo, con mucho gusto discutiremos contigo cualquier otro servicio adicional que requieras.", "Es entendido y convenido que Edenred es responsable por la veracidad y el resguardo de la información que nos sea suministrada para la prestación de nuestro servicio, por lo que te invitamos a consultar nuestra política de privacidad y protección de datos en nuestra página web.", "Los pagos por el servicio deberán ser realizados previamente por lo que la falta de pago oportuno retardará la dispersión o entrega de beneficio.", "Las condiciones de entrega de las tarjetas o monederos, dispersión de fondos y operatividad de nuestra plataforma para el manejo de beneficio, deberán ser consultadas en nuestra página web o a través de nuestro call center, quienes gustosamente nos aclararán cualquier duda al respecto."], "Responsabilidades": ["Es entendido y convenido que la empresa cliente es responsable por la veracidad de la información que nos sea adminidatrada para la prestación de los servicios anterirormente identificados.", "La empresa cliente es responsable del pago oportuno (dentro del lapso acordado) de las facturas por servicio.", "La empresa cliente es responsable de leer y seguir los instructivos y manuales de operación que están disponibles en la página web de Edenred, necesarios para la operatividad de los monederos electrónicos y tarjetas.", "Edenred es responsable de la entrega en los tiempos acordados de las tarjetas electrónicas y monederos, así como efectuar la dispersión de los fondos transmitidos por la empresa e la fecha indicada por la empresa cliente.", "La Empresa Cliente es responsable de designar a un Administrador Único del Sistema en la plataforma de Edenred, quién será el único responsable de las instrucciones que al efecto girará para las transacciones y operaciones que se efectúen en dicha plataforma desde el mismo momento en que se ingrese con la clave de usuario. El cambio de ese Administrador Único deberá ser notificado por escrito mediante una carta firmada por el Representante Legal."], "Jurisdicción": ["La empresa cliente ________________________________________ conviene que los terminos de esta propuesta estarán regidos e interpretados de acuerdo con las leyes de la República Mexicana."], "Declaración de Acuerdo Total": ["Esta propuesta constituye el único entendimiento  y acuerdo total entre Edenred y _______________________________________ con respecto a los servicios aquí descritos. Esta propuesta reemplaza cualquier otro convenio previo entre las partes con respecto al asunto de esta propuesta, cuyos efectos cesarán desde el momento de la firma de la presente."], "Misceláneos": ["Al aceptar la presente propuesta la empresa cliente por intermedio de su represenetante Legal, autoriza a ________________________________________ como Administrador UNICO del sistema para comunicarse con ella por correo electrónico o para transmitir documentos de forma electrónica, aceptando los riesgos inherente  este tipo de comunicación y acuerda que puede confiar solamente en la versión final impresa del documento u otra comunicación que ________________________________________ envíe a la Compañía.", "Esta propuesta será válida por un periodo de siete(7) días a partir de su recepción por parte de la empresa cliente.", "Será para nosotros motivo de gran satisfacción contar con ________________________________________ entre nuestros clientes y confiamos que los términos de nuestra propuesta sean de su conformidad. Si desean alguna información adicional gustosamente se la suministraremos a su solicitud. En la copia anexa a esta carta puede darnos su aceptación a esta propuesta, si esa fuera su decisión, aunque una firma al calce de la presente a o una respuesta escrita de ustedes servirá para el mismo propósito."] }');
		document.ContentType = 'application/json';
		document.DeveloperName = 'TerminosYCondicionesTest';
		document.IsPublic = true;
		document.Name = 'TerminosYCondicionesTest';
		document.FolderId = [SELECT Id FROM Folder WHERE Name = 'Logos'].Id;

		objs.add(new ContenidoPDF__c(Contenido__c = 'Vigencia de \n propuesta: 15 dias', Name = 'RequerimientoFirma', Seccion__c = 'RequerimientoFirma'));
		objs.add(new ContenidoPDF__c(Contenido__c = 'Vigencia de \n propuesta: 15 dias', Name = 'Despedida', Seccion__c = 'Despedida'));
		objs.add(new ContenidoPDF__c(Contenido__c = 'Vigencia de \n propuesta: 15 dias', Name = 'Información adicional', Seccion__c = 'Información adicional'));
		objs.add(new ContenidoPDF__c(Contenido__c = 'Vigencia de \n propuesta: 15 dias', Name = 'DocumentosPFisica', Seccion__c = 'Información adicional'));
		objs.add(new ContenidoPDF__c(Contenido__c = 'Vigencia de \n propuesta: 15 dias', Name = 'DocumentosPMoral', Seccion__c = 'Información adicional'));

		Id pricebookId = Test.getStandardPricebookId();
		//insert Product2
		Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta');

		//insert Account
		Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');

		objs.add(p);
		objs.add(acc);
		objs.add(document);

		insert objs;
		//System.debug('objs 1: ' + objs);
		objs.clear();

		//insert Opportunity
		Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today().addDays(5));
		//Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = Date.newInstance(2017, 8, 17));
		System.debug('opp setupData: ' + opp);

		//insert Contact
		Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');

		//insert PricebookEntry
		PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);

		//insert Concepto__c
		Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p.Id, Importe__c = 1.1);
		Concepto__c c1 = new Concepto__c(TipoCargo__c = 'Tarjeta titular', Producto__c = p.Id, Importe__c = 1.2);

		
		objs.add(opp);
		objs.add(cont);
		objs.add(pbe);
		objs.add(c);
		objs.add(c1);

		insert objs;
		QuoteSyncUtil.populateRequiredFields(opp);
		//System.debug('objs 2: ' + objs);
		objs.clear();

		//insert Quote
		Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, ContactId = cont.Id, Pricebook2Id = pricebookId);

		objs.add(quot);

		insert objs;
		//System.debug('objs 3: ' + objs);
		objs.clear();

		//sincronize Quote to Opportunity 
		opp.SyncedQuoteId = quot.Id;
		update opp;

		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe.Id, ServiceDate = System.today().addDays(5));

		//insert QuoteLineItem 
		QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe.Id, Product2Id = p.Id, CantidadTarjetas__c = 10, ServiceDate = System.today().addDays(5));
		QuoteLineItem qli2 = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe.Id, Product2Id = p.Id, CantidadTarjetas__c = 10, Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));

		objs.add(oli);
		objs.add(qli);
		objs.add(qli2);
		System.debug('opp setupData 2: ' + opp + ' lista: ' + objs);
		insert objs;

		QuoteSyncUtil.populateRequiredFields(qli);
		
		delete qli2;
		//System.debug('objs 4: ' + objs);
		objs.clear();

		//qli2.Escalonamiento__c = qli.Id;
		//objs.add(qli2);

		//insert ProductoComparado__c
		ProductoComparado__c pc = new ProductoComparado__c(ProductoCotizado__c = qli.Id, ProductoComparado__c = p.Id);

		//insert ProductoConcepto__c
		ProductoConcepto__c pcon = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id);
		ProductoConcepto__c pcon2 = new ProductoConcepto__c(Concepto__c = c1.Id, ProductoComparadoID__c = pc.Id);

		objs.add(pc);
		objs.add(pcon);
		objs.add(pcon2);

		insert objs;
		//System.debug('objs 5: ' + objs);
		objs.clear();

		//qli.Quantity = 14;
		//update qli;
		//qli.CantidadTarjetas__c = 200;
		//update qli;
	}
	
	/**
	*	calvarez  - 16 enero de 2017
	*	método de prueba para clase: PLAN_ProductoOportunidadConceptoCtrl
	*   Cotizador
	*/
	/*
	@isTest static void getProductoOportunidadConcepto() {

		Id pricebookId = Test.getStandardPricebookId();
		Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
		insert prod;

		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
		insert standardPrice;

		Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');
		insert acc;
		Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today().addDays(5));
		insert opp;

		OpportunityLineItem oli = new OpportunityLineItem(Quantity = 10, OpportunityId = opp.Id, TotalPrice = 10.23, PricebookEntryId = standardPrice.Id);
		List<QuoteLineItem> qlis = [SELECT Id, Quote.Opportunity.OwnerId FROM QuoteLineItem LIMIT 2];
		User owner = new User();
		for(QuoteLineItem qli : qlis) {
			oli.PartidaPresupuesto__c = String.valueOf(qli.Id);
			owner = new User(Id = qli.Quote.Opportunity.OwnerId);
			break;
		}
		insert oli;

		oli.Quantity = 201;
		oli.Etapa__c = 'Implementación';
		update oli;
/*
		if(owner.Id != null) {
			owner.Segmento__c = 'MLK';
			update owner;
			update oli;
		}*/
/*
		ApexPages.StandardController sc = new ApexPages.StandardController(oli);
		PageReference pageRef = Page.PLAN_ProductoOportunidadConcepto;
		pageRef.getParameters().put('id', String.valueOf(oli.Id));
        Test.setCurrentPage(pageRef);

		PLAN_ProductoOportunidadConceptoCtrl tpo = new PLAN_ProductoOportunidadConceptoCtrl(sc);
		List<ProductoConcepto__c> lpc = tpo.productos;

		//System.assertEquals(new List<ProductoConcepto__c>(), lpc);
	}

	/**
	*	calvarez  - 16 enero de 2017
	*	método de prueba para clase: UTIL_RoundRobin
	* 	Asignación de Leads - Round Robin
	*/
	/*@isTest static void getRoundRobin() {
		UTIL_RoundRobin urr = new UTIL_RoundRobin();
		UTIL_RoundRobin.ventas('');
		UTIL_RoundRobin.ventas(null);
		UTIL_RoundRobin.ventas('abc');

		UTIL_RoundRobin.orgDefaults('');
		UTIL_RoundRobin.orgDefaults(null);
		UTIL_RoundRobin.orgDefaults('abc');

		RoundRobin__c rrd = new RoundRobin__c(Name = 'Perfiles', Perfiles__c = 'Perfil 1, Perfil 2, Administrador del sistema', Objetivo__c = 1, NoContactadoMax__c = 1, CalificadoMin__c = 1, GanadoMin__c = 1, DescuentoUno__c = 1, DescuentoDos__c = 1, DescuentoTres__c = 1);
		insert rrd;
		UTIL_RoundRobin.actualizaConfiguracion('');
		UTIL_RoundRobin.actualizaConfiguracion(null);
		String str = '{"Id":"' + rrd.Id + '","Objetivo__c":50,"NoContactadoMax__c":30,"CalificadoMin__c":50,"GanadoMin__c":15,"DescuentoUno__c":50,"DescuentoDos__c":70,"DescuentoTres__c":80}';
		UTIL_RoundRobin.actualizaConfiguracion(str);

	}*/

	/**
	*	calvarez  - 16 enero de 2017
	*	método de prueba para clase: PLAN_PDFCotizacionCtrl
	* 	Generación de PDF de cotización.
	*//*
	@isTest static void getPdfCotizacion() {

		List<QuoteLineItem> qli =[SELECT Id, CantidadTarjetas__c, Description, Etapa__c, FormaPago__c, LineNumber, Subtotal, Quantity, Product2Id, UnitPrice, Product2.Name, Product2.Id, Product2.MonederoElectronico__c, product2.Family, TotalPrice FROM QuoteLineItem ORDER BY CreatedDate ASC];
		PageReference pageRef = Page.PDFCotizacion;
		pageRef.getParameters().put('id', String.valueOf([SELECT Id FROM Quote][0].Id));
		Test.setCurrentPage(pageRef);
		PLAN_PDFCotizacionCtrl.DocumentTYCName = 'TerminosYCondicionesTest';
		PLAN_PDFCotizacionCtrl ppdf = new PLAN_PDFCotizacionCtrl();

		Map<String, PLAN_PDFCotizacionCtrl.Seccion> mp = ppdf.mapSecciones;
		List<PLAN_PDFCotizacionCtrl.Seccion> listSecciones = ppdf.listSecciones;
		Integer numPaginas = ppdf.numPaginas;

		PLAN_PDFCotizacionCtrl.Seccion fp = ppdf.getFormaDePago();
		fp = ppdf.getVigencia();
		fp = ppdf.getDocumentacionPFisica2();
		fp = ppdf.getDocumentacionPFisica();
		fp = ppdf.getDocumentacionPMoral2();
		fp = ppdf.getDocumentacionPMoral();

		List<PLAN_PDFCotizacionCtrl.Seccion> ltycon = ppdf.getTerminosYCondicionesList();
		ltycon = ppdf.partirSeccionTerminosYCondiciones(ltycon[0]);
		ltycon[0].partirSeccion();


		PLAN_PDFCotizacionCtrl.Producto pr = new PLAN_PDFCotizacionCtrl.Producto(qli[0], new Map<Id, Decimal>());
		Map<Id,boolean> sbon = pr.getShowBonificacion();

		PLAN_PDFCotizacionCtrl.SeccionProducto spr = new PLAN_PDFCotizacionCtrl.SeccionProducto(pr);
		List<PLAN_PDFCotizacionCtrl.SeccionProducto> lspr = spr.getPartirListado(0);
		lspr = spr.getPartirListado(1);
		lspr = spr.getPartirListado(2);
		//lspr = spr.getPartirListadoDiferenciales(1);

		PLAN_PDFCotizacionCtrl.SeccionDiferencial sdiff = new PLAN_PDFCotizacionCtrl.SeccionDiferencial(pr);
		List<PLAN_PDFCotizacionCtrl.SeccionDiferencial> lsdiff = sdiff.partirSeccionDiferencial(1);

		List<PLAN_PDFCotizacionCtrl.ProductoConcepto> lspcon =  pr.listarProductoConceptoComparados(pr.Id);

		List<PLAN_PDFCotizacionCtrl.Comparado> comparados = pr.leerComparados(qli[0].Id, qli[0].Product2.Id);
		List<ProductoComparado__c> pcom = [SELECT Id, ProductoComparado__r.Name, ProductoComparado__c, ProductoCotizado__c FROM ProductoComparado__c];
		for(ProductoComparado__c comp: pcom) {
			new PLAN_PDFCotizacionCtrl.Comparado(comp);
		}

		for(Concepto__c concepto : [SELECT Id, Name, TipoCargo__c, Importe__c, Producto__c, Producto__r.Id, Obligatorio__c, Orden__c FROM Concepto__c]) {
			new PLAN_PDFCotizacionCtrl.Concepto(concepto.TipoCargo__c, 0, concepto.Id);
			new PLAN_PDFCotizacionCtrl.Concepto(concepto.TipoCargo__c, 0, concepto.Id, 'Características');
		}

	}

	@isTest static void OpportunityEditCtrl() {
		List<Opportunity> opps = [SELECT Id FROM Opportunity LIMIT 2];
		if(opps != null && opps.size() > 0) {
	        ApexPages.StandardController sc = new ApexPages.StandardController(opps[0]);
			PageReference pageRef = Page.OpportunityEdit;
			pageRef.getParameters().put('id', String.valueOf(opps[0].Id));
	        Test.setCurrentPage(pageRef);
	        OpportunityEditCtrl ctrl = new OpportunityEditCtrl(sc);
	        if(ctrl != null) {
	        	ctrl.getItems();
	        	ctrl.getCurrentName();
	        }
		}
	}

	@isTest static void PLAN_CuentaServiceTest() {
		List<Opportunity> opps = [SELECT Id FROM Opportunity LIMIT 2];
		if(opps != null && opps.size() > 0) {
			ApexPages.StandardController sc = new ApexPages.StandardController(opps[0]);
			PageReference pageRef = Page.PLAN_Cuenta;
			pageRef.getParameters().put('id', String.valueOf(opps[0].Id));
	        Test.setCurrentPage(pageRef);
	        PLAN_CuentaService ctrl = new PLAN_CuentaService(sc);

	        List<Id> ids = new List<Id>();
	        for(Product2 prod2: [SELECT Id, Name FROM Product2 LIMIT 2]) {
	        	ids.add(prod2.Id);
	        }
	        if(ids != null && ids.size() > 0) {
		        // PLAN_CuentaService.getPricebookEntriesByProduct2(ids);
		    }
		}
	}

	@isTest static void ctcUtilTest() {
		CTC_Util.query('SELECT Id FROM Product2');
		CTC_Util.queryLocator('SELECT Id FROM Product2');
		CTC_Util.describe(new List<String>{'Contact', 'Product2'});

		List<Id> ids = new List<Id>();
		List<Id> ids2 = new List<Id>();
		for(QuoteLineItem oli: [SELECT Id, QuoteId FROM QuoteLineItem]) {
			ids.add(oli.Id);
			ids2.add(oli.QuoteId);
		}
		if(ids != null && ids.size() > 0) {

			//CTC_Util.createPDF(new String[]{'/apex/PDFCotizacion?id=' + ids2[0], ids2[0]});

			CTC_Util.upsertObjects(new List<String>{'QuoteLineItem', '[{"Id": "' + ids[0] + '", "CantidadTarjetas__c": 200}]'});
			CTC_Util.upsertObjectsMultiple(new List<String>{'QuoteLineItem', '[{"Id": "' + ids[0] + '", "CantidadTarjetas__c": 200}]'}, false);
			CTC_Util.deleteIds(ids);
			CTC_Util.deleteIdsMultiple(ids, false);
			CTC_Util.createPDF(new List<String>{'/apex/PDFCotizacion?id=' + ids2[0], ids2[0]});
		}

		try {
            Account cuentaTest = new Account( name='Cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');
            insert cuentaTest;
            
            HistorialVE__c HVEC = new HistorialVE__C (cuenta__c = cuentaTest.Id, Name='ABC', NombreCliente__c = 'Hola', VEMes06__c=200.00 );
            insert HVEC;
            System.debug(cuentaTest);
            Test.startTest();
            
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('id', cuentaTest.id);
            //Database.LeadConvert lc = new database.LeadConvert();
            //lc.setLeadId(prospecto.Id);
            
            apexPages.StandardController std = new apexPages.StandardController(cuentaTest);
            HistorialVeController HVE = new HistorialVeController(std);
            
            Test.stopTest();
            
        } catch(Exception e) {
            e.getMessage();
        }


	}
*/
}