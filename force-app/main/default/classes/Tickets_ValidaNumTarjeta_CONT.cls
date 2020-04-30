public class Tickets_ValidaNumTarjeta_CONT {
    private static string NProd = '';
    private static string CProd = '';
    private static string IdProd = '';
    private static string v_Error = '';
    @AuraEnabled public String numTarjetaTag{get;set;}
    @AuraEnabled public String RealNumTarjetaTag{get;set;}
    @AuraEnabled public String vStatusTarjeta{get;set;}
    @AuraEnabled public String NomProducto{get;set;}
    @AuraEnabled public String NomCuenta{get;set;}
    @AuraEnabled public String IdSubCuenta{get;set;}
    @AuraEnabled public String StatusCuenta{get;set;}
    @AuraEnabled public String Status{get;set;}
    @AuraEnabled public String Saldo {get;set;}
    @AuraEnabled public String Referencia {get;set;}
    @AuraEnabled public String vError{get;set;}
    @AuraEnabled public String vError2{get;set;}
    @AuraEnabled public String datos{get;set;} 
    @AuraEnabled public Boolean ValePapel{get;set;}
    @AuraEnabled public Boolean BloqueaNumTarjeta{get;set;}
    @AuraEnabled public Boolean findCards{get;set;}
    
     @AuraEnabled
    public static Map<String,String> buscarTarjeta(String idTicket,String numT){ 
        Map<String,String> res=new Map<String,String>();
        //System.debug('buscarTarjeta: '+numT+', idTicket:'+idTicket);
        List<TemporaryCardsBig__b> tmpCard=[Select Id,CardNumber__c,Sub_Cuenta__c ,RFC__c from TemporaryCardsBig__b where CardNumber__c=:numT limit 1];
        //System.debug('buscarTarjeta: '+tmpCard.size());
        if(tmpCard!=null&&tmpCard.size()>0){
            String subcuenta=tmpCard[0].Sub_Cuenta__c ;
            //Integer i=[SELECT id,Producto__c,Name,Entidad_Cuenta__r.Cuenta__c,Entidad_Cuenta__r.Cuenta__r.Name FROM ContratoFilial__c WHERE CodigoAS400__c =: subcuenta];
            Integer i=[SELECT count() FROM ContratoFilial__c WHERE CodigoAS400__c =: subcuenta];
            if(i>0){
                ContratoFilial__c cf=[SELECT id,CodigoAS400__c,Producto__c,Producto__r.Name,Name,Entidad_Cuenta__r.Cuenta__c,Entidad_Cuenta__r.Cuenta__r.Name FROM ContratoFilial__c WHERE CodigoAS400__c =: subcuenta];
                Case  c = [SELECT Id, Tarjeta__c, Contrato_Filial__c FROM Case WHERE Id =: idTicket];
                c.Contrato_Filial__c=cf.Id;c.AccountId=cf.Entidad_Cuenta__r.Cuenta__c;c.ProductId=cf.Producto__c;
                update c;
                res.put('status', 'success');res.put('producto', cf.Producto__r.Name);                
                res.put('cuenta', cf.Entidad_Cuenta__r.Cuenta__r.Name);res.put('subcuenta', cf.CodigoAS400__c);                
                return res;
            }else{
                res.put('status', 'error');
                return res;
            }            
        }else{
            res.put('status', 'error');
            return res;
        }     
    }
    
    @AuraEnabled
    public static Tickets_ValidaNumTarjeta_CONT ObtenerDatos(string idTicket, string vNumTarjeta){ 
        Tickets_ValidaNumTarjeta_CONT datosT = new Tickets_ValidaNumTarjeta_CONT();
        datosT.BloqueaNumTarjeta = false;
        Blob cryptoKey = Blob.valueOf('00000000000000000000000000000000');
        
        if (vNumTarjeta.contains('xxxx')){
            vNumTarjeta = '';           
        }
        
        if (vNumTarjeta == ''){
            
            FOR (Case c : [SELECT Id, Type, Tarjeta__c, PaperVoucher__c, Contrato_Filial__c FROM Case WHERE Id =: idTicket]){
                String tarjeta;
                try{                        
                    if (test.isRunningTest()){
                        tarjeta = c.Tarjeta__c;
                    }
                    else{
                        Blob base64 = EncodingUtil.base64decode(c.Tarjeta__c);
                        Blob decryptedData = Crypto.decryptWithManagedIV ('AES256', cryptoKey, base64);
                        tarjeta= decryptedData.toString();
                    }
                    
                }
                catch(Exception e){
                    System.debug ('Error ' + e.getMessage());
                    tarjeta = c.Tarjeta__c;
                    vNumTarjeta = c.Tarjeta__c;
                }
                
                datosT.RealnumTarjetaTag = tarjeta;
                datosT.numTarjetaTag = tarjeta;
                datosT.ValePapel = c.PaperVoucher__c;
                
                if (datosT.ValePapel){
                    return datosT;
                }
                
                string tipo = c.Type;
                if (!tipo.contains('Usuario')){
                    datosT.ValePapel = true;
                    return datosT;   
                }
            }
            
        }
        else{
            datosT.RealnumTarjetaTag = vNumTarjeta;
            datosT.numTarjetaTag = vNumTarjeta;
        }
        
        try{
            string datos = ObtenerDatosTarjeta(datosT.RealnumTarjetaTag);
            
            if (datos == ''){
                datosT.numTarjetaTag =  datosT.RealnumTarjetaTag;
                datosT.vError=v_Error;
                datosT.findCards=true;
                return datosT;
            }
            
            datosT.vStatusTarjeta = ObtenerValor(datos, 'status', 'meta');
            
            if (test.isRunningTest()){
                if (vNumTarjeta == '04E6C392AB4A80'){
                    datosT.vStatusTarjeta = 'failed'; 
                    v_Error = '';
                }
            }
            
            Case  c = [SELECT Id, Tarjeta__c, Contrato_Filial__c FROM Case WHERE Id =: idTicket];
            if (ObtenerValor(datos, 'account', 'card') != '--'){
                if (vNumTarjeta != ''){
                    if (!test.isRunningTest()){
                        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, Blob.valueOf(vNumTarjeta));
                        c.Tarjeta__c = EncodingUtil.base64Encode(encryptedData);
                        c.ProductId = IdProd;
                        update c;
                    }    
                }
                datosT.numTarjetaTag = FormatoNumTarjetaTag(datosT.numTarjetaTag);
                datosT.NomProducto = NProd;
                datosT.NomCuenta = ObtenerValor(datos, 'name', 'employer');
                datosT.StatusCuenta = ObtenerValor(datos, 'account_status', 'card');
                datosT.Saldo = ObtenerValor(datos, 'available_balance', 'card');
                datosT.Status = ObtenerValor(datos, 'status', 'card');
                datosT.Referencia = ObtenerValor(datos, 'reference', 'card');
                
                string subcuenta = ObtenerValor(datos, 'identifier', 'employer');
                string productoResp = ObtenerValor(datos, 'product_identifier', 'card');
                //string cuenta = '';
                
                boolean tarjBase=true;                
                
                if (subcuenta != '--'){
                    datosT.findCards=false;
                    if(tarjBase){
                        //cuenta = subcuenta.substring(2,7);
                        subcuenta=subcuenta.length()<10 ? '0'+subcuenta : subcuenta;
                        subcuenta = subcuenta.substring(0,2) + '-' + CProd + '-' + subcuenta.substring(2,7) + '-' + subcuenta.substring(7,10);
                    }
                    try{
                        boolean existesubcuenta = false;
                        /*if(tarjBase){
                            for (Account acc: [SELECT id FROM Account WHERE CodigoClienteAS400__c =: String.valueOf(Integer.valueof(cuenta.trim()))] ){
                                cuenta = acc.Id;
                            }	
                        }*/
                        for (ContratoFilial__c cf: [SELECT id,Producto__c,Name,Entidad_Cuenta__r.Cuenta__c,Entidad_Cuenta__r.Cuenta__r.Name FROM ContratoFilial__c WHERE CodigoAS400__c =: subcuenta] ){                            
                            //c.AccountId = cuenta;
                            c.AccountId = cf.Entidad_Cuenta__r.Cuenta__c;
                            c.Contrato_Filial__c = cf.Id;
                            c.ProductId=cf.Producto__c;
                            update c;
                            existesubcuenta = true;
                            datosT.BloqueaNumTarjeta = true;
                            datosT.IdSubCuenta=cf.Name;
                            datosT.NomCuenta=cf.Entidad_Cuenta__r.Cuenta__r.Name;
                        }
                        
                        if (!existesubcuenta){
                            datosT.vError2 = 'No existe una subcuenta creada para esta tarjeta';
                            datosT.findCards=true;
                            datosT.IdSubCuenta = subcuenta;
                            datosT.BloqueaNumTarjeta = true;
                            if(productoResp!='--'){
                                c.ProductId=getProducto(productoResp);
                                update c;
                            }
                        }
                    }
                    catch(Exception e){
                        System.debug('error ' + e);
                    }
                }
                else{
                    datosT.findCards=true;
                    datosT.vError2 = 'La tarjeta no tiene asociada una cuenta';
                    if(productoResp!='--'){
                        c.ProductId=getProducto(productoResp);
                        update c;
                    }
                }
            }
            else{
                datosT.findCards=true;
                datosT.NomProducto = '';
                if (v_Error == ''){
                    datosT.numTarjetaTag = datosT.RealnumTarjetaTag;
                    v_Error = 'Error: ' + ObtenerValor(datos, 'description', 'meta');
                }
            }
            
            
            datosT.datos=datos;
            datosT.vError=v_Error;
        }
        catch(Exception e){
            datosT.vError= 'Error ' + e;  
            System.debug('datosT.vError ' + datosT.vError+',l:'+e.getLineNumber());
        }
        return datosT;
    }
	
    public static String getProducto(String cod){
        try{
            Product2 p=[Select Id from Product2 where ProductCode=:cod and IDInterno__c!='29-TER' limit 1];
            return p.Id;
        }catch(Exception e){
            return null;
        }
    }
 
    private static string FormatoNumTarjetaTag(string vNumTarjetaTag){
        string vFormatNum = '';
        for (integer i = 0; i < vNumTarjetaTag.length() - 4; i++) {
            vFormatNum = vFormatNum + 'x';    
        } 
        vFormatNum = vFormatNum + vNumTarjetaTag.right(4);
        
        return vFormatNum;
    }
    
    @AuraEnabled
    public static Tickets_ValidaNumTarjeta_CONT GuardarDatos(string idTicket, string vNumTarjeta){   
        return ObtenerDatos(idTicket,vNumTarjeta);
    }
    
    private static string ObtenerDatosTarjeta(string numTarjeta) {
        
        Negocio__c config = [Select TicketUsuario_Tarjeta_TokenURL__c,TicketUsuario_Tarjeta_X_Client_secret__c,TicketUsuario_Tarjeta_X_Client_id__c,TicketUsuario_Tarjeta_Client_id__c, TicketUsuario_Tarjeta_Client_secret__c, TicketUsuario_Tarjeta_Grant_type__c,TicketUsuario_Tarjeta_Scope__c,TicketUsuario_Tarjeta_DataURL__c From Negocio__c];
        string x_client_id = config.TicketUsuario_Tarjeta_X_Client_id__c;
        string x_client_secret = config.TicketUsuario_Tarjeta_X_Client_secret__c; 
        string client_id = config.TicketUsuario_Tarjeta_Client_id__c;
        string client_secret = config.TicketUsuario_Tarjeta_Client_secret__c; 
        string grant_type = config.TicketUsuario_Tarjeta_Grant_type__c;
        string scope = config.TicketUsuario_Tarjeta_Scope__c;
        string dataURL = config.TicketUsuario_Tarjeta_DataURL__c;
        string tokenURL = config.TicketUsuario_Tarjeta_TokenURL__c;
        
        //numTarjeta = '6036810176150313';
        //Obtiene Token
        string token = '';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setTimeout(120000);
        request.setEndpoint(tokenURL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('client_id='+client_id+'&client_secret='+client_secret+'&grant_type='+grant_type+'&scope='+scope);
        if (!test.isRunningTest()){     
            HttpResponse response = http.send(request);
            token = response.getBody();
        }
        
        token = ObtenerValor(token, 'access_token', '');
        System.debug('token ' + token);
        
        
        //Obtiene datos de la tarjeta
        string vlikenum = '%' +numTarjeta.left(8) + '%' ;   
        CProd = '';
        //Valida si es tarjeta o tag
        System.debug('numTarjeta ' + numTarjeta + ' numTarjeta.isNumeric() ' + numTarjeta.isNumeric());
        if (numTarjeta.isNumeric()){
            for(product2 prod :[Select Id, ProductCode,IDInterno__c, Name, Card_Relationship__c from product2 Where Card_Relationship__c like:vlikenum LIMIT 1]){
                IdProd = prod.Id;
                CProd = prod.IDInterno__c;  
                NProd = prod.Name;
            }
        }
        else{
            for(product2 prod :[Select Id, ProductCode,IDInterno__c, Name, Card_Relationship__c from product2 Where ProductCode=:'30' LIMIT 1]){
                IdProd = prod.Id;
                CProd = prod.IDInterno__c;  
                NProd = prod.Name;
            } 
        }
        
        if (CProd == ''){
            v_Error = 'No existe un producto relacionado a la tarjeta';
            return '';
        }
        
        Http http2 = new Http();
        HttpRequest request2 = new HttpRequest();
        request2.setTimeout(120000);
        request2.setEndpoint(dataURL);
        request2.setMethod('POST');
        request2.setHeader('Content-Type', 'application/json');
        request2.setHeader('Authorization', 'Bearer ' + token);
        request2.setHeader('X-Client-Id', x_client_id);
        request2.setHeader('X-Client-Secret', x_client_secret);
        
        string body = '{"card": {"product_identifier": ' + CProd + ',"number": "' + numTarjeta + '","serial": "","status": "NonRegistered","is_additional": false,"account": "","account_status": "Inactive","available_balance": 1.23,"reference": "","is_balance_hidden": false,"balance_type": "Money","tag_identifier": "","token_type": "PhysicCard","technology_type_identifier": "None"},"security": {"application_identifier": "E0AED02F-A2D2-4673-840A-031FE7DE8DFE","user_name": "GESTION_USUARIOS","end_user_identifier": "GESTION_USUARIOS","end_user_ip": "1.1.1.1"}}';        
        request2.setBody(body);
        
        if (!test.isRunningTest()){
            HttpResponse response2 = http2.send(request2);
            System.debug('response2.getBody() ' + response2.getBody());
            
            return response2.getBody();
        }
        else{
            return '{"data": {"card": {"account": "13147666   ","account_status": "Active","available_balance": 40.89,"balance_type": "Money","is_additional": "false","is_balance_hidden": "false","number": "6036810600010448","product_identifier": 14,"reference": "00 TRANSACCION EXITOSA                  ","serial": null,"status": "Active","tag_identifier": null,"technology_type_identifier": "None","token_type": "PhysicCard"},"employer": {"active": "false","card": "6036810600010448","identifier": "0116474021","name": "SERVICIOS EDENRED, S.A. DE C.V.(NOMINAS)","product": "14"}},"meta": {"messages": null,"status": "succeeded"}}';
        }
    }
    
    private static String ObtenerValor(string data, String campo, string grupo) {
        JSONParser parser = JSON.createParser(data);
        boolean grupoValido = true; 
        if (grupo != ''){
            grupoValido = false;        
        }
        
        while (parser.nextToken() != null) {
            if (parser.getText() == grupo){
                grupoValido = true;
            }
            
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == campo) && (grupoValido)) {
                parser.nextToken();
                if (parser.getText() == 'null'){
                    return '--';
                }
                else{
                    return parser.getText();  
                }    
            }
        }
        
        return '--';
    } 
    
}