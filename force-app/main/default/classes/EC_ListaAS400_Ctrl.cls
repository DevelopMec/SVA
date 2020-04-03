/**
	* @author calvarez@ctconsulting.com.mx
	* @date 2018
	* @description Controlador para listar subcuentas AS400.
	* @group EstructuraCuentas
*/
public without sharing class EC_ListaAS400_Ctrl {
	

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 16/04/2017
		* @param accountId Id de cuenta(Account).
		* @description Obtiene instancias Contrato2__c y ContratoFilial__c asociados a la cuenta.
		* @return Objeto con los resultados obtenidos.
	*/
	@AuraEnabled
	public static Map<String, Object> listaAS400( Id accountId ) {
		Map<String, Object> response = new Map<String, Object>();
		try {
			if ( String.isNotBlank( accountId ) ) {
				if( accountId.getSobjectType() == Schema.Account.SObjectType ) {
					response.put('filiales', [SELECT CodigoAS400__c,Entidad_Cuenta__r.Name,Entidad_Cuenta__c,Id,isPrime__c,Name,NombreEL__c,OwnerId FROM ContratoFilial__c WHERE Entidad_Cuenta__c =: [SELECT id from EntidadCuenta__c where Cuenta__c=:accountId] AND Contrato_2__c=null]);
					response.put('records', [SELECT Id, Cuenta__c, CodigoAS400__c, Entidad_Legal__r.Estatus__c, Entidad_Legal__r.Name, Entidad_Legal__r.RazonSocial__c, Entidad_Legal__r.RecordType.Name, ( SELECT Id, CodigoAS400__c, Entidad_Cuenta__r.NombreEL__c, Entidad_Cuenta__r.RFCEL__c, Entidad_Cuenta__r.Name FROM Contratos_Filial__r WHERE CodigoAS400__c != null AND isPrime__c!=true  ),PartidaPresupuesto__r.Product2.Name , PartidaPresupuesto__r.Product2.ProductCode, PartidaPresupuesto__r.Product2.Family FROM Contrato2__c WHERE Cuenta__c =: accountId AND CodigoAS400__c != null ORDER BY CreatedDate DESC ]);
                    response.put('codigosAs', [SELECT Id,CodigoAS400__c FROM ContratoFilial__c WHERE Entidad_Cuenta__r.Cuenta__c=: accountId]);
				} else {
					throw new PLAN_CuentaService.CustomException('El Id debe ser de tipo Account');
				}
			} else {
				response.put('error', 'Parameter @accountId is required');
			}
		} catch( Exception e ) {
			response.put('exception', e);
		}
		return response;
	}
    
    /**
		* @author sreyna@ctconsulting.com.mx
		* @date 25/04/2017
		* @description Obtiene la URL del tipo de metadato URLAS400 para ser mostrado en pantalla
		* @return String URL
	*/
	@AuraEnabled
	public static String getURL() {
		return [Select URL__c from URLAs400__mdt  Where DeveloperName = 'URLAS400'].URL__c;
	}
}