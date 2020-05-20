global class Batch_UpdateActivityCounterEvent implements Database.Batchable<sObject>{
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
            SELECT Id, WhoId, WhatId, ActivityType__c, EventNumber__c 
            FROM Event 
            WHERE EstatusEvento__c = 'Finalizado' 
            AND ActivityType__c = null 
            AND EventNumber__c = null 
            AND createdDate >= :fiscalYear
        ]);
    }
    global void execute(Database.BatchableContext BC, List<Event> listEvent){
        if(listEvent.size() > 0){ActivityCounter.generaContadorTipoEvento(listEvent);}
    }
    global void finish(Database.BatchableContext BC){}
}