public class GenerarCSVSController {
    public Opportunity oportunidad {get;set;}
    public QuoteLineItem qli {get; set;}//agrega calvarez 28feb2017
    public OpportunityLineItem oli {get; set;}//agrega calvarez 4mar2017
    public String COM_EMI = 'Comisión por el servicio';
    list<String> tipoArchivos = new List<String> { 'OCRD - BusinessPartners_auraportal.csv', 'OCPR - ContactEmployees_auraportal.csv', 'CRD1 - BPAddresses_auraportal.csv','PriceLists1(Cabecera).csv','PriceLists2(Detalle).csv' };
    public list<Attachment> archivos {get;set;}
    public list <WrapArchivo> listaArchivos{get;set;}
    public Negocio__c negocio {get;set;}
    public Class WrapArchivo{
        public String mensaje {get;set;}
        public String link {get;set;}
        public Attachment archivo {get;set;}
        public WrapArchivo(){
            archivo = new Attachment();
        }
    }
    
    public GenerarCSVSController(apexPages.StandardController std) {
        try {
        //agrega calvarez 28feb2017 INICIO
        String idProd = ApexPages.currentPage().getParameters().get('idProd');
        if(String.isNotBlank(idProd)) {
            List<QuoteLineItem> qlis = [SELECT Id, FormaPago__c, Facturacion1__c, Facturacion2__c, Pedidos__c, RecursosHumanos__c, Product2.NombreSistemas__c FROM QuoteLineItem WHERE Id=: idProd];
            if(qlis != null && qlis.size() > 0) {
                qli = qlis[0];
            }
            //agrega calvarez 4mar2017
            List<OpportunityLineItem> olis = [SELECT Id, FormaPago__c FROM OpportunityLineItem WHERE PartidaPresupuesto__c =: idProd];
            if(olis != null && olis.size() > 0) {
                oli = olis[0];
            }
        }
        //agrega calvarez 28feb2017 FIN

        oportunidad = [SELECT Id, Name, OwnerId,EnvioCSVOPAM__c, AccountId,IdCuentaOPAM__c,IdOportunidadOPAMNegocio__c, IdOportunidadOPAM__c, Producto__r.Producto__c, Producto__r.NumeroProducto__c, Facturacion1__c, Facturacion2__c, Pedidos__c, RecursosHumanos__c, Metodo_Pago__c, RegistroPatronalOPAM__c, Contacto__r.Extension__c, Contacto__r.Phone, Contacto__r.HomePhone, Contacto__r.Fax, Contacto__r.Email, Contacto__r.Salutation, Contacto__r.FirstName, Contacto__r.LastName, Contacto__r.AreaTrabajo__c, Contacto__r.Funcion__c FROM Opportunity WHERE Id =: std.getRecord().id];
        archivos = new list<Attachment>();
        listaArchivos = new list <WrapArchivo>();
        for(String tipoArchivo : tipoArchivos){
            WrapArchivo wa = new WrapArchivo();
            wa.archivo.Name = tipoArchivo ;
            //wa.archivo.ParentId = oportunidad.Id;
            wa.archivo.ParentId = oli.Id;//agrega calvarez 6mar2017 - asociar a OpportunityLineItem en lugar de Opportunity
            wa.archivo.ContentType = 'text/csv';
            listaArchivos.add(wa);
        }
        negocio = Negocio__c.getOrgDefaults();
        } catch(Exception e) {
            System.debug('ERROR Constructor: ' + e.getStackTraceString() + ' - ' + e.getMessage());
        }
    }
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 04/03/2018
        * @param idOpp Id de un registro de Opportunity
        * @param idProd Id de un registro de QuoteLineItem
        * @description Constructor que inicializa los datos para generar CSV.
    **/
    public GenerarCSVSController(Id idOpp, Id idProd) {
        try {
            if(String.isNotBlank(idProd)) {
                List<QuoteLineItem> qlis = [SELECT Id, FormaPago__c, Facturacion1__c, Facturacion2__c, Pedidos__c, RecursosHumanos__c, Product2.NombreSistemas__c FROM QuoteLineItem WHERE Id=: idProd];
                if(qlis != null && qlis.size() > 0) {
                    qli = qlis[0];
                }
                //agrega calvarez 4mar2017
                List<OpportunityLineItem> olis = [SELECT Id, FormaPago__c FROM OpportunityLineItem WHERE PartidaPresupuesto__c =: idProd];
                if(olis != null && olis.size() > 0) {
                    oli = olis[0];
                }
            }

            oportunidad = [SELECT Id, Name,EnvioCSVOPAM__c, OwnerId, AccountId,IdCuentaOPAM__c,IdOportunidadOPAMNegocio__c , IdOportunidadOPAM__c, Producto__r.Producto__c, Producto__r.NumeroProducto__c, Facturacion1__c, Facturacion2__c, Pedidos__c, RecursosHumanos__c, Metodo_Pago__c, RegistroPatronalOPAM__c, Contacto__r.Extension__c, Contacto__r.Phone, Contacto__r.HomePhone, Contacto__r.Fax, Contacto__r.Email, Contacto__r.Salutation, Contacto__r.FirstName, Contacto__r.LastName, Contacto__r.AreaTrabajo__c, Contacto__r.Funcion__c FROM Opportunity WHERE Id =: idOpp];
            archivos = new list<Attachment>();
            listaArchivos = new list <WrapArchivo>();
            for(String tipoArchivo : tipoArchivos){
                WrapArchivo wa = new WrapArchivo();
                wa.archivo.Name = tipoArchivo ;
                // wa.archivo.ParentId = oportunidad.Id;
                wa.archivo.ParentId = oli.Id;//agrega calvarez 6mar2017 - asociar a OpportunityLineItem en lugar de Opportunity
                wa.archivo.ContentType = 'text/csv';
                listaArchivos.add(wa);
            }
            negocio = Negocio__c.getOrgDefaults();
        } catch(Exception e) {
            System.debug('GenerarCSVSController EX: ' + e);
            System.debug('ERROR Constructor: ' + e.getStackTraceString() + ' - ' + e.getMessage());
        }
    }
    
    public void GenerarArchivos() {
        System.debug('GenerarArchivos: ' + oportunidad + ', tipoArchivos: ' + tipoArchivos);
        //Hay que borrar los archivos existententes que contegan el nombre OCDR,OCPR ...PriceList2, ya que solo debe existir uno por oortunidad
        try {
            //List <Attachment> archivosBorrar =[Select Id from Attachment where ParentId =:oportunidad.Id AND Name In :tipoArchivos];
            List <Attachment> archivosBorrar =[Select Id from Attachment where ParentId =: oli.Id AND Name In :tipoArchivos];
            if(archivosBorrar.size() > 1) {
                delete archivosBorrar;
            }
            
        }catch(Exception e){
            
        }
        List<ProductoConcepto__c> tarifas = new List<ProductoConcepto__c>(); 
        try{
            if(qli != null && qli.Id != null) {
                tarifas = [SELECT Id, Concepto__r.TipoCargo__c, Concepto__r.Orden__c, Concepto__r.Obligatorio__c, PrecioLista__c, PrecioFinal__c, Bonificacion__c, Notas__c, PrecioLista2__c, Concepto__r.ClaveReferencia__c, Concepto__r.NombreSistemas__c, Concepto__r.CaracteristicasSolucion__c FROM ProductoConcepto__c WHERE PartidaPresupuesto__c=: qli.Id];
            }

             //tarifas = Database.query('SELECT tarifa__r.Subproducto__c,'+String.join(new List<String>(SObjectType.TarifaOportunidad__c.Fields.getMap().keySet()), ', ')+' FROM TarifaOportunidad__c Where oportunidad__c =\'' +oportunidad.Id+'\'');    
        } catch(Exception e) {
             tarifas = new List<ProductoConcepto__c>();
        }
        Account cuenta = (Account)Database.query('SELECT Owner.Name,'+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()), ', ')+' FROM Account Where id =\'' +oportunidad.AccountId+'\'');
        User usuario = [Select IdSAP__c from User where Id =: oportunidad.OwnerId  Limit 1];

        EntidadLegal__c entidad = new EntidadLegal__c();
        if( qli != null && qli.Id != null ) {
            for( EntidadLegal__c el: [SELECT Id, Name, RazonSocial__c FROM EntidadLegal__c WHERE  Id IN( SELECT Entidad_Legal__c FROM Contrato2__c WHERE PartidaPresupuesto__c =: qli.Id )  ]) {
                entidad = el;
                break;
            }
        }
        //  [SELECT Id,Name,Sector__c,Estado__c,subOrigen__c,CodigoClienteAS400__c,RazonSocial__c,Type,Phone,RFC__c,Owner.Name FROM Account WHERE Id =: oportunidad.AccountId];
        //  SObject contactos = Database.query('SELECT Facturacion1__r.'+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ',Facturacion1__r.')+',Facturacion2__r.'+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ',Facturacion2__r.')+',RecursosHumanos__r.'+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ',RecursosHumanos__r.')+',Pedidos__r.'+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ',Pedidos__r.')+' FROM Opportunity Where Id =\'' +oportunidad.Id+'\'');
        // [SELECT Id,Name,Account.CodigoClienteAS400__c FROM Contact WHERE AccountId =: oportunidad.AccountId];
        String usuario400 = '0123456789';//cuenta.IdCuentaOPAM__c;
        String idCuentaOPAM = oportunidad.IdCuentaOPAM__c == null ? obtenerIdOPAM('cuenta'): oportunidad.IdCuentaOPAM__c;
        String idOportunidadOPAM = oportunidad.IdOportunidadOPAMNegocio__c == null ? obtenerIdOPAM('oportunidad') : oportunidad.IdOportunidadOPAMNegocio__c;
        String sucursal = usuario400 != null && usuario400.length() >=10 ? usuario400.subString(0,2):'';
        String grupo = usuario400 != null && usuario400.length() >=10 ? usuario400.subString(3,7):'';
        String cliente = usuario400 != null && usuario400.length() >=10 ? usuario400.subString(8,10):'';
        
        /*OCRD*/
       
        String textOCDR;// = 'CLIENTE,RAZON SOCIAL,TIPO,GRUPO,TEL 1,TEL2,CREDITO,RFC,EJECUTIVO,,NOMBRE COMERCIAL,CUENTA SAP,TIPO,SECTOR,SUC FACTURA,SUC VENTA,GIRO,CVE ESTADO,,,,,COMPETENCIA \n';
        textOCDR = 'CardCode,CardName,CardType,GroupCode,Phone1,Phone2,PayTermsGrpCode,FederalTaxID,SalesPersonCode,Currency,CardForeignName,DebitorAccount,CompanyPrivate,Industry,VatIdUnCmp,'+
        'U_SucVtas,Notes,U_ClvEdo,U_U_MetodoPago,U_Notas_Pago,U_Cuenta_Origen,U_RegistroPatronal,U_idOrigenAlta\r\n';
        textOCDR += 'CardCode,CardName,CardType,GroupCode,Phone1,Phone2,GroupNum,LicTradNum,SlpCode,Currency,CardFName,DebPayAcct,CmpPrivate,IndustryC,VatIdUnCmp,U_SucVtas,Notes,U_ClvEdo,'+
            'U_U_MetodoPago,U_Notas_Pago,U_Cuenta_Origen,U_RegistroPatronal,U_idOrigenAlta\r\n';
        try{
            textOCDR += mayusculas(idCuentaOPAM) + ',' +mayusculas(esNulo(entidad.RazonSocial__c))+',cCustomer,345,'+((esNulo(cuenta.Phone)).length()<=10  ? esNulo(cuenta.Phone) :esNulo(cuenta.Phone).subString(0,10))+',,2,'+mayusculas((esNulo(entidad.Name)))+',' + (esNulo(usuario.IdSAP__C) != '' ? usuario.IdSAP__C : '-1') +',$,'+ 
             //mayusculas(esNulo(cuenta.Name))+',_SYS00000000047,cCompany,'+(Utils.MAP_SECTOR.containsKey(cuenta.Sector__c) ?String.valueOf(Integer.valueOf(Utils.MAP_SECTOR.get(cuenta.Sector__c))): '-1')+','+(esNulo(cuenta.SucursalFacturacion__c)).toUpperCase()+','+mayusculas(esNulo(cuenta.SucursalVentas__c))+','+mayusculas(esNulo(cuenta.Giro__c))+','+(Utils.MAP_ESTADOCLAVE.containsKey(cuenta.Estado__c)?Utils.MAP_ESTADOCLAVE.get(cuenta.Estado__c):(esNulo(cuenta.Estado__c)))+',NO IDENTIFICADO,'+getClaveMetodo(oportunidad.Metodo_Pago__c)+',NO IDENTIFICADO,'+esNulo((cuenta.RegistroPatronal__c).replaceAll(' ',''))+',58,'+'\r\n';
             //agrega calvarez 6mar2017
             // mayusculas(esNulo(cuenta.Name))+',_SYS00000000047,cCompany,'+(Utils.MAP_SECTOR.containsKey(cuenta.Sector__c) ?String.valueOf(Integer.valueOf(Utils.MAP_SECTOR.get(cuenta.Sector__c))): '-1')+','+(esNulo(cuenta.SucursalFacturacion__c)).toUpperCase()+','+mayusculas(esNulo(cuenta.SucursalVentas__c))+','+mayusculas(esNulo(cuenta.Giro__c))+','+(Utils.MAP_ESTADOCLAVE.containsKey(cuenta.Estado__c)?Utils.MAP_ESTADOCLAVE.get(cuenta.Estado__c):(esNulo(cuenta.Estado__c)))+',NO IDENTIFICADO,'+getClaveMetodo(oli.FormaPago__c)+',NO IDENTIFICADO,'+esNulo((cuenta.RegistroPatronal__c).replaceAll(' ',''))+',58,'+'\r\n';
             mayusculas(esNulo(cuenta.Name))+',_SYS00000000047,cCompany,'+(Utils.MAP_SECTOR.containsKey(cuenta.Sector__c) ?String.valueOf(Integer.valueOf(Utils.MAP_SECTOR.get(cuenta.Sector__c))): '9')+',MEXICO,MEXICO,'+mayusculas(esNulo(cuenta.Giro__c))+','+(Utils.MAP_ESTADOCLAVE.containsKey(cuenta.Estado__c)?Utils.MAP_ESTADOCLAVE.get(cuenta.Estado__c):(esNulo(cuenta.Estado__c)))+',NO IDENTIFICADO,'+getClaveMetodo(oli.FormaPago__c)+',NO IDENTIFICADO,'+(esNulo(oportunidad.RegistroPatronalOPAM__c).replaceAll(' ',''))+',58,'+'\r\n';
           // listaArchivos.get(0).archivo.body = Blob.valueOf(textOCDR);
            
        listaArchivos.get(0).archivo.body = Blob.valueOf('\uFEFF'+Utils.removeCaracteres(textOCDR));
        listaArchivos.get(0).archivo.ContentType = 'text/csv;charset=UTF-8';  
            // insert listaArchivos.get(0).archivo;
            listaArchivos.get(0).mensaje = 'OK';
        } catch(Exception e) {
            if(listaArchivos != null && listaArchivos.size() > 0) {
                listaArchivos.get(0).mensaje = 'Error:' + e.getMessage() + ', ' + e.getStackTraceString() + ', ';
           
            }
        }
        System.debug('textOCDR: ' + textOCDR);
        
        /*OCPR*/
        String textOCPR ;//= 'CLIENTE,CONSECUTIVO,TIPO CONTACTO,PUESTO,EXTENCION FAX,Tel1,Tel2,FAX,CORREO 1,CORREO 2,EXTENCION,NOMBRE,SEGUNDO NOMBRE,APELLIDOS,LADA,AREA,ABREVIATURA TITULO\n';
        textOCPR = 'ParentKey,LineNum,Name,Position,Address,Phone1,Phone2,Fax,U_EMail1,U_EMail2,Title,FirstName,MiddleName,LastName,Pager,Remarks1,Password\r\n';
        textOCPR += 'CardCode,LineNum,Name,Position,Address,Tel1,Tel2,Fax,U_EMail1,U_EMail2,Title,FirstName,MiddleName,LastName,Pager,Notes1,Password\r\n';
        Integer i=0;
        List<String> tiposContacto = new List<String>();
        tiposContacto.add('Facturacion 1__c');
        tiposContacto.add('Facturacion 2__c');
        tiposContacto.add('Pedidos__c');
        tiposContacto.add('Recursos Humanos__c');


        //SObject oportunidadAux = oportunidad comenta calvarez 17 mayo 2017 - se sustituye Opportunity por QuoteLineItem;
        SObject qliAux = qli;
        /*for(String actual: tiposContacto) {
            try {
                String idContacto = String.valueOf( qli.get(actual.replaceAll(' ','')));
                Contact contacto = Database.query('SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ',')+' FROM Contact where Id =: idContacto');

                textOCPR += idCuentaOPAM+',,'+mayusculas(actual.replace('__c',''))+','+mayusculas(actual.replace('__c',''))+','+esNulo(String.valueOf(contacto.Extension__c))+','+ esNulo(String.valueOf(contacto.Phone))+','+esNulo(String.valueOf(contacto.HomePhone))+','+esNulo(String.valueOf(contacto.Fax))+','+minusculas(esNulo(String.valueOf(contacto.Email)))+',,'+ mayusculas(esNulo(String.valueOf(contacto.Salutation)))+','+mayusculas(esNulo(String.valueOf(contacto.FirstName)))+',,'+mayusculas(esNulo(String.valueOf(contacto.LastName)))+',,'+mayusculas(esNulo(String.valueOf(contacto.AreaTrabajo__c)))+','+mayusculas(esNulo(String.valueOf(contacto.Salutation)))+  '\r\n'; 
            } catch(Exception e) {
                
            }
        }*/



        List<Contact> listContact = [SELECT Extension__c, Phone, HomePhone, Fax, Email, Salutation, FirstName, LastName, AreaTrabajo__c, Funcion__c FROM Contact WHERE AccountId =: cuenta.Id];
        Map<String, Contact> mapContacts = new Map<String, Contact>();
        Set<String> setContactos = new Set<String>(new List<String>{'Representante Legal', 'Quien decide', 'Quien solicita', 'Quien administra Plataforma'});

        for( Contact contacto: listContact ) {
            if( contacto.Funcion__c != null && setContactos.contains(contacto.Funcion__c) ) {
                mapContacts.put(contacto.Funcion__c, contacto);
            }
        }
        if(mapContacts != null && mapContacts.values().size() > 0 ) {
            Integer index = 0;
            for( String funcion: setContactos ) {
                String actual = tiposContacto[index++];
                Contact contacto = mapContacts.containsKey(funcion) && funcion != 'Representante Legal' ? mapContacts.get(funcion) : (oportunidad.Contacto__r == null ? new Contact() : new Contact(Extension__c = oportunidad.Contacto__r.Extension__c, Phone = oportunidad.Contacto__r.Phone, HomePhone = oportunidad.Contacto__r.HomePhone, Fax = oportunidad.Contacto__r.Fax, Email = oportunidad.Contacto__r.Email, Salutation = oportunidad.Contacto__r.Salutation, FirstName = oportunidad.Contacto__r.FirstName, LastName = oportunidad.Contacto__r.LastName, AreaTrabajo__c = oportunidad.Contacto__r.AreaTrabajo__c, Funcion__c = oportunidad.Contacto__r.Funcion__c));

                textOCPR += idCuentaOPAM+',,'+mayusculas(actual.replace('__c',''))+','+mayusculas(actual.replace('__c',''))+','+esNulo(String.valueOf(contacto.Extension__c))+','+ esNulo(String.valueOf(contacto.Phone))+','+esNulo(String.valueOf(contacto.HomePhone))+','+esNulo(String.valueOf(contacto.Fax))+','+minusculas(esNulo(String.valueOf(contacto.Email)))+',,'+ mayusculas(esNulo(String.valueOf(contacto.Salutation)))+','+mayusculas(esNulo(String.valueOf(contacto.FirstName)))+',,'+mayusculas(esNulo(String.valueOf(contacto.LastName)))+',,'+mayusculas(esNulo(String.valueOf(contacto.AreaTrabajo__c)))+','+mayusculas(esNulo(String.valueOf(contacto.Salutation)))+  '\r\n';
            }
        }

        System.debug('textOCPR: ' + textOCPR);
     /*   for(Contact contacto : contactos ){
          textOCPR += idCuentaOPAM+',,'+esNulo(contacto.TipoContacto__c)+','+esNulo(contacto.Puesto__c)+','+esNulo(contacto.Extension__c)+','+esNulo

        (contacto.Phone)+','+esNulo(contacto.HomePhone)+
                      ','+esNulo(contacto.Fax)+','+esNulo(contacto.Email)+',,'+esNulo(String.valueOf(contact.Extension__c))+','+esNulo(String.valueOf

        (contact.FirstName))+',,'+esNulo(String.valueOf(contact.LastName))+',,'+esNulo(String.valueOf(contact.AreaTrabajo__c))+','+esNulo(String.valueOf

        (contact.Title))+'\n';
                }*/
        if(listaArchivos != null && listaArchivos.size() > 0) {
            listaArchivos.get(1).archivo.body = Blob.valueOf('\uFEFF'+Utils.removeCaracteres(textOCPR));
            listaArchivos.get(1).archivo.ContentType = 'application/CSV;charset=UTF-8';   
             
            try{
                insert listaArchivos.get(1).archivo;
                listaArchivos.get(1).mensaje = 'OK';
            }catch(Exception e){
                listaArchivos.get(1).mensaje = 'Error:' + e.getMessage();
                
            }
            /*CRD1*/
            
            String textCRD1;// = 'CLIENTE,CONSECUTIVO,TIPO,CALLE,DEL/MUN,CP,CIUDAD,COLONIA,PAIS,CVE ESTADO,NO INTERIOR,TIPO DIRECCION,NO EXTERIOR \n';
            textCRD1 = 'ParentKey,LineNum,AddressName,Street,Block,ZipCode,City,County,Country,State,BuildingFloorRoom,AddressType,StreetNo\r\n';
            textCRD1 += 'CardCode,LineNum,Address,Street,Block,ZipCode,City,County,Country,State,Building,AdresType,StreetNo\r\n';
            /*comenta calvarez 28feb2017 if(tarifas!= null && tarifas.size() > 0 &&  tarifas[0].subProductos__c != null) {
                for(Integer k = 0; k < tarifas[0].subProductos__c.split(',').size(); k++){
                    textCRD1 +=idCuentaOPAM+','+k+','+mayusculas(esNulo(String.valueOf(tarifas[0].subProductos__c.split(',')[k].trim())))+','+mayusculas(esNulo(cuenta.Calle__c))+','+mayusculas(esNulo(cuenta.DelegacionMunicipioFiscal__c))+','+esNulo(cuenta.CodigoPostal__c)+','+mayusculas(esNulo(cuenta.Ciudad__c))+','+mayusculas(esNulo(cuenta.Colonia__c))+',MX,'+ esNulo(Utils.MAP_ESTADOCLAVEDOS.containsKey(cuenta.Estado__c)?Utils.MAP_ESTADOCLAVEDOS.get(cuenta.Estado__c):(cuenta.Estado__c))+','+esNulo(cuenta.NumeroInterior__c)+',bo_BillTo,'+esNulo(cuenta.NumeroExterior__c)+'\r\n';
                }
            }*/

            //agrega calvarez 11 mayo 2017 - Dirección de entrega, 8 junio 2017 agregar address
            cuenta.Ciudad__c=cuenta.Ciudad__c=='CDMX'?'DF':cuenta.Ciudad__c;
            cuenta.Ciudad__c=cuenta.Estado__c=='CDMX'?'DF':cuenta.Estado__c;
            textCRD1 += idCuentaOPAM + ',0,' + mayusculas(qli.Product2.NombreSistemas__c) + ',' + mayusculas(esNulo(cuenta.Calle__c)) + ',' + mayusculas(esNulo(cuenta.DelegacionMunicipioFiscal__c)) + ',' + esNulo(cuenta.CodigoPostal__c) + ',' + mayusculas(esNulo(cuenta.Ciudad__c)) + ',' + mayusculas(esNulo(cuenta.Colonia__c)) + ',MX,' + esNulo(Utils.MAP_ESTADOCLAVEDOS.containsKey(cuenta.Estado__c) ? Utils.MAP_ESTADOCLAVEDOS.get(cuenta.Estado__c) : (cuenta.Estado__c)) + ',' + esNulo(cuenta.NumeroInterior__c) + ',bo_BillTo,' + esNulo(cuenta.NumeroExterior__c) + '\r\n';

            // listaArchivos.get(2).archivo.body = Blob.valueOf(textCRD1);
            //if(tarifas.size()!=0)
                //System.debug('Sub productos : '+tarifas[0].subProductos__c);
            listaArchivos.get(2).archivo.body = Blob.valueOf('\uFEFF'+Utils.removeCaracteres(textCRD1));
            listaArchivos.get(2).archivo.ContentType = 'text/csv;charset=UTF-8';  
            try{
                insert listaArchivos.get(2).archivo;
                listaArchivos.get(2).mensaje = 'OK';
            }catch(Exception e){
                listaArchivos.get(2).mensaje = 'Error:' + e.getMessage();
                
            }

            System.debug('textCRD1: ' + textCRD1);
            
            /*PriceLists1*/
            String textPriceLists1='' ;//= 'CONSECUTIVO,CLIENTE\n';
            textPriceLists1 += 'Code,Name\r\n';
            textPriceLists1 += 'Code,Name\r\n';
            textPriceLists1+=idOportunidadOPAM+','+idCuentaOPAM+'\n';
         //   listaArchivos.get(3).archivo.body = Blob.valueOf(textPriceLists1);
                    
            listaArchivos.get(3).archivo.body = Blob.valueOf('\uFEFF'+Utils.removeCaracteres(textPriceLists1));
            listaArchivos.get(3).archivo.ContentType = 'text/csv;charset=UTF-8';  

            System.debug('textPriceLists1: ' + textPriceLists1);
            
            try{
                insert listaArchivos.get(3).archivo;
                listaArchivos.get(3).mensaje = 'OK';
            }catch(Exception e){
                listaArchivos.get(3).mensaje = 'Error:' + e.getMessage();
               
            }
            /*PriceLists2*/
            
            String textPriceLists2 ;//= 'CONSECUTIVO,,CONSECUTIVO,ARTICULO PROD,NOMBRE PRODUCTO ,,COSTO,,PORCENTAJE,,\n';
            textPriceLists2 = 'ParentKey,LineNum,Code,U_ItemCode,U_Group,U_PriceIU,U_PriceP,U_ComIU,U_ComP,U_FechaAlta\r\n';
            textPriceLists2 += 'Code,LineNum,Code,U_ItemCode,U_Group,U_PriceIU,U_PriceP,U_ComIU,U_ComP,U_FechaAlta\r\n';
           String fechaHoy = Datetime.now().formatGMT(' yyyy-MM-dd '); 
            for(ProductoConcepto__c tarifa : tarifas) {
                //comenta calvarez 27feb2017 textPriceLists2 += idOportunidadOPAM+',,'+idOportunidadOPAM+','+esNulo(tarifa.ClaveReferencia__c)+','+esNulo(tarifa.tarifa__r.Subproducto__c)+',0,'+(tarifa.Importe__c!=null?tarifa.Importe__c:0)+',0,'+(tarifa.Porcentaje__c==null? 0 : tarifa.Porcentaje__c)+','+fechaHoy+',\r\n';
                
                //comenta calvarez 9 junio 2017 Decimal precioLista = (tarifa.PrecioFinal__c != null && tarifa.PrecioFinal__c != 0) ? tarifa.PrecioFinal__c : (tarifa.PrecioLista__c != null ? tarifa.PrecioLista__c : 0);
                Decimal precioLista = tarifa.Bonificacion__c != 0 ? tarifa.PrecioFinal__c : (tarifa.PrecioLista__c != null ? tarifa.PrecioLista__c : 0);
                if(tarifa.Concepto__r.TipoCargo__c == COM_EMI) {
                    //comenta calvarez 9 junio 2017 precioLista = (tarifa.PrecioFinal__c != null && tarifa.PrecioFinal__c != 0) ? tarifa.PrecioFinal__c : (tarifa.PrecioLista2__c != null ? tarifa.PrecioLista2__c : 0);
                    precioLista = tarifa.Bonificacion__c != 0 ? tarifa.PrecioFinal__c : (tarifa.PrecioLista2__c != null ? tarifa.PrecioLista2__c : 0);
                }
                //agrega Concepto__r.NombreSistemas__c en lugar de Subproducto__c - calvarez 30 mayo 2017
                //comenta calvarez 31 mayo 2017 - nuevos campos a enviar textPriceLists2 += idOportunidadOPAM + ',,' + idOportunidadOPAM + ',' + esNulo(tarifa.Concepto__r.ClaveReferencia__c) + ',' + esNulo(tarifa.Concepto__r.NombreSistemas__c) + ',0,' + precioLista + ',0,' + (tarifa.Bonificacion__c==null? 0 : tarifa.Bonificacion__c) + ',' + fechaHoy + ',\r\n';
                textPriceLists2 += idOportunidadOPAM + ',,' + idOportunidadOPAM + ',' + esNulo(tarifa.Concepto__r.ClaveReferencia__c) + ',' + esNulo(tarifa.Concepto__r.CaracteristicasSolucion__c) + ',0,' + (tarifa.Concepto__r.TipoCargo__c != COM_EMI ? precioLista : 0) + ',0,' + (tarifa.Concepto__r.TipoCargo__c == COM_EMI ? precioLista : 0) + ',' + fechaHoy + ',\r\n';
                
            }
          //  listaArchivos.get(4).archivo.body = Blob.valueOf(textPriceLists2);
            
            listaArchivos.get(4).archivo.body = Blob.valueOf('\uFEFF'+Utils.removeCaracteres(textPriceLists2));
            listaArchivos.get(4).archivo.ContentType = 'text/csv;charset=UTF-8'; 
            try{
                insert listaArchivos.get(4).archivo;
                listaArchivos.get(4).mensaje = 'OK';
            }catch(Exception e){
                listaArchivos.get(4).mensaje = 'Error:' + e.getMessage();
               
            }
            system.debug('oportunidad.IdCuentaOPAM__c************************');
            //Crear el encabezado de los demas archivos... aun no estoy seguro como llenarlo
           /* if(oportunidad.IdCuentaOPAM__c == null && oportunidad.IdOportunidadOPAMNegocio__c == null) {
                try {
                    system.debug('oportunidad.IdCuentaOPAM__c');
                    oportunidad.IdCuentaOPAM__c = idCuentaOPAM;
                    oportunidad.IdOportunidadOPAMNegocio__c = idOportunidadOPAM;
                    //update oportunidad;
                    negocio.IdCuentaOPAM__c = negocio.IdCuentaOPAM__c + 1;
                    negocio.IdOportunidadOPAM__c = negocio.IdOportunidadOPAM__c + 1;
                    update negocio;                
                } catch(Exception e) {
                    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage()));
					
                }            
            }*/
            System.debug('textPriceLists2: ' + textPriceLists2);
            
            enviarMail(); 
            oportunidad.EnvioCSVOPAM__c = true;
            
        }
    
    }
    
    public void enviarMail() {

         Negocio__c negocio = Negocio__c.getOrgDefaults();

         String direccionesEnvio = negocio.EmailCSV__c; 
         System.debug('enviarMail - negocio: ' + negocio + '\nlistaArchivos: ' + listaArchivos);
         String body = '';
         list<Messaging.EmailFileAttachment> listaAdjuntos = new list<Messaging.EmailFileAttachment>();
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
         
         for(WrapArchivo wa : listaArchivos){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(wa.archivo.Name);
            efa.setBody(wa.archivo.body);
            listaAdjuntos.add(efa);
         }
         
         String[] toAddresses = direccionesEnvio.split(',');
         email.setSubject( 'Oportunidad:' + oportunidad.Name + ' Archivos CSV' );
         email.setToAddresses( toAddresses );
         email.setPlainTextBody( body );
         email.setFileAttachments(listaAdjuntos);
         try{
             Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
             System.debug(email);
             if(r[0].isSuccess())
                 PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'Se han generado todos los archivos y se han enviado por correo ' ));
             else{
                 List<Messaging.SendEmailError> errores = r[0].getErrors();
                 //System.debug(errores);
                 PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al enviar los correros:' + errores ));
             }
         }catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Error al enviar los correos:' + e.getMessage()));
            System.debug('error enviarMail: ' + e + ', ' + e.getMessage() + ', ' + e.getStackTraceString());
         }
    }
    
    public String esNulo(String campo){
        if(campo==null) {
            return '';
        } else {
            return (campo.replaceAll(',', ' ')).trim();
        }
    }
    
    public String mayusculas(String campo){
        if(campo != null){
            return campo.toUpperCase();
        } else{
            return campo;
        }
    }
    
    public String minusculas(String campo){
        if(campo != null){
            return campo.toLowerCase();
        } else{
            return campo;
        }
    }
    
    public string obtenerIdOPAM(String tipo){
        String idOPAM = '';
        if(tipo == 'cuenta'){
           idOPAM = 'CTE' + (negocio != null && negocio.IdCuentaOPAM__c != null ? (negocio.IdCuentaOPAM__c + '') : ''); 
        }else if(tipo == 'oportunidad' && negocio != null && negocio.IdOportunidadOPAM__c != null){
           idOPAM = String.valueOf(negocio.IdOportunidadOPAM__c);
        }
        idOPAM = idOPAM.replace('.0','');
        return idOPAM;
    }

    public String getClaveMetodo(string metodo) {
        String metodoPago = '';
        /* if( metodoPago == 'Transferencia electrónica' ) {
            metodoPago = '03';
        } else if( metodoPago == 'American Express' ) {
            metodoPago = '04';
        } else if( metodoPago == 'Deposito' ) {
            metodoPago = '99';
        } else {
            metodoPago = '01';
        } */
        /*if(metodo=='Efectivo'){
            metodoPago='01';
        }
        else if(metodo=='Cheque nominativo'){
            metodoPago='02';
        }
        else if(metodo=='Transferencia electrónica de fondos'){
            metodoPago='03';
        }
        else if(metodo=='Tarjeta de Crédito'){
            metodoPago='04';
        }
        else if(metodo=='Monedero electrónico'){
            metodoPago='05';
        }
        else if(metodo=='Dinero electrónico'){
            metodoPago='06';
        }
        else if(metodo=='Vales de despensa'){
            metodoPago='08';
        }
        else if(metodo=='Tarjeta de débito'){
            metodoPago='28';
        }
        else if(metodo=='Tarjeta de servicios'){
            metodoPago='29';
        }
        else if(metodo=='Otros'){
            metodoPago='99';
        }
        else if(metodo=='NA'){
            metodoPago='98';
        }
        else{
            metodoPago='98';
        }*/

        return metodoPago;
    }
}