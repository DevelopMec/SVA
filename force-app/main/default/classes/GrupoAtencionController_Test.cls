@isTest
private class GrupoAtencionController_Test{
    @isTest static void test_method_one(){
        new GrupoAtencionController();
    }
	/*static Submotivo__c subMotivo, subMotivo_2, subMotivo_3;
	static Account acc;
	static Contact ctc;
	static List<EntidadCuenta__c> listEntidadCuenta;

	static void init() {

		subMotivo = new Submotivo__c();
		subMotivo.Name = 'Cobro de más';
		subMotivo.Tipo_de_Ticket__c = 'Solicitud';
		subMotivo.Motivo__c = 'Aclaración';		
		subMotivo.Grupo_Soporte_1__c = 'SAC';
		subMotivo.Grupo_Soporte_2__c = 'TI';
		insert subMotivo;

		acc = new Account();
		acc.Name = 'Acc Test';
		insert acc;

		ctc = new Contact();
		ctc.LastName = 'LastName';
		ctc.AccountId = acc.Id;
		insert ctc;

		EntidadLegal__c entidadLegal = new EntidadLegal__c();
		entidadLegal.Name = 'ABCD112233XYZ';
		entidadLegal.Cuenta__c = acc.Id;
		insert entidadLegal;

		listEntidadCuenta = [SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: acc.Id AND EntidadLegal__c =: entidadLegal.Id];

		///
		subMotivo_2 = new Submotivo__c();
		subMotivo_2.Name = 'Cambio De Comisión';
		subMotivo_2.Tipo_de_Ticket__c = 'Incidencia';
		subMotivo_2.Motivo__c = 'Re facturación';		
		subMotivo_2.Grupo_Soporte_1__c = 'SAC';
		subMotivo_2.Grupo_Soporte_2__c = 'TI';
		insert subMotivo_2;
	}

    @isTest static void test_method_one() {

    	init();

		// Familia - Benefits
		Product2 producto_1 = new Product2();
		producto_1.Name = 'Producto Test';
		producto_1.Family = 'Comida';
		producto_1.ProductCode = '1';
		insert producto_1;
	
		ContratoFilial__c contratoFilial_1 = new ContratoFilial__c();
		contratoFilial_1.Name = '11-22-33333-444';
		contratoFilial_1.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
		contratoFilial_1.Producto__c = producto_1.Id;
		insert contratoFilial_1;		

		Case caso_1 = new Case();
		caso_1.AccountId = acc.Id;
		caso_1.ContactId = ctc.Id;
		caso_1.Contrato_Filial__c = contratoFilial_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		insert caso_1;

		caso_1.Motivo__c = 'Aclaración';
		caso_1.Sub_Motivo__c = 'Cobro de más';		
		update caso_1;

		caso_1.TicketCampoVacio__c = false;
		update caso_1;

		Test.startTest();

		///
		Map<String,String> resultMap = GrupoAtencionController.siguienteCaso(caso_1.Id);

		///
		String comentario = 'Test';
		resultMap = GrupoAtencionController.anteriorCaso(caso_1.Id, comentario);
		resultMap = GrupoAtencionController.siguienteCaso(caso_1.Id);
		Test.stopTest();
    }

    @isTest static void test_method_two() {

    	init();

    	// Familia - Ticket Car
		Product2 producto_2 = new Product2();
		producto_2.Name = 'Producto Test';
		producto_2.Family = 'Combustible';
		producto_2.ProductCode = '2';
		insert producto_2;

		ContratoFilial__c contratoFilial_2 = new ContratoFilial__c();
		contratoFilial_2.Name = '11-22-33333-444';
		contratoFilial_2.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
		contratoFilial_2.Producto__c = producto_2.Id;
		insert contratoFilial_2;

		Case caso_2 = new Case();
		caso_2.AccountId = acc.Id;
		caso_2.ContactId = ctc.Id;
		caso_2.Contrato_Filial__c = contratoFilial_2.Id;
		caso_2.Type = 'Solicitud';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		insert caso_2;

		caso_2.Motivo__c = 'Aclaración';
		caso_2.Sub_Motivo__c = 'Cobro de más';		
		update caso_2;

		caso_2.TicketCampoVacio__c = false;
		update caso_2;

		Test.startTest();

		///
		Map<String,String> resultMap = GrupoAtencionController.siguienteCaso(caso_2.Id);

		///
		String comentario = 'Test';
		resultMap = GrupoAtencionController.anteriorCaso(caso_2.Id, comentario);

		Test.stopTest();
    }
    
    @isTest static void test_method_three() {

    	init();

    	// Familia - Ticket Empresarial
		Product2 producto_3 = new Product2();
		producto_3.Name = 'Producto Test';
		producto_3.Family = 'Viáticos';
		producto_3.ProductCode = '3';
		insert producto_3;	

		ContratoFilial__c contratoFilial_3 = new ContratoFilial__c();
		contratoFilial_3.Name = '11-22-33333-444';
		contratoFilial_3.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
		contratoFilial_3.Producto__c = producto_3.Id;
		insert contratoFilial_3;

		Case caso_3 = new Case();
		caso_3.AccountId = acc.Id;
		caso_3.ContactId = ctc.Id;
		caso_3.Contrato_Filial__c = contratoFilial_3.Id;
		caso_3.Type = 'Solicitud';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		insert caso_3;

		caso_3.Motivo__c = 'Aclaración';
		caso_3.Sub_Motivo__c = 'Cobro de más';		
		update caso_3;

		caso_3.TicketCampoVacio__c = false;
		update caso_3;

		Test.startTest();

		///
		Map<String,String> resultMap = GrupoAtencionController.siguienteCaso(caso_3.Id);

		///
		String comentario = 'Test';
		resultMap = GrupoAtencionController.anteriorCaso(caso_3.Id, comentario);

		Test.stopTest();
    }

    @isTest static void test_method_four() {

    	init();

    	// Familia - Ticket Empresarial
		Product2 producto_3 = new Product2();
		producto_3.Name = 'Producto Test';
		producto_3.Family = 'Viáticos';
		producto_3.ProductCode = '3';
		insert producto_3;	

		ContratoFilial__c contratoFilial_3 = new ContratoFilial__c();
		contratoFilial_3.Name = '11-22-33333-444';
		contratoFilial_3.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
		contratoFilial_3.Producto__c = producto_3.Id;
		insert contratoFilial_3;

		Case caso_3 = new Case();
		caso_3.AccountId = acc.Id;
		caso_3.ContactId = ctc.Id;
		caso_3.Contrato_Filial__c = contratoFilial_3.Id;
		caso_3.Type = 'Incidencia';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		insert caso_3;

		caso_3.Motivo__c = 'Re facturación';
		caso_3.Sub_Motivo__c = 'Cambio De Comisión';
		update caso_3;

		caso_3.TicketCampoVacio__c = false;
		update caso_3;

		Test.startTest();

		///
		Map<String,String> resultMap = GrupoAtencionController.siguienteCaso(caso_3.Id);
		resultMap = GrupoAtencionController.siguienteCaso(caso_3.Id);
		///
		String comentario = 'Test';
		resultMap = GrupoAtencionController.anteriorCaso(caso_3.Id, comentario);

		Test.stopTest();
    }

    @isTest static void test_method_five() {

    	init();

		// Familia - Benefits
		Product2 producto_1 = new Product2();
		producto_1.Name = 'Producto Test';
		producto_1.Family = 'Comida';
		producto_1.ProductCode = '1';
		insert producto_1;
	
		ContratoFilial__c contratoFilial_1 = new ContratoFilial__c();
		contratoFilial_1.Name = '11-22-33333-444';
		contratoFilial_1.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
		contratoFilial_1.Producto__c = producto_1.Id;
		insert contratoFilial_1;		

		Case caso_1 = new Case();
		caso_1.AccountId = acc.Id;
		caso_1.ContactId = ctc.Id;
		caso_1.Contrato_Filial__c = contratoFilial_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		insert caso_1;

		caso_1.Motivo__c = 'Aclaración';
		caso_1.Sub_Motivo__c = 'Cobro de más';
		update caso_1;

		Test.startTest();

		///
		Map<String,String> resultMap = GrupoAtencionController.siguienteCaso(caso_1.Id);

		///
		String comentario = 'Test';
		resultMap = GrupoAtencionController.anteriorCaso(caso_1.Id, comentario);

		Test.stopTest();
    }

    @isTest static void test_method_six() {

    	init();

		// Familia - Benefits
		Product2 producto_1 = new Product2();
		producto_1.Name = 'Producto Test';
		producto_1.Family = 'Comida';
		producto_1.ProductCode = '1';
		insert producto_1;
	
		ContratoFilial__c contratoFilial_1 = new ContratoFilial__c();
		contratoFilial_1.Name = '11-22-33333-444';
		contratoFilial_1.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
		contratoFilial_1.Producto__c = producto_1.Id;
		insert contratoFilial_1;		

		Case caso_1 = new Case();
		caso_1.AccountId = acc.Id;
		caso_1.ContactId = ctc.Id;
		caso_1.Contrato_Filial__c = contratoFilial_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		insert caso_1;

		caso_1.Motivo__c = 'Aclaración';
		caso_1.Sub_Motivo__c = 'Cobro de más';
		update caso_1;

		caso_1.TicketCampoVacio__c = false;
		update caso_1;

		Test.startTest();

		///
		Map<String,String> resultMap = GrupoAtencionController.siguienteCaso(caso_1.Id);

		///
		resultMap = GrupoAtencionController.siguienteCaso(caso_1.Id);

		Test.stopTest();
    }

    @isTest static void test_method_seven() {

    	init();

		// Familia - Benefits
		Product2 producto_1 = new Product2();
		producto_1.Name = 'Producto Test';
		producto_1.Family = 'Comida';
		producto_1.ProductCode = '1';
		insert producto_1;
	
		ContratoFilial__c contratoFilial_1 = new ContratoFilial__c();
		contratoFilial_1.Name = '11-22-33333-444';
		contratoFilial_1.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
		contratoFilial_1.Producto__c = producto_1.Id;
		insert contratoFilial_1;		

		Case caso_1 = new Case();
		caso_1.AccountId = acc.Id;
		caso_1.ContactId = ctc.Id;
		caso_1.Contrato_Filial__c = contratoFilial_1.Id;
		caso_1.Type = 'Incidencia';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		insert caso_1;

		caso_1.Motivo__c = 'Pedidos de Tarjeta';
		caso_1.Sub_Motivo__c = 'No reconoce la entrega';
		update caso_1;

		caso_1.TicketCampoVacio__c = false;
		update caso_1;

		Test.startTest();

		///
		Map<String,String> resultMap = GrupoAtencionController.siguienteCaso(caso_1.Id);

		///
		String comentario = 'Test';
		resultMap = GrupoAtencionController.anteriorCaso(caso_1.Id, comentario);

		Test.stopTest();
    }*/
}