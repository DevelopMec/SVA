public class ActivityCounter {
    // WhoId = Lead, Contactos
    // WhatId = oportunidades, cuentas, amenazas, OT, Ticket
    public static void  generaContadorTipoTarea(List<Task> listTask){
        set<Id> idObjetoWho = new set<Id>();
        set<Id> idObjetoWhat = new set<Id>();
        set<Id> idObjetoCuenta = new set<Id>();
        
        for(Task tarea:listTask){
            if(tarea.WhatId != null){
                String objetoWhat = Utils.obtenerNombreObjeto(tarea.WhatId);
                if (objetoWhat == 'Amenaza__c' || objetoWhat == 'WorkOrder' || objetoWhat == 'Case' || objetoWhat == 'Opportunity')
                    idObjetoWhat.add(tarea.WhatId);
            }
            if(tarea.WhatId != null){
                String objetoWhat = Utils.obtenerNombreObjeto(tarea.WhatId);
                if (objetoWhat == 'Account')
                    idObjetoCuenta.add(tarea.WhatId);
            }
            if(tarea.WhoId != null && tarea.WhatId == null){
                String objetoWho = Utils.obtenerNombreObjeto(tarea.WhoId);
                if (objetoWho == 'Lead' || objetoWho == 'Contact')
                    idObjetoWho.add(tarea.WhoId);
            }
        }
        if(idObjetoWhat.size() > 0){
            actualizaConteoTareaWhat(idObjetoWhat);
        }
        if(idObjetoCuenta.size() > 0){
            actualizaConteoTareaCuenta(idObjetoCuenta);
        }
        if(idObjetoWho.size() > 0){
            actualizaConteoTareaWho(idObjetoWho);
        }
    }
    
    private static void actualizaConteoTareaWho(Set<Id> idObjeto){
        Map<Id, Task> TaskMap = new Map<Id, Task>();
        if(idObjeto.size() > 0){
            List<Task> listTareas = [SELECT id, Whoid, ActivityType__c, TaskNumber__c, status FROM Task 
                                     WHERE status = 'Concluida' AND TaskSubtype != 'Email' AND Whoid in :idObjeto  
                                     AND WhatId= null
                                     ORDER BY createddate ASC];
            if(listTareas.size() > 0){
                integer contador = 0;
                for(Task tarea : listTareas){
                    if(tarea.Status == 'Concluida'){
                        contador++;
                    }
                    if(contador <= 1 && (tarea.ActivityType__c == null || tarea.ActivityType__c != 'Primera Tarea')){
                        tarea.ActivityType__c = 'Primera Tarea';
                        tarea.TaskNumber__c = contador;
                        TaskMap.put(tarea.id, tarea);
                    } 
                    if(contador > 1 && (tarea.TaskNumber__c == null || tarea.TaskNumber__c == 0 || tarea.TaskNumber__c != contador)){
                        tarea.ActivityType__c = 'Tarea de Seguimiento';
                        tarea.TaskNumber__c = contador;
                        TaskMap.put(tarea.id, tarea);
                    }
                }
            }
        }
        if(!TaskMap.isEmpty() && TaskMap.size() > 0){
            database.update(TaskMap.values(), false);
        }
    }
    
    private static void actualizaConteoTareaWhat(Set<Id> idObjeto){
        Map<Id, Task> TaskMap = new Map<Id, Task>();
        if(idObjeto.size() > 0){
            List<Task> listTareas = [SELECT id, Whatid, ActivityType__c, TaskNumber__c, status FROM Task 
                                     WHERE status = 'Concluida' AND TaskSubtype != 'Email' AND Whatid in :idObjeto 
                                     ORDER BY createddate ASC];
            if(listTareas.size() > 0){
                integer contador = 0;
                for(Task tarea : listTareas){
                    if(tarea.Status == 'Concluida'){
                        contador++;
                    }
                    if(contador <= 1 && (tarea.ActivityType__c == null || tarea.ActivityType__c != 'Primera Tarea')){
                        tarea.ActivityType__c = 'Primera Tarea';
                        tarea.TaskNumber__c = contador;
                        TaskMap.put(tarea.id, tarea);
                    } 
                    if(contador > 1 && (tarea.TaskNumber__c == null || tarea.TaskNumber__c == 0 || tarea.TaskNumber__c != contador)){
                        tarea.ActivityType__c = 'Tarea de Seguimiento';
                        tarea.TaskNumber__c = contador;
                        TaskMap.put(tarea.id, tarea);
                    }
                }     
            }
           
        }
        if(!TaskMap.isEmpty() && TaskMap.size() > 0){
            database.update(TaskMap.values(), false);
        }
    }
    
    private static void actualizaConteoTareaCuenta(Set<Id> idObjeto){
        Map<Id, Task> TaskMap = new Map<Id, Task>();
        if(idObjeto.size() > 0){
            Integer fiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
            Date fiscalYear = Date.newinstance(system.today().year(), fiscalMonth, 1);
            //DateTime fiscalYear = DateTime.newInstance(2020,5,13,16,27,50);
            fiscalYear.format();
            List<Task> listTareas = [SELECT id, Whatid, ActivityType__c, TaskNumber__c, status FROM Task 
                                     WHERE status = 'Concluida' AND TaskSubtype != 'Email' AND createdDate >= :fiscalYear AND Whatid in :idObjeto 
                                     ORDER BY createddate ASC];
            if(listTareas.size() > 0){
                integer contador = 0;
                for(Task tarea : listTareas){
                    if(tarea.Status == 'Concluida'){
                        contador++;
                    }
                    if(contador <= 1 && (tarea.ActivityType__c == null || tarea.ActivityType__c != 'Primera Tarea')){
                        tarea.ActivityType__c = 'Primera Tarea';
                        tarea.TaskNumber__c = contador;
                        TaskMap.put(tarea.id, tarea);
                    } 
                    if(contador > 1 && (tarea.TaskNumber__c == null || tarea.TaskNumber__c == 0 || tarea.TaskNumber__c != contador)){
                        tarea.ActivityType__c = 'Tarea de Seguimiento';
                        tarea.TaskNumber__c = contador;
                        TaskMap.put(tarea.id, tarea);
                    }
                }
            }
        }
        if(!TaskMap.isEmpty() && TaskMap.size() > 0){
            database.update(TaskMap.values(), false);
        }
    }  
    
    
    public static void  generaContadorTipoEvento(List<Event> listEvent){
        set<Id> idObjetoWho = new set<Id>();
        set<Id> idObjetoWhat = new set<Id>();
        set<Id> idObjetoCuenta = new set<Id>();
        
        for(Event evento:listEvent){
            if(evento.WhatId != null){
                String objetoWhat = Utils.obtenerNombreObjeto(evento.WhatId);
                if (objetoWhat == 'Amenaza__c' || objetoWhat == 'WorkOrder' || objetoWhat == 'Case' || objetoWhat == 'Opportunity')
                    idObjetoWhat.add(evento.WhatId);
            }
            if(evento.WhatId != null){
                String objetoWhat = Utils.obtenerNombreObjeto(evento.WhatId);
                if (objetoWhat == 'Account')
                    idObjetoCuenta.add(evento.WhatId);
            }
            if(evento.WhoId != null && evento.WhatId == null){
                String objetoWho = Utils.obtenerNombreObjeto(evento.WhoId);
                if (objetoWho == 'Lead' || objetoWho == 'Contact')
                    idObjetoWho.add(evento.WhoId);
            }
        }
        if(idObjetoWhat.size() > 0){
            actualizaConteoEventoWhat(idObjetoWhat);
        }
        if(idObjetoCuenta.size() > 0){
            actualizaConteoEventoCuenta(idObjetoCuenta);
        }
        if(idObjetoWho.size() > 0){
            actualizaConteoEventoWho(idObjetoWho);
        }
    }
    
    private static void actualizaConteoEventoWho(Set<Id> idObjeto){
        Map<Id, Event> EventMap = new Map<Id, Event>();
        if(idObjeto.size() > 0){
            List<Event> listEvent = [SELECT id, Whoid, ActivityType__c, EventNumber__c, EstatusEvento__c FROM Event 
                                     WHERE EstatusEvento__c = 'Finalizado' AND Whoid in :idObjeto AND WhatId= null
                                     ORDER BY createddate ASC];
            if(listEvent.size() > 0){
                integer contador = 0;
                for(Event evento : listEvent){
                    if(evento.EstatusEvento__c == 'Finalizado'){
                        contador++;
                    }
                    if(contador <= 1 && (evento.ActivityType__c == null || evento.ActivityType__c != 'Primera Cita')){
                        evento.ActivityType__c = 'Primera Cita';
                        evento.EventNumber__c = contador;
                        EventMap.put(evento.id, evento);
                    } 

                    if(contador > 1 && (evento.EventNumber__c == null || evento.EventNumber__c == 0 || evento.EventNumber__c != contador)){
                        evento.ActivityType__c = 'Cita de Seguimiento';
                        evento.EventNumber__c = contador;
                        EventMap.put(evento.id, evento);
                    }
                }
            }
        }
        if(!EventMap.isEmpty() && EventMap.size() > 0){
            database.update(EventMap.values(), false);
        }
    }
    
    private static void actualizaConteoEventoWhat(Set<Id> idObjeto){
        Map<Id, Event> EventMap = new Map<Id, Event>();
        if(idObjeto.size() > 0){
            List<Event> listEvent = [SELECT id, Whatid, ActivityType__c, EventNumber__c, EstatusEvento__c FROM Event 
                                     WHERE EstatusEvento__c = 'Finalizado' AND Whatid in :idObjeto 
                                     ORDER BY createddate ASC];
            if(listEvent.size() > 0){
                integer contador = 0;
                for(Event evento : listEvent){
                    if(evento.EstatusEvento__c == 'Finalizado'){
                        contador++;
                    }
                    if(contador <= 1 && (evento.ActivityType__c == null || evento.ActivityType__c != 'Primera Cita')){
                        evento.ActivityType__c = 'Primera Cita';
                        evento.EventNumber__c = contador;
                        EventMap.put(evento.id, evento);
                    } 
                    if(contador > 1 && (evento.EventNumber__c == null || evento.EventNumber__c == 0 || evento.EventNumber__c != contador)){
                        evento.ActivityType__c = 'Cita de Seguimiento';
                        evento.EventNumber__c = contador;
                        EventMap.put(evento.id, evento);
                    }                    
                }
            }
        }
        if(!EventMap.isEmpty() && EventMap.size() > 0){
            database.update(EventMap.values(), false);
        }
    }
    
    private static void actualizaConteoEventoCuenta(Set<Id> idObjeto){
        Map<Id, Event> EventMap = new Map<Id, Event>();
        if(idObjeto.size() > 0){
            Integer fiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
            Date fiscalYear = Date.newinstance(system.today().year(), fiscalMonth, 1);
            fiscalYear.format();
            
            List<Event> listEvent = [SELECT id, Whatid, ActivityType__c, EventNumber__c, EstatusEvento__c FROM Event 
                                     WHERE EstatusEvento__c = 'Finalizado' AND createdDate >= :fiscalYear AND Whatid in :idObjeto 
                                     ORDER BY createddate ASC];
            if(listEvent.size() > 0){
                integer contador = 0;
                for(Event evento : listEvent){
                    if(evento.EstatusEvento__c == 'Finalizado'){
                        contador++;
                    }
                    if(contador <= 1 && (evento.ActivityType__c == null || evento.ActivityType__c != 'Primera Cita')){
                        evento.ActivityType__c = 'Primera Cita';
                        evento.EventNumber__c = contador;
                        EventMap.put(evento.id, evento);
                    } 
                    if(contador > 1 && (evento.EventNumber__c == null || evento.EventNumber__c == 0 || evento.EventNumber__c != contador)){
                        evento.ActivityType__c = 'Cita de Seguimiento';
                        evento.EventNumber__c = contador;
                        EventMap.put(evento.id, evento);
                    }
                }
            }
        }
        if(!EventMap.isEmpty() && EventMap.size() > 0){
            database.update(EventMap.values(), false);
        }
    }
    
}