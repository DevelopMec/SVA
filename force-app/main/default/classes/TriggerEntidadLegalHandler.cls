/**
	* @author calvarez@ctconsulting.com.mx
	* @date 28/03/2018
	* @description Controlador de eventos del Trigger de EntidadLegal
	* @group EstructuraCuentas
*/
public with sharing class TriggerEntidadLegalHandler extends TriggerHandler {

	private Map<Id, EntidadLegal__c> newMap;
	private Map<Id, EntidadLegal__c> oldMap;
	private List<EntidadLegal__c> newList;
	private List<EntidadLegal__c> oldList;

	public TriggerEntidadLegalHandler() {
		this.newMap 	= (Map<Id, EntidadLegal__c>) trigger.newMap;
		this.oldMap 	= (Map<Id, EntidadLegal__c>) trigger.oldMap;
		this.newList 	= (List<EntidadLegal__c>) trigger.new;
		this.oldList 	= (List<EntidadLegal__c>) trigger.old;
	}	

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @description Método que se ejecuta antes de insertar registros de EntidadLegal__c.
	**/
	public override void beforeInsert() {
		for( EntidadLegal__c el: this.newList ) {
			//el.Estatus__c = 'Incompleta';
		}
		transformaRFCaMayuscula(this.newList);// agrega calvarez 28/03/2018
		validaRFC(this.newList);// agrega calvarez 28/03/2018
	}


	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @description Método que se ejecuta antes de actualizar registros de EntidadLegal__c.
	**/
	public override void beforeUpdate() {
		transformaRFCaMayuscula(this.newList);// agrega calvarez 28/03/2018
		validaRFC(this.newList);// agrega calvarez 28/03/2018
		validaUsoEnEntidadCuenta( this.newList );
		creaEntidadCuenta( validaCrearEntidadCuenta( this.newList ) );
		
		
	}
	
	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2018
		* @description Método que se ejecuta antes de eliminar registros de EntidadLegal__c.
	**/
	public override void beforeDelete() {
		verificaUsoEL(this.oldList);// agrega calvarez 02/04/2018
	}


	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 09/04/2018
		* @description Método que se ejecuta después de insertar registros de EntidadLegal__c.
	**/
	public override void afterInsert() {
		creaEntidadCuenta( this.newList );
        //DYAMPI
		//creaActualizaDireccion(this.newList);
	}
	public override void afterUpdate() {
        //DYAMPI
		//creaActualizaDireccion(this.newList ,this.oldList);
		sendToSIGLO(this.newList);
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @param listaEntidades Lista de instancias de EntidadLegal__c  a validar
		* @description Método que valida que el Name ingresado en una EntidadLegal__c no esté en uso.
	**/
	public void validaRFC( List<EntidadLegal__c> listaEntidades ) {
		if( listaEntidades != null ) {
			Map<String, Id> mapRfcEL = new Map<String, Id>();
			for( EntidadLegal__c el: listaEntidades ) {
				if( String.isNotBlank(el.Name) ) {
					mapRfcEL.put(el.Name, el.Id);
				}
			}

			if( mapRfcEL != null && mapRfcEL.values().size() > 0 ) {

				List<EntidadLegal__c> listaELStored = [SELECT Id, Name FROM EntidadLegal__c WHERE Name IN : mapRfcEL.keySet() ];
				Map<String, Id> mapELStored = new Map<String, Id>();
				for( EntidadLegal__c el: listaELStored ) {
					mapELStored.put(el.Name, el.Id);
				}

				for( EntidadLegal__c el: listaEntidades ) {
					if( String.isNotBlank(el.Name) && mapELStored.containsKey(el.Name) && mapELStored.get(el.Name) != mapRfcEL.get(el.Name) ) {
						el.Name.addError(el.Name + ' ya está en uso, ingrese otro valor.');
					}
				}
			}
		}
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @param listaEntidades Lista de instancias de EntidadLegal__c  a procesar
		* @description Método que transforma a mayúsculas el Name ingresado de EntidadLegal__c.
	**/
	public void transformaRFCaMayuscula( List<EntidadLegal__c> listaEntidades ) {
		if( listaEntidades != null ) {
			for( EntidadLegal__c el: listaEntidades ) {
				if( String.isNotBlank(el.Name) ) {
					el.Name = el.Name.toUpperCase().trim();
				}
			}
		}
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @param listaEntidades Lista de instancias de EntidadLegal__c  a procesar
		* @description Método que verifica que una EntidadLegal__c no esté asociada a una cuenta.
	**/
	public void verificaUsoEL( List<EntidadLegal__c> listaEntidades ) {

		if( listaEntidades != null ) {

			Set<Id> setIds = new Set<Id>();
			for( EntidadLegal__c el: listaEntidades ) {
				setIds.add(el.Id);
			}
			List<EntidadCuenta__c> listaELStored = [SELECT EntidadLegal__c, Cuenta__c FROM EntidadCuenta__c WHERE EntidadLegal__c IN: setIds];
			System.debug('listaELStored: ' + listaELStored);
			Map<Id, Id> mapELStored = new Map<Id, Id>();
			for( EntidadCuenta__c ec: listaELStored ) {
				mapELStored.put(ec.EntidadLegal__c, ec.Cuenta__c);
			}

			for( EntidadLegal__c el: listaEntidades ) {
				if( mapELStored.containsKey(el.Id) ) {
					el.addError('No se puede eliminar Entidad legal, está asociada a la cuenta: ' + mapELStored.get(el.Id));
				}
			}

		}
		
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @param listaEntidades Lista de instancias de EntidadLegal__c  a procesar
		* @description Método que verifica que una EntidadLegal__c no esté asociada a una cuenta.
	**/
	public void creaEntidadCuenta( List<EntidadLegal__c> listaEntidades ) {
        Set<String> setEl=new Set<String>();
        for( EntidadLegal__c el: listaEntidades ) {
            setEl.add(el.Name);
        }
        Set<String> setEcExistentes=new Set<String>();
        Set<String> setEcInsertadas=new Set<String>();
        for(EntidadCuenta__c ec: [Select Id,RFCEL__c  from EntidadCuenta__c where RFCEL__c  IN :setEl and RFCEL__c !=null]){
            setEcExistentes.add(ec.RFCEL__c );
        }
		List<EntidadCuenta__c> listEntidadCuenta = new List<EntidadCuenta__c>();
        for( EntidadLegal__c el: listaEntidades ) {
            if( el.Cuenta__c  != null ) {
                if(setEcExistentes.contains(el.Name)){
                    el.addError('La Entidad Cuenta ya existe: '+el.Name);
                }else{
                    if(!setEcInsertadas.contains(el.Name)){
                        setEcInsertadas.add(el.Name);
                        listEntidadCuenta.add( new EntidadCuenta__c( Cuenta__c  = el.Cuenta__c , EntidadLegal__c = el.Id, Name=el.Name,RFC_IDExterno__c=el.Name) );
                    }else{
                        el.addError('La Entidad Cuenta se repite en la inserción');
                    }
                }                
            }
        }
        if( listEntidadCuenta != null && listEntidadCuenta.size() > 0 ) {
            insert listEntidadCuenta;
        }
		
	}

	public List<EntidadLegal__c> validaCrearEntidadCuenta( List<EntidadLegal__c> listaEntidades ) {
		List<EntidadLegal__c> response = new List<EntidadLegal__c>();
		Set<Id> setIds = new Set<Id>();
		for( EntidadLegal__c el : listaEntidades ) {
			setIds.add( el.Id );
		}
		if( setIds != null && setIds.size() > 0 ) {
			Map<Id, EntidadLegal__c> mapELStored = new Map<Id, EntidadLegal__c>([SELECT Id FROM EntidadLegal__c WHERE Id IN: setIds AND Cuenta__c = null]);
			for( EntidadLegal__c el : listaEntidades ) {
				if( mapELStored.containsKey(el.Id) ) {
					response.add(el);
				}
			}
		}
		return response;
	}

	public void validaUsoEnEntidadCuenta( List<EntidadLegal__c> listaEntidades ) {
		Set<Id> setIds = new Set<Id>();
		for( EntidadLegal__c el : listaEntidades ) {
			setIds.add( el.Id );
		}
		Map<Id, EntidadLegal__c> mapELStored = new Map<Id, EntidadLegal__c>([SELECT Id, Cuenta__c, (SELECT Id, Name FROM Entidades_Cuenta__r) FROM EntidadLegal__c WHERE Id IN: setIds]);

		for( EntidadLegal__c el : listaEntidades ) {
			if( el.Cuenta__c != mapELStored.get(el.Id).Cuenta__c && mapELStored.get(el.Id).Entidades_Cuenta__r.size() > 0 ) {
				// el.addError('No se puede cambiar de cuenta, tiene elementos asociados.');
			}
		}


	}

	/*public void creaActualizaDireccion(List<EntidadLegal__c> newEntidades ,List<EntidadLegal__c> oldEntidades){
    	List<EntidadLegal__c> listaEntidad = new List<EntidadLegal__c>();
    	set<id> setCuentas = new set<id>();
    	List<CatalogoDirecciones__c> listaDirecciones = new List<CatalogoDirecciones__c>();
    	map<id,CatalogoDirecciones__c> mapaDirecciones = new map<id,CatalogoDirecciones__c>();
    	String[] fieldNames = new String[] {'Calle__c', 'NumeroExterior__c', 'NumeroInterior__c','CodigoPostal__c','Colonia__c'};
     	 for(EntidadLegal__c entidad : newEntidades){
     	 	EntidadLegal__c cuentaOld = this.oldMap.get(entidad.Id);
     	 	for (String fields : fieldNames) {
	            if (entidad.get(fields) != cuentaOld.get(fields)) {
	               	listaEntidad.add(entidad);
	               	setCuentas.add(entidad.Id);
	               	break;
	            }
	        }
     	}
     	for(EntidadLegal__c cuenta :listaEntidad){
     		mapaDirecciones.put(cuenta.id,new CatalogoDirecciones__c(RFC__c=cuenta.Name,CuentaID__c=cuenta.Cuenta__c,Tipo_Pt__c='Razón Social',Name=cuenta.Name+'-'+cuenta.Calle__c,Calle_Tt__c=cuenta.Calle__c,NumeroExterior_Tt__c=cuenta.NumeroExterior__c,NumeroInterior_Tt__c=cuenta.NumeroInterior__c,Colonia_Tt__c=cuenta.Colonia__c,
     			EntidadLegal__c=cuenta.id,CodigoPostal_Tt__c=cuenta.CodigoPostal__c,DelegacionMunicipio_Tt__c=cuenta.DelegacionMunicipioFiscal__c,Estado_Tt__c=cuenta.Estado__c,Ciudad_Tt__c=cuenta.Ciudad__c));
     	}
     	listaDirecciones=[SELECT id,CuentaID__c,CuentaID__r.Name,CuentaID__r.Calle__c,RFC__c,EntidadLegal__c,Calle_Tt__c  from CatalogoDirecciones__c where EntidadLegal__c=:setCuentas ];
     	for(CatalogoDirecciones__c direccion :listaDirecciones){
     		if(mapaDirecciones.containskey(direccion.EntidadLegal__c)){
     				CatalogoDirecciones__c dir= new CatalogoDirecciones__c();
	     			dir=mapaDirecciones.get(direccion.EntidadLegal__c);
	     			dir.id=direccion.id;
	     			dir.Name=mapaDirecciones.get(direccion.EntidadLegal__c).Calle_Tt__c+'-'+direccion.RFC__c;
	     			mapaDirecciones.put(direccion.EntidadLegal__c,dir);     			
     		}
     	}

     	if(!mapaDirecciones.isEmpty()){
     		upsert mapaDirecciones.values();
     	}
	}

	public void creaActualizaDireccion(List<EntidadLegal__c> newEntidades ){
    	List<CatalogoDirecciones__c> mapaDirecciones = new List<CatalogoDirecciones__c>();
     	for(EntidadLegal__c cuenta :newEntidades){
     		mapaDirecciones.add(new CatalogoDirecciones__c(RFC__c=cuenta.Name,CuentaID__c=cuenta.Cuenta__c,Tipo_Pt__c='Razón Social',Name=cuenta.Calle__c+'-'+cuenta.Name,Calle_Tt__c=cuenta.Calle__c,NumeroExterior_Tt__c=cuenta.NumeroExterior__c,NumeroInterior_Tt__c=cuenta.NumeroInterior__c,Colonia_Tt__c=cuenta.Colonia__c,
     			EntidadLegal__c=cuenta.ID,CodigoPostal_Tt__c=cuenta.CodigoPostal__c,DelegacionMunicipio_Tt__c=cuenta.DelegacionMunicipioFiscal__c,Estado_Tt__c=cuenta.Estado__c,Ciudad_Tt__c=cuenta.Ciudad__c));
     	}
     	insert mapaDirecciones;
	 }*/
	 
	 //Valida si existe algun cambio en los campos que se envian a SIGLO
	 public void sendToSIGLO(List<EntidadLegal__c> listaEntidades){
		System.debug('-------SendToSIGLO---------');
		Set<Id> elIds = new Set<Id>();
        for(EntidadLegal__c newEl : newMap.values()){
            EntidadLegal__c oldEl = oldMap.get(newEl.Id);
            if(newEl.RecordTypeId != oldEl.RecordTypeId || newEl.CountryOrigin__c != oldEl.CountryOrigin__c || newEl.DeedDate__c != oldEl.DeedDate__c || newEl.EconomicActivity__c != oldEl.EconomicActivity__c || newEl.Calle__c != oldEl.Calle__c || newEl.NumeroExterior__c != oldEl.NumeroExterior__c || 
				newEl.NumeroInterior__c != oldEl.NumeroInterior__c || newEl.Colonia__c != oldEl.Colonia__c || newEl.Estado__c != oldEl.Estado__c || newEl.DelegacionMunicipioFiscal__c != oldEl.DelegacionMunicipioFiscal__c || 
				newEl.CodigoPostal__c != oldEl.CodigoPostal__c || newEl.FEA__c != oldEl.FEA__c || newEl.DeedNumber__c != oldEl.DeedNumber__c || newEl.RazonSocial__c != oldEl.RazonSocial__c || 
				newEl.PersonType__c != oldEl.PersonType__c || newEl.Name != oldEl.Name){
					elIds.add(newEl.Id);
               }
		}
		if(!elIds.isEmpty()){
			List<Contrato2__c> contratoOpp = [SELECT Entidad_Legal__r.RecordTypeId, Entidad_Legal__r.CountryOrigin__c, Entidad_Legal__r.DeedDate__c, Entidad_Legal__r.EconomicActivity__c, 
												Entidad_Legal__r.Calle__c, Entidad_Legal__r.NumeroExterior__c, Entidad_Legal__r.NumeroInterior__c, Entidad_Legal__r.Colonia__c, 
												Entidad_Legal__r.Estado__c, Entidad_Legal__r.DelegacionMunicipioFiscal__c, Entidad_Legal__r.CodigoPostal__c, Entidad_Legal__r.FEA__c, 
												Entidad_Legal__r.DeedNumber__c, Entidad_Legal__r.RazonSocial__c, Entidad_Legal__r.PersonType__c, Entidad_Legal__r.Name,
												PartidaPresupuesto__r.Quote.OpportunityId
												FROM Contrato2__c 
												WHERE Entidad_Legal__c IN: elIds 
												AND PartidaPresupuesto__r.Quote.OpportunityId != null];
			List<Opportunity> oppListUPD = new List<Opportunity>();
			for(Contrato2__c contrato : contratoOpp){
				Opportunity oppToUpdate = new Opportunity(Id= contrato.PartidaPresupuesto__r.Quote.OpportunityId, SendToSIGLO__c = true);
                oppListUPD.add(oppToUpdate);
			}

			if(!oppListUPD.isEmpty()){
				update oppListUPD;
			}
		}

    }
}