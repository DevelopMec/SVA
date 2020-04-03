//TEST --> CaseTriggerFlujo_TEST
public without sharing class TriggerCaseHandler extends TriggerHandler {
    private Map<Id, Case> newMap;
    private Map<Id, Case> oldMap;
    private List<Case> newList;
    private List<Case> oldList;
    private Map<String, Submotivo__c> mapaSubMotivos;
    private Map<String, List<String>> usuariosColas;
    private Map<String, ServiceGroups__c> mapaGruposAtencion;
    private Map<String, User> mapUsers;
    private colasMapasWP mapasGlobal;
    private Map<String, ServiceGroupsUser__c> mapaGruposAtencionUsuario;
    private Map<Id, User> mapaUsuariosCreadores;
    private Map<String, Id> mapaUsuariosFunciones;
    private Map<Id, String> mapaTiposRegistro;
    
    public TriggerCaseHandler() {
        this.mapaSubMotivos = getCombinaciones();
        this.mapasGlobal = getColasMapa();
        this.usuariosColas = mapasGlobal.colasMapa;
        this.mapaGruposAtencion = mapasGlobal.colasServGro;
        this.mapaGruposAtencionUsuario = mapasGlobal.mapServGroUser;
        this.mapUsers = getUsers(this.usuariosColas);
        this.mapaUsuariosFunciones = getRoleUsers();
        
        this.newMap = (Map<Id, Case>) Trigger.newMap;
        this.oldMap = (Map<Id, Case>) trigger.oldMap;
        this.newList = (List<Case>) trigger.new;
        this.oldList = (List<Case>) trigger.old;
    }
    
    public override void beforeInsert() {
        system.debug('::beforeInsert::');
        asignarGrupoAtencionInicial(this.newList);
        
        this.mapaTiposRegistro = getTiposRegistro(this.newList);
        Id userId = userinfo.getUserId();
        string userRole = [SELECT Id, UserRole.Name FROM User where Id =: userId].UserRole.Name;
        for(Case caso : newList){
            if(this.mapaTiposRegistro.get(caso.RecordTypeId) == 'commercial'){
                if(this.mapaUsuariosFunciones.containskey(userRole)){
                    caso.New_owner__c = this.mapaUsuariosFunciones.get(userRole);
                }
            }
        }
    }
    
    public override void beforeUpdate() {
        System.debug('::beforeUpdate::');
        
        this.mapaTiposRegistro = getTiposRegistro(this.newList);
        this.mapaUsuariosCreadores = getCreatorUsers(this.newList);
        verificarCambiosCasos();
        asignarPropietarios();
    }
    
    public override void afterUpdate() {
        system.debug('::afterUpdate::');
        JCFS.API.pushUpdatesToJira(Trigger.new, Trigger.old);
        validarCreacionIssue(Trigger.new);
    }    
    
    private void asignarGrupoAtencionInicial(List<Case> newList) {
        system.debug('::asignarGrupoAtencionInicial::');
        List<Id> listIdUsuarios = new List<Id>();
        
        for(Case caso: newList) {
            if( caso.OwnerId != null ) {
                // Se valida si el Propietario es un Usuario
                if( ((String)caso.OwnerId).startsWith('005') ) {
                    listIdUsuarios.add(caso.OwnerId);
                }
            }
        }
        
        Map<Id,User> mapUsuarios = new Map<Id,User>();
        for(User usr: [SELECT Id,Grupo_de_Atencion__c FROM User WHERE Id IN : listIdUsuarios]) {
            if( !mapUsuarios.containsKey(usr.Id) ) {
                mapUsuarios.put(usr.Id, usr);
            }
        }
        
        for(Case caso: newList) {
            if( (caso.OwnerId != null) && (((String)caso.OwnerId).startsWith('005')) ) {
                if(mapUsuarios.containsKey(caso.OwnerId)) {
                    caso.Grupo_de_Atencion__c = mapUsuarios.get(caso.OwnerId).Grupo_de_Atencion__c;
                    caso.Grupo_atencion_siguiente__c='--';
                    caso.Grupo_atencion_anterior__c = '--';
                }
            }
        }
    }
    
    private void verificarCambiosCasos(){
        System.debug('::verificarCambiosCasos::');
        String strLlave;
        Set<String> listOwn=new Set<String>();
        for(Case caso : newList){
            if(!caso.InApprovalProcess__c){
                if( caso.OwnerId != null ) {
                    if( ((String)caso.OwnerId).startsWith('005') ) {
                        listOwn.add(caso.OwnerId);
                    }
                }
            }
        }

        Map<String,User> mapaUsOwn=new Map<String,User>();
        for(User u:[Select Id,Name,Grupo_de_Atencion__c from User where Id IN:listOwn]){
            mapaUsOwn.put(u.Id,u);
        }

        for(Case caso : newList){
            if(!caso.InApprovalProcess__c){
                if(caso.Status!=oldMap.get(caso.Id).Status){
                    caso.Fecha_Hora_deultimo_Cambio_de_Estatus__c=DateTime.now();
                }
                strLlave = caso.Type + '-' + caso.Motivo__c + '-' + caso.Sub_Motivo__c;
                strLlave=strLlave.toLowerCase();
                if((caso.Sub_Motivo__c!=oldMap.get(caso.Id).Sub_Motivo__c||caso.Motivo__c!=oldMap.get(caso.Id).Motivo__c)&&mapaSubMotivos.containsKey(strLlave)){
                    System.debug('::CONTIENE::');
                    caso.NumberGroupAtention__c=1;
                    caso.Grupo_de_Atencion__c=caso.Grupo_de_Atencion__c==null||caso.Grupo_de_Atencion__c=='--'||caso.Grupo_de_Atencion__c=='' ? '--' : caso.Grupo_de_Atencion__c ;
                    caso.Grupo_atencion_anterior__c=caso.Grupo_atencion_anterior__c==null||caso.Grupo_atencion_anterior__c=='--'||caso.Grupo_atencion_anterior__c=='' ? '--' : caso.Grupo_atencion_anterior__c ;
                    caso.Grupo_atencion_siguiente__c = mapaSubMotivos.get(strLlave).Grupo_Soporte_1__c != null ? (mapaSubMotivos.get(strLlave).Grupo_Soporte_1__c == 'TI' ? 'TI '+caso.Familia__c : mapaSubMotivos.get(strLlave).Grupo_Soporte_1__c): '--';
                    caso.EntitlementId=mapaSubMotivos.get(strLlave).SLA__c;
                    caso.Blocking__c=mapaSubMotivos.get(strLlave).Blocking__c;
                }else if(oldMap.get(caso.Id).Status == 'Abierto' && caso.Status=='En Proceso' && mapaSubMotivos.containsKey(strLlave)){
                    System.debug('::CAMBIO::');
                    if(validar(mapaSubMotivos.get(strLlave).RequiredFields__c, caso)){
                        caso.NumberGroupAtention__c=2;
                        caso.Grupo_atencion_anterior__c = caso.Grupo_de_Atencion__c;
                        caso.Grupo_de_Atencion__c = caso.Grupo_atencion_siguiente__c;
                        caso.Grupo_atencion_siguiente__c = mapaSubMotivos.get(strLlave).Grupo_Soporte_2__c != null ? (mapaSubMotivos.get(strLlave).Grupo_Soporte_2__c == 'TI' ? 'TI '+caso.Familia__c : mapaSubMotivos.get(strLlave).Grupo_Soporte_2__c): '--';
                    }else{
                        caso.addError('Ingrese todos los campos de la sección de Información del ticket');
                    }
                }/*else if(caso.OwnerId!=oldMap.get(caso.Id).OwnerId){
                    caso.Grupo_atencion_anterior__c = caso.Grupo_de_Atencion__c;
                    caso.Grupo_de_Atencion__c=mapaUsOwn.containsKey(caso.OwnerId)&&mapaUsOwn.get(caso.OwnerId)!=null ? mapaUsOwn.get(caso.OwnerId).Grupo_de_Atencion__c : null;
                }*/else if(!mapaSubMotivos.containsKey(strLlave)){
                    System.debug('::La combinación no se encuentra en el catalogo::'+strLlave);
                    //caso.addError('La combinación no se encuentra en el catalogo');
                }
            }
        }
    }
    
    private static boolean validar(String campos,Case ticket){
        System.debug('::validar::');
        boolean res=true;
        if(campos!=null){
            List<String> lisCam=campos.split(';');
            for(String tem:lisCam){
                if(ticket.get(tem)==null||ticket.get(tem)==''){
                    res=false;
                    break;
                }
            }
        }
        return res;
    }
    
    private void asignarPropietarios(){
        System.debug('::asignarPropietarios::');
        String strLlave;
        for(Case caso : newList){
            if(!caso.InApprovalProcess__c){
                if(caso.Grupo_de_Atencion__c != oldMap.get(caso.Id).Grupo_de_Atencion__c && caso.OwnerId == oldMap.get(caso.Id).OwnerId){
                    if(caso.Grupo_de_Atencion__c != null && (caso.Grupo_de_Atencion__c.equalsIgnoreCase('Inbox') || caso.Grupo_de_Atencion__c.equalsIgnoreCase('Elite'))){
                        caso.OwnerId = caso.CreatedById;
                    }
                    else if(this.mapaTiposRegistro.get(caso.Id) == 'commercial'){
                        String owner = getRoleUser(caso.CreatedById);
                        if(!string.isBlank(owner)){
                            caso.OwnerId = (Id)owner;
                        }
                    }
                    else{
                        String owner = getUserAsignar(caso.Grupo_de_Atencion__c, caso.Familia__c);
                        if(owner != '' && owner != null){
                            caso.OwnerId = owner;
                        }
                    }
                }
                if(!string.isBlank(caso.New_owner__c)){
                    caso.OwnerId = caso.New_owner__c;
                    caso.New_owner__c = null;
                    caso.Notificar_al_Propietario__c = true;
                    caso.Motivo__c = 'Asesoría comercial';
                    caso.Sub_Motivo__c = 'Resolución/seguimiento';
                    caso.Status = 'En proceso';
                }
            }
        }
        actualizarGrupos();
    }
    
    public void validarCreacionIssue(List<Case> newList){
        System.debug('::validarCreacionIssue::');
        Negocio__c neg=Negocio__c.getInstance();
        String idProyecto=neg.IdJiraProject__c;
        String idIssue=neg.IdJiraIssueType__c;
        List<Case> casos = new List<Case>();
        List<Case> casosUp = new List<Case>();
        for(Case c:newList){
            if(c.Grupo_de_Atencion__c!=null){
                if(c.Grupo_de_Atencion__c.startsWith('TI')&&!c.IssueCreado__c){
                    Case cas=new Case();
                    cas.IssueCreado__c=true;
                    cas.Id=c.Id;
                    casosUp.add(cas);
                    casos.add(c);
                }
            }
        }
        update casosUp;
        JCFS.API.createJiraIssue(idProyecto, idIssue,casos,Trigger.old); 
    }
    
    private void actualizarGrupos(){
        System.debug('::actualizarGrupos::');
        List<ServiceGroups__c> listUp = new List<ServiceGroups__c>();
        for(ServiceGroups__c sg:[Select Id,Users__c,Name from ServiceGroups__c where Name IN:usuariosColas.keySet() and RecordType.DeveloperName='Tickets']){
            if(usuariosColas.containsKey(sg.Name.toLowerCase())){
                //System.debug('USU::'+usuariosColas.get(sg.Name.toLowerCase()));
                String tem='';
                for(String it:usuariosColas.get(sg.Name.toLowerCase())){
                    tem= tem=='' ? tem+it : tem+';'+it;
                }
                //System.debug('ST::'+tem);
                if(sg.Users__c!=tem){
                    sg.Users__c=tem;
                    listUp.add(sg);
                }
            }
        }
        if(listUp!=null&&listUp.size()>0){
            update listUp;
        }
    }
    
    private String getUserAsignar(String grupoAtencion,String familia){
        System.debug('::getUserAsignar::');
        String usr='';
        List<String> usuariosColaActual=grupoAtencion!=null ? (usuariosColas.containsKey(grupoAtencion.toLowerCase()) ? usuariosColas.get(grupoAtencion.toLowerCase()) : null) : null;
        if(usuariosColaActual!=null){
            Integer index=0;
            if(grupoAtencion!=null&&mapaGruposAtencion.containsKey(grupoAtencion.toLowerCase())&&mapaGruposAtencion.get(grupoAtencion.toLowerCase())!=null&&mapaGruposAtencion.get(grupoAtencion.toLowerCase()).AssignmentByFamily__c){
                for(String us : usuariosColaActual){
                    String llave=mapaGruposAtencion.get(grupoAtencion.toLowerCase()).Id+'-'+us;
                    if(mapaGruposAtencionUsuario.containsKey(llave)&&mapaGruposAtencionUsuario.get(llave)!=null&&mapaGruposAtencionUsuario.get(llave).Family__c==familia&&estaDisponible(us)){
                        System.debug(us+'-->DISP');
                        usr=us;
                        break;
                    }else{
                        System.debug(us+'-->NODISP');
                    }
                    index++;
                }
            }else{
                for(String us : usuariosColaActual){
                    if(estaDisponible(us)){
                        System.debug(us+'-->DISP');
                        usr=us;
                        break;
                    }else{
                        System.debug(us+'-->NODISP');
                    }
                    index++;
                }
            }
            if(index<usuariosColaActual.size()){
                restructureQueue(grupoAtencion,index);
            }            
        }
        return usr;
    }
    
    private string getRoleUser(Id uId){
        System.debug('::getRoleUser::');
        String usr = null;

        if(this.mapaUsuariosFunciones.containskey(this.mapaUsuariosCreadores.get(uId).UserRole.Name)){
            usr = this.mapaUsuariosFunciones.get(this.mapaUsuariosCreadores.get(uId).UserRole.Name);
        }

        return usr;
    }
    
    private void restructureQueue(String grupoAtencion,Integer index){
        System.debug('::restructureQueue::');
        List<String> usuariosColaActual=usuariosColas.get(grupoAtencion.toLowerCase());
        System.debug('INI::'+usuariosColaActual);
        String tem=usuariosColaActual[index];
        usuariosColaActual.remove(index);
        usuariosColaActual.add(tem);
        System.debug('FIN::'+usuariosColaActual);
        usuariosColas.put(grupoAtencion, usuariosColaActual);
    }
    
    private boolean estaDisponible(String idUs){
        System.debug('::estaDisponible::');
        User us=mapUsers.get(idUs);
        if(us!=null){
            if(!us.Vacaciones_Activas__c&&horarioDisponible(us)){
                return true;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }
    
    private boolean horarioDisponible(User us){
        System.debug('::horarioDisponible::');
        boolean res=false;
        Time tmHoraDeCreacion = Time.newInstance( System.now().hour(), System.now().minute(), 0, 0);
        DateTime dtDiaAnterior;
        DateTime dtDiaSiguiente;
        // Horario Diurno
        if( us.Hora_de_Entrada__c < us.Hora_de_Salida__c ) {
            if( (us.Hora_de_Entrada__c <= tmHoraDeCreacion) && (us.Hora_de_Salida__c >= tmHoraDeCreacion) ) {
                res=true;
            }
        }
        // Horario Nocturno
        else if( us.Hora_de_Entrada__c > us.Hora_de_Salida__c ) {
            // Fecha de creacion antes de 12:00 AM
            if( (tmHoraDeCreacion > us.Hora_de_Entrada__c) && (tmHoraDeCreacion > us.Hora_de_Salida__c) ) {
                dtDiaAnterior = Datetime.newInstanceGmt( System.today(), us.Hora_de_Entrada__c);
                dtDiaSiguiente = Datetime.newInstanceGmt( System.today() + 1, us.Hora_de_Salida__c);
                if( (dtDiaAnterior <= System.now()) && (System.now() <= dtDiaSiguiente) ) {
                    res=true;
                }
            }
            // Fecha de creacion despues de 12:00 AM
            else if( (tmHoraDeCreacion < us.Hora_de_Entrada__c) && (tmHoraDeCreacion < us.Hora_de_Salida__c) ) {
                dtDiaAnterior = Datetime.newInstanceGmt( System.today() - 1, us.Hora_de_Entrada__c);
                dtDiaSiguiente = Datetime.newInstanceGmt( System.today(), us.Hora_de_Salida__c); 
                if( (dtDiaAnterior <= System.now()) && (System.now() <= dtDiaSiguiente) ) {
                    res=true;
                }
            }
        }
        return res;
    }
    
    private colasMapasWP getColasMapa(){
        System.debug('::getColasMapa::');
        colasMapasWP response=new colasMapasWP();
        Map<String, List<String>> mapaRes = new Map<String, List<String>>();
        Map<String, ServiceGroups__c> mapaServiceGroups = new Map<String, ServiceGroups__c>();
        Map<String, ServiceGroupsUser__c> mapaServiceGroupsUser = new Map<String, ServiceGroupsUser__c>();
        List<String> lisUs;
        for(ServiceGroups__c ag : [
            Select Id, Name, Users__c, AssignmentByFamily__c,
                   (Select Id, IdUserGroup__c, Family__c from UsersInServiceGroup__r where RecordType.DeveloperName='Tickets')
              from ServiceGroups__c
             where RecordType.DeveloperName = 'Tickets']){
            lisUs = new List<String>();
            if(ag.Users__c != null){
                lisUs = ag.Users__c.split(';');
                mapaServiceGroups.put(ag.Name.toLowerCase(), ag);
                mapaRes.put(ag.Name.toLowerCase(), lisUs);
                for(ServiceGroupsUser__c sgu : ag.UsersInServiceGroup__r){
                    if(!mapaServiceGroupsUser.containsKey(sgu.IdUserGroup__c)){
                        mapaServiceGroupsUser.put(sgu.IdUserGroup__c, sgu);
                    }
                }
            }
        }
        response.colasMapa = mapaRes;
        response.colasServGro = mapaServiceGroups;
        response.mapServGroUser = mapaServiceGroupsUser;
        return response;
    }
    
    public without sharing class colasMapasWP{
        public Map<String,List<String>> colasMapa{get;set;}
        public Map<String,ServiceGroups__c> colasServGro{get;set;}
        public Map<String,ServiceGroupsUser__c> mapServGroUser{get;set;}
    }
    
    private Map<String, User> getUsers(Map<String, List<String>> mapa){
        System.debug('::getUsers::');
        List<String> lisGl = new List<String>();
        Map<String,User> mapaRes = new Map<String,User>();
        for(List<String> ls : mapa.values()){
            lisGl.addAll(ls);
        }
        for(User us : [
            Select Id, Name, Vacaciones_Activas__c, Hora_de_Entrada__c, Hora_de_Salida__c, UserRole.Name
              from User
             where Id IN :lisGl
               and IsActive = true]){
            mapaRes.put(us.Id, us);
        }
        return mapaRes;
    }
    
    private Map<String, Submotivo__c> getCombinaciones(){
        System.debug('::getCombinaciones::');
        Map<String, Submotivo__c> mapResp = new Map<String, Submotivo__c>();
        for(Submotivo__c sub:[SELECT Name,RequiredFields__c,Blocking__c, Motivo__c, Tipo_de_Ticket__c, Grupo_Soporte_1__c, Grupo_Soporte_2__c, Grupo_Soporte_3__c, Grupo_Soporte_4__c, Grupo_Soporte_5__c, Grupo_Soporte_6__c, Grupo_Soporte_7__c,SLA__c FROM Submotivo__c where RecordType.DeveloperName='Tickets' LIMIT 50000]){
            String llave=sub.Tipo_de_Ticket__c+'-'+sub.Motivo__c+'-'+sub.Name;
            llave=llave.toLowerCase();
            if(!mapResp.containsKey(llave)){
                mapResp.put(llave,sub);
            }
        }
        return mapResp;
    }
    
    private Map<Id, User> getCreatorUsers(List<Case> casos){
        System.debug('::getCreatorUsers::');
        Map<Id, User> mapResp = new Map<Id, User>();
        
        Set<Id> sus = new Set<Id>();
        for(Case c : casos){
            sus.add(c.CreatedById);
        }
        
        for(User u : [Select Id, Username, UserRole.Name from User where Id in: sus]){
            mapResp.put(u.Id, u);
        }
        return mapResp;
    }
    
    private Map<Id, string> getTiposRegistro(List<Case> casos){
        System.debug('::getTiposRegistro::');
        Map<Id, string> mapResp = new Map<Id, string>();
        
        Set<Id> srts = new Set<Id>();
        for(Case c : casos){
            srts.add(c.RecordTypeId);
        }
        
        for(RecordType rt : [Select Id, Name, DeveloperName From RecordType where Id in: srts]){
            mapResp.put(rt.Id, rt.DeveloperName);
        }
        return mapResp;
    }
    
    private Map<String, Id> getRoleUsers(){
        System.debug('::getRoleUsers::');
        Map<String, Id> mapResp = new Map<String, Id>();
        
        for(Assignment_by_role__c ar : [Select Id, Role__c, User__c from Assignment_by_role__c where isActive__c = true]){
            mapResp.put(ar.Role__c, ar.User__c);
        }
        return mapResp;
    }
}