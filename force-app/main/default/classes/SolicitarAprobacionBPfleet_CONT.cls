public without sharing class SolicitarAprobacionBPfleet_CONT {
    @AuraEnabled
    public static String solicitarAprobacion(String idRegistro){        
        Id idReg=idRegistro;
        if(String.valueOf(idReg.getSobjectType())=='Lead'){
            Lead tem=[Select Id,Approver__c from Lead where Id=:idRegistro];
            if(tem.Approver__c==null){
               return 'Error'; 
            }
            Lead pro=new Lead(Id=idRegistro);pro.StatusApprovalBPfleet__c='En espera de aprobación';
            crearColaboracion('Lead',idRegistro,tem.Approver__c);
            if(!Test.isRunningTest()){update pro;}
        }else if(String.valueOf(idReg.getSobjectType())=='Opportunity'){
            Opportunity tem=[Select Id,Approver__c from Opportunity where Id=:idRegistro];
            if(tem.Approver__c==null){
               return 'Error'; 
            }
            Opportunity opp=new Opportunity(Id=idRegistro);opp.StatusApprovalBPfleet__c='En espera de aprobación';
            crearColaboracion('Opportunity',idRegistro,tem.Approver__c);
            if(!Test.isRunningTest()){update opp;}
        }
        return '';
    }
    @AuraEnabled
    public static boolean getInfo(String idRegistro){
        boolean res=false;
        Id idReg=idRegistro;
        if(String.valueOf(idReg.getSobjectType())=='Lead'){
            Lead pr=[Select Id,StatusApprovalBPfleet__c,BPfleetApproval__c from Lead where Id=:idRegistro];
            res=pr.StatusApprovalBPfleet__c==null&&pr.BPfleetApproval__c ? true : false;
        }else if(String.valueOf(idReg.getSobjectType())=='Opportunity'){
            Opportunity opp=[Select Id,StatusApprovalBPfleet__c,BPfleetApproval__c from Opportunity where Id=:idRegistro];
            res=opp.StatusApprovalBPfleet__c==null&&opp.BPfleetApproval__c ? true : false;
        }
        return res;
    }
    public static void crearColaboracion(String obj,String idReg,String idAprob){
        if(obj.equalsIgnoreCase('Lead')){
            Integer intReg=[Select count() from LeadShare where LeadId=:idReg and UserOrGroupId=:idAprob and LeadAccessLevel='Edit'];
            if(intReg==0){
                insert new LeadShare(LeadId=idReg,UserOrGroupId=idAprob,LeadAccessLevel='Edit');
            }
        }else if(obj.equalsIgnoreCase('Opportunity')){
            Integer intReg=[Select count() from OpportunityShare where OpportunityId=:idReg and UserOrGroupId=:idAprob and OpportunityAccessLevel='Edit'];
            if(intReg==0){
                insert new OpportunityShare(OpportunityId=idReg,UserOrGroupId=idAprob,OpportunityAccessLevel='Edit');
            }
        }
    }
}