global class BachOrdenesTrabajoAsignarEntidadLegal implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = Test.isRunningTest() ? 'SELECT Id, Entidad_Legal__c,(Select Id,Entidad_Cuenta__c,Entidad_Cuenta__r.EntidadLegal__c from Contratos_Filial__r) FROM WorkOrder where Entidad_Legal__c=null limit 10' : 'SELECT Id, Entidad_Legal__c,(Select Id,Entidad_Cuenta__c,Entidad_Cuenta__r.EntidadLegal__c from Contratos_Filial__r) FROM WorkOrder where Entidad_Legal__c=null';
        
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        return resultados;
    }
        
    global void execute(Database.BatchableContext BC, List<sObject> ordenesT){
        List<WorkOrder> lwo=new List<WorkOrder>();
        for(sObject workO : ordenesT){            
            WorkOrder wo=(WorkOrder)workO;
            if(wo.Contratos_Filial__r!=null&&wo.Contratos_Filial__r.size()>0){
                wo.Entidad_Legal__c=wo.Contratos_Filial__r.get(0).Entidad_Cuenta__c!=null ? wo.Contratos_Filial__r.get(0).Entidad_Cuenta__r.EntidadLegal__c : null;
                lwo.add(wo);
            }
        }
        update lwo;
    }
    
    global void finish(Database.BatchableContext BC){}
    
}