/**
	* @author calvarez@ctconsulting.com.mx
	* @date 06/04/2018
	* @description Clase de prueba para clase EC_ListaEntidadLegal_LC_Ctrl
	* @group EstructuraCuentas
*/

@isTest
private class EC_ListaEntidadLegal_LC_Test {

	@isTest
	static void buscarDireccion() {
		EC_ListaEntidadLegal_LC_Ctrl.buscarDireccion( '06030' );
	}

	@isTest
	static void getRecordsType() {
		EC_ListaEntidadLegal_LC_Ctrl.getRecordsType( 'EntidadLegal__c' );
	}

	@isTest
	static void guardaEntidadLegal() {
		Id recordTypeFisica = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();
        EntidadLegal__c el = new EntidadLegal__c( Name = 'BBDF880303L23', RecordTypeId = recordTypeFisica );
		el.Estatus__c = 'Completa';
		el.RazonSocial__c = 'Completa';
		el.Calle__c = 'Completa';
		el.NumeroExterior__c = 'Completa';
		el.Colonia__c = 'Completa';
		el.DelegacionMunicipioFiscal__c = 'Completa';
		el.CodigoPostal__c = 'Completa';
		el.Ciudad__c = 'Completa';
		el.Estado__c = 'Completa'; 
		CatalogoDirecciones__c cd=new CatalogoDirecciones__c();
        cd.Name='test';
        insert cd;
        insert el;
		EC_ListaEntidadLegal_LC_Ctrl.guardaEntidadLegal( el );
		EC_ListaEntidadLegal_LC_Ctrl.getDireccionesCuenta('003jfkdkdooif');
		List<EntidadLegal__c> listaEL = [SELECT Id FROM EntidadLegal__c LIMIT 2];

		//el.Id = listaEL[0].Id;

		el.Address__c=cd.Id;
		EC_ListaEntidadLegal_LC_Ctrl.guardaEntidadLegal( el );
		EC_ListaEntidadLegal_LC_Ctrl.getTipoDeSociedad();
	}

	@isTest(seeAllData=false)
	static void eliminaEntidadCuenta() {
		List<TiposDocumento__c> tipos = new List<TiposDocumento__c>();
		tipos.add(new TiposDocumento__c(
			ActaConstitutivaCliente__c = true, AltaSHCP__c = true, CedulaRFC__c = true, ComprobanteDomicilioCliente__c = true, ComprobanteDomicilioFiscal__c = true, ConstanciaRFC__c = true, ConstanciaRFCCliente__c = true, ContratoFirmado__c = true, CURP__c = true, FM3__c = true, AdjuntoA__c = true, IdentificacionOficialCliente__c = true, PoderNotarial__c = true, RegistroPatronal__c = true, RFC__c = true, RFCDoc__c = true, Name = 'Persona Moral EL'));
		
		tipos.add(new TiposDocumento__c(
			ActaConstitutivaCliente__c = true, AltaSHCP__c = true, CedulaRFC__c = true, ComprobanteDomicilioCliente__c = true, ComprobanteDomicilioFiscal__c = true, ConstanciaRFC__c = true, ConstanciaRFCCliente__c = true, ContratoFirmado__c = true, CURP__c = true, FM3__c = true, AdjuntoA__c = true, IdentificacionOficialCliente__c = true, PoderNotarial__c = true, RegistroPatronal__c = true, RFC__c = true, RFCDoc__c = true, Name = 'Persona Física EL'));

		tipos.add(new TiposDocumento__c(
			ActaConstitutivaCliente__c = true, AltaSHCP__c = true, CedulaRFC__c = true, ComprobanteDomicilioCliente__c = true, ComprobanteDomicilioFiscal__c = true, ConstanciaRFC__c = true, ConstanciaRFCCliente__c = true, ContratoFirmado__c = true, CURP__c = true, FM3__c = true, AdjuntoA__c = true, IdentificacionOficialCliente__c = true, PoderNotarial__c = true, RegistroPatronal__c = true, RFC__c = true, RFCDoc__c = true, Name = 'DocumentosOportunidad'));
		insert tipos;


		Account cuenta = new Account(Name ='Cuenta maestra',NumeroEmpleados__c = '1-25',NumeroVehiculos__c = '1-5');
		insert cuenta;
		Contact contacto = new Contact();
		contacto.LastName = 'Sola';
		contacto.AccountId = cuenta.Id;
		contacto.Extranjero__c = true;
		contacto.Funcion__c = 'Representante Legal';
        contacto.Curp__c = 'VAVR950615MVZZZB10';
        contacto.isCurp__c = true;
		insert contacto;
		EntidadLegal__c eL = new EntidadLegal__c();
        eL.Name = 'CUPO800825569';
        eL.RazonSocial__c = 'R';
       // eL.Cuenta__c = cuenta.Id;
        insert eL;
        EntidadCuenta__c eC = new EntidadCuenta__c(Cuenta__c = cuenta.Id, EntidadLegal__c = eL.Id);
        insert eC;

        ContactoEntidad__c cE = new ContactoEntidad__c(Contacto__c = contacto.Id,Entidad_Cuenta__c = eC.Id,EntidadLegal__c = eL.Id);
        insert cE;

        EC_ListaEntidadLegal_LC_Ctrl.actualizaEstatusEntidad(eL, 'Completa');


		EC_ListaEntidadLegal_LC_Ctrl.eliminaEntidadCuenta( eC.Id );
		//EC_ListaEntidadLegal_LC_Ctrl.getAddressAccount( cuenta.Id );
	}

	@isTest
	static void getEntidadByRFC() {
		EC_ListaEntidadLegal_LC_Ctrl.getEntidadByRFC('123');
	}

		@isTest
	static void testContactoEntidad() {
		EC_ListaEntidadLegal_LC_Ctrl.executeQuery( 'SELECT Id FROM Account LIMIT 1' );
		EC_ListaEntidadLegal_LC_Ctrl.describeSObjects( new List<String>{'Account', 'Opportunity'} );

		Id recordTypeFisica = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();

		Account acc = new Account( Name = 'testAccount', NumeroEmpleados__c = '1-25', NumeroVehiculos__c  = '1-5' );
        insert acc;

		Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = acc.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com', Funcion__c = 'Representante Legal',Curp__c='VAVR950616MVZZZB09',isCurp__c=TRUE);
		insert cont;
		
		EntidadLegal__c el = new EntidadLegal__c( Name = 'BBDF880303L23', RecordTypeId = recordTypeFisica );
		insert el;

		el.Estatus__c = 'Completa';
		update el;

		EntidadCuenta__c ec = new EntidadCuenta__c( Cuenta__c = acc.Id, EntidadLegal__c = el.Id );
		insert ec;

		ContactoEntidad__c ce = new ContactoEntidad__c( Contacto__c = cont.Id, Entidad_Cuenta__c = ec.Id );
		insert ce;

		EC_ListaEntidadLegal_LC_Ctrl.getEntidadByAccount( acc.Id );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.getEntidadByAccount( null );
		} catch( Exception e ) {}
		try {
			EC_ListaEntidadLegal_LC_Ctrl.getEntidadByAccount( cont.Id );
		} catch( Exception e ) {}

		EC_ListaEntidadLegal_LC_Ctrl.getEntidadByName( 'Contacto', acc.Id );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.getEntidadByName( null, acc.Id );
		} catch( Exception e ) {}


		EC_ListaEntidadLegal_LC_Ctrl.guardaEntidadCuenta( ec );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.guardaEntidadCuenta( new EntidadCuenta__c( Cuenta__c = acc.Id, EntidadLegal__c = el.Id) );
		} catch( Exception e ) {
			System.debug('Error guardaEntidadCuenta: ' + e);
		}


		try {
			EC_ListaEntidadLegal_LC_Ctrl.guardaEntidadCuenta( null );
		} catch( Exception e ) {}


		// Contacto Entidad 
		EC_ListaEntidadLegal_LC_Ctrl.getEntidadCuenta( ec.Id );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.getEntidadCuenta( null );
		} catch( Exception e ) {}


		EC_ListaEntidadLegal_LC_Ctrl.getContactoByEntidad( ec.Id );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.getContactoByEntidad( null );
		} catch( Exception e ) {}


		EC_ListaEntidadLegal_LC_Ctrl.getContactoEntidad( ce.Id );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.getContactoEntidad( null );
		} catch( Exception e ) {}


		EC_ListaEntidadLegal_LC_Ctrl.getContactoByAccount( acc.Id, 'Contacto' );
		EC_ListaEntidadLegal_LC_Ctrl.getContactoByAccount( acc.Id, 'Co' );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.getContactoByAccount( null, 'Contacto' );
		} catch( Exception e ) {}


		EC_ListaEntidadLegal_LC_Ctrl.saveContactoEntidad( ce );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.saveContactoEntidad( null );
		} catch( Exception e ) {}
		try {
			EC_ListaEntidadLegal_LC_Ctrl.saveContactoEntidad( new ContactoEntidad__c( Contacto__c = cont.Id, Entidad_Cuenta__c = null ) );
		} catch( Exception e ) {}
		try {
			EC_ListaEntidadLegal_LC_Ctrl.saveContactoEntidad( new ContactoEntidad__c( Contacto__c = null, Entidad_Cuenta__c = ec.Id ) );
		} catch( Exception e ) {}
		try {
			EC_ListaEntidadLegal_LC_Ctrl.saveContactoEntidad( new ContactoEntidad__c( Contacto__c = cont.Id, Entidad_Cuenta__c = ec.Id ) );
		} catch( Exception e ) {}


		EC_ListaEntidadLegal_LC_Ctrl.removeContactoEntidad( ce.Id );
		try {
			EC_ListaEntidadLegal_LC_Ctrl.removeContactoEntidad( null );
		} catch( Exception e ) {}
		try {
			EC_ListaEntidadLegal_LC_Ctrl.removeContactoEntidad( ce.Id );
		} catch( Exception e ) {}

	}

}