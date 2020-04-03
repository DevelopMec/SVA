public without sharing class GetGruposPrime_WS {
    public static responseWP getGrupos(String endPoint,String clientId,String clientSecret,String token,String groupId,String prodId){
        System.Debug( endPoint+'-'+ clientId+'-'+ clientSecret+'-'+ groupId+'-'+ prodId);
        responseWP resp=new responseWP();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint+'?group_identifier='+Decimal.valueOf(groupId)+'&product_identifier='+Decimal.valueOf(prodId));
        request.setMethod('GET');
        request.setHeader('X-Client-Id', clientId);
        request.setHeader('X-Client-Secret', clientSecret);
        request.setHeader('authorization',token);
        request.setTimeout(30000);
        
        //request.setBody('group_identifier='+Decimal.valueOf(groupId)+'&product_identifier='+Decimal.valueOf(prodId));
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            system.debug('response *##***###'+response.getBody());
            resp.response=(PrimeGroupResponse_WP)JSON.deserialize(response.getBody(), PrimeGroupResponse_WP.class);
            resp.status=true;
            
        } else {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            resp.response=(PrimeGroupResponse_WP)JSON.deserialize(response.getBody(), PrimeGroupResponse_WP.class);
            resp.status=false;
            resp.msj='';
            for(String t : response.getHeaderKeys()){
                resp.msj+=t;
            }
        }
        return resp;
    }
    public class responseWP{
        public PrimeGroupResponse_WP response{get;set;}
        public boolean Status{get;set;}
        public String msj{get;set;}
    }
}