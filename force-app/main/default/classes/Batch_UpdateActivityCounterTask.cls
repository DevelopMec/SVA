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
            AND ActivityType__c = null 
            AND TaskNumber__c = null 
            AND createdDate >= :fiscalYear
        ]);
    }
    global void execute(Database.BatchableContext BC, List<Task> listTask){
        if(listTask.size() > 0){ActivityCounter.generaContadorTipoTarea(listTask);}
    }
    global void finish(Database.BatchableContext BC){}
}