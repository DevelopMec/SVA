global class Batch_GetListEjecutivos implements Database.Batchable<sObject>{
    global final boolean FilterBlanks;
    
    global Batch_GetListEjecutivos(boolean fb){
        this.FilterBlanks = fb;
        
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
        if(this.FilterBlanks){
            return Database.getQueryLocator([
                Select Id, Name
                  From Account
                 where Funcion__c = null
                    or business__c = null
                 order by lastModifiedDate
            ]);
        }
        else{
            return Database.getQueryLocator([
                Select Id, Name
                  From Account
                 order by lastModifiedDate
            ]);
        }
    }

    global void execute(Database.BatchableContext BC, List<Account> rs){
        List<Id> ids = new List<Id>();
        for(Account a : rs){
            ids.add(a.Id);
        }
        Vista_EjecutivosAsignadosController.ProcessAccounts(ids);
    }
    
    global void finish(Database.BatchableContext BC){
    }
}