public without sharing class HistorialUsuario_CONT {
    @AuraEnabled
    public static List<registrosWP> getRegistros(String idUsuario){
        List<registrosWP> res=new List<registrosWP>();
        for(UserHistory__c uh : [Select Id,Field__c,PriorValue__c,NewValue__c,UserPerformsModification__c,UserPerformsModification__r.Name from UserHistory__c where User__c=:idUsuario]){
            res.add(new registrosWP(uh.Field__c,uh.PriorValue__c,uh.NewValue__c,uh.UserPerformsModification__c,uh.UserPerformsModification__r.Name));
        }
        return res;
    }
    public class registrosWP{
        @AuraEnabled public String campo{get;set;}
        @AuraEnabled public String valorAnterior{get;set;}
        @AuraEnabled public String valorNuevo{get;set;}
        @AuraEnabled public String urlUsuario{get;set;}
        @AuraEnabled public String usuario{get;set;}
        public registrosWP(String campo,String vA,String vN,String urlU,String namU){
            this.campo=campo;
            this.valorAnterior=vA;
            this.valorNuevo=vN;
            this.urlUsuario='/'+urlU;
            this.usuario=namU;
        }
    }
}