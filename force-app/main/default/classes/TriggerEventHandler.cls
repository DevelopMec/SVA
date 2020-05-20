public with sharing class TriggerEventHandler  extends TriggerHandler{
    private Map<Id, Event> newMap;
    private Map<Id, Event> oldMap;
    private List<Event> newList;
    private List<Event> oldList;
    private Map<Id,Profile> mapAdminProfiles;

    public TriggerEventHandler() {
        this.newMap = (Map<Id, Event>) trigger.newMap;
        this.oldMap = (Map<Id, Event>) trigger.oldMap;
        this.newList = (List<Event>) trigger.new;
        this.oldList = (List<Event>) trigger.old;
    }
    
    set<Id> idProspectos = new set<Id>(); 
    set<Id> idContactos = new set<Id>(); 
    set<Id> idCuentas = new set<Id>(); 
    set<Id> idOportunidades = new set<Id>(); 
    
    map<Id,Event> mapObjetoTarea = new map<Id,Event>();
    //WhoId
    list<Lead> prospectos = new list<Lead>();
    list<Contact> contactos = new list<Contact>();
    //WhatId
    list<Account> cuentas = new list<Account>();
    list<Opportunity> oportunidades = new list<Opportunity>();
    
    public override void beforeInsert(){
        validaFechaInicio(newList);
        insertFieldFamily();
        for(Event e:newList){
            if(e.EstatusEvento__c != 'Finalizado'){
                e.ActivityType__c = null;
                e.EventNumber__c = null; 
            }
        }
    }

    public override void afterUpdate(){
        validarEventoCompartido(newList,oldMap);
        //actulizarObjetosUltimaTarea();
        ActivityCounter.generaContadorTipoEvento(newList);
    }

    public override void beforeUpdate(){
        for(Event e:newList){
            if(e.EventoRelacionado__c!=''&&e.EventoRelacionado__c!=null&&e.OwnerId==UserInfo.getUserId()){
                e.addError('No puedes modificar un evento del cual eres acompañante');
            }
            if(e.EstatusEvento__c != 'Finalizado'){
               e.ActivityType__c = null;
               e.EventNumber__c = null; 
            }
        }
    }

    public override void beforeDelete(){
        mapAdminProfiles = new Map<Id,Profile>([SELECT Id,Name FROM Profile WHERE PermissionsModifyAllData = true]);
        validaBorradoEventos(oldList);
    }

    public override void afterInsert(){
        validarEventoCompartido(newList,oldMap);
        actulizarObjetosUltimaTarea();
        insertarFechaPrimeraActividad();
        ActivityCounter.generaContadorTipoEvento(newList);
    }
    
    public void validarEventoCompartido(List<Event> newListEvt,Map<Id,Event> oldMapEvt){
        List<Event> listEventCrear=new List<Event>();
        List<Event> listEventEliminar=new List<Event>();
        List<Event> listEventCambiar=new List<Event>();
        List<Event> listEventActualizar=new List<Event>();
        for(Event evt:newListEvt){
            if(trigger.isUpdate){
                if(oldMapEvt.get(evt.Id).Acompanado_por__c==null&&evt.Acompanado_por__c!=null){
                    listEventCrear.add(evt);
                }else if(oldMapEvt.get(evt.Id).Acompanado_por__c!=null&&evt.Acompanado_por__c!=null){
                    listEventCambiar.add(evt);
                }else if(oldMapEvt.get(evt.Id).Acompanado_por__c!=null&&evt.Acompanado_por__c==null){
                    listEventEliminar.add(evt);
                }
            }else if(trigger.isInsert){
                if(evt.Acompanado_por__c!=null){
                    listEventCrear.add(evt);
                }
            }
        }
        crearEventoAcompa(listEventCrear);
        eliminarEventoAcompa(listEventEliminar);
        cambiarEventoAcompa(listEventCambiar);
    }
    
    public void crearEventoAcompa(List<Event> listEvent){
        List<Event> listEventCrear=new List<Event>();
        for(Event evt:listEvent){
            Event tem=crearEvento(evt);
            tem.OwnerId=evt.Acompanado_por__c;
            tem.EventoRelacionado__c=String.valueOf(evt.Id);
            tem.IsReminderSet=true;
            tem.ReminderDateTime=DateTime.now().addMinutes(1);
            listEventCrear.add(tem);
        }
        System.debug('LIS:'+listEventCrear);
        insert listEventCrear;
    }
    
    public void cambiarEventoAcompa(List<Event> listEvent){
        Set<String> listIds=new Set<String>();
        List<Event> listEventUpdate=new List<Event>();
        for(Event ev:listEvent){
            listIds.add(ev.Id);
        }
        for(Event ev: [Select Id,EventoRelacionado__c from Event where EventoRelacionado__c IN :listIds]){
            ev.OwnerId=newMap.get(ev.EventoRelacionado__c).Acompanado_por__c;
            ev.EstatusEvento__c=newMap.get(ev.EventoRelacionado__c).EstatusEvento__c;
            
            ev.FechaHoraFin__c=newMap.get(ev.EventoRelacionado__c).FechaHoraFin__c;
            ev.FechaHoraInicio__c=newMap.get(ev.EventoRelacionado__c).FechaHoraInicio__c;
            ev.DireccionInicio__c=newMap.get(ev.EventoRelacionado__c).DireccionInicio__c;
            ev.DireccionFin__c=newMap.get(ev.EventoRelacionado__c).DireccionFin__c;
            ev.ValoracionCita__c=newMap.get(ev.EventoRelacionado__c).ValoracionCita__c;
            ev.ComentariosValoracion__c=newMap.get(ev.EventoRelacionado__c).ComentariosValoracion__c;
            
            ev.Comentarios__c=newMap.get(ev.EventoRelacionado__c).Comentarios__c;
            ev.IsReminderSet=true;
            ev.ReminderDateTime=DateTime.now().addMinutes(1);
            ev.StartDateTime=newMap.get(ev.EventoRelacionado__c).StartDateTime;
            ev.EndDateTime=newMap.get(ev.EventoRelacionado__c).EndDateTime;
            ev.IsAllDayEvent=newMap.get(ev.EventoRelacionado__c).IsAllDayEvent;
            ev.ShowAs=newMap.get(ev.EventoRelacionado__c).ShowAs;
            //ev.IsReminderSet=newMap.get(ev.EventoRelacionado__c).IsReminderSet;
            ev.Location=newMap.get(ev.EventoRelacionado__c).Location;
            ev.ActivityDate=newMap.get(ev.EventoRelacionado__c).ActivityDate;
            ev.ActivityDateTime=newMap.get(ev.EventoRelacionado__c).ActivityDateTime;
            ev.Asunto__c=newMap.get(ev.EventoRelacionado__c).Asunto__c;
            ev.Description=newMap.get(ev.EventoRelacionado__c).Description;
            ev.Subject=newMap.get(ev.EventoRelacionado__c).Subject;
            ev.WhatId=newMap.get(ev.EventoRelacionado__c).WhatId;
            ev.WhoId=newMap.get(ev.EventoRelacionado__c).WhoId;
            ev.DurationInMinutes=newMap.get(ev.EventoRelacionado__c).DurationInMinutes;
            listEventUpdate.add(ev);
        }
        update listEventUpdate;
    }
    
    public void eliminarEventoAcompa(List<Event> listEvent){
        Set<String> listIds=new Set<String>();
        for(Event ev:listEvent){
            listIds.add(ev.Id);
        }
        List<Event> listEventDelete=[Select Id from Event where EventoRelacionado__c IN :listIds];
        Delete listEventDelete;
    }
    
    public Event crearEvento(Event evt){
        Event ev=new Event();
        ev.StartDateTime=evt.StartDateTime;
        
        ev.FechaHoraFin__c=evt.FechaHoraFin__c;
        ev.FechaHoraInicio__c=evt.FechaHoraInicio__c;
        ev.DireccionInicio__c=evt.DireccionInicio__c;
        ev.DireccionFin__c=evt.DireccionFin__c;
        ev.ValoracionCita__c=evt.ValoracionCita__c;
        ev.ComentariosValoracion__c=evt.ComentariosValoracion__c;
        
        ev.Comentarios__c=evt.Comentarios__c;
        ev.EndDateTime=evt.EndDateTime;
        ev.IsAllDayEvent=evt.IsAllDayEvent;
        ev.ShowAs=evt.ShowAs;
        //ev.IsReminderSet=evt.IsReminderSet;        
        ev.Location=evt.Location;
        ev.ActivityDate=evt.ActivityDate;
        ev.ActivityDateTime=evt.ActivityDateTime;
        ev.Asunto__c=evt.Asunto__c;
        ev.Description=evt.Description;
        ev.Subject=evt.Subject;
        ev.WhatId=evt.WhatId;
        ev.WhoId=evt.WhoId;
        ev.DurationInMinutes=evt.DurationInMinutes;
        return ev;
    }
    
    public void validaBorradoEventos(List<Event> lista){
        for(Event tarea:lista){
            if(!mapAdminProfiles.containsKey(UserInfo.getProfileId()) ){
                tarea.addError('No cuenta con los permisos para eliminar el registro. Contacte a su administrador');
            }
        }
    }

    public void validaFechaInicio(List<Event> lista){
        for(Event tarea:lista){
            if(tarea.StartDateTime < Date.Today()  ) {
                tarea.addError('La fecha de inicio no puede ser menor a la actual');
            }
        }
    }
    
    public void actulizarObjetosUltimaTarea(){
        for(Event tarea:newList){
            if(tarea.WhoId != null){
                if (Utils.obtenerNombreObjeto(tarea.WhoId) == 'Lead'){
                        idProspectos.add(tarea.WhoId);
                 }
                 mapObjetoTarea.put(tarea.WhoId,tarea);
            }else if(tarea.WhatId != null){
                if(Utils.obtenerNombreObjeto(tarea.WhatId) == 'Opportunity'){
                        idOportunidades.add(tarea.WhatId);
                }
                mapObjetoTarea.put(tarea.WhatId,tarea);
            }
        }
        if(idProspectos.size() > 0){
            prospectos = [SELECT Id,Name,UltimaActvidad__c,UltimaActividadAsunto__c,FechaUltimaActividad__c FROM Lead WHERE Id IN : idProspectos];
            for(Lead prospecto : prospectos){
                prospecto.FechaUltimaActividad__c = mapObjetoTarea.get(prospecto.Id).CreatedDate;
            }
        }
        if(idOportunidades.size() > 0){
            oportunidades = [SELECT Id,Name,UltimaActvidad__c,UltimaActividadAsunto__c,FechaUltimaActividad__c FROM Opportunity WHERE Id IN : idOportunidades];
            for(Opportunity oportunidad : oportunidades){
                oportunidad.FechaUltimaActividad__c = mapObjetoTarea.get(oportunidad.Id).CreatedDate;
            }
        }
        if(prospectos.size() > 0){
            update prospectos;
        }
        if(oportunidades.size() > 0){
            update oportunidades;
        }
    }
    
    public void insertarFechaPrimeraActividad(){
        for(Event tarea:newList){
            if(tarea.WhoId != null){
                if (Utils.obtenerNombreObjeto(tarea.WhoId) == 'Lead'){
                        idProspectos.add(tarea.WhoId);
                }
            }
        }
        if(idProspectos.size() > 0){
            prospectos = [SELECT Id, FechaPrimeraActividad__c FROM Lead WHERE Id IN : idProspectos];
            for(Lead prospecto : prospectos){
                if(prospecto.FechaPrimeraActividad__c == null){
                    DateTime today = DateTime.now();
                    prospecto.FechaPrimeraActividad__c = today;
                }
            }
        }
        if(prospectos.size() > 0){
            update prospectos;
        }
    }
    
    //Método que funciona para actualizar el campo familia de un "Evento" a partir del campo Familia de la oportunidad relacionada
    public void insertFieldFamily(){
        for(Event evento: newList){
            String wId = evento.WhatId;
            String whoId = evento.WhoId;
            if(wId != null && wId.startsWith('006') &&! idOportunidades.contains(evento.WhatId) || whoId != null && whoId.startsWith('00Q') &&! idProspectos.contains(evento.WhoId)){
                idOportunidades.add(evento.WhatId);
                idProspectos.add(evento.WhoId);
            }
        }
        
        //Obtener la relación de eventos para las oportunidades
        List<Opportunity> EventOps = [Select Id, Familia__c from Opportunity where Id IN: idOportunidades];
        List<Lead> EventPros= [Select Id, CategoriaSolucion__c from Lead where Id IN:  idProspectos];
        Map<Id, Opportunity> opMap = new Map<Id, Opportunity>();
        Map<Id, Lead> prosMap = new Map<Id, Lead>();
        for(Opportunity opp: EventOps){
            opMap.put(opp.Id, opp);
        }
        for(Lead pros: EventPros){
            prosMap.put(pros.Id, pros);
        }
        
        //Actualizar campo de evento
        for(Event evento: newList){
            String wId = evento.WhatId;
            String whoId = evento.WhoId;
            Opportunity thisOp = new Opportunity();
            Lead thisPros = new Lead();
            //evento.Subject = 'Capacitación';
            //evento.Family__c = 'jjj';
            if(wId != null && wId.startsWith('006') || whoId != null && whoId.startsWith('00Q')){
                thisOp = new Opportunity();
                thisOp=opMap.get(evento.whatId);
                thisPros = new Lead();
                thisPros = prosMap.get(evento.WhoId);
               if(thisOp != null){
                evento.Familys__c = thisOp.Familia__c;
               }
                if(thisPros != null){
                    List<String> val=thisPros.CategoriaSolucion__c!=null ? thisPros.CategoriaSolucion__c.split(';') : new List<String>{''};
                    evento.Familys__c = val[0];   
                }
            }
        }      
    }
    
    /*
    V1
    public void actulizarObjetosUltimaTarea(){
        for(Event tarea:newList){
            if(tarea.EstatusEvento__c == 'Realizado'){
                if(tarea.WhoId != null){
                    if (Utils.obtenerNombreObjeto(tarea.WhoId) == 'Lead'){
                        idProspectos.add(tarea.WhoId);
                    }else if (Utils.obtenerNombreObjeto(tarea.WhoId) == 'Contact'){
                        idContactos.add(tarea.WhoId);
                    }
                    mapObjetoTarea.put(tarea.WhoId,tarea);
                } 
                
                if(tarea.WhatId != null){
                    if (Utils.obtenerNombreObjeto(tarea.WhatId) == 'Account'){
                        idCuentas.add(tarea.WhatId);
                    }else if(Utils.obtenerNombreObjeto(tarea.WhatId) == 'Opportunity'){
                        idOportunidades.add(tarea.WhatId);
                    }
                    mapObjetoTarea.put(tarea.WhatId,tarea);
                }
            }
        }
        
        if(idProspectos.size() > 0){
            prospectos = [SELECT Id,Name,UltimaActvidad__c,UltimaActividadAsunto__c FROM Lead WHERE Id IN : idProspectos];
            for(Lead prospecto : prospectos){
                prospecto.UltimaActvidad__c = mapObjetoTarea.get(prospecto.Id).Id;
                prospecto.UltimaActividadAsunto__c = mapObjetoTarea.get(prospecto.Id).Subject;
            }
        }else if(idContactos.size() > 0){   
            contactos = [SELECT Id,Name,UltimaActvidad__c,UltimaActividadAsunto__c FROM Contact WHERE Id IN : idContactos];
            for(Contact contacto : contactos){
                contacto.UltimaActvidad__c = mapObjetoTarea.get(contacto.Id).Id;
                contacto.UltimaActividadAsunto__c = mapObjetoTarea.get(contacto.Id).Subject;
            }
        }else if(idCuentas.size() > 0){ 
            cuentas = [SELECT Id,Name,UltimaActvidad__c,UltimaActividadAsunto__c FROM Account WHERE Id IN : idCuentas];
            for(Account cuenta : cuentas){
                cuenta.UltimaActvidad__c = mapObjetoTarea.get(cuenta.Id).Id;
                cuenta.UltimaActividadAsunto__c = mapObjetoTarea.get(cuenta.Id).Subject;
            }
        }else if(idOportunidades.size() > 0){
            oportunidades = [SELECT Id,Name,UltimaActvidad__c,UltimaActividadAsunto__c FROM Opportunity WHERE Id IN : idOportunidades];
            for(Opportunity oportunidad : oportunidades){
                oportunidad.UltimaActvidad__c = mapObjetoTarea.get(oportunidad.Id).Id;
                oportunidad.UltimaActividadAsunto__c = mapObjetoTarea.get(oportunidad.Id).Subject;
            }
        }
        
        if(prospectos.size() > 0){
            update prospectos;
        }
        if(contactos.size() > 0){
            update contactos;
        }
        if(cuentas.size() > 0){
            update cuentas;
        }
        if(oportunidades.size() > 0){
            update oportunidades;
        }
    }*/
}