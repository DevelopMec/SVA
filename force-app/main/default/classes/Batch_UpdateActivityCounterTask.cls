global class Batch_UpdateActivityCounterTask implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
        Integer fiscalMonth = [
            SELECT FiscalYearStartMonth 
            FROM Organization].FiscalYearStartMonth;
        Date fiscalYear = Date.newinstance(
            system.today().year(), 
            fiscalMonth, 
            1
        );
        return Database.getQueryLocator([
            SELECT Id, WhoId, WhatId, TaskSubtype, ActivityType__c, TaskNumber__c 
            FROM Task 
            WHERE Status = 'Concluida' 
            AND TaskSubtype != 'Email' 
            AND createdDate >= :fiscalYear
            ORDER BY createdDate ASC
        ]);
    }
    global void execute(Database.BatchableContext BC, List<Task> listTask){
        if(listTask.size() > 0){
            for(Task tarea : listTask){
                List<Task> listtaskNew = new List<Task>();
                listtaskNew.add(tarea);
                ActivityCounter.generaContadorTipoTarea(listtaskNew);
            }
        }
    }
    global void finish(Database.BatchableContext BC){}
}