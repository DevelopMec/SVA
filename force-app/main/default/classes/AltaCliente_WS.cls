public without sharing class AltaCliente_WS {
    
    public static String  getToken(String endPoint,String clientId,String clientSecret,String grantType,String scope){
        //Negocio__c neg=[Select Id,ClientId__c,Client_Secret__c,Grant_type__c,scope__c,TokenUrl__c from Negocio__c where Utilization__c='AltaClientes'];
        //String endPoint = neg.TokenUrl__c;        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setMethod('POST');
        request.setBody('client_id='+clientId+'&client_secret='+clientSecret+'&grant_type='+grantType+'&scope='+scope);
        SYstem.debug('RES:'+request);
        HttpResponse response =new  HttpResponse();
        response=CreateConnection(request);
        if (response.getStatusCode() == 200) {
            System.debug('BODY::'+response.getBody());
            Map<String,Object> obj = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            System.debug(EncodingUtil.urlDecode((String)obj.get('access_token'), 'UTF-8'));    
            return 'Bearer '+EncodingUtil.urlDecode((String)obj.get('access_token'), 'UTF-8');
        }
        return '';
    }
    public static HttpResponse CreateConnection(HttpRequest request){
        Http http = new Http();
        HttpResponse response =new  HttpResponse();
        try{
            response = http.send(request);
        }catch(CalloutException ex){
            system.debug('Error CreateConnection: '+ ex.getMessage() );
            return response;
        }
        return response;
    }
    public static responseWP crearCliente(CreateCustomerRequestWP customer,String token,String endPoint,String clientId,String clientSecret){
        responseWP resp=new responseWP();
        System.debug('token:'+token);
        //String token=getToken();
        //Negocio__c neg=[Select Id,NameLess_ByIdentifie__c,ClientId__c,Client_Secret__c,Grant_type__c,scope__c,TokenUrl__c from Negocio__c where Utilization__c='AltaClientesAS'];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('POST');        
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('X-Client-Id', clientId);
        request.setHeader('X-Client-Secret', clientSecret);
        request.setHeader('authorization',token);
        request.setTimeout(30000);
        
        //System.debug('SEND::'+JSON.serialize(customer));
        String jsonTemp=JSON.serialize(customer);
        String jsonSend=quitarAcentos(jsonTemp);
        request.setBody(jsonSend);
        HttpResponse response = http.send(request);
        System.debug('FIN SEND');

        if (response.getStatusCode() == 200) {
            system.debug('response *##***###'+response.getBody());
            resp.response=(CreateCustomerResponse)JSON.deserialize(response.getBody(), CreateCustomerResponse.class);
            resp.status=true;
            
        } else {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            System.debug('BODY:'+response.getBody());
            //resp.response=(CreateCustomerResponse)JSON.deserialize(response.getBody(), CreateCustomerResponse.class);
            resp.status=false;
            resp.msj=response.getBody()+' ';
            for(String t : response.getHeaderKeys()){
                resp.msj+=t;
            }
        }
        return resp;
    }
    public class responseWP{
        public CreateCustomerResponse response{get;set;}
        public boolean Status{get;set;}
        public String msj{get;set;}
    }
    public static String quitarAcentos(String cadena){
        Map<String,String> mapReplace=new Map<String,String>{'Ñ'=>'N','ñ'=>'n','á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u','ü'=>'u','Á'=>'A','É'=>'E','Í'=>'I','Ó'=>'O','Ú'=>'u','Ü'=>'u',
            'à'=>'a','è'=>'e','ì'=>'i','ò'=>'o','ù'=>'u','À'=>'A','È'=>'E','Ì'=>'I','Ò'=>'O','Ù'=>'u'};
            for(String i : mapReplace.KeySet()){
                cadena=cadena.replaceAll(i,mapReplace.get(i));
            }
        return cadena;
    }
}