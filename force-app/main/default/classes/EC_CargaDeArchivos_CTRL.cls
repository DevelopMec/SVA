/**
* @author rsanchez@ctconsulting.com.mx
* @date 26/03/2018
*
* @description Controller EC_CargaDeArchivos_CTRL
*/
public class EC_CargaDeArchivos_CTRL {
	
	/* @AuraEnabled
	public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType,String elFieldName) { 
		
		Attachment a;
		
		try{

			base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
				
						a = new Attachment();
						a.parentId = parentId;
		
						a.Body = EncodingUtil.base64Decode(base64Data);
						a.Name = fileName + '.pdf';
						a.ContentType = contentType;
						
						insert a;
						
			

			try{

				EntidadLegal__c eL = new EntidadLegal__c(Id = parentId);
				eL.put(elFieldName, true);
				update eL;
				
			}catch(Exception e){
				System.debug('Exception Cause update EntidadLegal__c: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
			}

		}catch(Exception ex){
			System.debug('Exception Cause save Attachment: '+ex.getCause() +'Line: '+ ex.getLineNumber()+' Message: '+ex.getMessage());
		}
		
		return a.Id;
	} */
	
	/* @AuraEnabled
	public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId,String elFieldName) { 
			if (fileId == '') {
					fileId = saveTheFile(parentId, fileName, base64Data, contentType,elFieldName);
			} else {
					appendToFile(fileId, base64Data);
			}
			
			return Id.valueOf(fileId);
	} */
	
	/* private static void appendToFile(Id fileId, String base64Data) {
			base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
			
			Attachment a = [
					SELECT Id, Body
					FROM Attachment
					WHERE Id = :fileId
			];
			
		String existingBody = EncodingUtil.base64Encode(a.Body);
			System.debug('existingBody:'+existingBody.length());
			a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
			
			update a;
	} */
	
	@AuraEnabled
	public static Id EC_saveAttachment2(String elId, String attId, String attachmentName, String elFieldName) {
		
		List<ContentDocument> attch = new List<ContentDocument>();
		
		System.debug('elId:'+elId+' attId:'+attId+' attachmentName:'+attachmentName+' elFieldName:'+elFieldName);
		
		try{
			
			attch = [SELECT Id , Title , ParentId FROM ContentDocument WHERE Id =: attId];
			
			if(attch.size() > 0){
				
				System.debug('ContentDocument:'+attch[0]);
				
				attch[0].Title = attachmentName;
				update attch[0];
				
				try {
					
					EntidadLegal__c eL = new EntidadLegal__c(Id = elId);
					eL.put(elFieldName, true);
					update eL;
					
				} catch(Exception e){
						System.debug('Exception Cause update EntidadLegal__c: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
				}
				
			}
			
		}catch(Exception ex){
			System.debug('Exception Cause save Attachment: '+ex.getCause() +'Line: '+ ex.getLineNumber()+' Message: '+ex.getMessage());
		}
		
		return attch[0].Id;
	}
	
	/**
	* @author calvarez@ctconsulting.com.mx
	* @date 07/08/2018
	* @description Persiste un Attachment relacionado a una EntidadLegal__c.
	*
	* @param parentId  El Id de la Entidad Legal correspondiente.
	* @param attachmentName El nombre asignado al Attachment a crear.
	* @param attachmentBody El contenido del File a subir.
	* @param elFieldName Campo en la Entidad Legal en el que se le asigna true que representa que se le asigno un attachment.
	* @param attchId Id del Attahment a actualizar.
	* @param replaceFile Indica si el archivo será reemplazado o se va a concatenar el contenido.
	* @param contentType Indica el contentType del archivo cargado.
	*
	* @return Id El Id del Attachment recien creado.
	*/
	/* @AuraEnabled
	public static Map<String, Object> saveAttachmentMultipart( Id parentId, String attachmentName, String attachmentBody, String elFieldName, Id attchId, Boolean insertFile, String contentType ) {
		
		Map<String, Object> response = new Map<String, Object>();
		
		try {
			
			if( parentId == null || String.isBlank(attachmentName) || String.isBlank(attachmentBody) || String.isBlank(elFieldName) ) {
				response.put('required', 'parentId, attachmentBody, attachmentName and elFieldName are required');
			}
			
			if( !response.containsKey('required') ) {
				
				response.put('entra', 'Procesa Attachment');
				
				Blob ab = EncodingUtil.base64Decode(attachmentBody);
				Attachment attc = null;
				
				if( insertFile ) { // insert or update Attachment
					
					if( attchId == null ) {
						attc = new Attachment(ParentId = parentId, Name = attachmentName, ContentType = contentType, Body = ab );
						insert attc;
					} else {
						attc = new Attachment(Body = ab, Id = attchId );
						update attc;
					}
					
					response.put('Attachment_Id', attc.Id);
					
				} else { // Concat content
					if( attchId == null ) {
						response.put('required', 'attchId is required');
					} else {
						List<Attachment> attcs = [SELECT Id, Body FROM Attachment WHERE Id =: attchId ];
						if( attcs != null && attcs.size() > 0 ) {
							attc = attcs[0];
							attc.Body = EncodingUtil.base64Decode(EncodingUtil.base64Encode(attc.Body) + attachmentBody);
							update attc; 
							response.put('Attachment_Id', attc.Id);
						}
					}
				}
			}
		} catch( Exception ex) {
			response.put('exception ', ex.getMessage() + ', ' + ex.getStackTraceString() );
		}
		return response;
	} */
	
	/**
	* @author rsanchez@ctconsulting.com.mx
	* @date 26/03/2018
	* @description Metodo que crea los Attachments a los registros correspondientes de la Entidad Legal en que se trabaja.
	*
	* @param Id elId El Id de la Entidad Legal correspondiente.
	* @param String attachmentName El nombre asignado al Attachment a crear.
	* @param String attachmentBody El contenido del File a subir.
	* @param String elFieldName Campo en la Entidad Legal en el que se le asigna true que representa que se le asigno un attachment.
	*
	* @return Id El Id del Attachment recien creado.
	*/
	@AuraEnabled
	public static Id EC_saveAttachment(Id elId, String attachmentName, String attachmentBody, String elFieldName) {

		List<Attachment> attch;
		
		try{

			Blob ab = EncodingUtil.base64Decode(attachmentBody);
			String attchName = attachmentName + '.pdf';

			attch = [SELECT Id , Name , ParentId,Body FROM Attachment WHERE ParentId =:elId AND Name =: attchName];

			if(attch.size() > 0){

				attch[0].Body = ab;
				update attch[0];

			}else{

				Attachment attch2 = new Attachment(ParentId = elId, Name = attchName, Body = ab);
				attch.add(attch2);
				insert attch;

			}
			

			try{

				EntidadLegal__c eL = new EntidadLegal__c(Id = elId);
				eL.put(elFieldName, true);
				update eL;

			}catch(Exception e){
				System.debug('Exception Cause update EntidadLegal__c: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
			}

		}catch(Exception ex){
			System.debug('Exception Cause save Attachment: '+ex.getCause() +'Line: '+ ex.getLineNumber()+' Message: '+ex.getMessage());
		}

		return attch[0].Id;
	}
	/**
		* @author rsanchez@ctconsulting.com.mx
		* @date 26/03/2018
		* @description Metodo que borra un Attachentes en especifico.
		*
		* @param Id attachmentId El Id del Attachment a borrar.
		* @param Id elId El Id de la Entidad Legal ligada al Attachment.
		* @param String elFieldName Nombre del campo en Entidad Legal donde se asigno el Attachment.
		*
		* @return Id El Id del Attachment borrado.
	*/
	@AuraEnabled
	public static Id EC_deleteAttachment(Id attachmentId, Id elId, String elFieldName) {
		Attachment attch = new Attachment(Id = attachmentId);
				try{
						delete attch;
						EntidadLegal__c eL = new EntidadLegal__c(Id = elId);
						eL.put(elFieldName, false);
						update eL;

				}catch(Exception e){
						System.debug('Exception Cause EC_deleteAttachment EntidadLegal__c: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
				}
				return attachmentId;
	}
		
		@AuraEnabled
	public static Id EC_deleteAttachment2(Id attachmentId, Id elId, String elFieldName) {
		// System.debug('EC_deleteAttachment2 attachmentId:'+attachmentId);
		ContentDocument attch = new ContentDocument(Id = attachmentId);
		try{
				delete attch;
				EntidadLegal__c eL = new EntidadLegal__c(Id = elId);
				eL.put(elFieldName, false);
				update eL;

		}catch(Exception e){
				System.debug('Exception Cause EC_deleteAttachment EntidadLegal__c: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
		}
		return attachmentId;
	}

	/**
		* @author rsanchez@ctconsulting.com.mx
		* @date 26/03/2018
		* @description Metodo que actualiza un Attachment.
		*
		* @param Id attachmentId El Id del Attachment a actualizar.
		* @param String attachmentBody El contenido del File a subir.
		*
	*/
	@AuraEnabled
	public static void EC_updateAttachment(Id attachmentId, String attachmentBody) {
		Blob ab = EncodingUtil.base64Decode(attachmentBody);
		Attachment attch = new Attachment(Id = attachmentId, Body = ab);
		update attch;
	}
	
	/**
		* @author rsanchez@ctconsulting.com.mx
		* @date 26/03/2018
		* @description Metodo obtiene la lista de Attachments ligados a la Entidad Legal especificada.
		*
		* @param Id elId El Id de la Entidad Legal.
		*
		* @return List<Attachment> Regresa la lista de Attachments ligados a la Entidad Legal.
	*/
	@AuraEnabled
	public static List<Attachment> EC_getAttachments(Id elId) {
		List<Attachment> eLAttachments = [SELECT Id, Name FROM Attachment WHERE ParentId = :elId];
		System.debug('EC_getAttachments: ' + eLAttachments);
		return eLAttachments;
	}
		
		@AuraEnabled
	public static List<ContentDocumentLink> EC_getAttachments2(Id elId) {
		/* List<ContentVersion> eLAttachments = [SELECT Id, ContentDocumentId, Title FROM ContentVersion where FirstPublishLocationId=:elId];
		System.debug('EC_getAttachments: ' + eLAttachments);
		return eLAttachments; */
		return [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :elId];
	}

	/**
	* @author rsanchez@ctconsulting.com.mx
	*
	* @param Id elId El id de la Entidad Legal.
	* @param Boolean El estatus a actualizar en la Entidad Legal.
	*
	* @return String Bandera al guardar.
	*/ 
	@AuraEnabled
	public static String EC_updateStatus(Id elId, String status){
		
		String respuesta = '';

		try{
			//EntidadLegal__c eL = [SELECT Id,Estatus__c FROM EntidadLegal__c WHERE Id =: elId];
			List<EntidadCuenta__c> entidad = [SELECT Id FROM EntidadCuenta__c WHERE EntidadLegal__c =: elId LIMIT 1];
			List<ContactoEntidad__c> contactoEntidad = [SELECT Id,Entidad_Cuenta__c FROM ContactoEntidad__c WHERE Entidad_Cuenta__c =: entidad[0].id LIMIT 1];
			//System.debug('Anydatatype_msg '+contactoEntidad.size());
			//eL.Estatus__c = status;
			if( contactoEntidad != null && contactoEntidad.size() > 0 ) {
				EC_ListaEntidadLegal_LC_Ctrl.actualizaEstatusEntidad(contactoEntidad[0]);
			} else if( elId != null ) {
				//update new EntidadLegal__c(Id = elId, Estatus__c = 'Incompleta');
			}
			//update eL;
			/*if(contactoEntidad.size()>0){
				EC_ListaEntidadLegal_LC_Ctrl.actualizaEstatusEntidad(contactoEntidad[0],status);
			}*/
			

			respuesta = 'SUCCESS';

		}catch(Exception e){
			System.debug('Exception Cause update EntidadLegal status: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
			respuesta = 'Exception Cause update EntidadLegal status: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage();		
		}

		return respuesta;
	}
	
	/**
		* @author rsanchez@ctconsulting.com.mx
		* @date 26/03/2018
		* @description Metodo que obtiene los tipos de documentos dentro de una configuración personalizada.
		*
		* @return Map<String, Object> Un mapa de los Tipos de documentos de la configuración personalizada.
	*/
	@AuraEnabled
	public static Map<String, Object> EC_getDocsByTypePerson() {

		Map<String, Object> mapDocsByTypePerson = new Map<String, Object>(); 
		Map<String, TiposDocumento__c> mapTD = TiposDocumento__c.getAll();
		List<String> listTypePersons = new List<String>();
		listTypePersons.addAll(mapTD.keySet());
		//System.debug('getDocsByTypePerson, listTypePersons: ' + listTypePersons);
		for (String typePerson : listTypePersons) {
			//System.debug('getDocsByTypePerson, mapTD.get(typePerson): ' + mapTD.get(typePerson));
			//System.debug('getDocsByTypePerson, typePerson: ' + typePerson);
			SObject docsByTypePerson = mapTD.get(typePerson);
			//System.debug('getDocsByTypePerson, docsByTypePerson.getSObjectType().getDescribe(): ' + docsByTypePerson.getSObjectType().getDescribe());
			Schema.DescribeSObjectResult dsor = docsByTypePerson.getSObjectType().getDescribe();
			List<Object> listDocs = new List<Object>();
			for (Schema.SObjectField sof : dsor.fields.getMap().values()) {
				Map<String, Object> mapDoc = new Map<String, Object>();
				Schema.DescribeFieldResult dfr = sof.getDescribe();
				if (dfr.isCustom()) {
					//System.debug(docsByTypePerson.get(dfr.getName()) instanceof Boolean);
					// if ((Boolean)docsByTypePerson.get(dfr.getName())) {
					if ( docsByTypePerson.get(dfr.getName()) != null && ((Boolean) docsByTypePerson.get(dfr.getName())) ) {
						//System.debug('getDocsByTypePerson: ' + dfr.getName() + ', ' + docsByTypePerson.get(dfr.getName()));
						mapDoc.put('name', String.valueOf(dfr.getLabel()));
						mapDoc.put('apiName', String.valueOf(dfr.getName()));
						listDocs.add(mapDoc);
					}
				}
			}
			mapDocsByTypePerson.put(typePerson, listDocs);
		}
		return mapDocsByTypePerson;
		//System.debug('getDocsByTypePerson, mapDocsByTypePerson: ' + mapDocsByTypePerson);
	}
	
	/**
		* @author rsanchez@ctconsulting.com.mx
		* @date 26/03/2018
		* @description Metodo que obtiene el tipo de persona de la Entidad Legal.
		*
		* @param Id elId El Id de la Entidad Legal a buscar.
		*
		* @return SObject Objeto de tipo Entidad Legal con los campos especificados.
	*/
	@AuraEnabled
	public static String EC_getRelatedAccountInformation(Id elId) {
		EntidadLegal__c listRelatedAccount = [SELECT Id,RecordType.Name FROM EntidadLegal__c WHERE Id = :elId];
        Profile prof=[Select Id,Name from Profile where Id=:UserInfo.getProfileId()];
        if(prof.Name=='Afiliación'){
            return listRelatedAccount.RecordType.Name+' Afiliación';
        }else{
            return listRelatedAccount.RecordType.Name;
        }
	}
	
	@AuraEnabled
	public static Boolean EC_getForeignContact(Id elId){
		EntidadCuenta__c eC = [SELECT Id FROM EntidadCuenta__c where EntidadLegal__c =: elId];
		Boolean foreignFlag = false;

		if(eC != null){

			List<ContactoEntidad__c> listContactos = [SELECT Id,Contacto__c,Contacto__r.Extranjero__c FROM ContactoEntidad__c WHERE Entidad_Cuenta__c =: eC.Id];
			
			if(listContactos.size() > 0){

				for(ContactoEntidad__c cE : listContactos){

					if(!foreignFlag){

						if(cE.Contacto__r.Extranjero__c == true){

							foreignFlag = true;
							break;

						}

					}

				}

			}
		}

		return foreignFlag;

	}
}