public with sharing class AsignacionAutomatica {

    @AuraEnabled 
    public static List<User> getUsers(){
        Map<Id,Profile> profileName=getProfileName();        
        List<User> usuarios= new List<User>();
        if(profileName.get(UserInfo.getProfileId()).Name=='Coordinador de implementación'){
            usuarios=[SELECT ID, NAME,Asignaciones_PL__c,FiltroAsignacion_MSPL__c from User WHERE IsActive=true and profile.Name='Implementación'];
        }
        else if(profileName.get(UserInfo.getProfileId()).Name=='Administración de Ventas'){
            usuarios=[SELECT ID, NAME,Asignaciones_PL__c,FiltroAsignacion_MSPL__c from User WHERE IsActive=true and profile.Name='Ejecutivo de ADV'];
        }
        else{
            usuarios=[SELECT ID, NAME,Asignaciones_PL__c,FiltroAsignacion_MSPL__c  from User WHERE IsActive=true ];
        }
        system.debug('listado '+usuarios);
        return usuarios;
    }
    
    @AuraEnabled
    public static Map<Id,Profile> getProfileName(){
        Map<Id,Profile> perfiles=new Map<id,profile>([SELECT Id, Name FROM Profile ]);
        return perfiles;
    }
     @AuraEnabled
    public static String getProfileN(){
        Map<Id,Profile> profileName=getProfileName();        
        string name= profileName.get(UserInfo.getProfileId()).Name;
        return name;
    }
    
    
}