@isTest
private class TriggerCase_Test {

	/*static Submotivo__c subMotivo;
	static Account acc;
	static Contact ctc;
	static List<EntidadCuenta__c> listEntidadCuenta;
	static User usr1;
	static User usr2;

	static void init() {

		subMotivo = new Submotivo__c();		
		subMotivo.Tipo_de_Ticket__c = 'Solicitud';
		subMotivo.Motivo__c = '_Pedidos de Tarjeta';
		subMotivo.Name = 'Cambio de persona';
		subMotivo.Grupo_Soporte_1__c = 'ASESORÍA COMERCIAL';
		subMotivo.Grupo_Soporte_2__c = 'ADMINISTRACIÓN DE CONTRATOS';
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
		Profile profileAdmin = [SELECT Name FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator' LIMIT 1];

		usr1 = new User();
		usr1.Alias = 'edtest1';
		usr1.Email = 'ed_test_1@edenred.com';
		usr1.LastName = 'Test_1';
		usr1.UserName = 'ed_test_1@edenred.com';
		usr1.TimeZoneSidKey = 'America/Los_Angeles';
		usr1.LocaleSidKey = 'en_US';
		usr1.LanguageLocaleKey = 'en_US';
		usr1.EmailEncodingKey = 'UTF-8';
		usr1.ProfileId = profileAdmin.Id;
		usr1.IsActive = true;
		usr1.Grupo_de_Atencion__c = 'ASESORÍA COMERCIAL';
		usr1.Hora_de_Entrada__c = Time.newInstance( System.now().hour() - 2, System.now().minute(), 0, 0);
		usr1.Hora_de_Salida__c = Time.newInstance( System.now().hour() + 2, System.now().minute(), 0, 0);
		insert usr1;

		usr2 = new User();
		usr2.Alias = 'edtest2';
		usr2.Email = 'ed_test_2@edenred.com';
		usr2.LastName = 'Test_2';
		usr2.UserName = 'ed_test_2@edenred.com';
		usr2.TimeZoneSidKey = 'America/Los_Angeles';
		usr2.LocaleSidKey = 'en_US';
		usr2.LanguageLocaleKey = 'en_US';
		usr2.EmailEncodingKey = 'UTF-8';
		usr2.ProfileId = profileAdmin.Id;
		usr2.IsActive = true;
		usr2.Grupo_de_Atencion__c = 'ASESORÍA COMERCIAL';
		usr2.Hora_de_Entrada__c = Time.newInstance( System.now().hour() - 2, System.now().minute(), 0, 0);
		usr2.Hora_de_Salida__c = Time.newInstance( System.now().hour() + 2, System.now().minute(), 0, 0);
		insert usr2;
	}

	@isTest static void test_method_one_1() {

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
		
		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ASESORÍA COMERCIAL'];
		Group cola_2 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];
		
		///
		Case caso_1 = new Case();
		caso_1.AccountId = acc.Id;
		caso_1.ContactId = ctc.Id;
		caso_1.Contrato_Filial__c = contratoFilial_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
        caso_1.Grupo_de_Atencion__c='TI test';
        caso_1.Description='TI test';
		insert caso_1;

		Test.startTest();

		caso_1.Motivo__c = '_Pedidos de Tarjeta';
		caso_1.Sub_Motivo__c = 'Cambio de persona';
		update caso_1;		

		caso_1.OwnerId = cola_1.Id;
		update caso_1;
		
		///
		caso_1.OwnerId = cola_2.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_1.OwnerId = cola_2.Id;
		update caso_1;

		Test.stopTest();
	}

	@isTest static void test_method_one_2() {

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
		
		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];
		
		///
		Case caso_1 = new Case();
		caso_1.AccountId = acc.Id;
		caso_1.ContactId = ctc.Id;
		caso_1.Contrato_Filial__c = contratoFilial_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		caso_1.Description='TI test';
		insert caso_1;

		caso_1.Motivo__c = '_Pedidos de Tarjeta';
		caso_1.Sub_Motivo__c = 'Cambio de persona';
		update caso_1;

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		Test.startTest();		

		caso_1.OwnerId = cola_1.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_1.OwnerId = cola_1.Id;
		update caso_1;

		Test.stopTest();
	}

	@isTest static void test_method_one_3() {
		
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
		
		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];		

		Case caso_1 = new Case();
		caso_1.AccountId = acc.Id;
		caso_1.ContactId = ctc.Id;
		caso_1.Contrato_Filial__c = contratoFilial_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		insert caso_1;

		caso_1.Motivo__c = '_Pedidos de Tarjeta';
		caso_1.Sub_Motivo__c = 'Cambio de persona';
		update caso_1;			

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'TEST';
		subMotivo.Grupo_Soporte_6__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		Test.startTest();	

		caso_1.OwnerId = cola_1.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_6__c = 'TEST';
		subMotivo.Grupo_Soporte_7__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_1.OwnerId = cola_1.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_7__c = 'TEST';
		update subMotivo;

		caso_1.OwnerId = cola_1.Id;
		update caso_1;

		Test.stopTest();
	}

	@isTest static void test_method_one_4() {

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

		caso_1.Motivo__c = '_Pedidos de Tarjeta';
		caso_1.Sub_Motivo__c = 'Cambio de persona';
		update caso_1;	

		Test.startTest();

		caso_1.TicketCampoVacio__c = false;
		caso_1.Status = 'En Proceso';
		update caso_1;
		
		caso_1.OwnerId = usr1.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_1__c = 'TEST';
		subMotivo.Grupo_Soporte_2__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_1.OwnerId = usr2.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_1.OwnerId = usr1.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_1.OwnerId = usr2.Id;
		update caso_1;

		Test.stopTest();
	}

	@isTest static void test_method_one_5() {

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

		caso_1.Motivo__c = '_Pedidos de Tarjeta';
		caso_1.Sub_Motivo__c = 'Cambio de persona';
		update caso_1;	

		subMotivo.Grupo_Soporte_1__c = 'TEST';
		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		Test.startTest();	

		caso_1.OwnerId = usr1.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_5__c = 'TEST';
		subMotivo.Grupo_Soporte_6__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_1.OwnerId = usr2.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_6__c = 'TEST';
		subMotivo.Grupo_Soporte_7__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_1.OwnerId = usr1.Id;
		update caso_1;

		subMotivo.Grupo_Soporte_7__c = 'TEST';
		update subMotivo;

		caso_1.OwnerId = usr2.Id;
		update caso_1;

		Test.stopTest();
	}

	@isTest static void test_method_two_1() {

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

		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ASESORÍA COMERCIAL'];
		Group cola_2 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];		
		
		///
		Case caso_2 = new Case();
		caso_2.AccountId = acc.Id;
		caso_2.ContactId = ctc.Id;
		caso_2.Contrato_Filial__c = contratoFilial_2.Id;
		caso_2.Type = 'Solicitud';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		insert caso_2;

		Test.startTest();

		caso_2.Motivo__c = '_Pedidos de Tarjeta';
		caso_2.Sub_Motivo__c = 'Cambio de persona';
		update caso_2;		

		caso_2.OwnerId = cola_1.Id;
		update caso_2;
		
		///
		caso_2.OwnerId = cola_2.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_2.OwnerId = cola_2.Id;
		update caso_2;

		Test.stopTest();
	}

	@isTest static void test_method_two_2() {

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

		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];

		///
		Case caso_2 = new Case();
		caso_2.AccountId = acc.Id;
		caso_2.ContactId = ctc.Id;
		caso_2.Contrato_Filial__c = contratoFilial_2.Id;
		caso_2.Type = 'Solicitud';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		insert caso_2;

		caso_2.Motivo__c = '_Pedidos de Tarjeta';
		caso_2.Sub_Motivo__c = 'Cambio de persona';
		update caso_2;		

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;
		
		Test.startTest();

		caso_2.OwnerId = cola_1.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_2.OwnerId = cola_1.Id;
		update caso_2;

		Test.stopTest();
	}

	@isTest static void test_method_two_3() {

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

		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];

		Case caso_2 = new Case();
		caso_2.AccountId = acc.Id;
		caso_2.ContactId = ctc.Id;
		caso_2.Contrato_Filial__c = contratoFilial_2.Id;
		caso_2.Type = 'Solicitud';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		insert caso_2;

		caso_2.Motivo__c = '_Pedidos de Tarjeta';
		caso_2.Sub_Motivo__c = 'Cambio de persona';
		update caso_2;			

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'TEST';
		subMotivo.Grupo_Soporte_6__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		Test.startTest();	

		caso_2.OwnerId = cola_1.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_6__c = 'TEST';
		subMotivo.Grupo_Soporte_7__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_2.OwnerId = cola_1.Id;
		update caso_2;

		Test.stopTest();
	}

	@isTest static void test_method_two_4() {

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

		caso_2.Motivo__c = '_Pedidos de Tarjeta';
		caso_2.Sub_Motivo__c = 'Cambio de persona';
		update caso_2;

		Test.startTest();

		caso_2.TicketCampoVacio__c = false;
		caso_2.Status = 'En Proceso';
		update caso_2;

		caso_2.OwnerId = usr1.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_1__c = 'TEST';
		subMotivo.Grupo_Soporte_2__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_2.OwnerId = usr2.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_2.OwnerId = usr1.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_2.OwnerId = usr2.Id;
		update caso_2;
		
		Test.stopTest();
	}

	@isTest static void test_method_two_5() {

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

		caso_2.Motivo__c = '_Pedidos de Tarjeta';
		caso_2.Sub_Motivo__c = 'Cambio de persona';
		update caso_2;
		
		subMotivo.Grupo_Soporte_1__c = 'TEST';
		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		Test.startTest();	

		caso_2.OwnerId = usr1.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_5__c = 'TEST';
		subMotivo.Grupo_Soporte_6__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_2.OwnerId = usr2.Id;
		update caso_2;

		subMotivo.Grupo_Soporte_6__c = 'TEST';
		subMotivo.Grupo_Soporte_7__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_2.OwnerId = usr1.Id;
		update caso_2;

		Test.stopTest();
	}

	@isTest static void test_method_three_1() {

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

		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ASESORÍA COMERCIAL'];
		Group cola_2 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];
		
		///
		Case caso_3 = new Case();
		caso_3.AccountId = acc.Id;
		caso_3.ContactId = ctc.Id;
		caso_3.Contrato_Filial__c = contratoFilial_3.Id;
		caso_3.Type = 'Solicitud';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		insert caso_3;

		Test.startTest();

		caso_3.Motivo__c = '_Pedidos de Tarjeta';
		caso_3.Sub_Motivo__c = 'Cambio de persona';
		update caso_3;		

		caso_3.OwnerId = cola_1.Id;
		update caso_3;		

		///
		caso_3.OwnerId = cola_2.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_3.OwnerId = cola_2.Id;
		update caso_3;

		Test.stopTest();
	}

	@isTest static void test_method_three_2() {

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

		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];
		
		///
		Case caso_3 = new Case();
		caso_3.AccountId = acc.Id;
		caso_3.ContactId = ctc.Id;
		caso_3.Contrato_Filial__c = contratoFilial_3.Id;
		caso_3.Type = 'Solicitud';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		insert caso_3;

		caso_3.Motivo__c = '_Pedidos de Tarjeta';
		caso_3.Sub_Motivo__c = 'Cambio de persona';
		update caso_3;		

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		Test.startTest();

		caso_3.OwnerId = cola_1.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_3.OwnerId = cola_1.Id;
		update caso_3;

		Test.stopTest();
	}

	@isTest static void test_method_three_3() {

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

		Group cola_1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'ADMINISTRACIÓN DE CONTRATOS'];

		Case caso_3 = new Case();
		caso_3.AccountId = acc.Id;
		caso_3.ContactId = ctc.Id;
		caso_3.Contrato_Filial__c = contratoFilial_3.Id;
		caso_3.Type = 'Solicitud';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		insert caso_3;

		caso_3.Motivo__c = '_Pedidos de Tarjeta';
		caso_3.Sub_Motivo__c = 'Cambio de persona';
		update caso_3;			

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'TEST';
		subMotivo.Grupo_Soporte_6__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		Test.startTest();	

		caso_3.OwnerId = cola_1.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_6__c = 'TEST';
		subMotivo.Grupo_Soporte_7__c = 'ADMINISTRACIÓN DE CONTRATOS';
		update subMotivo;

		caso_3.OwnerId = cola_1.Id;
		update caso_3;

		Test.stopTest();
	}

	@isTest static void test_method_three_4() {

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

		caso_3.Motivo__c = '_Pedidos de Tarjeta';
		caso_3.Sub_Motivo__c = 'Cambio de persona';
		update caso_3;

		Test.startTest();

		caso_3.TicketCampoVacio__c = false;
		caso_3.Status = 'En Proceso';
		update caso_3;

		caso_3.OwnerId = usr1.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_1__c = 'TEST';
		subMotivo.Grupo_Soporte_2__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_3.OwnerId = usr2.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_3.OwnerId = usr1.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_3.OwnerId = usr2.Id;
		update caso_3;
		
		Test.stopTest();
	}

	@isTest static void test_method_three_5() {

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

		caso_3.Motivo__c = '_Pedidos de Tarjeta';
		caso_3.Sub_Motivo__c = 'Cambio de persona';
		update caso_3;

		subMotivo.Grupo_Soporte_1__c = 'TEST';
		subMotivo.Grupo_Soporte_2__c = 'TEST';
		subMotivo.Grupo_Soporte_3__c = 'TEST';
		subMotivo.Grupo_Soporte_4__c = 'TEST';
		subMotivo.Grupo_Soporte_5__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		Test.startTest();	

		caso_3.OwnerId = usr1.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_5__c = 'TEST';
		subMotivo.Grupo_Soporte_6__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_3.OwnerId = usr2.Id;
		update caso_3;

		subMotivo.Grupo_Soporte_6__c = 'TEST';
		subMotivo.Grupo_Soporte_7__c = 'ASESORÍA COMERCIAL';
		update subMotivo;

		caso_3.OwnerId = usr1.Id;
		update caso_3;

		Test.stopTest();
	}*/
}