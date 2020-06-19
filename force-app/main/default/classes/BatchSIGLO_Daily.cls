global class BatchSIGLO_Daily implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    Map<String, String> docsMap = new Map<String, String>();
    Map<String, List<Log__c>> logsMap = new Map<String, List<Log__c>>();
    Map<String, Integer> totalRepLegalMap = new Map<String, Integer>();
    Map<String, Integer> totalClientsMap = new Map<String, Integer>();
    Set<Id> productsIdList = new Set<Id>();

    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'SELECT Contrato_2__r.CodigoAS400__c, '+

            //Contact
            'Contrato_2__r.Contacto__c, Contrato_2__r.Contacto__r.Name, Contrato_2__r.Contacto__r.Account.RFC__c, Contrato_2__r.Contacto__r.Account.Website, Contrato_2__r.Contacto__r.Email, '+
            'Contrato_2__r.Contacto__r.Phone, Contrato_2__r.Contacto__r.Birthdate, Contrato_2__r.Contacto__r.Curp__c, Contrato_2__r.Contacto__r.LastName, Contrato_2__r.Contacto__r.Nationality__c, '+
            'Contrato_2__r.Contacto__r.Telefono2__c, Contrato_2__r.Contacto__r.Calle__c, Contrato_2__r.Contacto__r.NumeroExterior__c, Contrato_2__r.Contacto__r.NumeroInterior__c, '+
            'Contrato_2__r.Contacto__r.Colonia__c, Contrato_2__r.Contacto__r.BirthState__c, Contrato_2__r.Contacto__r.Fax, Contrato_2__r.Contacto__r.ElectorID__c, Contrato_2__r.Contacto__r.Estado__c, '+
            'Contrato_2__r.Contacto__r.CodigoPostal__c, Contrato_2__r.Contacto__r.ProfessionName__c, Contrato_2__r.Contacto__r.Gender__c, Contrato_2__r.Contacto__r.BirthCountry__c, '+
            'Contrato_2__r.Contacto__r.DelegacionMunicipio__c, Contrato_2__r.Contacto__r.MaritalStatus__c, Contrato_2__r.Contacto__r.FirstName, '+

            //Product
            'Producto__c, Producto__r.SendToSIGLO__c, Producto__r.IDInterno__c, '+ 

            //Quote
            'Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId, Contrato_2__r.PartidaPresupuesto__r.Quote.OperationsInDollars__c, '+
            'Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c, Contrato_2__r.PartidaPresupuesto__r.Quote.TotalPrice, '+

            //Opportunity
            'Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Name, Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.CodigoClienteAS400__c, '+ 
            'Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.OwnerId, Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount, '+
            'Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.SentToSIGLO__c, '+

            //Account
            'Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Account.Name, Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Account.Phone, '+
            'Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Account.RFC__c, Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Account.Website, '+

            //Entidad Legal
            'Contrato_2__r.Entidad_Legal__c, Contrato_2__r.Entidad_Legal__r.Name, '+ 
            'Contrato_2__r.Entidad_Legal__r.RecordTypeId, Contrato_2__r.Entidad_Legal__r.CountryOrigin__c, '+
            'Contrato_2__r.Entidad_Legal__r.DeedDate__c, Contrato_2__r.Entidad_Legal__r.EconomicActivity__c, '+
            'Contrato_2__r.Entidad_Legal__r.Calle__c, Contrato_2__r.Entidad_Legal__r.NumeroExterior__c, '+
            'Contrato_2__r.Entidad_Legal__r.NumeroInterior__c, Contrato_2__r.Entidad_Legal__r.Colonia__c, '+
            'Contrato_2__r.Entidad_Legal__r.Estado__c, Contrato_2__r.Entidad_Legal__r.DelegacionMunicipioFiscal__c, '+
            'Contrato_2__r.Entidad_Legal__r.CodigoPostal__c, Contrato_2__r.Entidad_Legal__r.FEA__c, '+
            'Contrato_2__r.Entidad_Legal__r.DeedNumber__c, Contrato_2__r.Entidad_Legal__r.RazonSocial__c, '+ 
            'Contrato_2__r.Entidad_Legal__r.PersonType__c '+

            'FROM ContratoFilial__c '+
            'WHERE isActive__c = TRUE '+
            'AND Producto__r.SendToSIGLO__c = TRUE '+
            'AND Producto__r.IDInterno__c = \'29\' LIMIT 500';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ContratoFilial__c> scope) {
        for(ContratoFilial__c cf : scope){
            Log__c log = new Log__c();
            log.Opportunity__c = cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId;

            if (logsMap.containsKey(cf.Producto__c)){
                logsMap.get(cf.Producto__c).add(log);
            }else{
                logsMap.put(cf.Producto__r.IDInterno__c, new  List <Log__c> { log });
            }

            productsIdList.add(cf.Producto__c);

            if(cf.Contrato_2__r.Contacto__c != null){ // total de Rep Legal por Producto
                if(totalRepLegalMap.containsKey(cf.Producto__r.IDInterno__c)){
                    totalRepLegalMap.put(cf.Producto__r.IDInterno__c, totalRepLegalMap.get(cf.Producto__r.IDInterno__c) + 1);
                }else{
                    totalRepLegalMap.put(cf.Producto__r.IDInterno__c, 1);
                }
            }
            
            if(totalClientsMap.containsKey(cf.Producto__r.IDInterno__c)){ //total de Opp por Producto
                totalClientsMap.put(cf.Producto__r.IDInterno__c, totalClientsMap.get(cf.Producto__r.IDInterno__c) + 1);
            }else{
                totalClientsMap.put(cf.Producto__r.IDInterno__c, 1);
            }
        }
        
        Map<String, String> personasJSONBodies  = SIGLO_Clientes_FieldMapping.createJSON(scope, false, true); //Persona
        Map<String, String> repLegalJSONBodies  = SIGLO_Clientes_FieldMapping.createJSON(scope, true, true); //Rep Legal
        
        Map<String, String> transaccionesJSONBodies  = SIGLO_Transaccional_FieldMapping.createJSON(scope, true);

        for(String fileName : personasJSONBodies.keySet()){
            if(docsMap.containsKey(fileName)){
                String docJSON = docsMap.get(fileName);
                String repLegalJSONBody = repLegalJSONBodies.get(fileName);
                String clientesJSON = repLegalJSONBody != null ? personasJSONBodies.get(fileName) + ',' + repLegalJSONBody : personasJSONBodies.get(fileName);
                docsMap.put(fileName, docJSON + clientesJSON);

            }else{
                String header =  '{"header": {"Recordtype": "", "ProductId": "'+ fileName.substringBefore('-') + '", "SendDate": "'+String.valueOf(Datetime.now())+'"}, "body":[';
                
                String repLegalJSONBody = repLegalJSONBodies.get(fileName);
                String docJSON = repLegalJSONBody != null ? header + personasJSONBodies.get(fileName) + ',' + repLegalJSONBody : header + personasJSONBodies.get(fileName);
                
                docsMap.put(fileName, docJSON);
            }
        }
        
        for(String fileName : transaccionesJSONBodies.keySet()){
            if(docsMap.containsKey(fileName)){
                String docJSON = docsMap.get(fileName);
                docsMap.put(fileName, docJSON + transaccionesJSONBodies.get(fileName));
            }else{
                String header =  '{"header": {"Recordtype": "", "ProductId": "'+ fileName.substringBefore('-') + '", "SendDate": "'+String.valueOf(Datetime.now())+'"}, "body":[';
                
                String docJSON = header + transaccionesJSONBodies.get(fileName);

                docsMap.put(fileName, docJSON);
            }
        }
        
    }   

    global void finish(Database.BatchableContext BC) {
        Set<Log__c> logSet = new Set<Log__c>();
        for(String fileName : docsMap.keySet()){
            String docType = fileName.substringAfter('-');
            String prodId = fileName.substringBefore('-');
            if(prodId != 'null'){
                if(docType == 'clientes'){
                    Integer totalRecords = totalRepLegalMap.get(prodId) == null ? totalClientsMap.get(prodId) : totalRepLegalMap.get(prodId)+totalClientsMap.get(prodId);
                    String trailer =  '], "trailer": {"TotalRecord": '+String.valueOf(totalRecords)+'}}';
                    String docJSON = docsMap.get(fileName) + trailer;
                    docsMap.put(fileName, docsMap.get(fileName));
                    String response = 'test cliente';

                    Datetime tiempoEnvio = Datetime.now();
					
                    if(!Test.isRunningTest()){
                        HttpResponse responseClientes = SIGLO_DailyCallout.postCallout(docJSON);
                     	response = 'Cliente Response: ' + responseClientes.getStatusCode() + ' ' + responseClientes.getStatus();
                    }

                    Datetime tiempoRespuesta = Datetime.now();

                    for(Log__c log : logsMap.get(prodId)){
                        log.Fecha_Hora_Envio__c = tiempoEnvio;
                        log.Fecha_Hora_Respuesta__c = tiempoRespuesta;
                        log.ResponseWS__c = String.isNotBlank(log.ResponseWS__c) ? log.ResponseWS__c + '\n' + response : response;
                    }

                }else{
                    String trailer =  '], "trailer": {"TotalRecord": '+String.valueOf(totalClientsMap.get(prodId))+'}}';
                    String docJSON = docsMap.get(fileName) + trailer;
                    docsMap.put(fileName, docsMap.get(fileName));
                    String response = 'test transaction';

                    Datetime tiempoEnvio = Datetime.now();
					
                    if(!Test.isRunningTest()){
                        HttpResponse responseTransacciones = SIGLO_DailyCallout.postCallout(docJSON);
                    	response = 'Transaccion Response: ' + responseTransacciones.getStatusCode() + ' ' + responseTransacciones.getStatus();
                    }
                    
                    Datetime tiempoRespuesta = Datetime.now();

                    for(Log__c log : logsMap.get(prodId)){
                        log.Fecha_Hora_Envio__c = tiempoEnvio;
                        log.Fecha_Hora_Respuesta__c = tiempoRespuesta;
                        log.ResponseWS__c = String.isNotBlank(log.ResponseWS__c) ? log.ResponseWS__c + '\n' + response : response;
                    }
                }
            }
        }
        
        for(List<Log__c> logList : logsMap.values()){logSet.addAll(logList);}
        List<Log__c> logList = new List<Log__c>(logSet);

        List<Product2> productsList = [SELECT Id, SendToSIGLO__c FROM Product2 WHERE Id IN: productsIdList];
        for(Product2 product : productsList){product.SendToSIGLO__c = FALSE;}

        update productsList;
        insert logList;


    }
}