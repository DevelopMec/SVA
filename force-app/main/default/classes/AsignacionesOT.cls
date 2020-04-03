public without sharing class AsignacionesOT {
    Map<String,List<String>> mapGruposUsuarios=new Map<String,List<String>>();
    Map<String,Map<String,String>> mapGrupos=new Map<String,Map<String,String>>();
    Map<String,String> mapAsignaciones=new Map<String,String>();
    Map<String,String> mapRespaldo=new Map<String,String>();
    public String asignacion{get;set;}
    public AsignacionesOT(List<WorkOrder> newList,Map<String,Opportunity> mapOpps,String tipo){
        asignacion=tipo;
        mapasWP mapas=getMapas();
        mapGruposUsuarios=getMapUser();
        //System.debug('JSON::'+JSON.serialize(mapas));
        mapGrupos=mapas.mapGr;
        mapAsignaciones=mapas.mapAsig;
        mapRespaldo=mapas.mapResp;
        reasignarOTs(newList,mapOpps);
    }
    
    public void reasignarOTs(List<WorkOrder> newList,Map<String,Opportunity> mapOpps){
        Map<String,List<WorkOrder>> mapOTs=new Map<String,List<WorkOrder>>();
        List<WorkOrder> temp=new List<WorkOrder>();        
        for(WorkOrder wo : newList){            
            if(mapOTs.containsKey(wo.Oportunidad__c)){
                temp=mapOTs.get(wo.Oportunidad__c);
                temp.add(wo);
                mapOTs.put(wo.Oportunidad__c,temp);
            }else{
                mapOTs.put(wo.Oportunidad__c,new List<WorkOrder>{wo});
            }
        }
        
        for(String idOpp : mapOTs.keySet()){
            Map<String,String> idOwner=getOwner(mapOpps.get(idOpp));
            System.debug('VERR:'+idOwner);
            String idOwn='';
            if(idOwner.get('estatus')=='success'){
                idOwn=idOwner.get('idOwner');
            }else{
                if(idOwner.get('msj')=='Función no configurada'){
                    idOwn=getIdAsign('COORDINADORES MLK');
                    idOwner.put('grupo','COORDINADORES MLK');
                }
            }
            for(WorkOrder wo : mapOTs.get(idOpp)){
                System.debug('VERR2:'+idOwn);
                if(idOwn!=''&&idOwn!=null){
                    wo.OwnerId=idOwn;
                }else{
                    wo.addError('Error');
                }
            }
            restructurarGrupo(idOwner.get('grupo'));
        }
        actualizarGrupos();
    }
    private void actualizarGrupos(){
        System.debug('ACT');
        List<ServiceGroups__c> listUp=new List<ServiceGroups__c>();
        for(ServiceGroups__c sg:[Select Id,Users__c,Name from ServiceGroups__c where Name IN:mapGruposUsuarios.keySet() and RecordType.DeveloperName='WorkOrders']){
            System.debug('REG');
            if(mapGruposUsuarios.containsKey(sg.Name.toLowerCase())){
                String tem='';
                for(String it:mapGruposUsuarios.get(sg.Name.toLowerCase())){
                    tem= tem=='' ? tem+it : tem+';'+it;
                }
                if(sg.Users__c!=tem){
                    System.debug('CHANGE');
                    sg.Users__c=tem;
                    listUp.add(sg);
                }
            }
        }
        if(listUp!=null&&listUp.size()>0){
            System.debug('UPD');
            update listUp;
        }
    }
    private void restructurarGrupo(String grupo){
        System.debug('RESTRUC:'+JSON.serialize(mapGruposUsuarios));
        List<String> usuariosColaActual=mapGruposUsuarios.get(grupo.toLowerCase());
        String tem=usuariosColaActual[0];
        usuariosColaActual.remove(0);
        usuariosColaActual.add(tem);
        mapGruposUsuarios.put(grupo.toLowerCase(), usuariosColaActual);
        System.debug('RESTRUCFIN::'+JSON.serialize(mapGruposUsuarios));
    }
    public without sharing class mapasWP{
        public Map<String,Map<String,String>> mapGr{get;set;}
        public Map<String,String> mapAsig{get;set;}
        public Map<String,String> mapResp{get;set;}
    }
    public mapasWP getMapas(){
        mapasWP res=new mapasWP();
        Map<String,String> mapAsignaciones=new Map<String,String>();
        Map<String,String> mapRespaldo=new Map<String,String>();
        Map<String,Map<String,String>> mapGrupos=new Map<String,Map<String,String>>();
        for(Submotivo__c sub : [Select Id,AssignmentBy__c,Role__c,Values__c,Grupo_Soporte_1__c,Grupo_Soporte_2__c from Submotivo__c where RecordType.DeveloperName='WorkOrders']){
            Map<String,String> mapTempGrupAsig=new Map<String,String>();
            mapTempGrupAsig.put('grupoAsignar',sub.Grupo_Soporte_1__c);
            mapRespaldo.put(sub.Role__c.toLowerCase(),sub.Grupo_Soporte_2__c);
            if((sub.AssignmentBy__c=='Familia__c'||sub.AssignmentBy__c=='State')&&sub.Values__c!=null){
                String key='';
                for(String val : sub.Values__c.split(';')){
                    key=sub.Role__c+'-'+val;
                    mapGrupos.put(key.toLowerCase(), mapTempGrupAsig);
                }
            }else if(sub.AssignmentBy__c=='Directa'){
                mapGrupos.put(sub.Role__c.toLowerCase(), mapTempGrupAsig);
            }
            mapAsignaciones.put(sub.Role__c.toLowerCase(),sub.AssignmentBy__c);
        }
        res.mapAsig=mapAsignaciones;
        res.mapGr=mapGrupos;
        res.mapResp=mapRespaldo;
        return res;
    }
    public Map<String,List<String>> getMapUser(){
        Map<String,List<String>> res=new Map<String,List<String>>();
        for(ServiceGroups__c sg : [Select Id,Name,Users__c from ServiceGroups__c  where RecordType.DeveloperName='WorkOrders']){
            if(sg.Users__c!=null){
                res.put(sg.Name.toLowerCase(),sg.Users__c.split(';'));
            }
        }
        return res;
    }
    public static Map<String,Opportunity> getUsersOpps(Set<String> idsOpps){
        Map<String,Opportunity> res=new Map<String,Opportunity>([Select Id,OwnerId,Owner.Segmento__c,Familia__c,Owner.UserRole.DeveloperName,Owner.State from Opportunity where Id IN :idsOpps]);
        return res;
    }
    public Map<String,String> getOwner(Opportunity opp){
        Map<String,String> res=new Map<String,String>();
        if(asignacion!='capacitacion'){
            if(mapAsignaciones.containsKey(opp.Owner.UserRole.DeveloperName.toLowerCase())){
                if(mapAsignaciones.get(opp.Owner.UserRole.DeveloperName.toLowerCase())=='State'){
                    String key=opp.Owner.UserRole.DeveloperName+'-'+opp.Owner.State;
                    if(mapGrupos.containsKey(key.toLowerCase())){
                        Map<String,String> mG=mapGrupos.get(key.toLowerCase());
                        if(mG.get('grupoAsignar')!=''&&mG.get('grupoAsignar')!=null){
                            res.put('estatus','success');
                            res.put('idOwner',getIdAsign(mG.get('grupoAsignar')));
                            res.put('grupo',mG.get('grupoAsignar'));
                        }else{
                            res.put('estatus','error');
                            res.put('msj','No hay grupo para asignar');
                        }               
                    }else{
                        res.put('estatus','success');
                        res.put('idOwner',getIdAsign(mapRespaldo.get(opp.Owner.UserRole.DeveloperName.toLowerCase())));
                        res.put('grupo',mapRespaldo.get(opp.Owner.UserRole.DeveloperName.toLowerCase()));
                    }
                }else if(mapAsignaciones.get(opp.Owner.UserRole.DeveloperName.toLowerCase())=='Familia__c'){
                    String key=opp.Owner.UserRole.DeveloperName+'-'+opp.Familia__c;
                    if(mapGrupos.containsKey(key.toLowerCase())){
                        Map<String,String> mG=mapGrupos.get(key.toLowerCase());
                        if(mG.get('grupoAsignar')!=''&&mG.get('grupoAsignar')!=null){
                            res.put('estatus','success');
                            res.put('idOwner',getIdAsign(mG.get('grupoAsignar')));
                            res.put('grupo',mG.get('grupoAsignar'));
                        }else{
                            res.put('estatus','error');
                            res.put('msj','No hay grupo para asignar');
                        }  
                    }else{
                        res.put('estatus','success');
                        res.put('idOwner',getIdAsign(mapRespaldo.get(opp.Owner.UserRole.DeveloperName.toLowerCase())));
                        res.put('grupo',mapRespaldo.get(opp.Owner.UserRole.DeveloperName.toLowerCase()));
                    }
                }else if(mapAsignaciones.get(opp.Owner.UserRole.DeveloperName.toLowerCase())=='Directa'){
                    if(mapGrupos.containsKey(opp.Owner.UserRole.DeveloperName.toLowerCase())){
                        Map<String,String> mG=mapGrupos.get(opp.Owner.UserRole.DeveloperName.toLowerCase());
                        System.debug('MAPA:'+mG);
                        if(mG.get('grupoAsignar')!=''&&mG.get('grupoAsignar')!=null){
                            res.put('estatus','success');
                            res.put('idOwner',getIdAsign(mG.get('grupoAsignar')));
                            res.put('grupo',mG.get('grupoAsignar'));
                        }else{
                            res.put('estatus','error');
                            res.put('msj','No hay grupo para asignar');
                        }  
                    }else{
                        res.put('estatus','error');
                        res.put('msj','Función no configurada');
                    }
                }else{
                    res.put('estatus','error');
                    res.put('msj','Función no configurada');
                }
            }else{
                res.put('estatus','error');
                res.put('msj','Función no configurada');
            }
        }else{
            if(mapRespaldo.containsKey(opp.Owner.UserRole.DeveloperName.toLowerCase())){
                res.put('estatus','success');
                res.put('idOwner',getIdAsign(mapRespaldo.get(opp.Owner.UserRole.DeveloperName.toLowerCase())));
                res.put('grupo',mapRespaldo.get(opp.Owner.UserRole.DeveloperName.toLowerCase()));
            }else{
                res.put('estatus','error');
                res.put('msj','Función no configurada');
            }
        }
        return res;
    }
    public String getIdAsign(String grupo){
        System.debug('GRUPO:'+grupo);
        grupo=grupo.toLowerCase();
        String res='';
        List<String> liGr=mapGruposUsuarios.get(grupo);
        res=liGr[0];
        return res;
    }
}