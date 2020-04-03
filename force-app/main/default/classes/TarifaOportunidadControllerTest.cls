@isTest
private class TarifaOportunidadControllerTest {
	@isTest 
    static void testStandardUse() {
    	

          /*Producto__c producto = new 	Producto__c(Name='hsodia', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
            Account cta = new Account(Name='cuenta');
            insert cta;
            Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                               Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                              CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
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
            apexPages.StandardController std = new apexPages.StandardController(opp);
            TarifaOportunidadController convertir = new TarifaOportunidadController(std);
        List<SelectOption> uso= convertir.getUso();
        
      convertir.getTipoSolucion();
        TarifaOportunidadController.buscaProducto('hsodia');
        convertir.verificaContratoExistente();
        convertir.guardar();
        List<TarifaOportunidadController.WrappedBonificaciones> boni = new List<TarifaOportunidadController.WrappedBonificaciones>(); 
        convertir.catalogoTarifas.add(new TarifaOportunidadController.WrappedTarifas(uso,nueva,tarifa1,true,true,boni));
        Tarifa__c tarifa = convertir.catalogoTarifas[0].tarifa;
        Boolean esTarifa = convertir.catalogoTarifas[0].esTarifa;
        String tipoCargo = convertir.catalogoTarifas[0].tipoCargo;
        String getTarifaSeleccionada = convertir.catalogoTarifas[0].getTarifaSeleccionada();
       	convertir.catalogoTarifas[0].setTarifaSeleccionada(nueva.Id);
        List<SelectOption> tarifas = convertir.catalogoTarifas[0].tarifas;
        TarifaOportunidad__c tarifaOportunidad = convertir.catalogoTarifas[0].tarifaOportunidad;
        */
            
    }
	@isTest 
    static void completo() {

       /* Producto__c producto = new 	Producto__c(Name='sdas,fassa,fsa', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
            Account cta = new Account(Name='cuenta');
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
			System.currentPageReference().getParameters().put('id', opp.Id);
            apexPages.StandardController std = new apexPages.StandardController(opp);
            TarifaOportunidadController convertir = new TarifaOportunidadController(std);
        List<SelectOption> uso= convertir.getUso();
        convertir.subproductosSeleccionados='sdas,fassa,fsa';
        convertir.productos='sdas,fassa,fsa';
        convertir.buscar();
        convertir.getTipoSolucion();
        TarifaOportunidadController.buscaProducto('hsodia');
        convertir.oportunidad.ContratoTCM__c=contratoPrueba.Id;
        convertir.verificaContratoExistente();
        convertir.guardar();
        List<TarifaOportunidadController.WrappedBonificaciones> boni = new List<TarifaOportunidadController.WrappedBonificaciones>(); 
        
        uso.clear();
        uso.add(new SelectOption('122','4241'));
        convertir.catalogoTarifas.add(new TarifaOportunidadController.WrappedTarifas(uso,nueva,tarifa1,true,true,boni));
        Tarifa__c tarifa = convertir.catalogoTarifas[0].tarifa;
        Boolean esTarifa = convertir.catalogoTarifas[0].esTarifa;
        String tipoCargo = convertir.catalogoTarifas[0].tipoCargo;
        String getTarifaSeleccionada = convertir.catalogoTarifas[0].getTarifaSeleccionada();
       	convertir.catalogoTarifas[0].setTarifaSeleccionada(nueva.Id);
        List<SelectOption> tarifas = convertir.catalogoTarifas[0].tarifas;
        TarifaOportunidad__c tarifaOportunidad = convertir.catalogoTarifas[0].tarifaOportunidad;
        */
    }
}