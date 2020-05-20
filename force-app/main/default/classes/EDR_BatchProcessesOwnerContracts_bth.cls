global class EDR_BatchProcessesOwnerContracts_bth implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public String query = 'SELECT Id, CodigoAS400__c, Name, ModifyOwnerContract__c,OwnerId FROM ContratoFilial__c WHERE ModifyOwnerContract__c = true';
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
     }

    global void execute(Database.BatchableContext BC, List<ContratoFilial__c> lstrecordsContract) { 
        List<String> lstValuesRequest = new List<String>();
        Set<Id> setIdOwner = new  Set<Id>();
        Map<Id,String> mapUserAndTerritory = new  Map<Id,String>();
        List<ListSales> lstWprRequest = new List<ListSales>();

        if(lstrecordsContract.size() > 0 ){           
            for(ContratoFilial__c objContract :  lstrecordsContract){
                setIdOwner.add(objContract.OwnerId);
            }
        }

        if(setIdOwner.size() > 0){
            for(User objUser :[SELECT Id,Name,TerritorioPosventa__c FROM User WHERE id IN : setIdOwner ] ){
                mapUserAndTerritory.put(objUser.Id, objUser.TerritorioPosventa__c);
            }
        }

        if(lstrecordsContract.size() > 0 ){           
            for(ContratoFilial__c objContract :  lstrecordsContract){
                lstValuesRequest = objContract.CodigoAS400__c.split('-');

                System.debug('******** VALUES CodigoAS400 *********** ');
                System.debug('Branch :' + lstValuesRequest[0]);  // brach
                System.debug('Product :' +'0'+lstValuesRequest[1]);  // product agregar un 0 a la izquierda
                System.debug('Group :' +lstValuesRequest[2]);  // Group
                System.debug('Customer :' +lstValuesRequest[3]);  // Customer
                System.debug('Territory  :' +mapUserAndTerritory.get(objContract.OwnerId));  // Customer
                ListSales ObjListSales = (new ListSales(lstValuesRequest[0],'0'+lstValuesRequest[1],lstValuesRequest[2], lstValuesRequest[3], mapUserAndTerritory.get(objContract.OwnerId) ));
                lstWprRequest.add(ObjListSales);             
            }
                   
        }
        /** LLAMADO AL WS Y SE PROCESA LA RESPUESTA **** */
        if(lstWprRequest.size() > 0){
            lstSalesWPR ListSalesFinal = (new lstSalesWPR(lstWprRequest));  
            String jsonRequestWS = JSON.serializePretty(ListSalesFinal);
            String strFinalJson = jsonRequestWS.replace('Group_Z', 'Group');
            System.debug('************* REQUEST *************');
            System.debug(strFinalJson);
            
            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://www.mocky.io/v2/5ebf00a532000058000c3331');
            request.setMethod('POST');         
            request.setHeader('Content-Type', 'application/json');
            //request.setHeader('X-Client-Id', objCustomSetChainCall.ClientId__c);
            //request.setHeader('X-Client-Secret', objCustomSetChainCall.ClientSecret__c);
            //request.setHeader('authorization',strToken);
            request.setTimeout(30000);
            request.setBody(strFinalJson);
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                System.debug('*********** RESPONSE OK  ************' +  response.getBody());         
                EDR_OwnerContractsResponseWS_cls objResponse = (EDR_OwnerContractsResponseWS_cls)JSON.deserialize(response.getBody(), EDR_OwnerContractsResponseWS_cls.class); 
                System.debug('************* RESPONSE *************');
                System.debug(objResponse);
            }
            
        }





        
       

    }

    global void finish(Database.BatchableContext BC){    
    }

    //************************  CLASES WPR PARA EL JSON REQUEST  */
  
    public class lstSalesWPR {
        public List<ListSales> ListSales {get;set;} 

        public lstSalesWPR (List<ListSales> ListSales){
            this.ListSales =  ListSales;
        }
    }
    public class ListSales {
        public String Branch {get;set;} 
        public String Product {get;set;} 
        public String Group_Z {get;set;} 
        public String Customer {get;set;} 
        public String SalesTerritory {get;set;} 

        public ListSales(String Branch, String Product,  String Group_Z, String Customer,String SalesTerritory ){
            this.Branch =  Branch;
            this.Product =  Product;
            this.Group_Z =  Group_Z;
            this.Customer =  Customer;
            this.SalesTerritory =  SalesTerritory;
        }
    }

}