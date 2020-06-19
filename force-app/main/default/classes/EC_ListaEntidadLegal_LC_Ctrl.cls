/**
	* @author calvarez@ctconsulting.com.mx
	* @date 2018
	* @description Controlador para asociasión de Contacto a Entidad cuenta.
	* @group EstructuraCuentas
*/

public without sharing class EC_ListaEntidadLegal_LC_Ctrl {

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 22/12/2017
		* @description Ejecuta un SOQL válido para salesforce.
		* @group EstructuraCuentas
	*/
	@AuraEnabled
	public static List<sObject> executeQuery( String query ) {
		return Database.query(query);
	}
	@AuraEnabled
    public static List<CatalogoDirecciones__c> getDireccionesCuenta(String idAcc){
        return [Select Id,Name from CatalogoDirecciones__c where CuentaID__c=:idAcc];
    }
	/**
		* @author ibautista@ctconsulting.com.mx
		* @date 20/12/2017
		* @description Obtiene metadatos de uno ó varios objetos definidos en salesforce.
		* @return Objeto con metadatos de los APIname de los objetos enviados.
	*/
	@AuraEnabled
	public static Map<String, Object> describeSObjects( String[] objs ) {
		return LightningService_CTRL.describeSObjects( objs );
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param accountId Id de cuenta(Account).
		* @description Obtiene instancias EntidadLegal__c asociadas a la cuenta actual.
		* @return Objeto con los resultados obtenidos.
	*/
	@AuraEnabled
	public static Map<String, Object> getEntidadByAccount( Id accountId ) {
		Map<String, Object> response = new Map<String, Object>();
		try {
			System.debug('getEntidadByAccount ' );
			if ( String.isNotBlank( accountId ) ) {
				if( accountId.getSobjectType() == Schema.Account.SObjectType ) {
					response.put('records', [SELECT Id, Cuenta__c, EntidadLegal__r.Estatus__c, EntidadLegal__r.Name, EntidadLegal__r.RazonSocial__c,EntidadLegal__r.Address__c, EntidadLegal__r.RecordType.Name FROM EntidadCuenta__c WHERE Cuenta__c =: accountId ORDER BY CreatedDate DESC ]);
					//for(ContactoEntidad__c con :[SELECT ID,ContactoCuenta__c,Contacto__c,Cuenta__c,Entidad_Cuenta__c,EntidadLegal__c FROM ContactoEntidad__c WHERE  Entidad_Cuenta__c=:( [SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: accountId]) ]){
					//	System.debug('Anydatatype_msg '+ con);
					//	actualizaEstatusEntidad( con);
					//}
					
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
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param query expresión a buscar en campo Name de EntidadLegal__c
		* @param accountId Id de cuenta a la que va asociarse una entidad
		* @description Obtiene instancias EntidadLegal__c filtradas por Name.
		* @return Objeto con los resultados encontrados.
	*/
	@AuraEnabled
	public static Map<String, Object> getEntidadByName( String query, Id accountId ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( query ) ) {
			String str = '%' + query + '%';
			response.put('records', [SELECT Id, Name, RecordType.Name FROM EntidadLegal__c WHERE Name LIKE :str]);
		} else {
			response.put('error', 'Parameter @query is required');
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param rfc Name de la entidad legal.
		* @description Busca registros de Name en la EntidadLegal__c.
		* @return Objeto con los resultados encontrados.
	*/
	@AuraEnabled
	public static Map<String, Object> getEntidadByRFC( String rfc ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( rfc ) ) {
			Set<Id> setIdsEntidad = new Set<Id>();
			response.put('records', [SELECT Id, Name, RazonSocial__c, Calle__c, NumeroExterior__c, Colonia__c, DelegacionMunicipioFiscal__c, CodigoPostal__c, Ciudad__c, Estado__c, RecordType.Name, Cuenta__r.Name, Cuenta__r.Owner.Name, Cuenta__r.Owner.Email, (SELECT Id, Name FROM Entidades_Cuenta__r) FROM EntidadLegal__c WHERE Name =: rfc]);
		} else {
			response.put('error', 'Parameter @rfc is required');
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 12/04/2017
		* @param entidadLegal Instancia de EntidadLegal__c a insertar ó actualizar
		* @description Crea y actualiza un registro de EntidadLegal__c
		* @return Objeto con los resultados obtenidos.
	*/
	@AuraEnabled
	public static Map<String, Object> guardaEntidadLegal( EntidadLegal__c entidadLegal ) {

		System.debug('guardaEntidadLegal__c: ' + entidadLegal);
		Map<String, Object> response = new Map<String, Object>();
		if(String.isEmpty(entidadLegal.Estatus__c)){
			entidadLegal.Estatus__c='Incompleta';
		}
		
		/*for( Account ec: [SELECT Id,Sector__c,Segmento2__c FROM Account WHERE Id=:entidadLegal.Cuenta__c ] ) {
			System.debug('***********');
			if(ec.Sector__c=='Público'||ec.Segmento2__c=='Key'){
				entidadLegal.Estatus__c='Completa';
			}	
		}*/
		System.debug('2 guardaEntidadLegal__c: ' + entidadLegal);

		if ( entidadLegal != null  ) {
			
			List<String> errors = new List<String>();
			//Set<String> fieldsToSave = new Set<String>{'RecordTypeId','Estatus__c', 'Name', 'RazonSocial__c', 'Calle__c', 'NumeroExterior__c', 'Colonia__c', 'DelegacionMunicipioFiscal__c', 'CodigoPostal__c', 'Ciudad__c', 'Estado__c'};
			Set<String> fieldsToSave = new Set<String>{'RecordTypeId','Estatus__c', 'Name', 'RazonSocial__c','Address__c', 'CountryOrigin__c'};
			Id recordTypeFisica = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();
			Id recordTypeMoral = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Moral').getRecordTypeId();
			
			if( entidadLegal.Id != null ) {
				for( EntidadLegal__c el : [ SELECT Id, (SELECT Id, Name FROM Administraci_n_de_Ventas__r) FROM EntidadLegal__c WHERE Id =: entidadLegal.Id ] ) {
					response.put('' + el.Id, el);
					if( el.Administraci_n_de_Ventas__r != null && el.Administraci_n_de_Ventas__r.size() > 0 ) {
						errors.add('No es editable, está asociada con Contrato.');
					}
				}
			}

			// errors.add('No es editable, está asociada con Contrato.');

			for( String field : fieldsToSave ) {
				if( entidadLegal.get( field) == null || String.isBlank( String.valueOf(entidadLegal.get( field))) ) {
					errors.add( field );
				}
			}

			if( errors.size() <= 0 ) {
				System.debug('Anydatatype_msg '+entidadLegal);
				Database.upsertResult ur = Database.upsert(entidadLegal);
				Map<String, Object> mapContrato = new Map<String, Object>();
				mapContrato.put('Id', ur.getId());
				mapContrato.put('error', ur.getErrors());
				mapContrato.put('isCreated', ur.isCreated());
				mapContrato.put('isSuccess', ur.isSuccess());
				response.put('Upsert_EntidadLegal__c', mapContrato);
			} else {
				response.put('error', errors);
			}
			
		
		} else {
			response.put('error', 'Parameter @entidadLegal is required');
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param entidadCuenta Instancia de EntidadCuenta__c a insertar ó actualizar
		* @description Crea y actualiza un registro de EntidadCuenta__c
		* @return Objeto con los resultados obtenidos.
	*/
	@AuraEnabled
	public static Map<String, Object> guardaEntidadCuenta( EntidadCuenta__c entidadCuenta ) {
		Map<String, Object> response = new Map<String, Object>();

		if ( entidadCuenta != null && entidadCuenta.Cuenta__c != null && entidadCuenta.EntidadLegal__c != null ) {
			Database.upsertResult ur = Database.upsert(entidadCuenta);
			Map<String, Object> mapContrato = new Map<String, Object>();
			mapContrato.put('Id', ur.getId());
			mapContrato.put('error', ur.getErrors());
			mapContrato.put('isCreated', ur.isCreated());
			mapContrato.put('isSuccess', ur.isSuccess());
			response.put('Upsert_EntidadCuenta__c', mapContrato);
		
		} else {
			response.put('error', 'Parameter @entidadCuenta with properties {Cuenta__c and EntidadLegal__c} is required');
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param entidadCuenta Instancia de EntidadCuenta__c a insertar ó actualizar
		* @description Crea y actualiza un registro de EntidadCuenta__c
		* @return Objeto con los resultados obtenidos.
	*/
	@AuraEnabled
	public static Map<String, Object> eliminaEntidadCuenta( Id idEntidadCuenta ) {
		Map<String, Object> response = new Map<String, Object>();

		if ( idEntidadCuenta != null && idEntidadCuenta.getSobjectType() == Schema.EntidadCuenta__c.SObjectType ) {
			Database.DeleteResult ur = Database.delete(idEntidadCuenta);
			Map<String, Object> mapContrato = new Map<String, Object>();
			mapContrato.put('Id', ur.getId());
			mapContrato.put('error', ur.getErrors());
			mapContrato.put('isSuccess', ur.isSuccess());
			response.put('Delete_EntidadCuenta__c', mapContrato);
		
		} else {
			response.put('error', 'Parameter @idEntidadCuenta type EntidadCuenta__c is required');
		}
		return response;
	}

	@AuraEnabled
	public static Map<String, Object> getRecordsType( String sObjectName ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( sObjectName ) ) {
			response.put('records', new Map<Id, RecordType>([ SELECT Id, Name, DeveloperName, IsActive, SobjectType FROM RecordType WHERE SObjectType =: sObjectName ]));
		} else {
			response.put('error', 'Parameter @sObjectName is required');
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 17/04/2017
		* @param codigoPostal Código postal a buscar.
		* @description Busca registros de Direccion__c, filtrados por CodigoPostal__c.
		* @return Objeto con la propiedad records si se encuentra la información ó error en caso de haber alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> buscarDireccion( String codigoPostal ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( codigoPostal) ) {
			String str = '%' + codigoPostal.trim() + '%';
			response.put('records', [SELECT Calle__c, Ciudad__c, CodigoPostal__c, Colonia__c, DelegacionMunicipio__c, Estado__c, Id, Name, Tipo__c FROM Direccion__c WHERE Name LIKE :str ]);
		} else {
			response.put('error', 'Parameters @codigoPostal is required');
		}
		return response;
	}

	/*@AuraEnabled
	public static EntidadLegal__c getAddressAccount( String accountId ) {
		
		Account account =[SELECT id, Calle__c,NumeroInterior__c,NumeroExterior__c,DelegacionMunicipioFiscal__c,Estado__c,Ciudad__c,Colonia__c,ColMpoCpEdo__r.CodigoPostal__c FROM Account WHERE id=:accountId limit 1];
		EntidadLegal__c el = new EntidadLegal__c(Calle__c=account.Calle__c,
			Ciudad__c=account.Ciudad__c,Colonia__c=account.Colonia__c,NumeroExterior__c=account.NumeroExterior__c,NumeroInterior__c=account.NumeroInterior__c,Estado__c=account.Estado__c,DelegacionMunicipioFiscal__c=account.DelegacionMunicipioFiscal__c,CodigoPostal__c=account.ColMpoCpEdo__r.CodigoPostal__c);
		return el;
	}*/



	// EntidadContacto__c

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param idEntidadCuenta Id de instancia EntidadCuenta__c
		* @description Obtiene los datos de un registro de EntidadCuenta__c.
		* @return Objeto con la propiedad records si se encuentra la información ó error en caso de haber alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> getEntidadCuenta( Id idEntidadCuenta ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( idEntidadCuenta ) ) {
			//DV
            response.put('records', [SELECT Id, Cuenta__c, Cuenta__r.Name, EntidadLegal__c, EntidadLegal__r.Calle__c, EntidadLegal__r.TipoSociedad_PL__c, EntidadLegal__r.CountryOrigin__c,EntidadLegal__r.Ciudad__c, EntidadLegal__r.Direccion_Cuenta__c, EntidadLegal__r.CodigoPostal__c, EntidadLegal__r.Colonia__c, EntidadLegal__r.Cuenta__c, EntidadLegal__r.DelegacionMunicipioFiscal__c, EntidadLegal__r.Estado__c, EntidadLegal__r.Estatus__c, EntidadLegal__r.RazonSocial__c, EntidadLegal__r.NumeroExterior__c, EntidadLegal__r.NumeroInterior__c,EntidadLegal__r.Address__c, EntidadLegal__r.Name, EntidadLegal__r.RecordTypeId, (SELECT Id FROM Administraci_n_de_Ventas__r) FROM EntidadCuenta__c WHERE Id =: idEntidadCuenta]);
		    //DV
        } else {
			response.put('error', 'Parameter @idEntidadCuenta is required');
		}
		return response;
	}
	

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param idEntidadCuenta Id de instancia EntidadCuenta__c
		* @description Obetiene los contactos asociados al registro de una EntidadCuenta__c.
		* @return Objeto con la propiedad records si se encuentra la información ó error en caso de haber alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> getContactoByEntidad( Id idEntidadCuenta ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( idEntidadCuenta ) ) {
			response.put('records', [SELECT Id, Contacto__r.Name, Entidad_Cuenta__c FROM ContactoEntidad__c WHERE Entidad_Cuenta__c =: idEntidadCuenta ORDER BY Contacto__r.Name ASC]);
		} else {
			response.put('error', 'Parameter @idEntidadCuenta is required');
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param idContactoEntidad Id de un registro de ContactoEntidad__c
		* @description Obtiene el registro de ContactoEntidad__c me diante el Id.
		* @return Objeto con la propiedad records si se encuentra la información ó error en caso de haber alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> getContactoEntidad( Id idContactoEntidad ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( idContactoEntidad ) ) {
			response.put('records', [SELECT Id, Contacto__r.Name, Entidad_Cuenta__r.Cuenta__r.Name FROM ContactoEntidad__c WHERE Id =: idContactoEntidad]);
		} else {
			response.put('error', 'Parameter @idContactoEntidad is required');
		}
		return response;
	}



	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param idAccount Id de Account.
		* @param query Cadena proporcionada por el usuario.
		* @description Busca registros de AccountContactRelation, filtrados por Id de Account y con Contact.Funcion__c con valor 'Representante Legal'
		* @return Objeto con la propiedad records si se encuentra la información ó error en caso de haber alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> getContactoByAccount( Id idAccount, String query ) {
		Map<String, Object> response = new Map<String, Object>();
		if ( String.isNotBlank( idAccount) && String.isNotBlank( query) ) {
			String str = '%' + query.trim() + '%';
			response.put('idAccount', idAccount);
			response.put('query', query);
			if( query.length() > 2 ) {
				response.put('records', [SELECT Id, AccountId, Contact.Name FROM AccountContactRelation WHERE AccountId =: idAccount AND Contact.Funcion__c = 'Representante Legal'  AND Contact.Name LIKE :str ]);
			} else {
				response.put('records', [SELECT Id, AccountId, Contact.Name FROM AccountContactRelation WHERE AccountId =: idAccount AND Contact.Funcion__c = 'Representante Legal' AND (Contact.Name LIKE :str OR Contact.Funcion__c = 'Representante Legal')]);
			}
		} else {
			response.put('error', 'Parameters @idAccount and @query are required');
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param contactoEntidad registro de tipo ContactoEntidad__c.
		* @description Crea ó actualiza un registro de tipo ContactoEntidad__c.
		* @return Objeto con la propiedad Upsert_ContactoEntidad__c si el DML fué exitoso ó error en caso de haber alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> saveContactoEntidad( ContactoEntidad__c contactoEntidad ) {
		Map<String, Object> response = new Map<String, Object>();

		if ( contactoEntidad == null ) {
			response.put('error', 'contactoEntidad es requerida');
		} else if( String.isBlank(contactoEntidad.Entidad_Cuenta__c) ) {
			response.put('error', 'Entidad_Cuenta__c es requerida');
		} else if( String.isBlank(contactoEntidad.Contacto__c) ) {
			response.put('error', 'Contacto__c es requerido');
		} else {
			try {
				Database.upsertResult ur = Database.upsert(contactoEntidad);
				Map<String, Object> mapContrato = new Map<String, Object>();
				mapContrato.put('Id', ur.getId());
				mapContrato.put('error', ur.getErrors());
				mapContrato.put('isCreated', ur.isCreated());
				mapContrato.put('isSuccess', ur.isSuccess());
				response.put('Upsert_ContactoEntidad__c', mapContrato);
				actualizaEstatusEntidad( contactoEntidad );
			} catch( Exception ex ) {
				response.put( 'error', ex.getMessage() );
				response.put( 'detail', ex.getStackTraceString() + ', ' + ex.getLineNumber() );
			}
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 02/04/2017
		* @param idContactoEntidad Id de registro de tipo ContactoEntidad__c.
		* @description Elimina un registro de tipo ContactoEntidad__c mediante su Id.
		* @return Objeto con la propiedad Delete_ContactoEntidad__c si el DML fué exitoso ó error en caso de haber alguno.
	*/
	@AuraEnabled
	public static Map<String, Object> removeContactoEntidad( Id idContactoEntidad ) {
		Map<String, Object> response = new Map<String, Object>();

		if ( idContactoEntidad == null ) {
			response.put('error', 'idContactoEntidad es requerido');
		} else {
			try {

				List<ContactoEntidad__c> contactoEntidad = [ SELECT Id, Entidad_Cuenta__c FROM ContactoEntidad__c WHERE Id =: idContactoEntidad];
				
				Database.DeleteResult ur = Database.delete(idContactoEntidad);
				Map<String, Object> mapContrato = new Map<String, Object>();

				mapContrato.put('Id', ur.getId());

				mapContrato.put('error', ur.getErrors());
				mapContrato.put('isSuccess', ur.isSuccess());
				response.put('Delete_ContactoEntidad__c', mapContrato);

				if( contactoEntidad != null && contactoEntidad.size() > 0 ) {
					actualizaEstatusEntidad( contactoEntidad[0] );
				}
			} catch( Exception ex ) {
				response.put( 'error', ex.getMessage() );
				response.put( 'detail', ex.getStackTraceString() + ', ' + ex.getLineNumber() );
			}
		}
		return response;
	}

	/**
		* @author calvarez@ctconsulting.com.mx
		* @date 14/05/2018
		* @param contactoEntidad registro de tipo ContactoEntidad__c.
		* @description Actualiza campo EntidadLegal__c.Estatus__c.
		* @return void.
	*/
	public static void actualizaEstatusEntidad( ContactoEntidad__c contactoEntidad ) {
		// Verificar si Contacto agregado es extranjero - calvarez 14 de mayo de 2018
		List<EntidadCuenta__c> entidades = [SELECT Id,Cuenta__r.Sector__c,Cuenta__r.Segmento2__c, EntidadLegal__c, EntidadLegal__r.RecordType.Name, EntidadLegal__r.Estatus__c,EntidadLegal__r.CargaInicial__c FROM EntidadCuenta__c WHERE Id =: contactoEntidad.Entidad_Cuenta__c ];
		//Inicio cambio SIGLO
        //List<ContactoEntidad__c> listaContactos = [ SELECT Id FROM ContactoEntidad__c WHERE Entidad_Cuenta__c =: contactoEntidad.Entidad_Cuenta__c AND Contacto__r.Extranjero__c  = true ];
        List<ContactoEntidad__c> listaContactos = [ SELECT Id FROM ContactoEntidad__c WHERE Entidad_Cuenta__c =: contactoEntidad.Entidad_Cuenta__c AND Contacto__r.Nationality__c != '' AND Contacto__r.Nationality__c != null AND Contacto__r.Nationality__c != 'MEXICO' ];
		//Fin cambio SIGLO
        List<ContactoEntidad__c> listaContactos2 = [ SELECT Id FROM ContactoEntidad__c WHERE Entidad_Cuenta__c =:  contactoEntidad.Entidad_Cuenta__c  ];
		
		if( entidades != null && entidades.size() > 0  ) {
			if(!entidades[0].EntidadLegal__r.CargaInicial__c){
				Boolean publicaKey=false;
				Set<String> setDocs = new Set<String>();
				// List<Attachment> atts = [ SELECT Id, Name FROM Attachment WHERE ParentId =: entidades[0].EntidadLegal__c ];
				// for( Attachment att: atts ) {
				// 	setDocs.add( att.Name );
				// }

				List<ContentDocumentLink> atts = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =: entidades[0].EntidadLegal__c];

				for( ContentDocumentLink att: atts ) {
					setDocs.add( att.ContentDocument.Title  + '.pdf');
				}

				if(entidades[0].Cuenta__r.Sector__c=='Público'||entidades[0].Cuenta__r.Segmento2__c=='Key'){
					publicaKey=true;
				}
			
				
				Map<String, Object> mapDocsByTypePerson = CON_OppDocChecklist_CTRL.getDocsByTypePerson();
				TiposDocumento__c td = new TiposDocumento__c();
				Profile p=[Select Id,Name from Profile where Id=:UserInfo.getProfileId()];
                String perfil=' ';
                if(p.Name=='Afiliación'){
                    perfil=' Afiliación ';
                }
				//if( entidades[0].EntidadLegal__r.RecordType.Name == 'Persona Moral' ) {
                        td = [Select Id,Name from TiposDocumento__c where Name=:entidades[0].EntidadLegal__r.RecordType.Name+perfil+'EL'];//TiposDocumento__c.getInstance('Persona Moral'+perfil+'EL');                  
				//} else if ( entidades[0].EntidadLegal__r.RecordType.Name == 'Persona Física' ) {
					//td = TiposDocumento__c.getInstance('Persona Física'+perfil+'EL');
				///}

				List<Object> listDocs = (List<Object>) mapDocsByTypePerson.get( td.Name );
				System.debug('Anydatatype_msg '+listDocs);
				System.debug('Anydatatype_msg '+setDocs);
				Boolean allDocs = true;
                List<String> docOpcionales=new List<String>();
                try{
                    GeneralCatalog__c gc=[Select Id,Value__c from GeneralCatalog__c where Key__c=:entidades[0].EntidadLegal__r.RecordType.Name+perfil+'EL'];
                    if(gc.value__c!=null){
                        docOpcionales=gc.Value__c.split(';');
                    }
                }catch(Exception e){
                    System.debug('Error: '+e.getMessage()+',Linea: '+e.getLineNumber());
                }
				for( Object obj: listDocs ) {
					Map<String, Object> mapDoc = (Map<String, Object>) obj;
					String name = (String.valueOf(mapDoc.get('name')).replaceAll(' ', '_')) + '.pdf';

					//Verificar si es extranjero 
					if( name.indexOf('Formula_Migratoria_3.pdf') != -1 && ( listaContactos.size() < 1 )) {
						System.debug('name: no extrangero' );
						name = '';
					}

					System.debug('name: ' + name);

					if( String.isNotBlank( name ) && !setDocs.contains( name ) && allDocs == true &&!docOpcionales.contains(name)) {
						System.debug('name: d ' + name);
						allDocs = false;
					}
				}

				System.debug('allDocs: ' + allDocs);
				System.debug('entidades: ' + entidades);
				System.debug('contactoEntidad: ' + contactoEntidad);
				System.debug('listaContactos2 : ' + listaContactos2.size());
				System.debug('listaContactos2 : ' + listaContactos.size());
				
				if(publicaKey){
					allDocs=true;
				}	

				EntidadLegal__c el = new EntidadLegal__c( Id = entidades[0].EntidadLegal__c, Estatus__c = allDocs == false ? 'Incompleta' : 'Completa' );
				if( listaContactos2.size()<1){
					el.Estatus__c='Incompleta';
				}
				System.debug('************* actualizara a : '+ el);
				update el;
			}
		}
	}

	public static void actualizaEstatusEntidad( EntidadLegal__c entidadLegal,String status ) {
		// Verificar si Contacto agregado es extranjero - calvarez 14 de mayo de 2018
		//List<EntidadCuenta__c> entidadCuenta = [SELECT Id FROM EntidadCuenta__c WHERE EntidadLegal__c =: entidadLegal.id LIMIT 1];
		List<EntidadCuenta__c> entidades = [SELECT Id,Cuenta__r.Sector__c,Cuenta__r.Segmento2__c, EntidadLegal__c, EntidadLegal__r.RecordType.Name, EntidadLegal__r.Estatus__c FROM EntidadCuenta__c WHERE EntidadLegal__c =: entidadLegal.id ];
		List<ContactoEntidad__c> listaContactos = [ SELECT Id FROM ContactoEntidad__c WHERE Entidad_Cuenta__c =: entidades[0].id  ];
		
		if( entidades != null && entidades.size() > 0 ) {
			Boolean publicaKey=false;
			Set<String> setDocs = new Set<String>();
			List<Attachment> atts = [ SELECT Id, Name FROM Attachment WHERE ParentId =: entidades[0].EntidadLegal__c ];
			for( Attachment att: atts ) {
				setDocs.add( att.Name );
			}

			if(entidades[0].Cuenta__r.Sector__c=='Público'||entidades[0].Cuenta__r.Segmento2__c=='Key'){
				publicaKey=true;
			}
		
			
			Map<String, Object> mapDocsByTypePerson = CON_OppDocChecklist_CTRL.getDocsByTypePerson();
			TiposDocumento__c td = new TiposDocumento__c();
			
			if( entidades[0].EntidadLegal__r.RecordType.Name == 'Persona Moral' ) {
				td = TiposDocumento__c.getInstance('Persona Moral EL');

			} else if ( entidades[0].EntidadLegal__r.RecordType.Name == 'Persona Física' ) {
				td = TiposDocumento__c.getInstance('Persona Física EL');
			}

			List<Object> listDocs = (List<Object>) mapDocsByTypePerson.get( td.Name );
			Boolean allDocs = true;
			for( Object obj: listDocs ) {
				Map<String, Object> mapDoc = (Map<String, Object>) obj;

				String name = (String.valueOf(mapDoc.get('name')).replaceAll(' ', '_')) + '.pdf';

				// Verificar si es extranjero 
				if( name.indexOf('Migratoria') != -1 && ( listaContactos == null || listaContactos.size() < 1 )) {
					name = '';
				}

				System.debug('name: ' + name);

				if( String.isNotBlank( name ) && !setDocs.contains( name ) && allDocs == true ) {
					allDocs = false;
				}
			}
			if(status=='Incompleta'){
				allDocs=false;
			}
			else{
				allDocs=true;
			}
			if(publicaKey){
				allDocs=true;
			}	

			System.debug('allDocs: ' + allDocs);
			System.debug('entidades: ' + entidades);
			System.debug('entidadLegal: ' + entidadLegal);
			System.debug('listaContactos: ' + listaContactos.size());
					
			EntidadLegal__c el = new EntidadLegal__c( Id = entidades[0].EntidadLegal__c, Estatus__c = allDocs == false ? 'Incompleta' : 'Completa' );
			if( listaContactos.size()<1){
				el.Estatus__c='Incompleta';
			}
			update el;
		}
	}
    
    //DV Inicio
    @AuraEnabled
    public static List<String> getTipoDeSociedad(){
        Schema.DescribeFieldResult fieldResult = EntidadLegal__c.TipoSociedad_PL__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<String> options = new List<String>();
        
        for (Schema.PicklistEntry plValue : ple) { options.add(plValue.getLabel()); }
        return options;
    }
    //DV Fin
  
    @AuraEnabled
    public static List<String> getPaisOrigen(){
        Schema.DescribeFieldResult fieldResult = EntidadLegal__c.CountryOrigin__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<String> options2 = new List<String>();
        
        for (Schema.PicklistEntry plValue : ple) { options2.add(plValue.getLabel()); }
        return options2;
    }
}