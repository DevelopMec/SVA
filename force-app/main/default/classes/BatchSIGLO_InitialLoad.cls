global class BatchSIGLO_InitialLoad implements Database.Batchable<sObject>, Database.Stateful {

    //private Integer daysBefore;
    Integer totalRepLegal = 0;
    Integer totalOpp = 0;
    Boolean firstLoop = FALSE;

    /*public BatchSIGLO_InitialLoad(Integer daysParam) {
        daysBefore = daysParam;
    }*/

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String headerClientes =  '{"header": {"Recordtype": "", "ProductId": "", "SendDate": "'+String.valueOf(Date.today())+'"}, "body":[';
        String headerTransacciones =  '{"header": {"Recordtype": "", "ProductId": "", "SendDate": "'+String.valueOf(Date.today())+'"}, "body":[';

        List<Document> initialLoadDocs = new List<Document>();
        Document clientesDocument = new Document();

        Folder folder = [SELECT Id FROM Folder WHERE Name = 'SIGLO Inital Load' LIMIT 1];
        
        clientesDocument.Name = 'SIGLO_Clientes_InitialLoadd'; 
        clientesDocument.Body =  Blob.valueOf(headerClientes); 
        clientesDocument.ContentType = 'text/plain';
        clientesDocument.Type = 'txt';
        clientesDocument.FolderId = folder.Id;
        initialLoadDocs.add(clientesDocument);
        
        Document transaccionesDocument = new Document(); 
        transaccionesDocument.Name = 'SIGLO_Transacciones_InitialLoadd'; 
        transaccionesDocument.Body =  Blob.valueOf(headerTransacciones);
        transaccionesDocument.ContentType = 'text/plain';
        transaccionesDocument.Type = 'txt';
        transaccionesDocument.FolderId = folder.Id;
        initialLoadDocs.add(transaccionesDocument);

        insert initialLoadDocs;

        String query = 'SELECT Id, Name, CodigoClienteAS400__c, Account.Name, Account.RFC__c, Account.Website, SentToSIGLO__c,'+
                        'Entidad_Legal__r.Id, Entidad_Legal__r.Name, Entidad_Legal__r.RecordTypeId, Entidad_Legal__r.CountryOrigin__c, Entidad_Legal__r.DeedDate__c, Entidad_Legal__r.EconomicActivity__c,'+
                        'Entidad_Legal__r.Calle__c, Entidad_Legal__r.NumeroExterior__c, Entidad_Legal__r.NumeroInterior__c, Entidad_Legal__r.Colonia__c, Entidad_Legal__r.Estado__c,'+
                        'Entidad_Legal__r.CodigoPostal__c, Entidad_Legal__r.FEA__c, Entidad_Legal__r.DeedNumber__c, Entidad_Cuenta__c, Contrato_Filial__r.Contrato_2__r.contacto__c '+
                        'FROM Opportunity '+
                        'WHERE Contrato_Filial__c != null ';
                        //AND Contrato_Filial__r.isActive__c = TRUE
                        //AND Contrato_Filial__r.Producto__r.SendToSIGLO__c = TRUE
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> opportunitiesList) {
        Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>(opportunitiesList);
        
        List<Quote> quotesList = [SELECT Id, OpportunityId, OperationsInDollars__c, TransactionsEstimatedNumber__c, TotalPrice FROM Quote WHERE OpportunityId IN : opportunitiesList];
        Map<Id, Quote> oppQuotesMap = new Map<Id, Quote>();
        for(Quote quote : quotesList){
            oppQuotesMap.put(quote.OpportunityId, quote);
        }
        
        Set<Id> entidadCuentaIdList = new Set<Id>(); 
        for(Opportunity opp : opportunitiesList){
            entidadCuentaIdList.add(opp.Entidad_Cuenta__c);
        }
        
        Set<Id> contactIdList = new Set<Id>();
        for(Opportunity opp : opportunitiesList){
            contactIdList.add(opp.Contrato_Filial__r.Contrato_2__r.contacto__c);
        }

        List<Contact> contactsList = [SELECT Id, Name, Account.RFC__c, Account.Website, Nationality__c, Phone, Birthdate, Curp__c, 
                                      Email, Telefono2__c, Calle__c, NumeroExterior__c, NumeroInterior__c, Colonia__c, BirthState__c, 
                                      Fax, ElectorID__c, Estado__c, CodigoPostal__c, ProfessionName__c, Gender__c, BirthCountry__c
                                      FROM Contact 
                                      WHERE Id IN (SELECT Contacto__c FROM ContactoEntidad__c WHERE Entidad_Cuenta__c IN: entidadCuentaIdList)];
        
        /*List<Contact> contactsList = [SELECT Id, Name, Account.RFC__c, Account.Website, Nationality__c, Phone, Birthdate, Curp__c, 
                                      Email, Telefono2__c, Calle__c, NumeroExterior__c, NumeroInterior__c, Colonia__c, BirthState__c, 
                                      Fax, ElectorID__c, Estado__c, CodigoPostal__c, ProfessionName__c, Gender__c, BirthCountry__c
                                      FROM Contact 
                                      WHERE Id IN: contactIdList];*/
        Map<Id, Contact> contactsMap = new Map<Id, Contact>(contactsList);
        
        Contact contact;
        Map<Id, Contact> oppContactsMap = new Map<Id, Contact>();
        /*for (Opportunity opp : opportunitiesMap.values()) {
            contact = contactsMap.get(opp.Entidad_Legal__r.Id);
            totalRepLegal = contact != null ? totalRepLegal + 1 : totalRepLegal;
            oppContactsMap.put(opp.Id, contactsMap.get(opp.Entidad_Legal__r.Id));            
        }*/

        for (Id mapKey : opportunitiesMap.keySet()) {
            contact = contactsMap.get(opportunitiesMap.get(mapKey).Contrato_Filial__r.Contrato_2__r.contacto__c);
            totalRepLegal = contact != null ? totalRepLegal + 1 : totalRepLegal;
            oppContactsMap.put(mapKey, contactsMap.get(opportunitiesMap.get(mapKey).Contrato_Filial__r.Contrato_2__r.contacto__c));            
        }

        totalOpp = totalOpp + opportunitiesMap.values().size();
        
        String personasJSONBody  = SIGLO_Clientes_FieldMapping.createJSON(opportunitiesMap, oppContactsMap, oppQuotesMap, false); //Persona
        String repLegalJSONBody  = SIGLO_Clientes_FieldMapping.createJSON(opportunitiesMap, oppContactsMap, oppQuotesMap, true); //Rep Legal

        String transaccionesJSONBody  = SIGLO_Transaccional_FieldMapping.createJSON(opportunitiesMap, oppQuotesMap);

        String clientesJSON = firstLoop ? personasJSONBody + ',' + repLegalJSONBody : ',' + personasJSONBody + ',' + repLegalJSONBody;
        String transaccionesJSON = firstLoop ? transaccionesJSONBody : ',' + transaccionesJSONBody;

        List<Document> updateDocs = new List<Document>();
        Document clientesDoc = [Select Name, Body FROM Document where Name = 'SIGLO_Clientes_InitialLoadd' LIMIT 1];
        Document transaccionesDoc = [Select Name, Body FROM Document where Name = 'SIGLO_Transacciones_InitialLoadd' LIMIT 1];
        if(clientesJSON != null){clientesDoc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(clientesDoc.Body) + EncodingUtil.convertToHex(Blob.valueOf(clientesJSON)));}
        if(transaccionesJSON != null){transaccionesDoc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(transaccionesDoc.Body) + EncodingUtil.convertToHex(Blob.valueOf(transaccionesJSON)));}
        updateDocs.add(clientesDoc);
        updateDocs.add(transaccionesDoc);
        update updateDocs; 

        firstLoop = false;
        
    }   

    global void finish(Database.BatchableContext BC) {
        String trailerClientes =  '], "trailer": {"TotalRecord": '+String.valueOf(totalRepLegal+totalOpp)+'}}';
        String trailerTransacciones =  '], "trailer": {"TotalRecord": '+String.valueOf(totalOpp)+'}}';

        List<Document> finishDocs = new List<Document>();
        Document clientesDoc = [Select Name, Body FROM Document where Name = 'SIGLO_Clientes_InitialLoadd' LIMIT 1];
        Document transaccionesDoc = [Select Name, Body FROM Document where Name = 'SIGLO_Transacciones_InitialLoadd' LIMIT 1];
        clientesDoc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(clientesDoc.Body) + EncodingUtil.convertToHex(Blob.valueOf(trailerClientes)));
        transaccionesDoc.Body = EncodingUtil.convertFromHex(EncodingUtil.convertToHex(transaccionesDoc.Body) + EncodingUtil.convertToHex(Blob.valueOf(trailerTransacciones)));
        finishDocs.add(clientesDoc);
        finishDocs.add(transaccionesDoc);
        update finishDocs; 

    }
}