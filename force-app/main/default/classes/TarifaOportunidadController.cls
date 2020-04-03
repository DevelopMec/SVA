public with sharing class TarifaOportunidadController {
    
    List<TarifaOportunidad__c> tarifasOportunidades{get;set;}
    //Objetos salesforce
    public Account cuenta {get;set;}
    public Contrato__c contrato{get;set;}
    public Opportunity oportunidad {get;set;}
    public Producto__c producto {get;set;}
    public TarifaOportunidad__c  tarifaOportunidadGlobal {get;set;}
    public List<BonificacionEscalonamiento__c> bonificacionesOpp{get;set;}
    
    
    public List<BonificacionEscalonamiento__c> EscalonamientosOpp{get;set;}
    public List<Descuento__c> catalogoDescuentos{get;set;}
    public List<TarifaOportunidad__c> tarifaOportunidadAnteriores{get;set;}
    
    //Wrapped
    public List<WrappedTarifas> catalogoTarifas {get;set;}
    public WrappedTarifas tarifaActual{get;set;}
    public List<WrappedTarifas> tarifasAplicables {get;set;}
    public List<WrappedBonificaciones> bonificacionesActuales{get;set;}
    public List<WrappedBonificaciones> escalonamientosActuales{get;set;}
    
    //listas de selección
    public List<SelectOption> usos {get;set;}
    public List<SelectOption> tipoSolucion {get;set;}
    public List<SelectOption> subproductos {get;set;}
    public List<SelectOption> tarifasBonificaciones{get;set;}
    
    //Tipo primitivo u objeto
    public Date fechaActual {get;set;}
    public String idOportunidad {get;set;}
    public String muestraAnterior{get;set;}
    public String productoSeleccionado {get;set{
        if(this.productoSeleccionado != value){
        bonificacionesActuales= new List<WrappedBonificaciones>();
        escalonamientosActuales=new List<WrappedBonificaciones>();
        this.productoSeleccionado = value; 
            
        }
    }}
    public String usoActual {get;set;}
    public String tipoSolucionActual {get;set;}
    public String aux{get;set;}
    public String escalonamientoAplicable{get;set;}
    public Boolean esEscalonamiento{get;set;}
    public Boolean desactivaUso{get;set;}
    public Boolean activaTipoSolucion{get;set;}
    public Boolean seleccionaTodo{get;set;}
    public Boolean sinTipoSolucion{get;set;}
    public Boolean esEnviado{get;set;}
    public Boolean esNuevo {get;set;}
    public Boolean tieneSubproducto{get;set;}
    public Boolean guardo{get;set;}
    public Boolean tieneTarifas{get;set;}
    public list<String> subproductosSeleccionados {get;set;}
    
    public String tarifaBonificacion
    {get{
        if(tarifaBonificacion==null){
            tarifaBonificacion='';
        }return tarifaBonificacion;
    }set;}
    
    //Aplica para Anualidad
    public BonificacionEscalonamiento__c bonificacion{get;set;}
    public Boolean aplicaAnualidad{get;set;}
    public Boolean aplicaAniversario{get;set;}
    public String mesSeleccionado
    {get{
        if(mesSeleccionado==null){
            Integer mes = Date.today().month();
            if(mes==1){mesSeleccionado='Enero';}
            if(mes==2){mesSeleccionado='Febrero';}
            if(mes==3){mesSeleccionado='Marzo';}
            if(mes==4){mesSeleccionado='Abril';}
            if(mes==5){mesSeleccionado='Mayo';}
            if(mes==6){mesSeleccionado='Junio';}
            if(mes==7){mesSeleccionado='Julio';}
            if(mes==8){mesSeleccionado='Agosto';}
            if(mes==9){mesSeleccionado='Septiembre';}
            if(mes==10){mesSeleccionado='Octubre';}
            if(mes==11){mesSeleccionado='Noviembre';}
            if(mes==12){mesSeleccionado='Diciembre';}
        }return mesSeleccionado;
    }set;}
    public List<SelectOption> mesAplica{get{
        List<SelectOption> mesAplica= new List<SelectOption>();
        mesAplica.add(new selectOption('Enero','Enero'));
        mesAplica.add(new selectOption('Febrero','Febrero'));
        mesAplica.add(new selectOption('Marzo','Marzo'));
        mesAplica.add(new selectOption('Abril','Abril'));
        mesAplica.add(new selectOption('Mayo','Mayo'));
        mesAplica.add(new selectOption('Junio','Junio'));
        mesAplica.add(new selectOption('Julio','Julio'));
        mesAplica.add(new selectOption('Agosto','Agosto'));
        mesAplica.add(new selectOption('Septiembre','Septiembre'));
        mesAplica.add(new selectOption('Octubre','Octubre'));
        mesAplica.add(new selectOption('Noviembre','Noviembre'));
        mesAplica.add(new selectOption('Diciembre','Diciembre'));
        return mesAplica;
    }set;}
    
    //Clase asociada al listado de tarifas
    public class WrappedTarifas{
        public TarifaOportunidad__c tarifaOportunidad {get;set;}
        public Tarifa__c tarifa {get;set;}
        
        public List<WrappedBonificaciones> bonificaciones{get;set;}
        public List<SelectOption> tarifas {get;set;}
        
        public Boolean esTarifaEscalonamiento{get;set;}
        public String tipoEscalonamiento{get;set;}
        public Boolean aplicaTarifa{get;set;}
        public Boolean tieneVariasTarifas{get;set;}
        public String importeInvalido{get;set;}
        
        public String tarifaSeleccionada;
        public void setTarifaSeleccionada(String tarifaSeleccionada){}
        public String getTarifaSeleccionada(){
            return this.tarifaSeleccionada;
        }
        
        public Double Precio {get{
            try{
                if(tarifaOportunidad.Porcentaje__c != 0){
                    return tarifa.Importe__c - ((tarifa.Importe__c*tarifaOportunidad.Porcentaje__c))/100;
                }else{
                    return tarifa.Importe__c;
                }
            }catch(Exception e){
                return tarifa.Importe__c;
            }
        }set;}
        
        //Constructor principal
        public WrappedTarifas(List<SelectOption> selectTarifas, Tarifa__c tar, TarifaOportunidad__c tarOpp, Boolean tieneVariasTarifas, Boolean aplicaTarifa, List<WrappedBonificaciones> bonificaciones){
            this.esTarifaEscalonamiento=false;
            this.tarifas = selectTarifas;
            this.tieneVariasTarifas=tieneVariasTarifas;
            this.tarifa=tar;
            this.tarifaOportunidad = tarOpp;
            this.tarifaSeleccionada = tarOpp.Tarifa__c;
            this.bonificaciones = bonificaciones;
            
            if(tarOpp.Id != null){
                this.aplicaTarifa = true;
            }else{
                this.aplicaTarifa = false;
            }
            
            if(tarifas.size()==1){
                tarifaSeleccionada = String.valueOf(this.tarifas[0].getValue());
            }
            
            if(this.tarifa != null){
                if(this.tarifa.TipoCargo__c.contains('monto')||this.tarifa.TipoCargo__c.contains('fecha')){
                    this.tipoEscalonamiento = this.tarifa.TipoCargo__C.contains('monto')?'monto':'fecha';
                    this.esTarifaEscalonamiento =true;
                }
            }
        }
        
        //Constructor auxiliar
        public WrappedTarifas(){}
    }
    
    //Clase asociada al listado de bonificaciones
    public class WrappedBonificaciones{
        public Id recordTypeBonificacion = [SELECT Id,SobjectType,Name From RecordType WHERE DeveloperName ='Bonificacion' and SobjectType ='BonificacionEscalonamiento__c' limit 1].Id;
        public Id recordTypeEscalonamiento = [SELECT Id,SobjectType,Name From RecordType WHERE DeveloperName ='Escalonamiento' and SobjectType ='BonificacionEscalonamiento__c' limit 1].Id;
        
        public BonificacionEscalonamiento__c bonificacion{get;set;}
        
        public Boolean checked{get;set;}
        public String nombreTarifa{get;set;}
        public String tipoEscalonamiento{get;set;}
        public String tarifaId{get;set;}
        
        //Constructor de bonificaciones
        public WrappedBonificaciones(String tarifaId,String nombreTarifa, BonificacionEscalonamiento__c bonificacion){
            this.checked = false;
            this.nombreTarifa = nombreTarifa;
            this.tarifaId = tarifaId;
            this.bonificacion = bonificacion;
            this.bonificacion.recordTypeId=recordTypeBonificacion;
        }
        
        //Constructor de escalonamientos
        public WrappedBonificaciones(BonificacionEscalonamiento__c escalonamiento, String tipoEscalonamiento){
            this.checked = false;
            if(escalonamiento.TarifaOportunidad__r.TipoCargo__C!=null){
                tipoEscalonamiento = escalonamiento.TarifaOportunidad__r.TipoCargo__C.contains('monto')?'monto':'fecha';
            }else{
                tipoEscalonamiento = tipoEscalonamiento.contains('monto')?'monto':'fecha';
            }
            this.bonificacion=escalonamiento;
            this.bonificacion.TipoEscalonamiento__c=tipoEscalonamiento;
            this.bonificacion.recordTypeId=recordTypeEscalonamiento;
        }
        
        //Constructor auxiliar
        public WrappedBonificaciones(){
            this.checked = false;
        }
    }
    
    //RJP
    public list<Tarifa__c> tarifasTotales {get;set;}
    public map<String,list<Tarifa__c>> mapClaveReferenciaTarifa {get;set;}
    public list<WrappedBonificaciones> bonificacionesAsociadas {get;set;}
    public list<TarifaOportunidad__c> tarifasOportunidadesExistentes  {get;set;}
    public map<String,TarifaOportunidad__c> mapTarifasOportunidadesExistentes {get;set;}
    public map<String,Tarifa__c> mapTarifas {get;set;}
    public map<String,list<WrappedBonificaciones>> mapTarifaBonificaciones {get;set;}
    public list<BonificacionEscalonamiento__c> bonificacionesEliminar{get;set;}
    public List<BonificacionEscalonamiento__c> setBonificacionesEliminar{get;set;}
    
    
    
    /** CONSTRUCTOR **/
    public TarifaOportunidadController(ApexPages.StandardController stdController){
        idOportunidad = System.currentPagereference().getParameters().get('id');
        muestraAnterior =String.valueOf(System.currentPagereference().getParameters().get('muestraAnterior'));
        
        //Instancias
        fechaActual=Date.today();
        esEnviado = false;
        sinTipoSolucion = true;
        subproductosSeleccionados = new list<String>();
        subproductos = new list<SelectOption>();
        producto = new Producto__c();
        tarifaOportunidadGlobal = new TarifaOportunidad__c();  
        bonificacion = new BonificacionEscalonamiento__c();
        bonificacionesEliminar = new list<BonificacionEscalonamiento__c>();
        setBonificacionesEliminar = new List<BonificacionEscalonamiento__c>();
        tarifaOportunidadAnteriores = new List<TarifaOportunidad__c>();
        bonificacionesAsociadas = new list<WrappedBonificaciones>();
        bonificacionesActuales = new list<WrappedBonificaciones>();
        escalonamientosActuales = new List<WrappedBonificaciones>();
        catalogoTarifas = new list<WrappedTarifas>();
        mapTarifaBonificaciones = new map<String,list<WrappedBonificaciones>>();
        mapTarifasOportunidadesExistentes = new map<String,TarifaOportunidad__c>();        
        tarifasOportunidadesExistentes=new List<TarifaOportunidad__c>();
        list<BonificacionEscalonamiento__c> listaBonificaciones = new list<BonificacionEscalonamiento__c> ();
        list<BonificacionEscalonamiento__c> listaEscalonamientos = new list<BonificacionEscalonamiento__c> ();
        
        List<SelectOption> tarifasBonificaciones = new list<SelectOption>();
        
        //Querys principales
        catalogoDescuentos = [SELECT Id, Name, AplicaTarifa__c , Clave__c , CodigoProducto__c FROM Descuento__c];
        try{
            oportunidad =  [SELECT Id, Name,VolumenComision__c,  Amount, ComisionEmision__c ,Familia__c, Producto__c, 
                            Producto__r.NumeroProducto__c , UsoProducto__c, TipoSolucion__c,ContratoTCM__c,ContratoTC3__c,
                            Producto__r.Name
                            FROM Opportunity 
                            WHERE Id =: idOportunidad LIMIT 1];
            if(oportunidad.Producto__r.Name!=null){
                productoSeleccionado = oportunidad.Producto__r.Name;
            }
            if(oportunidad.TipoSolucion__c!=null){
                tarifaOportunidadGlobal.TipoSolucion__c=oportunidad.TipoSolucion__c;
            }
            
        }catch(Exception e){
            System.debug('No existe oportunidad para: ' + idOportunidad);
        }
        try{
            contrato = [SELECT Id, Estatus__c FROM Contrato__c WHERE Oportunidad__c=: idOportunidad];
        }catch(Exception e){}
        
        if(contrato!= null && contrato.Estatus__c =='Enviado'){
            esEnviado = true;
        }
        
        verificaContratoExistente();
        if(productoSeleccionado!=null){
            obtenerDatosExistentes();
            buscar();
            obtenerBonficaciones();
        }
    }
    
    
    //CARGA LA PAGINA CON LOS DATOS RESCATADOS DE LAS TARIFAS EN TABLAS
    public void obtenerDatosExistentes(){
        if(oportunidad.Producto__c != null){
            
            obtenerTarifasExistentes();
            
            /*JPR : ESPECIAL: OPAM*/
            String[] listaSubproductos = null;
            
            //Llena la lista de selección de subproductos
            if(producto.Subproductos__c != null ){
                tieneSubproducto = true;
                String cadSubproductos = producto.Subproductos__c;
                cadSubproductos = cadSubproductos.toUpperCase();
                listaSubproductos = String.valueof(CadSubproductos).split(';');
                if(subproductos.size()==0){
                    for(String subproducto: listaSubproductos){
                        subproductos.add(new SelectOption( subproducto.capitalize() , subproducto));
                    }
                }
            }else{
                tieneSubproducto = false;
                subproductosSeleccionados =  new list<String>();
            }
            
            //Llena la cadena de subproductos seleccionados a partir del query
            if(tarifasOportunidadesExistentes.size() > 0){
                tarifaOportunidadGlobal.TipoSolucion__c = tarifasOportunidadesExistentes[0].TipoSolucion__c;
                if(tarifasOportunidadesExistentes[0].Subproductos__c != null){
                    subproductosSeleccionados = tarifasOportunidadesExistentes[0].Subproductos__c.split(',');
                    for(integer i=0; i<subproductosSeleccionados.size();i++){
                        subproductosSeleccionados[i]=subproductosSeleccionados[i].trim();
                    }
                }
            }
        }
    }
    
    public void obtenerTarifasExistentes(){
        try{//toma las tarifas guardadas en la oportunidad
            aplicaAnualidad = false;
            mapTarifasOportunidadesExistentes = new map<String,TarifaOportunidad__c>();        
            tarifasOportunidadesExistentes=new List<TarifaOportunidad__c>();
            
            tarifasOportunidadesExistentes = [SELECT Id,AplicaAniversario__c,Tarifa__r.Producto__c,Tarifa__r.Producto__r.Name , 
                                              MesQueAplica__c, AjusteInflacion__c, Name, Producto__c,Producto__r.Name,Producto__r.Id,
                                              Producto__r.Producto__c, Producto__r.NumeroProducto__c, ClaveReferencia__c, Importe__c, 
                                              Porcentaje__c, Observaciones__c,TipoCargo__c, TipoSolucion__c,Uso__c,Oportunidad__c,
                                              Tarifa__c, Subproductos__c, TipoTarifa__c , Tarifa__r.ClaveReferencia__c 
                                              FROM TarifaOportunidad__c  
                                              WHERE Oportunidad__c=:oportunidad.Id ];
            for(TarifaOportunidad__c tarifaOportunidad:tarifasOportunidadesExistentes){
                if(!mapTarifasOportunidadesExistentes.containsKey(tarifaOportunidad.Tarifa__c)){
                    mapTarifasOportunidadesExistentes.put(tarifaOportunidad.Tarifa__c,tarifaOportunidad);
                }
                if(tarifaOportunidad.ClaveReferencia__c == 'CA02'){
                    aplicaAnualidad = true;
                }
            }
        }catch(Exception e){}
    }
    
    public boolean bBuscar {get;set;}//Para campo: ¿aplicaTarifa?
    public void buscar(){
        tarifaOportunidadAnteriores= new List<TarifaOportunidad__c>();
        catalogoTarifas = new list<WrappedTarifas>();
        subproductos = new list<SelectOption>();
        tarifasTotales = new List<Tarifa__c>(); 
        mapTarifas = new map<String,Tarifa__c>();
        
        aplicaAnualidad=false;
        mapClaveReferenciaTarifa = new map<String,list<Tarifa__c>>();
        
        try{
            producto = [SELECT Id, Name, Uso__c, Producto__c,  Subproductos__c,NumeroProducto__c,FamiliaNecesidades__c, FamiliaCorporativa__c,FamiliaMX__c FROM Producto__c WHERE Name=:productoSeleccionado LIMIT 1];
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Ingresa un nombre para el producto a consultar válido.'));
            return;
        }
        
        getUsos();
        usoActual = oportunidad.UsoProducto__c;
        /*JPR : ESPECIAL: Para ticket car*/
        activarTipoSolucion();
        
        //Funciona para Productos Ticket Car. En los casos en que se guarda como Avanzado y luego se cambia a Básico. Se eliminan las tarifas que no aplican hasta que se dá click en guardar
        if(tarifaOportunidadGlobal.TipoSolucion__c=='Básico' && tarifasOportunidadesExistentes!=null){
            for(integer i=0; i< tarifasOportunidadesExistentes.size();i++){
                if( tarifasOportunidadesExistentes[i].ClaveReferencia__c.contains('CG01') || tarifasOportunidadesExistentes[i].ClaveReferencia__c=='CTB1' ){
                    tarifaOportunidadAnteriores.add(tarifasOportunidadesExistentes[i]);
                    tarifasOportunidadesExistentes.remove(i);
                    i=i-1;
                }
            }
        }
        
        /*JPR : ESPECIAL: OPAM*/
        String[] listaSubproductos = null;
        String cadSubproductos = '';
        if(producto.Subproductos__c != null){
            tieneSubproducto = true;
            
            cadSubproductos = producto.Subproductos__c;
            cadSubproductos = cadSubproductos.toUpperCase();
            listaSubproductos = String.valueof(cadSubproductos).split(';');
            for(String subproducto: listaSubproductos){
                subproductos.add(new SelectOption( subproducto.capitalize() , subproducto));
            }
        }else{
            tieneSubproducto = false;
            subproductosSeleccionados =  new list<String>();
        }
        
        //Si es producto OPAM, entonces tiene que haber subproductosSeleccionados
        if(subproductosSeleccionados.size() <= 0  && tieneSubproducto)
        { return; }
        
        /*FIN: OPAM*/
        
        
        try{
            if(!tieneSubproducto){
                tarifasTotales = [SELECT Id, Name, Producto__c,Producto__r.Name, Producto__r.NumeroProducto__c , ClaveReferencia__c, ClaveSubproducto__c , 
                                  CodigoProducto__c , Subproducto__c , Importe__c, Porcentaje__c,TipoCargo__c 
                                  FROM Tarifa__c WHERE Producto__c =: producto.Id];  
            }else{
                tarifasTotales = [SELECT Id, Name, Producto__c,Producto__r.Name, Producto__r.NumeroProducto__c , ClaveReferencia__c, ClaveSubproducto__c , 
                                  CodigoProducto__c , Subproducto__c , Importe__c, Porcentaje__c,TipoCargo__c 
                                  FROM Tarifa__c WHERE Producto__c =: producto.Id AND SubProducto__c IN : subproductosSeleccionados];  
            }              
        }catch(Exception e){
            System.debug('No se encontraron tarifas para: ' + productoSeleccionado + ',Error: ' + e.getMessage()+ e.getLineNumber() );
        }
        for(Tarifa__c tarifa:tarifasTotales){
            if(!mapTarifas.containsKey(tarifa.Id)){
                mapTarifas.put(tarifa.Id,tarifa);
            }
            if(!mapClaveReferenciaTarifa.containsKey(tarifa.ClaveReferencia__c)){
                mapClaveReferenciaTarifa.put(tarifa.ClaveReferencia__c,new list<Tarifa__c>());
            }
            mapClaveReferenciaTarifa.get(tarifa.ClaveReferencia__c).add(tarifa);
        }
        bBuscar = true;
        
        /*JPR : ESPECIAL: Para mostrar bonificaciones*/
        if(activaTipoSolucion && tarifaOportunidadGlobal.TipoSolucion__c == null ){
            sinTipoSolucion = false;
        }else{
            sinTipoSolucion = true;
        }
        
        configurarResultadoBusqueda();
        agregarTarifas();
        
        
        //Si el producto cambia o es OPAM, habilita por default todos los elementos de la lista 
        if(producto.Id!=oportunidad.Producto__c || tieneSubproducto){
            for(WrappedTarifas cat: catalogoTarifas){
                cat.aplicaTarifa=true;
            }
        }
        //Valida si aplica Anualidad
        for(WrappedTarifas cat: catalogoTarifas){
            if(cat.TarifaOportunidad.ClaveReferencia__c=='CA02'){
                if(cat.aplicaTarifa){
                    aplicaAnualidad=true;
                }else{
                    aplicaAnualidad=false;
                }
                break;
            }
        }
        llenarSeleccionTarifasBonificaciones();
    }
    
    
    public void configurarResultadoBusqueda(){
        set<String> setTarifaRenglonAgreada = new set<String>();
        set<String> setSubproductos = new set<String>();
        list<String> tiposTarifaCargo;
        list<SelectOption> selectTarifas = new List<SelectOption>();
        //Itera sobre todas las tarifas aplicables al producto seleccionado
        for(Tarifa__c tarifa: tarifasTotales){
            if(mapClaveReferenciaTarifa.containsKey(tarifa.ClaveReferencia__c) && !setTarifaRenglonAgreada.contains(tarifa.ClaveReferencia__c)){
                selectTarifas = new List<SelectOption>();
                tiposTarifaCargo = new list<String>();
                String tipoTarifa = '';
                TarifaOportunidad__c tarifaOportunidad = null;
                
                //Llena el select si Tarifa Base si hay más de una tarifa coincidente con la clave de referencia
                for(Tarifa__c tarifaRenglon : mapClaveReferenciaTarifa.get(tarifa.ClaveReferencia__c)){
                    String sImporte = (tarifaRenglon.Importe__c==null|| tarifaRenglon.Importe__c==0)? '':String.valueOf(tarifaRenglon.Importe__c);
                    
                    if(sImporte == ''){
                        selectTarifas.add(new SelectOption(String.valueOf(tarifaRenglon.Id) , String.valueOf(tarifaRenglon.TipoCargo__c)));
                    }else{
                        selectTarifas.add(new SelectOption(String.valueOf(tarifaRenglon.Id) , String.valueOf(tarifaRenglon.TipoCargo__c +'-' + sImporte)));
                    }
                    
                    tiposTarifaCargo.add(tarifaRenglon.TipoCargo__c);
                    //Si ya existe una tarifa de este tipo, se realiza la asignación
                    if(mapTarifasOportunidadesExistentes.containsKey(tarifaRenglon.Id)){
                        tarifaOportunidad = mapTarifasOportunidadesExistentes.get(tarifaRenglon.Id);
                    }
                }
                tipoTarifa = String.getCommonPrefix(tiposTarifaCargo);//Se define el nombre de la tarifa por elementos comunes
                tipoTarifa = tipoTarifa.replace('-', '');
                
                //Se instancian las tarifas que no fueron halladas en el query
                for(Tarifa__c tarifaRenglon : mapClaveReferenciaTarifa.get(tarifa.ClaveReferencia__c)){
                   
                    Tarifa__c primeraTarifaRenglon = obtenerTarifaReal(mapClaveReferenciaTarifa.get(tarifa.ClaveReferencia__c));
                    if(tarifaOportunidad == null){
                        tarifaOportunidad = new TarifaOportunidad__c();
                        tarifaOportunidad.Uso__c = usoActual;
                        tarifaOportunidad.Tarifa__c = primeraTarifaRenglon.Id;
                        tarifaOportunidad.TipoCargo__c= primeraTarifaRenglon.TipoCargo__c;
                        tarifaOportunidad.ClaveReferencia__c = primeraTarifaRenglon.ClaveReferencia__c;
                        tarifaOportunidad.Producto__c = primeraTarifaRenglon.Producto__c;
                        tarifaOportunidad.Importe__c = primeraTarifaRenglon.Importe__c;
                        tarifaOportunidad.Oportunidad__c = idOportunidad;
                        tarifaOportunidad.TipoTarifa__c = tipoTarifa;
                        tarifaOportunidad.Porcentaje__c = 0.0;
                    }
                    
                    if(tarifaOportunidad.TipoTarifa__c != null){
                        /*JPR : ESPECIAL: Para los escalonamientos*/
                        if(tarifaOportunidad.ClaveReferencia__c == 'CO01'){
                            tarifaOportunidad.TipoTarifa__c = 'Comisión de servicios';
                        }
                        if(tarifaOportunidad.ClaveReferencia__c == 'CA02'){
                            aplicaAnualidad = true;
                            if(tarifaOportunidad.id != null){
                                aplicaAniversario=tarifaOportunidad.AplicaAniversario__c;
                                mesSeleccionado = tarifaOportunidad.MesQueAplica__c ;
                            }
                        }
                    }else{tarifaOportunidad.TipoTarifa__c='<Sin clave de Referencia>';}
                    
                    /*JPR : ESPECIAL:*/
                    //Se llena el catálogo de la lista
                    tarifaOportunidad.TipoSolucion__c = tarifaOportunidadGlobal.TipoSolucion__c;
                    if(tarifaOportunidad.TipoSolucion__c == 'Básico'){
                        if(tarifaOportunidad.ClaveReferencia__c!='CG01' && tarifaOportunidad.ClaveReferencia__c!='CTB1'){
                            catalogoTarifas.add(new WrappedTarifas(selectTarifas, primeraTarifaRenglon, tarifaOportunidad, true, bBuscar, bonificacionesAsociadas) );
                        }
                    }else{
                        //Aplica para OPAM. Se quitan las bonificaciones de los subproductos 60 y 52
                        if(tieneSubproducto && (producto.NumeroProducto__c==60 || producto.NumeroProducto__c==52)){
                            if(tarifaOportunidad.ClaveReferencia__c!='GSDBO130' &&tarifaOportunidad.ClaveReferencia__c!='GLPBO130' &&
                               tarifaOportunidad.ClaveReferencia__c!='GSMBO130' &&tarifaOportunidad.ClaveReferencia__c!='GCPBO130' &&
                               tarifaOportunidad.ClaveReferencia__c!='DS0BO130' &&tarifaOportunidad.ClaveReferencia__c!='DSHBO130'){
                                   catalogoTarifas.add(new WrappedTarifas(selectTarifas, primeraTarifaRenglon, tarifaOportunidad, true, bBuscar, bonificacionesAsociadas) );
                               }
                        }else{
                            //Si no corresponden a los productos 60 & 52, se obtienen todas las tarifas OPAM del catálogo
                            catalogoTarifas.add(new WrappedTarifas(selectTarifas, primeraTarifaRenglon, tarifaOportunidad, true, bBuscar, bonificacionesAsociadas) );
                        }
                    }
                    /**/
                    
                    setTarifaRenglonAgreada.add(primeraTarifaRenglon.ClaveReferencia__c);
                    break;
                }
            }
        }
        bBuscar = false;
    }
    public Tarifa__c obtenerTarifaReal(List<Tarifa__c> tarifas){
        for(Tarifa__c tarifa : tarifas){
            if(mapTarifasOportunidadesExistentes.containsKey(tarifa.Id)){
                return tarifa;
            }
        }
        return tarifas[0];
    }
    
    
    public void guardar(){
        Boolean aplicaEscalonamiento = false;
        Boolean importesInvalidos = false;
        String tipoError='';
         tarifasOportunidades = new List<TarifaOportunidad__c>();
        List<BonificacionEscalonamiento__c> bonificacionesEscalonamientos = new List<BonificacionEscalonamiento__c>();
        List<BonificacionEscalonamiento__c> bonificacionAnteriores= new List<BonificacionEscalonamiento__c>();
        
        /** VALIDACIONES DE LLENADO **/
        if(catalogoTarifas.size() < 1){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes ingresar un producto y obtener sus precios para poder guardar sus tarifa' ));
            return;
        }
        if(activaTipoSolucion && tarifaOportunidadGlobal.TipoSolucion__c == null){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes seleccionar un tipo de solución.' ));
            return;
        }
        //Aplica para escalonamiento
        for(WrappedTarifas wrapTarifa: catalogoTarifas){
            if(wrapTarifa.aplicaTarifa){
                if(wrapTarifa.esTarifaEscalonamiento){
                    aplicaEscalonamiento = true;
                    break;
                }
            }
        }
        if(aplicaEscalonamiento){
            if(EscalonamientosActuales.size()==0){
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Se debe ingresar al menos un escalonamiento.' ));
                return;
            }
        }
        /* FIN DE VALIDACIONES DE LLENADO*/
        if(tarifaOportunidadAnteriores.size()>0){//Viene de las tarifas que se borran al cambiar de avanzado a Básico para productos TicketCar
                if( !eliminaAnteriores()){
                    return;
                }
        }
        
        try{/* APLICA CUANDO SE CAMBIA EL PRODUCTO */
            if(producto.Id!=oportunidad.Producto__c){
                for(TarifaOportunidad__c tarOpp: tarifasOportunidadesExistentes){
                    tarifaOportunidadAnteriores.add(tarOpp);
                }
                if( !eliminaAnteriores()){
                    return;
                }
            }
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al cambiar el producto: '+ e.getMessage()+e.getLineNumber() ));
            Return;
        }
        
        try{
            //Itera sobre la lista actual para guardar las tarifas que aplican
            for(WrappedTarifas wrapTarifa: catalogoTarifas){
                if(wrapTarifa.aplicaTarifa){
                    wrapTarifa.importeInvalido = '';
                    /*APLICA PARA OPAM, VALIDACION ESPECIAL DE IMPORTES*/
                    if(!tieneSubproducto && wrapTarifa.tarifaOportunidad.Importe__c<wrapTarifa.tarifa.Importe__c){
                        importesInvalidos=true;
                        wrapTarifa.importeInvalido='has-error';
                        tipoError='Los importes aplicables deben ser mayores o iguales a la tarifa Base';
                    }
                     /*
                    if(producto.NumeroProducto__c == 60 && wrapTarifa.Precio<30){
                        importesInvalidos = true;
                        wrapTarifa.importeInvalido = 'has-error';
                        tipoError = 'Los importes aplicables deben ser mayores a 30';
                    }
                    if(producto.NumeroProducto__c== 52 && wrapTarifa.Precio<30 && wrapTarifa.tarifa.Importe__c>30){
                        importesInvalidos = true;
                        wrapTarifa.importeInvalido = 'has-error';
                        tipoError = 'Los importes aplicables deben ser mayores a 30';
                    }
                    /****/
                    
                    /*RJP : CASO ESPECIAL*/
                    //Asignación de campos de anualidad, si es que aplica
                    if(wrapTarifa.tarifaOportunidad.ClaveReferencia__c=='CA02'){
                        wrapTarifa.tarifaOportunidad.AplicaAniversario__c = aplicaAniversario;
                        wrapTarifa.tarifaOportunidad.MesQueAplica__c = mesSeleccionado; 
                    }
                    
                    //OPAM, inserta la cadena de referencia hacia los subproductos
                    if(subproductosSeleccionados != null && subproductosSeleccionados.size() > 0){
                        String subproductos = String.valueOf(subproductosSeleccionados);
                        subproductos = subproductos.replace('(','');
                        subproductos = subproductos.replace(')','');
                        wrapTarifa.tarifaOportunidad.Subproductos__c = subproductos;
                    }
                    //Se agrega a la lista que se va a insertar
                    if(tieneSubproducto)
                        wrapTarifa.tarifaOportunidad.importe__c = wrapTarifa.precio!= null ?wrapTarifa.precio:0.0;
                    tarifasOportunidades.add(wrapTarifa.tarifaOportunidad);
                }else{
                    if(mapTarifasOportunidadesExistentes.containsKey(wrapTarifa.tarifa.Id) && wrapTarifa.tarifaOportunidad.Id!=null){
                        tarifaOportunidadAnteriores.add(mapTarifasOportunidadesExistentes.get(wrapTarifa.tarifa.Id));
                    }
                }
            }
            if(importesInvalidos){
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, tipoError ));
                return;
            }
            if(tarifaOportunidadAnteriores.size()>0){
                if( !eliminaAnteriores()){
                    return;
                }
            }
            
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al llenar el listado de tarifas: '+ e.getMessage()+e.getLineNumber() ));
            Return;
        }
        
        try{/* SE ACTUALIZA OPORTUNIDAD */
            system.debug('TARIFAS A INSERTAR');
            for(tarifaOportunidad__c tarOpp: tarifasOportunidades){
                system.debug(tarOpp);
            }
            upsert tarifasOportunidades;
            //PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR,tarifasOportunidades.SIZE()+ 'tARIFAS INSERTADAS'));
            //return;
            
            if(!guardarBonificaciones()){
                return;
            }            
            if(!guardarEscalonamientos()){
                return;
            }
            
            
            
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al guardar: '+ e.getMessage()+e.getLineNumber() ));
            Return;
        }
        
        try{//ELIMINA PRODUCTOS OPAM, CUANDO SE SELECCIONAN MENOS SUBPRODUCTOS DE LOS QUE ORIGINALMENTE SE GUARDARON
            list<Id> IdTarifas = new list<Id>();
            if(tarifasOportunidades.size()>0){
                for(tarifaOportunidad__c tar: tarifasOportunidades){
                    IdTarifas.add(tar.Id);
                }
            }
            list<TarifaOportunidad__c> tarifasExtras = [SELECT Id,AplicaAniversario__c,Tarifa__r.Producto__c,Tarifa__r.Producto__r.Name , 
                                                                        MesQueAplica__c, AjusteInflacion__c, Name, Producto__c,Producto__r.Name,Producto__r.Id,
                                                                        Producto__r.Producto__c, Producto__r.NumeroProducto__c, ClaveReferencia__c, Importe__c, 
                                                                        Porcentaje__c, Observaciones__c,TipoCargo__c, TipoSolucion__c,Uso__c,Oportunidad__c,
                                                                        Tarifa__c, Subproductos__c, TipoTarifa__c , Tarifa__r.ClaveReferencia__c 
                                                                        FROM TarifaOportunidad__c  
                                                                        WHERE Oportunidad__c=:oportunidad.Id 
                                                                        AND Id NOT IN : IdTarifas ];
            if(tarifasExtras.size()>0){
                for(tarifaOportunidad__c tarOppExtras: tarifasExtras){
                    tarifaOportunidadAnteriores.add(tarOppExtras);
                }
                if( !eliminaAnteriores()){
                    return;
                }
            }
            
        }catch(Exception e){
            
        }
        obtenerTarifasExistentes();
        obtenerBonficaciones();
        
        try{/* ACTUALIZA LA OPORTUNIDAD */
            oportunidad.Producto__c = producto.Id;
            oportunidad.UsoProducto__c = usoActual;
            oportunidad.Familia__c = producto.FamiliaNecesidades__c;
            if(tarifaOportunidadGlobal.TipoSolucion__c!=null){
                oportunidad.TipoSolucion__c=tarifaOportunidadGlobal.TipoSolucion__c;
            }
            upsert oportunidad;
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error actualizando oportunidad:' + e.getMessage()));
            return;
        }
        
        PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'Se ha actualizado el producto y las tarifas de la oportunidad' ));
        guardo = true;
    }
    
    public boolean eliminaAnteriores(){
        try{//Elimina las bonificaciones antes, y después las tarifas
            bonificacionesEliminar=new List<BonificacionEscalonamiento__c>();
            if(tarifaOportunidadAnteriores.size() > 0){
                for(tarifaOportunidad__c tarOpp: tarifaOportunidadAnteriores){
                    
                    //Limpia el Id si se encuentra en el catálogo de la lista para que se inserte
                    for(WrappedTarifas wpTar: catalogoTarifas){
                        if(wpTar.TarifaOportunidad.Id!=null){
                            if(wpTar.TarifaOportunidad.Id==tarOpp.Id){
                                wpTar.TarifaOportunidad=wpTar.TarifaOportunidad.clone();
                                break;
                            }
                        }
                    }
                    
                    //Se borran las bonificaciones asociadas
                    for(integer i=0; i<bonificacionesActuales.size();i++){
                        if(String.valueOf(bonificacionesActuales[i].bonificacion.TarifaOportunidad__c)==String.valueOf(tarOpp.Id) && bonificacionesActuales[i].bonificacion.id!=null){
                            bonificacionesEliminar.add(bonificacionesActuales[i].bonificacion);
                            bonificacionesActuales.remove(i);
                            i=i-1;
                        }
                    }
                    
                    
                    //Borra del listado de tarifas existentes
                    for(integer i=0;i<tarifasOportunidadesExistentes.size();i++){
                        if(tarOpp.Id==tarifasOportunidadesExistentes[i].id){
                            tarifasOportunidadesExistentes.remove(i);
                            break;
                        }
                    }
                }
                if(bonificacionesEliminar.size()>0){
                    delete bonificacionesEliminar;
                    bonificacionesEliminar= new List<BonificacionEscalonamiento__c>();
                }
                
                delete tarifaOportunidadAnteriores;
                tarifaOportunidadAnteriores= new List<TarifaOportunidad__c>();
            }
            system.debug('Tarifas Existentes después de borrar::');
            for(integer i=0;i<tarifasOportunidadesExistentes.size();i++){
                system.debug(tarifasOportunidadesExistentes[i]);
            }
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al eliminar tarifas anteriores'+e.getMessage()+' ,en la linea:'+e.getLineNumber()+' el tamaño de lo que queria borrar es :'+tarifaOportunidadAnteriores.size()+' identificador:'+ tarifaOportunidadAnteriores[0].id));
            return false;
        }
        return true;
    }
    
    public void verificaContratoExistente(){
        if(oportunidad.ContratoTCM__c == null && oportunidad.ContratoTC3__c == null){
            esNuevo = true;
        }else{
            if(esEnviado){
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.INFO, 'La oportunidad ya fué enviada, no se permite modificar sus tarifas' ));
                return;
            }
            
            esNuevo = false;
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.INFO, 'La oportunidad ya tiene un contrato generado. No se pueden modificar las características del producto' ));
        }
    }
    
    public void agregarTarifas(){
        String idTarifa = System.currentPagereference().getParameters().get('tarifaId');
        String sIndex = System.currentPagereference().getParameters().get('index');
        Integer index = sIndex != null ?   Integer.valueOf(sIndex) : 0;
        
        if(idTarifa != null){
            if(mapTarifas.containsKey(idTarifa)){
                catalogoTarifas.get(index).tarifa = mapTarifas.get(idTarifa);
                catalogoTarifas.get(index).tarifaOportunidad.Importe__c = mapTarifas.get(idTarifa).Importe__c;
                catalogoTarifas.get(index).tarifaOportunidad.Tarifa__c = mapTarifas.get(idTarifa).Id;
                catalogoTarifas.get(index).tarifaSeleccionada = mapTarifas.get(idTarifa).Id;
                catalogoTarifas.get(index).Precio = mapTarifas.get(idTarifa).Importe__c;
                catalogoTarifas.get(index).tarifaOportunidad.TipoCargo__c =  mapTarifas.get(idTarifa).TipoCargo__c;
                /*RJP : CASO ESPECIAL*/
                if(catalogoTarifas.get(index).tarifaOportunidad.ClaveReferencia__c != null){
                    if(catalogoTarifas.get(index).tarifaOportunidad.ClaveReferencia__c == 'CA02'){ 
                        if( catalogoTarifas.get(index).aplicaTarifa){
                            aplicaAnualidad = true;
                            aplicaAniversario=catalogoTarifas.get(index).tarifaOportunidad.AplicaAniversario__c;
                            mesSeleccionado = catalogoTarifas.get(index).tarifaOportunidad.MesQueAplica__c ;
                        }else{
                            aplicaAnualidad = false;
                        }
                    }
                }
                
                if(catalogoTarifas.get(index).aplicaTarifa){
                    if(catalogoTarifas.get(index).tarifaOportunidad.TipoCargo__c.contains('monto')||catalogoTarifas.get(index).tarifaOportunidad.TipoCargo__c.contains('fecha')){
                        catalogoTarifas.get(index).tipoEscalonamiento = catalogoTarifas.get(index).tarifaOportunidad.TipoCargo__C.contains('monto')?'monto':'fecha';
                        catalogoTarifas.get(index).esTarifaEscalonamiento = true;
                        if(escalonamientosActuales.size()!= 0){
                            if(catalogoTarifas.get(index).tarifaOportunidad.TipoCargo__c.contains('monto') != escalonamientosActuales[0].bonificacion.TipoEscalonamiento__c.contains('monto')){
                                
                                escalonamientosActuales = new list<WrappedBonificaciones>();
                            }
                        }
                    }else{
                        catalogoTarifas.get(index).esTarifaEscalonamiento = false; 
                        if(escalonamientosActuales.size()>0){
                            for(Integer indice=0;indice<escalonamientosActuales.size();indice++){
                                if(escalonamientosActuales[indice].bonificacion.Id!=null){
                                    setBonificacionesEliminar.add(escalonamientosActuales[indice].bonificacion);
                                    escalonamientosActuales.remove(indice);
                                    indice=indice-1;
                                }
                            }
                        }
                                escalonamientosActuales = new list<WrappedBonificaciones>();
                    }
                }
            }
            llenarSeleccionTarifasBonificaciones();
        }else{
            if(tarifasBonificaciones!=null){
                tarifasBonificaciones= new List<SelectOption>();
                //aplicaAnualidad= false;
                
                tarifasBonificaciones.add( new SelectOption('','--Selecciona una tarifa--'));
                for(WrappedTarifas tar: catalogoTarifas){
                    if(tar.aplicaTarifa==true){
                        tarifasBonificaciones.add(new SelectOption(String.valueOf(tar.tarifaOportunidad.Tarifa__c) , String.valueOf(tar.tarifaOportunidad.TipoTarifa__c)));
                        if(String.valueOf(tar.tarifaOportunidad.ClaveReferencia__c).contains('CA02')){ 
                            aplicaAnualidad=true;
                        }
                    }
                }
                
                tarifaBonificacion=null;
                
                tarifaActual = new WrappedTarifas(); 
            }
            
            
        }
        tarifaActual = new WrappedTarifas(); 
        tarifaBonificacion=null;
        llenarSeleccionTarifasBonificaciones();
        
    }
    
    /*BONIFICACIONES*/
    
    public void llenarSeleccionTarifasBonificaciones(){
        tarifasBonificaciones = new list<SelectOption>();
        tarifasBonificaciones.add( new SelectOption('','--Selecciona una tarifa--'));
        for(WrappedTarifas tar: catalogoTarifas){
            if(tar.aplicaTarifa == true){
                tarifasBonificaciones.add(new SelectOption(String.valueOf(tar.tarifaOportunidad.Tarifa__c) , String.valueOf(tar.tarifaOportunidad.TipoTarifa__c)));
            }
        }
        
    }
    
    public void seleccionarTarifa(){
        try{
            for(WrappedTarifas tarifaWrap: catalogoTarifas){
                if(tarifaWrap.tarifaOportunidad.Tarifa__c == tarifaBonificacion){
                    tarifaActual = tarifaWrap;
                    break;
                }
            }
            bonificacion = new BonificacionEscalonamiento__C();
        }catch(Exception e){}
    }
    
    public Id devuelveIdentificadorTarifa(String name){
        for(TarifaOportunidad__C tarifaActualFOR: tarifasOportunidades){
            if(tarifaActualFOR.TipoTarifa__c == name){
                return tarifaActualFOR.Id;
            }
        }
        return null;
    }
    public boolean guardarBonificaciones(){
        set<String> identificadoresBonificacion = new Set<String>();
        setBonificacionesEliminar=new List<BonificacionEscalonamiento__c>();
       
        list<BonificacionEscalonamiento__c> bonificaciones = new list<BonificacionEscalonamiento__c> ();
        for(WrappedBonificaciones ba : bonificacionesActuales){
            ba.bonificacion.TarifaOportunidad__c = devuelveIdentificadorTarifa(ba.nombreTarifa);
            bonificaciones.add(ba.bonificacion);
            
            if(ba.bonificacion.Id!=null)
                identificadoresBonificacion.add(ba.bonificacion.Id);
            
        }
         try{
            setBonificacionesEliminar= [SELECT Id, Name, Descuento__c, TarifaOportunidad__c, TipoEscalonamiento__c FROM BonificacionEscalonamiento__c WHERE TarifaOportunidad__r.Oportunidad__r.Id=:idOportunidad AND RecordType.DeveloperName ='Bonificacion' AND Id NOT IN: identificadoresBonificacion];
        }catch(Exception e){
            setBonificacionesEliminar=new List<BonificacionEscalonamiento__c>();
        }
        try{
            if(setBonificacionesEliminar.size()>0)
                delete setBonificacionesEliminar;
            if(bonificaciones.size()>=1){
              //  PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Bonificaciones insertadas : '+bonificaciones.size()+' de '+bonificacionesActuales.size()+' actuales identificador del id='+bonificaciones[0].id+' tarifaOportunidadRelacionada:'+bonificaciones[0].tarifaOportunidad__c));
                upsert bonificaciones;
            }
            //delete setBonificacionesEliminar;
            setBonificacionesEliminar = new List<BonificacionEscalonamiento__c>();
        }catch(Exception e){
            System.debug('Error Bonificacion :'+e.getMessage()+' en la Linea :'+e.getLineNumber());
             PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error Bonificacion :'+e.getMessage()+' en la Linea :'+e.getLineNumber() ));
            return false;
        }
        
        bonificacionesActuales = new list<WrappedBonificaciones>();
        return true;
    }
    
    public boolean guardarEscalonamientos(){
        
        list<BonificacionEscalonamiento__c> escalonamientos = new list<BonificacionEscalonamiento__c> ();
        if(escalonamientosActuales.size()>0){
            //Agrega los escalonamientos
            for(WrappedBonificaciones ba : escalonamientosActuales){
                ba.bonificacion.TarifaOportunidad__c = devuelveIdentificadorTarifa('Comisión de servicios');    
                escalonamientos.add(ba.bonificacion);
            }
        }
        // Si un escalonamiento es de un tipo diferente al que se ha generado, se elimina
        try{
            set<String> identificadoresEscalonamiento = new Set<String>();
            for(BonificacionEscalonamiento__c auxiliarBonificacion:escalonamientos){
                if(auxiliarBonificacion.Id!=null)
                identificadoresEscalonamiento.add(auxiliarBonificacion.Id);
            }
            List<BonificacionEscalonamiento__c> escalonamientosAnteriores;
            try{
                escalonamientosAnteriores= [SELECT Id, Name, Descuento__c, TarifaOportunidad__c, TipoEscalonamiento__c FROM BonificacionEscalonamiento__c WHERE TarifaOportunidad__r.Oportunidad__r.Id=:idOportunidad AND RecordType.DeveloperName ='Escalonamiento' AND Id NOT IN: identificadoresEscalonamiento];
            }catch(Exception e){
                escalonamientosAnteriores=new List<BonificacionEscalonamiento__c>();
            }
            if(escalonamientosAnteriores.size()>0){
                delete escalonamientosAnteriores;
                escalonamientosAnteriores= new List<BonificacionEscalonamiento__c>();
            }
        }catch(Exception e ){}
        
        try{
            if(escalonamientos.size()>0){
                upsert escalonamientos;
            }
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage()+' en la linea:'+e.getLineNumber() ));
                return false;
        }
        escalonamientosActuales = new list<WrappedBonificaciones>();
        return true;
    }
    
    public void obtenerBonficaciones(){
        mapTarifaBonificaciones = new map<String,list<WrappedBonificaciones>>();
        list<BonificacionEscalonamiento__c> listaBonificaciones = new list<BonificacionEscalonamiento__c> ();
        list<BonificacionEscalonamiento__c> listaEscalonamientos = new list<BonificacionEscalonamiento__c> ();
        try{
            listaBonificaciones = [SELECT Id, Name, TarifaOportunidad__r.Tarifa__c,  ValorPorcentual__c, Descuento__c , TipoEscalonamiento__c, MontoInicial__c, MontoFinal__c, FechaInicio__c, FechaFinal__c, 
                                   TarifaOportunidad__c, recordType.Name,RecordType.DeveloperName,TarifaOportunidad__r.ClaveReferencia__c,TarifaOportunidad__r.TipoTarifa__c
                                   FROM BonificacionEscalonamiento__c 
                                   WHERE TarifaOportunidad__r.Oportunidad__c =: idOportunidad
                                   AND RecordType.DeveloperName =: 'Bonificacion'];
            listaEscalonamientos = [SELECT Id, Name, TarifaOportunidad__r.Tarifa__c,  ValorPorcentual__c, Descuento__c , TipoEscalonamiento__c, MontoInicial__c, MontoFinal__c, FechaInicio__c, FechaFinal__c, 
                                    TarifaOportunidad__c, recordType.Name,RecordType.DeveloperName,TarifaOportunidad__r.ClaveReferencia__c,TarifaOportunidad__r.TipoTarifa__c
                                    FROM BonificacionEscalonamiento__c 
                                    WHERE TarifaOportunidad__r.Oportunidad__c =: idOportunidad
                                    AND RecordType.DeveloperName =: 'Escalonamiento'];
        }catch(Exception e){
            
        }
        for(BonificacionEscalonamiento__c bonificacion: listaBonificaciones){
            if(!mapTarifaBonificaciones.containsKey(bonificacion.TarifaOportunidad__r.Tarifa__c)){
                mapTarifaBonificaciones.put(bonificacion.TarifaOportunidad__r.Tarifa__c,new list<WrappedBonificaciones>());
            }
            WrappedBonificaciones wrappedBonificacion = new WrappedBonificaciones();
            wrappedBonificacion.bonificacion = bonificacion;
            wrappedBonificacion.nombreTarifa = bonificacion.TarifaOportunidad__r.TipoTarifa__c;
            wrappedBonificacion.tarifaId = bonificacion.TarifaOportunidad__r.Tarifa__c;
            mapTarifaBonificaciones.get(bonificacion.TarifaOportunidad__r.Tarifa__c).add(wrappedBonificacion);
            bonificacionesActuales.add(wrappedBonificacion);
        }
        for(BonificacionEscalonamiento__c escalonamiento: listaEscalonamientos){
            if(!mapTarifaBonificaciones.containsKey(escalonamiento.TarifaOportunidad__r.Tarifa__c)){
                mapTarifaBonificaciones.put(escalonamiento.TarifaOportunidad__r.Tarifa__c,new list<WrappedBonificaciones>());
            }
            WrappedBonificaciones wrappedEscalonamiento = new WrappedBonificaciones();
            wrappedEscalonamiento.bonificacion = escalonamiento;
            mapTarifaBonificaciones.get(escalonamiento.TarifaOportunidad__r.Tarifa__c).add(wrappedEscalonamiento);
            escalonamientosActuales.add(wrappedEscalonamiento);
        }
    }
    
    
    public void agregarBonificaciones(){
        if(tarifaActual == null){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes seleccionar una tarifa' ));
            return;
        }
        if(bonificacion.ValorPorcentual__c<=0){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'El valor porcentual debe ser mayor a cero' ));
            return;
        }
        if((bonificacion.ValorPorcentual__c ==null || bonificacion.FechaInicio__c==null || bonificacion.FechaFinal__c == null)  && tarifaActual.tarifaOportunidad.ClaveReferencia__c!='CA04'){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes ingresar el periodo en que aplica la bonificación y su porcentaje' ));
            return;
        }
        if(bonificacion.ValorPorcentual__c ==null  && tarifaActual.tarifaOportunidad.ClaveReferencia__c=='CA04'){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes ingresar el porcentaje de la bonificación' ));
            return;
        }
        for(WrappedBonificaciones boni: bonificacionesActuales){
            if(boni.nombreTarifa == tarifaActual.tarifaOportunidad.TipoTarifa__c){
                if( 
                    (bonificacion.FechaInicio__c >=boni.bonificacion.FechaInicio__c &&bonificacion.FechaInicio__c <=boni.bonificacion.FechaFinal__c)
                    ||(bonificacion.FechaFinal__c >=boni.bonificacion.FechaInicio__c &&bonificacion.FechaFinal__c <=boni.bonificacion.FechaFinal__c) 
                    ||(boni.bonificacion.FechaInicio__c >=bonificacion.FechaInicio__c &&boni.bonificacion.FechaInicio__c <=bonificacion.FechaFinal__c)
                    ||(boni.bonificacion.FechaFinal__c >=bonificacion.FechaInicio__c &&boni.bonificacion.FechaFinal__c <=bonificacion.FechaFinal__c) 
                    ||(bonificacion.FechaFinal__c ==boni.bonificacion.FechaInicio__c &&bonificacion.FechaFinal__c ==boni.bonificacion.FechaFinal__c) 
                ){
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'No se permite traslapar fechas' ));
                    return;
                }
                if(tarifaActual.tarifaOportunidad.ClaveReferencia__c=='CA04' && bonificacion.ValorPorcentual__c==boni.bonificacion.ValorPorcentual__c){
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'No se permite ingresar bonificación duplicada' ));
                    return;
                }
            }
        }
        for(Descuento__c descuento: catalogoDescuentos){
            if(descuento.AplicaTarifa__c == tarifaActual.tarifaOportunidad.ClaveReferencia__c && descuento.CodigoProducto__c == String.ValueOf(tarifaActual.tarifaOportunidad.Producto__r.NumeroProducto__c)){
                bonificacion.Descuento__c = descuento.Id;
                break;
            }
        }
        
        if(tarifaActual.tarifaOportunidad != null){
            bonificacion.TarifaOportunidad__c = tarifaActual.tarifaOportunidad.Id;
        }
        //tarifaActual.bonificaciones.add(new WrappedBonificaciones(tarifaActual.tarifaOportunidad.TipoTarifa__c, bonificacion));
        if(!mapTarifaBonificaciones.containsKey(tarifaActual.tarifaOportunidad.Tarifa__c)){
            mapTarifaBonificaciones.put(tarifaActual.tarifaOportunidad.Tarifa__c, new list<WrappedBonificaciones>());
        }
        try{
            WrappedBonificaciones wrappedBonificacion = new WrappedBonificaciones(tarifaActual.tarifa.Id,tarifaActual.tarifaOportunidad.TipoTarifa__c,bonificacion);
            mapTarifaBonificaciones.get(tarifaActual.tarifaOportunidad.Tarifa__c).add(wrappedBonificacion);
            bonificacionesActuales.add(wrappedBonificacion);
            bonificacion = new BonificacionEscalonamiento__c();
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Se debe seleccionar una tarifa' ));
            return;
        }
    }
    
    public void borrarBonificacion(){
        for(integer i = 0 ; i < bonificacionesActuales.size(); i++){
            if(bonificacionesActuales[i].checked){
                if(bonificacionesActuales[i].bonificacion.Id != null){
                    setBonificacionesEliminar.add(bonificacionesActuales[i].bonificacion);
                }
                bonificacionesActuales.remove(i);
                i=i-1;
            }
        }
    }
    
    
    public void agregarEscalonamientos(){
        if(bonificacion.ValorPorcentual__c<=0){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'El valor porcentual debe ser mayor a cero' ));
            return;
        }
        if(bonificacion.ValorPorcentual__c ==null || bonificacion.FechaInicio__c==null || bonificacion.FechaFinal__c == null){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Debes ingresar el periodo en que aplica el escalonamiento y su porcentaje' ));
            return;
        }
        for(WrappedBonificaciones esc: escalonamientosActuales){
            if( 
                (bonificacion.FechaInicio__c >=esc.bonificacion.FechaInicio__c &&bonificacion.FechaInicio__c <=esc.bonificacion.FechaFinal__c)
                ||(bonificacion.FechaFinal__c >=esc.bonificacion.FechaInicio__c &&bonificacion.FechaFinal__c <=esc.bonificacion.FechaFinal__c) 
                ||(esc.bonificacion.FechaInicio__c >=bonificacion.FechaInicio__c &&esc.bonificacion.FechaInicio__c <=bonificacion.FechaFinal__c)
                ||(esc.bonificacion.FechaFinal__c >=bonificacion.FechaInicio__c &&esc.bonificacion.FechaFinal__c <=bonificacion.FechaFinal__c) 
                ||(bonificacion.FechaFinal__c ==esc.bonificacion.FechaInicio__c &&bonificacion.FechaFinal__c ==esc.bonificacion.FechaFinal__c) 
            ){
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'No se permite traslapar fechas' ));
                return;
            }
            if(tarifaActual.tarifaOportunidad.ClaveReferencia__c=='CA04' && bonificacion.ValorPorcentual__c==esc.bonificacion.ValorPorcentual__c){
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'No se permite ingresar bonificación duplicada' ));
                return;
            }
        }
        
        if(!mapTarifaBonificaciones.containsKey(tarifaActual.tarifaOportunidad.Tarifa__c)){
            mapTarifaBonificaciones.put(tarifaActual.tarifaOportunidad.Tarifa__c, new list<WrappedBonificaciones>());
        }
        
        WrappedBonificaciones wrappedEscalonamiento = new WrappedBonificaciones(bonificacion, tarifaActual.tipoEscalonamiento); 
        wrappedEscalonamiento.tarifaId = tarifaActual.tarifa.Id;   
        escalonamientosActuales.add(wrappedEscalonamiento);
        mapTarifaBonificaciones.get(tarifaActual.tarifaOportunidad.Tarifa__c).add(wrappedEscalonamiento);
        //bonificacion.TarifaOportunidad__c = tarifaActual.tarifaOportunidad.Id;
        bonificacion = new BonificacionEscalonamiento__c();
    }
    
    public void borrarEscalonamiento(){
        for(integer i = 0 ; i < escalonamientosActuales.size(); i++){
            if(escalonamientosActuales[i].checked){
                if(escalonamientosActuales[i].bonificacion.Id != null){
                    setBonificacionesEliminar.add(escalonamientosActuales[i].bonificacion);
                }
                escalonamientosActuales.remove(i);
                i=i-1;
            }
        }
    }
    
    
    
    public List<SelectOption> getUsos(){
        usos = new List<SelectOption>();
        String[] opc = String.valueof(producto.Uso__c).split(';');
        for(String str: opc){
            usos.add(new SelectOption(str, str));
        }
        if(usos.size()>1){ 
            desactivaUso=false; 
        }else{ 
            desactivaUso=true;
        }
        
        if(usos.size()==1){ 
            usoActual = String.valueOf(usos[0].getValue()); 
        }
        return usos;
    }
    
    public void activarTipoSolucion(){
        
        if(String.valueof(producto.Name).contains('Ticket Car')){
            activaTipoSolucion = true;
        }else{
            tarifaOportunidadGlobal.TipoSolucion__c = null;
            activaTipoSolucion = false;
        }
    }
    
    
    @RemoteAction
    public static List<Producto__c> buscaProducto(String searchProd){
        List<Producto__c> catalogoProductos;
        try{
            catalogoProductos = Database.query('SELECT id, Name,NumeroProducto__c , FamiliaNecesidades__c, FamiliaCorporativa__c,FamiliaMX__c  FROM Producto__c WHERE Estatus__c=\'1\' AND Name LIKE \'%'+String.escapeSingleQuotes(searchProd)+'%\' ORDER BY NumeroProducto__c  '); 
        }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error en consulta: '+e.getMessage() ));
            return null;
        }
        return catalogoProductos;
    }
    
    
}