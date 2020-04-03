public class TriggerContactoEntidadHandler extends TriggerHandler {
	private Map<Id, ContactoEntidad__c> newMap;
	private Map<Id, ContactoEntidad__c> oldMap;
	private List<ContactoEntidad__c> newList;
	private List<ContactoEntidad__c> oldList;

	public TriggerContactoEntidadHandler() {
		this.newMap 	= (Map<Id, ContactoEntidad__c>) trigger.newMap;
		this.oldMap 	= (Map<Id, ContactoEntidad__c>) trigger.oldMap;
		this.newList 	= (List<ContactoEntidad__c>) trigger.new;
		this.oldList 	= (List<ContactoEntidad__c>) trigger.old;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2018
		* @description Método que se ejecuta antes de insertar registros de ContactoEntidad__c.
	**/
	public override void beforeInsert() {
		verificaDuplicado(this.newList);// agrega calvarez 02/04/2018
	}


	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @description Método que se ejecuta antes de actualizar registros de ContactoEntidad__c.
	**/
	public override void beforeUpdate() {
		verificaDuplicado(this.newList);// agrega calvarez 02/04/2018
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2018
		* @param listaContactos Lista de instancias de ContactoEntidad__c a validar
		* @description Método que valida que el no existan duplicados, es decir, no se debe agregar dos veces una misma EntidadLegal__c a la cuenta.
	**/
	public void verificaDuplicado( List<ContactoEntidad__c> listaContactos ) {
		if( listaContactos != null ) {

			Map<String, Id> mapEntidades = new Map<String, Id>();
			Map<Id, String> mapContactoCuenta = new Map<Id, String>();
			Set<Id> setIdContactoEntidad = new Set<Id>();
			Set<Id> setIdCuenta = new Set<Id>();
			Set<Id> setIdContacto = new Set<Id>();
			for( ContactoEntidad__c ec: listaContactos ) {
				if( String.isBlank(ec.Contacto__c) ) {
					ec.Contacto__c.addError('Contacto es requerido.');
				} else if( String.isBlank(ec.Entidad_Cuenta__c)) {
					ec.Entidad_Cuenta__c.addError('Entidad cuenta es requerido.');
				} else {
					setIdContactoEntidad.add( ec.Entidad_Cuenta__c );
					setIdContacto.add( ec.Contacto__c );
					//EC_ListaEntidadLegal_LC_Ctrl.actualizaEstatusEntidad(ec);
				}
			}

			if( setIdContactoEntidad != null && setIdContactoEntidad.size() > 0 ) {

				List<ContactoEntidad__c> listaECStored = [SELECT Id, Contacto__c, Entidad_Cuenta__c, Entidad_Cuenta__r.Cuenta__c FROM ContactoEntidad__c WHERE Entidad_Cuenta__c IN : setIdContactoEntidad ];

				for( ContactoEntidad__c ec: listaECStored ) {
					mapEntidades.put(ec.Contacto__c + '_' + ec.Entidad_Cuenta__c, ec.Id);
				}


				List<EntidadCuenta__c> listEntidadCuenta = [SELECT Id, Cuenta__c FROM EntidadCuenta__c WHERE Id IN: setIdContactoEntidad];
				for(EntidadCuenta__c ec : listEntidadCuenta ) {
					setIdCuenta.add( ec.Cuenta__c );
				}
				List<AccountContactRelation> listaContactoCuenta = [SELECT Id, AccountId, ContactId, Contact.Funcion__c FROM AccountContactRelation WHERE AccountId IN : setIdCuenta];
				for(AccountContactRelation acr: listaContactoCuenta ) {
					mapContactoCuenta.put( acr.ContactId, acr.Contact.Funcion__c);
				}

				for( ContactoEntidad__c ec: listaContactos ) {
					String key = ec.Contacto__c + '_' + ec.Entidad_Cuenta__c;
					if( mapEntidades.containsKey(key) && mapEntidades.get(key) != ec.Id ) {
						ec.Contacto__c.addError('El contacto seleccionado ya está asociado a la entidad cuenta');
					} else if( !mapContactoCuenta.containsKey(ec.Contacto__c) ) {
						ec.Contacto__c.addError('El contacto seleccionado no está asociado a la cuenta');
					} else if(mapContactoCuenta.containsKey(ec.Contacto__c) && mapContactoCuenta.get(ec.Contacto__c) != 'Representante Legal') {
						ec.Contacto__c.addError('El contacto seleccionado no tiene función de Representante Legal');
					}
				}
			}
		}
	}
}