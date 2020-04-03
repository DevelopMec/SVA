global class SemaforosSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
       //String queryFL='Select Id,FechaUltimaActividad__c,NumeroReasignacion__c,FechaReasignacion__c from Lead where FechaReasignacion__c!=null and NumeroReasignacion__c=1';
       String queryDL='Select Id,FechaUltimaActividad__c,NumeroReasignacion__c,FechaReasignacion__c,Owner.UserRole.Name,OwnerId from Lead where FechaReasignacion__c!=null and NumeroReasignacion__c>=10 and NumeroReasignacion__c<=13 and IsConverted=false and CountryCode!=\'PE\' and CountryCode!=\'CO\' and Status!=\'Calificado\' and Status!=\'No interesado\' and Status!=\'Descartado\'';
       //String queryFO='Select Id,FechaUltimaActividad__c,NumeroReasignacion__c,FechaReasignacion__c,CloseDate,StageName,Account.CodigoClienteAS400__c,AccountId from Opportunity where FechaReasignacion__c!=null and NumeroReasignacion__c=1';
       String queryDO='Select Id,FechaUltimaActividad__c,NumeroReasignacion__c,FechaReasignacion__c,CloseDate,StageName,Account.CodigoClienteAS400__c,AccountId,Owner.UserRole.Name,OwnerId from Opportunity where FechaReasignacion__c!=null and ((NumeroReasignacion__c>=10 and NumeroReasignacion__c<=13) or (NumeroReasignacion__c>=20 and NumeroReasignacion__c<=22)) and (StageName=\'Cotización\' or StageName=\'Contrato\')';
       /*BatchSemaforosLead semFieldLead = new BatchSemaforosLead(queryFL,'FIELD'); 
       Database.executebatch(semFieldLead);*/
       
       BatchSemaforosLead semDistantLead = new BatchSemaforosLead(queryDL,'DISTANT'); 
       Database.executebatch(semDistantLead,200);
       
       /*BatchSemaforosOportunidad semFieldOpp = new BatchSemaforosOportunidad(queryFO,'FIELD'); 
       Database.executebatch(semFieldOpp,200);*/
       
       BatchSemaforosOportunidad semDistantOpp = new BatchSemaforosOportunidad(queryDO,'DISTANT'); 
       Database.executebatch(semDistantOpp,200);
   }
}