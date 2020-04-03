public class ContratoTC3Controller {
  /*  
    public string idOportunidad{get;set;}
    public string idContrato{get;set;}
    public string accId{get;set;}
    public String  lineaImpresion {get;set;}
    public Contrato__c contrato{get;set;}
    public account  accContrato{get;set;}
    public Opportunity oppContrato{get;set;}
    public Garantia__c  garantia{get;set;}
    //public Producto__c prod{get;set;}    
    public Product2 prod{get;set;} //Agregar objeto estándar 
    public Boolean ctaNoCliente{get;set;}
    public Boolean ctaGrupo{get;set;}
    public date fechaActual{get;set;}
    public QuoteLineItem prodCotizado {get; set;}
    
    public List<Garantia__c> garantias {get;set;}
    
    //catalogos
    public List<SelectOption> catSucursal{ get{ return Utils.obtenerCatalogo('Sucursal'); }set; }
    public List<SelectOption> catOrigenVenta{ get{ return Utils.obtenerCatalogo('Origen de Venta'); }set; }
    public List<SelectOption> catCompetidor{ get{ return Utils.obtenerCatalogo('Competidor'); }set; }
    public List<SelectOption> catTipoPago{ get{ return Utils.obtenerCatalogo('Tipo de Pago'); }set; }
    public List<SelectOption> catMedioPago{ get{ return Utils.obtenerCatalogo('Medio de pago'); }set; }
    public List<SelectOption> catFrecuenciaLiberacionAutomatica{ get{ return Utils.obtenerCatalogo('Frecuencia de liberación automática'); }set; }
    public List<SelectOption> catTipoFacturacion{  get{ return Utils.obtenerCatalogo('Tipo de facturación'); }set; }
    public List<SelectOption> catFrecuenciaFacturacion{ get{ return Utils.obtenerCatalogo('Frecuencia de Facturación'); }set; }
    public List<SelectOption> catComoFactura{ get{ return Utils.obtenerCatalogo('Cómo factura'); }set; }
    public List<SelectOption> catTipoCliente{ get{ return Utils.obtenerCatalogo('Tipo de Cliente'); }set; }
    public List<SelectOption> catFacturacionComision{ get{ return Utils.obtenerCatalogo('Facturación Comisión'); }set; }
    public List<SelectOption> catFacturacionPlastico{ get{ return Utils.obtenerCatalogo('Facturación Plástico'); }set; }
    public List<SelectOption> catItemContratacion{ get{ return Utils.obtenerCatalogo('Item de contratación'); }set; }
    public List<SelectOption> catPuesto{ get{ return Utils.obtenerCatalogo('Puesto'); }set; }
    public List<SelectOption> catFacturacionCargos{ get{ return Utils.obtenerCatalogo('Facturación Cargos'); }set; }
    public List<SelectOption> catManeja{ get{ return Utils.obtenerCatalogo('Maneja'); }set; }
    public List<SelectOption> catRed{ get{ return Utils.obtenerCatalogo('Red'); }set; }
    public List<SelectOption> catOperacionModoOffline{ get{ return Utils.obtenerCatalogo('Operación modo offline'); }set; }
    public List<SelectOption> catDescripcionLineaImpresion{ get{ return Utils.obtenerCatalogo('Descripción línea de Impresión'); }set; }
    public List<SelectOption> catFinanciamiento{ get{ return Utils.obtenerCatalogo('Financiamiento'); }set; }
    public List<SelectOption> catTipoFinanciamiento{ get{ return Utils.obtenerCatalogo('Tipo financiamiento'); }set; }
    public List<SelectOption> catTipoPlasticoTarjetaFinanciera{ get{ return Utils.obtenerCatalogo('Tipo plástico (Tarjeta Financiera)'); }set; }
    public List<SelectOption> catTipoPlasticoTarjetaStock{ get{ return Utils.obtenerCatalogo('Tipo plástico (Tarjeta Stock)'); }set; }
    public List<SelectOption> catMaquila{ get{ return Utils.obtenerCatalogo('Maquila'); }set;}// Agrega calvarez 28feb2017
    // Contacto
    public wrapContacto nuevoContacto{get;set;}
    public list<Contact> lstBorrarContacto{get;set;}
    public list<wrapContacto> catalogoContacto{get;set;}
    public list<wrapContacto>  lstContacto{get;set;}
    
    public class wrapContacto{
        public boolean checked{get;set;}
        public String tipoContacto{get;set;}
        public Contact contacto{get;set;}
        
        public wrapContacto(){
            this.checked = false;
        }
        public wrapContacto( String tipo){
            this.checked = false;
            tipoContacto = tipo;
            //contacto = new Contact(TipoContacto__c = tipo);
        }
    }
    //Lineas de impresion
    public list<LineaImpresion__c> lstBorrarLI{get;set;}
    public list<wrapLineaImpresion>  lstLineaImpresion{get;set;}
    public class wrapLineaImpresion{
        public boolean checked{get;set;}
        public LineaImpresion__c lineaImpresion{get;set;}
        public wrapLineaImpresion(Opportunity oppContrato, String valor){
            this.checked = false;
            this.lineaImpresion = new LineaImpresion__c();
            this.lineaImpresion.DescripcionLineaImpresion__c =String.valueOf([SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM Catalogo__c  WHERE Tipo__c='Descripción línea de Impresión' AND Clave__c =:valor].Descripcion__c);
            this.lineaImpresion.ClaveDescripcionLineaImpresion__c =valor;
            //this.lineaImpresion.Orden__c = 1;
            //this.lineaImpresion.Contrato__c = contrato.Id;
        }
        public wrapLineaImpresion(){
            this.checked = false;
        }
    }
    //Facturacion
    public FechaFacturacion__c fecha{get;set;}
    public list<wrapFechaFacturacion>  lstFechaFacturacion{get;set;}
    public list<FechaFacturacion__c> lstBorrarFF{get;set;}
    
    public class wrapFechaFacturacion{
        public boolean checked{get;set;}
        public FechaFacturacion__c fechaFacturacion{get;set;}
        
        public wrapFechaFacturacion(){
            this.fechaFacturacion = new FechaFacturacion__c();
            this.checked = false;
            this.fechaFacturacion.FechaInicio__c = date.today();
        }
    }
    //Direccion de entrega
    public wrapDireccion direccionEntrega{get;set;}
    public list<wrapDireccion> lstDireccion{get;set;}
    public list<DireccionEntrega__c> lstBorrarDireccion{get;set;}
    
    public class wrapDireccion{
        public boolean checked{get;set;}
        public DireccionEntrega__c dirEntrega{get;set;}
        public wrapDireccion(){
            this.checked = false;
        }
    }
    
    // Tarifas bonificacion / Escalonamiento 
    public string tipoCargo{get;set;}
    public string tipoRegistro{get;set;}
    public boolean tipoEscalo{get;set;}
    public boolean hideAjuste{get;set;}
    public boolean hideAniversarioMes{get;set;}
    public boolean hideComision{get;set;}
    public TarifaOportunidad__c tarifaOpp{get;set;}
    public WrappedBonificaciones tarifaSelect{get;set;}
    public List<TarifaOportunidad__c> catalogoTarifas {get;set;}
    public list<BonificacionEscalonamiento__c> lstBorrarBoniEsca{get;set;}
    public list<WrappedBonificaciones> lstBonificacionEscalonamiento{get;set;}
    public list<WrappedBonificaciones> lstNuevaBonEsca {get;set;}
    public String idProdCotizado {get; set;}// agrega calvarez aprox dic 2016
    
    public class WrappedBonificaciones{
        public boolean checked{get;set;}
        public TarifaOportunidad__c tipoCargo{get;set;}
        public BonificacionEscalonamiento__c bonificacion{get;set;}
        public WrappedBonificaciones(){
            this.checked = false;
            tipoCargo= new TarifaOportunidad__c();
            bonificacion = new BonificacionEscalonamiento__c();
        }
    }
    
    public ContratoTC3Controller(apexPages.StandardController std){
        // Datos de la cuenta
        contrato = new Contrato__c();
        idOportunidad = apexpages.currentpage().getparameters().get('id') == null ? '' : apexpages.currentpage().getparameters().get('id');
        ctaGrupo=true;
        ctaNoCliente=true; 
        // Contacto
        catalogoContacto = new list<wrapContacto>();
        lstContacto = new list<wrapContacto>();
        inciaContacto();
        lstborrarContacto = new list<Contact>();
        // Direccion
        lstDireccion = new list<wrapDireccion>();
        lstBorrarDireccion = new list<DireccionEntrega__c>(); 
        // Lineas de impresion
        lstLineaImpresion = new list<wrapLineaImpresion>();
        lstBorrarLI= new list<LineaImpresion__c>();
        // Facturacion
        fechaActual  = date.today()-1;
        lstFechaFacturacion = new list<wrapFechaFacturacion>();
        lstBorrarFF = new list<FechaFacturacion__c>();
        fecha = new FechaFacturacion__c(FechaInicio__c=Date.today());
        // Tarifas bonificacion / Escalonamiento 
        lstBonificacionEscalonamiento = new list<WrappedBonificaciones>();
        lstNuevaBonEsca = new list<WrappedBonificaciones>();
        catalogoTarifas = new List<TarifaOportunidad__c>();
        // Funciones para traer datos 
        obtenerDatos();
        iniciaDireccionEntrega();
        //idContrato = oppContrato.ContratoTC3__c;//comenta calvarez 8mar2017 - se mueve de línea
        // Garantia
        garantias = new List<Garantia__c>();
        garantias.add(new Garantia__c(TipoGarantia__c='Deposito en garantia', Contrato__c=contrato.Id));
        garantias.add(new Garantia__c(TipoGarantia__c='Fianza', Contrato__c=contrato.Id));
        garantias.add(new Garantia__c(TipoGarantia__c='Otra', Contrato__c=contrato.Id));



        //Autor calvarez, obtener producto cotizado estándar => QuoteLineItem 
        idProdCotizado = ApexPages.currentPage().getParameters().get('idProd') != null ? ApexPages.currentPage().getParameters().get('idProd') : '';
        if(String.isNotBlank(idProdCotizado)) {
            prodCotizado = [SELECT Id, Etapa__c, Product2Id, Product2.Family, Product2.Name, UnitPrice, ContratoTC3__c FROM QuoteLineItem WHERE Id=: idProdCotizado];
        }
        idContrato = prodCotizado.ContratoTC3__c;

        // Funciones para un contrato existente
        if(idContrato == null){
            contrato.Oportunidad__c = oppContrato.id;
            contrato.ProductoCotizado__c = (Id) idProdCotizado;
            contrato.Cuenta__c = accContrato.id;
            contrato.Estatus__c = 'Pendiente';
            contratoCuenta();
            //inciaContacto();
        } else {
            obtenerDatosContrato();
        }
        try{
            //prod = [SELECT Id, Name FROM Producto__c WHERE Id=:contrato.Producto__c LIMIT 1];
            prod = [SELECT Id, Name FROM Product2 WHERE Id=:contrato.Product2Id__c LIMIT 1];
        }
        catch(exception e){
        }
    }
    
    //Datos que se muestran de la cuenta
    public void contratoCuenta(){
        System.debug('contratoCuenta: ' + accContrato);
        garantia = new Garantia__c(Contrato__c=contrato.Id);

        //Autor: calvarez, Obtener campos de objeto estándar aprox dic 2016
        contrato.FamiliaCorporativa__c = prodCotizado.Product2.Family == '' ? '-' : prodCotizado.Product2.Family;
        contrato.Product2Id__c = prodCotizado.Product2Id;

        //contrato.FamiliaCorporativa__c = oppContrato.Familia__c ==''? '-': oppContrato.Familia__c;//comenta calvarez
        contrato.Sector__c = accContrato.Sector__c == null? '-' : accContrato.Sector__c;
        contrato.Fax__c = accContrato.Phone == null? '0' : accContrato.Phone;
        contrato.RazonSocial__c = accContrato.RazonSocial__c == null? '-' : accContrato.RazonSocial__c;
        contrato.RFC__c = accContrato.RFC__c == null? '-' : accContrato.RFC__c;
        contrato.Segmento__c = accContrato.Segmento__c == null? '-' : accContrato.Segmento__c;
        //contrato.Producto__c = oppContrato.Producto__c == null? null : oppContrato.Producto__c;//comenta calvarez
        string aux = accContrato.CodigoClienteAS400__c == null? '0' : accContrato.CodigoClienteAS400__c.mid(3, 5);
        if(aux=='0'){
            ctaGrupo=false;
        }else{
            ctaGrupo=true;
            contrato.Grupo__c = String.valueOf(aux);
        }
        aux = accContrato.CodigoClienteAS400__c == null? '0' : accContrato.CodigoClienteAS400__c.mid(8, 3);
        if(accContrato.CodigoClienteAS400__c == null){
            ctaNoCliente=false;
            System.debug('entra if');
        }else{
            System.debug('entra else: ' + aux);
            ctaNoCliente=true;
            contrato.NumeroCliente__c = String.valueOf(aux);
        }


        contrato.UsuarioAS400__c  = accContrato.Owner.UsuarioAS400__c == null? '-' : accContrato.Owner.UsuarioAS400__c;
        string calle = accContrato.Calle__c==null? '  ': accContrato.Calle__c;
        string NumeroExterior = accContrato.NumeroExterior__c == null? '  ': accContrato.NumeroExterior__c;
        string NumeroInterior = accContrato.NumeroExterior__c == null? '  ' : accContrato.NumeroInterior__c;
        contrato.DireccionFactura__c = esNulo(calle) + ' ' + esNulo(NumeroExterior) + ' ' + esNulo(NumeroInterior);
        contrato.CodigoPostal__c = accContrato.CodigoPostal__c == null? '-' : accContrato.CodigoPostal__c; 
        contrato.Calle__c = accContrato.Calle__c == null? '-' : accContrato.Calle__c;
        contrato.Colonia__c = accContrato.Colonia__c == null? '-' : accContrato.Colonia__c;
        contrato.NumeroExterior__c = accContrato.NumeroExterior__c == null? '-' : accContrato.NumeroExterior__c;
        contrato.Ciudad__c = accContrato.Ciudad__c == null? '-' : accContrato.Ciudad__c;
        contrato.NumeroInterior__c = accContrato.NumeroInterior__c == null? '-' : accContrato.NumeroInterior__c;
        contrato.Estado__c = accContrato.Estado__c == null? '-' : accContrato.Estado__c; 
        contrato.RecordTypeId = [Select Id From RecordType where DeveloperName ='TC3'].Id;
        contrato.VolEmisionEstimadoMensual__c = prodCotizado.UnitPrice == null ? 1 : prodCotizado.UnitPrice;
        //contrato.VolEmisionEstimadoMensual__c = oppContrato.Amount == null? 1 : oppContrato.Amount;
        contrato.Giro__c = accContrato.Giro__c == null? ' ' : accContrato.Giro__c;
        //       Vienen de Web Service:
        //contrato.Territorio__c=;
        //contrato.NombreEjecutivo__c=;
System.debug('Contrato al obtener cuenta: ' + contrato);
    }
    public String esNulo(String valor) {
        if(valor == null){
            return '';
        }else{
            return valor;
        }
    }
    //Se obtienen los datos de todos los objetos que se ocupan en el contrato 
    public void obtenerDatos() {
        try{
            oppContrato = (Opportunity)Database.query('SELECT '+String.join(new List<String>(SObjectType.Opportunity.Fields.getMap().keySet()), ', ')+' FROM Opportunity Where id =: idOportunidad');
            accId = oppContrato.AccountId;

            accContrato = (Account)Database.query('SELECT '+String.join(new List<String>(SObjectType.account.Fields.getMap().keySet()), ', ')+', Owner.UsuarioAS400__c FROM Account Where id =: accId'); 
            catalogoContacto = new list<wrapContacto>();
            System.debug('accContrato: ' + accContrato);
            
          

             //comenta - calvarez 14 dic 2016for(Contact addContactoR : [Select FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact  where Id in (select Contacto__c from ContactoRelacionado__c where Cuenta__c=: accId)]){                             
             for(Contact addContactoR : [Select FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact  where Id in (select ContactId from AccountContactRelation where AccountId=: accId)]){                             
                 wrapContacto wrpCon = new wrapContacto();
                wrpCon.contacto = addContactoR;
               catalogoContacto.add(wrpCon);
            }
            
            for(TarifaOportunidad__c tarOpp : [SELECT Id, Name, TipoCargo__c FROM TarifaOportunidad__c WHERE Oportunidad__c=:oppContrato.Id AND Producto__c =:oppContrato.Producto__c ]){
                catalogoTarifas.add(tarOpp);
            }
            
        }catch(exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, ' Obtener datos :  ' + e.getMessage()+'Linea:  '+ e.getLineNumber() ));
        } 
    }
    
    public void obtenerDatosContrato() {
        List<Garantia__c> garantiasContrato = [Select Id, Contrato__c, TipoGarantia__c, Monto__c ,Observaciones__c From Garantia__c Where Contrato__c =: idContrato Limit 3];
        if(garantiasContrato.size()>0){
            for(Garantia__c gar: garantiasContrato){
                if(gar.TipoGarantia__c == 'Deposito en garantia'){garantias[0]=gar;}
                if(gar.TipoGarantia__c == 'Fianza'){garantias[1]=gar;}
                if(gar.TipoGarantia__c == 'Otra'){garantias[2]=gar;}
            }
        }
        try{
            contrato = (Contrato__c)Database.query('SELECT '+String.join(new List<String>(SObjectType.Contrato__c.Fields.getMap().keySet()), ', ')+' FROM Contrato__c Where id =: idContrato limit 1'); 
            system.debug(contrato);
            for(LineaImpresion__c llenarLI :[SELECT Id, Name,DescripcionLineaImpresion__c,ClaveDescripcionLineaImpresion__c,Orden__c,Contrato__c FROM LineaImpresion__c WHERE Contrato__c =: contrato.Id]){
                wrapLineaImpresion linea = new wrapLineaImpresion();
                linea.lineaImpresion = llenarLI;
                lstLineaImpresion.add(linea);
            }
            
            for(FechaFacturacion__c llenarFF :[SELECT Id, Name,FechaInicio__c ,FechaFin__c, Contrato__c FROM FechaFacturacion__c WHERE Contrato__c =: contrato.Id]){
                wrapFechaFacturacion fecha = new wrapFechaFacturacion();
                fecha.fechaFacturacion = llenarFF;
                lstFechaFacturacion.add(fecha);
            }
            lstContacto[0].contacto = [Select Id, FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact Where id =: contrato.ContactoDecide__c ].size() > 0 ? [Select FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact Where id =: contrato.ContactoDecide__c] : new Contact();
            system.debug(contrato.ContactoDecide__c);
            lstContacto[1].contacto = [Select Id, FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact Where id =: contrato.ContactoSolicita__c ].size() > 0 ? [Select Id, FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact Where id =: contrato.ContactoSolicita__c] : new Contact();
            system.debug(contrato.ContactoSolicita__c);
            lstContacto[2].contacto = [Select Id, FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact Where id =: contrato.OtroContacto__c ].size() > 0 ? [Select Id, FirstName, LastName, OtroPuesto__c, Puesto__c, HorarioOficina__c, Phone, Extension__c, Email, TipoContacto__c From Contact Where id =: contrato.OtroContacto__c] : new Contact();
            system.debug(contrato.OtroContacto__c);
            lstContacto[0].tipoContacto = 'Contacto que decide';
            lstContacto[1].tipoContacto = 'Contacto que solicita';
            lstContacto[2].tipoContacto = 'Otro contacto';
            
            //lstContacto[0].contacto.TipoContacto__c = 'Contacto que decide';
            //lstContacto[1].contacto.TipoContacto__c = 'Contacto que solicita';
            //lstContacto[2].contacto.TipoContacto__c = 'Otro contacto';
            
            for(DireccionEntrega__c llenarDireccion : [Select Id, Calle__c, ClaveDireccion__c, Descripcion__c, Direccion__c, NumExterior__c, NumInterior__c, CodigoPostal__c, Colonia__c, Ciudad__c, Estado__c, AtencionA__c, Puesto__c, Telefono__c, Extension__c, Email__c, Horario__c, NombrePersonalizar__c, DireccionPersonalizar__c, Observaciones__c,Estatus__c From DireccionEntrega__c Where Contrato__c =: idContrato]){
                wrapDireccion datosDireccion = new wrapDireccion();
                datosDireccion.dirEntrega = llenarDireccion;
                lstDireccion.add(datosDireccion);
            }
            system.debug('Lista direccion de entrega SE LLENA CON DATOS GUARDADOS: ' + lstDireccion);
            
        } catch(exception e) {
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, ' Obtener datos del contrato :  ' + e.getMessage() ));
            System.debug(' Obtener datos del contrato :  ' + e.getMessage()+' linea: '+e.getLineNumber());
        }
    }
    
   
    //Funcionalidad de Fecha de Facturación 
    public void guardaFechaFacturacion() {
        // try{
        List<FechaFacturacion__c> insertaFechas = new List<FechaFacturacion__c>();
        for(wrapFechaFacturacion li: lstFechaFacturacion){
            li.fechaFacturacion.Contrato__c = contrato.Id;
            insertaFechas.add(li.fechaFacturacion);
        }
        upsert insertaFechas;
        if(lstBorrarFF.size() > 0){
            delete lstBorrarFF;
        }
        //}catch(exception e){
        //  PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
        //}
    }
    public void agregarFechaFacturacion() { 
        try{
            wrapFechaFacturacion nuevaFecha = new wrapFechaFacturacion();
            
            if(lstFechaFacturacion.size()>0){
                Date lastDate = lstFechaFacturacion[lstFechaFacturacion.size()-1].fechaFacturacion.FechaFin__c ;
                nuevaFecha.fechaFacturacion.FechaInicio__c=lastDate + 1;
            }
            lstFechaFacturacion.add(nuevaFecha);
        }
        catch(exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
        }
        return ;
    }
    
    public void borrarFechaFacturacion(){
        try {
            for(integer i = 0; i < lstFechaFacturacion.size(); i++){
                if(lstFechaFacturacion[i].checked){
                    if(lstFechaFacturacion[i].fechaFacturacion.Id != null){
                        lstBorrarFF.add(lstFechaFacturacion[i].fechaFacturacion);
                    }
                    lstFechaFacturacion.remove(i);
                    i=i-1;
                }
            }
        } catch(exception e) {
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
        }
    }
    
    
    //Funcionalidad de Líneas de Impresión
    public void guardaLineaImpresion() {
        List<LineaImpresion__c> insertaLineas = new List<LineaImpresion__c>();
        for(wrapLineaImpresion li: lstLineaImpresion){
            li.lineaImpresion.Contrato__c = contrato.Id;
            insertaLineas.add(li.lineaImpresion);
        }       
        if(lstBorrarLI.size() >0){
            system.debug('entra');
            system.debug('Antes de borrar' + lstBorrarLI);
            delete lstBorrarLI;
              system.debug('Despues de borrar' + lstBorrarLI);
        }
        upsert insertaLineas;
    }    

    public void agregarLineaImpresion() { 
        try{            
            if(lstLineaImpresion.size() < 3){
                lstLineaImpresion.add( new wrapLineaImpresion(oppContrato, lineaImpresion ) );
            }
        }
        catch(exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
            System.debug(' guardaLineaImpresion:  ' + e.getMessage()+' linea: '+e.getLineNumber());
        }
        return ;
    }
    
    public void borrarLineaImpresion() {
        try{
            for(integer i = 0; i < lstLineaImpresion.size(); i++){
                if(lstLineaImpresion[i].checked){
                    if(lstLineaImpresion[i].lineaImpresion.Id != null){
                        lstBorrarLI.add(lstLineaImpresion[i].lineaImpresion);
                        system.debug(lstBorrarLI);
                    }
                    lstLineaImpresion.remove(i);
                    i=i-1;
                }
            }
        }catch(exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
        }
    }
    
    // Funcionalidad para la seccion Contacto
    public List<SelectOption> getOtroPuesto() {
        List<SelectOption> otroPuesto = new List<SelectOption>();
        otroPuesto.add(new SelectOption('' , ''));
        for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Puesto']){
            otroPuesto.add(new SelectOption(cat.Descripcion__c, cat.Descripcion__c));
        }
        return otroPuesto; 
    }
    
    public void inciaContacto() {
        lstContacto.add( new wrapContacto('Contacto que decide'));
        lstContacto.add( new wrapContacto('Contacto que solicita'));
        lstContacto.add( new wrapContacto('Otro contacto'));
    }
    
    public void nuevoContacto() {
        nuevoContacto = new wrapContacto();
        if(lstContacto != null)
            for(integer i = 0; i < lstContacto.size(); i++){
                if(lstContacto[i].checked){
                    nuevoContacto.tipoContacto = lstContacto[i].tipoContacto;
                    for(integer j = 0; j < lstCatalogoBueno.size(); j++){
                        if(lstCatalogoBueno[j].checked){
                            nuevoContacto.contacto = lstCatalogoBueno[j].contacto;
                            j = lstCatalogoBueno.size();
                        }else{
                            nuevoContactoBoton();
                        }
                    }
                    if(lstCatalogoBueno.isEmpty()){
                            nuevoContactoBoton();
                        }
                    i=lstContacto.size();
                }
            }
    }
    
    public void nuevoContactoBoton() {
        nuevoContacto = new wrapContacto();
        for(integer i = 0; i < lstContacto.size(); i++){
            if(lstContacto[i].checked){
                nuevoContacto.tipoContacto = lstContacto[i].tipoContacto;
                i = lstContacto.size();
            }
        }
        nuevoContacto.contacto = new Contact();    
    }
    
    public void agregarNuevoContacto() {
        for(integer i = 0; i < lstContacto.size(); i++){
            if(lstContacto[i].checked){
                lstContacto[i].tipoContacto = nuevoContacto.tipoContacto;
                lstContacto[i].contacto = nuevoContacto.contacto;
                i = lstContacto.size();
            }
        }
    }
    
    public void agregarContactoExistente() {
        String tipoContacto ='';
        for(integer j = 0; j < lstContacto.size(); j++){
            if(lstContacto[j].checked){
                tipoContacto = lstContacto[j].tipoContacto;
                for(integer i = 0; i < lstCatalogoBueno.size(); i++){
                    if(lstCatalogoBueno[i].checked){
                        if(tipoContacto =='Contacto que decide'){
                            lstContacto[0].contacto = lstCatalogoBueno[i].contacto;
                            lstContacto[0].TipoContacto = tipoContacto;
                            lstContacto[0].checked = false;
                        }else if(tipoContacto == 'Contacto que solicita'){
                            lstContacto[1].contacto = lstCatalogoBueno[i].contacto;
                            lstContacto[1].TipoContacto = tipoContacto;
                            lstContacto[1].checked = false;
                        }else{
                            lstContacto[2].contacto = lstCatalogoBueno[i].contacto;
                            lstContacto[2].TipoContacto = tipoContacto;
                            lstContacto[2].checked = false;
                        }
                        lstCatalogoBueno[i].checked = false;
                        break;
                    }
                }
                break;
            }
        }
    }
    
    public list<wrapContacto> lstCatalogoBueno{get;set;}
    public void llenaCatalogoContacto(){
        lstCatalogoBueno = new list<wrapContacto>();
        for(wrapContacto addContacto : catalogoContacto){
            lstCatalogoBueno.add(addContacto);
        }
    }
    
    public Integer guardarContacto() {
        try {
            Contact guardaContactoDecide = new Contact();
            Contact guardaContactoSolicita = new Contact();
            Contact guardaOtroContacto = new Contact();
            if(lstContacto.size() == 3){
                if(lstContacto[0].contacto.FirstName != null && lstContacto[0].contacto.LastName != null){
                    lstContacto[0].contacto.AccountId = accId;
                    guardaContactoDecide = lstContacto[0].contacto;
                } else{
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Se deben agregar 3 contactos'));
                    System.debug('guardarContacto 1');
                    return 1;
                }
                if(lstContacto[1].contacto.FirstName !=null && lstContacto[1].contacto.LastName !=null){
                    lstContacto[1].contacto.AccountId = accId;
                    guardaContactoSolicita = lstContacto[1].contacto;
                } else{
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Se deben agregar 3 contactos'));
                    System.debug('guardarContacto 2');
                    return 1;
                }
                if(lstContacto[2].contacto.FirstName !=null && lstContacto[2].contacto.LastName !=null){
                    lstContacto[2].contacto.AccountId = accId;
                    guardaOtroContacto = lstContacto[2].contacto;
                } else{
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Se deben agregar 3 contactos'));
                    System.debug('guardarContacto 3');
                    return 1;
                }
            }
            
            upsert guardaContactoDecide;
            upsert guardaContactoSolicita; 
            upsert guardaOtroContacto; 
            
            contrato.ContactoDecide__c = guardaContactoDecide.id;
            contrato.ContactoSolicita__c = guardaContactoSolicita.id;
            contrato.OtroContacto__c = guardaOtroContacto.id;
            
            System.debug(contrato.ContactoDecide__c);
            System.debug(contrato.ContactoSolicita__c);
            System.debug(contrato.OtroContacto__c);
        }catch(exception e){
            System.debug(' guardarContacto 1:  ' + e.getMessage()+' linea: '+e.getLineNumber());
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() + e.getLineNumber() ));
            System.debug(' guardarContacto 2:  ' + e.getMessage()+' linea: '+e.getLineNumber());
            return 1;
        }
        return 0;
    }
    
    //Funcionalidad de Direccion Entrega
    public void iniciaDireccionEntrega() {
        direccionEntrega = new wrapDireccion();
        direccionEntrega.dirEntrega = new DireccionEntrega__c();
        direccionEntrega.dirEntrega.ClaveDireccion__c = 'ENTR';
        direccionEntrega.dirEntrega.Estatus__c = 'OK';
    }
    
    public void agregarDireccion() {
        try {
            for(wrapDireccion wDireccion:lstDireccion){
                if(wDireccion.dirEntrega.ClaveDireccion__c == direccionEntrega.dirEntrega.ClaveDireccion__c){
                    direccionEntrega.dirEntrega.ClaveDireccion__c.addError('Clave direccion repetida');
                    //PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Clave direccion repetida'));
                    return;
                }
            }
            lstDireccion.add(direccionEntrega);
            system.debug('Lista direccion de entrega DESPUES DE AGREGAR: ' + lstDireccion);
            iniciaDireccionEntrega();
        }catch(exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
        }
    }
    
    public void borrarDireccion() {
        try {
            for(integer i = 0; i < lstDireccion.size(); i++){
                system.debug(lstDireccion[i].checked);
                if(lstDireccion[i].checked){
                    if(lstDireccion[i].dirEntrega.id != null){
                        lstBorrarDireccion.add(lstDireccion[i].dirEntrega);
                    }
                    lstDireccion.remove(i);
                    i=i-1;
                }
            }
        }catch(exception e){
            system.debug('Error:  '+e.getMessage());
        }
    }
    
    //Borrar Contratos
    public void borrarContrato() {
        try{
            list<Contrato__c> borrarContrato = new list<Contrato__c>();
            for(Contrato__c li: [Select Id, Name, RFC__c, Oportunidad__c From Contrato__c Where id !=: oppContrato.ContratoTC3__c AND Oportunidad__c =: idOportunidad]){
                borrarContrato.add(li);
            }
            //delete borrarContrato;//Comenta calvarez 8mar2017
        }catch(exception e){
             PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() +'Linea:  ' + e.getLineNumber()));
            
        }	
    }
    
    public void agregarDireccionCuenta() {
        Account dirContrato = [SELECT Name, Calle__c, NumeroExterior__c, NumeroInterior__c, CodigoPostal__c, Colonia__c, Ciudad__c, Estado__c, RazonSocial__c, phone, BillingAddress FROM Account Where id =: accId limit 1];
        //direccionEntrega.dirEntrega.ClaveDireccion__c = 'ENTR';
        direccionEntrega.dirEntrega.Descripcion__c  = dirContrato.RazonSocial__c;
        direccionEntrega.dirEntrega.Direccion__c  = esNulo(dirContrato.Calle__c) + '  ' + esNulo(dirContrato.NumeroExterior__c) + '  ' + esNulo(dirContrato.NumeroInterior__c);
        direccionEntrega.dirEntrega.Calle__c = dirContrato.Calle__c;
        direccionEntrega.dirEntrega.NumExterior__c  = dirContrato.NumeroExterior__c;
        direccionEntrega.dirEntrega.NumInterior__c  = dirContrato.NumeroInterior__c;
        direccionEntrega.dirEntrega.CodigoPostal__c  = dirContrato.CodigoPostal__c;
        direccionEntrega.dirEntrega.Colonia__c  = dirContrato.Colonia__c;
        direccionEntrega.dirEntrega.Ciudad__c  = dirContrato.Ciudad__c;
        direccionEntrega.dirEntrega.Estado__c  = dirContrato.Estado__c;
        direccionEntrega.dirEntrega.AtencionA__c = lstContacto[1].contacto.firstName;
        direccionEntrega.dirEntrega.Puesto__c = lstContacto[1].contacto.OtroPuesto__c;
        direccionEntrega.dirEntrega.Telefono__c  = lstContacto[1].contacto.Phone;
        direccionEntrega.dirEntrega.Extension__c = Decimal.valueOf(lstContacto[1].contacto.Extension__c);
        direccionEntrega.dirEntrega.Email__c = lstContacto[1].contacto.Email;
        direccionEntrega.dirEntrega.Horario__c  = lstContacto[1].contacto.HorarioOficina__c;
        direccionEntrega.dirEntrega.NombrePersonalizar__c  = dirContrato.RazonSocial__c;
        direccionEntrega.dirEntrega.DireccionPersonalizar__c  = esNulo(dirContrato.Calle__c) + '  ' + esNulo(dirContrato.NumeroExterior__c) + '  ' + esNulo(dirContrato.NumeroInterior__c);
        //direccionEntrega.dirEntrega.Estatus__c = 'OK';
    }
    
    public void guardarDireccion() {
        list<DireccionEntrega__c> guardaDirecciones = new list<DireccionEntrega__c>();
        if(lstDireccion.size() > 0){
            system.debug('Lista direccion de entrega ANTES DE GUARDAR: ' + lstDireccion);
            for(wrapDireccion guarda: lstDireccion){
                guarda.dirEntrega.contrato__c = contrato.Id;
                guardaDirecciones.add(guarda.dirEntrega);
            }
        }
        upsert guardaDirecciones;
        system.debug('Lista direccion de entrega DESPUES DE GUARDAR: ' + lstDireccion);
        if(lstBorrarDireccion.size() >0){
            delete lstBorrarDireccion;
        }
    }
    //Se Guarda todo el contrato 
    public void guardar(){
        System.debug('Id COntratoTC3: ' + contrato);
        try {

                System.debug(' ---1');
            contrato.OrigenVenta__c = Utils.MAP_ORIGENVENTA.get(contrato.ClaveOrigenVenta__c);
            contrato.Sucursal__c = Utils.MAP_SUCURSAL.get(contrato.ClaveSucursal__c);
            contrato.Competidor__c = Utils.MAP_COMPETIDOR.get(contrato.ClaveCompetidor__c);
            contrato.TipoPago__c = Utils.MAP_TIPOPAGO.get(contrato.ClaveTipoPago__c);
            contrato.Financiamiento__c = Utils.MAP_FINANCIAMIENTO.get(contrato.ClaveFinanciamiento__c);
            contrato.TipoFinanciamiento__c = Utils.MAP_TIPOFINANCIAMIENTO.get(contrato.ClaveTipoFinanciamiento__c);
            contrato.MedioPago__c = Utils.MAP_MEDIOPAGO.get(contrato.ClaveMedioPago__c);
            contrato.FrecuenciaLiberacionAutomatica__c = Utils.MAP_FRECUENCIALIBERACIONAUTOMATICA.get(contrato.ClaveFrecuenciaLiberacionAutomatica__c);
            contrato.TipoFacturacion__c = Utils.MAP_TIPOFACTURACION.get(contrato.ClaveTipoFacturacion__c);
            contrato.FrecuenciaFacturacion__c = Utils.MAP_FRECUENCIAFACTURACION.get(contrato.ClaveFrecuenciaFacturacion__c);
            contrato.ComoFactura__c = Utils.MAP_COMOFACTURA.get(contrato.ClaveComoFactura__c);
            contrato.TipoCliente__c = Utils.MAP_TIPOCLIENTE.get(contrato.ClaveTipoCliente__c);
            contrato.FacturacionCargos__c = Utils.MAP_FACTURACIONCARGOS.get(contrato.ClaveFacturacionCargos__c);
            contrato.FacturacionComision__c = Utils.MAP_FACTURACIONCOMISION.get(contrato.ClaveFacturacionComision__c);
            contrato.FacturacionPlastico__c = Utils.MAP_FACTURACIONPLASTICO.get(contrato.ClaveFacturacionPlastico__c);
            contrato.OperacionModoOffline__c = Utils.MAP_OPERACIONMODOOFFLINE.get(contrato.ClaveOperacionModoOffline__c);
            contrato.TipoPlasticoTarjetaFinanciera__c = Utils.MAP_TIPOPLASTICOTARJETAFINANCIERA.get(contrato.ClaveTipoPlasticoTarjetaFinanciera__c);
            contrato.TipoPlasticoTarjetaStock__c = Utils.MAP_TIPOPLASTICOTARJETASTOCK.get(contrato.ClaveTipoPlasticoTarjetaStock__c);
            contrato.Maneja__c = Utils.MAP_MANEJA.get(contrato.ClaveManeja__c);
            contrato.Red__c = Utils.MAP_RED.get(contrato.Red__c);
            contrato.ItemContratacion__c = Utils.MAP_ITEMCONTRATACION.get(contrato.ClaveItemContratacion__c);
            // agrega calvarez 28feb2017
            contrato.TipoMaquila__c = Utils.MAP_MAQUILA.get(contrato.ClaveMaquila__c);
            
            String camposFaltantes='|';
            if(contrato.OrigenVenta__c==null){camposFaltantes=camposFaltantes+' Origen de venta |';}
            if(contrato.Sucursal__c==null){camposFaltantes=camposFaltantes+' Sucursal |';}
            if(contrato.Grupo__c==null){camposFaltantes=camposFaltantes+' Grupo |';}
            if(contrato.NumeroCliente__c==null){camposFaltantes=camposFaltantes+' No. de cliente |';}
            if(contrato.TipoPago__c==null){camposFaltantes=camposFaltantes+' Tipo de pago |';}
            if(contrato.CondicionesPago__c==''){camposFaltantes=camposFaltantes+' Condiciones de pago |';}
            if(contrato.FrecuenciaPedido__c==''){camposFaltantes=camposFaltantes+' Frecuencia de Pedido |';}
            if(contrato.MedioPago__c==null){camposFaltantes=camposFaltantes+' Medio de pago |';}
            if(contrato.TipoFacturacion__c==null){camposFaltantes=camposFaltantes+' Tipo de facturación |';}
            if(contrato.FrecuenciaFacturacion__c==null){camposFaltantes=camposFaltantes+' Frecuencia de facturación |';}
            if(contrato.ComoFactura__c==null){camposFaltantes=camposFaltantes+' Cómo factura |';}
            if(contrato.FacturacionCargos__c==null){camposFaltantes=camposFaltantes+' Facturación cargos |';}
            if(contrato.FacturacionComision__c==null){camposFaltantes=camposFaltantes+' Facturación comisión |';}
            if(contrato.FacturacionPlastico__c==null){camposFaltantes=camposFaltantes+' Facturación plástico |';}
            if(contrato.ItemContratacion__c==null){camposFaltantes=camposFaltantes+'Item de contratación |';}
            if(contrato.ClaveOperacionModoOffline__c==null){camposFaltantes=camposFaltantes+' Operación modo Offline |';}
            
            if(contrato.ClaveFinanciamiento__c == 'M'){
                if(contrato.Clasificacion__c==null){camposFaltantes=camposFaltantes+' Clasificacion |';}
            }
            if(contrato.EmpresaPrincipal__c == false){
                if(contrato.IdPrime__c==null){camposFaltantes=camposFaltantes+' Id empresa prime |';}
            }
            
            if(contrato.ClaveTipoPago__c=='1'){
                if(contrato.LineaOperativa__c==null){camposFaltantes=camposFaltantes+' Línea operativa |';}
            }
            //if(contrato.ClaveComoFactura__c== '2') {Comenta y agrega siguiente línea calvarez 24 mayo 2017
                System.debug('EsConsolidador__c: ' + contrato.EsConsolidador__c);
            if(contrato.ClaveComoFactura__c== '2' && contrato.EsConsolidador__c == false) {
                if(contrato.GrupoConsolidacion__c==null){camposFaltantes=camposFaltantes+' Grupo de consolidación |';}
                if(contrato.SucursalConsolidacion__c==null){camposFaltantes=camposFaltantes+' Sucursal de consolidación |';}
                if(contrato.ClienteConsolidacion__c==null){camposFaltantes=camposFaltantes+' Cliente de consolidación |';}
            }
            if(contrato.ClaveComoFactura__c== '3' || contrato.ClaveComoFactura__c=='4' || contrato.ClaveComoFactura__c=='5' || contrato.ClaveComoFactura__c=='6'){
                if(contrato.ProductoFacturacionGlobal__c==null){camposFaltantes=camposFaltantes+' Producto de facturación global|';}
                if(contrato.SucursalFacturacionGlobal__c==null){camposFaltantes=camposFaltantes+' Sucursal de facturación global |';}
                if(contrato.GrupoFacturacionGlobal__c==null){camposFaltantes=camposFaltantes+' Grupo de facturación global |';}
                if(contrato.ClienteFacturacionGlobal__c==null){camposFaltantes=camposFaltantes+' Cliente de facturación global|';}
            }
            if(contrato.ClaveOperacionModoOffline__c== '3'){
                if(contrato.IntervaloEntreTransacciones__c==null){camposFaltantes=camposFaltantes+' Intervalo entre transacciones |';}
                if(contrato.CantidadMaxTransaccionesOffline__c==null){camposFaltantes=camposFaltantes+' Cantidad Max. de Transacciones Offline |';}
                if(contrato.ValorMaxParaUnaTransaccion__c==null){camposFaltantes=camposFaltantes+' Valor Max. Para una Transacción |';}
            }
            
            if(contrato.ImprimeLogo__c==true){
                if(contrato.TipoPlasticoTarjetaFinanciera__c==null){camposFaltantes=camposFaltantes+' Tipo plástico (Tarjeta Financiera) |';}
                if(contrato.TipoPlasticoTarjetaStock__c==null){camposFaltantes=camposFaltantes+' Tipo plástico (Tarjeta Stock) |';}
            }

            //agrega calvarez 23 mayo de 2017
            String errorAux = '';
            if(String.isBlank(accContrato.NumeroExterior__c)) {
                errorAux += ' ' + Account.NumeroExterior__c.getDescribe().getLabel();
            }
            if(String.isBlank(accContrato.Calle__c)) {
                if(errorAux.length() > 0) {
                    errorAux += ', ';
                }
                errorAux += Account.Calle__c.getDescribe().getLabel();
            }
            if(String.isBlank(accContrato.Colonia__c)) {
                if(errorAux.length() > 0) {
                    errorAux += ', ';
                }
                errorAux += Account.Colonia__c.getDescribe().getLabel();
            }
            if(String.isBlank(accContrato.CodigoPostal__c)) {
                if(errorAux.length() > 0) {
                    errorAux += ', ';
                }
                errorAux += Account.CodigoPostal__c.getDescribe().getLabel();
            }
            if(errorAux.length() > 0) {
                camposFaltantes += 'Campos faltantes en objeto Cuenta: ' + errorAux;
            }
            
            if(camposFaltantes!='|'){
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Falta ingresar información. Todos los campos en rojo son obligatorios: '+ camposFaltantes));

                System.debug('return 1');
                return; 
            }
            
            if(contrato.NombrePersonalizacion__c==null||contrato.NombrePersonalizacion__c==''){
                String nombrePersonalizacion = String.valueOf(accContrato.Name);
                contrato.NombrePersonalizacion__c = nombrePersonalizacion.length() > 25 ? nombrePersonalizacion.substring(0,25) : nombrePersonalizacion ;
            }
            
                System.debug('---2');
            if(contrato.ClaveFrecuenciaFacturacion__c=='52'){
                System.debug('---3');
                if(lstFechaFacturacion.size()<2){
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Se deben agregar al menos dos periodos de facturación' ));
                System.debug('return 2');
                    return	;
                }
                for(wrapFechaFacturacion fact: lstFechaFacturacion){
                    if(fact.fechaFacturacion.FechaInicio__c==null || fact.fechaFacturacion.FechaFin__c==null){
                        PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Las fechas de facturación no pueden ir vacías'));
                System.debug('return 2');
                        return;
                    }
                    
                }
            } else{
                System.debug('---3');
                for(wrapFechaFacturacion fecha: lstFechaFacturacion){
                    if(fecha.fechaFacturacion.FechaInicio__c > fecha.fechaFacturacion.FechaFin__c  ){
                        PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Una fecha de inicio de facturación no puede ser mayor a su fecha final' ));
                System.debug('return 4');
                        return;
                    }
                } 
                if(lstFechaFacturacion.size() > 0){
                    List<FechaFacturacion__c> borrarFechasFac = new List<FechaFacturacion__c>();
                    for(wrapFechaFacturacion fecha: lstFechaFacturacion){
                        if(fecha.fechaFacturacion.id != null){
                            borrarFechasFac.add(fecha.fechaFacturacion);
                        }
                    }
                     if(borrarFechasFac.size() > 0 && borrarFechasFac != null){
                    	 delete borrarFechasFac;
                    } 
                } 
            }
            
            if(contrato.ClaveItemContratacion__c == '2') { // Si la clave de contrato es - TC Basico -
                if(lstLineaImpresion.size() >= 1 &&  lstLineaImpresion.size()  < 3){
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes ingresar 3 líneas de impresión' ));
                System.debug('--- return 1');
                    return;
                }
                Integer resultado = guardarContacto();
                System.debug('--- return 2');
                if(resultado==1) {
                System.debug('--- return 3');
                    return;
                }
                if(contrato.ClaveFrecuenciaFacturacion__c=='52'){
                    guardaFechaFacturacion();
                }
                if(lstDireccion.size()==0){
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes agregar al menos una dirección de entrega'));
                System.debug('--- return 4');
                    return;
                }
                if(lstLineaImpresion.size() > 0){
                    for(Integer i=1; i<4;i++){
                        if( (lstLineaImpresion[0].lineaImpresion.Orden__c==i&&lstLineaImpresion[1].lineaImpresion.Orden__c==i)||(lstLineaImpresion[1].lineaImpresion.Orden__c==i&&lstLineaImpresion[2].lineaImpresion.Orden__c==i)){
                            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Los valores de orden de las líneas de impresión deben ser diferentes' ));
                System.debug('--- return 5');
                            return;
                        }
                    }
                }
                //Se Guarda el contrato, Linea de impresion y Direccion de entrega, Si la clave de contrato es diferente - TC Basico -
                upsert contrato;
                //agrega calvarez 8mar2017
                System.debug('actualizar prodCotizado: ' + prodCotizado);
                if(prodCotizado != null && prodCotizado.Id != null) {
                    prodCotizado.ContratoTC3__c = contrato.Id;
                    update prodCotizado;
                }
                guardaLineaImpresion();
                if(lstDireccion.size()==0){
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes agregar al menos una dirección de entrega'));
                    return;
                }
                guardarDireccion();
                
            } else{
                // Si la clave de contrato es diferente - TC Basico -
                
                //Se eliminan las lineas de impresion si se ocultan en el contrato
                if(lstLineaImpresion.size() > 0){
                    List<LineaImpresion__c> insertaLineas = new List<LineaImpresion__c>();
                    for(wrapLineaImpresion li: lstLineaImpresion){
                        if(li.lineaImpresion.id != null){
                            insertaLineas.add(li.lineaImpresion);
                        }
                    }
                    if(insertaLineas.size() > 0 && insertaLineas != null){
                        delete insertaLineas;
                    }
                }
                
                //Se Limpia lista de elemntos borrados de lineas de impresion 
                if(lstBorrarLI.size() > 0){
                    system.debug('entra');
                    system.debug('Antes de borrar' + lstBorrarLI);
                    delete lstBorrarLI;
                    system.debug('Despues de borrar' + lstBorrarLI);
                }
                
                // se Guarda el contrato, Fecha de facturacion Y Direccion de entrega, Si la clave de contrato es diferente - TC Basico -
                upsert contrato;
                Integer resultado = guardarContacto();
                System.debug('return 5');
                if(resultado==1)
                    return;
                if(contrato.ClaveFrecuenciaFacturacion__c=='52'){
                    guardaFechaFacturacion();
                }
                if(lstDireccion.size()==0){
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes agregar al menos una dirección de entrega'));
                    return;
                }
                guardarDireccion();
            }// Termina else de  - TC Basico -
            
            
            if(contrato.ClaveTipoPago__c == '1'){
                for(Garantia__c gar : garantias){
                    if(gar.Contrato__c == null){
                        gar.Contrato__c=contrato.Id; 
                    }
                    upsert gar;
                }
            }else{
                for(Garantia__c gar : garantias){
                    if(gar.Monto__c != null && gar.Observaciones__c != null && gar.Contrato__c != null){
                        try{
                            delete garantias;
                        }catch(Exception e){ 
                        }
                    }
                }
            }   
            upsert contrato;
            System.debug('contrato actualizado: ' + contrato);
            oppContrato.ContratoTC3__c = contrato.Id;
            upsert oppContrato;
            
            prodCotizado.ContratoTC3__c = contrato.Id;
            update prodCotizado;//agrega calvarez 3-mar-2017 asocia contrato a producto cotizado
            System.debug('prodCotizado actualizado: ' + prodCotizado);
            borrarContrato();
            
            
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'La información se guardo correctamente' ));
        }catch(exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() + 'Linea:  ' + e.getLineNumber()));
            System.debug(' guardar:  ' + e.getMessage()+' linea: '+e.getLineNumber());
        }
    }*/
}