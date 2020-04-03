/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @creation	03/03/2020	Mass update to account solutions field. 	
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
global class Batch_UpdateAccountSolutions implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            Select Id, (SELECT Id FROM Entidades_Cuenta__r LIMIT 1)
              From Account Where SolutionsText__c = ''
            ]);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){
        List<EntidadCuenta__c> entidadesList = new List<EntidadCuenta__c>();
        for(Account r : scope){
            if(!r.Entidades_Cuenta__r.isEmpty()) {
           		entidadesList.add(r.Entidades_Cuenta__r); 
            }
        }
        if(!entidadesList.isEmpty()) {
        	Vista_DinamicaController.updateAccountSolutions(entidadesList);
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}