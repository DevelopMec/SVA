public without sharing class TiempoReasignacionSemaforo {
    @AuraEnabled
    public static semaforosWP getInfoSemaforos(String recordId){
        semaforosWP res=new semaforosWP();
        Id idob=recordId;
        String objectName = String.valueOf(idob.getSobjectType());
        res.objeto=objectName;
        String query='Select Id,FechaReasignacion__c,FechaUltimaActividad__c,NumeroReasignacion__c from '+objectName+' where Id=:recordId';
        sObject so=Database.query(query);
        if(objectName=='Lead'){
            Lead p=(Lead)so;
            //Lead p=[Select Id,FechaReasignacion__c,FechaUltimaActividad__c,NumeroReasignacion__c from Lead where Id=:recordId];
            res.numReas=p.NumeroReasignacion__c!=null ? Integer.ValueOf(p.NumeroReasignacion__c) : -1;
            res.diasResAct=p.FechaUltimaActividad__c!=null ? Date.valueOf(p.FechaUltimaActividad__c.date()).DaysBetween(Date.today()) : p.FechaReasignacion__c!=null ? Date.valueOf(p.FechaReasignacion__c.date()).DaysBetween(Date.today()) : -1;
            res.diasResFR=p.FechaReasignacion__c!=null ? Date.valueOf(p.FechaReasignacion__c.date()).DaysBetween(Date.today()) : -1;
        }else if(objectName=='Opportunity'){
            Opportunity p=(Opportunity)so;
            //Lead p=[Select Id,FechaReasignacion__c,FechaUltimaActividad__c,NumeroReasignacion__c from Lead where Id=:recordId];
            res.numReas=p.NumeroReasignacion__c!=null ? Integer.ValueOf(p.NumeroReasignacion__c) : -1;
            res.diasResAct=p.FechaUltimaActividad__c!=null ? Date.valueOf(p.FechaUltimaActividad__c.date()).DaysBetween(Date.today()) : p.FechaReasignacion__c!=null ? Date.valueOf(p.FechaReasignacion__c.date()).DaysBetween(Date.today()) : -1;
            res.diasResFR=p.FechaReasignacion__c!=null ? Date.valueOf(p.FechaReasignacion__c.date()).DaysBetween(Date.today()) : -1;
        }
        res.variables=Negocio__c.getInstance();
        return res;
    }
    public class semaforosWP{
        @AuraEnabled public Integer diasResAct{get;set;}
        @AuraEnabled public Integer diasResFR{get;set;}
        @AuraEnabled public Integer numReas{get;set;}
        @AuraEnabled public String objeto{get;set;}
        @AuraEnabled public Negocio__c variables{get;Set;}
    }    
}