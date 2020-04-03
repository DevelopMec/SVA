public virtual class LightningService_CTRL {
	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 22/12/2017
		* @description Ejecuta un SOQL válido para salesforce.
	*/
	@AuraEnabled
	public static List<sObject> executeQuery( String query ) {
		return Database.query(query);
	}
	
	/**
		* @author ibautista@ctconsulting.com.mx
		* @date 20/12/2017
		* @param objs Lista de Apiname de los obejtos a describir.
		* @description Obtiene metadatos de uno ó varios objetos definidos en salesforce.
		* @return Objeto con los metadatos obtenidos.
	*/
	@AuraEnabled
	public static Map<String, Object> describeSObjects( String[] objs ) {
		
		Map<String, Object> response = new Map<String, Object>();
		
		if( objs != null && objs.size() > 0 ) {
			for( Schema.DescribeSobjectResult dsor: Schema.describeSObjects(objs) ) {
				
				Map<String, Object> fields = new Map<String, Object>();
				
				for ( Schema.SObjectField sof : dsor.fields.getMap().values() ) {
					
					Map<String, Object> field = new Map<String, Object>();
					
					Schema.DescribeFieldResult dfr = sof.getDescribe();
					
					// Field name
					field.put('name', dfr.getName());
					field.put('label', dfr.getLabel());
					field.put('isCustom', dfr.isCustom());
					field.put('type', String.valueOf(dfr.getType()));
					field.put('editable', dfr.isCreateable());
					field.put('updateable', dfr.isUpdateable());
					field.put('required', dfr.isNillable() == false && String.valueOf(dfr.getType()) != 'BOOLEAN' );

					if( dfr.getName() == 'Id' ) {
						field.put('prefix', dsor.getKeyPrefix());
					}
 					
					if (String.valueOf(dfr.getType()) == 'PICKLIST' || String.valueOf(dfr.getType()) == 'MULTIPICKLIST' || String.valueOf(dfr.getType()) == 'REFERENCE') {
						if ( dfr.picklistValues.size() > 0 ) {
							
							List<Object> values = new List<Object>();
							for (Schema.PicklistEntry ple : dfr.picklistValues) {
								Map<String, String> value = new Map<String, String>();
								value.put('label', ple.getLabel());
								value.put('value', ple.getValue());
								
								if( ple.isDefaultValue() ) {
									value.put('defaultValue', ple.getValue());
								}
								values.add(value);
							}
							field.put('values', values);
							field.put('restrictedPicklist', dfr.restrictedpicklist);
						}
						
						if (dfr.getRelationshipName() != '') {
							field.put('relationshipName', dfr.getRelationshipName());
						}
					} else if (String.valueOf(dfr.getType()) == 'DOUBLE' || String.valueOf(dfr.getType()) == 'PERCENT' || String.valueOf(dfr.getType()) == 'CURRENCY') {
						field.put('precision', String.valueOf(dfr.getPrecision()));
						field.put('scale', String.valueOf(dfr.getScale()));
						
						field.put('length', dfr.getScale() > 0 ? (String.valueOf(dfr.getPrecision() + 1)) : String.valueOf(dfr.getPrecision()));
					}
					
					if (dfr.getController() != null) {
						field.put('controller', dfr.getController().getDescribe().getName());
					}
					
					if (dfr.getInlineHelpText() != '') {
						field.put('inlineHelpText', dfr.getInlineHelpText());
					}
					
					fields.put(dfr.getName(), field);
				}
				
				// Fields by sObject
				response.put(dsor.getName(), fields);
				
			}
			
		} else {
			response.put('error', 'Nombre de objetos es requerido. Ejemplo: ["Account", "Opportunity"]');
		}
		return response;
	}
	
	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 2018
		* @param parentId Id del objeto padre al que asignará el Attachment.
		* @param strDataBase64 Cadena de texto en base64.
		* @param fileName Nombre al que se le asignará el Attachment.
		* @param contentType Tipo de archivo a persistir.
		* @param attachmentId Id del Attachment a actualizar.
		* @description Inserta ó actualiza una instancia de Attacment.
		* @return Objetos con los resultados obtenidos, propiedad Upsert_Attachment con datos del DML ó error si es que ocurrió alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> saveAttachment( String parentId, String strDataBase64, String fileName, String contentType, String attachmentId ) {
		Map<String, Object> response = new Map<String, Object>();

		if(String.isNotBlank(parentId) && String.isNotBlank(strDataBase64)) {
				
			Attachment newAttactment = new Attachment(ContentType = contentType, Name = fileName, ParentId = parentId);
			newAttactment.Body = EncodingUtil.base64Decode( strDataBase64 );

			if( String.isNotBlank(attachmentId) ) {
				newAttactment.Id = attachmentId;
			}
			
			List<Attachment> instances = new List<Attachment>();
			instances.add(newAttactment);

			for (Database.upsertResult ur : Database.upsert(instances)) {
				Map<String, Object> mapAttachment = new Map<String, Object>();
				mapAttachment.put('Id', ur.getId());
				Database.Error[] errors = ur.getErrors();
				if( errors != null && errors.size() > 0 ) {
					mapAttachment.put('errors', errors);
				}
				mapAttachment.put('isCreated', ur.isCreated());
				mapAttachment.put('isSuccess', ur.isSuccess());
				response.put('Upsert_Attachment', mapAttachment);
			}

			
		} else {
			response.put('error', 'Parámetros {parentId} y {strDataBase64} son requeridos');
		}
		return response;
	}
	
	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 2018
		* @param typeobj Apiname del objeto al que se aplicará el DML.
		* @param data Cadena en formato JSON de un array de instancias a manipular.
		* @description Inserta ó actualiza un objeto de salesforce.
		* @return Objeto con los resultados obtenidos.
	*/
	@AuraEnabled
    public static Object upsertObject( String typeobj, String data ) {
    	Map<String, Object> response = new Map<String, Object>();
        Type t = Type.forName('List<' + typeobj + '>');
    	List<Object> result = new List<Object>();
        List<sObject> instances = (List<sObject>) JSON.deserialize(data, t);
        for( Database.UpsertResult dur :  Database.upsert(instances) ) {
        	Map<String, Object> res = new Map<String, Object>();
        	Database.Error[] errors = dur.getErrors();
        	res.put('id', dur.getId());
        	if( errors != null && errors.size() > 0 ) {
        		res.put('errors', errors);
        	}
        	res.put('created', dur.isCreated());
        	res.put('success', dur.isSuccess());
        	result.add(res);
        }
        response.put('result', result);
        response.put('limits', LightningService_CTRL.getLimits());
        return response;
    }
	
	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 2018
		* @description Obtiene los límites de gobierno actuales.
		* @return Objeto con los limites de gobierno obtenidos.
	*/
    public static Map<String, Object> getLimits() {
	    Map<String, Object> ret = new Map<String, Object>();
	    ret.put('DMLLimit', Limits.getLimitDMLStatements());
	    ret.put('DMLExecuted', Limits.getDMLStatements());
	    ret.put('DMLAvailable', Limits.getLimitDMLStatements() - Limits.getDMLStatements());

	    ret.put('SOQLLimit', Limits.getLimitQueries());
	    ret.put('SOQLExecuted', Limits.getQueries());
	    ret.put('SOQLAvailable', Limits.getLimitQueries() - Limits.getQueries());
	    return ret;
	}
	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 2018
		* @description Manejo personalizado de excepciones
	*/
  	public class CustomException extends Exception { }
}