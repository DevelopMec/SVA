public without sharing class TriggerEstablishmentHandler extends TriggerHandler{
    private Map<Id, Establishment__c> newMap;
    private Map<Id, Establishment__c> oldMap;
    private List<Establishment__c> newList;
    private List<Establishment__c> oldList;
    public TriggerEstablishmentHandler(){
        this.newMap = (Map<Id, Establishment__c>) trigger.newMap;
        this.oldMap = (Map<Id, Establishment__c>) trigger.oldMap;
        this.newList = (List<Establishment__c>) trigger.new;
        this.oldList = (List<Establishment__c>) trigger.old; 
    }
    public override void afterUpdate(){
        actualizarNombre(this.newList,this.oldMap);
    }
    public static void actualizarNombre(List<Establishment__c> lisEs,Map<Id, Establishment__c> mapEst){
        Set<String> idsaff=new Set<String>();
        for(Establishment__c est : lisEs){
            if(est.Affiliate__c!=null){
                idsaff.add(est.Affiliate__c);
            }
        }
        Map<String,List<Establishment__c>> mapAf=new Map<String,List<Establishment__c>>();
        for(Affiliate__c af : [Select Id,(Select Id,Affiliate__r.Name,Name from Establecimientos__r) from Affiliate__c where Id IN :idsaff]){
            mapAf.put(af.Id,af.Establecimientos__r);
        }
        List<Establishment__c> lUpd=new List<Establishment__c>();
        for(String idEs : mapAf.KeySet()){
            Integer i=0;
            for(Establishment__c es : mapAf.get(idEs)){   
                i++;
                if(es.Name!=es.Affiliate__r.Name+'-'+getSecuencia(i)){   
                    String n=es.Affiliate__r.Name+'-'+getSecuencia(i);
                    lUpd.add(new Establishment__c(Id=es.Id,StationId__c =n,Name=n, EstablishmentStatus__c ='Generado'));
                }
            }
            
        }
        if(lUpd.size()>0){
            update lUpd;
        }
        
    }
    public static String getSecuencia(Integer num){
        if(num<10){
            return '00'+num;
        }else if(num>=10&&num<100){
            return '0'+num;
        }else{
            return String.valueOf(num);
        }
    }
}