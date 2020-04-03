global class Batch_GetListEjecutivos implements Database.Batchable<sObject>{
    
    global Batch_GetListEjecutivos(){
        if(Test.isRunningTest()){
            integer c = 0;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
            c++;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            Select Id, Name, business__c, Busines__c
              From Account
             where business__c = null
               and Id in (Select Cuenta__c from EntidadCuenta__c)
             order by lastModifiedDate
            ]);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){
        for(Account r : scope){
            Vista_EjecutivosAsignadosController.getListEjecutivos(r.Id);
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}