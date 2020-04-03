public class NameLessConnection {
    public static Log__c logApp{get;set;}
    public static Integer totalRecords{get;set;}
    public static List<BitacoraIntegracion__c> bitacora{get;set;}
    
    public static HttpResponse CreateConnection(HttpRequest request){
        Http http = new Http();
        system.debug('request: '+request);
        //system.debug('body: '+request.getBody());
        HttpResponse response =new  HttpResponse();
        try{
            response = http.send(request);
        }catch(CalloutException ex){            
            //createBitacora('No se logro crear la conexion ','Error: ' +ex.getMessage());
            system.debug('Error CreateConnection: '+ ex.getMessage() );
            return response;
        }        
        System.debug('FIN CREATECON:'+response);
        return response;
    }
    public class respWP{
        @AuraEnabled public String tipo{get;set;}
        @AuraEnabled public String msj{get;set;}
    }
    @AuraEnabled
    public static respWP oneExcute(String sucursal, String producto,String grupo,String cliente){      
        respWP res=new respWP();
        try{
            String cod=getLegacy(sucursal,producto,grupo,cliente);
            System.debug('CODIGO:'+cod);
            List<ContratoFilial__c> filiales = [SELECT id,CodigoAS400__c,Entidad_Cuenta__c from ContratoFilial__c where CodigoAS400__c=:cod];
            if(filiales!=null&&filiales.size()>0){
                res.tipo='warning';
                res.msj='La SubCuenta ya existe';
                return res;
            }else{
                string token =getToken();
                System.debug('TOKENN::'+token);
                if(token!=null){                  
                    MuleSoftJSON data = new MuleSoftJSON();  
                    map<string,MuleSoftJSON.cls_customers> mapa =new  map<string,MuleSoftJSON.cls_customers>();
                    data=GetCustomerIdentifier(sucursal,producto,grupo,cliente,token);
                    System.debug('GetCustomerIdentifier:: '+JSON.serialize(data));
                    mapa=DataBindOnly(data);
                    System.debug('MAPAAA:::'+JSON.serialize(mapa));
                    createObject(mapa);
                    System.debug('DataBind:: '+mapa);
                    res.tipo='success';
                    res.msj='La información se creo correctamente';
                    return res;
                }else{
                    res.tipo='error';
                    res.msj='El token no se generó correctamente';
                    return res;
                }
            }
        }catch(exception ex){
            createBitacora('Error Excute:' ,'Error: ' +ex);
            createBitacora();
            res.tipo='error';
            res.msj=ex.getMessage();
            return res;
        }
    }
    
    /*public static void Excute(){
        decimal total=1;            
        try{
            string token =getToken();
            if(token!=null){               
                for(Integer paginas=1;paginas<=total;paginas++){
                    MuleSoftJSON data =GetCustomerFilter((Integer)paginas,40,token);
                    system.debug('data# '+data);
                    map<string,MuleSoftJSON.cls_customers> mapaBind= new  map<string,MuleSoftJSON.cls_customers>();                    
                    mapaBind=DataBind(data);
                    system.debug('#mapaBind# '+mapaBind);
                    if(!mapaBind.isEmpty()){
                        map<string,MuleSoftJSON.cls_customers> detail= new  map<string,MuleSoftJSON.cls_customers>();
                        detail=getDetail(mapaBind,token); 
                        if(!detail.isEmpty()){
                            createObject(detail);
                        }
                    }else{
                        createBitacora('Se finalizo la ejecución pagina: '+paginas+' de '+ total,'Ya existe toda la informacion '+JSON.serialize(data));
                        createBitacora();
                    } 
                    //total=(decimal)data.data.paging.total_records;
                    //total=(total/40).round(System.RoundingMode.UP)-1;
                    total=1;
                }
            }
        }
        catch(exception ex){
            createBitacora('Error Excute:' ,'Error: ' +ex);
            createBitacora();
        }
    }*/
    
    public static String  getToken(){
        String endPoint = Negocio__c.getOrgDefaults().TokenUrl__c;        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setMethod('POST');
        request.setBody('client_id='+Negocio__c.getOrgDefaults().ClientId__c+'&client_secret='+Negocio__c.getOrgDefaults().Client_Secret__c+'&grant_type='+Negocio__c.getOrgDefaults().Grant_type__c+'&scope='+Negocio__c.getOrgDefaults().scope__c);        
        HttpResponse response =new  HttpResponse();
        response=CreateConnection(request);
        if (response.getStatusCode() == 200) {
            Map<String,Object> obj = (Map<String,    Object>)JSON.deserializeUntyped(response.getBody());
            System.debug(EncodingUtil.urlDecode((String)obj.get('access_token'), 'UTF-8'));    
            return 'Bearer '+EncodingUtil.urlDecode((String)obj.get('access_token'), 'UTF-8');
        }
        
        return '';                 
    }
    
    /*public static MuleSoftJSON GetCustomerFilter(Integer pagina,integer registros,string token ){ 
        String endPoint = Negocio__c.getOrgDefaults().NameLessRead__c;
        HttpRequest request = new HttpRequest();
        MuleSoftJSON data = new MuleSoftJSON();
        Datetime fecha= Datetime.newInstance(Datetime.now().year(),Datetime.now().month(),Datetime.now().day(),0,0,1);
        system.debug('fecha '+fecha.addDays(-1));
        system.debug('fecha fin'+fecha.addHours(24));
        request.setEndpoint(endPoint+getParamsCustomerFilter(fecha.addDays(-1),fecha.addHours(24),registros,pagina));
        request.setMethod('GET');
        try{
            
            request.setHeader('authorization',token);
            HttpResponse response =new  HttpResponse();
            response=CreateConnection(request); 
            system.debug('response GetCustomerFilter'+response);
            
            if (response.getStatusCode() == 200) {
                system.debug('reponse : '+response.getBody());
                response.getBody().replace('group','groupx');
                response.getBody().replace('number','numberx');
                response.getBody().replace('type','typex');
                data = (MuleSoftJSON)JSON.deserialize((String)response.getBody(),MuleSoftJSON.class); 
            }
            system.debug('data, GetCustomerFilter '+data);
        }catch(exception  ex ){
            createBitacora('Ocurrio un error en GetCustomerFilter',ex.getMessage());
            return null;
        }
        
        return data;
    }*/
    
    
    public static MuleSoftJSON GetCustomerIdentifier(String branch,String product,String groupx,String identifier,String token){ 
        String endPoint = Negocio__c.getOrgDefaults().NameLess_ByIdentifie__c;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint+getParamsCustomerIdentifier(identifier, product, branch, groupx, 1, 1));
        request.setMethod('GET');
        request.setHeader('authorization',token);
        System.debug('END::'+endPoint+getParamsCustomerIdentifier(identifier, product, branch, groupx, 1, 1));
        System.debug('END2::'+token);
        HttpResponse response =new  HttpResponse();
        response=CreateConnection(request); 
        system.debug('');
        if (response.getStatusCode() == 200) {
            system.debug('reponse : '+response.getBody());
            //response.setBody(response.getBody().replace('group','groupx'));
            //response.setBody(response.getBody().replace('number','numberx'));
            response.setBody(response.getBody().replace('type','typex'));
            response.setBody(response.getBody().replace('data','dataOnly'));
            system.debug('response *##***###'+response.getBody());
            return (MuleSoftJSON)JSON.deserialize((String)response.getBody(),MuleSoftJSON.class);              
        }
        return null;
    }
    
   /* public static  map<string,MuleSoftJSON.cls_customers> DataBind(MuleSoftJSON data){
        set<String> legacyList = new set<String>();
        set<String> taxList = new set<String>();
        set<String> groupList = new set<String>();
        List<String> legacyCreatedList = new List<String>();
        map<string,MuleSoftJSON.cls_customers> legacyMap =new map<string,MuleSoftJSON.cls_customers>(); 
        map<string,MuleSoftJSON.cls_customers> legacyMapFaltantes =new map<string,MuleSoftJSON.cls_customers>(); 
        String cadena='';
       
        for(MuleSoftJSON.cls_customers customer: data.data.customers ){            
            cadena=getLegacy(customer.branch_identifier,customer.product_identifier,customer.group_identifier,customer.identifier);
            system.debug('cadena '+cadena);
            if(!legacyMap.containsKey(cadena )&&cadena!=null){
                legacyMap.put(cadena,customer);
            }               
        }
        System.debug('LEGACY:'+JSON.serialize(legacyMap));
        legacyMapFaltantes=SearchFilial(legacyMap,true); 
        
        
        legacyMapFaltantes=SearchEntidadLegal(legacyMapFaltantes);
        legacyMapFaltantes=SearchGroup(legacyMapFaltantes);
        system.debug('$$$$$$$$$$$$$$$$ '+legacyMapFaltantes);
        return legacyMapFaltantes;
        
    }*/
    
    public static  map<string,MuleSoftJSON.cls_customers> DataBindOnly(MuleSoftJSON data){
        set<String> legacyList = new set<String>();
        set<String> taxList = new set<String>();
        set<String> groupList = new set<String>();
        List<String> legacyCreatedList = new List<String>();
        map<string,MuleSoftJSON.cls_customers> legacyMap =new map<string,MuleSoftJSON.cls_customers>(); 
        map<string,MuleSoftJSON.cls_customers> legacyMapFaltantes =new map<string,MuleSoftJSON.cls_customers>(); 
        String cadena='';
       
        system.debug('cadena '+data.dataOnly);
        system.debug('cadena '+data.dataOnly.customer.group_identifier);
            cadena=getLegacy(data.dataOnly.customer.branch_identifier,data.dataOnly.customer.product_identifier,data.dataOnly.customer.group_identifier,data.dataOnly.customer.identifier);
            system.debug('cadena '+cadena);
            if(!legacyMap.containsKey(cadena )&&cadena!=null){
                legacyMap.put(cadena,data.dataOnly.customer);
            }               
        
        System.debug('LEGACY:'+JSON.serialize(legacyMap));
        legacyMapFaltantes=SearchFilial(legacyMap,true); 
        
        
        legacyMapFaltantes=SearchEntidadLegal(legacyMapFaltantes);
        legacyMapFaltantes=SearchGroup(legacyMapFaltantes);
        system.debug('$$$$$$$$$$$$$$$$ '+legacyMapFaltantes);
        return legacyMapFaltantes;
        
    }
    
    /*public static map<string,MuleSoftJSON.cls_customers> getDetail( map<string,MuleSoftJSON.cls_customers> mapa,string token){
        //https://dev-salesforce-nameless-experience-api.us-e1.cloudhub.io/api/customers/130?product_identifier=30&branch_identifier=1&group_identifier=3568&all=true&page_size=10&page_index=1
        List<MuleSoftJSON> infoList= new List<MuleSoftJSON>();
        MuleSoftJSON data;
        system.debug('Mapita '+mapa);
        string cadena='';
        for(MuleSoftJSON.cls_customers datos :mapa.values()){
            system.debug('---DatosCuenta:'+ datos.Cuenta);
                system.debug('Cuenta '+datos.Cuenta);
                data= new MuleSoftJSON();
                cadena='';
                data=GetCustomerIdentifier(datos.branch_identifier,datos.product_identifier,datos.group_identifier,datos.identifier,token );
                system.debug('@@@@@@@@@@@@@@@@@@@@@@ '+data);
                if(data!=null){
                    cadena=getLegacy(datos.branch_identifier,datos.product_identifier,datos.group_identifier,datos.identifier); 
                    data.dataOnly.customer.EntidadCuenta=datos.EntidadCuenta;
                    data.dataOnly.customer.EntidadLegal=datos.EntidadLegal;
                    data.dataOnly.customer.Cuenta=datos.Cuenta;
                    data.dataOnly.customer.ContratoFilial=datos.ContratoFilial;
                    //data.dataOnly.customer.address=data.ContratoFilial;
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@ '+data.dataOnly.customer);
                    mapa.put(cadena,data.dataOnly.customer);                         
                }                              
            
        }
        return mapa;
        
    }*/
    
    
    
    
    public static map<string,MuleSoftJSON.cls_customers>  createObject( map<string,MuleSoftJSON.cls_customers> mapa){
        System.debug('MAPADATOS::'+JSON.serialize(mapa));
        List<Account> cuentas =  new List<Account>();
        Set<String> groupx =  new Set<String>();
        Set<String> rfs =  new Set<String>();
        Set<String> setFilial =  new Set<String>();
        List<EntidadLegal__c> entidadesLegales =  new List<EntidadLegal__c>();
        List<ContratoFilial__c> filiales =  new List<ContratoFilial__c>();
        string cadena='';
        
        for(MuleSoftJSON.cls_customers datos :mapa.values()){
            cadena=getLegacy(datos.branch_identifier,datos.product_identifier,datos.group_identifier,datos.identifier);
            system.debug('datos : '+JSON.serialize(datos));
            system.debug('cuenta : '+datos.Cuenta);
            if(datos.Cuenta==null){                
                datos.Cuenta=new Account(name=datos.commercial_name,phone=datos.phone,CodigoClienteAS400__c=datos.group_identifier,NumeroEmpleados__c='126-250',Calle__c=datos.address.street,
                                         NumeroExterior__c=datos.address.building_number,NumeroInterior__c=datos.address.internal_number,Colonia__c=datos.address.city,CodigoPostal__c=datos.address.zip_code  );
                if(!groupx.contains(datos.group_identifier)){
                    cuentas.add(datos.Cuenta);
                    groupx.add(datos.group_identifier);
                }
                
            }                                   
            mapa.put(cadena,datos);   
        }
        if(!cuentas.isEmpty()){
            Database.SaveResult[] srList = Database.insert(cuentas, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.'); 
                        createBitacora('Error al insertar cuentas ', err.getFields() +' '+err.getMessage());
                    }
                }
            }           
        }
        system.debug('Lista de cuentas:'+mapa);
        system.debug('Lista de cuentas:'+cuentas);
        mapa=SearchGroup(mapa);
        system.debug('Lista de cuentasmapamapamapamapa :'+mapa);
        try{
            for(MuleSoftJSON.cls_customers datos :mapa.values()){
                cadena=getLegacy(datos.branch_identifier,datos.product_identifier,datos.group_identifier,datos.identifier);
                System.debug('::Datos::'+JSON.serialize(datos));
                if(datos.EntidadLegal==null){
                    Id tipoRegistro;
                    if(datos.tax_kind==0){
                        tipoRegistro=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Moral').getRecordTypeId();
                    }else{
                        tipoRegistro=Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId();
                    }
                    datos.EntidadLegal=new EntidadLegal__c(name=datos.tax_payer_identifier,Cuenta__c=datos.Cuenta.id,RFC__c=datos.tax_payer_identifier,RazonSocial__c=datos.commercial_name,Calle__c=datos.address.street,
                                                           NumeroExterior__c=datos.address.building_number,NumeroInterior__c=datos.address.internal_number,Colonia__c=datos.address.city,CodigoPostal__c=datos.address.zip_code,RecordTypeId= tipoRegistro );                               
                    if(!rfs.contains(datos.tax_payer_identifier)){
                        entidadesLegales.add( datos.EntidadLegal);
                        rfs.add(datos.tax_payer_identifier);
                    }
                    
                } 
                system.debug('datos.EntidadLegal'+datos.EntidadLegal);
            }
            if(!entidadesLegales.isEmpty()){
                Database.SaveResult[] srList = Database.insert(entidadesLegales, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.'+err.getFields() +' '+err.getMessage()); 
                            createBitacora('Error al insertar Entidades Legales ', err.getFields() +' '+err.getMessage());
                        }
                    }
                }        
            }
            
            mapa=SearchEntidadLegal(mapa);
            for(MuleSoftJSON.cls_customers datos :mapa.values()){
                cadena=getLegacy(datos.branch_identifier,datos.product_identifier,datos.group_identifier,datos.identifier);
                if(datos.ContratoFilial==null){
                    datos.ContratoFilial=new ContratoFilial__c(name=cadena,CodigoAS400__c=cadena,Entidad_Cuenta__c=datos.EntidadCuenta.id );  
                    system.debug('filiales  ****: '+datos.ContratoFilial);
                    if(!setFilial.contains(cadena)){
                        filiales.add(datos.ContratoFilial); 
                        setFilial.add(cadena); 
                    }
                    
                }
            }
            
            if(!filiales.isEmpty()){
                Database.SaveResult[] srList = Database.insert(filiales, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.'+err.getFields() +' '+err.getMessage()); 
                            createBitacora('Error al insertar filiales ', err.getFields() +' '+err.getMessage());
                        }
                    }
                }    
                
            } 
        }
        catch(exception ex){
            System.debug('ERROR::'+ex.getMessage()+',Linea::'+ex.getLineNumber());
            // createBitacora('Error Al crear Objetos',ex.getMessage());
            //createBitacora(cuentas,entidadesLegales, filiales); 
        }
        //mapa=SearchFilial(mapa,false);   
        system.debug('Mapa Final: '+mapa);
        createBitacora(cuentas,entidadesLegales, filiales);
        return mapa;
        
    }
    
    
    public static void createBitacora(List<Account> cuentas,List<EntidadLegal__c> entidadesLegales, List<ContratoFilial__c> filiales){
        List<BitacoraIntegracion__c> bit = new List<BitacoraIntegracion__c>();
        if(logApp==null){
            logApp=new Log__c(Nombre_aplicacion__c='Nameless');
            insert logApp;
        }
        createBitacora('Finalizo la ejecución','');
        if(cuentas!=null&&entidadesLegales!=null&&filiales!=null){
            if(cuentas.isEmpty()&&entidadesLegales.isEmpty()&&filiales.isEmpty()){
                bit.add(new BitacoraIntegracion__c(Descripcion__c='No se creo ningun archivo'));
            }else{
                for(Account cuenta :cuentas){
                    if(cuenta.id!=null)
                        bit.add(new BitacoraIntegracion__c(Descripcion__c='Se creo la siguiente información',Cuenta__c=cuenta.id,Log__c=logApp.id));
                }
                for(EntidadLegal__c cuenta :entidadesLegales){
                    if(cuenta.id!=null)
                        bit.add(new BitacoraIntegracion__c(Descripcion__c='Se creo la siguiente información',EntidadLegal__c=cuenta.id,Log__c=logApp.id));
                }
                for(ContratoFilial__c cuenta :filiales){
                    if(cuenta.id!=null)
                        bit.add(new BitacoraIntegracion__c(Descripcion__c='Se creo la siguiente información',ContratoFilial__c=cuenta.id,Log__c=logApp.id));
                }                           
            }
            
        }
        
        if(!bitacora.isEmpty()){
            for(BitacoraIntegracion__c bita:bitacora){
                bit.add(bita);
            }
        }
        
        if(!bit.isEmpty())
            insert bit;
    }
    
    public static void createBitacora(String mensaje,String error){
        if(logApp==null){
            logApp=new Log__c(Nombre_aplicacion__c='Nameless');
            insert logApp;
        }
        if(bitacora==null){
            bitacora = new List<BitacoraIntegracion__c>();
        }         
        bitacora.add(New BitacoraIntegracion__c(Descripcion__c=mensaje,Mensaje_Error__c=error,Log__c=logApp.id));
    }
    
    public static void createBitacora(){
        if(logApp==null){
            logApp=new Log__c(Nombre_aplicacion__c='Nameless');
            insert logApp;
        } 
        if(bitacora!=null)
            insert bitacora;
    }
    
    
    
    
    public static map<string,MuleSoftJSON.cls_customers> SearchFilial( map<string,MuleSoftJSON.cls_customers> mapa, Boolean remove){
        List<ContratoFilial__c> filiales = [SELECT id,CodigoAS400__c,Entidad_Cuenta__c from ContratoFilial__c where CodigoAS400__c=:mapa.keySet() ];
        String cadena='';
        for(ContratoFilial__c filial: filiales){
            if(mapa.containsKey(filial.CodigoAS400__c)&&remove){
                mapa.remove(filial.CodigoAS400__c);
            }
            if(remove==false){
                for(MuleSoftJSON.cls_customers values: mapa.values()){
                    cadena=getLegacy(values.branch_identifier,values.product_identifier,values.group_identifier,values.identifier);
                    values.ContratoFilial=filial;
                    mapa.put(cadena,values); 
                }
            }
        }
        system.debug('SearchFilial '+mapa);
        return mapa;
        
    }
    public static map<string,MuleSoftJSON.cls_customers> SearchEntidadLegal( map<string,MuleSoftJSON.cls_customers> mapa){
        String cadena='';
        set<String> taxList = new set<String>(); 
        for(MuleSoftJSON.cls_customers values :mapa.values()){
            if(!taxList.contains(values.tax_payer_identifier)){
                taxList.add(values.tax_payer_identifier);
            }
        }
        for( EntidadCuenta__c entidadLegal : [SELECT id,Name,EntidadLegal__c,RFC_IDExterno__c,Cuenta__c from EntidadCuenta__c where Name=:taxList ]){
            cadena='';
            for(MuleSoftJSON.cls_customers values: mapa.values()){
                if(values.tax_payer_identifier==entidadLegal.Name){
                    cadena=getLegacy(values.branch_identifier,values.product_identifier,values.group_identifier,values.identifier);
                    values.EntidadCuenta=entidadLegal;
                    values.EntidadLegal=new EntidadLegal__c(id=entidadLegal.EntidadLegal__c);
                    mapa.put(cadena,values); 
                }
            }
        }
        system.debug('SearchEntidadLegal '+mapa);
        return mapa;
        
    }
    public static map<string,MuleSoftJSON.cls_customers> SearchGroup( map<string,MuleSoftJSON.cls_customers> mapa){
        String cadena='';
        set<String> groupList = new set<String>(); 
        for(MuleSoftJSON.cls_customers values :mapa.values()){
            if(!groupList.contains(values.group_identifier)){
                groupList.add(values.group_identifier);
            }
        }
        for( Account cuenta : [SELECT id,Name,CodigoClienteAS400__c from Account where CodigoClienteAS400__c=:groupList ]){
            cadena='';
            for(MuleSoftJSON.cls_customers values: mapa.values()){                 
                if(values.group_identifier==cuenta.CodigoClienteAS400__c){   
                    system.debug('######################## '+cuenta.CodigoClienteAS400__c);
                    cadena=getLegacy(values.branch_identifier,values.product_identifier,values.group_identifier,values.identifier);
                    values.Cuenta=cuenta;                   
                    mapa.put(cadena,values);                      
                }
            }
        }
        system.debug('####SearchGroup '+mapa);
        return mapa;
        
    }
    public static String getLegacy (string branch_identifier,string  product_identifier,string group_identifier,string identifier){
        if(branch_identifier==null||product_identifier==null||group_identifier==null||identifier==null){
            return null;
        }
        else{
            if(branch_identifier.length()==1){
                branch_identifier='0'+branch_identifier;
            }
            if(product_identifier.length()==1){
                product_identifier='0'+product_identifier;
            }
            group_identifier=getGroup(group_identifier);
            
            if(identifier.length()==1){
                identifier='00'+identifier;
            }else if(identifier.length()==2){
                identifier='0'+identifier;
            }
        }
        return branch_identifier+'-'+product_identifier+'-'+group_identifier+'-'+identifier;
    }
    
    public static String getGroup (string group_identifier){
        
        if(group_identifier.length()==1){
            group_identifier='0000'+group_identifier;
        }else if(group_identifier.length()==2){
            group_identifier='000'+group_identifier;
        }else if(group_identifier.length()==3){
            group_identifier='00'+group_identifier;
        }else if(group_identifier.length()==4){
            group_identifier='0'+group_identifier;
        }
        
        return group_identifier;
    }
    
    /*public static String getParamsCustomerFilter(Datetime fechaInicio, Datetime fechaFin,Integer pagina, Integer registroPorPagina ){
        string endPoint='customers?filter_type=interval&start_date=';
        string inicio;
        string fin;
        inicio=fechaInicio.format('yyyy-MM-dd\'T\'HH:mm:ssXXX');
        fin=fechaFin.format('yyyy-MM-dd\'T\'HH:mm:ssXXX');
        endPoint=endPoint+inicio.replace(':','%3A')+'&end_date='+fin.replace(':','%3A')+'&all=false&page_size='+pagina+'&page_index='+registroPorPagina;
        system.debug('params '+endPoint);
        return endPoint;
    }*/
    
    public static String getParamsCustomerIdentifier(String identifier , String product,String branch, String groupx,Integer pagina, Integer registroPorPagina ){
        string endPoint=identifier +'?product_identifier='+product+'&branch_identifier='+branch+'&group_identifier='+groupx+'&all=false'+'&page_size='+registroPorPagina+'&page_index='+pagina;
        system.debug('params getParamsCustomerIdentifier '+endPoint);
        return endPoint;
    }
    
    
}