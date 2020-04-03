/**
* @author ibautista@ctconsulting.com.mx
* @date 15/12/2017
* @group Checklist de Documentos
* @description Controlador principal de la aplicación "Checklist de Documentos".
*
* Es usado en los siguientes recursos:
*
* - Clases de Apex:
* -> CON_ContractsContainer_CTRL
*
* - Componentes de Lightning:
* -> CON_OppDocChecklist_LC
*
* Clase de Test: CON_OppDocChecklist_TEST
*/
public virtual class CON_OppDocChecklist_CTRL {
	/**
	* @description Crea y asocia una instancia de Attachment a un determinado registro de Oportunidad y la inserta en la
	* base de datos. Después, actualiza dicha Oportunidad, marcando un determinado campo que está asociado al Attachment
	* insertado.
	* @param oppId El Id de la Oportunidad
	* @param attachmentName El nombre del Attachment
	* @param attachmentBody El contenido del Attachment
	* @param oppFieldName El nombre del campo de la Oportunidad a actualizar
	* @return El Id del Attachment insertado
	*/
	@AuraEnabled
	public static Id saveAttachment(Id oppId, String attachmentName, String attachmentBody, String oppFieldName) {
		//System.debug('saveAttachment, arguments:' + oppId + ', ' + attachmentName + ', ' + attachmentBody);
		try {
			Blob ab = EncodingUtil.base64Decode(attachmentBody);
			Attachment attch = new Attachment(ParentId = oppId, Name = attachmentName + '.pdf', Body = ab);
			insert attch;
			Opportunity opp = new Opportunity(Id = oppId);
			opp.put(oppFieldName, true);
			update opp;
			return attch.Id;
		} catch (Exception e) {
			System.debug('e:' + e.getMessage() + ', ' + e.getStackTraceString());
			return null;
		}
	}
	/**
	* @description Elimina un determinado registro de Attachment. Después, actualiza la Oportunidad del Attachment
	* eliminado, desmarcando un determinado campo que estaba asociado a dicho Attachment.
	* @param attachmentId El Id del Attachment
	* @param oppId El Id de la Oportunidad
	* @param oppFieldName El nombre del campo de la Oportunidad a actualizar
	* @return El Id del Attachment eliminado
	*/
	@AuraEnabled
	public static Id deleteAttachment(Id attachmentId, Id oppId, String oppFieldName) {
		Attachment attch = new Attachment(Id = attachmentId);
		delete attch;
		Opportunity opp = new Opportunity(Id = oppId);
		opp.put(oppFieldName, false);
		update opp;
		return attachmentId;
	}
	/**
	* @description Crea una determinada instancia de Attachment y actualiza el correspondiente registro.
	* @param attachmentId El Id del Attachment
	* @param attachmentBody El contenido del Attachment
	*/
	@AuraEnabled
	public static void updateAttachment(Id attachmentId, String attachmentBody) {
		Blob ab = EncodingUtil.base64Decode(attachmentBody);
		Attachment attch = new Attachment(Id = attachmentId, Body = ab);
		update attch;
	}
	/**
	* @description Obtiene y retorna todos los Attachments asociados a una determinada Oportunidad
	* @param oppId El Id de la Oportunidad
	* @return Una lista de los Attachments asociados
	*/
	@AuraEnabled
	/* public static List<Attachment> getOppAttachments(Id oppId) {
		List<Attachment> oppAttachments = [SELECT Id, Name FROM Attachment WHERE ParentId = :oppId];
		List<Opportunity> opp = [ SELECT Id, Entidad_Legal__c FROM opportunity WHERE Id =: oppId AND Entidad_Legal__c != null ];
		if( opp.size() > 0 ) {
			oppAttachments.addAll([SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = : opp[0].Entidad_Legal__c ]);
		}
		return oppAttachments;
	} */
	public static List<ContentDocumentLink> getOppAttachments(Id oppId) {
		List<ContentDocumentLink> oppAttachments = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :oppId];
		List<Opportunity> opps = [SELECT Id, Entidad_Legal__c FROM opportunity WHERE Id =: oppId AND Entidad_Legal__c != null];
		if (opps.size() > 0) {
			oppAttachments.addAll([SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :opps[0].Entidad_Legal__c]);
		}
		return oppAttachments;
	}
	/**
	* @description Obtiene y retorna las listas de los documentos asociados a un determinado tipo de persona de acuerdo
	* a la configuración personalizada "TiposDocumento".
	* @return Un mapa con dos entradas dónde la llave es el tipo de persona y el valor es la lista de los documentos
	* asociados.
	*/
	@AuraEnabled
	public static Map<String, Object> getDocsByTypePerson() {
		Map<String, Object> mapDocsByTypePerson = new Map<String, Object>(); 
		Map<String, TiposDocumento__c> mapTD = TiposDocumento__c.getAll();
		List<String> listTypePersons = new List<String>();
		listTypePersons.addAll(mapTD.keySet());
		for (String typePerson : listTypePersons) {
			SObject docsByTypePerson = mapTD.get(typePerson);
			Schema.DescribeSObjectResult dsor = docsByTypePerson.getSObjectType().getDescribe();
			List<Object> listDocs = new List<Object>();
			for (Schema.SObjectField sof : dsor.fields.getMap().values()) {
				Map<String, Object> mapDoc = new Map<String, Object>();
				Schema.DescribeFieldResult dfr = sof.getDescribe();
				//if ((dfr.isCustom()) && (dfr.getName() != 'AdjuntoA__c') ) {
				if ((dfr.isCustom())) {
					if ((docsByTypePerson.get(dfr.getName()) != null) && (docsByTypePerson.get(dfr.getName()) == true)) {
						mapDoc.put('name', String.valueOf(dfr.getLabel()));
						mapDoc.put('apiName', String.valueOf(dfr.getName()));
						listDocs.add(mapDoc);
					}
				}
			}
			mapDocsByTypePerson.put(typePerson, listDocs);
		}
		return mapDocsByTypePerson;
	}
	/**
	* @description Obtiene y retorna los códigos del registro patronal almacenados en la configuración personalizada
	* "Negocio"
	* @return Si la consulta se realiza exitosamente, retorna un registro de tipo Negocio__c, de lo contrario, retorna un
	* Map con información relativa a la excepción "System.Exception"
	*/
	@AuraEnabled
	public static Object getEmployerRegistrationData(Id oppId) {
		try {
			Map<String, Object> mapERD = new Map<String, Object>();
			Negocio__c n = [SELECT Id, CodigosRegistroPatronal__c FROM Negocio__c LIMIT 1];
			Opportunity opp = [SELECT Id, Codigo_Producto_cotizacion__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
			mapERD.put('employerRegistrationCodes', n);
			mapERD.put('opportunity', opp);
			return mapERD;
		} catch(System.Exception e) {
			return getMapException(e);
		}
	}
	/**
	* @description Obtiene y retorna información relativa a la excepción "System.Exception"
	* @param e Instancia de "System.Exception"
	* @return Retorna un Map
	*/
	private static Object getMapException(System.Exception e) {
		Map<String, Object> mapE = new Map<String, Object>();
		mapE.put('cause', e.getCause());
		mapE.put('lineNumber', e.getLineNumber());
		mapE.put('message', e.getMessage());
		mapE.put('stackTraceString', e.getStackTraceString());
		mapE.put('exceptionTypeName', e.getTypeName());
		return mapE;
	}
	/**
	* @description Obtiene y retorna determinada información de una Cuenta que está relacionada con una determinada
	* Oportunidad.
	* @param oppId El Id de la Oportunidad
	* @return Una registro de Cuenta
	*/
	@AuraEnabled
	public static SObject getRelatedAccountInformation(Id oppId) {
		List<Opportunity> listRelatedAccount = [SELECT Id, Account.Name, Account.TipoPersona__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
		return listRelatedAccount[0];
	}
	/**
	* @description Obtiene y retorna una lista de Oportunidades que tienen asociada un Contacto con función de
	* "Representante Legal" y que es "Extranjero".
	* @param oppId El Id de la Oportunidad
	* @return Una lista de registros de Oportunidad
	*/
	@AuraEnabled
	public static Object getContactLegalRepresentative(Id oppId) {
		List<Opportunity> listOpps = [SELECT Id FROM Opportunity WHERE Id = :oppId AND Contacto__r.Funcion__c = 'Representante Legal' AND Contacto__r.Extranjero__c = true];
		return listOpps;
	}
	
	/**
	* @description 
	* @param
	* @return
	*/
	@AuraEnabled
	public static Object updateDocAndOpp(Id documentId, String newTitle, Id oppId, String oppFieldName) {
		//Opportunity oppToUpdate = new Opportunity(Id = oppId);
		//oppToUpdate.put(oppFieldName, true);
		//update oppToUpdate;
		ContentDocument doc = [SELECT Id, Title FROM ContentDocument WHERE Id = :documentId];
		doc.Title = newTitle;
		Database.SaveResult updateResult = Database.update(doc);
		Map<String, Object> mapUpdateResult = new Map<String, Object>();
		mapUpdateResult.put('errors', updateResult.getErrors());
		mapUpdateResult.put('id', updateResult.getId());
		mapUpdateResult.put('isSuccess', updateResult.isSuccess());
		return mapUpdateResult;
	}
	
	/**
	* @description 
	* @param
	* @return
	*/
	@AuraEnabled
	public static Object deleteDocUpdateOpp(Id oldDocId, Id oppId, String oppFieldName) {
		//Opportunity oppToUpdate = new Opportunity(Id = oppId);
		//oppToUpdate.put(oppFieldName, false);
		//update oppToUpdate;
		Database.DeleteResult deleteResult = Database.delete(oldDocId);
		Map<String, Object> mapDeleteResult = new Map<String, Object>();
		mapDeleteResult.put('errors', deleteResult.getErrors());
		mapDeleteResult.put('id', deleteResult.getId());
		mapDeleteResult.put('isSuccess', deleteResult.isSuccess());
		return mapDeleteResult;
	}
}