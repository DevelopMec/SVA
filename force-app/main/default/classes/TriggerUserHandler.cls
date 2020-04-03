public without sharing class TriggerUserHandler extends triggerHandler{
    private List<User> newList;
    private Map<Id, User> oldMap;
    private Map<Id, User> newMap;
    
    public TriggerUserHandler() {
		this.newList = (List<User>) trigger.new;
        this.oldMap = (Map<Id, User>) trigger.oldMap;
        this.newMap = (Map<Id, User>) trigger.newMap;
    }
    public override void beforeUpdate(){
        copiarDepartamento(this.newList,this.oldMap);
    }
    public override void beforeInsert(){
        copiarDepartamento(this.newList,this.oldMap);
    }
    
    public override void afterUpdate(){
        crearHistorial(this.newList,this.oldMap);
    }
    
     public void copiarDepartamento(List<User> newListUser,Map<Id, User> oldMapUser){
         for(User u : newListUser){
             if((Trigger.isInsert&&u.InternalDeparment__c!=null)||(Trigger.isUpdate&&u.InternalDeparment__c!=oldMapUser.get(u.Id).InternalDeparment__c)||(Trigger.isUpdate&&u.InternalDeparment__c!=u.Department)){
                 u.Department=u.InternalDeparment__c;
             }
         }
     }
    
    public void crearHistorial(List<User> newListUser,Map<Id, User> oldMapUser){
        GeneralCatalog__c cat=[Select Id,Name,Value__c from GeneralCatalog__c where Name='Campos Historial de Usuario' and RecordType.DeveloperName='GenericRecord' limit 1];
        
        Map<String,String> mapPerfiles=new Map<String,String>();
        Map<String,String> mapFunciones=new Map<String,String>();
        Map<String,String> mapCampos=new Map<String,String>();
        
        map<string,SObjectField> fList = schema.getGlobalDescribe().get('User').getDescribe().fields.getMap();
        for(string str: fList.keySet()){
              mapCampos.put(fList.get(str).getDescribe().getName(),fList.get(str).getDescribe().getLabel());            
        }
        
        Map<String,Set<String>> mapIds=getIds(newListUser,oldMapUser);
        for(Profile prof : [Select Id,Name from Profile where Id IN:mapIds.get('idsPerfiles')]){
            mapPerfiles.put(prof.Id,prof.Name);
        }
        for(UserRole rol : [Select Id,Name from UserRole where Id IN:mapIds.get('idsfunciones')]){
            mapFunciones.put(rol.Id,rol.Name);
        }
        
        List<String> camposHistorial=cat.Value__c!=null ? cat.Value__c.split(';') : new List<String>();
        List<UserHistory__c> historial=new List<UserHistory__c>();
        for(User u : newListUser){
            for(String campo : camposHistorial){
                if(cambioCampo(campo,u,oldMapUser.get(u.Id))){
                    String campoLabel=mapCampos.containsKey(campo) ? mapCampos.get(campo) : '';
                    if(campo=='ProfileId'||campo=='UserRoleId'){
                        String valNew='';
                        String valOld='';
                        if(campo=='ProfileId'){
                            valNew=mapPerfiles.containsKey(String.valueOf(u.get(campo))) ? mapPerfiles.get(String.valueOf(u.get(campo))) : '';
                            valOld=mapPerfiles.containsKey(String.valueOf(oldMapUser.get(u.Id).get(campo))) ? mapPerfiles.get(String.valueOf(oldMapUser.get(u.Id).get(campo))) : '';
                        }else{
                            valNew=mapFunciones.containsKey(String.valueOf(u.get(campo))) ? mapFunciones.get(String.valueOf(u.get(campo))) : '';
                            valOld=mapFunciones.containsKey(String.valueOf(oldMapUser.get(u.Id).get(campo))) ? mapFunciones.get(String.valueOf(oldMapUser.get(u.Id).get(campo))) : '';
                        }
                        historial.add(new UserHistory__c(User__c=u.Id,UserPerformsModification__c=UserInfo.getUserId(),Field__c=campoLabel,NewValue__c=valNew,PriorValue__c=valOld));
                    }else{
                        historial.add(new UserHistory__c(User__c=u.Id,UserPerformsModification__c=UserInfo.getUserId(),Field__c=campoLabel,NewValue__c=String.valueOf(u.get(campo)),PriorValue__c=String.valueOf(oldMapUser.get(u.Id).get(campo))));
                    }
                }
            }
        }
        if(historial!=null&&historial.size()>0){
            insertarHistorial(JSON.serialize(historial));
        }
    }
    @future
    public static void insertarHistorial(String listHistorial){
        insert ((List<UserHistory__c>)JSON.deserialize(listHistorial, List<UserHistory__c>.class));
    }
    public boolean cambioCampo(String campo,User usuarioNew,User usuarioOld){
        if(String.valueOf(usuarioNew.get(campo))!=String.valueOf(usuarioOld.get(campo))){
            return true;
        }else{
            return false;
        }
    }
    public Map<String,Set<String>> getIds(List<User> newListUser,Map<Id, User> oldMapUser){
        Map<String,Set<String>> res=new Map<String,Set<String>>();
        Set<String> idsPerfiles=new Set<String>();
        Set<String> idsFunciones=new Set<String>();
        for(User u : newListUser){
            if(u.ProfileId!=null&&!idsPerfiles.contains(u.ProfileId)){
                idsPerfiles.add(u.ProfileId);
            } 
            if(u.UserRoleId!=null&&!idsFunciones.contains(u.UserRoleId)){
                idsFunciones.add(u.UserRoleId);
            }
        }
        for(User u : oldMapUser.values()){
            if(u.ProfileId!=null&&!idsPerfiles.contains(u.ProfileId)){
                idsPerfiles.add(u.ProfileId);
            } 
            if(u.UserRoleId!=null&&!idsFunciones.contains(u.UserRoleId)){
                idsFunciones.add(u.UserRoleId);
            }
        }
        res.put('idsPerfiles', idsPerfiles);
        res.put('idsfunciones', idsFunciones);
        return res;
    }
}