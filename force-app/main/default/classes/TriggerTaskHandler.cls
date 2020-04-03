public without sharing class TriggerTaskHandler  extends TriggerHandler{
	private Map<Id, Task> newMap;
	private Map<Id, Task> oldMap;
	private List<Task> newList;
	private List<Task> oldList;
	//private Map<Id,Profile> mapAdminProfiles;

	public TriggerTaskHandler() {
		this.newMap = (Map<Id, Task>) trigger.newMap;
		this.oldMap = (Map<Id, Task>) trigger.oldMap;
		this.newList = (List<Task>) trigger.new;
		this.oldList = (List<Task>) trigger.old;
		//mapAdminProfiles = new Map<Id,Profile>([SELECT Id,Name FROM Profile WHERE PermissionsModifyAllData = true]);
	}
	
	set<Id> idProspectos = new set<Id>(); 
	set<Id> idContactos = new set<Id>(); 
	set<Id> idCuentas = new set<Id>(); 
	set<Id> idOportunidades = new set<Id>(); 
	
	map<Id,Task> mapObjetoTarea = new map<Id,Task>();
	//WhoId
	list<Lead> prospectos = new list<Lead>();
	list<Contact> contactos = new list<Contact>();
	//WhatId
	list<Account> cuentas = new list<Account>();
	list<Opportunity> oportunidades = new list<Opportunity>();
	
	
	public override void beforeUpdate(){
		for(Task tarea:newList){
			if(tarea.Status == 'Completada'){
				tarea.TimestampCompletada__c = Datetime.now();
			}
		}
	}
	
	public override void afterUpdate(){
		//actulizarObjetosUltimaTarea();
	}

	public override void beforeDelete(){
		validaBorradoEventos(oldList);
	}
	
	public override void afterInsert(){
		actulizarObjetosUltimaTarea();
        insertarFechaPrimeraActividad();
	}
    
    public void validaBorradoEventos(List<Task> lista){
        for(Task tarea:lista){
			if(!FeatureManagement.checkPermission('Delete_WO')){
				tarea.addError('No cuenta con los permisos para eliminar el registro. Contacte a su adminsitrador');
			}
		}
    }
	
	
	public void actulizarObjetosUltimaTarea(){
		for(Task tarea:newList){
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
        List<Opportunity> oppsUpd=new List<Opportunity>();
		if(idOportunidades.size() > 0){
			oportunidades = [SELECT Id,Name,UltimaActvidad__c,UltimaActividadAsunto__c,FechaUltimaActividad__c FROM Opportunity WHERE Id IN : idOportunidades];
			for(Opportunity oportunidad : oportunidades){
                //if(!mapObjetoTarea.get(oportunidad.Id).IsAlert__c){
                if(!mapObjetoTarea.get(oportunidad.Id).IsAlert__c&&oportunidad.FechaUltimaActividad__c != mapObjetoTarea.get(oportunidad.Id).CreatedDate){
                    oportunidad.FechaUltimaActividad__c = mapObjetoTarea.get(oportunidad.Id).CreatedDate;  
                    oppsUpd.add(oportunidad);
                }
                //}				
			}
		}
		if(prospectos.size() > 0){
			update prospectos;
		}
		if(oppsUpd.size() > 0){
            System.debug('INSERTTASK2:'+oppsUpd.size());
			update oppsUpd;
		}
	}
	
    public void insertarFechaPrimeraActividad(){
        for(Task tarea:newList){
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
    
	/*
	//V1
	public void actulizarObjetosUltimaTarea(){
		
		for(Task tarea:newList){
			if(tarea.IsClosed){
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
	
	public String obtenerNombreObjeto(String idObjeto){
		String objectAPIName = '';
		if(idObjeto != null  && idObjeto != ''){
			Id idConvertido  = Id.valueOf (idObjeto);
			objectAPIName = idConvertido.getSObjectType().getDescribe().getName();
		}
		return objectAPIName;
	}
	
	
}