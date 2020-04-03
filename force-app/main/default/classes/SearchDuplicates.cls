public without sharing  class SearchDuplicates {
	
    @AuraEnabled 
    public static List<EntidadLegal__c> GetEntidadLegal(String nombre, String rfc,String idGrupo){
        if(String.isEmpty(nombre)&&String.isEmpty(rfc)){
           return null;
        }else if(String.isEmpty(rfc)){
           return [SELECT id,Owner.Name, Name, RazonSocial__c,Cuenta__c,Cuenta__r.Name,Cuenta__r.CodigoClienteAS400__c FROM EntidadLegal__c WHERE RazonSocial__c LIKE :('%'+ nombre+ '%') limit 1000];  
        }else{
           return [SELECT id,Owner.Name, Name, RazonSocial__c,Cuenta__c,Cuenta__r.Name,Cuenta__r.CodigoClienteAS400__c FROM EntidadLegal__c WHERE Name=:rfc  limit 1000];  
        }
        
    }
    
     @AuraEnabled 
    public static List<Account> GetAccount(String nombre,String idGrupo){
        if(String.isEmpty(nombre)&&String.isEmpty(idGrupo)){
           return null;
        }else if(String.isEmpty(idGrupo)) {
           return GetAccountShared([SELECT Id,Owner.Name, Name, CodigoClienteAS400__c,Owner.Manager.Name,Segmento2__c,ClienteComplejo__c, FechaUltimaActividad__c FROM Account WHERE Name LIKE :('%'+ nombre+ '%')  limit 1000 ]);  
        }else{
             return GetAccountShared([SELECT Id,Owner.Name, Name, CodigoClienteAS400__c,Owner.Manager.Name,Segmento2__c,ClienteComplejo__c, FechaUltimaActividad__c FROM Account WHERE CodigoClienteAS400__c =:idGrupo limit 1000 ]);  
        }
        
    }
    
     @AuraEnabled 
    public static List<Account> GetAccountShared(List<Account> listaAccount){
     	List<AccountShare> listaColaboracion =[SELECT AccountId from AccountShare where AccountId=:listaAccount AND ROWCAUSE!='Owner' ]; 
        List<Account> cuentas =new  List<Account>();
        Set<id> idCuentas =new Set<id>();
        Set<id> idCuentasOpp =new Set<id>();
        Map<String, DateTime> mapaOppDate=new Map<String,DateTime>();

        for(AccountShare colaboracion :listaColaboracion){
            idCuentas.add(colaboracion.AccountId);
        }
        
        for(Account acc: listaAccount){
            idCuentasOpp.add(acc.Id);
        }
        
        string idAccOpp;
        for(Opportunity opp: [SELECT AccountId, FORMAT(FechaUltimaActividad__c), (Select Id, Subject, IsAlert__c from Tasks) FROM Opportunity WHERE AccountId IN:idCuentasOpp AND FechaUltimaActividad__c != NULL ORDER BY AccountId, FechaUltimaActividad__c DESC LIMIT 1000]){
            boolean isAlert = false;
            List<Task> tareas = opp.getSObjects('Tasks');
            if (tareas.Size() != 0){
                for(Task tarea:tareas){
                	isAlert = tarea.IsAlert__c;    
                }
            }
            
            if (idAccOpp != opp.AccountId && !isAlert) {
            	mapaOppDate.put(opp.AccountId, opp.FechaUltimaActividad__c);
                idAccOpp = opp.AccountId;
            }
        }
        
        
        
        for(Account cuenta :listaAccount){
            if(idCuentas.contains(cuenta.Id)){
                cuenta.ClienteComplejo__c=true;
            }else{
                cuenta.ClienteComplejo__c=false;
            }
            
            if (mapaOppDate.containsKey(cuenta.Id)){
                System.debug('cuenta.Id ' + cuenta.Id);
                System.debug('Fecha ' + mapaOppDate.get(cuenta.Id));
            	cuenta.FechaUltimaActividad__c = mapaOppDate.get(cuenta.Id);    
            }
            else{
                cuenta.FechaUltimaActividad__c = null;   
            }
                
            
            cuentas.add(cuenta);
        }
         system.debug('Result AccountShare '+cuentas);
        return cuentas;   
    }

     @AuraEnabled 
    public static List<Lead> GetLead(String nombre){
        if(String.isEmpty(nombre)){
           return  null;
        }else{
             return [SELECT Owner.Name,Company,CategoriaSolucion__c, Name,Segmento__c,Status,FORMAT(FechaUltimaActividad__c)FROM Lead WHERE isConverted=false And(  Name like :('%'+nombre+'%')  or Company like :('%'+nombre+'%') )limit 1000 ];  
        }
        
    }

     @AuraEnabled 
    public static List<Opportunity> GetOpportunity(String nombre){
        if(String.isEmpty(nombre)){
           return  null;
        }else{
             return [SELECT Owner.Name,Familia__c, Name,Account.Name,Account.Segmento2__c,Account.CodigoClienteAS400__c,Owner.Manager.Name, FORMAT(FechaUltimaActividad__c) FROM Opportunity WHERE Name like :('%'+nombre+'%')  limit 1000 ];  
        }
        
    }

     @AuraEnabled 
    public static List<Contact> GetContact(String nombre){
        if(String.isEmpty(nombre)){
           return  null;
        }else{
             return [SELECT  Name ,Funcion__c ,Account.CodigoClienteAS400__c ,Account.Name,Owner.Name ,Owner.Manager.Name FROM Contact WHERE Name like :('%'+nombre+'%')  or Account.name like :('%'+nombre+'%')  limit 1000 ];  
        }
        
    }
    
  
}