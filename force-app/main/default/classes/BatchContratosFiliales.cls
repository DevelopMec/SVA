global with sharing class BatchContratosFiliales Implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Database.QueryLocator resultados=  Database.getQueryLocator('SELECT Id,isActive__c,Amount_last_order__c,Last_order_date__c,Entidad_Cuenta__c  FROM ContratoFilial__c Order By Entidad_Cuenta__c,CreatedDate DESC');
        return resultados;
    }
    global void execute(Database.BatchableContext BC, List<sObject> contratos){ 
        
        List<ContratoFilial__c> contratosFilial = (List<ContratoFilial__c>) contratos;
        List<ContratoFilial__c> contratosActualizados =  new List<ContratoFilial__c>();
        Map<Id,ContratoFilial__c> mapContratos = new Map<Id,ContratoFilial__c>();
        
        Date dateEnd = date.newinstance(Date.today().year(), Date.today().month(), 1);
        dateEnd = dateEnd.addDays(-1);
        Date dateIni= dateEnd.addMonths(-12);
        for(ContratoFilial__c con : contratosFilial) {
            if(con.Last_order_date__c >=  dateIni && con.Last_order_date__c <= dateEnd && con.Amount_last_order__c > 0){
                con.isActive__c = true;
            } else {
                con.isActive__c = false;
            }
            contratosActualizados.add(con);
        }
        mapContratos.putall(contratosActualizados);
        Database.update(mapContratos.values(),false);
    }

    global void finish(Database.BatchableContext Bc) {

    }
    
}