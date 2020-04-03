public without sharing class PLAN_PDFCotizacionCtrl {
    /***** Constantes utilizadas en el PDF *****/
    //Tamaños de hoja.
    public static Tamano T_A4 = new Tamano(210, 297);
    public static Tamano T_CARTA = new Tamano(21.59,27.94);
    
    
    //Info de Cotizacion para Pdf.
    public Quote cotizacion {get;set;}
    public String msgError  {get;set;}
    public Pdf pdf {get;set;}
    public static String DocumentTYCName = 'TerminosYCondiciones';
    
    
    //Informacion y contenido estatico del PDF
    public String currentDate {get; set;}
    public Map<String,ContenidoPDF__c> contenidos;
    public List<SeccionProducto> spexample{get;set;}
    
    //Listado de secciones
    public Map<String,Seccion> mapSecciones{get;set;}
    public List<Seccion> listSecciones{set;get;}
    private Pagina pagina;
    
    //Paginado
    public List<Pagina> paginas{get;set;}
    public Integer numPaginas{get;set;}
    public Id userId {get; set;}
    public String segmento = '';
    public String ejecutivoName {get; set;}
    public String ejecutivoEmail {get; set;}
    public String ejecutivoTelefono {get; set;}
    public Map<Id, Decimal> mapEscalonamientos = new Map<Id, Decimal>();
    
    public PLAN_PDFCotizacionCtrl() {
        userId = UserInfo.getUserId();
        if(userId != null) {
            for(User usr: [SELECT Id, Segmento__c, Name, Email, Phone, Extension FROM User WHERE Id=: userId]) {
                segmento = usr.Segmento__c;
                ejecutivoName = usr.Name != null ? usr.Name : '';
                ejecutivoEmail = usr.Email != null ? usr.Email : '';
                ejecutivoTelefono = (usr.Phone != null ? usr.Phone : '') + (usr.Extension != null ? (' ext: ' + usr.Extension) : '');
                break;
            }
        }
        String idCotizacion = ApexPages.currentPage().getParameters().get('id');
        currentDate = System.now().format('dd/MM/yyyy');
        contenidos = ContenidoPDF__c.getAll();
        paginas = new List<Pagina>();
        //this.DocumentTYCName = 'TerminosYCondiciones';
        
        if(String.isNotBlank(idCotizacion) && idCotizacion.length() > 14) {
            try {
                //cotizacion = [SELECT Id, Name, Contact.Name, Contact.Puesto__c, Opportunity.Account.Name, TotalPrice, CantidadTarjetas__c, Opportunity.Account.NumberOfEmployees, (SELECT Id, CantidadTarjetas__c, Description, Etapa__c, LineNumber, Subtotal, Quantity, Product2Id, UnitPrice, Product2.Name, Product2.Id, Product2.MonederoElectronico__c, product2.Family, TotalPrice FROM QuoteLineItems WHERE Escalonamiento1__c=false ORDER BY CreatedDate ASC) From Quote WHERE Id =: idCotizacion];
                cotizacion = [SELECT Id, Name, Contact.Name, Contact.Puesto__c, Opportunity.Account.Name, TotalPrice, CantidadTarjetas__c, Opportunity.Account.NumberOfEmployees, (SELECT Id, CantidadTarjetas__c, Description, Etapa__c, LineNumber, Subtotal, Quantity, Product2Id, UnitPrice, Product2.Name, Product2.Id, Product2.MonederoElectronico__c, product2.Family, TotalPrice FROM QuoteLineItems WHERE Escalonamiento__c = null ORDER BY CreatedDate ASC) From Quote WHERE Id =: idCotizacion];

                //agrega calvarez 23 mayo 2017
                for(QuoteLineItem qli : [SELECT Id, Subtotal, Escalonamiento__c, Escalonamiento1__c FROM QuoteLineItem WHERE QuoteId =: idCotizacion AND Escalonamiento__c != null AND Subtotal != null]) {
                    if(!mapEscalonamientos.containsKey(qli.Escalonamiento__c)) {
                        mapEscalonamientos.put(qli.Escalonamiento__c, 0);
                    }
                    mapEscalonamientos.put(qli.Escalonamiento__c, mapEscalonamientos.get(qli.Escalonamiento__c) + qli.Subtotal);
                }
                System.debug('\n\n mapEscalonamientos: ' + mapEscalonamientos + ' \n\n');
                
                if(cotizacion != null && cotizacion.QuoteLineItems != null && cotizacion.QuoteLineItems.size() > 0) {
                    pdf = new Pdf(cotizacion, mapEscalonamientos);
                }
                system.debug(pdf.productos);
                if(pdf.productos.size()>0){
                    construyePdf();
                }
            } catch(Exception e) {
                msgError = e.getMessage();
                System.debug('ERROR PLAN_PDFCotizacionCtrl: ' + e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getStackTraceString());
            }
        }
        //this.spexample = (new SeccionProducto(pdf.productos[0])).getPartirListado(4);
        
    }
    public static Decimal W_CONTENIDO = 17.5;
    public static Tamano SIZE_CABECERA          = new Tamano(21.59,3.8);
    public static Tamano SIZE_PC_TITULO         = new Tamano(W_CONTENIDO,3.0);
    public static Tamano SIZE_PC_INFO_CLIENTE   = new Tamano(W_CONTENIDO, 1.5);
    public static Tamano SIZE_FPYV              = new Tamano(W_CONTENIDO,2.5);
    public static Tamano SIZE_DIFERENCIALES     = new Tamano(W_CONTENIDO, 14.0);
    public static Tamano SIZE_DOC_REQ           = new Tamano(W_CONTENIDO, 10.5);
    public static Tamano SIZE_IA                = new Tamano(W_CONTENIDO,3.0);
    public static Tamano SIZE_FIRMAS            = new Tamano(W_CONTENIDO,4.5);
    public static Tamano SIZE_CONTACTO          = new Tamano(W_CONTENIDO,4.5);
    public static Tamano SIZE_FOOTER            = new Tamano(W_CONTENIDO,4.0);
    public static Decimal PC_CHARXLINEA         = 96;
    
    public void construyePdf(){
        //pagina= new Pagina();
        if(pdf.productosSinMonedero.size() > 0){
            armaPdf(pdf.productosSinMonedero, true);
        }
        if(pdf.productosConMonedero.size() > 0){
            armapdf(pdf.productosConMonedero, false);
        }
    }
    
    public void armaPdf(List<Producto> lsp, Boolean imprimeTYC) {
        this.numPaginas = 0;
        //Seccion que representa la cabecera
        Seccion cabecera = new Seccion();
        cabecera.nombre = 'cabecera';
        cabecera.titulo = 'cabecera';
        cabecera.size = SIZE_CABECERA;
        
        //Sección que representa el título de la propuesta.
        Seccion tituloPropCom = new Seccion();
        tituloPropCom.nombre = 'Titulo Propuesta Comercial';
        tituloPropCom.titulo = 'Propuesta Comercial';
        tituloPropCom.size = SIZE_PC_TITULO;
        
        //Sección que representa la información del cliente
        Seccion infoCliente = new Seccion();
        infoCliente.nombre = 'Información Cliente';
        infoCliente.size = SIZE_PC_INFO_CLIENTE;
        
        //Sección que representa el contenido la propuesta comercial.(Aprox 95 caracteres por linea)
        Seccion infoPropCom = new Seccion();
        infoPropCom.nombre = 'Informacion Propuesta Comercial';
        infoPropCom.titulo = infoPropCom.nombre;
        infoPropCom.size = new Tamano(W_CONTENIDO, 3.5); //Varia segun tamaño de renglón.
        
        //Sección que representa el comparativo de los productos.
        List<SeccionProducto> lssp = getSeccionesProducto(lsp);
        
        //Copiar a partir de aquí
        Seccion fpyv = new Seccion();
        fpyv.nombre = 'Forma de pago y vigencia';
        fpyv.titulo = fpyv.nombre;
        fpyv.size = SIZE_FPYV;

        //List<SeccionProducto> diferencialesLista = getSeccionesProducto(lsp);
        
        List<SeccionDiferencial> diferenciales = getSeccionesDiferencial(lsp);
        system.debug('####Listado de Diferenciales');
        for(SeccionDiferencial sd:diferenciales){
            system.debug('Titulo:'+sd.titulo);
            system.debug(sd.cabecerasTabla);
            system.debug(sd.diferencialesRows.size());
            for(RowDiferencial rd: sd.diferencialesRows){
                system.debug(rd.descripcion+', '+rd.checks);
            }
        }
        
        Seccion reqDocumentacion = new Seccion();
        reqDocumentacion.nombre = 'Documentación para contratar';
        reqDocumentacion.titulo = 'Tabla de documentos';
        reqDocumentacion.size = new Tamano(W_CONTENIDO,H_TDOC_TABLA + H_TDOC_TITULO);
        
        Seccion reqDocuemntacionRF = getDocumentacionRequerimientoFirma();
        Seccion reqDocumentacionDesp = getDocumentacionDespedida();
        
        Seccion infoAdicional = new Seccion();
        infoAdicional.nombre = 'Información Adicional';
        infoAdicional.titulo = infoAdicional.nombre;
        infoAdicional.size = SIZE_IA;
        
        List<Seccion> tyc = new List<Seccion>();
        Seccion firmas = new Seccion();
        if(imprimeTYC){
            if(pdf.imprimeTYC() && 'Small' == segmento){
                tyc = getTerminosYCondicionesList();
                firmas.nombre = 'Firmas';
                firmas.size = SIZE_FIRMAS;
            }
        }
        Seccion contacto = new Seccion();
        contacto.nombre = 'Contacto';
        contacto.size = SIZE_CONTACTO;
        
        Seccion footer = new Seccion();
        footer.nombre = 'Footer';
        footer.titulo = 'Da click en el nombre del ícono para conocer otras soluciones.';
        footer.size = SIZE_FOOTER;
        
        //Pagina pagina = new Pagina();
        pagina = new Pagina();
        Boolean addCabecera = pagina.addSeccion(cabecera);
        Boolean addTituloPC = pagina.addSeccion(tituloPropCom);
        Boolean addInfoCliente = pagina.addSeccion(infoCliente);
        Boolean addInfoPropCom = pagina.addSeccion(infoPropCom);
        
        //Se agregan las secciones de productos
        for(SeccionProducto sp: lssp){
            //-->Modificado Sinuhe Garcia 8 junio de 2017
            SeccionProducto sptoadd = sp;
            while(!pagina.addSeccionProducto(sptoadd)){
                Decimal espacioFaltante = pagina.size.height - pagina.sumaHeight;
                Integer nconceptos = (Integer)((espacioFaltante - (2*H_TCOMP_CABECERAS)-H_TCOMP_RESUMEN-H_TCOMP_ESPACIO)/H_TCOMP_ROW);//Al espacio faltante se le restan las cabeceras + resumen y el resultado se divide entre el espacio entre conceptos
                if(nconceptos <= 0){
                    this.addPagina(pagina);
                    pagina = new Pagina();
                    pagina.addSeccion(cabecera);
                    //pagina.addSeccionProducto(sp);
                }else{
                    List<SeccionProducto> lsp1 = sp.getPartirListado(nconceptos);
                    system.debug('####SeccionDiferencial partida tamaño:'+lsp1.size());
                    if(lsp1 != null){
                        if(lsp1.size() == 1){
                            sptoadd = lsp1[0];
                        }
                        if(lsp1.size() == 2){
                            if(pagina.addSeccionProducto(lsp1[0])){
                                system.debug('[EjemploPDF] armaPDF() Tabla Diferencial de producto '+lsp1[0].nombre+' añadida exitosamente');
                            }
                            sptoadd = lsp1[1];
                        }
                    }
                }
            }
            //<----------------------------------
        }
        
        pagina = addSeccion(fpyv, pagina, cabecera);
        System.debug('####Diferenciales size: ' + diferenciales.size());
        
        //Se agregan las secciones de diferenciales
        for(SeccionDiferencial sd: diferenciales){
            SeccionDiferencial sdtoadd = sd;
            System.debug('####SeccionDiferencial: ' + sdtoadd);

            while(!pagina.addSeccionDiferencial(sdtoadd)){
                Decimal espacioFaltante = pagina.size.height - pagina.sumaHeight;
                Integer ndiferenciales = 0;
                if(String.isBlank(sdtoadd.titulo)){
                    ndiferenciales = (Integer)((espacioFaltante - H_TDIF_CABECERA)/H_TDIF_ROW);
                }else{
                    ndiferenciales = (Integer)((espacioFaltante - H_TDIF_CABECERA-H_TDIF_TITULO)/H_TDIF_ROW);
                }
                
                if(ndiferenciales <= 3){
                    System.debug('####entra ndiferenciales <= 0');
                    addPagina(pagina);
                    pagina = new Pagina();
                    pagina.addSeccion(cabecera);
                }else {
                    //--> Modificado Sinuhe Garcia 8 - Junio 2017
                    List<SeccionDiferencial> lsd1 = sdtoadd.partirSeccionDiferencial(ndiferenciales);
                    system.debug('####SeccionDiferencial partida tamaño:'+lsd1.size());
                    if(lsd1 != null){
                        if(lsd1.size() == 1){
                            sdtoadd = lsd1[0];
                        }
                        if(lsd1.size() == 2){
                            if(pagina.addSeccionDiferencial(lsd1[0])){
                                system.debug('[EjemploPDF] armaPDF() Tabla Diferencial de producto '+lsd1[0].nombre+' añadida exitosamente');
                            }
                            sdtoadd = lsd1[1];
                        }
                    }
                    //<--------------------------------------------
                }
            }
            system.debug('[EjemploPDF] armaPDF() Tabla Diferencial de producto '+sd.nombre+' completada exitosamente.');
            
        }
        pagina = addSeccion(reqDocumentacion, pagina, cabecera);
        pagina = addSeccion(reqDocuemntacionRF, pagina, cabecera);
        pagina = addSeccion(reqDocumentacionDesp, pagina, cabecera);
        pagina = addSeccion(infoAdicional, pagina, cabecera);
        
        //system.debug('[EjemploPDF]partirSeccionTerminosYCondiciones\n'+partirSeccionTerminosYCondiciones(tyc[0]));
        if(imprimeTYC){
            if(pdf.imprimeTYC() && 'Small' == segmento){
                for(Seccion sec: tyc){
                    if(pagina.addSeccion(sec)){
                        system.debug(sec.titulo+' añadida exitosamente');
                    }else{
                        for(Seccion secc:partirSeccionTerminosYCondiciones(sec)){
                            if(pagina.addSeccion(secc)){
                                system.debug(secc.titulo+' añadida exitosamente');
                            }else{
                                addPagina(pagina);
                                pagina = new Pagina();
                                pagina.addSeccion(cabecera);
                                pagina.addSeccion(secc);
                            }       
                        }
                    }
                }
                pagina = addSeccion(firmas,pagina,cabecera);
            }
        }
        pagina = addSeccion(contacto,pagina,cabecera);
        pagina = addSeccion(footer,pagina,cabecera);
        this.addPagina(pagina);
        if(imprimeTYC){
            pagina = new Pagina();
            this.addPagina(pagina);
        }
    }

    public Decimal addHeader(Producto p, Seccion s, Decimal d) {
        return d;
    }
    
    public Pagina addSeccion(Seccion seccion, Pagina pagina, Seccion cabecera){
        boolean v_addSeccion = pagina.addSeccion(seccion);
        if(!v_addSeccion){
            addPagina(pagina);
            pagina = new Pagina();
            pagina.addSeccion(cabecera);
            pagina.addSeccion(seccion);
        }
        return pagina;
    }
    
    public List<SeccionProducto> getSeccionesProducto(List<Producto> lsprod){
        List<SeccionProducto> lsp = new List<SeccionProducto>();
        for(Producto p: lsprod){
            SeccionProducto sp = new SeccionProducto(p);
            lsp.add(sp);
        }
        return lsp;
    }
    public List<SeccionDiferencial> getSeccionesDiferencial(List<Producto> lsprod){
        List<SeccionDiferencial> lsd = new List<SeccionDiferencial>();
        for(Producto p: lsprod) {
            //System.debug('getSeccionesDiferencial: ' + p.diferenciales.size() + ' ' + p.conceptos.size());
            SeccionDiferencial sd = new SeccionDiferencial(p);
            lsd.add(sd);
        }
        return lsd;
    }
    
    /***** Se obtienen los contenidos de los documentos. *****/
    public void addPagina(Pagina p){
        numPaginas += 1;
        p.numPagina = numPaginas;
        paginas.add(p);
    }
    public Seccion getFormaDePago(){
        return getSeccionFromContenidos('Forma de pago del pedido');
    }
    public Seccion getVigencia(){
        return getSeccionFromContenidos('Vigencia de propuesta');
    }
    public Seccion getDocumentacionPFisica2(){
        Seccion sec = new Seccion();
        for(ContenidoPDF__c c:contenidos.values()){
            if(c.Seccion__c == 'Documentación para contratar' && c.Cuerpo__c && c.PersonaFisica__c){
                sec.listaContenido.add(c.Contenido__c);
            }
            if(c.Seccion__c == 'Documentación para contratar' && c.Titulo__c && c.PersonaFisica__c){
                sec.titulo = c.Contenido__c;
            }
        }
        return sec;
    }
    public static Decimal H_TDOC_TABLA = 4.0;
    public static Decimal H_TDOC_TITULO = 1.0;
    public Seccion getDocumentacionPFisica(){
        Seccion seccion = new Seccion();
        String docsPFisica = contenidos.get('DocumentosPFisica').Contenido__c;
        List<String> lsContenido = docsPFisica.split('\n');
        Integer contador = 0;
        for(String str: lsContenido){
            if(contador == 0){
                seccion.titulo = str;
            }else{
                seccion.listaContenido.add(str);
            }
            contador++;
        }
        seccion.size = new Tamano(W_CONTENIDO,H_TDOC_TABLA+H_TDOC_TITULO);
        return seccion;
    }

    public Seccion getDocumentacionPMoral2(){
        Seccion sec = new Seccion();
        for(ContenidoPDF__c c:contenidos.values()){
            if(c.Seccion__c == 'Documentación para contratar' && c.Cuerpo__c && c.PersonaMoral__c){
                sec.listaContenido.add(c.Contenido__c);
            }
            if(c.Seccion__c == 'Documentación para contratar' && c.Titulo__c && c.PersonaMoral__c){
                sec.titulo = c.Contenido__c;
            }
        }
        return sec;
    }

    public Seccion getDocumentacionPMoral(){
        Seccion seccion = new Seccion();
        String docsPFisica = contenidos.get('DocumentosPMoral').Contenido__c;
        List<String> lsContenido = docsPFisica.split('\n');
        Integer contador = 0;
        for(String str: lsContenido){
            if(contador == 0){
                seccion.titulo = str;
            }else{
                seccion.listaContenido.add(str);
            }
            contador++;
        }
        seccion.size = new Tamano(W_CONTENIDO,H_TDOC_TABLA+H_TDOC_TITULO);
        return seccion;
    }
    public Seccion getDocumentacionRequerimientoFirma(){
        return getSeccionFromContenidos('RequerimientoFirma');
    }
    public Seccion getDocumentacionDespedida(){
        return getSeccionFromContenidos('Despedida');
    }
    /*
    * @description Obtiene el contenido de una Sección en particular. Devuelve un titulo y una lista de
    * contenido.
    * @param seccion Nombre de la sección a recuperar.
    */
    public static Decimal H_TDOC_REQF = 2.5;
    public static Decimal H_TDOC_DESP = 0.9;
    public Seccion getSeccionFromContenidos(String seccion){
        Seccion sec = new Seccion();
        if(seccion == 'Despedida' || seccion == 'RequerimientoFirma'){
            sec.nombre = 'Documentación para contratar';
            sec.titulo = seccion;
            String requerimientoFirma = contenidos.get(seccion).Contenido__c;
            for(String str:requerimientoFirma.split('\n')){
                sec.listaContenido.add(str);
            }
            sec.size = new Tamano(W_CONTENIDO,H_TDOC_REQF);
        }
        if(seccion == 'Forma de pago del pedido' || seccion == 'Vigencia de propuesta'){
            for(ContenidoPDF__c c:contenidos.values()){
                if(c.Seccion__c == seccion && c.Cuerpo__c){
                    sec.listaContenido.add(c.Contenido__c);
                }
                if(c.Seccion__c == seccion && c.Titulo__c){
                    sec.titulo = c.Contenido__c;
                }
            }
            sec.size = new Tamano(W_CONTENIDO,H_TDOC_DESP);
        }
        return sec;
    }
    
    /*
    * @description Obtiene el contenido del documento de Términos y condiciones, dividido en Secciones.
    */
    public static Decimal H_TYC_TITULO = 0.5;
    public static Decimal H_TYC_LINEA = 0.4;
    public static Decimal H_TYC_ESPACIO = 0.5;
    public static Decimal TYC_CHARXLINEA = 106;
    
    public List<Seccion> getTerminosYCondicionesList(){
        List<Seccion> tycSecciones = new List<Seccion>();
        List<Document> documents = [SELECT Body FROM Document WHERE DeveloperName = :DocumentTYCName];
        Blob blobContent = documents[0].Body;
        String contenido = blobContent.toString();
        Decimal numCarXlinea = TYC_CHARXLINEA;
        Map<String,List<String>> tyc = (Map<String,List<String>>)JSON.deserialize(contenido,Type.forName('Map<String,List<String>>'));
        for(String key:tyc.keySet()){
            Seccion sec = new Seccion();
            sec.nombre = 'Terminos y condiciones';
            sec.titulo = key;
            Decimal height = H_TYC_TITULO; //Altura del titulo
            sec.listaContenido = tyc.get(key);
            for(String str:sec.listaContenido){
                Decimal alturaParrafo = math.ceil(str.length() / numCarXLinea) * H_TYC_LINEA;
                alturaParrafo += H_TYC_ESPACIO;
                height += alturaParrafo;
            }
            sec.size = new Tamano(W_CONTENIDO,height);
            tycSecciones.add(sec);
        }
        return tycSecciones;
    }
    public List<Seccion> partirSeccionTerminosYCondiciones(Seccion seccion){
        List<Seccion> lss = seccion.partirSeccion();
        Integer contador = 0;
        for(Seccion sec : lss){
            Decimal height = 0.0;
            if(contador==0){
                height += H_TYC_TITULO;
            }
            Decimal alturaParrafo = math.ceil(sec.listaContenido[0].length() / TYC_CHARXLINEA) * H_TYC_LINEA;
            alturaParrafo += H_TYC_ESPACIO;
            height += alturaParrafo;
            sec.size = new Tamano(W_CONTENIDO,height);
        }
        return lss;
    }
    
    
    /**
    * @description Clase que representa una sección de la página, posee una lista de contenido.
    */
    public class Seccion {
        public String nombre{get;set;}
        public String titulo{get;set;}
        public List<String> listaContenido{get;set;}
        public Tamano size{get;set;}
        public String html{get;set;}
        public Seccion(){
            listaContenido = new List<String>();
            //Por default se pone un tamaño de 0.0 x 0.0 cm
            size = new Tamano(0.0,0.0);
        }
        public List<Seccion> partirSeccion(){
            Integer contador = 0;
            List<Seccion> lss = new List<Seccion>();
            for(String str: this.listaContenido){
                Seccion sec = new Seccion();
                sec.nombre = this.nombre;
                if(contador == 0){
                    sec.titulo = this.titulo;
                }else{
                    sec.titulo = '';
                }
                sec.listaContenido.add(str);
                //Por default se pone un tamaño de 0.0 x 0.0 cm
                //Se deben hacer calculos de acuerdo al elemento.
                sec.size = new Tamano(0.0,0.0);
                lss.add(sec);
                contador++;
            }
            return lss;
        }
    }
    
    public static Decimal H_TDIF_TITULO = 1.5;
    public static Decimal H_TDIF_CABECERA = 0.85;
    public static Decimal H_TDIF_ROW = 1.0;
    public class SeccionDiferencial{
        public String nombre{get;set;}
        public String titulo{get;set;}
        public Tamano size{get;set;}
        public List<String> cabecerasTabla{get;set;}
        public List<RowDiferencial> diferencialesRows{get;set;}
        public Boolean showTitulo{get;set;}
        private Decimal heightCabeceras;
        
        public SeccionDiferencial(Producto prod){
            init();
            this.nombre = prod.nombre;
            this.titulo = 'Diferenciales de '+ prod.nombre;
            this.showTitulo = true;
            this.cabecerasTabla.add('Descripción');
            this.cabecerasTabla.add(prod.nombre);
            for(Comparado comp:prod.comparados){
                this.cabecerasTabla.add(comp.nombre);
            }
            system.debug('####. Diferenciales:'+prod.diferenciales.size());
            system.debug('####'+prod.hasDiferencial);
            Integer index = 0;
            for(String diff: prod.diferenciales){
                RowDiferencial rd = new RowDiferencial();
                rd.descripcion = diff;
                rd.styleClass = Math.mod(index, 2) == 0 ? 'par' : 'non';
                rd.checks.add(prod.hasDiferencial.get(diff+'_'+prod.idProduct2));
                for(Comparado comp:prod.comparados){
                    rd.checks.add(prod.hasDiferencial.get(diff+'_'+comp.idProduct2));
                }
                diferencialesRows.add(rd);
                index++;
            }
            calculaTamano();
        }
        public SeccionDiferencial(){
            init();
        }
        public void init(){
            this.cabecerasTabla = new List<String>();
            this.diferencialesRows = new List<RowDiferencial>();
            
        }
        
        public void calculaTamano(){
            Decimal height;
            if(showTitulo){
                height = H_TDIF_TITULO + H_TDIF_CABECERA + (H_TDIF_ROW * diferencialesRows.size());
            }else{
                height = H_TDIF_CABECERA + (H_TDIF_ROW * diferencialesRows.size());
            }
            size = new Tamano(W_CONTENIDO,height);
        }
        public List<SeccionDiferencial> partirSeccionDiferencial(Integer numdiferenciales){
            system.debug('[SeccionDiferencial] getPartirSeccionDiferencial() numconceptos: '+numdiferenciales); 
            //Se crea un array de SeccionDiferencial
            List<SeccionDiferencial> lssd = new List<SeccionDiferencial>();
            List<List<RowDiferencial>> lsrds = new List<List<RowDiferencial>>();
            Integer contador = 0;
            List<RowDiferencial> lsrd;
            Integer limiteDiferenciales = numdiferenciales - 1;
            for(RowDiferencial dif: diferencialesRows){
                if(contador == 0){
                    lsrd = new List<RowDiferencial>();
                    lsrd.add(dif);
                    if(limiteDiferenciales == contador){
                        lsrds.add(lsrd);
                        lsrd = new List<RowDiferencial>();
                    }
                }else if(contador > 0 && contador == limiteDiferenciales){//Cuando solo se parten en dos partes.
                    lsrd.add(dif);
                    lsrds.add(lsrd);
                    lsrd = new List<RowDiferencial>();
                }
                else{
                    lsrd.add(dif);
                    if(contador == (diferencialesRows.size()-1)){
                        lsrds.add(lsrd);
                    }
                }   
                contador++;
            }
            contador = 0;
            
            for(List<RowDiferencial> ls: lsrds){
                system.debug('[SeccionDiferencial] partirSeccionDiferencial() ls:'+ls);
                SeccionDiferencial sd = new SeccionDiferencial();
                sd.cabecerasTabla = cabecerasTabla;
                sd.diferencialesRows = ls;
                if(contador == 0){
                    sd.titulo = titulo;
                }else{
                    sd.titulo = '';
                }
                sd.nombre = sd.nombre;
                sd.showTitulo = false;
                sd.calculaTamano();
                lssd.add(sd);
                contador++;
            }
            //system.debug('###Tamaño de array de PartirDiferencial:'+lssd.size());
            return lssd;
        }
    }
    public class RowDiferencial{
        public String descripcion{get;set;}
        public String styleClass{get;set;}
        public List<Boolean> checks{get;set;}
        public RowDiferencial(){
            checks = new List<Boolean>();
        }
    }
    public static Decimal H_TCOMP_RESUMEN = 2.0;
    public static Decimal H_TCOMP_CABECERAS = 0.85;//0.8
    public static Decimal H_TCOMP_ESPACIO = 0.5;
    public static Decimal H_TCOMP_ROW = 0.8;
    
    public class SeccionProducto {
        public String nombre{get;set;}
        public String titulo{get;set;}
        public List<String> listaContenido{get;set;}
        public Tamano size{get;set;}
        public Producto producto{get;set;}
        public List<String> conceptos{get;set;}
        public List<String> diferenciales{get;set;}
        public List<PLAN_PDFCotizacionCtrl.Concepto> conceptosAux{get;set;}
        public boolean showResumen{get;set;}
        private Decimal heightCabeceras;
        
        public SeccionProducto(Producto p){
            this.producto = p;
            this.nombre = p.nombre;
            this.titulo = 'Tabla comparativa de '+nombre;
            this.conceptos = p.conceptos;
            this.conceptosAux = p.conceptosAux;
            this.diferenciales = p.diferenciales;
            this.showResumen = true;
            calculaTamano();
        }
        public void calculaTamano(){
            if(showResumen){
                this.heightCabeceras = H_TCOMP_RESUMEN + (H_TCOMP_CABECERAS * 2) + H_TCOMP_ESPACIO;//Resumen+cabeceras+espacio
            }else{
                this.heightCabeceras = (H_TCOMP_ROW * 2) + H_TCOMP_ESPACIO;//Cabeceras + espacio
            }
            
            Decimal height = heightCabeceras;
            height += conceptos.size() * 0.8;
            this.size = new Tamano(W_CONTENIDO,height);
        }

        public void calculaTamanoDiferenciales(){
            this.heightCabeceras = H_TCOMP_CABECERAS + H_TCOMP_ESPACIO;
            Decimal height = heightCabeceras;
            height += diferenciales.size() * 0.8;
            this.size = new Tamano(W_CONTENIDO,height);
        }

        public List<SeccionProducto> getPartirListado(Integer numconceptos){
            system.debug('[SeccionProducto] getPartirListado() numconceptos: '+numconceptos); 
            List<SeccionProducto> lssp = new List<SeccionProducto>();
            List<List<String>> lscps = new List<List<String>>();
            Integer contador = 0;
            List<String> lscp;
            Integer limiteConceptos = numconceptos-1;
            for(String c: conceptos){
                if(contador == 0){
                    lscp = new List<String>();
                    lscp.add(c);
                    if(limiteConceptos == contador){
                        lscps.add(lscp);
                        lscp = new List<String>();
                    }
                }else if(contador > 0 && contador == limiteConceptos){//Cuando solo se parten en dos partes.
                    lscp.add(c);
                    lscps.add(lscp);
                    lscp = new List<String>();
                }
                else{
                    lscp.add(c);
                    if(contador == (producto.conceptos.size()-1)){
                        lscps.add(lscp);
                    }
                }   
                contador++;
            }
            contador = 0;
            
            for(List<String> lsstr: lscps){
                system.debug('[SeccionProducto] getPartirListado() lsstr:'+lsstr);
                SeccionProducto sp = new SeccionProducto(producto);
                sp.conceptos = lsstr;
                if(contador == 0){
                    sp.showResumen= true;
                    sp.calculaTamano();
                }else{
                    sp.showResumen = false;
                    sp.calculaTamano();
                }
                lssp.add(sp);
                contador++;
            }
            return lssp;
        }

        /*public List<SeccionProducto> getPartirListadoDiferenciales(Integer numdiferenciales){
            system.debug('[SeccionProducto] getPartirListado() numconceptos: '+numdiferenciales); 
            List<SeccionProducto> lssp = new List<SeccionProducto>();
            List<List<String>> lscps = new List<List<String>>();
            Integer contador = 0;
            List<String> lscp;
            for(String c: diferenciales){
                if(contador == 0){
                    lscp = new List<String>();
                    lscp.add(c);
                }else if(contador > 0 && contador == (numdiferenciales-1)){//Cuando solo se parten en dos partes.
                    lscp.add(c);
                    lscps.add(lscp);
                    lscp = new List<String>();
                }
                else{
                    lscp.add(c);
                    if(contador == (producto.diferenciales.size()-1)){
                        lscps.add(lscp);
                    }
                }   
                contador++;
            }
            contador = 0;
            
            for(List<String> lsstr: lscps){
                system.debug('[SeccionProducto] getPartirListado() lsstr:'+lsstr);
                SeccionProducto sp = new SeccionProducto(producto);
                sp.conceptos = lsstr;
                sp.showResumen = false;
                sp.calculaTamanoDiferenciales();
                lssp.add(sp);
                contador++;
            }
            return lssp;
        }*/
    }
    /**
    * @description Clase que representa una sección de la página, posee una lista de contenido.
    */
    public class Pagina{
        public Tamano size;
        public Decimal sumaHeight;
        public List<Seccion> secciones{get;set;}
        public List<SeccionProducto> seccionesProducto{get;set;}
        public List<Secciondiferencial> seccionesDiferencial{get;set;}
        public Integer numPagina{get;set;}
        public Pagina(Tamano t){
            init(t);
        }
        public Pagina(){
            init(PLAN_PDFCotizacionCtrl.T_CARTA); //Este tamaño corresponde al tamaño carta.
            //init(new Tamano(21.59,27.94));
        }
        public void init(Tamano t){
            this.size = t;
            this.sumaHeight = 0.0;
            secciones = new List<Seccion>();
            seccionesProducto = new List<SeccionProducto>();
            seccionesDiferencial = new List<Secciondiferencial>();
        }
        public boolean addSeccion(Seccion s){
            sumaHeight += s.size.height;
            if(sumaHeight <= size.height){
                secciones.add(s);
                system.debug('[Pagina] addSeccion '+s.nombre+' (OK)');
                return true;
            }else{
                sumaHeight -= s.size.height;
                system.debug('[Pagina] addSeccion '+s.nombre+' (Error)');
                return false;
            }
        }
        public boolean addSeccionProducto(SeccionProducto s){
            sumaHeight += s.size.height;
            //system.debug('[Pagina] addSeccionProducto() seccion.size:'+s.size);
            //system.debug('[Pagina] addSeccionProducto() sumaHeight:'+sumaHeight);
            if(sumaHeight <= this.size.height){
                seccionesProducto.add(s);
                system.debug('[Pagina] addSeccionProducto '+s.nombre+' (OK)');
                return true;
            }else{
                sumaHeight -= s.size.height;
                system.debug('[Pagina] addSeccionProducto '+s.nombre+' (Error)');
                return false;
            }
        }
        public boolean addSeccionDiferencial(SeccionDiferencial s){
            sumaHeight += s.size.height;
            //system.debug('[Pagina] addSeccionDiferencial() seccion.size:'+s.size);
            //system.debug('[Pagina] addSeccionDiferencial() sumaHeight:'+sumaHeight);
            if(sumaHeight <= this.size.height){
                seccionesDiferencial.add(s);
                system.debug('[Pagina] addSeccionDiferencial '+s.nombre+' (OK)');
                return true;
            }else{
                sumaHeight -= s.size.height;
                system.debug('[Pagina] addSeccionDiferencial '+s.nombre+' (Error)');
                return false;
            }
        }
    }
    /**
    * @description Representa las dimensiones en centimetros de un rectangulo o marco.
    */
    public class Tamano{
        public Decimal height;
        public Decimal width;
        public Tamano(Decimal width, Decimal height)
        {
            this.height = height;
            this.width = width;
        }
    }
    
    /***** Wrappers de cotizacion *****/
    
    public class Pdf {

        public Quote cotizacion {get; set;}
        public List<Producto> productos {get; set;}
        public List<Producto> productosConMonedero{get;set;}
        public List<Producto> productosSinMonedero{get;set;}

        public Pdf(Quote cotizacion, Map<Id, Decimal> mapEscalonamientos) {
            this.cotizacion = cotizacion;
            this.productos = new List<Producto>();
            this.productosConMonedero = new List<Producto>();
            this.productosSinMonedero = new List<Producto>();
            for(QuoteLineItem qli: this.cotizacion.QuoteLineItems) {
                this.productos.add(new Producto(qli, mapEscalonamientos));
                if(qli.Product2.MonederoElectronico__c){
                    this.productosConMonedero.add(new Producto(qli, mapEscalonamientos));
                }else{
                    this.productosSinMonedero.add(new Producto(qli, mapEscalonamientos));
                }
            }

            List<Id> idsProductos = obtenerIdsProductos(this.productos);

            System.debug('idsProductos 24FEB: ' + idsProductos);
        }
        public List<Id> obtenerIdsProductos(List<Producto> productos) {
            List<Id> idsProductos = new List<Id>();
            for(Producto producto : productos) {
                idsProductos.add(producto.idProduct2);
            }
            return idsProductos;
        }
        public boolean imprimeTYC(){
            boolean ityc = false;
            for(Producto p:productos){
                if(p.monederoElectronico){
                    ityc = true;
                }
            }
            return ityc;
        }
    }

    public class Producto {
        public Id id {get; set;}
        public Id idProduct2 {get; set;}
        public String nombre {get; set;} //Nombre
        public String caracteristicas {get; set;} //Característica
        public Decimal totalPrice {get;set;} //TotalPrice
        public Integer cantidadTarjetas{get;set;}
        public Boolean monederoElectronico{get;set;}
        public List<Comparado> comparados {get; set;}
        public List<String> conceptos {get; set;}
        public List<String> diferenciales {get; set;}
        public Map<String, Boolean> hasDiferencial {get; set;}
        public List<PLAN_PDFCotizacionCtrl.Concepto> conceptosAux {get; set;}

        public Map<Id, Map<String, ProductoConcepto>> prodCon {get; set;} //Este es el que se muestra en pantalla en las tablas.
        Set<String> setConceptos = new Set<String>();
        
        public Producto(QuoteLineItem qli, Map<Id, Decimal> mapEscalonamientos) {
            this.id = qli.Id;
            this.idProduct2 = qli.Product2.Id;
            this.nombre = qli.Product2.Name;
            this.totalPrice = qli.TotalPrice;
            if(mapEscalonamientos != null && mapEscalonamientos.containsKey(id)) {
                this.totalPrice = this.totalPrice + mapEscalonamientos.get(id);
            }
            this.cantidadTarjetas = Integer.valueOf(qli.CantidadTarjetas__c);
            this.monederoElectronico = qli.Product2.Monederoelectronico__c;
            this.comparados = leerComparados(qli.Id, qli.Product2.Id);
            this.conceptos = listarConceptos(obtenerIdsProductos(this));
            if(this.conceptos != null && this.conceptos.size() > 0) {
                Integer indice = this.conceptos.size() - 1;
                String str = this.conceptos.get(indice);
                if(str.contains('% de comisión')) {
                    this.conceptos.remove(indice);
                    this.conceptos.add(0, str);
                }
            }

            prodCon = new Map<Id, Map<String, ProductoConcepto>>();
            String COMISION_SERVICIO = 'Comisión por el servicio';
            //System.debug('this.conceptos: ' + this.conceptos);

            List<Id> idsDiferenciales = new List<Id>();
            idsDiferenciales.add(this.idProduct2);

            for(Comparado comp : this.comparados) {
                List<ProductoConcepto> pcComparados = listarProductoConceptoComparados(comp.Id);

                Map<String, ProductoConcepto> conceptosProd = new Map<String, ProductoConcepto>();
                for(String con : this.conceptos) {
                    conceptosProd.put(con, new ProductoConcepto());
                }
                prodCon.put(comp.Id, conceptosProd);
                for(ProductoConcepto pc : pcComparados) {
                    if(conceptosProd.containsKey(pc.concepto)) {
                        ProductoConcepto instancia = conceptosProd.get(pc.concepto);
                        instancia = pc;
                        /*if(instancia.concepto.contains(COMISION_SERVICIO)) {
                            instancia.precioLista2 = '';
                        }*/
                        conceptosProd.put(pc.concepto, instancia);
                    }
                    setConceptos.add(pc.concepto);
                }
                idsDiferenciales.add(comp.idProduct2);
            }

            Map<String, ProductoConcepto> conceptosProd = new Map<String, ProductoConcepto>();
            for(String con : this.conceptos) {
                conceptosProd.put(con, new ProductoConcepto());
            }

            prodCon.put(this.Id, conceptosProd);
            List<ProductoConcepto> pcProducto = listarProductoConcepto(this.Id);
            for(ProductoConcepto pc : pcProducto) {
                if(conceptosProd.containsKey(pc.concepto)) {
                    ProductoConcepto instancia = conceptosProd.get(pc.concepto);
                    instancia = pc;
                    /*if(instancia.concepto.contains(COMISION_SERVICIO)) {
                        instancia.precioLista2 = '';
                    }*/
                    conceptosProd.put(pc.concepto, instancia);
                }

                setConceptos.add(pc.concepto);
            }

            //agrega calvarez 27abril2017 verifica que los conceptos estén en uso
            Integer size = this.conceptos.size() - 1;
            for(Integer i = size; i > -1; i--) {
                if(!setConceptos.contains(this.conceptos[i])) {
                    this.conceptos.remove(i);
                }
            }

            //agrega calvarez 24 feb 2017 - Lista de diferenciales
            System.debug('idsDiferenciales: ' + idsDiferenciales);
            diferenciales = listaDiferenciales(idsDiferenciales);

        }
        
        public Map<Id,boolean> getShowBonificacion(){
            String COMISION_SERVICIO = 'Comisión por el servicio';
            Map<Id,boolean> mb = new Map<Id,boolean>();
            for(Id pId: this.prodCon.keySet()){
                Decimal bpc = 0.0;
                Map<String,ProductoConcepto> mpc = this.prodCon.get(pId);
                Boolean hasComision = false;
                for(String str: mpc.keySet()){
                    if(mpc.get(str).Bonificacion != null) {
                        bpc += Decimal.valueOf(mpc.get(str).Bonificacion);
                    }
                    if(!hasComision && mpc.get(str).Concepto == COMISION_SERVICIO) {
                        hasComision = true;
                    }
                }
                if(bpc != 0.0 || hasComision){
                    mb.put(pId,true);
                }else{
                    mb.put(pId,false);
                }
                //agrega calvarez 6 junio 2017
                //mb.put(pId,true);
            }
            return mb;
        }

        public List<Comparado> leerComparados(Id idQli, Id productId) {
            List<Comparado> comparados = new List<Comparado>();
            for(ProductoComparado__c comparado: [SELECT Id, ProductoCotizado__c, ProductoComparado__c, ProductoComparado__r.Name, ProductoComparado__r.Id FROM ProductoComparado__c WHERE ProductoCotizado__c =: idQli]) {
                if(productId != comparado.ProductoComparado__r.Id) {
                    comparados.add(new Comparado(comparado));
                }
            }
            return comparados;
        }

        public List<String> listarConceptos(List<Id> ids) {
            Map<String, Boolean> unicos = new Map<String, Boolean>();
            List<Concepto> conceptosObli = new List<Concepto>();
            List<Concepto> conceptosOpcion = new List<Concepto>();
            List<Concepto__c> lista = [SELECT Id, Name, TipoCargo__c, Importe__c, Producto__c, Producto__r.Id, Obligatorio__c, Orden__c FROM Concepto__c WHERE Producto__c IN : ids AND Activo__c=true ORDER BY Obligatorio__c DESC];
            System.debug('Lista -> ' + lista.size());
            System.debug('Lista -> ' + ids);

            for(Concepto__c concepto : [SELECT Id, Name, TipoCargo__c, Importe__c, Producto__c, Producto__r.Id, Obligatorio__c, Orden__c FROM Concepto__c WHERE Producto__c IN : ids AND TipoCargo__c!=null AND Activo__c=true ORDER BY Obligatorio__c DESC]) {
                
                //calvarez: 20 feb 2017, nuevo ordenamiento
                //if(String.isNotBlank(concepto.TipoCargo__c) && !unicos.containsKey(concepto.TipoCargo__c)) {
                  //  unicos.put(concepto.TipoCargo__c, true);
                //}
                if(String.isNotBlank(concepto.TipoCargo__c)) {
                    Decimal orden = concepto.Orden__c == null ? 0 : concepto.Orden__c;
                    if(concepto.Obligatorio__c) {
                        conceptosObli.add(new Concepto(concepto.TipoCargo__c, orden, concepto.Id));
                    } else  {
                        conceptosOpcion.add(new Concepto(concepto.TipoCargo__c, orden, concepto.Id));
                    }
                }
            }
            conceptosObli.sort();
            conceptosOpcion.sort();

            conceptosObli.addAll(conceptosOpcion);
            conceptosAux = conceptosObli;
            for(Concepto c: conceptosObli) {
                if(String.isNotBlank(c.tipoCargo) && !unicos.containsKey(c.tipoCargo)) {
                    unicos.put(c.tipoCargo, true);
                }
            }

            System.debug('conceptosObligatorios: ' + conceptosObli);
            System.debug('\n\n\n');


            return new List<String>(unicos.keySet());
        }

        public List<Id> obtenerIdsProductos(Producto p) {
            List<Id> idsProductos = new List<Id>();
            idsProductos.add(p.idProduct2);
            for(Comparado comparado : p.comparados) {
                idsProductos.add(comparado.idProduct2);
            }
            return idsProductos;
        }

        public List<ProductoConcepto> listarProductoConcepto(Id id) {
            List<ProductoConcepto> prodsConceptos = new List<ProductoConcepto>();
            for(ProductoConcepto__c pc : [SELECT Id, Concepto__c, Concepto__r.TipoCargo__c, PrecioLista__c, PrecioLista2__c, PrecioFinal__c, Bonificacion__c, PartidaPresupuesto__r.Product2.Name FROM ProductoConcepto__c WHERE Concepto__r.Activo__c=true AND PartidaPresupuesto__c =: id]) {
                prodsConceptos.add(new ProductoConcepto(pc, pc.Concepto__r.TipoCargo__c));
            }
            return prodsConceptos;
        }

        public List<ProductoConcepto> listarProductoConceptoComparados(Id id) {
            List<ProductoConcepto> prodsConceptos = new List<ProductoConcepto>();
            for(ProductoConcepto__c pc : [SELECT Id, Concepto__c, Concepto__r.TipoCargo__c, PrecioLista__c, PrecioLista2__c, PrecioFinal__c, Bonificacion__c, ProductoComparadoID__r.ProductoComparado__r.Name FROM ProductoConcepto__c WHERE Concepto__r.Activo__c=true AND ProductoComparadoID__c =: id]) {
                prodsConceptos.add(new ProductoConcepto(pc, pc.Concepto__r.TipoCargo__c));
            }
            return prodsConceptos;
        }

        public List<String> listaDiferenciales(List<Id> ids) {

            List<String> lista = new List<String>();
            if(ids != null && ids.size() > 0) {
                Set<String> unique = new Set<String>();
                Map<String, Boolean> diff = new Map<String, Boolean>();

                List<Concepto__c> listaInicial = [SELECT Id, Producto__c, CaracteristicasSolucion__c, Name FROM Concepto__c WHERE Producto__c IN: ids AND RecordType.DeveloperName='CaracteristicasSolucion'];
                Integer counter = 0;
                for(Id idAux: ids) {
                    for(Concepto__c con: listaInicial) {
                        if(String.isNotBlank(con.CaracteristicasSolucion__c)) {
                            diff.put(con.CaracteristicasSolucion__c + '_' +  idAux, false);
                        }
                    }
                }
                for(Concepto__c con: listaInicial) {
                    if(String.isNotBlank(con.CaracteristicasSolucion__c) && !unique.contains(con.CaracteristicasSolucion__c)) {
                        lista.add(con.CaracteristicasSolucion__c);
                        unique.add(con.CaracteristicasSolucion__c);
                    }
                    if(String.isNotBlank(con.CaracteristicasSolucion__c)) {
                        diff.put(con.CaracteristicasSolucion__c + '_' +  con.Producto__c, true);
                    }
                    
                }

                //diferenciales = lista;
                hasDiferencial = diff;
                System.debug('hasDiferencial: ' + diff.size());
            }
            return lista;

        }

        public Boolean getVerifyDiff(Set<String> sett, String key) {
            return sett != null && String.isNotBlank(key) && sett.contains(key);
        }
    }

    public class Comparado {
        public Id id {get; set;}
        public String nombre {get; set;}
        public Id idProduct2 {get; set;}
        public Id idQli {get; set;}

        public Comparado(ProductoComparado__c pc) {
            this.id = pc.Id;
            this.nombre = pc.ProductoComparado__r.Name;
            this.idProduct2 = pc.ProductoComparado__c;
            this.idQli = pc.ProductoCotizado__c;
        }

    }

    public class ProductoConcepto {

        public Id id {get; set;}
        public Id conceptoId {get; set;}
        public String concepto {get; set;}
        public String precioLista {get; set;}
        public String precioLista2 {get; set;}
        public String bonificacion {get; set;}
        public String precioFinal {get; set;}

        public String COMISION_SERVICIO = 'Comisión por el servicio';

        public ProductoConcepto() {

        }

        public ProductoConcepto(ProductoConcepto__c pc, String nombre) {
            this.Id = pc.Id;
            this.conceptoId = pc.Concepto__c;
            this.concepto = nombre;
            //this.precioLista = nombre == COMISION_SERVICIO ? '' : String.valueOf(pc.PrecioLista__c);
            this.precioLista = String.valueOf(pc.PrecioLista__c);
            this.precioLista2 = String.valueOf(pc.PrecioLista2__c);
            this.bonificacion = String.valueOf(pc.Bonificacion__c);
            this.precioFinal = String.valueOf(pc.PrecioFinal__c);

            /*if(this.precioLista != null) {
                this.precioLista = nombre == COMISION_SERVICIO ? (this.precioLista + ' %') : ('$ ' + this.precioLista);
            }
            if(this.bonificacion != null) {
                this.bonificacion = nombre == COMISION_SERVICIO ? (this.bonificacion + ' %') : ('$ ' + this.bonificacion);
            }
            if(this.precioFinal != null) {
                this.precioFinal = nombre == COMISION_SERVICIO ? (this.precioFinal + ' %') : ('$ ' + this.precioFinal);
            }*/
        }
    }

    public class Concepto implements Comparable {
        public String tipoCargo {get; set;}
        public Decimal orden {get; set;}
        public String idP {get; set;}
        public String caracteristicas {get; set;}

        public  Concepto(String tipoCargo, Decimal orden, String idP) {
            this.tipoCargo = tipoCargo;
            this.orden = orden;
            this.idP = idP;
        }

        public  Concepto(String tipoCargo, Decimal orden, String idP, String caracteristicas) {
            this.tipoCargo = tipoCargo;
            this.orden = orden;
            this.idP = idP;
            this.caracteristicas = caracteristicas;
        }

        public Integer compareTo(Object compareTo) {
            Concepto concept = (Concepto) compareTo;
            if(orden == concept.orden) {
                return 0;
            }
            if(orden > concept.orden) {
                return 1;
            }
            return -1;
        }
    }
}