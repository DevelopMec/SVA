@isTest
public class GenerarXMLControllerTest {
	
	/*@isTest 
	static void testStandardUse() {
        Producto__c producto = new 	Producto__c(Name='sdas,fassa,fsa', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
            Account cta = new Account(Name='cuenta', NumeroEmpleados__c = '1 - 125');
            insert cta;
            Contact cont = new Contact(LastName = 'Contacto prueba', AccountId = cta.Id, Puesto__c = 'Consultor', Email = 'pruebasxyz@mail.com');
            insert cont;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                               Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                              CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp;
        
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
            contratoPrueba.ContactoDecide__c = cont.Id;
            contratoPrueba.ContactoSolicita__c = cont.Id;
            contratoPrueba.OtroContacto__c = cont.Id;
            contratoPrueba.Estado__c = 'Estado prueba, 123';
        	upsert contratoPrueba;
            cont.Contrato__c = contratoPrueba.Id;
            update cont;

        DireccionEntrega__c dir = new DireccionEntrega__c(Calle__c = 'a', ClaveDireccion__c = '1', Descripcion__c = '1', Direccion__c = '1', NumExterior__c = '1', NumInterior__c = '1', CodigoPostal__c = '1', Colonia__c = '1', Ciudad__c = '1', Estado__c = '1', AtencionA__c = '1', Puesto__c = '1', Telefono__c = '1', Extension__c = 11, Email__c = 'email1@mail.com', Horario__c = '1', NombrePersonalizar__c = '1', DireccionPersonalizar__c = '1', Observaciones__c = '1',Estatus__c = '1');
        dir.Contrato__c = contratoPrueba.Id;
        dir.ContratoPersonalizado__c = contratoPrueba.Id;
        insert dir;

        Tarifa__c nueva = new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert nueva;
        Tarifa__c escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento',SubProducto__c='fassa',Producto__c=producto.Id);
        insert escalonamiento;
        escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
		TarifaOportunidad__c tarifa1= new TarifaOportunidad__c(  Producto__c=producto.Id, Importe__c=12.3, Porcentaje__c=0.2, Observaciones__c='Ninfuna',TipoCargo__c='21', TipoSolucion__c='21',Uso__c='213;21',Oportunidad__c=opp.Id,Tarifa__c=nueva.Id, Subproductos__c='sdas,fassa,fsa' );         
           insert tarifa1; 
           
            // Test.setCurrentPageReference(new PageReference('Page.myPage'));
			// System.currentPageReference().getParameters().put('idObjeto', contratoPrueba.Id);
			// System.currentPageReference().getParameters().put('tipo', 'TC3');
            // apexPages.StandardController std = new apexPages.StandardController(contratoPrueba);
            // GenerarXMLController convertir = new GenerarXMLController(std);
        	GenerarXMLController convertir = new GenerarXMLController(opp.Id, contratoPrueba.Id);

            // System.currentPageReference().getParameters().put('tipo', 'TCM');
            // std = new apexPages.StandardController(contratoPrueba);
            // convertir = new GenerarXMLController(std);

            // System.currentPageReference().getParameters().put('tipo', 'TCMx');
            // std = new apexPages.StandardController(contratoPrueba);
            // convertir = new GenerarXMLController(std);
        
    } */
	
	/* @isTest 
	static void TCM() {
        Producto__c producto = new 	Producto__c(Name='sdas,fassa,fsa', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
            Account cta = new Account(Name='cuenta', NumeroEmpleados__c = '1 - 125');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                               Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                              CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp;
        
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
        Tarifa__c nueva = new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert nueva;
        Tarifa__c escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento',SubProducto__c='fassa',Producto__c=producto.Id);
        insert escalonamiento;
        escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
		TarifaOportunidad__c tarifa1= new TarifaOportunidad__c(  Producto__c=producto.Id, Importe__c=12.3, Porcentaje__c=0.2, Observaciones__c='Ninfuna',TipoCargo__c='21', TipoSolucion__c='21',Uso__c='213;21',Oportunidad__c=opp.Id,Tarifa__c=nueva.Id, Subproductos__c='sdas,fassa,fsa' );         
           insert tarifa1; 
           
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('idObjeto', contratoPrueba.Id);
			System.currentPageReference().getParameters().put('tipo', 'TCM');
            apexPages.StandardController std = new apexPages.StandardController(contratoPrueba);
            GenerarXMLController convertir = new GenerarXMLController(std);
        
    } */
	
	/* @isTest 
	static void NADA() {
        Producto__c producto = new 	Producto__c(Name='sdas,fassa,fsa', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
            Account cta = new Account(Name='cuenta', NumeroEmpleados__c = '1 - 125');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                               Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                              CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
            insert opp;
        
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
        Tarifa__c nueva = new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert nueva;
        Tarifa__c escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento',SubProducto__c='fassa',Producto__c=producto.Id);
        insert escalonamiento;
        escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
		TarifaOportunidad__c tarifa1= new TarifaOportunidad__c(  Producto__c=producto.Id, Importe__c=12.3, Porcentaje__c=0.2, Observaciones__c='Ninfuna',TipoCargo__c='21', TipoSolucion__c='21',Uso__c='213;21',Oportunidad__c=opp.Id,Tarifa__c=nueva.Id, Subproductos__c='sdas,fassa,fsa' );         
           insert tarifa1; 
           
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('idObjeto', contratoPrueba.Id);
            apexPages.StandardController std = new apexPages.StandardController(contratoPrueba);
            GenerarXMLController convertir = new GenerarXMLController(std);
        
    } */
	
	@isTest
	public static void generaDocumentoXMLTest1() {
        Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
        
		Opportunity opp = (Opportunity)mapOppQuoP2PeQli.get('Opportunity');
        Product2 p2 = (Product2)mapOppQuoP2PeQli.get('Product2');
        QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Contrato2__c c2 = new Contrato2__c();
        c2.PartidaPresupuesto__c = qli.Id;
        c2.ComoFactura__c = 'Empresa';
        c2.Item_Contratacion__c = 'TC Basico';
		insert c2;
        Concepto__c c = new Concepto__c(TipoCargo__c = 'Anualidad - Grande', Producto__c = p2.Id, Importe__c = 1.1, ClaveReferencia__c = 'XXXX');
        insert c;
        ProductoConcepto__c pc = new ProductoConcepto__c(Concepto__c = c.Id, PartidaPresupuesto__c = qli.Id, EsProductoComparado__c = false, Bonificacion__c = 1.0);
        insert pc;
        Negocio__c n = new Negocio__c(IdOportunidadOPAM__c = 422, IdCuentaOPAM__c = 12, EmailXML__c = 'car@gmail.com', ClaveReferenciaAnualidad__c = 'XXXX');
		insert n;
		//GenerarXMLController gxmlc = new GenerarXMLController(opp.Id, c2.Id);
        List<String> result= new List<String>();
        result.add(GenerarXMLController.generaDocumentoXMLExtras(opp,c2,'Nombre'));
        GenerarXMLController.enviarMail2(opp,c2,result,true);
	}
	
	/*@isTest
    public static void crearDOMTest1() {
        Opportunity opp = TestDataFactory_TEST.createOpportunity();
		Contrato2__c c2 = new Contrato2__c();
		insert c2;
		GenerarXMLController gxmlc = new GenerarXMLController(opp.Id, c2.Id);
        gxmlc.crearDOM();
    }*/
}