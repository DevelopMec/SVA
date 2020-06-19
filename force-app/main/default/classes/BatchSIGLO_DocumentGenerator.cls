global class BatchSIGLO_DocumentGenerator implements Database.Batchable<sObject>, Database.Stateful {
    
    Set<String> filesNamesSet = new Set<String>();
    Set<String> transaccionesFilesNamesSet = new Set<String>();
    Set<String> oppIds = new Set<String>();
    Map<String, Integer> totalRepLegalMap = new Map<String, Integer>();
    Map<String, Integer> totalClientsMap = new Map<String, Integer>();
    Map<String, String> clientesJSONMap =  new Map<String, String>();
    Map<String, String> transaccionesJSONMap =  new Map<String, String>();
    
    Integer daysBefore = 0;
    Id folderId;
    
    public BatchSIGLO_DocumentGenerator(Integer daysParam) {
        daysBefore = daysParam;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        folderId = [SELECT Id FROM Folder WHERE Name = 'SIGLO Documents' LIMIT 1].Id;

        //Se identifican opps que hayan cambiado a Implementación en los ultimos N dias
        Set<Id> oppSet = new Set<Id>(); 
        if(daysBefore != 0){
            Date createdDate = Date.Today().addDays(-daysBefore);
            List<OpportunityFieldHistory> oppHistoryList = [SELECT Id, CreatedById, CreatedDate, Field, NewValue, OldValue, OpportunityId  
                                                            FROM OpportunityFieldHistory Where Field = 'StageName' 
                                                            AND CreatedDate >=: createdDate];
            
            for(OpportunityFieldHistory oppH : oppHistoryList){
                if(oppH.NewValue == 'Implementación'){
                    oppSet.add(oppH.OpportunityId);
                }
            }
        }
        
        String query = 'SELECT Contrato_2__r.CodigoAS400__c, '+

            //Contact
            'Contrato_2__r.Contacto__c, Contrato_2__r.Contacto__r.Name, Contrato_2__r.Contacto__r.Account.RFC__c, Contrato_2__r.Contacto__r.Account.Website, Contrato_2__r.Contacto__r.Email, '+
            'Contrato_2__r.Contacto__r.Phone, Contrato_2__r.Contacto__r.Birthdate, Contrato_2__r.Contacto__r.Curp__c, Contrato_2__r.Contacto__r.LastName, Contrato_2__r.Contacto__r.Nationality__c, '+
            'Contrato_2__r.Contacto__r.Telefono2__c, Contrato_2__r.Contacto__r.Calle__c, Contrato_2__r.Contacto__r.NumeroExterior__c, Contrato_2__r.Contacto__r.NumeroInterior__c, '+
            'Contrato_2__r.Contacto__r.Colonia__c, Contrato_2__r.Contacto__r.BirthState__c, Contrato_2__r.Contacto__r.Fax, Contrato_2__r.Contacto__r.ElectorID__c, Contrato_2__r.Contacto__r.Estado__c, '+
            'Contrato_2__r.Contacto__r.CodigoPostal__c, Contrato_2__r.Contacto__r.ProfessionName__c, Contrato_2__r.Contacto__r.Gender__c, Contrato_2__r.Contacto__r.BirthCountry__c, '+
            'Contrato_2__r.Contacto__r.DelegacionMunicipio__c, Contrato_2__r.Contacto__r.MaritalStatus__c, Contrato_2__r.Contacto__r.FirstName, '+

            //Product
            'Producto__r.SendToSIGLO__c, Producto__r.IDInterno__c, '+ 

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
            'AND Producto__r.SendToSIGLO__c = TRUE ';
            //'AND Producto__r.IDInterno__c = \'32\' ';
        
        query = daysBefore != 0 ? query + 'AND Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId IN: oppSet LIMIT 500' : query + 'LIMIT 500';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ContratoFilial__c> scope) {

        for(ContratoFilial__c cf : scope){
            if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId != null){oppIds.add(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId);}

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
        
        Map<String, String> personasJSONBodies  = SIGLO_Clientes_FieldMapping.createJSON(scope, false, false); //Persona
        Map<String, String> repLegalJSONBodies  = SIGLO_Clientes_FieldMapping.createJSON(scope, true, false); //Rep Legal
        
        Map<String, String> transaccionesJSONBodies  = SIGLO_Transaccional_FieldMapping.createJSON(scope, false);
        
        List<Document> documentsList =  [Select Name, Body FROM Document where Name IN: personasJSONBodies.keySet() OR Name IN: transaccionesJSONBodies.keySet()];
        Map<String, Document> docsMap = new Map<String, Document>();
        for(Document doc : documentsList){docsMap.put(doc.Name, doc);}
        
        for(String fileName : personasJSONBodies.keySet()){
            if(docsMap.containsKey(fileName)){
                Document doc = docsMap.get(fileName);
                String repLegalJSONBody = repLegalJSONBodies.get(fileName);
                String clientesJSON = repLegalJSONBody != null ? personasJSONBodies.get(fileName) + ',' + repLegalJSONBody : personasJSONBodies.get(fileName);
                doc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(doc.Body) + EncodingUtil.convertToHex(Blob.valueOf(clientesJSON)));
                
                filesNamesSet.add(fileName);
            }else{
                String header =  '{"header": {"Recordtype": "", "ProductId": "'+ fileName.substringBefore('-') + '", "SendDate": "'+String.valueOf(Datetime.now())+'"}, "body":[';
                
                String repLegalJSONBody = repLegalJSONBodies.get(fileName);
                String docJSON = repLegalJSONBody != null ? header + personasJSONBodies.get(fileName) + ',' + repLegalJSONBody : header + personasJSONBodies.get(fileName);
                
                Document newDoc = new Document();
                newDoc.Name = fileName; 
                newDoc.Body =  Blob.valueOf(docJSON); 
                newDoc.ContentType = 'text/plain';
                newDoc.Type = 'txt';
                newDoc.FolderId = folderId;
                documentsList.add(newDoc);
                
                filesNamesSet.add(fileName);
            }
        }
        
        for(String fileName : transaccionesJSONBodies.keySet()){
            if(docsMap.containsKey(fileName)){
                Document doc = docsMap.get(fileName);
                doc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(doc.Body) + EncodingUtil.convertToHex(Blob.valueOf(transaccionesJSONBodies.get(fileName))));
                
                filesNamesSet.add(fileName);
            }else{
                String header =  '{"header": {"Recordtype": "", "ProductId": "'+ fileName.substringBefore('-') + '", "SendDate": "'+String.valueOf(Datetime.now())+'"}, "body":[';
                
                String docJSON = header + transaccionesJSONBodies.get(fileName);
                
                Document newDoc = new Document();
                newDoc.Name = fileName; 
                newDoc.Body =  Blob.valueOf(docJSON); 
                newDoc.ContentType = 'text/plain';
                newDoc.Type = 'txt';
                newDoc.FolderId = folderId;
                documentsList.add(newDoc);
                
                filesNamesSet.add(fileName);
            }
        }
        
        upsert documentsList;
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        List<Document> documentsList =  [Select Name, Body FROM Document where Name IN: filesNamesSet];
        Map<String, Document> docsMap = new Map<String, Document>();
        List<Opportunity> oppListUPD = new List<Opportunity>();
        for(Document doc : documentsList){
            String docType = doc.Name.substringAfter('-');
            String prodId = doc.Name.substringBefore('-');
            if(prodId != 'null'){
                if(docType == 'clientes'){
                    Integer totalRecords = totalRepLegalMap.get(prodId) == null ? totalClientsMap.get(prodId) : totalRepLegalMap.get(prodId)+totalClientsMap.get(prodId);
                    String trailer =  '], "trailer": {"TotalRecord": '+String.valueOf(totalRecords)+'}}';
                    doc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(doc.Body) + EncodingUtil.convertToHex(Blob.valueOf(trailer)));
                    doc.Name = daysBefore == 0 ? 'InitialLoad_MEX_FINTECH_CLIENTS_'+prodId+'_'+String.valueOf(Date.Today()) : String.valueOf(daysBefore) + '_DAYS_DATA_MEX_FINTECH_CLIENTS_'+prodId+'_'+String.valueOf(Date.Today());
                }else{
                    String trailer =  '], "trailer": {"TotalRecord": '+String.valueOf(totalClientsMap.get(prodId))+'}}';
                    doc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(doc.Body) + EncodingUtil.convertToHex(Blob.valueOf(trailer)));
                    doc.Name = daysBefore == 0 ? 'InitialLoad_MEX_FINTECH_TRANSACTIONS_'+prodId+'_'+String.valueOf(Date.Today()) : String.valueOf(daysBefore) + '_DAYS_DATA_MEX_FINTECH_TRANSACTIONS_'+prodId+'_'+String.valueOf(Date.Today());
                }
            }
        }
        
        for(Id oppId : oppIds){
            Opportunity oppToUpdate = new Opportunity(Id=oppId, SentToSIGLO__c = true);
            oppListUPD.add(oppToUpdate);
        }
        
        update documentsList;
        update oppListUPD;
        
    }
}