public  class GenerarXMLController {
    String tipo {get;set;}
    String idObjeto{get;set;}
    // public Contrato__c contrato {get;set;}
    public String xmlContent {get;set;}
    public Boolean exitoContrato{get;set;}
    public QuoteLineItem qli {get; set;}
    public OpportunityLineItem oli {get; set;}
 
    // Nueva estructura de XML calvarez 10 de abril de 2018
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 10/04/2018
        * @param opportunityId Id de un registro de Opportunity
        * @param contratoId Id de un registro de Contrato2__c
        * @description Constructor que inicializa los datos para generar XML.
    **/
   /* public GenerarXMLController( Id opportunityId, Id contratoId ) {
        Opportunity opp = new Opportunity();
        Contrato2__c contrato = (Contrato2__c) Database.query('SELECT ' + String.join( new List<String>( SObjectType.Contrato2__c.Fields.getMap().keySet() ), ', ') + ', Entidad_Cuenta__r.Name, Entidad_Cuenta__r.Cuenta__r.Giro__c, Entidad_Cuenta__r.Cuenta__r.Sector__c, Entidad_Legal__r.RazonSocial__c, Entidad_Legal__r.Name, Entidad_Legal__r.Direccion__c, Entidad_Legal__r.Calle__c, Entidad_Legal__r.NumeroExterior__c, Entidad_Legal__r.NumeroInterior__c, Entidad_Legal__r.CodigoPostal__c, Entidad_Legal__r.Colonia__c, Entidad_Legal__r.Ciudad__c, Entidad_Legal__r.Estado__c, PartidaPresupuesto__r.Product2.ProductCode, PartidaPresupuesto__r.Product2.Familia__c, PartidaPresupuesto__r.ComentariosCotizacion__c, PartidaPresupuesto__r.Quote.QuoteNumber, PartidaPresupuesto__r.FormaPago__c, Contacto__r.Phone, Contacto__r.Email, Contacto__r.Extension__c FROM Contrato2__c WHERE id =: contratoId');
        
        for( Opportunity oppAux : [SELECT Id, Name, NumeroOportunidad__c, AccountId, ComisionEmision__c, Competidor__c, OwnerId, Owner.Name, Owner.Segmento__c, Owner.NumeroTerritorio__c, Contacto__r.FirstName, Contacto__r.LastName, Contacto__r.Puesto__c, Contacto__r.HorarioOficina__c, Contacto__r.Phone, Contacto__r.Email, Contacto__r.Extension__c, Contacto__r.TipoContacto__c, Contacto__r.Calle__c, Contacto__r.NumeroInterior__c, Contacto__r.NumeroExterior__c, Contacto__r.Colonia__c, Contacto__r.Ciudad__c, Contacto__r.Estado__c, Contacto__r.DelegacionMunicipio__c FROM Opportunity WHERE Id =: opportunityId] ) {
            opp = oppAux;
            break;
        }

        generaDocumentoXML( opp, contrato );

    }

    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 11/04/2018
        * @param opp Registro de Opportunity
        * @param contrato Registro de Contrato2__c
        * @description Genera la estructura del XML.
    **//*
    public void generaDocumentoXML( Opportunity opp, Contrato2__c contrato ) {
        try {
            List<ProductoConcepto__c> tarifas = [SELECT Id, Concepto__r.TipoCargo__c, Concepto__r.NombreSistemas__c, Concepto__r.Orden__c, Concepto__r.Obligatorio__c, PrecioLista__c, PrecioFinal__c, Bonificacion__c, Notas__c, PrecioLista2__c, AjusteInflacion__c, AplicaAniversario__c, AplicaCobroComisionMinima__c, MesAplica__c, Concepto__r.ClaveReferencia__c, FechaInicio__c, FechaFinal__c, PartidaPresupuesto__r.Product2.NombreSistemas__c FROM ProductoConcepto__c WHERE PartidaPresupuesto__c =: contrato.PartidaPresupuesto__c];
            String comisionEmision = '';
            for( ProductoConcepto__c pc : tarifas ) {
                if( pc.Concepto__r != null && pc.Concepto__r.TipoCargo__c == 'Comisión por el servicio' ) {
                    comisionEmision = pc.PrecioFinal__c != null ? String.valueOf(pc.PrecioFinal__c) : '';
                }
            }
    
            Map<String,String> mapGiro = Utils.MAP_GIRO;
            Dom.Document doc = new Dom.Document();
            Dom.Xmlnode rootNode = doc.createRootElement('response', null, null);
            Dom.Xmlnode contratoNode = rootNode.addChildElement('Contrato', null, null);
            contratoNode.setAttribute('Tipo','TC3');
            contratoNode.addChildElement('IdSalesforce',null,null).addTextNode(contrato.Id);
            contratoNode.addChildElement('FolioSalesforce',null,null).addTextNode(opp.NumeroOportunidad__c);
            contratoNode.addChildElement('Oportunidad', null, null).addTextNode(nullToString(opp.Name));
            contratoNode.addChildElement('PorcentajeComision', null, null).addTextNode(comisionEmision);
            contratoNode.addChildElement('Cuenta', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.RazonSocial__c));
            contratoNode.addChildElement('RazonSocial', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.RazonSocial__c));
            contratoNode.addChildElement('RFC', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Name));
            contratoNode.addChildElement('Segmento', null, null).addTextNode(nullToString(opp.Owner.Segmento__c));
            // contratoNode.addChildElement('Sucursal', null, null).addTextNode(nullToString(contrato.Sucursal_Facturacion_Global__c));
            contratoNode.addChildElement('Sucursal', null, null).addTextNode( 'DISTRITO FEDERAL' );
            contratoNode.addChildElement('Producto', null, null).addTextNode(nullToString(String.valueOf(contrato.PartidaPresupuesto__r.Product2.ProductCode)));
            contratoNode.addChildElement('Grupo', null, null).addTextNode('0');
            contratoNode.addChildElement('NumeroCliente', null, null).addTextNode('0');
            contratoNode.addChildElement('Giro', null, null).addTextNode(nullToString(mapGiro.containsKey(contrato.Entidad_Cuenta__r.Cuenta__r.Giro__c) ? mapGiro.get(contrato.Entidad_Cuenta__r.Cuenta__r.Giro__c) :'999'));
            contratoNode.addChildElement('Sector', null, null).addTextNode(nullToString(contrato.Entidad_Cuenta__r.Cuenta__r.Sector__c));
            contratoNode.addChildElement('Fax', null, null).addTextNode('0');
            contratoNode.addChildElement('Familia', null, null).addTextNode('Combustible');
            contratoNode.addChildElement('Migracion', null, null).addTextNode('false');
            contratoNode.addChildElement('NumeroSolicitud', null, null).addTextNode(nullToString(opp.NumeroOportunidad__c));
            contratoNode.addChildElement('OrigenVenta', null, null).addTextNode('CAMBACEO'); 
            contratoNode.addChildElement('Territorio', null, null).addTextNode(nullToString(String.valueOf(opp.Owner.NumeroTerritorio__c)));
            contratoNode.addChildElement('NombreEjecutivo', null, null).addTextNode(nullToString(opp.Owner.Name));
            // contratoNode.addChildElement('Posvendedor', null, null).addTextNode(nullToString(String.valueOf('')));
            contratoNode.addChildElement('Posvendedor', null, null).addTextNode(' ');
            contratoNode.addChildElement('VersionContrato', null, null).addTextNode(nullToString('TVWT-001'));
            contratoNode.addChildElement('Competidor', null, null).addTextNode(nullToString(opp.Competidor__c));
            contratoNode.addChildElement('UsuarioAS400', null, null).addTextNode('0');
            contratoNode.addChildElement('CodigoCliente', null, null).addTextNode(nullToString(contrato.CodigoAS400__c));
            contratoNode.addChildElement('EstatusAltaTC3', null, null).addTextNode(' ');
            contratoNode.addChildElement('DireccionFactura', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Calle__c).replace(',',' ')+' '+nullToString(contrato.Entidad_Legal__r.NumeroExterior__c).replace(',',' ')+' '+nullToString(contrato.Entidad_Legal__r.NumeroInterior__c).replace(',',' ')
                +' '+nullToString(contrato.Entidad_Legal__r.CodigoPostal__c).replace(',',' ') +' '+nullToString(contrato.Entidad_Legal__r.Colonia__c).replace(',',' ')+' '+nullToString(contrato.Entidad_Legal__r.Ciudad__c).replace(',',' ')+' '+nullToString(contrato.Entidad_Legal__r.Estado__c).replace(',',' '));
            contratoNode.addChildElement('Calle', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Calle__c).replace(',',' '));
            contratoNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.NumeroExterior__c).replace(',',' '));
            contratoNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.NumeroInterior__c).replace(',',' '));
            contratoNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.CodigoPostal__c));
            contratoNode.addChildElement('Colonia', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Colonia__c).replace(',',' '));
            contratoNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Ciudad__c).replace(',',' '));
            contratoNode.addChildElement('Estado', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Estado__c).replace(',',' '));
            contratoNode.addChildElement('TipoPago', null, null).addTextNode(nullToString(contrato.TipoPago__c == 'Pospago' ? 'Por Consumo' : 'Por Pedido'));
            contratoNode.addChildElement('CondicionesPago', null, null).addTextNode(nullToString(contrato.CondicionesPago__c));
            contratoNode.addChildElement('Financiamiento', null, null).addTextNode('No utiliza');
            contratoNode.addChildElement('ModoTransaccion', null, null).addTextNode(nullToString(contrato.Modo_Transaccion__c));
            contratoNode.addChildElement('PagoCargosFinanciamiento', null, null).addTextNode('False');
            contratoNode.addChildElement('TipoFinanciamiento', null, null).addTextNode(' ');
            contratoNode.addChildElement('Clasificacion', null, null).addTextNode(' ');
            contratoNode.addChildElement('CargoRecurrenteConFinanciamiento', null, null).addTextNode('False');
            contratoNode.addChildElement('FrecuenciaLiberacionAutomatica', null, null).addTextNode(nullToString(contrato.Frecuencia_Liberacion_Automatica__c));      
            contratoNode.addChildElement('LineaOperativa', null, null).addTextNode(nullToString(String.valueOf(contrato.Linea_Operativa__c)));   
            contratoNode.addChildElement('VentanaRiesgo', null, null).addTextNode(nullToString(String.valueOf(contrato.Ventana_de_Riesgos__c))); 
            contratoNode.addChildElement('Monto', null, null).addTextNode(nullToString('0'));
            contratoNode.addChildElement('Observaciones', null, null).addTextNode(nullToString(contrato.PartidaPresupuesto__r.ComentariosCotizacion__c));
            contratoNode.addChildElement('DiaLiberacion', null, null).addTextNode(nullToString(contrato.Dia_Liberacion__c));
            contratoNode.addChildElement('Dia', null, null).addTextNode(nullToString(contrato.Dia__c));
            contratoNode.addChildElement('DiaInicio', null, null).addTextNode(nullToString(contrato.Dia_Inicio__c));
            contratoNode.addChildElement('ProximaCarga', null, null).addTextNode(nullToString(contrato.Proxima_Carga__c));
            // contratoNode.addChildElement('TipoFacturacion', null, null).addTextNode(nullToString(contrato.Tipo_de_Facturacion__c));
            contratoNode.addChildElement('TipoFacturacion', null, null).addTextNode('Por Consumo – Detallada');
            contratoNode.addChildElement('FrecuenciaFacturacion', null, null).addTextNode(nullToString(contrato.FrecuenciaFacturacion__c));
            contratoNode.addChildElement('EmailQueRecibeFactura', null, null).addTextNode(nullToString(contrato.CorreoRecibeFactura__c));
            String comoFactura = contrato.ComoFactura__c;
            if( contrato.ComoFactura__c == 'Empresa' ) {
                comoFactura = 'Por Empresa';
    
            } else if( contrato.ComoFactura__c == 'Consolidada' ) {
                comoFactura = 'Consolidador';
    
            } else if( contrato.ComoFactura__c == 'Grupo de Facturación' ) {
                comoFactura = 'Grupo de Facturación';
    
            } else if( contrato.ComoFactura__c == 'Por Estructura Organizacional' ) {
                comoFactura = 'Estructura Órganizacional';
            }
            contratoNode.addChildElement('ComoFactura', null, null).addTextNode(nullToString(comoFactura));
            contratoNode.addChildElement('TipoCliente', null, null).addTextNode(nullToString('Web'));//contrato.TipoCliente__c
            contratoNode.addChildElement('EsConsolidador', null, null).addTextNode(nullToString(String.valueOf(contrato.Consolidador__c)));
            contratoNode.addChildElement('SucursalConsolidacion', null, null).addTextNode(nullToString(contrato.Sucursal_Facturacion_Global__c));
            // contratoNode.addChildElement('ProductoConsolidacion', null, null).addTextNode(nullToString(contrato.Producto_Factura_Global__c));
            contratoNode.addChildElement('ProductoConsolidacion', null, null).addTextNode(' ');
            contratoNode.addChildElement('GrupoConsolidacion', null, null).addTextNode(nullToString(contrato.GrupoConsolidacion__c)); 
            contratoNode.addChildElement('ClienteConsolidacion', null, null).addTextNode(nullToString(contrato.Cliente_Facturacion_Global__c));
            contratoNode.addChildElement('SucursalFacturacionGlobal', null, null).addTextNode(nullToString(contrato.Sucursal_Facturacion_Global__c));
            // contratoNode.addChildElement('ProductoFacturacionGlobal', null, null).addTextNode(nullToString(contrato.Producto_Factura_Global__c));
            contratoNode.addChildElement('ProductoFacturacionGlobal', null, null).addTextNode(' ');
            contratoNode.addChildElement('GrupoFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.GrupoConsolidacion__c)));
            contratoNode.addChildElement('ClienteFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.Cliente_Facturacion_Global__c)));
            // contratoNode.addChildElement('FacturacionCargos', null, null).addTextNode(nullToString(contrato.Facturacion_Cargos__c));
            // contratoNode.addChildElement('FacturacionPlastico', null, null).addTextNode(nullToString(contrato.Facturacion_Plasticos__c));
            // contratoNode.addChildElement('FacturacionComision', null, null).addTextNode(nullToString(contrato.Facturacion_Comision__c));
            contratoNode.addChildElement('FacturacionCargos', null, null).addTextNode('Separado del Consumo');
            contratoNode.addChildElement('FacturacionPlastico', null, null).addTextNode('Separado del Consumo');
            contratoNode.addChildElement('FacturacionComision', null, null).addTextNode('Junto con el Consumo');
            contratoNode.addChildElement('VolEmisionEstimadoMensual', null, null).addTextNode(nullToString(String.valueOf(contrato.MontoEstimadoConsumoMensual__c)));
            contratoNode.addChildElement('VIP', null, null).addTextNode(nullToString(String.valueOf(contrato.VIP__c)));
            contratoNode.addChildElement('EmpresaPrincipal', null, null).addTextNode(' False');
            contratoNode.addChildElement('IdPrime', null, null).addTextNode(' ');
            String itemContratacion = contrato.Item_Contratacion__c;
            if( contrato.Item_Contratacion__c == 'TC Basico') {
                itemContratacion = 'TC Básico';
            }
            contratoNode.addChildElement('ItemContratacion', null, null).addTextNode( nullToString(itemContratacion ));
            contratoNode.addChildElement('PermiteAutorizacionTelefonica', null, null).addTextNode(nullToString(String.valueOf(contrato.Permite_Autorizacion_Telefonica__c)));
            contratoNode.addChildElement('ImprimeLogo', null, null).addTextNode(nullToString(String.valueOf(contrato.ImprimeLogo__c)));
            contratoNode.addChildElement('TipoPlasticoTarjetaFinanciera', null, null).addTextNode(' ');
            contratoNode.addChildElement('TipoPlasticoTarjetaStock', null, null).addTextNode(nullToString(contrato.TipoPlastico__c));
            contratoNode.addChildElement('BombaPropia', null, null).addTextNode(nullToString(String.valueOf(contrato.BombaPropia__c)));
            // contratoNode.addChildElement('Maneja', null, null).addTextNode(nullToString(contrato.Item_Contratacion__c));
            contratoNode.addChildElement('Maneja', null, null).addTextNode(' ');
            contratoNode.addChildElement('Red', null, null).addTextNode(nullToString(' '));
            contratoNode.addChildElement('ManejaConductores', null, null).addTextNode(nullToString(String.valueOf(contrato.Maneja_Conductores__c)));
            contratoNode.addChildElement('ManejaNotaVale', null, null).addTextNode(nullToString(String.valueOf(contrato.Maneja_Nota_Vale__c)));
            contratoNode.addChildElement('OperaTcTruck', null, null).addTextNode(nullToString(String.valueOf(contrato.Opera_TC_Truck__c)));
            contratoNode.addChildElement('ControlaPresenciaVehiculoNFC', null, null).addTextNode(nullToString(String.valueOf(contrato.Controla_Presencia_Vehiculo_NFC__c)));
            contratoNode.addChildElement('NoMostrarKm', null, null).addTextNode(nullToString(String.valueOf(contrato.No_Mostrar_Km__c)));
            contratoNode.addChildElement('ControlVolumetrico', null, null).addTextNode(nullToString(String.valueOf(contrato.ControlVolumetrico__c)));
            contratoNode.addChildElement('OperacionModoOffline', null, null).addTextNode(nullToString(contrato.ModoOffline__c));
            contratoNode.addChildElement('ImpedirComprarDiaHabil', null, null).addTextNode('False');
            contratoNode.addChildElement('ImpedirComprarSabado', null, null).addTextNode('False');
            contratoNode.addChildElement('ImpedirComprarDomingo', null, null).addTextNode('False');
            contratoNode.addChildElement('CantidadMaxTransaccionesOffline', null, null).addTextNode(' ');
            contratoNode.addChildElement('ValorMaxParaUnaTransaccion', null, null).addTextNode(' ');
            contratoNode.addChildElement('IntervaloEntreTransacciones', null, null).addTextNode(' ');
            contratoNode.addChildElement('NombrePersonalizacion', null, null).addTextNode(' ');
            contratoNode.addChildElement('FrecuenciaPedido', null, null).addTextNode(nullToString('30'));//contrato.Frecuencia_de_Pedido__c
            contratoNode.addChildElement('MedioPago', null, null).addTextNode(nullToString('Ficha de Deposito'));//contrato.PartidaPresupuesto__r.FormaPago__c
            contratoNode.addChildElement('NumeroOportunidad', null, null).addTextNode(nullToString(contrato.PartidaPresupuesto__r.Quote.QuoteNumber));
            contratoNode.addChildElement('MetodoPago', null, null).addTextNode(nullToString('Otros'));//contrato.PartidaPresupuesto__r.FormaPago__c
            contratoNode.addChildElement('ObservacionesEjecutivos', null, null).addTextNode(nullToString(contrato.PartidaPresupuesto__r.ComentariosCotizacion__c));
            contratoNode.addChildElement('ContactoDesissor', null, null).addTextNode(nullToString('Pendiente'));
            contratoNode.addChildElement('UsuarioMaster', null, null).addTextNode(nullToString(opp.Owner.Name));
            contratoNode.addChildElement('ComentariosAdministracionVentas', null, null).addTextNode(nullToString(contrato.Comentarios_ADV__c));
            // contratoNode.addChildElement('Maquila', null, null).addTextNode(nullToString(String.valueOf(contrato.TipoPago__c)));
            contratoNode.addChildElement('Maquila', null, null).addTextNode( contrato.Maquila__c ? 'True' : 'False' );
            contratoNode.addChildElement('TipoMaquila', null, null).addTextNode(nullToString(contrato.Tipo_Maquila__c));
    
    
            Dom.Xmlnode contactosNode = rootNode.addChildElement('Contactos', null, null);
            Map<String, Contact> mapContact = new Map<String, Contact>(); 
            Map<String, String> mapFuciones = new Map<String, String>{'Quien decide' => 'Contacto que decide', 'Quien solicita' => 'Contacto que solicita', 'Otro' => 'Otro contacto'};
            List<AccountContactRelation> listContacts = [SELECT Id, AccountId, ContactId,  Contact.Funcion__c, Contact.FirstName, Contact.LastName, Contact.Puesto__c, Contact.HorarioOficina__c, Contact.Phone, Contact.Email, Contact.Extension__c, Contact.TipoContacto__c, Contact.Calle__c, Contact.NumeroInterior__c, Contact.NumeroExterior__c, Contact.Colonia__c, Contact.Ciudad__c, Contact.Estado__c, Contact.DelegacionMunicipio__c FROM AccountContactRelation WHERE AccountId =: opp.AccountId AND Contact.Funcion__c IN : mapFuciones.keySet() ];
            for( AccountContactRelation acc: listContacts ) {
                if( acc.ContactId != null && String.isNotBlank(acc.Contact.Funcion__c) ) {
    
                    Contact cnt = new Contact( Id = acc.ContactId, FirstName = acc.Contact.FirstName, LastName = acc.Contact.LastName, Puesto__c = acc.Contact.Puesto__c, HorarioOficina__c = acc.Contact.HorarioOficina__c, Phone = acc.Contact.Phone, Email = acc.Contact.Email, Extension__c = acc.Contact.Extension__c, TipoContacto__c = acc.Contact.TipoContacto__c, Calle__c = acc.Contact.Calle__c, NumeroInterior__c = acc.Contact.NumeroInterior__c, NumeroExterior__c = acc.Contact.NumeroExterior__c, Colonia__c = acc.Contact.Colonia__c, Ciudad__c = acc.Contact.Ciudad__c, Estado__c = acc.Contact.Estado__c, DelegacionMunicipio__c = acc.Contact.DelegacionMunicipio__c );
                    mapContact.put(acc.Contact.Funcion__c, cnt);
                }
            }
    
            for( String funcion : mapFuciones.keySet() ) {
                Contact cnt = new Contact();
                if( mapContact.containsKey( funcion ) ) {
                    cnt = mapContact.get( funcion );
                } else {
                    cnt = opp.Contacto__r == null ? new Contact() : new Contact(FirstName = opp.Contacto__r.FirstName, LastName = opp.Contacto__r.LastName, Puesto__c = opp.Contacto__r.Puesto__c, HorarioOficina__c = opp.Contacto__r.HorarioOficina__c, Phone = opp.Contacto__r.Phone, Email = opp.Contacto__r.Email, Extension__c = opp.Contacto__r.Extension__c, TipoContacto__c = opp.Contacto__r.TipoContacto__c, Calle__c = opp.Contacto__r.Calle__c, NumeroInterior__c = opp.Contacto__r.NumeroInterior__c, NumeroExterior__c = opp.Contacto__r.NumeroExterior__c, Colonia__c = opp.Contacto__r.Colonia__c, Ciudad__c = opp.Contacto__r.Ciudad__c, Estado__c = opp.Contacto__r.Estado__c, DelegacionMunicipio__c = opp.Contacto__r.DelegacionMunicipio__c);
                    // cnt = opp.Contacto__r;
                }
    
                if( String.isBlank(cnt.Extension__c )) {
                    cnt.Extension__c = '0';
                }

                Dom.Xmlnode contactoNode = contactosNode.addChildElement('Contacto', null, null);
                contactoNode.addChildElement('Nombre', null, null).addTextNode(nullToString(cnt.FirstName));
                contactoNode.addChildElement('Apellidos', null, null).addTextNode(nullToString(cnt.LastName));
                contactoNode.addChildElement('Puesto', null, null).addTextNode(nullToString(cnt.Puesto__c));
                contactoNode.addChildElement('HorarioOficina', null, null).addTextNode(nullToString(cnt.HorarioOficina__c));
                contactoNode.addChildElement('Telefono', null, null).addTextNode(nullToString(cnt.Phone));
                contactoNode.addChildElement('Extension', null, null).addTextNode(nullToString(cnt.Extension__c));
                contactoNode.addChildElement('Email', null, null).addTextNode(nullToString(cnt.Email));
                contactoNode.addChildElement('TipoContacto', null, null).addTextNode(nullToString( mapFuciones.get( funcion ) ));
                contactoNode.addChildElement('Calle', null, null).addTextNode(nullToString(cnt.Calle__c));
                contactoNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString(cnt.NumeroInterior__c));
                contactoNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(cnt.NumeroExterior__c));
                contactoNode.addChildElement('Colonia', null, null).addTextNode(nullToString(cnt.Colonia__c));
                contactoNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(cnt.Ciudad__c));
                contactoNode.addChildElement('Estado', null, null).addTextNode(nullToString(cnt.Estado__c));
                contactoNode.addChildElement('Municipio', null, null).addTextNode(nullToString(cnt.DelegacionMunicipio__c));
    
            }
    
            if( contrato.Contacto__r != null && contrato.Contacto__r.Extension__c == null ) {
                contrato.Contacto__r.Extension__c = '0';
            }
    
            Dom.Xmlnode direccionesEntregaNode = rootNode.addChildElement('DireccionesEntrega', null, null);
            Dom.Xmlnode direccionNode = direccionesEntregaNode.addChildElement('DireccionEntrega', null, null);
            direccionNode.addChildElement('NoSolicitud', null, null).addTextNode(nullToString('Pendiente'));
            direccionNode.addChildElement('ClaveEntrega', null, null).addTextNode('ENTR');
            direccionNode.addChildElement('Descripcion', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Calle__c));
            direccionNode.addChildElement('Direccion', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Direccion__c));
            direccionNode.addChildElement('Telefono', null, null).addTextNode(nullToString(String.valueOf(contrato.Contacto__r.Phone)));
            direccionNode.addChildElement('Extension', null, null).addTextNode(nullToString(String.valueOf(contrato.Contacto__r.Extension__c)));
            direccionNode.addChildElement('Email', null, null).addTextNode(nullToString(contrato.Contacto__r.Email));
            direccionNode.addChildElement('Calle', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Calle__c));
            direccionNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.NumeroExterior__c== '' ? '-' : contrato.Entidad_Legal__r.NumeroExterior__c));
            direccionNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.NumeroInterior__c==''?'-':contrato.Entidad_Legal__r.NumeroInterior__c));
            direccionNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.CodigoPostal__c));
            direccionNode.addChildElement('Colonia', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Colonia__c));
            direccionNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Ciudad__c));
            direccionNode.addChildElement('Estado', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Estado__c));
            direccionNode.addChildElement('HoraOficina', null, null).addTextNode('9:00 a 6:00');
            direccionNode.addChildElement('AtencionA', null, null).addTextNode('NA');
            direccionNode.addChildElement('Cargo', null, null).addTextNode('NA');
            direccionNode.addChildElement('Observaciones', null, null).addTextNode(' ');
            direccionNode.addChildElement('NombrePersonalizar', null, null).addTextNode(' ');
            direccionNode.addChildElement('DireccionPersonalizar', null, null).addTextNode(nullToString(contrato.Entidad_Legal__r.Calle__c));
            direccionNode.addChildElement('Estatus', null, null).addTextNode('A');
    
            Dom.Xmlnode tarifasNode = rootNode.addChildElement('Tarifas', null, null);
            String COM_EMI = 'Comisión por el servicio';
            String mesAplica = ' ';
            String ClaveReferenciaAnualidad = String.isNotBlank(Negocio__c.getOrgDefaults().ClaveReferenciaAnualidad__c) ? Negocio__c.getOrgDefaults().ClaveReferenciaAnualidad__c : 'CA02';
            for( ProductoConcepto__c tarifa : tarifas ) {
                mesAplica = ' ';
                Dom.Xmlnode tnode = tarifasNode.addChildElement('Tarifa', null, null);
                tnode.setAttribute('Nombre', nullToString(tarifa.Concepto__r.TipoCargo__c).replaceAll('/', ''));
                tnode.setAttribute('ClaveReferencia',nullToString(tarifa.Concepto__r.ClaveReferencia__c));
                tnode.addChildElement('NombreTarifa', null, null).addTextNode(nullToString(tarifa.Concepto__r.NombreSistemas__c).replaceAll('/', ''));
                if( tarifa.Concepto__r.TipoCargo__c == COM_EMI ) { //Tarifa es porcentaje - Precio en cero y porcentaje con valor
                    tnode.addChildElement('Precio', null, null).addTextNode(String.valueOf(0));
                    tnode.addChildElement('Porcentaje', null, null).addTextNode(String.valueOf(tarifa.PrecioLista2__c != null ? tarifa.PrecioLista2__c : 0));
                } else { //Costo fijo - Precio con valor y porcentaje en cero
                    tnode.addChildElement('Precio', null, null).addTextNode(String.valueOf(tarifa.PrecioLista__c != null ? tarifa.PrecioLista__c : 0));
                    tnode.addChildElement('Porcentaje', null, null).addTextNode(String.valueOf(0));
                }
                tnode.addChildElement('AjusteInflacion', null, null).addTextNode(nullToString(String.valueOf(tarifa.AjusteInflacion__c)));
                tnode.addChildElement('AplicaCobroComisionMinima', null, null).addTextNode(nullToString(String.valueOf(tarifa.AplicaCobroComisionMinima__c)));
                if(String.isNotBlank(tarifa.Concepto__r.ClaveReferencia__c) && String.isNotBlank(ClaveReferenciaAnualidad)  && tarifa.Concepto__r.ClaveReferencia__c == ClaveReferenciaAnualidad ) {
                     mesAplica = tarifa.MesAplica__c != null ? tarifa.MesAplica__c : ' ';
                }
                tnode.addChildElement('AplicaAniversario', null, null).addTextNode(nullToString(String.valueOf(tarifa.AplicaAniversario__c)));
                tnode.addChildElement('MesAplica', null, null).addTextNode(mesAplica);
    
                // Validar con @msantos si se continua creando el nodo - @calvarez 11 abril de 2018
                Dom.Xmlnode escalonamientoNode = tnode.addChildElement('Escalonamientos', null, null);
            }
    
            Dom.Xmlnode lineasImpresionTarjetaTC3Node = rootNode.addChildElement('LineasImpresion', null, null);
            // Dom.Xmlnode lineaNode = lineasImpresionTarjetaTC3Node.addChildElement('LineaImpresionTarjeta', null, null);
            // lineaNode.addChildElement('Orden', null, null).addTextNode('<LineasImpresion/>');
            // lineaNode.addChildElement('DescripcionLineaImpresion', null, null).addTextNode('<LineasImpresion/>');
            // lineaNode.addChildElement('Identificador', null, null).addTextNode('<LineasImpresion/>');
    
            Dom.Xmlnode calendariosNode = rootNode.addChildElement('Calendarios', null, null);
            // Dom.Xmlnode calendarioNode = calendariosNode.addChildElement('Calendario', null, null);
            // calendarioNode.addChildElement('FechaInicio', null, null).addTextNode('<Calendarios/>');
            // calendarioNode.addChildElement('FechaFin', null, null).addTextNode('<Calendarios/>');
            
            Dom.Xmlnode bonifiacionesNode = rootNode.addChildElement('Bonificaciones', null, null);
            for(ProductoConcepto__c tarifa : tarifas) {
                if( tarifa.Bonificacion__c != null && tarifa.Bonificacion__c != 0 ) {
                    Dom.Xmlnode bonifiacionNode = bonifiacionesNode.addChildElement('Bonificacion', null, null);
                    bonifiacionNode.setAttribute('Tarifa', nullToString(tarifa.Concepto__r.NombreSistemas__c));
                    bonifiacionNode.setAttribute('ClaveReferencia', nullToString(tarifa.Concepto__r.ClaveReferencia__c));
                    bonifiacionNode.addChildElement('ValorPorcentual', null, null).addTextNode(String.valueOf(tarifa.Bonificacion__c != NULL ? tarifa.Bonificacion__c : 0));
                    bonifiacionNode.addChildElement('ValorFijo', null, null).addTextNode(String.valueOf(0));
                    bonifiacionNode.addChildElement('FechaInicio', null, null).addTextNode(nullToString(String.valueOf(tarifa.FechaInicio__c)));
                    bonifiacionNode.addChildElement('FechaFinal', null, null).addTextNode(nullToString(String.valueOf(tarifa.FechaFinal__c)));
                }
            }
            xmlContent = doc.toXmlString().trim().replaceAll(',', ' ');
            exitoContrato = true;
            enviarMail( opp, contrato, xmlContent );
            System.debug('xmlContent: ' + xmlContent);
        } catch( Exception ex ) {
            System.debug('generaDocumentoXML Exception: ' + ex + ', ' + ex.getStackTraceString());
        }
    }*/



    public static String generaDocumentoXMLExtras( Opportunity opp, Contrato2__c contrato, String nombre ) {
    String xmlContent;
    try {
            List<ProductoConcepto__c> tarifas = [SELECT Id, Concepto__r.TipoCargo__c, Concepto__r.NombreSistemas__c, Concepto__r.Orden__c, Concepto__r.Obligatorio__c, PrecioLista__c, PrecioFinal__c, Bonificacion__c, Notas__c, PrecioLista2__c, AjusteInflacion__c, AplicaAniversario__c, AplicaCobroComisionMinima__c, MesAplica__c, Concepto__r.ClaveReferencia__c, FechaInicio__c, FechaFinal__c, PartidaPresupuesto__r.Product2.NombreSistemas__c FROM ProductoConcepto__c WHERE PartidaPresupuesto__c =: contrato.PartidaPresupuesto__c];
            String comisionEmision = '';
            for( ProductoConcepto__c pc : tarifas ) {
                if( pc.Concepto__r != null && pc.Concepto__r.TipoCargo__c == 'Comisión por el servicio' ) {
                    comisionEmision = pc.PrecioFinal__c != null ? String.valueOf(pc.PrecioFinal__c) : '';
                }
            }
    
            Map<String,String> mapGiro = Utils.MAP_GIRO;
            Dom.Document doc = new Dom.Document();
            Dom.Xmlnode rootNode = doc.createRootElement('response', null, null);
            Dom.Xmlnode contratoNode = rootNode.addChildElement('Contrato', null, null);
            contratoNode.setAttribute('Tipo','TC3');
            contratoNode.addChildElement('IdSalesforce',null,null).addTextNode(contrato.Id);
            contratoNode.addChildElement('FolioSalesforce',null,null).addTextNode(nombre);
            contratoNode.addChildElement('Oportunidad', null, null).addTextNode(nullToString2(opp.Name));
            contratoNode.addChildElement('PorcentajeComision', null, null).addTextNode(comisionEmision);
            contratoNode.addChildElement('Cuenta', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.RazonSocial__c));
            contratoNode.addChildElement('RazonSocial', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.RazonSocial__c));
            contratoNode.addChildElement('RFC', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Name));
            contratoNode.addChildElement('Segmento', null, null).addTextNode(nullToString2(opp.Owner.Segmento__c));
            // contratoNode.addChildElement('Sucursal', null, null).addTextNode(nullToString2(contrato.Sucursal_Facturacion_Global__c));
            contratoNode.addChildElement('Sucursal', null, null).addTextNode( 'DISTRITO FEDERAL' );
            contratoNode.addChildElement('Producto', null, null).addTextNode(nullToString2(String.valueOf(contrato.PartidaPresupuesto__r.Product2.ProductCode)));
            contratoNode.addChildElement('Grupo', null, null).addTextNode('0');
            contratoNode.addChildElement('NumeroCliente', null, null).addTextNode('0');
            contratoNode.addChildElement('Giro', null, null).addTextNode(nullToString2(mapGiro.containsKey(contrato.Entidad_Cuenta__r.Cuenta__r.Giro__c) ? mapGiro.get(contrato.Entidad_Cuenta__r.Cuenta__r.Giro__c) :'999'));
            contratoNode.addChildElement('Sector', null, null).addTextNode(nullToString2(contrato.Entidad_Cuenta__r.Cuenta__r.Sector__c));
            contratoNode.addChildElement('Fax', null, null).addTextNode('0');
            contratoNode.addChildElement('Familia', null, null).addTextNode('Combustible');
            contratoNode.addChildElement('Migracion', null, null).addTextNode('false');
            contratoNode.addChildElement('NumeroSolicitud', null, null).addTextNode(nullToString2(opp.NumeroOportunidad__c));
            contratoNode.addChildElement('OrigenVenta', null, null).addTextNode('CAMBACEO'); 
            contratoNode.addChildElement('Territorio', null, null).addTextNode(nullToString2(String.valueOf(opp.Owner.NumeroTerritorio__c)));
            contratoNode.addChildElement('NombreEjecutivo', null, null).addTextNode(nullToString2(opp.Owner.Name));
            // contratoNode.addChildElement('Posvendedor', null, null).addTextNode(nullToString2(String.valueOf('')));
            contratoNode.addChildElement('Posvendedor', null, null).addTextNode(' ');
            contratoNode.addChildElement('VersionContrato', null, null).addTextNode(nullToString2('TVWT-001'));
            contratoNode.addChildElement('Competidor', null, null).addTextNode(nullToString2(opp.Competidor__c));
            contratoNode.addChildElement('UsuarioAS400', null, null).addTextNode('0');
            contratoNode.addChildElement('CodigoCliente', null, null).addTextNode(nullToString2(contrato.CodigoAS400__c));
            contratoNode.addChildElement('EstatusAltaTC3', null, null).addTextNode(' ');
            contratoNode.addChildElement('DireccionFactura', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Calle__c).replace(',',' ')+' '+nullToString2(contrato.Entidad_Legal__r.NumeroExterior__c).replace(',',' ')+' '+nullToString2(contrato.Entidad_Legal__r.NumeroInterior__c).replace(',',' ')
                +' '+nullToString2(contrato.Entidad_Legal__r.CodigoPostal__c).replace(',',' ') +' '+nullToString2(contrato.Entidad_Legal__r.Colonia__c).replace(',',' ')+' '+nullToString2(contrato.Entidad_Legal__r.Ciudad__c).replace(',',' ')+' '+nullToString2(contrato.Entidad_Legal__r.Estado__c).replace(',',' '));
            contratoNode.addChildElement('Calle', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Calle__c).replace(',',' '));
            contratoNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.NumeroExterior__c).replace(',',' '));
            contratoNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.NumeroInterior__c).replace(',',' '));
            contratoNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.CodigoPostal__c));
            contratoNode.addChildElement('Colonia', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Colonia__c).replace(',',' '));
            contratoNode.addChildElement('Ciudad', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Ciudad__c).replace(',',' '));
            contratoNode.addChildElement('Estado', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Estado__c).replace(',',' '));
            contratoNode.addChildElement('TipoPago', null, null).addTextNode(nullToString2(contrato.TipoPago__c == 'Pospago' ? 'Por Consumo' : 'Por Pedido'));
            contratoNode.addChildElement('CondicionesPago', null, null).addTextNode(nullToString2(contrato.CondicionesPagoPlazo__c));
            contratoNode.addChildElement('Financiamiento', null, null).addTextNode('No utiliza');
            contratoNode.addChildElement('ModoTransaccion', null, null).addTextNode(nullToString2(contrato.Modo_Transaccion__c));
            contratoNode.addChildElement('PagoCargosFinanciamiento', null, null).addTextNode('False');
            contratoNode.addChildElement('TipoFinanciamiento', null, null).addTextNode(' ');
            contratoNode.addChildElement('Clasificacion', null, null).addTextNode(' ');
            contratoNode.addChildElement('CargoRecurrenteConFinanciamiento', null, null).addTextNode('False');
            contratoNode.addChildElement('FrecuenciaLiberacionAutomatica', null, null).addTextNode(nullToString2(contrato.Frecuencia_Liberacion_Automatica__c));      
            contratoNode.addChildElement('LineaOperativa', null, null).addTextNode(nullToString2(String.valueOf(contrato.Linea_Operativa__c)));   
            contratoNode.addChildElement('VentanaRiesgo', null, null).addTextNode(nullToString2(String.valueOf(contrato.Ventana_de_Riesgos__c))); 
            contratoNode.addChildElement('Monto', null, null).addTextNode(nullToString2('0'));
            contratoNode.addChildElement('Observaciones', null, null).addTextNode(nullToString2(contrato.PartidaPresupuesto__r.ComentariosCotizacion__c));
            contratoNode.addChildElement('DiaLiberacion', null, null).addTextNode(nullToString2(contrato.Dia_Liberacion__c));
            contratoNode.addChildElement('Dia', null, null).addTextNode(nullToString2(contrato.Dia__c));
            contratoNode.addChildElement('DiaInicio', null, null).addTextNode(nullToString2(contrato.Dia_Inicio__c));
            contratoNode.addChildElement('ProximaCarga', null, null).addTextNode(nullToString2(contrato.Proxima_Carga__c));
            // contratoNode.addChildElement('TipoFacturacion', null, null).addTextNode(nullToString2(contrato.Tipo_de_Facturacion__c));
            contratoNode.addChildElement('TipoFacturacion', null, null).addTextNode('Por Consumo - Detallada');
            contratoNode.addChildElement('FrecuenciaFacturacion', null, null).addTextNode(nullToString2(contrato.FrecuenciaFacturacion__c));
            contratoNode.addChildElement('EmailQueRecibeFactura', null, null).addTextNode(nullToString2(contrato.CorreoRecibeFactura__c));
            String comoFactura = contrato.ComoFactura__c;
            if( contrato.ComoFactura__c == 'Empresa' ) {
                comoFactura = 'Por Empresa';
    
            } else if( contrato.ComoFactura__c == 'Consolidada' ) {
                comoFactura = 'Consolidador';
    
            } else if( contrato.ComoFactura__c == 'Grupo de Facturación' ) {
                comoFactura = 'Grupo de Facturación';
    
            } else if( contrato.ComoFactura__c == 'Por Estructura Organizacional' ) {
                comoFactura = 'Estructura Órganizacional';
            }
            contratoNode.addChildElement('ComoFactura', null, null).addTextNode(nullToString2(comoFactura));
            contratoNode.addChildElement('TipoCliente', null, null).addTextNode(nullToString2('Web'));//contrato.TipoCliente__c
            contratoNode.addChildElement('EsConsolidador', null, null).addTextNode(nullToString2(String.valueOf(contrato.Consolidador__c)));
            contratoNode.addChildElement('SucursalConsolidacion', null, null).addTextNode(nullToString2(contrato.Sucursal_Facturacion_Global__c));
            // contratoNode.addChildElement('ProductoConsolidacion', null, null).addTextNode(nullToString2(contrato.Producto_Factura_Global__c));
            contratoNode.addChildElement('ProductoConsolidacion', null, null).addTextNode(' ');
            contratoNode.addChildElement('GrupoConsolidacion', null, null).addTextNode(nullToString2(contrato.GrupoConsolidacion__c)); 
            contratoNode.addChildElement('ClienteConsolidacion', null, null).addTextNode(nullToString2(contrato.Cliente_Facturacion_Global__c));
            contratoNode.addChildElement('SucursalFacturacionGlobal', null, null).addTextNode(nullToString2(contrato.Sucursal_Facturacion_Global__c));
            // contratoNode.addChildElement('ProductoFacturacionGlobal', null, null).addTextNode(nullToString2(contrato.Producto_Factura_Global__c));
            contratoNode.addChildElement('ProductoFacturacionGlobal', null, null).addTextNode(' ');
            contratoNode.addChildElement('GrupoFacturacionGlobal', null, null).addTextNode(nullToString2(String.valueOf(contrato.GrupoConsolidacion__c)));
            contratoNode.addChildElement('ClienteFacturacionGlobal', null, null).addTextNode(nullToString2(String.valueOf(contrato.Cliente_Facturacion_Global__c)));
            // contratoNode.addChildElement('FacturacionCargos', null, null).addTextNode(nullToString2(contrato.Facturacion_Cargos__c));
            // contratoNode.addChildElement('FacturacionPlastico', null, null).addTextNode(nullToString2(contrato.Facturacion_Plasticos__c));
            // contratoNode.addChildElement('FacturacionComision', null, null).addTextNode(nullToString2(contrato.Facturacion_Comision__c));
            contratoNode.addChildElement('FacturacionCargos', null, null).addTextNode('Separado del Consumo');
            contratoNode.addChildElement('FacturacionPlastico', null, null).addTextNode('Separado del Consumo');
            contratoNode.addChildElement('FacturacionComision', null, null).addTextNode('Junto con el Consumo');
            contratoNode.addChildElement('VolEmisionEstimadoMensual', null, null).addTextNode(nullToString2(String.valueOf(contrato.MontoEstimadoConsumoMensual__c)));
            contratoNode.addChildElement('VIP', null, null).addTextNode(nullToString2(String.valueOf(contrato.VIP__c)));
            contratoNode.addChildElement('EmpresaPrincipal', null, null).addTextNode(' False');
            contratoNode.addChildElement('IdPrime', null, null).addTextNode(' ');
            String itemContratacion = contrato.Item_Contratacion__c;
            if( contrato.Item_Contratacion__c == 'TC Basico') {
                itemContratacion = 'TC Básico';
            }
            contratoNode.addChildElement('ItemContratacion', null, null).addTextNode( nullToString2(itemContratacion ));
            contratoNode.addChildElement('PermiteAutorizacionTelefonica', null, null).addTextNode(nullToString2(String.valueOf(contrato.Permite_Autorizacion_Telefonica__c)));
            contratoNode.addChildElement('ImprimeLogo', null, null).addTextNode(nullToString2(String.valueOf(contrato.ImprimeLogo__c)));
            contratoNode.addChildElement('TipoPlasticoTarjetaFinanciera', null, null).addTextNode(' ');
            contratoNode.addChildElement('TipoPlasticoTarjetaStock', null, null).addTextNode(nullToString2(contrato.TipoPlastico__c));
            contratoNode.addChildElement('BombaPropia', null, null).addTextNode(nullToString2(String.valueOf(contrato.BombaPropia__c)));
            // contratoNode.addChildElement('Maneja', null, null).addTextNode(nullToString2(contrato.Item_Contratacion__c));
            contratoNode.addChildElement('Maneja', null, null).addTextNode(' ');
            contratoNode.addChildElement('Red', null, null).addTextNode(nullToString2(' '));
            contratoNode.addChildElement('ManejaConductores', null, null).addTextNode(nullToString2(String.valueOf(contrato.Maneja_Conductores__c)));
            contratoNode.addChildElement('ManejaNotaVale', null, null).addTextNode(nullToString2(String.valueOf(contrato.Maneja_Nota_Vale__c)));
            contratoNode.addChildElement('OperaTcTruck', null, null).addTextNode(nullToString2(String.valueOf(contrato.Opera_TC_Truck__c)));
            contratoNode.addChildElement('ControlaPresenciaVehiculoNFC', null, null).addTextNode(nullToString2(String.valueOf(contrato.Controla_Presencia_Vehiculo_NFC__c)));
            contratoNode.addChildElement('NoMostrarKm', null, null).addTextNode(nullToString2(String.valueOf(contrato.No_Mostrar_Km__c)));
            contratoNode.addChildElement('ControlVolumetrico', null, null).addTextNode(nullToString2(String.valueOf(contrato.ControlVolumetrico__c)));
            contratoNode.addChildElement('OperacionModoOffline', null, null).addTextNode(nullToString2(contrato.ModoOffline__c));
            contratoNode.addChildElement('ImpedirComprarDiaHabil', null, null).addTextNode('False');
            contratoNode.addChildElement('ImpedirComprarSabado', null, null).addTextNode('False');
            contratoNode.addChildElement('ImpedirComprarDomingo', null, null).addTextNode('False');
            contratoNode.addChildElement('CantidadMaxTransaccionesOffline', null, null).addTextNode(' ');
            contratoNode.addChildElement('ValorMaxParaUnaTransaccion', null, null).addTextNode(' ');
            contratoNode.addChildElement('IntervaloEntreTransacciones', null, null).addTextNode(' ');
            contratoNode.addChildElement('NombrePersonalizacion', null, null).addTextNode(' ');
            contratoNode.addChildElement('FrecuenciaPedido', null, null).addTextNode(nullToString2('30'));//contrato.Frecuencia_de_Pedido__c
            contratoNode.addChildElement('MedioPago', null, null).addTextNode(nullToString2('Ficha de Deposito'));//contrato.PartidaPresupuesto__r.FormaPago__c
            contratoNode.addChildElement('NumeroOportunidad', null, null).addTextNode(nullToString2(contrato.PartidaPresupuesto__r.Quote.QuoteNumber));
            contratoNode.addChildElement('MetodoPago', null, null).addTextNode(nullToString2('Otros'));//contrato.PartidaPresupuesto__r.FormaPago__c
            contratoNode.addChildElement('ObservacionesEjecutivos', null, null).addTextNode(nullToString2(contrato.PartidaPresupuesto__r.ComentariosCotizacion__c));
            contratoNode.addChildElement('ContactoDesissor', null, null).addTextNode(nullToString2('Pendiente'));
            contratoNode.addChildElement('UsuarioMaster', null, null).addTextNode(nullToString2(opp.Owner.Name));
            contratoNode.addChildElement('ComentariosAdministracionVentas', null, null).addTextNode(nullToString2(contrato.Comentarios_ADV__c));
            // contratoNode.addChildElement('Maquila', null, null).addTextNode(nullToString2(String.valueOf(contrato.TipoPago__c)));
            contratoNode.addChildElement('Maquila', null, null).addTextNode( contrato.Maquila__c ? 'True' : 'False' );
            contratoNode.addChildElement('TipoMaquila', null, null).addTextNode(nullToString2(contrato.Tipo_Maquila__c));
    
    
            Dom.Xmlnode contactosNode = rootNode.addChildElement('Contactos', null, null);
            Map<String, Contact> mapContact = new Map<String, Contact>(); 
            Map<String, String> mapFuciones = new Map<String, String>{'Quien decide' => 'Contacto que decide', 'Quien solicita' => 'Contacto que solicita', 'Otro' => 'Otro contacto'};
            List<AccountContactRelation> listContacts = [SELECT Id, AccountId, ContactId,  Contact.Funcion__c, Contact.FirstName, Contact.LastName, Contact.Puesto__c, Contact.HorarioOficina__c, Contact.Phone, Contact.Email, Contact.Extension__c, Contact.TipoContacto__c, Contact.Calle__c, Contact.NumeroInterior__c, Contact.NumeroExterior__c, Contact.Colonia__c, Contact.Ciudad__c, Contact.Estado__c, Contact.DelegacionMunicipio__c FROM AccountContactRelation WHERE AccountId =: opp.AccountId AND Contact.Funcion__c IN : mapFuciones.keySet() ];
            for( AccountContactRelation acc: listContacts ) {
                if( acc.ContactId != null && String.isNotBlank(acc.Contact.Funcion__c) ) {
    
                    Contact cnt = new Contact( Id = acc.ContactId, FirstName = acc.Contact.FirstName, LastName = acc.Contact.LastName, Puesto__c = acc.Contact.Puesto__c, HorarioOficina__c = acc.Contact.HorarioOficina__c, Phone = acc.Contact.Phone, Email = acc.Contact.Email, Extension__c = acc.Contact.Extension__c, TipoContacto__c = acc.Contact.TipoContacto__c, Calle__c = acc.Contact.Calle__c, NumeroInterior__c = acc.Contact.NumeroInterior__c, NumeroExterior__c = acc.Contact.NumeroExterior__c, Colonia__c = acc.Contact.Colonia__c, Ciudad__c = acc.Contact.Ciudad__c, Estado__c = acc.Contact.Estado__c, DelegacionMunicipio__c = acc.Contact.DelegacionMunicipio__c );
                    mapContact.put(acc.Contact.Funcion__c, cnt);
                }
            }
    
            for( String funcion : mapFuciones.keySet() ) {
                Contact cnt = new Contact();
                if( mapContact.containsKey( funcion ) ) {
                    cnt = mapContact.get( funcion );
                } else {
                    cnt = opp.Contacto__r == null ? new Contact() : new Contact(FirstName = opp.Contacto__r.FirstName, LastName = opp.Contacto__r.LastName, Puesto__c = opp.Contacto__r.Puesto__c, HorarioOficina__c = opp.Contacto__r.HorarioOficina__c, Phone = opp.Contacto__r.Phone, Email = opp.Contacto__r.Email, Extension__c = opp.Contacto__r.Extension__c, TipoContacto__c = opp.Contacto__r.TipoContacto__c, Calle__c = opp.Contacto__r.Calle__c, NumeroInterior__c = opp.Contacto__r.NumeroInterior__c, NumeroExterior__c = opp.Contacto__r.NumeroExterior__c, Colonia__c = opp.Contacto__r.Colonia__c, Ciudad__c = opp.Contacto__r.Ciudad__c, Estado__c = opp.Contacto__r.Estado__c, DelegacionMunicipio__c = opp.Contacto__r.DelegacionMunicipio__c);
                    // cnt = opp.Contacto__r;
                }
    
                if( String.isBlank(cnt.Extension__c )) {
                    cnt.Extension__c = '0';
                }

                Dom.Xmlnode contactoNode = contactosNode.addChildElement('Contacto', null, null);
                contactoNode.addChildElement('Nombre', null, null).addTextNode(nullToString2(cnt.FirstName));
                contactoNode.addChildElement('Apellidos', null, null).addTextNode(nullToString2(cnt.LastName));
                contactoNode.addChildElement('Puesto', null, null).addTextNode(nullToString2(cnt.Puesto__c));
                contactoNode.addChildElement('HorarioOficina', null, null).addTextNode(nullToString2(cnt.HorarioOficina__c));
                contactoNode.addChildElement('Telefono', null, null).addTextNode(nullToString2(cnt.Phone));
                contactoNode.addChildElement('Extension', null, null).addTextNode(nullToString2(cnt.Extension__c));
                contactoNode.addChildElement('Email', null, null).addTextNode(nullToString2(cnt.Email));
                contactoNode.addChildElement('TipoContacto', null, null).addTextNode(nullToString2( mapFuciones.get( funcion ) ));
                contactoNode.addChildElement('Calle', null, null).addTextNode(nullToString2(cnt.Calle__c));
                contactoNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString2(cnt.NumeroInterior__c));
                contactoNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString2(cnt.NumeroExterior__c));
                contactoNode.addChildElement('Colonia', null, null).addTextNode(nullToString2(cnt.Colonia__c));
                contactoNode.addChildElement('Ciudad', null, null).addTextNode(nullToString2(cnt.Ciudad__c));
                contactoNode.addChildElement('Estado', null, null).addTextNode(nullToString2(cnt.Estado__c));
                contactoNode.addChildElement('Municipio', null, null).addTextNode(nullToString2(cnt.DelegacionMunicipio__c));
    
            }
    
            if( contrato.Contacto__r != null && contrato.Contacto__r.Extension__c == null ) {
                contrato.Contacto__r.Extension__c = '0';
            }
    
            Dom.Xmlnode direccionesEntregaNode = rootNode.addChildElement('DireccionesEntrega', null, null);
            Dom.Xmlnode direccionNode = direccionesEntregaNode.addChildElement('DireccionEntrega', null, null);
            direccionNode.addChildElement('NoSolicitud', null, null).addTextNode(nullToString2('Pendiente'));
            direccionNode.addChildElement('ClaveEntrega', null, null).addTextNode('ENTR');
            direccionNode.addChildElement('Descripcion', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Calle__c));
            direccionNode.addChildElement('Direccion', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Direccion__c));
            direccionNode.addChildElement('Telefono', null, null).addTextNode(nullToString2(String.valueOf(contrato.Contacto__r.Phone)));
            direccionNode.addChildElement('Extension', null, null).addTextNode(nullToString2(String.valueOf(contrato.Contacto__r.Extension__c)));
            direccionNode.addChildElement('Email', null, null).addTextNode(nullToString2(contrato.Contacto__r.Email));
            direccionNode.addChildElement('Calle', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Calle__c));
            direccionNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.NumeroExterior__c== '' ? '-' : contrato.Entidad_Legal__r.NumeroExterior__c));
            direccionNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.NumeroInterior__c==''?'-':contrato.Entidad_Legal__r.NumeroInterior__c));
            direccionNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.CodigoPostal__c));
            direccionNode.addChildElement('Colonia', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Colonia__c));
            direccionNode.addChildElement('Ciudad', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Ciudad__c));
            direccionNode.addChildElement('Estado', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Estado__c));
            direccionNode.addChildElement('HoraOficina', null, null).addTextNode('9:00 a 6:00');
            direccionNode.addChildElement('AtencionA', null, null).addTextNode('NA');
            direccionNode.addChildElement('Cargo', null, null).addTextNode('NA');
            direccionNode.addChildElement('Observaciones', null, null).addTextNode(' ');
            direccionNode.addChildElement('NombrePersonalizar', null, null).addTextNode(' ');
            direccionNode.addChildElement('DireccionPersonalizar', null, null).addTextNode(nullToString2(contrato.Entidad_Legal__r.Calle__c));
            direccionNode.addChildElement('Estatus', null, null).addTextNode('A');
    
            Dom.Xmlnode tarifasNode = rootNode.addChildElement('Tarifas', null, null);
            String COM_EMI = 'Comisión por el servicio';
            String mesAplica = ' ';
            String ClaveReferenciaAnualidad = String.isNotBlank(Negocio__c.getOrgDefaults().ClaveReferenciaAnualidad__c) ? Negocio__c.getOrgDefaults().ClaveReferenciaAnualidad__c : 'CA02';
            for( ProductoConcepto__c tarifa : tarifas ) {
                mesAplica = ' ';
                Dom.Xmlnode tnode = tarifasNode.addChildElement('Tarifa', null, null);
                tnode.setAttribute('Nombre', nullToString2(tarifa.Concepto__r.TipoCargo__c).replaceAll('/', ''));
                tnode.setAttribute('ClaveReferencia',nullToString2(tarifa.Concepto__r.ClaveReferencia__c));
                tnode.addChildElement('NombreTarifa', null, null).addTextNode(nullToString2(tarifa.Concepto__r.NombreSistemas__c).replaceAll('/', ''));
                if( tarifa.Concepto__r.TipoCargo__c == COM_EMI ) { //Tarifa es porcentaje - Precio en cero y porcentaje con valor
                    tnode.addChildElement('Precio', null, null).addTextNode(String.valueOf(0));
                    tnode.addChildElement('Porcentaje', null, null).addTextNode(String.valueOf(tarifa.PrecioLista2__c != null ? tarifa.PrecioLista2__c : 0));
                } else { //Costo fijo - Precio con valor y porcentaje en cero
                    tnode.addChildElement('Precio', null, null).addTextNode(String.valueOf(tarifa.PrecioLista__c != null ? tarifa.PrecioLista__c : 0));
                    tnode.addChildElement('Porcentaje', null, null).addTextNode(String.valueOf(0));
                }
                tnode.addChildElement('AjusteInflacion', null, null).addTextNode(nullToString2(String.valueOf(tarifa.AjusteInflacion__c)));
                tnode.addChildElement('AplicaCobroComisionMinima', null, null).addTextNode(nullToString2(String.valueOf(tarifa.AplicaCobroComisionMinima__c)));
                if(String.isNotBlank(tarifa.Concepto__r.ClaveReferencia__c) && String.isNotBlank(ClaveReferenciaAnualidad)  && tarifa.Concepto__r.ClaveReferencia__c == ClaveReferenciaAnualidad ) {
                     mesAplica = tarifa.MesAplica__c != null ? tarifa.MesAplica__c : ' ';
                }
                tnode.addChildElement('AplicaAniversario', null, null).addTextNode(nullToString2(String.valueOf(tarifa.AplicaAniversario__c)));
                tnode.addChildElement('MesAplica', null, null).addTextNode(mesAplica);
    
                // Validar con @msantos si se continua creando el nodo - @calvarez 11 abril de 2018
                Dom.Xmlnode escalonamientoNode = tnode.addChildElement('Escalonamientos', null, null);
            }
    
            Dom.Xmlnode lineasImpresionTarjetaTC3Node = rootNode.addChildElement('LineasImpresion', null, null);
            // Dom.Xmlnode lineaNode = lineasImpresionTarjetaTC3Node.addChildElement('LineaImpresionTarjeta', null, null);
            // lineaNode.addChildElement('Orden', null, null).addTextNode('<LineasImpresion/>');
            // lineaNode.addChildElement('DescripcionLineaImpresion', null, null).addTextNode('<LineasImpresion/>');
            // lineaNode.addChildElement('Identificador', null, null).addTextNode('<LineasImpresion/>');
    
            Dom.Xmlnode calendariosNode = rootNode.addChildElement('Calendarios', null, null);
            // Dom.Xmlnode calendarioNode = calendariosNode.addChildElement('Calendario', null, null);
            // calendarioNode.addChildElement('FechaInicio', null, null).addTextNode('<Calendarios/>');
            // calendarioNode.addChildElement('FechaFin', null, null).addTextNode('<Calendarios/>');
            
            Dom.Xmlnode bonifiacionesNode = rootNode.addChildElement('Bonificaciones', null, null);
            for(ProductoConcepto__c tarifa : tarifas) {
                if( tarifa.Bonificacion__c != null && tarifa.Bonificacion__c != 0 ) {
                    Dom.Xmlnode bonifiacionNode = bonifiacionesNode.addChildElement('Bonificacion', null, null);
                    bonifiacionNode.setAttribute('Tarifa', nullToString2(tarifa.Concepto__r.NombreSistemas__c));
                    bonifiacionNode.setAttribute('ClaveReferencia', nullToString2(tarifa.Concepto__r.ClaveReferencia__c));
                    bonifiacionNode.addChildElement('ValorPorcentual', null, null).addTextNode(String.valueOf(tarifa.Bonificacion__c != NULL ? tarifa.Bonificacion__c : 0));
                    bonifiacionNode.addChildElement('ValorFijo', null, null).addTextNode(String.valueOf(0));
                    bonifiacionNode.addChildElement('FechaInicio', null, null).addTextNode(nullToString2(String.valueOf(tarifa.FechaInicio__c)));
                    bonifiacionNode.addChildElement('FechaFinal', null, null).addTextNode(nullToString2(String.valueOf(tarifa.FechaFinal__c)));
                }
            }
            xmlContent = doc.toXmlString().trim().replaceAll(',', ' ');
            //enviarMail2( opp, contrato, xmlContent,true, nombre );
            System.debug('xmlContent: ' + xmlContent);
            return xmlContent;
        } catch( Exception ex ) {
            System.debug('generaDocumentoXML Exception: ' + ex + ', ' + ex.getStackTraceString());
              return null;
        }
        return null;
    }






    
    /*public GenerarXMLController(apexPages.StandardController std){
        exitoContrato=true;
        idObjeto = apexpages.currentpage().getparameters().get('idObjeto') == null ? '' : apexpages.currentpage().getparameters().get('idObjeto');
        tipo = apexpages.currentpage().getparameters().get('tipo') == null ? '' : apexpages.currentpage().getparameters().get('tipo');
         contrato = [SELECT Id,ContactoDecide__c,ContactoSolicita__c,OtroContacto__c,oportunidad__c,Name from Contrato__c where Id =: idObjeto];

        //agrega calvarez 4mar2017 - asignar a xml OpportunityLineItem en lugar de Opportunity
        if(contrato != null && contrato.Id != null) {
            List<QuoteLineItem> lista = [SELECT Id, Quote.QuoteNumber, FormaPago__c FROM QuoteLineItem WHERE ContratoTC3__c=: contrato.Id];
            if(lista != null && lista.size() > 0) {
                qli = lista[0];
            }

            List<OpportunityLineItem> listaOli = [SELECT Id, FormaPago__c FROM OpportunityLineItem WHERE ContratoTC3__c=: contrato.Id];
            if(listaOli != null && listaOli.size() > 0) {
                oli = listaOli[0];
            }
        }
        
        if(contrato.ContactoDecide__c==null||contrato.ContactoSolicita__c==null ||contrato.OtroContacto__c==null ){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Tienes que tener agregados 3 contactos para poder generar el XML' ));
            exitoContrato=false;
            return;
        }
        if([Select Id FROM DireccionEntrega__c Where contrato__c =: idObjeto].size() < 1){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Tienes que tener al menos una dirección de entrega' ));
            exitoContrato=false;
            
            return;
        }
        if(tipo == 'TCM') {
            crearDOMContratoTCM();
        } else if(tipo == 'TC3') {
            try {
                crearDOMContratoTC3();
            } catch(Exception e ){
                System.debug('Exception: ' + e.getMessage() + ', ' + e.getLineNumber() + ', ' + e.getStackTraceString());
            }
        }else{
            crearDOM();
        }
    }*/
    
    public void crearDOM(){
        Dom.Document doc = new Dom.Document();
        Dom.Xmlnode rootNode = doc.createRootElement('response', null, null);
        Dom.Xmlnode contratoNode = rootNode.addChildElement('Contrato', null, null);
        contratoNode.setAttribute('id', '1234567890');
        xmlContent = doc.toXmlString();
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename=ejemplo.xml');
    }
    /*public void crearDOMContratoTCM() {
        list<DireccionEntrega__c> direcciones  = new list<DireccionEntrega__c>();
        list<Contact> contactos  = new list<Contact>();
        Contrato__c contrato = (Contrato__c)Database.query('SELECT ProductoCotizado__r.Product2.Name,cuenta__r.CodigoClienteAS400__c,'+String.join(new List<String>(SObjectType.Contrato__c.Fields.getMap().keySet()), ', ')+' ,Cuenta__r.Name,Oportunidad__r.Name FROM Contrato__c Where id =: idObjeto');
        //calvarez 14 dic 2016 //Contrato__c contrato = (Contrato__c)Database.query('SELECT Producto__r.Name,cuenta__r.CodigoClienteAS400__c,'+String.join(new List<String>(SObjectType.Contrato__c.Fields.getMap().keySet()), ', ')+' ,Cuenta__r.Name,Oportunidad__r.Name FROM Contrato__c Where id =: idObjeto');
        direcciones = Database.query('SELECT '+String.join(new List<String>(SObjectType.DireccionEntrega__c.Fields.getMap().keySet()), ', ')+' FROM DireccionEntrega__c Where ContratoPersonalizado__c =: idObjeto');
        contactos = Database.query('SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ', ')+' FROM Contact Where Contrato__c =: idObjeto');
        
        Dom.Document doc = new Dom.Document();
        Dom.Xmlnode rootNode = doc.createRootElement('Response', null, null);
        Dom.Xmlnode contratoNode = rootNode.addChildElement('Contrato', null, null);
        contratoNode.setAttribute('Tipo','TCM');
        Dom.Xmlnode informacionGeneralNode = contratoNode.addChildElement('InformacionGeneral', null, null);

        //calvarez 4mar2017 verificar si se cambia por Producto de la oportunidad.
            informacionGeneralNode.addChildElement('Oportunidad', null, null).addTextNode(nullToString(contrato.Oportunidad__c));
        
            informacionGeneralNode.addChildElement('Sector', null, null).addTextNode(nullToString(contrato.Sector__c));
            informacionGeneralNode.addChildElement('ContratoFuente', null, null).addTextNode(nullToString(contrato.ContratoFuente__c));
            informacionGeneralNode.addChildElement('FaxCuenta', null, null).addTextNode(nullToString(contrato.Fax__c));
            informacionGeneralNode.addChildElement('Cuenta', null, null).addTextNode(nullToString(contrato.Cuenta__r.Name));
            informacionGeneralNode.addChildElement('FamiliaCorporativa', null, null).addTextNode(nullToString(contrato.FamiliaCorporativa__c));
            informacionGeneralNode.addChildElement('RazonSocial', null, null).addTextNode(nullToString(contrato.RazonSocial__c));
            informacionGeneralNode.addChildElement('NumeroSolcitud', null, null).addTextNode(nullToString(contrato.NumeroSolicitud__c));
            informacionGeneralNode.addChildElement('RFC', null, null).addTextNode(nullToString(contrato.RFC__c));
            informacionGeneralNode.addChildElement('OrigenVenta', null, null).addTextNode(nullToString(contrato.OrigenVenta__c));
            informacionGeneralNode.addChildElement('Segmento', null, null).addTextNode(nullToString(contrato.Segmento__c));
            informacionGeneralNode.addChildElement('Territorio', null, null).addTextNode(nullToString(String.valueOf(contrato.Territorio__c)));
            // informacionGeneralNode.addChildElement('Sucursal', null, null).addTextNode( nullToString(contrato.Sucursal__c));
            informacionGeneralNode.addChildElement('Sucursal', null, null).addTextNode( 'Distrito Federal' );
            informacionGeneralNode.addChildElement('NombreEjecutivo', null, null).addTextNode(nullToString(contrato.NombreEjecutivo__c));
            //calvarez 14 dic 2016//informacionGeneralNode.addChildElement('Producto', null, null).addTextNode(nullToString(contrato.Producto__r.Name));
            informacionGeneralNode.addChildElement('Producto', null, null).addTextNode(nullToString(contrato.ProductoCotizado__r.Product2.Name));
            informacionGeneralNode.addChildElement('EjecutivoPosventa', null, null).addTextNode(nullToString(String.valueOf(contrato.EjecutivoPosventa__c)));
            informacionGeneralNode.addChildElement('Grupo', null, null).addTextNode(nullToString(String.valueOf(contrato.Grupo__c)));
            informacionGeneralNode.addChildElement('Competidor', null, null).addTextNode(nullToString(contrato.ClaveCompetidor__c));
            informacionGeneralNode.addChildElement('NumeroCliente', null, null).addTextNode(nullToString(String.valueOf(contrato.NumeroCliente__c)));
            informacionGeneralNode.addChildElement('UsuarioAS400', null, null).addTextNode(nullToString(contrato.UsuarioAS400__c));
            informacionGeneralNode.addChildElement('Giro', null, null).addTextNode(nullToString(contrato.Giro__c));
            informacionGeneralNode.addChildElement('EstatusAltaTCM', null, null).addTextNode(nullToString(contrato.EstatusAltaTCM__c));
        Dom.Xmlnode direccionFiscalNode = contratoNode.addChildElement('DireccionFiscal', null, null);
            direccionFiscalNode.addChildElement('DireccionFactura', null, null).addTextNode(nullToString(contrato.DireccionFactura__c.replace(',',' ')));
            direccionFiscalNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString(contrato.CodigoPostal__c));
            direccionFiscalNode.addChildElement('Calle', null, null).addTextNode(nullToString(contrato.Calle__c.replace(',',' ')));
            direccionFiscalNode.addChildElement('Colonia', null, null).addTextNode(nullToString(contrato.Colonia__c));
            direccionFiscalNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(contrato.NumeroExterior__c.replace(',',' ')));
            direccionFiscalNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(contrato.Ciudad__c.replace(',',' ')));
            direccionFiscalNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString(contrato.NumeroInterior__c.replace(',',' ')));
            direccionFiscalNode.addChildElement('Estado', null, null).addTextNode(nullToString(contrato.Estado__c));
        Dom.Xmlnode condicionesPagoNode = contratoNode.addChildElement('CondicionesPago', null, null);
            condicionesPagoNode.addChildElement('TipoPago', null, null).addTextNode(nullToString(contrato.ClaveTipoPago__c));
            condicionesPagoNode.addChildElement('MedioPago', null, null).addTextNode(nullToString(contrato.MedioPago__c));
            condicionesPagoNode.addChildElement('CondicionesPago', null, null).addTextNode(nullToString(contrato.CondicionesPago__c));
            condicionesPagoNode.addChildElement('ComisionMinima', null, null).addTextNode(nullToString(String.valueOf(contrato.ComisionMinima__c)));
            condicionesPagoNode.addChildElement('FrecuenciaPedido', null, null).addTextNode(nullToString(contrato.FrecuenciaPedido__c));
        Dom.Xmlnode diaLiberacionNode = contratoNode.addChildElement('DiaLiberacion', null, null);
            diaLiberacionNode.addChildElement('DiaLiberacion', null, null).addTextNode(nullToString(contrato.DiaLiberacion__c));
            diaLiberacionNode.addChildElement('DiaSemana', null, null).addTextNode(nullToString(contrato.DiaSemana__c));
            diaLiberacionNode.addChildElement('DiaInicio', null, null).addTextNode(nullToString(contrato.DiaInicio__c));
            diaLiberacionNode.addChildElement('ProximaCarga', null, null).addTextNode(nullToString(contrato.ProximaCarga__c));
            diaLiberacionNode.addChildElement('Dia', null, null).addTextNode(nullToString(contrato.Dia__c));
        Dom.Xmlnode condicionesFacturacionNode = contratoNode.addChildElement('CondicionesFacturacion', null, null);
            diaLiberacionNode.addChildElement('TipoFacturacion', null, null).addTextNode(nullToString(contrato.ClaveTipoFacturacion__c));
            diaLiberacionNode.addChildElement('EmailRecibeFactura', null, null).addTextNode(nullToString(contrato.EmailQueRecibeFactura__c));
            diaLiberacionNode.addChildElement('FrecuenciaFacturacion', null, null).addTextNode(nullToString(contrato.FrecuenciaFacturacion__c));
            diaLiberacionNode.addChildElement('FrecuenciaPedido', null, null).addTextNode(nullToString(contrato.FrecuenciaPedido__c));
        Dom.Xmlnode facturacionClienteNode = contratoNode.addChildElement('FacturacionCliente', null, null);
            facturacionClienteNode.addChildElement('ComoFactura', null, null).addTextNode(nullToString(contrato.ClaveComoFactura__c));
            facturacionClienteNode.addChildElement('SucursalFacturacionGlobal', null, null).addTextNode(nullToString(String.ValueOf(contrato.SucursalFacturacionGlobal__c)));
            facturacionClienteNode.addChildElement('TipoCliente', null, null).addTextNode(nullToString(contrato.ClaveTipoCliente__c));
            facturacionClienteNode.addChildElement('ProductoFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.ProductoFacturacionGlobal__c)));
            facturacionClienteNode.addChildElement('Consolidador', null, null).addTextNode(nullToString(String.valueOf(contrato.EsConsolidador__c)));
            facturacionClienteNode.addChildElement('GrupoFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.GrupoFacturacionGlobal__c)));
            facturacionClienteNode.addChildElement('SucursalConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.SucursalConsolidacion__c)));
            facturacionClienteNode.addChildElement('ClienteFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.ClienteFacturacionGlobal__c)));
            facturacionClienteNode.addChildElement('ProduccionConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.ProductoConsolidacion__c)));
            facturacionClienteNode.addChildElement('GrupoConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.GrupoConsolidacion__c)));
            facturacionClienteNode.addChildElement('ClienteConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.ClienteConsolidacion__c)));
        Dom.Xmlnode facturacionAdicionalNode = contratoNode.addChildElement('FacturacionAdicional', null, null);
            facturacionAdicionalNode.addChildElement('FacturacionComision', null, null).addTextNode(nullToString(contrato.ClaveFacturacionComision__c));
            facturacionAdicionalNode.addChildElement('FacturacionPlastico', null, null).addTextNode(nullToString(contrato.ClaveFacturacionPlastico__c));
        Dom.Xmlnode condiconesOperativasTCMNode = contratoNode.addChildElement('CondiconesOperativasTCM', null, null);
            condiconesOperativasTCMNode.addChildElement('VIP', null, null).addTextNode(nullToString(String.valueOf(contrato.VIP__c)));
            condiconesOperativasTCMNode.addChildElement('ParametroProducto', null, null).addTextNode(nullToString(contrato.ParametroProducto__c));
            condiconesOperativasTCMNode.addChildElement('EmpresaPrincipal', null, null).addTextNode(nullToString(String.valueOf(contrato.EmpresaPrincipal__c)));
            condiconesOperativasTCMNode.addChildElement('NivelPoliticasAprobacion', null, null).addTextNode(nullToString(String.valueOf(contrato.NivelPoliticasAprobacion__c)));
            condiconesOperativasTCMNode.addChildElement('ItemContratacion', null, null).addTextNode(nullToString(contrato.ItemContratacion__c));
            condiconesOperativasTCMNode.addChildElement('EspecialistaEdenred', null, null).addTextNode(nullToString(contrato.EspecialistaEdenred__c));
            condiconesOperativasTCMNode.addChildElement('IdPrime', null, null).addTextNode(nullToString(contrato.IdPrime__c));
            condiconesOperativasTCMNode.addChildElement('RetardoDiasFijo', null, null).addTextNode(nullToString(contrato.RetardosDiasFijos__c));
            condiconesOperativasTCMNode.addChildElement('UsaFacturaAnticipada', null, null).addTextNode(nullToString(String.valueOf(contrato.UsaFacturaAnticipada__c)));
        Dom.Xmlnode contactosNode = rootNode.addChildElement('Contactos', null, null);
            for(Contact contacto : contactos){
                Dom.Xmlnode contactoNode = contactosNode.addChildElement('Contacto', null, null);
                contactoNode.addChildElement('Nombre', null, null).addTextNode(nullToString(contacto.Name));
                contactoNode.addChildElement('Puesto', null, null).addTextNode(nullToString(contacto.LastName));
                contactoNode.addChildElement('HorarioOficina', null, null).addTextNode(nullToString(contacto.LastName));
                contactoNode.addChildElement('Telefono', null, null).addTextNode(nullToString(contacto.LastName));
                contactoNode.addChildElement('Email', null, null).addTextNode(nullToString(contacto.Email));
                // contactoNode.addChildElement('Extension', null, null).addTextNode(nullToString(String.valueOf(contacto.Extension__c)));
                contactoNode.addChildElement('TipoContacto', null, null).addTextNode(nullToString(contacto.TipoContacto__c));
            }
        Dom.Xmlnode direccionesEntregaNode = contratoNode.addChildElement('DireccionesEntrega', null, null);
            for(DireccionEntrega__c direccion : direcciones){
                Dom.Xmlnode direccionNode = direccionesEntregaNode.addChildElement('DireccionEntrega', null, null);
                direccionNode.addChildElement('ClaveDireccion', null, null).addTextNode(nullToString(direccion.ClaveDireccion__c));
                direccionNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(direccion.NumExterior__c));
                direccionNode.addChildElement('Direccion', null, null).addTextNode(nullToString(direccion.Direccion__c));
                direccionNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(direccion.NumInterior__c));
                direccionNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString(direccion.CodigoPostal__c));
                direccionNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(direccion.Ciudad__c));
                direccionNode.addChildElement('Colonia', null, null).addTextNode(nullToString(direccion.Colonia__c));
                direccionNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(direccion.Ciudad__c));
                direccionNode.addChildElement('Estado', null, null).addTextNode(nullToString(direccion.Estado__c));
                direccionNode.addChildElement('Telefono', null, null).addTextNode(nullToString(String.valueOf(direccion.Telefono__c)));
                direccionNode.addChildElement('Email', null, null).addTextNode(nullToString(direccion.Email__c));
                // direccionNode.addChildElement('Extension', null, null).addTextNode(nullToString(String.valueOf(direccion.Extension__c)));
                direccionNode.addChildElement('AtencionA', null, null).addTextNode(nullToString(direccion.AtencionA__c));
                direccionNode.addChildElement('Puesto', null, null).addTextNode(nullToString(direccion.Puesto__c));
                direccionNode.addChildElement('Horario', null, null).addTextNode(nullToString(direccion.Horario__c));
                direccionNode.addChildElement('NombrePersonalizar', null, null).addTextNode(nullToString(direccion.NombrePersonalizar__c));
                direccionNode.addChildElement('DireccionPersonalizar', null, null).addTextNode(nullToString(direccion.DireccionPersonalizar__c));
                direccionNode.addChildElement('Descripcion', null, null).addTextNode(nullToString(direccion.Descripcion__c));
                direccionNode.addChildElement('Observaciones', null, null).addTextNode(nullToString(direccion.Observaciones__c));
            }
        Dom.Xmlnode tarifasEscalonamietoNode = contratoNode.addChildElement('TarifasEscalonamientoBonificaciones', null, null);
        Dom.Xmlnode observacionesNode = contratoNode.addChildElement('Observaciones', null, null);
            observacionesNode.addChildElement('ObjervacionesEjecutivas', null, null).addTextNode(nullToString(String.valueOf(contrato.ObservacionesEjecutivos__c)));
            observacionesNode.addChildElement('ComentariosAdministrativosVentas', null, null).addTextNode(nullToString(String.valueOf(contrato.ComentariosAdministracionVentas__c)));
        
        xmlContent = doc.toXmlString();
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename=TCM-' + contrato.Oportunidad__r.Name + '.xml');
    }
   
    public void crearDOMContratoTC3() {
        
        list<DireccionEntrega__c> direcciones  = new list<DireccionEntrega__c>();
        list<Contact> contactos  = new list<Contact>();
        List<LineaImpresion__c> lineasImpresion;
        //List<TarifaOportunidad__c> tarifas;
        List<ProductoConcepto__c> tarifas = new List<ProductoConcepto__c>();//Agrega y comenta calvarez 25 feb 2017, agregar productos concepto
        //agrega calvarez 12 mayo 2017
        String ClaveReferenciaAnualidad = String.isNotBlank(Negocio__c.getOrgDefaults().ClaveReferenciaAnualidad__c) ? Negocio__c.getOrgDefaults().ClaveReferenciaAnualidad__c : 'CA02';

    
    
        List<FechaFacturacion__c> calendarios;
        List<String> contactosCargo=new List<String>();
        map<Id,String> mapContactoTipo = new map<Id,String>();
        contrato = (Contrato__c)Database.query('SELECT Oportunidad__r.ComisionEmision__c ,Oportunidad__r.Name,Oportunidad__r.Id,Oportunidad__r.NumeroOportunidad__c,Oportunidad__r.Metodo_Pago__c,Owner.Name,ProductoCotizado__r.Product2.Name,ProductoCotizado__r.Product2.ProductCode,'+'cuenta__r.'+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()), ',cuenta__r.')+','+String.join(new List<String>(SObjectType.Contrato__c.Fields.getMap().keySet()), ', ')+' FROM Contrato__c Where id =: idObjeto');
        //calvarez 14 dic 2016//contrato = (Contrato__c)Database.query('SELECT Oportunidad__r.ComisionEmision__c ,Oportunidad__r.Name,Oportunidad__r.Id,Oportunidad__r.NumeroOportunidad__c,Oportunidad__r.Metodo_Pago__c,Owner.Name,Producto__r.Name,Producto__r.NumeroProducto__c,'+'cuenta__r.'+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()), ',cuenta__r.')+','+String.join(new List<String>(SObjectType.Contrato__c.Fields.getMap().keySet()), ', ')+' FROM Contrato__c Where id =: idObjeto');
        try{
            lineasImpresion =Database.query('SELECT '+String.join(new List<String>(SObjectType.LineaImpresion__c.Fields.getMap().keySet()), ', ')+' FROM LineaImpresion__c Where Contrato__c =: idObjeto');
        }catch(Exception e){
            
            lineasImpresion= new List<LineaImpresion__c>();
        }
          try{
            //String identificadorOpor= contrato.Oportunidad__c;
            //tarifas =Database.query('SELECT Producto__r.NumeroProducto__c,'+String.join(new List<String>(SObjectType.TarifaOportunidad__c.Fields.getMap().keySet()), ', ')+' FROM TarifaOportunidad__c Where Oportunidad__c =: identificadorOpor');
            //Agrega y comenta calvarez 25 feb 2017
            tarifas = [SELECT Id, Concepto__r.TipoCargo__c, Concepto__r.NombreSistemas__c, Concepto__r.Orden__c, Concepto__r.Obligatorio__c, PrecioLista__c, PrecioFinal__c, Bonificacion__c, Notas__c, PrecioLista2__c, AjusteInflacion__c, AplicaAniversario__c, AplicaCobroComisionMinima__c, MesAplica__c, Concepto__r.ClaveReferencia__c, FechaInicio__c, FechaFinal__c, PartidaPresupuesto__r.Product2.NombreSistemas__c FROM ProductoConcepto__c WHERE PartidaPresupuesto__c=: contrato.ProductoCotizado__c];


        }catch(Exception e){
            tarifas= new List<ProductoConcepto__c>();
             System.debug(e.getMessage()+e.getLineNumber());
        }
        try{
            calendarios =Database.query('SELECT '+String.join(new List<String>(SObjectType.FechaFacturacion__c.Fields.getMap().keySet()), ', ')+' FROM FechaFacturacion__c Where contrato__c =: idObjeto');
        }catch(Exception e){
            calendarios= new List<FechaFacturacion__c>();
             System.debug(e.getMessage()+e.getLineNumber());
        }
            try{
            direcciones = Database.query('SELECT '+String.join(new List<String>(SObjectType.DireccionEntrega__c.Fields.getMap().keySet()), ', ')+' FROM DireccionEntrega__c Where contrato__c =: idObjeto');
        }catch(Exception e){
            direcciones= new List<DireccionEntrega__c>();
        }
        try {
            Set<Id>idsContactos = new Set<Id>();
            idsContactos.add(contrato.ContactoDecide__c);
            idsContactos.add(contrato.ContactoSolicita__c);
            idsContactos.add(contrato.OtroContacto__c);
            mapContactoTipo.put(contrato.ContactoDecide__c,'Contacto que decide');
            mapContactoTipo.put(contrato.ContactoSolicita__c,'Contacto que solicita');
            mapContactoTipo.put(contrato.OtroContacto__c,'Otro contacto');
             
            contactosCargo.add(contrato.ContactoDecide__c+'Contacto que decide');
            contactosCargo.add(contrato.ContactoSolicita__c+'Contacto que solicita');
            contactosCargo.add(contrato.OtroContacto__c+'Otro contacto');
            contactos = Database.query('SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ', ')+' FROM Contact Where Id IN: idsContactos');
        } catch(Exception e) {
            System.debug(e.getMessage()+e.getLineNumber());
            contactos= new List<Contact>();
        }
        Dom.Document doc = new Dom.Document();
        Dom.Xmlnode rootNode = doc.createRootElement('response', null, null);
        Dom.Xmlnode contratoNode = rootNode.addChildElement('Contrato', null, null);
        contratoNode.setAttribute('Tipo','TC3');
        contratoNode.addChildElement('IdSalesforce',null,null).addTextNode(contrato.Id);
        contratoNode.addChildElement('FolioSalesforce',null,null).addTextNode(contrato.Name);
        contratoNode.addChildElement('Oportunidad', null, null).addTextNode(nullToString(contrato.Oportunidad__r.Name));
        contratoNode.addChildElement('PorcentajeComision', null, null).addTextNode(String.valueOf(contrato.Oportunidad__r.ComisionEmision__c ==null ? 0 : contrato.Oportunidad__r.ComisionEmision__c));
        contratoNode.addChildElement('Cuenta', null, null).addTextNode(nullToString(contrato.cuenta__r.Name));
        contratoNode.addChildElement('RazonSocial', null, null).addTextNode(nullToString(contrato.RazonSocial__c));
        contratoNode.addChildElement('RFC', null, null).addTextNode(nullToString(contrato.RFC__c));
        contratoNode.addChildElement('Segmento', null, null).addTextNode(nullToString(contrato.Segmento__c));
        contratoNode.addChildElement('Sucursal', null, null).addTextNode(nullToString(contrato.Sucursal__c));
        contratoNode.addChildElement('Producto', null, null).addTextNode(nullToString(String.valueOf(contrato.ProductoCotizado__r.Product2.ProductCode)));
        //calvarez 14 dic 2016 //contratoNode.addChildElement('Producto', null, null).addTextNode(nullToString(String.valueOf(contrato.Producto__r.NumeroProducto__c)));
        contratoNode.addChildElement('Grupo', null, null).addTextNode(nullToString(String.valueOf(contrato.Grupo__c)));
        contratoNode.addChildElement('NumeroCliente', null, null).addTextNode(nullToString(String.valueOf(contrato.NumeroCliente__c)));
        contratoNode.addChildElement('Giro', null, null).addTextNode(nullToString(Utils.MAP_GIRO.containsKey(contrato.giro__c)?Utils.MAP_GIRO.get(contrato.giro__c):'999'));
        contratoNode.addChildElement('Sector', null, null).addTextNode(nullToString(contrato.Sector__c));
        contratoNode.addChildElement('Fax', null, null).addTextNode(nullToString(contrato.Fax__c));
        contratoNode.addChildElement('Familia', null, null).addTextNode(nullToString(contrato.FamiliaCorporativa__c));
        contratoNode.addChildElement('Migracion', null, null).addTextNode(nullToString(String.valueOf(contrato.Migracion__c)));
        contratoNode.addChildElement('NumeroSolicitud', null, null).addTextNode(nullToString(contrato.NumeroSolicitud__c));
        contratoNode.addChildElement('OrigenVenta', null, null).addTextNode(nullToString(contrato.OrigenVenta__c)); 
        contratoNode.addChildElement('Territorio', null, null).addTextNode(nullToString(String.valueOf(contrato.Territorio__c)));
        contratoNode.addChildElement('NombreEjecutivo', null, null).addTextNode(nullToString(contrato.NombreEjecutivo__c));
        contratoNode.addChildElement('Posvendedor', null, null).addTextNode(nullToString(String.valueOf(contrato.Posvendedor__c)));
        contratoNode.addChildElement('VersionContrato', null, null).addTextNode(nullToString(contrato.VersionContrato__c));
        contratoNode.addChildElement('Competidor', null, null).addTextNode(nullToString(contrato.Competidor__c));
        contratoNode.addChildElement('UsuarioAS400', null, null).addTextNode(nullToString(contrato.UsuarioAS400__c));
        contratoNode.addChildElement('CodigoCliente', null, null).addTextNode(nullToString(contrato.cuenta__r.CodigoClienteAS400__c ));
        contratoNode.addChildElement('EstatusAltaTC3', null, null).addTextNode(nullToString(contrato.EstatusAltaTC3__c));
        contratoNode.addChildElement('DireccionFactura', null, null).addTextNode(nullToString(contrato.DireccionFactura__c.replace(',',' ')));
        contratoNode.addChildElement('Calle', null, null).addTextNode(nullToString(contrato.Calle__c.replace(',',' ')));
        contratoNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(contrato.NumeroExterior__c.replace(',',' ')));
        contratoNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString(contrato.NumeroInterior__c.replace(',',' ')));
        contratoNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString(contrato.CodigoPostal__c));
        contratoNode.addChildElement('Colonia', null, null).addTextNode(nullToString(contrato.Colonia__c.replace(',',' ')));
        contratoNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(contrato.Ciudad__c.replace(',',' ')));
        contratoNode.addChildElement('Estado', null, null).addTextNode(nullToString(contrato.Estado__c.replace(',',' ')));
        contratoNode.addChildElement('TipoPago', null, null).addTextNode(nullToString(contrato.TipoPago__c));
        contratoNode.addChildElement('CondicionesPago', null, null).addTextNode(nullToString(contrato.CondicionesPago__c));
        contratoNode.addChildElement('Financiamiento', null, null).addTextNode(nullToString(contrato.Financiamiento__c));
        contratoNode.addChildElement('ModoTransaccion', null, null).addTextNode(nullToString(contrato.ModoTransaccion__c));
        contratoNode.addChildElement('PagoCargosFinanciamiento', null, null).addTextNode(nullToString(String.valueOf(contrato.PagoCargosFinanciamiento__c)));
        contratoNode.addChildElement('TipoFinanciamiento', null, null).addTextNode(nullToString(contrato.TipoFinanciamiento__c));
        contratoNode.addChildElement('Clasificacion', null, null).addTextNode(nullToString(contrato.Clasificacion__c));
        contratoNode.addChildElement('CargoRecurrenteConFinanciamiento', null, null).addTextNode(nullToString(String.valueOf(contrato.CargoRecurrenteConFinanciamiento__c)));
        contratoNode.addChildElement('FrecuenciaLiberacionAutomatica', null, null).addTextNode(nullToString(contrato.ClaveFrecuenciaLiberacionAutomatica__c));      
        contratoNode.addChildElement('LineaOperativa', null, null).addTextNode(nullToString(String.valueOf(contrato.LineaOperativa__c)));   
        contratoNode.addChildElement('VentanaRiesgo', null, null).addTextNode(nullToString(String.valueOf(contrato.VentanaRiesgo__c))); 
        //Monto // Garnatiá
        contratoNode.addChildElement('Monto', null, null).addTextNode(nullToString('Pendiente'));
        //Observaciones
        contratoNode.addChildElement('Observaciones', null, null).addTextNode(nullToString(contrato.ObservacionesEjecutivos__c));
        
        contratoNode.addChildElement('DiaLiberacion', null, null).addTextNode(nullToString(contrato.DiaLiberacion__c));
        contratoNode.addChildElement('Dia', null, null).addTextNode(nullToString(contrato.Dia__c));
        contratoNode.addChildElement('DiaInicio', null, null).addTextNode(nullToString(contrato.DiaInicio__c));
        contratoNode.addChildElement('ProximaCarga', null, null).addTextNode(nullToString(contrato.ProximaCarga__c));
        //contratoNode.addChildElement('TipoFacturacion', null, null).addTextNode(nullToString(contrato.ClaveTipoFacturacion__c));
        contratoNode.addChildElement('TipoFacturacion', null, null).addTextNode(nullToString(contrato.TipoFacturacion__c));
        contratoNode.addChildElement('FrecuenciaFacturacion', null, null).addTextNode(nullToString(contrato.FrecuenciaFacturacion__c));
        contratoNode.addChildElement('EmailQueRecibeFactura', null, null).addTextNode(nullToString(contrato.EmailQueRecibeFactura__c));
        contratoNode.addChildElement('ComoFactura', null, null).addTextNode(nullToString(contrato.ComoFactura__c));
        //contratoNode.addChildElement('ComoFactura', null, null).addTextNode(nullToString(contrato.ClaveComoFactura__c));
        contratoNode.addChildElement('TipoCliente', null, null).addTextNode(nullToString(contrato.TipoCliente__c));
        //contratoNode.addChildElement('TipoCliente', null, null).addTextNode(nullToString(contrato.ClaveTipoCliente__c));
        contratoNode.addChildElement('EsConsolidador', null, null).addTextNode(nullToString(String.valueOf(contrato.EsConsolidador__c)));
        contratoNode.addChildElement('SucursalConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.SucursalConsolidacion__c)));
        contratoNode.addChildElement('ProductoConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.ProductoConsolidacion__c)));
        contratoNode.addChildElement('GrupoConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.GrupoConsolidacion__c)));  
        contratoNode.addChildElement('ClienteConsolidacion', null, null).addTextNode(nullToString(String.valueOf(contrato.ClienteConsolidacion__c)));
        contratoNode.addChildElement('SucursalFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.SucursalFacturacionGlobal__c)));
        contratoNode.addChildElement('ProductoFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.ProductoFacturacionGlobal__c)));
        contratoNode.addChildElement('GrupoFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.GrupoFacturacionGlobal__c)));
        contratoNode.addChildElement('ClienteFacturacionGlobal', null, null).addTextNode(nullToString(String.valueOf(contrato.ClienteFacturacionGlobal__c)));
        // contratoNode.addChildElement('FacturacionCargos', null, null).addTextNode(nullToString(contrato.FacturacionCargos__c));
        contratoNode.addChildElement('FacturacionCargos', null, null).addTextNode('Separado del Consumo');
        //contratoNode.addChildElement('FacturacionCargos', null, null).addTextNode(nullToString(contrato.ClaveFacturacionCargos__c));
        // contratoNode.addChildElement('FacturacionPlastico', null, null).addTextNode(nullToString(contrato.FacturacionPlastico__c));
        contratoNode.addChildElement('FacturacionPlastico', null, null).addTextNode(nullToString(contrato.FacturacionPlastico__c));
        //contratoNode.addChildElement('FacturacionPlastico', null, null).addTextNode(nullToString(contrato.ClaveFacturacionPlastico__c));
        contratoNode.addChildElement('FacturacionComision', null, null).addTextNode(nullToString(contrato.FacturacionComision__c));
        //contratoNode.addChildElement('FacturacionComision', null, null).addTextNode(nullToString(contrato.ClaveFacturacionComision__c));
        contratoNode.addChildElement('VolEmisionEstimadoMensual', null, null).addTextNode(nullToString(String.valueOf(contrato.VolEmisionEstimadoMensual__c)));
        contratoNode.addChildElement('VIP', null, null).addTextNode(nullToString(String.valueOf(contrato.VIP__c)));
        contratoNode.addChildElement('EmpresaPrincipal', null, null).addTextNode(nullToString(String.valueOf(contrato.EmpresaPrincipal__c)));
        contratoNode.addChildElement('IdPrime', null, null).addTextNode(nullToString(contrato.IdPrime__c));
        contratoNode.addChildElement('ItemContratacion', null, null).addTextNode(nullToString(contrato.ItemContratacion__c));
        //contratoNode.addChildElement('ItemContratacion', null, null).addTextNode(nullToString(contrato.ClaveItemContratacion__c));
        contratoNode.addChildElement('PermiteAutorizacionTelefonica', null, null).addTextNode(nullToString(String.valueOf(contrato.PermiteAutorizacionTelefonica__c)));
        contratoNode.addChildElement('ImprimeLogo', null, null).addTextNode(nullToString(String.valueOf(contrato.ImprimeLogo__c)));
        contratoNode.addChildElement('TipoPlasticoTarjetaFinanciera', null, null).addTextNode(nullToString(contrato.TipoPlasticoTarjetaFinanciera__c));
        contratoNode.addChildElement('TipoPlasticoTarjetaStock', null, null).addTextNode(nullToString(contrato.TipoPlasticoTarjetaStock__c));
        contratoNode.addChildElement('BombaPropia', null, null).addTextNode(nullToString(String.valueOf(contrato.BombaPropia__c)));
        contratoNode.addChildElement('Maneja', null, null).addTextNode(nullToString(contrato.Maneja__c));
        contratoNode.addChildElement('Red', null, null).addTextNode(nullToString(contrato.Red__c));
        
        contratoNode.addChildElement('ManejaConductores', null, null).addTextNode(nullToString(String.valueOf(contrato.ManejaConductores__c)));
        contratoNode.addChildElement('ManejaNotaVale', null, null).addTextNode(nullToString(String.valueOf(contrato.ManejaNotaVale__c)));
        contratoNode.addChildElement('OperaTcTruck', null, null).addTextNode(nullToString(String.valueOf(contrato.OperaTcTruck__c)));
        contratoNode.addChildElement('ControlaPresenciaVehiculoNFC', null, null).addTextNode(nullToString(String.valueOf(contrato.ControlaPresenciaVehiculoNFC__c)));
        contratoNode.addChildElement('NoMostrarKm', null, null).addTextNode(nullToString(String.valueOf(contrato.NoMostrarKm__c)));
        contratoNode.addChildElement('ControlVolumetrico', null, null).addTextNode(nullToString(String.valueOf(contrato.ControlVolumetrico__c)));
        contratoNode.addChildElement('OperacionModoOffline', null, null).addTextNode(nullToString(contrato.OperacionModoOffline__c));
        //contratoNode.addChildElement('OperacionModoOffline', null, null).addTextNode(nullToString(contrato.ClaveOperacionModoOffline__c));
        contratoNode.addChildElement('ImpedirComprarDiaHabil', null, null).addTextNode(nullToString(String.valueOf(contrato.ImpedirComprarDiaHabil__c)));
        contratoNode.addChildElement('ImpedirComprarSabado', null, null).addTextNode(nullToString(String.valueOf(contrato.ImpedirComprarSabado__c)));
        contratoNode.addChildElement('ImpedirComprarDomingo', null, null).addTextNode(nullToString(String.valueOf(contrato.ImpedirComprarDomingo__c)));
        contratoNode.addChildElement('CantidadMaxTransaccionesOffline', null, null).addTextNode(nullToString(String.valueOf(contrato.CantidadMaxTransaccionesOffline__c)));
        contratoNode.addChildElement('ValorMaxParaUnaTransaccion', null, null).addTextNode(nullToString(String.valueOf(contrato.ValorMaxParaUnaTransaccion__c)));
        contratoNode.addChildElement('IntervaloEntreTransacciones', null, null).addTextNode(nullToString(String.valueOf(contrato.IntervaloEntreTransacciones__c)));
        contratoNode.addChildElement('NombrePersonalizacion', null, null).addTextNode(nullToString(contrato.NombrePersonalizacion__c));
        contratoNode.addChildElement('FrecuenciaPedido', null, null).addTextNode(nullToString(contrato.FrecuenciaPedido__c));
        contratoNode.addChildElement('MedioPago', null, null).addTextNode(nullToString(contrato.MedioPago__c));
        //calvarez 4mar2017 validar con Claus los datos a enviar - enviar número de cotización 6mar2017
        //contratoNode.addChildElement('NumeroOportunidad', null, null).addTextNode(nullToString(contrato.Oportunidad__r.NumeroOportunidad__c));
        contratoNode.addChildElement('NumeroOportunidad', null, null).addTextNode(nullToString(qli.Quote.QuoteNumber != null ? qli.Quote.QuoteNumber : ''));
        //contratoNode.addChildElement('MetodoPago', null, null).addTextNode(nullToString(contrato.Oportunidad__r.Metodo_Pago__c));
        //actualiza calvarez 24 mayo de 2017 - oli po qli
        contratoNode.addChildElement('MetodoPago', null, null).addTextNode(nullToString(qli.FormaPago__c));
        
        Dom.Xmlnode contactosNode = rootNode.addChildElement('Contactos', null, null);
        for(Contact contacto : contactos){
            Set<String> tiposContactos= new Set<String>();
            for(String contactoCargoAuxiliar:contactosCargo){
                if(contactoCargoAuxiliar.contains(''+contacto.Id)){
                    tiposContactos.add(contactoCargoAuxiliar.replaceAll(''+contacto.Id,''));
                }
                
            }
            for(String tipoContactoAuxiliar : tiposContactos){
            Dom.Xmlnode contactoNode = contactosNode.addChildElement('Contacto', null, null);
            contactoNode.addChildElement('Nombre', null, null).addTextNode(nullToString(contacto.FirstName));
            contactoNode.addChildElement('Apellidos', null, null).addTextNode(nullToString(contacto.LastName));
            contactoNode.addChildElement('Puesto', null, null).addTextNode(nullToString(contacto.Puesto__c));
            contactoNode.addChildElement('HorarioOficina', null, null).addTextNode(nullToString(contacto.HorarioOficina__c));
            contactoNode.addChildElement('Telefono', null, null).addTextNode(nullToString(contacto.Phone));
            // contactoNode.addChildElement('Extension', null, null).addTextNode(nullToString(String.valueOf(contacto.Extension__c != null ? contacto.Extension__c : 0)));
            contactoNode.addChildElement('Email', null, null).addTextNode(nullToString(contacto.Email));
            
          //  contactoNode.addChildElement('TipoContacto', null, null).addTextNode(nullToString(mapContactoTipo.get(contacto.Id)));
            contactoNode.addChildElement('TipoContacto', null, null).addTextNode(tipoContactoAuxiliar);
            contactoNode.addChildElement('Calle', null, null).addTextNode(nullToString(contacto.Calle__c));
            contactoNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString(contacto.NumeroInterior__c));
            contactoNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(contacto.NumeroExterior__c));
            contactoNode.addChildElement('Colonia', null, null).addTextNode(nullToString(contacto.Colonia__c));
            contactoNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(contacto.Ciudad__c));
            contactoNode.addChildElement('Estado', null, null).addTextNode(nullToString(contacto.Estado__c));
                contactoNode.addChildElement('Municipio', null, null).addTextNode(nullToString(contacto.DelegacionMunicipio__c));
            }
        }
        contratoNode.addChildElement('ObservacionesEjecutivos', null, null).addTextNode(nullToString(String.valueOf(contrato.ObservacionesEjecutivos__c)));
        //ContactoDesissor
        contratoNode.addChildElement('ContactoDesissor', null, null).addTextNode(nullToString(String.valueOf('Pendiente')));
        //Contacto
         contratoNode.addChildElement('UsuarioMaster', null, null).addTextNode(nullToString(String.valueOf(contrato.Owner.Name)));
        contratoNode.addChildElement('ComentariosAdministracionVentas', null, null).addTextNode(nullToString(contrato.ComentariosAdministracionVentas__c));
        //agrega calvarez 28feb2017
        contratoNode.addChildElement('Maquila', null, null).addTextNode(nullToString(String.valueOf(contrato.Maquila__c)));
        contratoNode.addChildElement('TipoMaquila', null, null).addTextNode(nullToString(contrato.TipoMaquila__c));
        
        Dom.Xmlnode direccionesEntregaNode = rootNode.addChildElement('DireccionesEntrega', null, null);
        for(DireccionEntrega__c direccion : direcciones){
            Dom.Xmlnode direccionNode = direccionesEntregaNode.addChildElement('DireccionEntrega', null, null);
            //No solicitud // Contrato
            direccionNode.addChildElement('NoSolicitud', null, null).addTextNode(nullToString('Pendiente'));
            direccionNode.addChildElement('ClaveEntrega', null, null).addTextNode(nullToString(direccion.ClaveDireccion__c));
            direccionNode.addChildElement('Descripcion', null, null).addTextNode(nullToString(direccion.Descripcion__c));
            direccionNode.addChildElement('Direccion', null, null).addTextNode(nullToString(direccion.Direccion__c));
            direccionNode.addChildElement('Telefono', null, null).addTextNode(nullToString(String.valueOf(direccion.Telefono__c)));
            // direccionNode.addChildElement('Extension', null, null).addTextNode(nullToString(String.valueOf(direccion.Extension__c)));
            direccionNode.addChildElement('Email', null, null).addTextNode(nullToString(direccion.Email__c));
            // ¿Calle? /
            direccionNode.addChildElement('Calle', null, null).addTextNode(nullToString('Pendiente'));
            direccionNode.addChildElement('NumeroExterior', null, null).addTextNode(nullToString(direccion.NumExterior__c));
            direccionNode.addChildElement('NumeroInterior', null, null).addTextNode(nullToString(direccion.NumInterior__c));
            direccionNode.addChildElement('CodigoPostal', null, null).addTextNode(nullToString(direccion.CodigoPostal__c));
            direccionNode.addChildElement('Colonia', null, null).addTextNode(nullToString(direccion.Colonia__c));
            direccionNode.addChildElement('Ciudad', null, null).addTextNode(nullToString(direccion.Ciudad__c));
            direccionNode.addChildElement('Estado', null, null).addTextNode(nullToString(direccion.Estado__c));
            direccionNode.addChildElement('HoraOficina', null, null).addTextNode(nullToString(direccion.Horario__c));
            direccionNode.addChildElement('AtencionA', null, null).addTextNode(nullToString(direccion.AtencionA__c));
            direccionNode.addChildElement('Cargo', null, null).addTextNode(nullToString(direccion.Puesto__c));
            direccionNode.addChildElement('Observaciones', null, null).addTextNode(nullToString(direccion.Observaciones__c));
            direccionNode.addChildElement('NombrePersonalizar', null, null).addTextNode(nullToString(direccion.NombrePersonalizar__c));
            direccionNode.addChildElement('DireccionPersonalizar', null, null).addTextNode(nullToString(direccion.DireccionPersonalizar__c));
            // ¿Estatus? /
            direccionNode.addChildElement('Estatus', null, null).addTextNode(nullToString(direccion.Estatus__c));
        
        }
        Dom.Xmlnode tarifasNode = rootNode.addChildElement('Tarifas', null, null);
    
        //modifica calvarez 25 feb 2017, agregar Producto concepto en lugar de Tarifas Oportunidad
        String COM_EMI = 'Comisión por el servicio';
        String mesAplica = ' ';
        for(ProductoConcepto__c tarifa : tarifas) {
             mesAplica = ' ';
            Dom.Xmlnode tnode = tarifasNode.addChildElement('Tarifa', null, null);
            tnode.setAttribute('Nombre', nullToString(tarifa.PartidaPresupuesto__r.Product2.NombreSistemas__c));
            tnode.setAttribute('ClaveReferencia',nullToString(tarifa.Concepto__r.ClaveReferencia__c));
            tnode.addChildElement('NombreTarifa', null, null).addTextNode(nullToString(tarifa.Concepto__r.NombreSistemas__c));


            if(tarifa.Concepto__r.TipoCargo__c == COM_EMI) {//Tarifa es porcentaje - Precio en cero y porcentaje con valor
                tnode.addChildElement('Precio', null, null).addTextNode(String.valueOf(0));
                tnode.addChildElement('Porcentaje', null, null).addTextNode(String.valueOf(tarifa.PrecioLista2__c != null ? tarifa.PrecioLista2__c : 0));
            } else {//Costo fijo - Precio con valor y porcentaje en cero
                tnode.addChildElement('Precio', null, null).addTextNode(String.valueOf(tarifa.PrecioLista__c != null ? tarifa.PrecioLista__c : 0));
                tnode.addChildElement('Porcentaje', null, null).addTextNode(String.valueOf(0));
            }

            tnode.addChildElement('AjusteInflacion', null, null).addTextNode(nullToString(String.valueOf(tarifa.AjusteInflacion__c)));
            tnode.addChildElement('AplicaCobroComisionMinima', null, null).addTextNode(nullToString(String.valueOf(tarifa.AplicaCobroComisionMinima__c)));

            //agrega calvarez 12 mayo de 2017
            if(String.isNotBlank(tarifa.Concepto__r.ClaveReferencia__c) && String.isNotBlank(ClaveReferenciaAnualidad)  && tarifa.Concepto__r.ClaveReferencia__c == ClaveReferenciaAnualidad) {
                 mesAplica = tarifa.MesAplica__c != null ? tarifa.MesAplica__c : ' ';
            }
            tnode.addChildElement('AplicaAniversario', null, null).addTextNode(nullToString(String.valueOf(tarifa.AplicaAniversario__c)));
            tnode.addChildElement('MesAplica', null, null).addTextNode(mesAplica);

            //agrega calvarez 11 mayo 2017
            Dom.Xmlnode escalonamientoNode = tnode.addChildElement('Escalonamientos', null, null);
        }

        Dom.Xmlnode lineasImpresionTarjetaTC3Node = rootNode.addChildElement('LineasImpresion', null, null);
        for(LineaImpresion__c lineaImpresion: lineasImpresion){
            Dom.Xmlnode lineaNode = lineasImpresionTarjetaTC3Node.addChildElement('LineaImpresionTarjeta', null, null);
            lineaNode.addChildElement('Orden', null, null).addTextNode(nullToString(String.valueOf(lineaImpresion.Orden__c)));
            lineaNode.addChildElement('DescripcionLineaImpresion', null, null).addTextNode(nullToString(lineaImpresion.DescripcionLineaImpresion__c));
            lineaNode.addChildElement('Identificador', null, null).addTextNode(nullToString(lineaImpresion.ClaveDescripcionLineaImpresion__c));

        }

        Dom.Xmlnode calendariosNode = rootNode.addChildElement('Calendarios', null, null);
        for(FechaFacturacion__c calendario : calendarios){
            Dom.Xmlnode calendarioNode = calendariosNode.addChildElement('Calendario', null, null);
            calendarioNode.addChildElement('FechaInicio', null, null).addTextNode(nullToString(String.valueOf(calendario.FechaInicio__c)));
            calendarioNode.addChildElement('FechaFin', null, null).addTextNode(nullToString(String.valueOf(calendario.FechaFin__c)));
        }
        
        Dom.Xmlnode bonifiacionesNode = rootNode.addChildElement('Bonificaciones', null, null);
        //agrega calvarez 12 mayo de 2017
        for(ProductoConcepto__c tarifa : tarifas) {
            if(tarifa.Bonificacion__c != null) {
                Dom.Xmlnode bonifiacionNode = bonifiacionesNode.addChildElement('Bonificacion', null, null);

                bonifiacionNode.setAttribute('Tarifa', nullToString(tarifa.Concepto__r.NombreSistemas__c));

                bonifiacionNode.setAttribute('ClaveReferencia', nullToString(tarifa.Concepto__r.ClaveReferencia__c));

                bonifiacionNode.addChildElement('ValorPorcentual', null, null).addTextNode(String.valueOf(tarifa.Bonificacion__c != NULL ? tarifa.Bonificacion__c : 0));

                /comenta calvarez 17 mayo 2017 if(tarifa.Concepto__r.TipoCargo__c == COM_EMI) {
                    bonifiacionNode.addChildElement('ValorFijo', null, null).addTextNode(String.valueOf(tarifa.PrecioLista2__c != NULL ? tarifa.PrecioLista2__c : 0));
                } else {
                    bonifiacionNode.addChildElement('ValorFijo', null, null).addTextNode(String.valueOf(tarifa.PrecioLista__c != NULL ? tarifa.PrecioLista__c : 0));
                }/
                bonifiacionNode.addChildElement('ValorFijo', null, null).addTextNode(String.valueOf(0));
                bonifiacionNode.addChildElement('FechaInicio', null, null).addTextNode(nullToString(String.valueOf(tarifa.FechaInicio__c)));
                bonifiacionNode.addChildElement('FechaFinal', null, null).addTextNode(nullToString(String.valueOf(tarifa.FechaFinal__c)));
            }
        }
        System.debug('doc.toXmlString(): ' + doc.toXmlString());
        xmlContent = doc.toXmlString();
        xmlContent=xmlContent.trim();
    }*/
    
      /* public GenerarXMLController( Id opportunityId, Id contratoId,ContratoFilial__c filial ) {
        Opportunity opp = new Opportunity();
        Contrato2__c contrato = (Contrato2__c) Database.query('SELECT ' + String.join( new List<String>( SObjectType.Contrato2__c.Fields.getMap().keySet() ), ', ') + ', Entidad_Cuenta__r.Name, Entidad_Cuenta__r.Cuenta__r.Giro__c, Entidad_Cuenta__r.Cuenta__r.Sector__c, Entidad_Legal__r.RazonSocial__c, Entidad_Legal__r.Name, Entidad_Legal__r.Direccion__c, Entidad_Legal__r.Calle__c, Entidad_Legal__r.NumeroExterior__c, Entidad_Legal__r.NumeroInterior__c, Entidad_Legal__r.CodigoPostal__c, Entidad_Legal__r.Colonia__c, Entidad_Legal__r.Ciudad__c, Entidad_Legal__r.Estado__c, PartidaPresupuesto__r.Product2.ProductCode, PartidaPresupuesto__r.Product2.Familia__c, PartidaPresupuesto__r.ComentariosCotizacion__c, PartidaPresupuesto__r.Quote.QuoteNumber, PartidaPresupuesto__r.FormaPago__c, Contacto__r.Phone, Contacto__r.Email, Contacto__r.Extension__c FROM Contrato2__c WHERE id =: contratoId');
        for( Opportunity oppAux : [SELECT Id, Name, NumeroOportunidad__c, AccountId, ComisionEmision__c, Competidor__c, OwnerId, Owner.Name, Owner.Segmento__c, Owner.NumeroTerritorio__c, Contacto__r.FirstName, Contacto__r.LastName, Contacto__r.Puesto__c, Contacto__r.HorarioOficina__c, Contacto__r.Phone, Contacto__r.Email, Contacto__r.Extension__c, Contacto__r.TipoContacto__c, Contacto__r.Calle__c, Contacto__r.NumeroInterior__c, Contacto__r.NumeroExterior__c, Contacto__r.Colonia__c, Contacto__r.Ciudad__c, Contacto__r.Estado__c, Contacto__r.DelegacionMunicipio__c FROM Opportunity WHERE Id =: opportunityId] ) {
            opp = oppAux;
            break;
        }
        contrato.Entidad_Cuenta__r.Name=filial.Entidad_Cuenta__r.EntidadLegal__r.Name;
        contrato.Entidad_Legal__r.RazonSocial__c=filial.Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c;
        contrato.Entidad_Legal__r.Name=filial.Entidad_Cuenta__r.EntidadLegal__r.Name; 
        contrato.Entidad_Legal__r.Calle__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Calle__c;
        contrato.Entidad_Legal__r.NumeroExterior__c=filial.Entidad_Cuenta__r.EntidadLegal__r.NumeroExterior__c; 
        contrato.Entidad_Legal__r.NumeroInterior__c=filial.Entidad_Cuenta__r.EntidadLegal__r.NumeroInterior__c;
        contrato.Entidad_Legal__r.CodigoPostal__c=filial.Entidad_Cuenta__r.EntidadLegal__r.CodigoPostal__c; 
        contrato.Entidad_Legal__r.Colonia__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Colonia__c;
        contrato.Entidad_Legal__r.Ciudad__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Ciudad__c;
        contrato.Entidad_Legal__r.Estado__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Estado__c;
        generaDocumentoXML( opp, contrato );

    }*/


    public void enviarMail( Opportunity opp, Contrato2__c contrato, String xmlContent ) {

        System.debug('xmlContent: ' + xmlContent);
        if( exitoContrato ) {
            
            Negocio__c negocio = Negocio__c.getOrgDefaults();
            String direccionesEnvio = negocio.EmailXML__c; 
            String body = '';
            list<Messaging.EmailFileAttachment> listaAdjuntos = new list<Messaging.EmailFileAttachment>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            Attachment archivo = new Attachment();
            archivo.Name = nullToString(opp.NumeroOportunidad__c == null ? 'archivoXML' : opp.NumeroOportunidad__c) + '.xml';
            archivo.Body = Blob.valueOf(xmlContent);
            efa.setFileName(archivo.Name);
            efa.setBody(archivo.Body);
            listaAdjuntos.add(efa);
            try {
                String[] toAddresses = direccionesEnvio.split(',');
                email.setSubject( 'Contrato XML- ' + opp.Name );
                email.setToAddresses( toAddresses );
                System.debug(toAddresses);
                email.setPlainTextBody( body );
                email.setFileAttachments(listaAdjuntos);
                Messaging.SendEmailResult [] r = Messaging.sendEmail( new Messaging.SingleEmailMessage[] {email} ); 
                if( r[0].isSuccess() ) {
                    // contrato.Estatus__c = 'Enviado';
                    // update contrato;
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'Se han generado todos los archivos y se han enviado por correo'));
                } else {
                    List<Messaging.SendEmailError> errores = r[0].getErrors();
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al enviar los correros:' + errores ));
                    System.debug('Error al enviar los correros:' + errores);
                }
                
            } catch( Exception e ) {
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al enviar los correos:' + e.getMessage()));
                System.debug('Error al enviar los correos:' + e.getMessage()+'line'+e.getLineNumber());
            }
        }
    }

     public static void enviarMail2( Opportunity opp, Contrato2__c contrato,List<String> xmlContent, Boolean exitoContrato ) {

        //System.debug('xmlContent: ' + xmlContent);
        if( exitoContrato ) {
            Integer contador=1;
              System.debug('Error al enviar los correros: correo enviado---------------------------------');
            Negocio__c negocio = Negocio__c.getOrgDefaults();
            String direccionesEnvio = negocio.EmailXML__c; 
            String body = '';
            list<Messaging.EmailFileAttachment> listaAdjuntos = new list<Messaging.EmailFileAttachment>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            Attachment archivo = new Attachment();
            for(String xml :xmlContent){
                archivo = new Attachment();
                archivo.Name = nullToString2(opp.NumeroOportunidad__c == null ? 'archivoXML' :opp.NumeroOportunidad__c) +'-'+contador+ '.xml';
                archivo.Body = Blob.valueOf(xml);
                efa = new Messaging.EmailFileAttachment();
                efa.setFileName(archivo.Name);
                efa.setBody(archivo.Body);
                listaAdjuntos.add(efa);
                 contador=contador+1;
            }
            
            try {
                String[] toAddresses = direccionesEnvio.split(',');
                email.setSubject( 'Contrato XML- ' + opp.Name );
                email.setToAddresses( toAddresses );
                System.debug(toAddresses);
                email.setPlainTextBody( body );
                email.setFileAttachments(listaAdjuntos);
                Messaging.SendEmailResult [] r = Messaging.sendEmail( new Messaging.SingleEmailMessage[] {email} ); 
                if( r[0].isSuccess() ) {
                    // contrato.Estatus__c = 'Enviado';
                    // update contrato;
                     System.debug('Error al enviar los correros: correo enviado---------------------------------');
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'Se han generado todos los archivos y se han enviado por correo'));
                } else {
                    List<Messaging.SendEmailError> errores = r[0].getErrors();
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al enviar los correros:' + errores ));
                    System.debug('Error al enviar los correros:' + errores);
                }
                
            } catch( Exception e ) {
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al enviar los correos:' + e.getMessage()));
                System.debug('Error al enviar los correos:' + e.getMessage()+'line'+e.getLineNumber());
            }
        }
    }
    
    public String nullToString( String cadena ) {
        if( cadena == null ){
            return ' ';
        } else {
            return cadena;
        }
    }

    public static String nullToString2( String cadena ) {
        if( cadena == null ){
            return ' ';
        } else {
            return cadena;
        }
    }
}