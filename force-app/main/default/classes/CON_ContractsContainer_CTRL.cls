/**
* @author ibautista@ctconsulting.com.mx
* @author calvarez@ctconsulting.com.mx
* @author jarellano@ctconsulting.com.mx
* @date 20/12/2017
* @description Controlador principal de las aplicaciones "Pantalla de Funcionalidades" (anteriormente conocido como el
* "Contenedor de Contratos") y "ADV".
*
* Es usado en los siguientes recursos:
*
* - Componentes de Lightning:
* -> CON_ADVContainer
* -> CON_ContractsContainer_ADV
* -> CON_ContractsContainer_LC
* -> CON_DownloadUploadLayout_LC
* -> CON_ValidationChecklist_ADV
* -> CON_ValidationChecklist_LC
* -> LEAD_ValidaConversion
*
* - Componentes de Visualforce:
* -> CON_TC3PagoPorConsumo_LC
*
* Clase de Test: CON_ContractsContainer_TEST
* Hereda de: CON_OppDocChecklist_CTRL
*/
public without sharing class CON_ContractsContainer_CTRL extends CON_OppDocChecklist_CTRL {
	/**
	* @description
	*/
	public String managerName{get{
			return [Select Manager.Name FROM User WHERE Id =: UserInfo.getUserId()].Manager.Name;
		}set;}
    
    
    
    
    @AuraEnabled
    public static List<Map<String,String>> getMotivosDeRechazo(){
        List<Map<String,String>> resp=new List<Map<String,String>>();
        Schema.DescribeFieldResult fieldResult = Contrato2__c.RejectionReasons__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry plv : ple){
            resp.add(new Map<String,String>{'label'=>plv.getLabel(),'value'=>plv.getValue()});
        }
        return resp;
    }
	/**
	* @description Guarda cambios de contenedor contratos(Contrato, Secciones y Anexos).
	* @param strData Es un String en formato JSON
	* @example '{"qli": "0QL5B000000aXzTWAU", "contrato": {"Id": "IdContrato2__c", "Name": "Prueba Contrato"}}'
	* @return
	*/
	@AuraEnabled
	public static Map<String, Object> guardaContrato( String strData ) {
		System.debug('guardaContrato, strData: ' + strData);
		Map<String, Object> response = new Map<String, Object>();
		try {
			
			Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(strData);
			//System.debug('guardaContrato, data: ' + data);
			if ( data != null ) {
				
				Id qli = data.containsKey('qli') ? ( (Id) data.get('qli')) : null;
				if( qli != null ) {
					
					// Obtener la instancia de Contrato2__c, si es que hay otro usuario editando el mismo contrato
					List<Contrato2__c> listContrato = [SELECT Id,Name FROM Contrato2__c WHERE PartidaPresupuesto__c =: qli];
					Contrato2__c contrato = data.containsKey('contrato') ? ( (Contrato2__c) JSON.deserialize((String)JSON.serialize(data.get('contrato')), Contrato2__c.class) ) : new Contrato2__c();
					
					contrato.Id = listContrato != null && listContrato.size() > 0 ? listContrato[0].Id : contrato.Id;
					contrato.PartidaPresupuesto__c = qli;
					//contrato.Name=contrato.name.substring(0, 70);
					System.debug('Anydatatype_msg ajale '+ contrato.Name);
					if (!data.containsKey('finalizar')) {
						contrato.EtapaContrato__c = 'En Proceso';
					} else {
						contrato.EtapaContrato__c = 'Finalizado';
						contrato.CamposValidados__c = true;
					}
					
					List<QuoteLineItem> soluciones = [SELECT Id, Product2.Name, Etapa__c, Quote.AccountId, Quote.OpportunityId,Quote.Opportunity.OwnerId FROM QuoteLineItem WHERE Id =: qli];
					String idOwnerOpp='';
                    if(soluciones!=null&&soluciones.size()>0){
                        idOwnerOpp=soluciones[0].Quote.Opportunity.OwnerId;
                    }
                    
					List<Opportunity> listOpp = [SELECT Contacto__r.Name,Maquila__c,Maquilador__c FROM Opportunity WHERE Id = :soluciones[0].Quote.OpportunityId AND Contacto__r.Funcion__c = 'Representante Legal'];
					// List<Contact> contactos = [SELECT Id, Name FROM Contact WHERE AccountId =: soluciones[0].Quote.AccountId AND Puesto__c = 'Representante legal'];
					if( listOpp != null && listOpp.size() > 0 ) {
						contrato.RepresentanteLegal__c = listOpp[0].Contacto__r.Name;
						if(listOpp[0].Maquila__c==true){
							contrato.Maquila__c = listOpp[0].Maquila__c;
							contrato.Tipo_Maquila__c = listOpp[0].Maquilador__c;
						}
					}
					
					listContrato = new List<Contrato2__c>();
					listContrato.add(contrato);
					System.debug('guardaContrato, listContrato: ' + listContrato);
					// Guardar instancia de Contrato2__c
					Id idContrato = null;
					for (Database.upsertResult ur : Database.upsert(listContrato)) {
						Map<String, Object> mapContrato = new Map<String, Object>();
						mapContrato.put('Id', ur.getId());
						mapContrato.put('errors', ur.getErrors());
						mapContrato.put('isCreated', ur.isCreated());
						mapContrato.put('isSuccess', ur.isSuccess());
						response.put('Upsert_Contrato2__c', mapContrato);
						idContrato = ur.getId();
					}
					
					List<Anexo__c> listAnexo = idContrato == null ? new List<Anexo__c>() : [SELECT Id FROM Anexo__c WHERE IdContrato__c =: idContrato ];
                        /*if(listAnexo!=null&&listAnexo.size()>0){
                            delete listAnexo;
                            listAnexo =new List<Anexo__c>();
                        }*/
					Anexo__c anexo = data.containsKey('anexo') ? ( (Anexo__c) JSON.deserialize((String)JSON.serialize(data.get('anexo')), Anexo__c.class) ) : new Anexo__c();
					
					anexo.Id = listAnexo != null && listAnexo.size() > 0 ? listAnexo[0].Id : anexo.Id;
					anexo.IdContrato__c = idContrato;
					anexo.Solucion__c = qli;
					
					// Guardar instancia de Anexo__c
					listAnexo.clear();
					listAnexo.add(anexo);
					for (Database.upsertResult ur : Database.upsert(listAnexo)) {
						Map<String, Object> mapAnexo = new Map<String, Object>();
						mapAnexo.put('Id', ur.getId());
						mapAnexo.put('errors', ur.getErrors());
						mapAnexo.put('isCreated', ur.isCreated());
						mapAnexo.put('isSuccess', ur.isSuccess());
						response.put('Upsert_Anexo__c', mapAnexo);
					}
					// Oportunidad
					if (data.containsKey('oportunidad')) {
						Opportunity opp = (Opportunity)JSON.deserialize((String)JSON.serialize(data.get('oportunidad')), Opportunity.class);
						update opp;
					}
					// Contrato - Filial
					// Obteniendo mapa de registros de Contrato - Filial
					Map<String, List<ContratoFilial__c>> mapContratoFiliales = data.containsKey('contratoFilial') ? (Map<String, List<ContratoFilial__c>>)JSON.deserialize((String)JSON.serialize(data.get('contratoFilial')), Map<String, List<ContratoFilial__c>>.class) : new Map<String, List<ContratoFilial__c>>();
					System.debug('mapContratoFiliales: ' + mapContratoFiliales);
					// Insertando o actulizando registros de Contrato - Filial
					List<ContratoFilial__c> listNuevosContratosFiliales = mapContratoFiliales.containsKey('paraGuardar') ? mapContratoFiliales.get('paraGuardar') : new List<ContratoFilial__c>();
					if (listNuevosContratosFiliales.size() > 0) {
                        
                        for(ContratoFilial__c cf : listNuevosContratosFiliales){
                            cf.OwnerId=idOwnerOpp;
                        }                        
                        
						for (Database.upsertResult ur : Database.upsert(listNuevosContratosFiliales)) {
							response.put('Upsert_ContratoFilial__c', getMapUpsertResult(ur));
						}
					}
					// Eliminando registros de Contrato - Filial, si los hay
					List<ContratoFilial__c> listContratosFilialesParaEliminar = mapContratoFiliales.containsKey('paraEliminar') ? mapContratoFiliales.get('paraEliminar') : new List<ContratoFilial__c>();
					if (listContratosFilialesParaEliminar.size() > 0) {
						for (Database.DeleteResult dr : Database.delete(listContratosFilialesParaEliminar)) {
							response.put('Delete_ContratoFilial__c', getMapDeleteResult(dr));
						}
					}
					System.debug('guardaContrato, response: ' + response);
				} else {
					response.put('error', 'Id de QuoteLineItem {qli} es requerido');
				}
			} else {
				response.put('error', 'No se recibió información');
			}
		} catch(JSONException ex) {
			response.put('error', ex.getStackTraceString());
			response.put('JSONException', ex.getMessage());
			throw new CustomException(ex.getMessage() + ', ' + ex.getStackTraceString());
		} catch(NullPointerException ex) {
			response.put('error', ex.getStackTraceString());
			response.put('NullPointerException', ex.getMessage());
			throw new CustomException(ex.getMessage() + ', ' + ex.getStackTraceString());
		} catch(Exception ex) {
			response.put('error', ex.getStackTraceString());
			response.put('Exception', ex.getMessage());
			throw new CustomException(ex.getMessage() + ', ' + ex.getStackTraceString());
		}
		
		response.put('Limits', getLimits());
		return response;
	}
	/**
	* @description Realiza una consulta hacia la base de datos y retorna el resultado
	* @param query String de una consulta SOQL válida
	* @return Si la consulta se realiza exitosamente, retorna un sObjects[] con los registros consultados. Si el método
	* se invoca con un valor inválido para el argumento "query", retorna un Map con información relativa a la excepción
	* "System.NullPointerException". Si el método se invoca con un String de consulta SOQL inválido, retorna un Map con
	* información relativa a la excepción "System.QueryException"
	*/
	@AuraEnabled
	public static Object executeQuery(String query) {
		try {
			return Database.query(query);
		} catch(System.NullPointerException npe) {
			Map<String, Object> mapNpe = new Map<String, Object>();
			mapNpe.put('cause', npe.getCause());
			mapNpe.put('lineNumber', npe.getLineNumber());
			mapNpe.put('message', npe.getMessage());
			mapNpe.put('stackTraceString', npe.getStackTraceString());
			mapNpe.put('exceptionTypeName', npe.getTypeName());
			return mapNpe;
		} catch(System.QueryException qe) {
			Map<String, Object> mapQe = new Map<String, Object>();
			mapQe.put('cause', qe.getCause());
			mapQe.put('lineNumber', qe.getLineNumber());
			mapQe.put('message', qe.getMessage());
			mapQe.put('stackTraceString', qe.getStackTraceString());
			mapQe.put('exceptionTypeName', qe.getTypeName());
			return mapQe;
		}
	}
	/**
	* @description Obtiene los metadatos de los campos de varios sObjects y los retorna
	* @param objs Array de Strings con los nombres API de los sObjects
	* @return Retorna un Map donde Key es el nombre del sObject y Value es un Map de los campos de ese sObject donde Key
	* es el nombre del campo y Value es un Map de los metadatos de ese campo donde Key es el nombre del metadato y Value
	* es el valor de ese metadato
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
					field.put('label', String.valueOf(dfr.getLabel()));
					field.put('isCustom', String.valueOf(dfr.isCustom()));
					field.put('type', String.valueOf(dfr.getType()));
					field.put('editable', String.valueOf(dfr.isCreateable()));
					field.put('updateable', String.valueOf(dfr.isUpdateable()));
					
					if (dfr.isCreateable() && !dfr.isNillable() && !dfr.isDefaultedOnCreate()) {
						field.put('isRequired', String.valueOf(true));
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
							field.put('picklistEntries', values);
							field.put('restrictedPicklist', String.valueOf(dfr.restrictedpicklist));
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
	* @description Guarda archivo PDF de un Contrato relacionado a una Oportunidad
	* @param qliId Es el Id del QuoteLineItem
	* @param strDataBase64 Es un String en formato Base64
	*/
	@RemoteAction
	public static Map<String, Object> guardaPDFBase64( String qliId, String strDataBase64 ) {
		Map<String, Object> response = new Map<String, Object>();

		System.debug('Entro guardaPDFBase64');

		if(String.isNotBlank(qliId) && String.isNotBlank(strDataBase64)) {

			List<QuoteLineItem> soluciones = [SELECT Id, Product2.Name, Etapa__c,Quote.Name, Quote.IdPDFContrato__c, Quote.OpportunityId FROM QuoteLineItem WHERE Id =: qliId];
			
			if( soluciones != null && soluciones.size() > 0 ) {
				QuoteLineItem qli = soluciones.get(0);
				
				System.debug('guardaPDFBase64 qli:'+qli);

				List<Attachment> instances = new List<Attachment>();
				String nombre = 'Contrato ' + qli.Product2.Name + '.pdf';
				List<Attachment> documentos = [SELECT Id, Name FROM Attachment WHERE Name =: nombre  AND ParentId =: qli.Quote.OpportunityId];
				delete documentos;

				System.debug('guardaPDFBase64 documentos:'+documentos);

				Attachment contrato = new Attachment(ContentType = 'application/pdf', Name = nombre, ParentId = qli.Quote.OpportunityId);
				contrato.Body = EncodingUtil.base64Decode(strDataBase64);
				instances.add(contrato);

				for (Database.upsertResult ur : Database.upsert(instances)) {
					Map<String, Object> mapContrato = new Map<String, Object>();
					mapContrato.put('Id', ur.getId());
					mapContrato.put('errors', ur.getErrors());
					mapContrato.put('isCreated', ur.isCreated());
					mapContrato.put('isSuccess', ur.isSuccess());
					response.put('Upsert_Attachment', mapContrato);
				}
				//List<Attachment> listOppAttachments = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :oppId];
				List<QuoteDocument> listQuoDocs = [SELECT Id FROM QuoteDocument WHERE QuoteId = :qli.QuoteId AND Id  =: qli.Quote.IdPDFContrato__c ];
				QuoteDocument qd;

				if(listQuoDocs.size() > 0){
					delete listQuoDocs;
				}
								String quoteNameBK = qli.Quote.Name;
								Quote quote = new Quote(Id = qli.QuoteId, Name = 'Contrato');
				upsert quote;
		
				qd = new QuoteDocument();
				// System.debug('attach: ' + attach);
				qd.QuoteId = qli.QuoteId;
				qd.Document = contrato.Body;
				
				// System.debug('createQuoteDocument, qd: ' + qd);
				upsert qd;
				quote = new Quote(Id = qli.QuoteId, IdPDFContrato__c = qd.Id, Name = quoteNameBK);
				upsert quote;

			} else {
				System.debug('Solución con Id ' + qliId + ' no encontrada');
				response.put('error', 'Solución con Id ' + qliId + ' no encontrada');
			}
		} else {
			System.debug('Entro guardaPDFBase64 error qlid:'+qliId+' Base64:'+strDataBase64);
			response.put('error', 'Parámetros {qliId} y {strDataBase64} son requeridos');
		}
		response.put('Limits', getLimits());
		return response;
	}
	/**
	* @description Ejecuta un SOQL válido para salesforce
	* @param
	* @return
	*/
	@RemoteAction
	public static List<sObject> executeQueryRA(String query) {
        System.debug('QUERYYY:::'+query);
		return Database.query(query);
	}
	/**
	* @description
	* @param
	* @return
	*/
	@RemoteAction
	public static List<QuoteLineItem> getContratoTicketCarData(String quoteLineItemId){
		List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
		String query;
		// query = 'SELECT Quote.Opportunity.Name,Quote.OpportunityId,Quote.Owner.Name,Quote.AccountId,Quote.Account.RazonSocial__c,Quote.Account.Representante_Legal__c, Quote.Account.RFC__c, Quote.Account.BillingAddress, Quote.Account.Ciudad__c FROM QuoteLineItem WHERE Id = \'' + quoteLineItemId+ '\''; 
		query = 'SELECT Quote.Opportunity.Name,Quote.OpportunityId,Quote.Owner.Name,Quote.AccountId,Quote.Account.RazonSocial__c, Quote.Account.RFC__c, Quote.Account.BillingAddress, Quote.Account.Ciudad__c FROM QuoteLineItem WHERE Id = \'' + quoteLineItemId+ '\''; 
		quoteLineItemList = Database.query(query);
		return quoteLineItemList;
	}
	/**
	* @description
	* @param
	* @return
	*/
	@RemoteAction
	public static Contrato2__c getContrato(String quoteLineItemId){
		System.debug('GETCONTRATO');
		String strSql;
		List<Contrato2__c> listContrato = new List<Contrato2__c>();
		strSql = getStrCampos(Contrato2__c.SObjectType);
		strSql = 'SELECT ' + strSql + ',Cuenta__r.Giro__c,Cuenta__r.Telefono2__c,Cuenta__r.Subgiro__c,Cuenta__r.Phone,Cuenta__r.CodigoClienteAS400__c,PartidaPresupuesto__r.FormaPago__c,PartidaPresupuesto__r.Quote.Comision_por_Servicio__c,Contacto__r.Name,Contacto__r.Email, Entidad_Legal__r.RecordType.Name FROM Contrato2__c WHERE PartidaPresupuesto__c = \'' + quoteLineItemId + '\'';
		System.debug('SQLQuery: ' + strSql);
		listContrato = Database.query(strSql);
		if(listContrato.size() > 0){
			return listContrato[0];
		}
		else{
			Contrato2__c contrato;
			return contrato;
		}
	}
	/**
	* @description
	* @param
	* @return
	*/
	public static String getStrCampos(Schema.SObjectType targetObject){
		return String.join(getListCampos(targetObject), ', ');
	}
	/**
	* @description
	* @param
	* @return
	*/
	public static List<String> getListCampos(Schema.SObjectType targetObject){
		List<String> listCampos = new List<String>();
		Set<String> setCamposParaExcluir = new Set<String>{'CreatedById', 'CreatedDate', 'SystemModstamp', 'LastModifiedDate', 'LastModifiedById', 'LastReferencedDate', 'LastViewedDate', 'IsDeleted'};


		List<Schema.sObjectField> lSobjectFields = targetObject.getDescribe().fields.getMap().values();
		for(Schema.sObjectField sob : lSobjectFields){
			
			Schema.DescribeFieldResult f = sob.getDescribe();
			//NO agregar campos que no se necesitan
			String nombreCampo = f.getName();
			if(!setCamposParaExcluir.contains(nombreCampo)) listCampos.add(nombreCampo);
		}
		return listCampos;
	}
	/**
	* @description
	* @param
	* @return
	*/
	public static List<Database.UpsertResult> upsertSobjects( List<sObject> instances ) {
		return Database.upsert(instances);
	}
	/**
	* @description Actualiza informacion de Contrato para ADV
	* @param
	* @return
	*/
	@AuraEnabled
	public static Map<String, String> updateContratoADV( String jsonContrato, String jsonOportunidad ) {
		Map<String,String> response = new Map<String,String>();
		Contrato2__c contrato = new Contrato2__c();
		Opportunity opp = new Opportunity();
		try{
			contrato = (Contrato2__c)JSON.deserialize(jsonContrato,Contrato2__c.class);
			opp = (Opportunity)JSON.deserialize(jsonOportunidad,Opportunity.class);
			if(contrato.EtapaContrato__c == 'Autorizado'){
				
				opp.FechaFinADV__c = system.now();
				
			}
			update contrato;
			update opp;
			if(contrato.EtapaContrato__c == 'Rechazado para corrección'){
				Opportunity newOpp = [SELECT Id,  FechaInicioADV__c, FechaFinADV__c, ComentariosADV__c, Estatus__c, RejectionReasons__c, Comentarios_Ejecutivo__c,NumeroAltaCliente__c FROM Opportunity WHERE Id =:opp.Id];
				Integer rejections = [SELECT COUNT() FROM Rejection_history__c WHERE Opportunity__c = :newOpp.Id] + 1;
				Rejection_history__c rechazo = new Rejection_history__c(
				ADV_Comments__c = newOpp.ComentariosADV__c,
				Comercial_comments__c = newOpp.Comentarios_Ejecutivo__c,
				Opportunity_status__c	= newOpp.Estatus__c,
				Rejection_reason__c = newOpp.RejectionReasons__c,
				ADV_End_Date__c	= Date.newinstance(newOpp.FechaFinADV__c.year(), newOpp.FechaFinADV__c.month(), newOpp.FechaFinADV__c.day()),
				ADV_Start_Date__c = Date.newinstance(newOpp.FechaInicioADV__c.year(), newOpp.FechaInicioADV__c.month(), newOpp.FechaInicioADV__c.day()),
				Name = newOpp.NumeroAltaCliente__c + ': Rechazo- ' + String.valueOf(rejections),
				Assignment_folio__c = newOpp.NumeroAltaCliente__c,
				Opportunity__c	 = newOpp.Id
				);			
				insert rechazo;
			}

			if(contrato.EtapaContrato__c == 'Autorizado'){
				if(!string.isEmpty(contrato.CodigoAS400__c)&&contrato.id!=null){
				system.debug('hello '+contrato);
				insert new ContratoFilial__c(CodigoAS400__c=contrato.CodigoAS400__c,Name=contrato.CodigoAS400__c
					,Contrato_2__c=contrato.id,Entidad_Cuenta__c=contrato.Entidad_Cuenta__c,isPrime__c=true);
				}
			
			}
			
			response.put('Code','0');
			response.put('Response','Informacion Guardada con exito');
			return response;
		}
		catch(Exception e){
			response.put('Code','-1');
			response.put('Response','Error al guardar la informacion: '+ e);
			return response;
		}
	}



	@AuraEnabled
	public static Map<String, String> updateContratoADV2( String jsonContrato, String jsonOportunidad,String extras ) {
        
		Map<String,String> response = new Map<String,String>();
		Contrato2__c contrato = new Contrato2__c();
		Opportunity opp = new Opportunity();
		List<Sub> subs = new List<Sub>();
		List<ContratoFilial__c> filiales = new List<ContratoFilial__c>();

		Savepoint sp=Database.setSavepoint();
		try{
            List<String> lisErrors=new List<String>();
			contrato = (Contrato2__c)JSON.deserialize(jsonContrato,Contrato2__c.class);
			opp = (Opportunity)JSON.deserialize(jsonOportunidad,Opportunity.class);
			subs=(List<Sub>)JSON.deserialize(extras,List<Sub>.class);
				
            Opportunity opp2= [SELECT id,Contacto__c,AccountId,OwnerId from Opportunity where id=:opp.id LIMIT 1];
            QuoteLineItem qli=[Select Id,Product2.IDInterno__c from QuoteLineItem where Quote.OpportunityId=:opp2.Id and Quote.IsSyncing=true and Escalonamiento__c=null LIMIT 1];
            
			for(Sub extra:subs){
                System.debug('SUBB::'+extra.CodigoAS400);
				filiales.add(new ContratoFilial__c(CodigoAS400__c=extra.CodigoAS400,Name=extra.CodigoAS400
					,PlatformAdministrator__c=opp2.Contacto__c ,Contrato_2__c=contrato.id,Entidad_Cuenta__c=contrato.Entidad_Cuenta__c,OwnerId=opp2.OwnerId));
			}
			
            contrato.EtapaContrato__c = 'Finalizado';
            Integer ind=[Select Count() from Contrato2__c where Id!=:contrato.Id and CodigoAS400__c=:contrato.CodigoAS400__c];
            if(ind>0){
                Database.rollback(sp);
                response.put('Code','-1');                    
                response.put('Response','Error al guardar la informacion: El Codigo ingresado ya se encuentra en otro contrato('+contrato.CodigoAS400__c+')');
                return response;
            }
			update contrato;
			insert filiales;			

            ContratoFilial__c tem;
			if(!string.isEmpty(contrato.CodigoAS400__c)&&contrato.id!=null){
				system.debug('hello '+contrato);
				 tem= new ContratoFilial__c(OwnerId=opp2.OwnerId,CodigoAS400__c=contrato.CodigoAS400__c,Name=contrato.CodigoAS400__c
					,Contrato_2__c=contrato.id,Entidad_Cuenta__c=contrato.Entidad_Cuenta__c,isPrime__c=true,PlatformAdministrator__c=opp2.Contacto__c);
                insert tem;
			}

			contrato.EtapaContrato__c = 'Autorizado';
			opp.FechaFinADV__c = system.now();	
			update contrato;
            if(!string.isEmpty(contrato.CodigoAS400__c)&&contrato.CodigoAS400__c.split('-')[1]!='30'&&contrato.CodigoAS400__c.split('-')[1]!='31'){
                update opp;//DYAMPI
            }
			//Opportunity opp2= [SELECT id,AccountId,OwnerId,(Select Id from Funciones_de_Contactos_en_Oportunidad__r) from Opportunity where id=:opp.id LIMIT 1];
			Account thisAccount = [SELECT id,CodigoClienteAS400__c,CodigoClienteOPAM__c  from Account where Id=:opp2.AccountId LIMIT 1];
			String grupo=contrato.CodigoAS400__c;
			List<String> codigoGrupo= grupo.split('-');
            
            String codProd=qli.Product2.IDInterno__c!=null ? (qli.Product2.IDInterno__c.length()==1 ? '0'+qli.Product2.IDInterno__c : qli.Product2.IDInterno__c) : '';
            if(codProd.contains('-')){
                codProd=codProd.split('-')[0];
            }
            if(codigoGrupo.size()==4&&codProd!=codigoGrupo.get(1)){
                //Database.rollback(sp);
                //response.put('Code','-1');                    
                //response.put('Response','Error al guardar la informacion: El producto ingresado en el código AS400, no corresponde al producto de la Oportunidad');
                //return response;
                lisErrors.add('No puede generarse el alta de cliente con número de producto distinto al producto cotizado('+grupo+')');
            }
            
			if(String.isBlank(thisAccount.CodigoClienteAS400__c)&&codigoGrupo.size()==4){
                Integer numAcc=[Select count() from Account where CodigoClienteAS400__c=:codigoGrupo.get(2)];                                
                if(numAcc>0){
                    /*Database.rollback(sp);
                    response.put('Code','-1');                    
                    response.put('Response','Error al guardar la informacion: El Grupo Ingresado se encuentra en otra cuenta');
                    return response;*/
                    lisErrors.add('El grupo capturado ya se encuentra generado en otra Cuenta('+grupo+')');
                }else{                    
                    thisAccount.CodigoClienteAS400__c=codigoGrupo.get(2);
                    update thisAccount;
                }
			}else if((!String.isBlank(thisAccount.CodigoClienteAS400__c))&&codigoGrupo.size()==4&&thisAccount.CodigoClienteAS400__c!=codigoGrupo.get(2)){
                /*Database.rollback(sp);
                response.put('Code','-1');                    
                response.put('Response','Error al guardar la informacion: El Grupo Ingresado es diferente al grupo de la cuenta');
                return response;*/
                lisErrors.add('El grupo capturado es diferente al grupo de la cuenta('+grupo+')');
            }
			else if(codigoGrupo.size()==2){
				 thisAccount.CodigoClienteOPAM__c=grupo;
				 update thisAccount;
			}
            
            if(lisErrors!=null&&lisErrors.size()>0){
                Database.rollback(sp);
                response.put('Code','-1');                    
                response.put('Response','Error al guardar la informacion: '+String.join(lisErrors, ','));
                return response;
            }
			
			response.put('Code','0');
			response.put('Response','Informacion Guardada con exito');

		/*	if([SELECT Codigo_Producto_cotizacion__c  FROM Opportunity where id =:opp.id LIMIT 1].Codigo_Producto_cotizacion__c=='30'&& (!filiales.isEmpty())){
				for(ContratoFilial__c filial : filiales){
					generaXML(opp,contrato);
				}				
			}*/

			return response;
		}
		catch(Exception e){
            Database.rollback(sp);
			response.put('Code','-1');
			response.put('Response','Error al guardar la informacion: '+ e.getMessage()+', linea: '+e.getStackTraceString());
			return response;
		}
	}
    
    @AuraEnabled
    public static Map<String,String> generarClientesAs400(String idContrato,String idQli,String idOpp){
        Map<String,String> response=new Map<String,String>();
        CreateCustomerRequestWP cliente;
        try{
            Map<String,String> mapaCatalogos=new Map<String,String>();
            Map<String,WSCredentials__c> mapCredenciales=WSCredentials__c.getAll();
            for(GeneralCatalog__c gc : [Select Id,Name,Field__c,value__c,Key__c,RecordType.DeveloperName from GeneralCatalog__c where RecordType.DeveloperName='CustomerRegistration']){
                mapaCatalogos.put(gc.Name+'-'+gc.Field__c, gc.value__c);
            }
            String posVendedor;
            try{
                posVendedor=[Select Id,Name,Field__c,value__c from GeneralCatalog__c where Key__c='POS-AC'].value__c;
            }catch(Exception e){
                response.put('Code','2');                
                response.put('Response','Postvendedor no configurado');
                return response;
            }
            if(!(mapCredenciales.containsKey('TOK-AC')&&mapCredenciales.containsKey('AC'))){
                response.put('Code','2');                
                response.put('Response','No existen las credenciales para alta de clientes');
                return response;
            }
            
            Opportunity opp2= [SELECT id,Owner.NumeroTerritorio__c,Contacto__r.Name,AccountId,OwnerId,Contacto__c,Contacto__r.FirstName,Contacto__r.LastName,Contacto__r.Extension__c,Contacto__r.Email,Contacto__r.Phone,Contacto__r.ColMpoCPEdo__r.CodigoPostal__c,(Select Id,Role__c,ContactId__r.FirstName,ContactId__r.LastName,ContactId__r.Email,ContactId__r.Phone
                                                            , ContactId__r.Extension__c,ContactId__r.CodigoPostal__c from Funciones_de_Contactos_en_Oportunidad__r) from Opportunity where id=:idOpp];
            
            QuoteLineItem qli=[Select Id,(Select Id,Concepto__r.SinEdicion__c,PrecioLista__c ,Concepto__r.ClaveReferencia__c,Bonificacion__c,VigenciaDescuento__c,Concepto__r.Importe__c,Concepto__r.ReferenceKeyDiscount__c,FechaInicio__c,FechaFinal__c,PrecioLista2__c,PrecioFinal__c from Productos_Concepto__r) from QuoteLineItem where Id=:idQli];
            Set<String> idsDirecciones=new Set<String>();
            for(Contrato_Direccion__c cd: [SELECT Id, Name, ContratoID__c,DireccionID__r.CodigoPostalID__r.CodigoPostal__c, DireccionID__c FROM Contrato_Direccion__c where ContratoID__c=:idContrato]){
                idsDirecciones.add(cd.DireccionID__c);
            }
            
            List<CatalogoDirecciones__c> direcciones=[Select Id,Calle_Tt__c,CodigoPostal_Tt__c,CodigoPostalID__r.CodigoPostal__c ,Colonia_Tt__c,CodigoPostalID__r.Name,Name,NumeroExterior_Tt__c,NumeroInterior_Tt__c from CatalogoDirecciones__c where Id IN:idsDirecciones limit 1];
            
            List<ContratoFilial__c> listFilialesUpd=new List<ContratoFilial__c>();
            boolean error=false;
            String token='';
            System.debug('GETTOKEN');
            if(Test.isRunningTest()){
                token='lajiudbiubi';
            }else{
                token=AltaCliente_WS.getToken(mapCredenciales.get('TOK-AC').EndPoint__c,mapCredenciales.get('TOK-AC').ClientId__c,mapCredenciales.get('TOK-AC').ClientSecret__c,mapCredenciales.get('TOK-AC').GrantType__c,mapCredenciales.get('TOK-AC').Scope__c);
            }
            System.debug('TOK::'+token);
            if(token==''||token==null||(token!=null&&token.trim()=='')){
                response.put('Code','2');
                response.put('Response','Error al crear los clientes en AS400, No se Generó el TOKEN, Por favor Reintente');
                System.debug('Return 2');
                return response;
            }
            System.debug('>>');
            //String msjs='';
            
            
            List<ContratoFilial__c> listaFiliales=[Select Id,isPrime__c,Contrato_2__r.CondicionesPagoPlazo__c,Contrato_2__r.WayPay__c,Contrato_2__r.Facturacion_Cargos__c,Contrato_2__r.FiscalAddress__r.Name,Contrato_2__r.Frecuencia_de_Pedido__c,PlatformAdministrator__r.Name,Contrato_2__r.TipoPago__c,PlatformAdministrator__r.Phone,PlatformAdministrator__r.LastName,PlatformAdministrator__r.FirstName,PlatformAdministrator__c,Contrato_2__r.FiscalAddress__r.Colonia_Tt__c,Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c,Contrato_2__r.FiscalAddress__r.CodigoPostalID__r.CodigoPostal__c,Contrato_2__r.FiscalAddress__r.CodigoPostalID__r.Name,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Competidor__c,Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c,Contrato_2__r.VolumenEmision__c,Contrato_2__r.Tipo_de_Facturacion__c,Contrato_2__r.EmpresaPrincipal_PL__c,Contrato_2__r.Nombre_de_Personalizacion__c,Producto__r.ProductCode,CodigoAS400__c,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.LeadSource
                                                   ,Contrato_2__r.PrimeId__c,Contrato_2__r.Entidad_cuenta__r.NombreEL__c,Contrato_2__r.PrimeGroupName__c,Contrato_2__r.Modo_Transaccion__c,Contrato_2__r.MaxOfflineTransactionsQuantity__c,Contrato_2__r.MaxOfflineTransactionsAmount__c,Contrato_2__r.TransactionInterval__c,Contrato_2__r.BombaPropia__c,Contrato_2__r.ModoOffline__c,Contrato_2__r.Consolidador__c,Contrato_2__r.TipoCliente__c,Contrato_2__r.ComisionMinima__c,Contrato_2__r.Maneja_Conductores__c,Contrato_2__r.DenyPurchaseSunday__c,Contrato_2__r.DenyPurchaseBusinessDay__c,Contrato_2__r.DenyPurchaseSaturday__c,Contrato_2__r.Controla_Presencia_Vehiculo_NFC__c,Contrato_2__r.Facturacion_Comision__c,Contrato_2__r.Facturacion_Plasticos__c,Entidad_Cuenta__r.Cuenta__r.Sector__c,Entidad_Cuenta__r.Cuenta__r.Giro__c,Entidad_Cuenta__r.RFCEL__c,Contrato_2__r.FiscalAddress__r.Calle_Tt__c,Contrato_2__r.FiscalAddress__r.NumeroInterior_Tt__c,Contrato_2__r.FiscalAddress__r.NumeroExterior_Tt__c
                                                   ,Contrato_2__r.Contacto__r.FirstName,Contrato_2__r.Contacto__r.LastName,Contrato_2__r.Contacto__r.Extension__c,Contrato_2__r.Contacto__r.Email,Contrato_2__r.Contacto__r.Phone,Contrato_2__r.Contacto__r.ColMpoCPEdo__r.CodigoPostal__c
                                                   ,Contrato_2__r.Tipo_Maquila__c,Contrato_2__r.Cliente_Facturacion_Global__c,Contrato_2__r.Producto_Factura_Global__c,Contrato_2__r.Sucursal_Facturacion_Global__c,Contrato_2__r.MontoGarantia__c,PlatformAdministrator__r.email,PlatformAdministrator__r.Extension__c,PlatformAdministrator__r.ColMpoCPEdo__r.CodigoPostal__c,Contrato_2__r.ComoFactura__c,Contrato_2__r.Item_Contratacion__c,Contrato_2__r.FrecuenciaFacturacion__c,Contrato_2__r.CorreoRecibeFactura__c,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.NumeroOportunidad__c from ContratoFilial__c where Contrato_2__c=:idContrato and CustomerCreatedAS400__c=false];
            
            Integer filialesCount=[Select count() from ContratoFilial__c where Contrato_2__c=:idContrato];
            if(filialesCount==0){
                response.put('Code','2');                
                response.put('Response','No hay filiales asociadas al contrato!!');
                response.put('cliente',JSON.serialize(cliente));
                return response;
            }
            if(listaFiliales!=null&&listaFiliales.size()>0){
                List<erroresWP> listaErrores=new List<erroresWP>();
                for(ContratoFilial__c cf : listaFiliales){
                    if(new List<String>{'30-TC4','30','30-B','30-E','30-G','30-S','31'}.indexOf(cf.Producto__r.ProductCode)!=-1){
                        
                        cliente=new CreateCustomerRequestWP(mapaCatalogos,cf,opp2,qli.Productos_Concepto__r,direcciones,posVendedor);
                        AltaCliente_WS.responseWP resp=AltaCliente_WS.crearCliente(cliente, token,mapCredenciales.get('AC').EndPoint__c,mapCredenciales.get('AC').ClientId__c,mapCredenciales.get('AC').ClientSecret__c);
                        System.debug('RESPONSE::'+JSON.serialize(resp.response));
                        if(resp.status){
                            if(resp.response.meta.status.equalsIgnoreCase('succeeded')){
                                cf.CustomerCreatedAS400__c=true;
                                listFilialesUpd.add(cf);
                            }else{
                                erroresWP tem=new erroresWP();
                                tem.subCuenta=cf.CodigoAS400__c;
                                //msjs+='\n SubCuenta '+cf.CodigoAS400__c+': ';
                                List<String> errList=new List<String>();
                                for(CreateCustomerResponse.mensajesDTO msj : resp.response.meta.messages){
                                    errList.add(msj.text);
                                    //msjs+='\n '+msj.text;
                                }
                                tem.errores=errList;
                                listaErrores.add(tem);
                                //cf.CustomerCreatedAS400__c=false;
                                error=true;                    
                            }
                        }else{
                            erroresWP tem=new erroresWP();
                            tem.subCuenta=cf.CodigoAS400__c;
                            tem.errores=new List<String>{resp.msj};                                
                            //msjs+='\n SubCuenta '+cf.CodigoAS400__c+': '+resp.msj;
                            //cf.CustomerCreatedAS400__c=false;
                            listaErrores.add(tem);
                            error=true;
                        }
                        
                    }
                }
                if(listFilialesUpd!=null&&listFilialesUpd.size()>0){
                    update listFilialesUpd;
                }
                response.put('errores',JSON.serialize(listaErrores));
            }/*else{
                response.put('Code','2');                
                response.put('Response','No hay mas clientes pendientes para dar de alta!!');
                response.put('cliente',JSON.serialize(cliente));
                return response;
            }*/
            
            if(error){
                //Database.rollback(sp);
                response.put('Code','-1');
                response.put('cliente',JSON.serialize(cliente));
                response.put('Response','Error al crear los clientes en AS400');
                return response;
            }
            Contrato2__c con=new Contrato2__c(Id=idContrato);
            con.CustomersCreatedAS400__c=true;
            update con;
            
            response.put('Code','0');
            response.put('cliente',JSON.serialize(cliente));
            response.put('Response','Clientes dados de alta correctamente!!');
            return response;
        }catch(Exception e){
            response.put('Code','-2');
            response.put('cliente',JSON.serialize(cliente));
            response.put('Response','Error: '+e.getStackTraceString()+'--'+e.getMessage());
            System.debug('ERROR::::'+e.getStackTraceString()+'--'+e.getMessage());
            return response;
        }
    }
    
    public class erroresWP{
        @AuraEnabled public String subCuenta{get;set;}
        @AuraEnabled public List<String> errores{get;set;}
    }

/*	public static void generaXML(Opportunity opp,Contrato2__c contrato){

		GenerarXMLController genera = new GenerarXMLController(opp.id,contrato.id);
	}*/
	/**
	* @description Actualiza informacion de Oportunidad para ADV
	* @param
	* @return
	*/
	@AuraEnabled
	public static Map<String, String> updateOportunidadADV( String jsonOportunidad ) {
		Map<String,String> response = new Map<String,String>();
		Opportunity oportunidad = new Opportunity();
		try{
			oportunidad = (Opportunity)JSON.deserialize(jsonOportunidad,Opportunity.class);
			update oportunidad;
			response.put('Code','0');
			response.put('Response','Informacion Guardada con exito');
			return response;
		}
		catch(Exception e){
			response.put('Code','-1');
			response.put('Response','Error al guardar la informacion: '+ e);
			return response;
		}
	}
	/**
	* @description Obtiene información de la configuración personalizada "TiposDocumento", información de la Cuenta
	* relacionada con una Oportunidad y todos los Attachments de dicha Oportunidad y retorna el conjunto de toda esta
	* información. Este método hace uso de métodos definidos en la clase "CON_OppDocChecklist_CTRL"
	* @param oppId Id de la Oportunidad a través de la cual se obtendrá la información de la Cuenta y los Attachments
	* @return Retorna un Map con tres entradas: 1) los datos de la configuración personalizada, 2) la información de la
	* Cuenta relacionada y, 3) los Attachments de la Oportunidad
	*/
	@AuraEnabled
	public static Object validateOppAttachments(Id oppId) {
		Map<String, Object> mapOppDocs = new Map<String, Object>();
		Map<String, Object> mapDocsByTypePerson = CON_OppDocChecklist_CTRL.getDocsByTypePerson();
		mapOppDocs.put('docsByTypePerson', mapDocsByTypePerson);
		SObject oppAcc = CON_OppDocChecklist_CTRL.getRelatedAccountInformation(oppId);
		mapOppDocs.put('relatedAccount', oppAcc);
		
		List<Attachment> oppAttachments = [SELECT Id, Name FROM Attachment WHERE ParentId = :oppId];
		List<Opportunity> opp = [ SELECT Id, Entidad_Legal__c FROM opportunity WHERE Id =: oppId AND Entidad_Legal__c != null ];
		if( opp.size() > 0 ) {
			oppAttachments.addAll([SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = : opp[0].Entidad_Legal__c ]);
		}
		mapOppDocs.put('oppAttachments', oppAttachments);
		return mapOppDocs;

		

		// Map<String, Object> mapOppDocs = new Map<String, Object>();
		// Map<String, Object> mapDocsByTypePerson = CON_OppDocChecklist_CTRL.getDocsByTypePerson();
		// SObject oppAcc = CON_OppDocChecklist_CTRL.getRelatedAccountInformation(oppId);

		// mapOppDocs.put('docsByTypePerson', mapDocsByTypePerson);
		// mapOppDocs.put('relatedAccount', oppAcc);
		
		// List<ContentDocumentLink> oppAttachments = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: oppId];
		// List<Opportunity> opp = [ SELECT Id, Entidad_Legal__c FROM opportunity WHERE Id =: oppId AND Entidad_Legal__c != null ];

		// if( opp.size() > 0 ) {
		// 	oppAttachments.addAll([SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = : opp[0].Entidad_Legal__c ]);
		// }
		// mapOppDocs.put('oppAttachments', oppAttachments);
		// return mapOppDocs;
	}
	/**
	* @description Crea una nueva instancia de Attachment, la inserta o actualiza dependiendo del valor del argumento
	* "attachId", y retorna el resultado de cualquiera de esas acciones
	* @param attachId Id del Attachment a actualizar o insertar. Su valor puede ser un Id válido (para actualizar) o
	* no tener alguno (para insertar)
	* @param parentId Id del sObject al cual se asociará el Attachment
	* @param attachName Nombre del Attachment
	* @param attachBody Contenido del Attachment
	* @param docType Extensión del archivo
	* @return Si el Attachment es insertado o actualizado exitosamente, retorna un Map con información relativa a la
	* acción "Database.UpsertResult". Si el método es invocado con algún valor inválido para cualesquier argumento
	* u ocurre algún problema durante el proceso de actualización/insercción, retorna un Map con información relativa
	* a la excepción "System.Exception"
	*/
	@AuraEnabled
	public static Object saveLayout(String attachId, Id parentId, String attachName, String attachBody, String docType) {
		try {
			Blob b = EncodingUtil.base64Decode(attachBody);
			Attachment attach = new Attachment(Id = attachId, ParentId = parentId, Name = attachName + docType, Body = b);
			return getMapUpsertResult(Database.upsert(attach));
		} catch(System.Exception e) {
			return getMapException(e);
		}
	}
	@AuraEnabled
	public static Object saveLayoutAttachment(Id attachmentId, Id parentId, String type, String encodedString, String name) {
		Map<String, Object> mapResults = new Map<String, Object>();
		try {
			Attachment attach;
			if (attachmentId != null) {
				attach = [SELECT Id, Body FROM Attachment WHERE Id = :attachmentId];
				attach.Body = EncodingUtil.base64Decode(EncodingUtil.base64Encode(attach.Body) + encodedString);
			} else {
				attach = new Attachment(ParentId = ParentId, Name = name + type, ContentType = type, Body = EncodingUtil.base64Decode(encodedString));
			}
			return getMapUpsertResult(Database.upsert(attach));
		} catch (Exception e) {
			return getMapException(e);
		}
	}
	/**
	* @description Elimina un Attachment y retorna el resultado
	* @param attachId Id del Attachment a eliminar
	* @return Si el Attachment es eliminado correctamente, retorna un Map con información relativa a la acción
	* "Database.DeleteResult". Si el método es invocado con un valor inválido para el argumento "attachId" u ocurre
	* algún problema durante el proceso de eliminación, retorna un Map con información relativa a la excepción
	* "System.Exception"
	*/
	@AuraEnabled
	public static Object deleteLayoutFAC(Id attachId) {
		try {
			Attachment attach = new Attachment(Id = attachId);
			return getMapDeleteResult(Database.delete(attach));
		} catch(System.Exception e) {
			return getMapException(e);
		}
	}
	/**
	* @description Obtiene y retorna una lista de Entidades Legales relacionadas con una determinada Cuenta
	* @param accId El Id de la Cuenta
	* @return Si la consulta se realiza exitosamente, se retorna una lista de Entidades Legales, de lo contrario, se
	* retornar un Map con información relativa a la Excepción "System.Exception"
	*/
	@AuraEnabled
	public static Object getLegalEntitiesThroughAcc(Id accId) {
		try {
			if (accId.getSobjectType() == Schema.Account.SObjectType) { 
				List<EntidadCuenta__c> listEc = [SELECT Id, EntidadLegal__c, EntidadLegal__r.Name, EntidadLegal__r.RecordType.Name, EntidadLegal__r.RFC__c, EntidadLegal__r.RazonSocial__c, EntidadLegal__r.Estatus__c, (SELECT Contacto__c, Contacto__r.Name, Contacto__r.Funcion__c, Entidad_Cuenta__c FROM Contactos_Entidad1__r WHERE Contacto__r.Funcion__c = 'Representante Legal' ORDER BY CreatedDate) FROM EntidadCuenta__c WHERE Cuenta__c = :accId AND EntidadLegal__r.Estatus__c = 'Completa'];
				return listEc;
			} else {
				throw new CustomException('El argumento "accId" debe ser un Id de una instancia de Cuenta');
			}
		} catch(System.Exception e) {
			return getMapException(e);
		}
	}
	/**
	* @description Obtiene y retorna un determinado registro de Contrato con campos asociados a Estructuras de Cuentas
	* @param contractId El Id del Contrato
	* @return Si la consulta se realiza exitosamente, se retorna un registro de Contrato, de lo contrario, se
	* retornar un Map con información relativa a la Excepción "System.Exception"
	*/
	@AuraEnabled
	public static Object getAccountsStructureFromContract(Id contractId) {
		try {
            System.debug('CONTRATOC::'+contractId);
			Contrato2__c cont = [SELECT Id, Entidad_Legal__c, Entidad_Cuenta__c, Contacto__c FROM Contrato2__c WHERE Id = :contractId LIMIT 1];
			return cont;
		} catch(System.Exception e) {
			return getMapException(e);
		}
	}
	/**
	* @description
	* @param
	* @return
	*/
	@AuraEnabled
	public static Object getContractSubsidiaries(Id contractId) {
		try {
			if (contractId.getSobjectType() == Schema.Contrato2__c.SObjectType) {
				return [SELECT Id, Entidad_Cuenta__c, Entidad_Cuenta__r.EntidadLegal__c, Entidad_Cuenta__r.EntidadLegal__r.Name FROM ContratoFilial__c WHERE Contrato_2__c = :contractId];
			} else {
				throw new CustomException('El argumento "contractId" debe ser un Id de una instancia de Contrato');
			}
		} catch(System.Exception e) {
			return getMapException(e);
		}
	}
	/**
	* @description Obtiene y retorna información relativa a la acción "Database.UpsertResult"
	* @param ur Instancia de "Database.UpsertResult"
	* @return Retorna un Map
	*/
	private static Object getMapUpsertResult(Database.UpsertResult ur) {
		Map<String, Object> mapUr = new Map<String, Object>();
		mapUr.put('errors', ur.getErrors());
		mapUr.put('id', ur.getId());
		mapUr.put('isCreated', ur.isCreated());
		mapUr.put('isSuccess', ur.isSuccess());
		return mapUr;
	}
	/**
	* @description Obtiene y retorna información relativa a la acción "Database.DeleteResult"
	* @param dr Instancia de "Database.DeleteResult"
	* @return Retorna un Map
	*/
	private static Object getMapDeleteResult(Database.DeleteResult dr) {
		Map<String, Object> mapDr = new Map<String, Object>();
		mapDr.put('errors', dr.getErrors());
		mapDr.put('id', dr.getId());
		mapDr.put('isSuccess', dr.isSuccess());
		return mapDr;
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
	* @description Obtener datos de límites de gobierno
	* @param
	* @return
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
		* @author rsanchez@ctconsulting.com.mx
		* @date 26/03/2018
		* @description Metodo que obtiene los tipos de documentos dentro de una configuración personalizada.
		*
		* @return Map<String, Object> Un mapa de los Tipos de documentos de la configuración personalizada.
	*/
	/**
		* @author rsanchez@ctconsulting.com.mx
		* @date 26/03/2018
		* @description Metodo que guarda los codigos AS400 en los contratos filiales.
		*
		* @return String Respuesta de exito o error.
	*/
    @AuraEnabled
    public static String saveS400Filiales(String jsonFiliales){
        String respuesta = '';
        try{
            //System.debug('jsonFiliales:'+jsonFiliales);            
            List<ContratoFilial__c> cFilial = (List<ContratoFilial__c>)JSON.deserialize(jsonFiliales,List<ContratoFilial__c>.class);
            System.debug('Filiales:'+cFilial);
            
            for(ContratoFilial__c cf : cFilial){
                cf.Name=cf.CodigoAS400__c;
            }
            upsert cFilial;
            List<ContratoFilial__c> cFiliales=[SELECT name,Contrato_2__c,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.AccountId,Entidad_Cuenta__r.Cuenta__c,CodigoAS400__c,Contrato_2__r.PartidaPresupuesto__r.Product2.IDInterno__c,Entidad_Cuenta__r.Cuenta__r.CodigoClienteAS400__c FROM ContratoFilial__c where id=:cFilial and  isPrime__c=false];
            List<String> lisErr=new List<String>();
            
            Set<String> setAcc=new Set<String>();
            Set<String> setAdv=new Set<String>();
            for(ContratoFilial__c cf : cFiliales){
                if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.AccountId!=null){
                    setAcc.add(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.AccountId);
                }
                if(cf.Contrato_2__c!=null){
                    setAdv.add(cf.Contrato_2__c);
                }
            }
            for(Account acc:[Select Id,Name,Sector__c from Account where Id IN :setAcc]){
                if(acc.Sector__c==null){
                    lisErr.add('La cuenta '+acc.Name+' no contiene sector');
                }
            }
            for(Contrato2__c adv:[Select Id,FiscalAddress__c,PartidaPresupuesto__r.Product2.IDInterno__c from Contrato2__c where Id IN :setAdv and PartidaPresupuesto__r.Product2.IDInterno__c IN ('30','31')]){
                if(adv.FiscalAddress__c	==null){
                    lisErr.add('No se ha seleccionado una dirección en el contrato');
                }
            }
            
            /*Map<String,String> setAcc=new Map<String,String>();
            for(ContratoFilial__c cf : cFiliales){
                if(cf.Entidad_Cuenta__r.Cuenta__c!=null&&cf.CodigoAS400__c!=null){
                    setAcc.put(cf.Entidad_Cuenta__r.Cuenta__c,cf.CodigoAS400__c.split('-')[2]);
                }
            }*/            
            
            
            for(ContratoFilial__c cf : cFiliales){                
                String codProd=cf.Contrato_2__r.PartidaPresupuesto__r.Product2.IDInterno__c!=null ? (cf.Contrato_2__r.PartidaPresupuesto__r.Product2.IDInterno__c.length()==1 ? '0'+cf.Contrato_2__r.PartidaPresupuesto__r.Product2.IDInterno__c : cf.Contrato_2__r.PartidaPresupuesto__r.Product2.IDInterno__c) : '';
                if(codProd.contains('-')){
                    codProd=codProd.split('-')[0];
                }
                if(cf.CodigoAS400__c!=null&&cf.CodigoAS400__c.split('-')[2]!=cf.Entidad_Cuenta__r.Cuenta__r.CodigoClienteAS400__c&&cf.Entidad_Cuenta__r.Cuenta__r.CodigoClienteAS400__c!=null&&cf.Entidad_Cuenta__r.Cuenta__r.CodigoClienteAS400__c!=''){
                    lisErr.add('El grupo capturado no corresponde a la cuenta ('+cf.CodigoAS400__c+')');
                }
                if(cf.CodigoAS400__c!=null&&cf.CodigoAS400__c.split('-')[1]!=codProd){
                    lisErr.add('No puede generarse el alta de cliente con número de producto distinto al producto cotizado('+cf.CodigoAS400__c+')');
                }
            }
            if(lisErr.size()==0){
                respuesta = 'Exito';
            }else{
                respuesta=String.join(lisErr, ',');
            }
            /*for(ContratoFilial__c filial:cFiliales){
if(filial.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c=='30'){
GenerarXMLController xml = new GenerarXMLController( filial.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId ,filial.Contrato_2__c,filial );
} 	
}*/
        }	
        catch(Exception e){
            respuesta = 'Exception Cause saveS400Filiales status: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage();	
			
		}

		return respuesta;

	}
	
	/*DVM INICIO, 2 Julio. Para atender el requerimiento de mostrar todos los contactos con función AP en la pantalla de ADV*/
	@AuraEnabled
	public static List<Object> getContactosAP(String idRegistro, String nombreObjeto){
			List< Object > contactosAp = new List< Object >();
			if(!String.isBlank(idRegistro) && !String.isBlank(nombreObjeto)){
					String query = 'SELECT Id, Name, Puesto__c, Funcion__c, Phone, Telefono2__c, Email FROM Contact WHERE AccountID IN (SELECT AccountId FROM ' +nombreObjeto+ ' WHERE Id = \'' + idRegistro + '\')';
					System.debug(query);
					contactosAp = Database.query(query);
			}
			return contactosAp;
	}
	/*DVM FIN, 2 Julio*/
	
	/**
	* @author calvarez@ctconsulting.com.mx
	* @date 20/12/2017
	* @description
	*/
	public class CustomException extends Exception {}

	public class Sub {
			public String Name;
			public String CodigoAS400;
	}

	@AuraEnabled
		public static void generaXMLExtras( Id opportunityId, Id contratoId, List<ContratoFilial__c> filiales, String extras  ){
			Integer contador=0;
			String nombre;
			List<String> xmlAEnviar= new List<String>();
			List<Sub> subs = new List<Sub>();
			subs=(List<Sub>)JSON.deserialize(extras,List<Sub>.class); 
				Opportunity opp = new Opportunity();
				Contrato2__c contrato = (Contrato2__c) Database.query('SELECT ' + String.join( new List<String>( SObjectType.Contrato2__c.Fields.getMap().keySet() ), ', ') + ', Entidad_Cuenta__r.Name, Entidad_Cuenta__r.Cuenta__r.Giro__c, Entidad_Cuenta__r.Cuenta__r.Sector__c, Entidad_Legal__r.RazonSocial__c, Entidad_Legal__r.Name, Entidad_Legal__r.Direccion__c, Entidad_Legal__r.Calle__c, Entidad_Legal__r.NumeroExterior__c, Entidad_Legal__r.NumeroInterior__c, Entidad_Legal__r.CodigoPostal__c, Entidad_Legal__r.Colonia__c, Entidad_Legal__r.Ciudad__c, Entidad_Legal__r.Estado__c, PartidaPresupuesto__r.Product2.ProductCode, PartidaPresupuesto__r.Product2.Familia__c, PartidaPresupuesto__r.ComentariosCotizacion__c, PartidaPresupuesto__r.Quote.QuoteNumber, PartidaPresupuesto__r.FormaPago__c, Contacto__r.Phone, Contacto__r.Email, Contacto__r.Extension__c FROM Contrato2__c WHERE id =: contratoId');
				for( Opportunity oppAux : [SELECT Id,EnvioXMLTC30__c, Name, NumeroOportunidad__c, AccountId, ComisionEmision__c, Competidor__c, OwnerId, Owner.Name, Owner.Segmento__c, Owner.NumeroTerritorio__c, Contacto__r.FirstName, Contacto__r.LastName, Contacto__r.Puesto__c, Contacto__r.HorarioOficina__c, Contacto__r.Phone, Contacto__r.Email, Contacto__r.Extension__c, Contacto__r.TipoContacto__c, Contacto__r.Calle__c, Contacto__r.NumeroInterior__c, Contacto__r.NumeroExterior__c, Contacto__r.Colonia__c, Contacto__r.Ciudad__c, Contacto__r.Estado__c, Contacto__r.DelegacionMunicipio__c FROM Opportunity WHERE Id =: opportunityId] ) {
						opp = oppAux;
						break;
				}
			 nombre=opp.NumeroOportunidad__c;
			 xmlAEnviar.add( GenerarXMLController.generaDocumentoXMLExtras( opp, contrato ,nombre));
			 System.debug('Anydatatype_msg acaca '+  extras);
			 for(Sub filial:subs){
					 contador=contador+1;
					 nombre=opp.NumeroOportunidad__c+'-'+contador;
						xmlAEnviar.add( GenerarXMLController.generaDocumentoXMLExtras( opp, contrato ,nombre));
				}
			 
				for(ContratoFilial__c filial:filiales){
					contador=contador+1;
					 nombre=opp.NumeroOportunidad__c+'-'+contador;
						contrato.Entidad_Cuenta__r.Name=filial.Entidad_Cuenta__r.EntidadLegal__r.Name;
						contrato.Entidad_Legal__r.RazonSocial__c=filial.Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c;
						contrato.Entidad_Legal__r.Name=filial.Entidad_Cuenta__r.EntidadLegal__r.Name; 
						contrato.Entidad_Legal__r.Calle__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Calle__c;
						contrato.Entidad_Legal__r.NumeroExterior__c=filial.Entidad_Cuenta__r.EntidadLegal__r.NumeroExterior__c; 
						contrato.Entidad_Legal__r.NumeroInterior__c=filial.Entidad_Cuenta__r.EntidadLegal__r.NumeroInterior__c;
						contrato.Entidad_Legal__r.CodigoPostal__c=filial.Entidad_Cuenta__r.EntidadLegal__r.CodigoPostal__c; 
						contrato.Entidad_Legal__r.Colonia__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Colonia__c;
						contrato.Entidad_Legal__r.Ciudad__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Ciudad__c;
						contrato.Entidad_Legal__r.Estado__c=filial.Entidad_Cuenta__r.EntidadLegal__r.Estado__c;
						contrato.CodigoAS400__c= filial.CodigoAS400__c;
						xmlAEnviar.add( GenerarXMLController.generaDocumentoXMLExtras( opp, contrato,nombre ));
				}
				GenerarXMLController.enviarMail2( opp, contrato, xmlAEnviar ,true );
				opp.EnvioXMLTC30__c=true;
				update opp;
		}
		@AuraEnabled
	public static Boolean getEntidadCuenta( id AccountIs ) {
		List<EntidadCuenta__c> lista=[SELECT ID FROM EntidadCuenta__c WHERE CUENTA__C=:AccountIs and EntidadLegal__r.Estatus__c='Completa'];
		if(lista.isEmpty()){return true;}
		return false;
	}

	@AuraEnabled
	public static responseWP getDireccionesFiscales(String idCuenta,String idOpp){
		System.debug('INICIO GETDIF');
		responseWP res=new responseWP();
		try{
			res.lisDir=[Select Id,Name,NumeroInterior_Tt__c,Calle_Tt__c,NumeroExterior_Tt__c,Colonia_Tt__c,DelegacionMunicipio_Tt__c,Estado_Tt__c,CodigoPostal_Tt__c  from CatalogoDirecciones__c where EntidadLegal__r.Cuenta__c=:idCuenta or CuentaID__c=:idCuenta];
			res.valor=[Select Id,DireccionFiscal__c from Contrato2__c where PartidaPresupuesto__r.Quote.Opportunity.Id=:idOpp and PartidaPresupuesto__r.Quote.IsSyncing=true limit 1].DireccionFiscal__c!=null ? [Select Id,DireccionFiscal__c from Contrato2__c where PartidaPresupuesto__r.Quote.Opportunity.Id=:idOpp and PartidaPresupuesto__r.Quote.IsSyncing=true limit 1].DireccionFiscal__c : '';
			return res;
		}catch(Exception e){
			System.debug('Error: '+e.getMessage()+', Linea: '+e.getLineNumber());
			return null;
		}
	}
	public class responseWP{
		@AuraEnabled public String valor{get;set;}
		@AuraEnabled public List<CatalogoDirecciones__c> lisDir{get;set;}
	}
}