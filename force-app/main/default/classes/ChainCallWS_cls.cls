/**********************************************************************************
Developed by: Freeway Consulting
Author: Hector Diaz
Project:  "Edenred" 
Description: .
---------------------------------------------------------------------------------
Version       Date         Author                   Description
------ ---------- ---------------------------------------------------------------
1.0       20-Abril-2020      Hector Diaz               Initial version
*************************************************************************************/
public class ChainCallWS_cls{ 

    public static String  getToken(){
        WSCredentials__c objCustomSetChainToken = [SELECT Id,ClientId__c,ClientSecret__c,GrantType__c,Scope__c,EndPoint__c FROM WSCredentials__c WHERE  name = 'ChainToken' ];      
        String endPoint = objCustomSetChainToken.EndPoint__c;
        
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setMethod('POST');
        request.setBody('client_id='+objCustomSetChainToken.ClientId__c+'&client_secret='+objCustomSetChainToken.ClientSecret__c+'&grant_type='+objCustomSetChainToken.GrantType__c+'&scope='+objCustomSetChainToken.Scope__c);
        SYstem.debug('RES:'+request);
        HttpResponse response = http.send(request);
    
        if (response.getStatusCode() == 200) {
            System.debug('TOKEN BODY::'+response.getBody());
            Map<String,Object> obj = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('TOKEN HMDH  : ' + EncodingUtil.urlDecode((String)obj.get('access_token'), 'UTF-8'));    
            return 'Bearer '+EncodingUtil.urlDecode((String)obj.get('access_token'), 'UTF-8');
        }
        return '';
    }

    public static void chainCallWS(){
        ChainDTOWS_cls.Chain  objRequestWS  =  new  ChainDTOWS_cls.Chain(); 
        ChainDTOWS_cls.ChainRequest ObjChainRequest = (new ChainDTOWS_cls.ChainRequest(objRequestWS));
        // ***** SE OBTIENE EL TOKEN **
        String strToken = ChainCallWS_cls.getToken();
        // ***** CONSULTA AL CUSTOM SEETING
        WSCredentials__c  objCustomSetChainCall = [SELECT Id,ClientId__c,ClientSecret__c,EndPoint__c FROM WSCredentials__c WHERE  name = 'ChainCallWS' ];   
        
        //********** CONSULTA EL ULTIMO CRM NUMBER QUE SE GUARDO EN EL LOG Y LE SUMA 1 EN CASO CONTRARIO CONSULTA EL DE INICIO  */
        List<Log__c> lstobjLog = [SELECT Id , CRM_Numero__c FROM Log__c WHERE  Nombre_aplicacion__c = 'ChainWS' ORDER BY CreatedDate DESC limit 1 ];           
        if(lstobjLog.size() > 0){
            Integer intLastValueCRM = Integer.valueOf(lstobjLog[0].CRM_Numero__c) + 1;
            objRequestWS.crm_number = String.valueOf(intLastValueCRM);
        }else{
            objRequestWS.crm_number = '900000';
        }      
        objRequestWS.zip_code = 52000;
        

        
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint(objCustomSetChainCall.EndPoint__c);
        request.setMethod('POST');         
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('X-Client-Id', objCustomSetChainCall.ClientId__c);
        request.setHeader('X-Client-Secret', objCustomSetChainCall.ClientSecret__c);
        request.setHeader('authorization',strToken);
        request.setTimeout(30000);
        
        //SERIALIZA EL JSON
        String jsonRequestWS=JSON.serializePretty(ObjChainRequest);
        System.debug('******* REQUEST WS **********');
        System.debug(jsonRequestWS);
        request.setBody(jsonRequestWS);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            System.debug('*********** RESPONSE OK  ************' +  response.getBody());         
            ChainResponseWS_cls objResponse = (ChainResponseWS_cls)JSON.deserialize(response.getBody(), ChainResponseWS_cls.class);      
            ChainCallWS_cls.creteLogCallWs(objResponse , response, jsonRequestWS, objRequestWS.crm_number);
            System.debug(objResponse.meta.status);
            

            
        } else {
            System.debug('*********** RESPONSE ERROR ************');
            System.debug('The status code : ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('BODY: '+response.getBody());             
        }
         
    }

    public static void creteLogCallWs(ChainResponseWS_cls objResponse, HttpResponse response, String jsonRequestWS, String  strLastCrmNumber ){
        System.debug('******* ENTRO METODO PARA CREAR LOG ******* ');
        Log__c objLog = new Log__c();      
            
        if(objResponse.meta.status == 'succeeded' ){
            objLog.Nombre_aplicacion__c = 'ChainWS';
            objLog.ResquestWS__c = jsonRequestWS;
            objLog.ResponseWS__c =  response.getBody();
            objLog.CRM_Numero__c = strLastCrmNumber;
            objLog.EstatusLlamado_WS__c = objResponse.meta.status;
        }else{
            objLog.Nombre_aplicacion__c = 'ChainWS';
            objLog.ResquestWS__c = jsonRequestWS;
            objLog.ResponseWS__c = response.getBody(); 
            objLog.CRM_Numero__c = strLastCrmNumber;
            objLog.EstatusLlamado_WS__c = objResponse.meta.status;
        }
        if(objLog != null){
            insert objLog;
        }
    }

}