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
            AND createdDate >= :fiscalYear
            ORDER BY createdDate ASC
        ]);
    }
    global void execute(Database.BatchableContext BC, List<Event> listEvent){
        if(listEvent.size() > 0){
            for(Event evento : listEvent){
                List<Event> listEventNew = new List<Event>();
                listEventNew.add(evento);
                ActivityCounter.generaContadorTipoEvento(listEventNew);
            }
        }
    }
    global void finish(Database.BatchableContext BC){}
}