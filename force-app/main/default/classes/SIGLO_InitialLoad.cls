public class SIGLO_InitialLoad {
    
    public static void generateJSONContent(List<Opportunity> opportunitiesList) {
        
        Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>(opportunitiesList);
        
        List<Quote> quotesList = [SELECT Id, OpportunityId, OperationsInDollars__c, TransactionsEstimatedNumber__c, TotalPrice FROM Quote WHERE OpportunityId IN : opportunitiesList];
        Map<Id, Quote> oppQuotesMap = new Map<Id, Quote>();
        for(Quote quote : quotesList){
            oppQuotesMap.put(quote.OpportunityId, quote);
        }
        
        Set<Id> contactIdList = new Set<Id>(); //Rep Legal
        for(Opportunity opp : opportunitiesList){
            //contactIdList.add(opp.Contrato_Filial__r.Contrato_2__r.contacto__c);
        }
        
        Set<Id> entidadLegalIdList = new Set<Id>(); //Rep Legal
        for(Opportunity opp : opportunitiesList){
            entidadLegalIdList.add(opp.Entidad_Legal__r.Id);
        }
        
        Map<Id, Id> contactoEntidadMap = new Map<Id, Id>();
        List<ContactoEntidad__c> ceList = [SELECT Id, EntidadLegal__c, Contacto__c FROM ContactoEntidad__c WHERE EntidadLegal__c IN: entidadLegalIdList];
        for(ContactoEntidad__c ce : ceList){
            if(ce.Contacto__c != null){
                contactIdList.add(ce.Contacto__c);
                contactoEntidadMap.put(ce.EntidadLegal__c, ce.Contacto__c);
            }
        }
        
        
        List<Contact> contactsList = [SELECT Id, Name, Account.RFC__c, Account.Website, Nationality__c, Phone, Birthdate, Curp__c, 
                                      Email, Telefono2__c, Calle__c, NumeroExterior__c, NumeroInterior__c, Colonia__c, BirthState__c, 
                                      Fax, ElectorID__c, Estado__c, CodigoPostal__c, ProfessionName__c, Gender__c, BirthCountry__c
                                      FROM Contact 
                                      WHERE Id IN: contactIdList];
        Map<Id, Contact> contactsMap = new Map<Id, Contact>(contactsList);
        
        Map<Id, Contact> oppContactsMap = new Map<Id, Contact>();
        /*for (Id mapKey : opportunitiesMap.keySet()) {
        oppContactsMap.put(mapKey, contactsMap.get(opportunitiesMap.get(mapKey).Contrato_Filial__r.Contrato_2__r.contacto__c));
        }*/
        Integer totalRepLegal = 0;
        Contact contact;
        for (Opportunity opp : opportunitiesMap.values()) {
            contact = contactsMap.get(opp.Entidad_Legal__r.Id);
            totalRepLegal = contact != null ? totalRepLegal + 1 : totalRepLegal;
            oppContactsMap.put(opp.Id, contactsMap.get(opp.Entidad_Legal__r.Id));            
        }
        
        String personasJSONBody  = SIGLO_Clientes_FieldMapping.createJSON(opportunitiesMap, oppContactsMap, oppQuotesMap, false); //Persona
        String repLegalJSONBody  = SIGLO_Clientes_FieldMapping.createJSON(opportunitiesMap, oppContactsMap, oppQuotesMap, true); //Rep Legal
        
        String transaccionesJSONBody  = SIGLO_Transaccional_FieldMapping.createJSON(opportunitiesMap, oppQuotesMap); //Transacciones
        
        String totalRecords = String.valueOf(opportunitiesMap.values().size() + totalRepLegal);
        
        String headerClientes =  '{"header": {"Recordtype": "", "ProductId": "", "SendDate": "'+String.valueOf(Date.today())+'"}, "body":[';
        String trailerClientes =  '], "trailer": {"TotalRecord": '+totalRecords+'}}';
        
        String headerTransacciones =  '{"header": {"Recordtype": "", "ProductId": "", "SendDate": "'+String.valueOf(Date.today())+'"}, "body":[';
        String trailerTransacciones =  '], "trailer": {"TotalRecord": '+String.valueOf(opportunitiesMap.values().size())+'}}';
        
        //Crear header y trailer como string
        String clientesJSON = headerClientes + personasJSONBody + ',' + repLegalJSONBody + trailerClientes;
        String transaccionesJSON = headerTransacciones + transaccionesJSONBody + trailerTransacciones;
        
        List<Document> initialLoadDocs = new List<Document>();
        
        Document clientesDocument = new Document(); 
        
        //Blob cryptoKey = Crypto.generateAesKey(128);
        //Blob cryptoKey = Blob.valueOf([SELECT key__c FROM SIGLO_Crypto_Key__mdt].key__c);
        
        Folder folder = [SELECT Id FROM Folder WHERE Name = 'SIGLO Inital Load' LIMIT 1];
        
        clientesDocument.Name = 'SIGLO_Clientes_InitialLoadd'; 
        //clientesDocument.Body =  Crypto.encryptWithManagedIV('AES128', cryptoKey, Blob.valueOf(clientesJSON)); 
        clientesDocument.Body =  Blob.valueOf(clientesJSON); 
        clientesDocument.ContentType = 'text/plain';
        clientesDocument.Type = 'txt';
        clientesDocument.FolderId = folder.Id;
        initialLoadDocs.add(clientesDocument);
        
        Document transaccionesDocument = new Document(); 
        transaccionesDocument.Name = 'SIGLO_Transacciones_InitialLoadd'; 
        //transaccionesDocument.Body =  Crypto.encryptWithManagedIV('AES128', cryptoKey, Blob.valueOf(transaccionesJSON));
        transaccionesDocument.Body =  Blob.valueOf(transaccionesJSON);
        transaccionesDocument.ContentType = 'text/plain';
        transaccionesDocument.Type = 'txt';
        transaccionesDocument.FolderId = folder.Id;
        initialLoadDocs.add(transaccionesDocument);
        
        insert initialLoadDocs;
        
        List<Opportunity> sentToSIGLO = new List<Opportunity>();
        for(Opportunity opp : opportunitiesList){
            opp.SentToSIGLO__c = TRUE;
            sentToSIGLO.add(opp);
        }
        
        //upsert sentToSIGLO;
        
        
    }
    
}