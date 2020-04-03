global class BatchSemaforosLead implements Database.Batchable<sObject>{
    public String query{get;set;}
    public String tipo{get;set;}
    public respWP mapasRolesAsig=getMapaRoles();
    global BatchSemaforosLead(String qu,String tip){
        query=qu;
        tipo=tip;
    }    
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        return resultados;
    }    
    global void execute(Database.BatchableContext BC, List<sObject> items){
        System.debug('INICIO execute');
        Negocio__c tiempos=Negocio__c.getInstance();
        List<Lead> listLead=(List<Lead>) items;        
        if(tipo=='FIELD'){
            List<Lead> leadsUpdate=new List<Lead>();
            for(Lead le : listLead){
                System.debug('LEAD::');
                if(Date.valueOf(le.FechaReasignacion__c.date()).DaysBetween(Date.today())<Integer.valueOf(tiempos.ReasignacionLeadConversion_MLK__c)){
                    if(le.FechaUltimaActividad__c==null&&(Date.valueOf(le.FechaReasignacion__c.date()).DaysBetween(Date.today()))>Integer.valueOf(tiempos.ReasignacionLeadTarea_MLK__c)){
                        leadsUpdate.add(le);
                    }
                    if(le.FechaUltimaActividad__c!=null&&(Date.valueOf(le.FechaUltimaActividad__c.date()).DaysBetween(Date.today()))>Integer.valueOf(tiempos.ReasignacionLeadTarea_MLK__c)){

                        leadsUpdate.add(le);
                    }
                }else{
                    leadsUpdate.add(le);
                }
            }
            reasignarLeadsAlGestor(leadsUpdate);
        }else if(tipo=='DISTANT'){
            System.debug('ES DISTANT');
            List<String> timeDist=tiempos.ReasignacionLead_Small__c.split(';');
            List<Lead> reasignaMismoGrupo=new List<Lead>();
            List<Lead> reasignaSec=new List<Lead>();
            List<Lead> reasignaTer=new List<Lead>();
            List<Lead> asignarRecycle=new List<Lead>();
            for(Lead le:listLead){
                System.debug('DIASENTRE:');
                if(le.NumeroReasignacion__c==10){
                    System.debug('R10');
                    if(Date.valueOf(le.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(0))){
                        reasignaMismoGrupo.add(le);
                    }
                }else if(le.NumeroReasignacion__c==11){
                    System.debug('R11');
                    if(Date.valueOf(le.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(1))){
                        reasignaSec.add(le);
                    }
                }else if(le.NumeroReasignacion__c==12){
                    System.debug('R12');
                    if(Date.valueOf(le.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(2))){
                        reasignaTer.add(le);
                    }
                }else if(le.NumeroReasignacion__c==13){
                    System.debug('R13');
                    if(Date.valueOf(le.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(3))){
                        asignarRecycle.add(le);
                    }
                }
            }
            reasignacionesDistant(reasignaMismoGrupo,reasignaSec,reasignaTer,asignarRecycle);
        }             
    }
    global void finish(Database.BatchableContext BC){}
    
    global void reasignarLeadsAlGestor(List<Lead> leads){
        try{
            for(Lead le:leads){
                le.NumeroReasignacion__c=2;
                le.FechaReasignacion__c=DateTime.now();
            }
            update leads;
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
    }
    
    global void reasignacionesDistant(List<Lead> reasignaMG,List<Lead> reasignaS,List<Lead> reasignaT,List<Lead> reasignaR){
        System.debug('INICIO REASIGDISTANT');
        try{
            List<Lead> listUpdate=new List<Lead>();
            for(Lead le:reasignaMG){
                System.debug('HAYMG');
                String idProp=getTopUser(le.Owner.UserRole.Name,le.OwnerId);
                if(idProp!=''){
                    if(mapasRolesAsig.mapaAsig.containsKey(idProp)){
                        Integer i=mapasRolesAsig.mapaAsig.get(idProp);
                        mapasRolesAsig.mapaAsig.put(idProp,i+1);
                    }
                    le.OwnerId=idProp;
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=11;
                }
            }
            for(Lead le:reasignaS){
                System.debug('HAYS');
                String idProp=le.Owner.UserRole.Name=='Ejecutivo Telesales Inbound' ? getTopUser('Ejecutivo Telesales Outbound',le.OwnerId) : le.Owner.UserRole.Name=='Ejecutivo Telesales Outbound' ? getTopUser('Ejecutivo de Migracion',le.OwnerId) :  getTopUser('Ejecutivo Telesales Inbound',le.OwnerId);
                if(idProp!=''){
                    if(mapasRolesAsig.mapaAsig.containsKey(idProp)){
                        Integer i=mapasRolesAsig.mapaAsig.get(idProp);
                        mapasRolesAsig.mapaAsig.put(idProp,i+1);
                    }
                    le.OwnerId=idProp;
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=12;
                }
            }
            for(Lead le:reasignaT){
                System.debug('HAYT');
                String idProp=le.Owner.UserRole.Name=='Ejecutivo Telesales Inbound' ? getTopUser('Ejecutivo Telesales Outbound',le.OwnerId) : le.Owner.UserRole.Name=='Ejecutivo Telesales Outbound' ? getTopUser('Ejecutivo de Migracion',le.OwnerId) :  getTopUser('Ejecutivo Telesales Inbound',le.OwnerId) ;
                if(idProp!=''){
                    if(mapasRolesAsig.mapaAsig.containsKey(idProp)){
                        Integer i=mapasRolesAsig.mapaAsig.get(idProp);
                        mapasRolesAsig.mapaAsig.put(idProp,i+1);
                    }
                    le.OwnerId=idProp;
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=13;
                }
            }
            for(Lead le:reasignaR){
                System.debug('HAYR');
                le.FechaReasignacion__c=DateTime.now();
                le.NumeroReasignacion__c=14;
            }
            listUpdate.addAll(reasignaMG);
            listUpdate.addAll(reasignaS);
            listUpdate.addAll(reasignaT);
            listUpdate.addAll(reasignaR);
            //System.debug('ANTESUPDATE'+JSON.serialize(listUpdate));
            Database.update(listUpdate,false);
        }catch(Exception ex){
            System.debug('Error: '+ex.getMessage()+', linea: '+ex.getLineNumber());
        }
    }
    
    //Obtiene usuario top
    global String getTopUser(String rol,String idAct){
        String idProp='';
        if(mapasRolesAsig.mapaId!=null&&mapasRolesAsig.mapaId.containsKey(rol)){
            for(String idUs:mapasRolesAsig.mapaId.get(rol)){
                if(idProp!=''){
                    if(mapasRolesAsig.mapaAsig.get(idUs)<mapasRolesAsig.mapaAsig.get(idProp)&&idUs!=idAct){
                        idProp=idUs;
                    }
                }else if(idUs!=idAct){
                    idProp=idUs;
                }                              
            }
        }
        //System.debug('El mapa es:'+JSON.serialize(mapasRolesAsig));
        //System.debug('El usuario de rol:'+rol+' con menos asignaciones es: '+idProp);
        return idProp;
    }    
    //obtiene mapa de funciones y Ids
    global respWP getMapaRoles(){
        respWP resp=new respWP();
        Set<String> idsUser=new Set<String>();
        Map<String,Integer> mapaAsignados=new Map<String,Integer>();
        Set<String> roles=new Set<String>{'Ejecutivo de Migracion','Ejecutivo Telesales Outbound','Ejecutivo Telesales Inbound'};
        Map<String,List<String>> mIds=new Map<String,List<String>>();
        for(User u:[Select Id,UserRole.Name from User where UserRole.Name IN:roles and IsActive=true and UsuarioTop__c=true]){
            idsUser.add(u.Id);
            mapaAsignados.put(u.Id,0);
            List<String> temp;
            if(mIds.containsKey(u.UserRole.Name)){
                temp=mIds.get(u.UserRole.Name);
                temp.add(u.Id);
                mIds.put(u.UserRole.Name,temp);
            }else{
                temp=new List<String>();
                temp.add(u.Id);
                mIds.put(u.UserRole.Name,temp);
            }
        }
        /*for(Lead op:[Select Id,OwnerId from Lead where OwnerId IN:idsUser]){
            if(mapaAsignados.containsKey(op.OwnerId)){
                Integer i=mapaAsignados.get(op.OwnerId);
                mapaAsignados.put(op.OwnerId,i+1);
            }
        }*/
        resp.mapaId=mIds;
        resp.mapaAsig=mapaAsignados;
        return resp;
    }
    
    global class respWP{
        public Map<String,List<String>> mapaId{get;set;}
        public Map<String,Integer> mapaAsig{get;set;}
    }
    
    //obtener top de pendiendo la funcion 
    /*global String getTop(String roleName,String idAct){
        System.debug('INICIO GETTOP:'+roleName);
        Map<String,Integer> mapaTotal=new Map<String,Integer>();
        List<User> usuariosTop=[Select Id from User where IsActive=true and UserRole.Name=:roleName and UsuarioTop__c=true and Id!=:idAct];
        for(User u:usuariosTop){
            mapaTotal.put(u.Id,0);
        }
        for(Lead le:[Select Id,OwnerId from Lead where OwnerId IN:usuariosTop]){
            if(mapaTotal.containsKey(le.OwnerId)){
                Integer i=mapaTotal.get(le.OwnerId);
                mapaTotal.put(le.OwnerId,i++);
            }
        }
        System.debug('MAPA::'+mapaTotal);
        String ret='';
        for(String cl:mapaTotal.KeySet()){
            if(ret!=''){
                if(mapaTotal.get(cl)<mapaTotal.get(ret)){
                    ret=cl;
                }
            }else{
                ret=cl;
            }
        }
        return ret;
    } */
}