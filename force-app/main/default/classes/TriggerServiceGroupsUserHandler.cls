public class TriggerServiceGroupsUserHandler extends TriggerHandler{
	private Map<Id, ServiceGroupsUser__c> newMap;
	private Map<Id, ServiceGroupsUser__c> oldMap;
	private List<ServiceGroupsUser__c> newList;
	private List<ServiceGroupsUser__c> oldList;
    private Map<String,Map<String,String>> mapaGro;
    public TriggerServiceGroupsUserHandler() {        
		this.newMap = (Map<Id, ServiceGroupsUser__c>) Trigger.newMap;
		this.oldMap = (Map<Id, ServiceGroupsUser__c>) trigger.oldMap;
		this.newList = (List<ServiceGroupsUser__c>) trigger.new;
		this.oldList = (List<ServiceGroupsUser__c>) trigger.old;
        if(!Trigger.isDelete){
            this.mapaGro=getMapG();
        }
	}
    
    public override void beforeInsert() {
        cambiaCampos(trigger.new);
    }
    
    public override void beforeUpdate() {
        cambiaCampos(trigger.new);
    }
    
    public override void afterInsert() {
        Set<String> lisOld=new Set<String>();
        for(ServiceGroupsUser__c tem: newList){
            lisOld.add(tem.ServiceGroup__c);
        }
        Map<String,ServiceGroups__c> mapSerG=new Map<String,ServiceGroups__c>();
        for(ServiceGroups__c stem:[Select Id,Users__c from ServiceGroups__c where Id IN :lisOld]){
            mapSerG.put(stem.Id, stem);
        }
        agregarUsuarioServiceGroup(trigger.new,mapSerG);
    }
    
    public override void afterUpdate() {
        verificarCambios(trigger.new);
    }
    
    public override void beforeDelete() {
        Set<String> lisOld=new Set<String>();
        for(ServiceGroupsUser__c tem: oldList){
            lisOld.add(tem.ServiceGroup__c);
        }
        Map<String,ServiceGroups__c> mapSerG=new Map<String,ServiceGroups__c>();
        for(ServiceGroups__c stem:[Select Id,Users__c from ServiceGroups__c where Id IN :lisOld]){
            mapSerG.put(stem.Id, stem);
        }
        removerUsuarioServiceGroup(oldList,mapSerG);
    }
    
    private Map<String,Map<String,String>> getMapG(){
        Map<String,Map<String,String>> res=new Map<String,Map<String,String>>();
        Map<String,String> mapGr=new Map<String,String>();
        Map<String,String> mapUsr=new Map<String,String>();
        Set<String> idsSG=new Set<String>();
        Set<String> idsUs=new Set<String>();
        System.debug('NEW::'+newList);
        for(ServiceGroupsUser__c tem: newList){
            idsSG.add(tem.ServiceGroup__c);
            idsUs.add(tem.User__c);
        }
        
        for(ServiceGroups__c tem: [Select Id,Name from ServiceGroups__c]){
            mapGr.put(tem.Id, tem.Name);
        }
        for(User tem: [Select Id,Name from User ]){
            mapUsr.put(tem.Id, tem.Name);
        }
        res.put('grupos', mapGr);
        res.put('usuarios', mapUsr);
        return res;
    }
    
    private void cambiaCampos(List<ServiceGroupsUser__c> listNe){      
        for(ServiceGroupsUser__c tem: listNe){
            tem.Name=mapaGro.get('grupos').get(tem.ServiceGroup__c)+'-'+mapaGro.get('usuarios').get(tem.User__c);
            tem.IdUserGroup__c=tem.ServiceGroup__c+'-'+tem.User__c;
        }
    }
    
    private void agregarUsuarioServiceGroup(List<ServiceGroupsUser__c> listNe,Map<String,ServiceGroups__c> mapSerG){
        List<ServiceGroups__c> lisUpd=new List<ServiceGroups__c>();
        Map<String,ServiceGroups__c> mapaSerGrRep=new Map<String,ServiceGroups__c>();
        ServiceGroups__c sg;
        for(ServiceGroupsUser__c tem: listNe){
            sg=mapaSerGrRep.containsKey(tem.ServiceGroup__c) ? mapaSerGrRep.get(tem.ServiceGroup__c) : new ServiceGroups__c(Id=tem.ServiceGroup__c);
            System.debug('VERR::'+mapSerG.get(tem.ServiceGroup__c));
            sg.Users__c=mapaSerGrRep.containsKey(tem.ServiceGroup__c) ? mapaSerGrRep.get(tem.ServiceGroup__c).Users__c : mapSerG.get(tem.ServiceGroup__c).Users__c;
            sg.Users__c=sg.Users__c!=null ? tem.User__c+';'+sg.Users__c : tem.User__c;
            mapaSerGrRep.put(sg.Id,sg);
            lisUpd.add(sg);
        }
        update mapaSerGrRep.values();
    }
    
    private void verificarCambios(List<ServiceGroupsUser__c> listNe){
        List<ServiceGroupsUser__c> ls=new List<ServiceGroupsUser__c>();
        for(ServiceGroupsUser__c tem: listNe){
            if(tem.ServiceGroup__c!=oldMap.get(tem.Id).ServiceGroup__c){
                ls.add(tem);
            }
        }
        Set<String> lisOld=new Set<String>();
        for(ServiceGroupsUser__c tem: listNe){
            lisOld.add(oldMap.get(tem.Id).ServiceGroup__c);
            lisOld.add(tem.ServiceGroup__c);
        }
        Map<String,ServiceGroups__c> mapSerG=new Map<String,ServiceGroups__c>();
        for(ServiceGroups__c stem:[Select Id,Users__c from ServiceGroups__c where Id IN :lisOld]){
            mapSerG.put(stem.Id, stem);
        }
        agregarUsuarioServiceGroup(ls,mapSerG);
        removerUsuarioServiceGroup(ls,mapSerG);
    }
    
    private void removerUsuarioServiceGroup(List<ServiceGroupsUser__c> listNe,Map<String,ServiceGroups__c> mapSerG){
        List<ServiceGroups__c> lisUpd=new List<ServiceGroups__c>();
        Map<String,ServiceGroups__c> mapaSerGrRep=new Map<String,ServiceGroups__c>();
        ServiceGroups__c sg;
        
        for(ServiceGroupsUser__c tem: listNe){
            sg=new ServiceGroups__c(Id=oldMap.get(tem.Id).ServiceGroup__c);
            sg.Users__c=mapaSerGrRep.containsKey(oldMap.get(tem.Id).ServiceGroup__c) ? mapaSerGrRep.get(oldMap.get(tem.Id).ServiceGroup__c).Users__c : mapSerG.get(oldMap.get(tem.Id).ServiceGroup__c).Users__c;
            System.debug('ANT::'+sg.Users__c);
            if(sg.Users__c!=null){
                List<String> liEl=sg.Users__c.split(';');
                for(integer i=0;i<liEl.size();i++){
                    if(liEl[i]==tem.User__c){
                        liEl.remove(i);
                        String inf='';
                        for(String te:liEl){
                             inf= inf=='' ? inf+te : inf+';'+te;
                        }
                        sg.Users__c=inf;
                        mapaSerGrRep.put(sg.Id,sg);
                        lisUpd.add(sg);
                        break;
                    }
                }
            }            
        }
        update mapaSerGrRep.values();
    }
}