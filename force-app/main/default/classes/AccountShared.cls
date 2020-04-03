public  Without Sharing class AccountShared {
    @AuraEnabled 
    public static List<Object> GetAccountShared(String IdAccount){
        Set<id> idUsuario = new Set<id>();
        if(String.isEmpty(IdAccount)){
            return null;
        }else{
            List<AccountShare> cuentas= [SELECT id, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, UserOrGroupId FROM AccountShare WHERE AccountId=:IdAccount AND ROWCAUSE!='Owner' limit 1000];
            for(AccountShare cola : cuentas){
                if(!idUsuario.contains(cola.UserOrGroupId)){
                    idUsuario.add(cola.UserOrGroupId);
                }
            }
            Map<id, User> usuarios = new Map<id, User>([SELECT Id, Name, Manager.Name From User where id =: idUsuario]);
            return CreateObject(cuentas, usuarios);
        }
    }
    
    @AuraEnabled 
    public static List<Object> CreateObject(List<AccountShare> cuentas, Map<id, User> usuarios){
        List<Colaboracion> colaboracion = new List<Colaboracion>();
        for(AccountShare cuenta: cuentas){
             colaboracion.add(new Colaboracion(cuenta.OpportunityAccessLevel,
             cuenta.AccountAccessLevel, cuenta.CaseAccessLevel, cuenta.ContactAccessLevel,
             cuenta.UserOrGroupId, usuarios.get(cuenta.UserOrGroupId)));
        }
        system.debug('Result AccountShare '+ colaboracion);
       
        return colaboracion;
    }
    
    public class Colaboracion{
        @AuraEnabled 
        public String OpportunityAccessLevel {get; set;}
        @AuraEnabled 
        public String AccountAccessLevel{get; set;}
        @AuraEnabled 
        public String CaseAccessLevel{get; set;}
        @AuraEnabled 
        public String ContactAccessLevel{get; set;}
        @AuraEnabled 
        public Id UserOrGroupId{get; set;}
        @AuraEnabled 
        public User UserName{get; set;}
        
        public Colaboracion(String OpportunityAccessLevel, String AccountAccessLevel, String CaseAccessLevel, String ContactAccessLevel, Id UserOrGroupId, User UserName){
            this.OpportunityAccessLevel=OpportunityAccessLevel;
            this.AccountAccessLevel=AccountAccessLevel;
            this.CaseAccessLevel=CaseAccessLevel;
            this.ContactAccessLevel=ContactAccessLevel;
            this.UserOrGroupId=UserOrGroupId;
            this.UserName=UserName;
        }
    }
    
    @InvocableMethod
    public static void InvokeAccountApproachLevel(List<Id> accountIds){
        AccountApproachLevel(accountIds);
    }
    
    public static void AccountApproachLevel(List<Id> accountIds){
        List<Account> accs = [
            Select Id, Name, FechaUltimaActividad__c, CreatedDate,
                   (Select Id, TimestampCompletada__c, LastModifiedDate
                      from ActivityHistories
                     where isAlert__c = false
                     order by TimestampCompletada__c desc nulls last, LastModifiedDate desc
                     limit 1),
                   (Select Id, LastModifiedDate from Opportunities order by LastModifiedDate desc limit 1),
                   (Select Id, LastModifiedDate from Amenazas__r order by LastModifiedDate desc limit 1)
              From Account
             where Id in: accountIds
        ];
        
        Set<Id> aIds = new Set<Id>();
        for(Account a : accs){
            aIds.add(a.Id);
        }
        
        List<ContratoFilial__c> cfs = [
            Select Id, OwnerId, Entidad_Cuenta__r.Cuenta__c
              from ContratoFilial__c
             where Entidad_Cuenta__r.Cuenta__c in: aIds
        ];
        
        Map<Id, Set<Id>> mcfs = new Map<Id, Set<Id>>();
        Set<Id> os = new Set<Id>();
        for(ContratoFilial__c cf : cfs){
            os.add(cf.OwnerId);
            if(!mcfs.containsKey(cf.Entidad_Cuenta__r.Cuenta__c)) mcfs.put(cf.Entidad_Cuenta__r.Cuenta__c, new Set<Id>());
            Set<Id> sos = mcfs.get(cf.Entidad_Cuenta__r.Cuenta__c);
            sos.add(cf.OwnerId);
            mcfs.put(cf.Entidad_Cuenta__r.Cuenta__c, sos);
        }
        
        List<Case> ts = [
            Select Id, CreatedById, AccountId, CreatedDate
              from Case
             where AccountId in: mcfs.KeySet()
               and CreatedById in: os
        ];
        
        Map<Id, List<Case>> mts = new Map<Id, List<Case>>();
        for(Case t : ts){
            if(mcfs.containsKey(t.AccountId) && mcfs.get(t.AccountId).contains(t.CreatedById)){
                if(!mts.containsKey(t.AccountId)) mts.put(t.AccountId, new List<Case>());
                List<Case> lts = mts.get(t.AccountId);
                lts.add(t);
                mts.put(t.AccountId, lts);
            }
        }
        
        List<Account> uaccs = new List<Account>();
        for(Account a : accs){
            DateTime fecha = a.FechaUltimaActividad__c;
            if(fecha == null) fecha = a.CreatedDate;
            if(a.ActivityHistories != null && a.ActivityHistories.size() > 0){
                if(a.ActivityHistories[0].TimestampCompletada__c != null){
                    if(a.ActivityHistories[0].TimestampCompletada__c > fecha){
                        fecha = a.ActivityHistories[0].TimestampCompletada__c;
                    }
                }
                else{
                    if(a.ActivityHistories[0].LastModifiedDate > fecha){
                        fecha = a.ActivityHistories[0].LastModifiedDate;
                    }
                }
            }
            if(a.Opportunities != null && a.Opportunities.size() > 0){
                if(a.Opportunities[0].LastModifiedDate > fecha){
                    fecha = a.Opportunities[0].LastModifiedDate;
                }
            }
            if(a.Amenazas__r != null && a.Amenazas__r.size() > 0){
                if(a.Amenazas__r[0].LastModifiedDate > fecha){
                    fecha = a.Amenazas__r[0].LastModifiedDate;
                }
            }
            if(mts.containsKey(a.Id)){
                for(Case t : mts.get(a.Id)){
                    if(t.CreatedDate > fecha){
                        fecha = t.CreatedDate;
                    }
                }
            }
            if(fecha != a.FechaUltimaActividad__c && fecha != a.CreatedDate){
                a.FechaUltimaActividad__c = fecha;
                uaccs.add(a);
            }
        }
        
        database.update(uaccs, false);
    }
}