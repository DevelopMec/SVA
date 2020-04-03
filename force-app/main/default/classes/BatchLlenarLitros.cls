global class BatchLlenarLitros implements Database.Batchable<sObject>{     
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        String query = Test.isRunningTest() ? 'SELECT Id, UnitPrice, Litros__c FROM QuoteLineItem where Quote.Familia__c=\'Combustible\' limit 1' : 'SELECT Id, UnitPrice, Litros__c FROM QuoteLineItem where Quote.Familia__c=\'Combustible\'';        
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        return resultados;
    }    
    global void execute(Database.BatchableContext BC, List<sObject> productosCot){
        List<QuoteLineItem> listQli=(List<QuoteLineItem>) productosCot;
        Precio_Litro__c pl=Precio_Litro__c.getInstance();
        for(QuoteLineItem qli : listQli){
            //qli.Litros__c=qli.UnitPrice*pl.Precio_por_litro__c;
            qli.Litros__c=qli.UnitPrice/pl.Precio_por_litro__c;
            update qli;
        }
        
    }
    global void finish(Database.BatchableContext BC){}
}