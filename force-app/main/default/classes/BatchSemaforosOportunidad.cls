global class BatchSemaforosOportunidad implements Database.Batchable<sObject>{
    public String query{get;set;}
    public String tipo{get;set;}
    public respWP mapasRolesAsig=getMapaRoles();
    global BatchSemaforosOportunidad(String qu,String tip){
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
        List<Opportunity> listOpps=(List<Opportunity>) items;        
        if(tipo=='FIELD'){
            List<String> timeFie=tiempos.ReasignacionOpportunity_MLK__c.split(';');
            List<Opportunity> oppsUpdate=new List<Opportunity>();
            for(Opportunity op : listOpps){
                if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())<Integer.valueOf(timeFie.get(0))){
                    //if(Date.today().DaysBetween(op.CloseDate)<Integer.valueOf(tiempos.Rango_PAC__c)){
                        //System.debug('DENTRO DE PAC');
                    if(op.FechaUltimaActividad__c==null&&Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeFie.get(1))){
                        oppsUpdate.add(op);
                    }
                    if(op.FechaUltimaActividad__c!=null&&(Date.valueOf(op.FechaUltimaActividad__c.date()).DaysBetween(Date.today()))>Integer.valueOf(timeFie.get(1))){
                        oppsUpdate.add(op);
                    }
                    /*}else{
                        System.debug('FUERA DE PAC');
                        if(op.FechaUltimaActividad__c==null&&Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeFie.get(2))){
                            oppsUpdate.add(op);
                        }
                        if(op.FechaUltimaActividad__c!=null&&(Date.valueOf(op.FechaUltimaActividad__c.date()).DaysBetween(Date.today()))>Integer.valueOf(timeFie.get(2))){
                            oppsUpdate.add(op);
                        }
                    }*/
                }else if(op.StageName=='Cotización'||op.StageName=='Contrato'){
                    System.debug('ES COTIZACION O CONTRATO 60');
                    oppsUpdate.add(op);
                }
            }
           reasignarOppsAlGestor(oppsUpdate);
        }else if(tipo=='DISTANT'){
            System.debug('ES DISTANT');
            List<String> timeDist=tiempos.ReasignacionOpportunity_Small__c.split(';');
            List<String> timeDistCS=tiempos.ReasignacionOportunidad_Cross_Sell__c.split(';');
            List<Opportunity> reasignaMismoGrupo=new List<Opportunity>();
            List<Opportunity> reasignaSec=new List<Opportunity>();
            List<Opportunity> reasignaTer=new List<Opportunity>();
            List<Opportunity> asignarRecycle=new List<Opportunity>();
            for(Opportunity op:listOpps){
                System.debug('Hay opps');
                if(op.NumeroReasignacion__c==10){
                    System.debug('R10:');
                    if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(0))&&(op.StageName=='Cotización'||op.StageName=='Contrato')){
                        reasignaMismoGrupo.add(op);
                    }
                }else if(op.NumeroReasignacion__c==11){
                    System.debug('R11');
                    if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(1))&&(op.StageName=='Cotización'||op.StageName=='Contrato')){
                        reasignaSec.add(op);
                    }
                }else if(op.NumeroReasignacion__c==12){
                    System.debug('R12');
                    if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(2))&&(op.StageName=='Cotización'||op.StageName=='Contrato')){
                        reasignaTer.add(op);
                    }
                }else if(op.NumeroReasignacion__c==13){
                    System.debug('R13');
                    if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDist.get(3))&&(op.StageName=='Cotización'||op.StageName=='Contrato')){
                        asignarRecycle.add(op);
                    }
                }/*else if(op.NumeroReasignacion__c==20){
                    System.debug('R20');
                    if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDistCS.get(0))&&(op.StageName=='Cotización'||op.StageName=='Contrato')){
                        reasignaMismoGrupo.add(op);
                    }
                }else if(op.NumeroReasignacion__c==21){
                    System.debug('R21');
                    if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDistCS.get(1))&&(op.StageName=='Cotización'||op.StageName=='Contrato')){
                        reasignaMismoGrupo.add(op);
                    }
                }else if(op.NumeroReasignacion__c==22){
                    System.debug('R22');
                    if(Date.valueOf(op.FechaReasignacion__c.date()).DaysBetween(Date.today())>Integer.valueOf(timeDistCS.get(2))&&(op.StageName=='Cotización'||op.StageName=='Contrato')){
                        asignarRecycle.add(op);
                    }
                }*/
            }
            reasignacionesDistant(reasignaMismoGrupo,reasignaSec,reasignaTer,asignarRecycle);
        }         
    }
    global void finish(Database.BatchableContext BC){}
    global void reasignarOppsAlGestor(List<Opportunity> opps){
        try{
            for(Opportunity le:opps){
                le.NumeroReasignacion__c=2;
                le.FechaReasignacion__c=DateTime.now();
            }
            update opps;
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
    }
    global void reasignacionesDistant(List<Opportunity> reasignaMG,List<Opportunity> reasignaS,List<Opportunity> reasignaT,List<Opportunity> reasignaR){
        System.debug('INICIO REASIGDISTANT');
        try{
            Negocio__c neg=Negocio__c.getInstance();
            List<Account> listUpdateAcc=new List<Account>();
            List<Opportunity> listUpdate=new List<Opportunity>();                        
            
            for(Opportunity op:reasignaMG){
                System.debug('HAYMG');
                String idProp=getTopUser(op.Owner.UserRole.Name,op.OwnerId);
                if(idProp!=''){
                    if(mapasRolesAsig.mapaAsig.containsKey(idProp)){
                        Integer i=mapasRolesAsig.mapaAsig.get(idProp);
                        mapasRolesAsig.mapaAsig.put(idProp,i+1);
                    }
                    if(op.Account.CodigoClienteAS400__c==null&&op.NumeroReasignacion__c==10){
                        Account acc=new Account();
                        acc.Id=op.AccountId;
                        acc.OwnerId=idProp;
                        listUpdateAcc.add(acc);
                    }
                    op.OwnerId=idProp;
                    op.FechaReasignacion__c=DateTime.now();
                    op.NumeroReasignacion__c=op.NumeroReasignacion__c+1;
                }
            }
            for(Opportunity op:reasignaS){
                System.debug('HAYS');
                String idProp=op.Owner.UserRole.Name=='Ejecutivo Telesales Inbound' ? getTopUser('Ejecutivo Telesales Outbound',op.OwnerId) : op.Owner.UserRole.Name=='Ejecutivo Telesales Outbound' ? getTopUser('Ejecutivo de Migracion',op.OwnerId) :  getTopUser('Ejecutivo Telesales Inbound',op.OwnerId);
                if(idProp!=''){
                    if(mapasRolesAsig.mapaAsig.containsKey(idProp)){
                        Integer i=mapasRolesAsig.mapaAsig.get(idProp);
                        mapasRolesAsig.mapaAsig.put(idProp,i+1);
                    }
                    if(op.Account.CodigoClienteAS400__c==null){
                        Account acc=new Account();
                        acc.Id=op.AccountId;
                        acc.OwnerId=idProp;
                        listUpdateAcc.add(acc);
                    }
                    op.OwnerId=idProp;
                    op.FechaReasignacion__c=DateTime.now();
                    op.NumeroReasignacion__c=12;
                }
            }
            for(Opportunity op:reasignaT){
                System.debug('HAYT');
                String idProp=op.Owner.UserRole.Name=='Ejecutivo Telesales Inbound' ? getTopUser('Ejecutivo Telesales Outbound',op.OwnerId) : op.Owner.UserRole.Name=='Ejecutivo Telesales Outbound' ? getTopUser('Ejecutivo de Migracion',op.OwnerId) :  getTopUser('Ejecutivo Telesales Inbound',op.OwnerId) ;
                if(idProp!=''){
                    if(mapasRolesAsig.mapaAsig.containsKey(idProp)){
                        Integer i=mapasRolesAsig.mapaAsig.get(idProp);
                        mapasRolesAsig.mapaAsig.put(idProp,i+1);
                    }
                    if(op.Account.CodigoClienteAS400__c==null){
                        Account acc=new Account();
                        acc.Id=op.AccountId;
                        acc.OwnerId=idProp;
                        listUpdateAcc.add(acc);
                    }
                    op.OwnerId=idProp;
                    op.FechaReasignacion__c=DateTime.now();
                    op.NumeroReasignacion__c=13;
                }
            }
            for(Opportunity op:reasignaR){
                System.debug('HAYR');
                String idPropRe=neg.IdUsuarioRecycle__c;
                if(idPropRe!=''){
                    if(op.Account.CodigoClienteAS400__c==null){
                        Account acc=new Account();
                        acc.Id=op.AccountId;
                        acc.OwnerId=idPropRe;
                        listUpdateAcc.add(acc);
                    }
                    op.OwnerId=idPropRe;
                    op.FechaReasignacion__c=DateTime.now();
                    op.NumeroReasignacion__c=op.NumeroReasignacion__c+1;
                }
            }
            listUpdate.addAll(reasignaMG);
            listUpdate.addAll(reasignaS);
            listUpdate.addAll(reasignaT);
            listUpdate.addAll(reasignaR);
            List<Contact> listUpdateCon=[Select Id,AccountId from Contact where AccountId IN:listUpdateAcc];
            Map<String,String> mapaPropAcc=new Map<String,String>();
            for(Account ac:listUpdateAcc){
                if(!mapaPropAcc.containsKey(ac.Id)){
                    mapaPropAcc.put(ac.Id,ac.OwnerId);
                }
            }
            for(Contact con : listUpdateCon){
                if(mapaPropAcc.containsKey(con.AccountId)){
                    con.OwnerId=mapaPropAcc.get(con.AccountId);
                }
            }
            //System.debug('ANTESUPDATE'+listUpdate);
            //System.debug('ANTESUPDATE'+listUpdateAcc);
            //System.debug('ANTESUPDATE'+listUpdateCon);
            
            Database.update(listUpdate,false);
            Database.update(listUpdateAcc,false);
            Database.update(listUpdateCon,false);
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
        /*for(Opportunity op:[Select Id,OwnerId from Opportunity where OwnerId IN:idsUser]){
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
    /*global String getTop(String roleName,String propAc){
        System.debug('INICIO GETTOP:'+roleName);
        Map<String,Integer> mapaTotal=new Map<String,Integer>();
        List<User> usuariosTop=[Select Id from User where IsActive=true and UserRole.Name=:roleName and UsuarioTop__c=true and Id!=:propAc];
        for(User u:usuariosTop){
            mapaTotal.put(u.Id,0);
        }
        for(Opportunity op:[Select Id,OwnerId from Opportunity where OwnerId IN:usuariosTop]){
            if(mapaTotal.containsKey(op.OwnerId)){
                Integer i=mapaTotal.get(op.OwnerId);
                mapaTotal.put(op.OwnerId,i++);
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
    }*/
}