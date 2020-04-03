/**
	* @author calvarez@ctconsulting.com.mx
	* @date 28/03/2018
	* @description Controlador de eventos del Trigger de EntidadCuenta
	* @group EstructuraCuentas
*/
public class TriggerEntidadCuentaHandler extends TriggerHandler {
	private Map<Id, EntidadCuenta__c> newMap;
	private Map<Id, EntidadCuenta__c> oldMap;
	private List<EntidadCuenta__c> newList;
	private List<EntidadCuenta__c> oldList;

	public TriggerEntidadCuentaHandler() {
		this.newMap 	= (Map<Id, EntidadCuenta__c>) trigger.newMap;
		this.oldMap 	= (Map<Id, EntidadCuenta__c>) trigger.oldMap;
		this.newList 	= (List<EntidadCuenta__c>) trigger.new;
		this.oldList 	= (List<EntidadCuenta__c>) trigger.old;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2018
		* @description Método que se ejecuta antes de insertar registros de EntidadCuenta__c.
	**/
	public override void beforeInsert() {
		verificaDuplicado(this.newList);// agrega calvarez 02/04/2018
	}


	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @description Método que se ejecuta antes de actualizar registros de EntidadCuenta__c.
	**/
	public override void beforeUpdate() {
		verificaDuplicado(this.newList);// agrega calvarez 02/04/2018
	}


	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 28/03/2018
		* @description Método que se ejecuta antes de actualizar registros de EntidadCuenta__c.
	**/
	public override void beforeDelete() {
		desasociarCuentaEntidadLegal(this.oldList);// agrega calvarez 02/04/2018
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2018
		* @param listaEntidades Lista de instancias de EntidadCuenta__c  a validar
		* @description Método que valida que el no existan duplicados, es decir, no se debe agregar dos veces una misma EntidadLegal__c a la cuenta.
	**/
	public void verificaDuplicado( List<EntidadCuenta__c> listaEntidades ) {
		if( listaEntidades != null ) {

			Map<String, Id> mapEntidades = new Map<String, Id>();
			Set<Id> setIdCuenta = new Set<Id>();
			for( EntidadCuenta__c ec: listaEntidades ) {
				if( String.isBlank(ec.Cuenta__c) ) {
					ec.Cuenta__c.addError('Cuenta es requerido.');
				} else if( String.isBlank(ec.EntidadLegal__c)) {
					ec.EntidadLegal__c.addError('Entidad legal es requerido.');
				} else {
					setIdCuenta.add( ec.Cuenta__c );					
				}
			}
		

			

			if( setIdCuenta != null && setIdCuenta.size() > 0 ) {

				List<EntidadCuenta__c> listaECStored = [SELECT Id, Cuenta__c, EntidadLegal__c FROM EntidadCuenta__c WHERE Cuenta__c IN : setIdCuenta ];
				for( EntidadCuenta__c ec: listaECStored ) {
					mapEntidades.put(ec.Cuenta__c + '_' + ec.EntidadLegal__c, ec.Id);
				}

				for( EntidadCuenta__c ec: listaEntidades ) {
					String key = ec.Cuenta__c + '_' + ec.EntidadLegal__c;
					if( mapEntidades.containsKey(key) && mapEntidades.get(key) != ec.Id ) {
						ec.EntidadLegal__c.addError('La Entidad legal seleccionada ya está asociada a la cuenta');
					}
				}
			}
		}
	}

	public void desasociarCuentaEntidadLegal( List<EntidadCuenta__c> listaEntidades ) {
		Set<Id> setIdEntidad = new Set<Id>();
		List<EntidadLegal__c> listEntidadLegal = new List<EntidadLegal__c>();
		for( EntidadCuenta__c ec: listaEntidades ) {
			setIdEntidad.add(ec.Id);
		}

		Map<Id, EntidadCuenta__c> mapECStored = new Map<Id, EntidadCuenta__c>([SELECT Id, EntidadLegal__c, (SELECT Id FROM Administraci_n_de_Ventas__r) FROM EntidadCuenta__c WHERE Id IN : setIdEntidad]);
		for( EntidadCuenta__c ec : listaEntidades ) {
			if( mapECStored.containsKey(ec.Id) ) {
				if( mapECStored.get(ec.Id).Administraci_n_de_Ventas__r.size() <= 0 ) {
					listEntidadLegal.add(new EntidadLegal__c( Id = mapECStored.get(ec.Id).EntidadLegal__c, Cuenta__c = null));
				} else {
					ec.addError('No se puede eliminar, tiene contratos asociados');
				}
			}
		}
		if( listEntidadLegal.size() > 0 ) {
			update listEntidadLegal;
		}
	}
}