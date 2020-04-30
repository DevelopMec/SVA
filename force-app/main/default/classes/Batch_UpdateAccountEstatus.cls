global class Batch_UpdateAccountEstatus implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, status__c, (SELECT Id FROM Entidades_Cuenta__r LIMIT 1) From Account]);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){
        List<EntidadCuenta__c> entidadesList = new List<EntidadCuenta__c>();
        List<Account> cuentaList = new List<Account>();
        for(Account r : scope){
            if(!r.Entidades_Cuenta__r.isEmpty()) {
           		entidadesList.add(r.Entidades_Cuenta__r); 
            } else { 
               r.Status__c = 'Prospecto';
               cuentaList.add(r); 
            }
        }
        if(!entidadesList.isEmpty()) {
        	AccountSubAccount.updateAccountEstatus(entidadesList);
        }
        if(!cuentaList.isEmpty()){
            database.update(cuentaList, false);
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}