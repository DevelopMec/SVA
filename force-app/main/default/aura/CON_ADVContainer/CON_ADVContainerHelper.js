({
	getInitialData : function(component, contratoId) {
		var action = component.get("c.executeQuery");
		var consulta="SELECT CustomersCreatedAS400__c,Entidad_Cuenta__c,PlatformAdministrator__c,PartidaPresupuesto__r.Quote.Account.CodigoPostal__c,PartidaPresupuesto__r.Quote.Account.Colonia__c,PartidaPresupuesto__r.Quote.Account.Calle__c,PartidaPresupuesto__r.Quote.Account.DelegacionMunicipioFiscal__c,PartidaPresupuesto__r.Quote.Account.NumeroExterior__c,PartidaPresupuesto__r.Quote.Account.Estado__c, EtapaContrato__c,Comentarios_ADV__c,CodigoAS400__c,Frecuencia_de_Pedido__c,Primer_Pedido__c,Tipo_Pedido__c,Nombre_de_Personalizacion__c,Direccion_Personalizacion__c,ImprimeLogo__c,TipoPlastico__c,LineasImpresionTarjeta__c,Tipo_Reposicion__c,Caducidad_Saldo__c,Opcion_Habilitada_ATM__c,ComoFactura__c,TipoCliente__c,CEO__c,DiscountFree__c,CondicionesPagoPlazo__c,Deduce__c,ComisionMinima__c,Personalizacion_de_Tarjetas__c,FrecuenciaFacturacion__c,EspecialDia__c,Consolidador__c,Ligado_a__c,CorreoRecibeFactura__c,DireccionFiscal__c,FiscalAddressText__c,Otros_correos__c,PeriodicidadComplemento__c,Emision_complemento__c,FrecuenciaEstadoCuenta__c,Tipo_de_Facturacion__c,Producto_Factura_Global__c,Sucursal_Facturacion_Global__c,Cliente_Facturacion_Global__c,Facturacion_Cargos__c,Facturacion_Plasticos__c,Facturacion_Comision__c,Linea_Operativa__c,Ventana_de_Riesgos__c,Frecuencia_Liberacion_Automatica__c,Fianza__c,MontoGarantia__c,Otro__c,Dia_Liberacion__c,Dia_de_la_Semana__c,Dia_Inicio__c,Proxima_Carga__c,Dia__c,VIP__c,Permite_autorizacion_telefonica__c,Item_Contratacion__c,TicketBomba__c,ControlVolumetrico__c,BombaPropia__c,Maneja_Nota_Vale__c,No_Mostrar_KM__c,Maneja_Conductores__c,Controla_Presencia_Vehiculo_NFC__c,Modo_Transaccion__c,Opera_TC_Truck__c,PartidaPresupuesto__r.TipoTarjeta__c,PartidaPresupuesto__r.Product2.Name,PartidaPresupuesto__r.Product2.Formato__c,PartidaPresupuesto__r.Product2.Uso__c, PartidaPresupuesto__r.Product2.Red__c, PartidaPresupuesto__r.Product2.IDInterno__c,PartidaPresupuesto__r.Quote.Opportunity.Competidor__c,PartidaPresupuesto__r.Quote.Opportunity.Recordtype.Name,PartidaPresupuesto__r.Quote.Opportunity.AccountId,";
		consulta=consulta+"Contacto__r.Curp__c,PartidaPresupuesto__r.Quote.Opportunity.Contacto__r.Email,PartidaPresupuesto__r.Quote.Opportunity.Contacto__r.Name,RejectionReasons__c,PartidaPresupuesto__r.Quote.Opportunity.EnvioXMLTC30__c,PartidaPresupuesto__r.Quote.Opportunity.Maquilador__c,PartidaPresupuesto__r.Quote.Name,PartidaPresupuesto__r.Quote.Opportunity.Name,PartidaPresupuesto__r.Quote.Opportunity.StageName,PartidaPresupuesto__r.Quote.Opportunity.Owner.Name,PartidaPresupuesto__r.Quote.OpportunityId,PartidaPresupuesto__r.Quote.Opportunity.ActaConstitutivaCliente__c,PartidaPresupuesto__r.Quote.Opportunity.CURP__c,PartidaPresupuesto__r.Quote.Opportunity.CedulaRFC__c,PartidaPresupuesto__r.Quote.Opportunity.ComprobanteDomicilioCliente__c,PartidaPresupuesto__r.Quote.Opportunity.ComprobanteDomicilioFiscal__c,PartidaPresupuesto__r.Quote.Opportunity.ConstanciaRFC__c,PartidaPresupuesto__r.Quote.Opportunity.ConstanciaRFCCliente__c,PartidaPresupuesto__r.Quote.Opportunity.IdentificacionOficialCliente__c,PartidaPresupuesto__r.Quote.Opportunity.IdentificacionOficialVigente__c, PartidaPresupuesto__r.Quote.Opportunity.PoderNotarial__c,PartidaPresupuesto__r.Quote.Owner.Name,PartidaPresupuesto__r.Quote.AccountId,PartidaPresupuesto__r.Quote.Account.RazonSocial__c,PartidaPresupuesto__r.Quote.Account.RFC__c,PartidaPresupuesto__r.Quote.Account.Owner.Name,PartidaPresupuesto__r.Quote.Account.BillingAddress,PartidaPresupuesto__r.Quote.Contact.Email,PartidaPresupuesto__r.Quote.Contact.Name,PartidaPresupuesto__r.Quote.Contact.Puesto__c,PartidaPresupuesto__r.Quote.Account.Ciudad__c, PartidaPresupuesto__r.Quote.Opportunity.NumeroOportunidad__c,PartidaPresupuesto__r.Quote.Opportunity.Familia__c, PartidaPresupuesto__r.Quote.Opportunity.Producto_cotizacion__c ,PartidaPresupuesto__r.Quote.Opportunity.Contrato_Filial__r.CodigoAS400__c,PartidaPresupuesto__r.Quote.Opportunity.RecordType.DeveloperName, PartidaPresupuesto__r.Quote.Opportunity.Producto__c,PartidaPresupuesto__r.Quote.Opportunity.OwnerId,PartidaPresupuesto__r.Quote.Opportunity.LeadSource, PartidaPresupuesto__r.Quote.Opportunity.SubOrigen__c, PartidaPresupuesto__r.Quote.Opportunity.NumeroAltaCliente__c,PartidaPresupuesto__r.Quote.Account.Name,PartidaPresupuesto__r.Quote.Account.Phone,PartidaPresupuesto__r.Quote.Account.Telefono2__c,PartidaPresupuesto__r.Quote.Account.Giro__c,PartidaPresupuesto__r.Quote.Contact.Funcion__c,Contacto__c,Contacto__r.Funcion__c,Contacto__r.Email,Contacto__r.Phone,Contacto__r.Puesto__c,Contacto__r.RazonSocial__c,Contacto__r.Name, PartidaPresupuesto__r.Quote.Opportunity.VentaTrademarketing_Checkbox__c, PartidaPresupuesto__r.Quote.Account.CodigoClienteAS400__c, PartidaPresupuesto__r.Quote.Opportunity.VentaTradeMarketing_PL__c,PartidaPresupuesto__r.Quote.Opportunity.Comentarios_Ejecutivo__c FROM Contrato2__c where Id = '"+contratoId+"'";
        action.setParams({
			query : consulta
        });
		action.setCallback(this,function(response){
			var state = response.getState();
			var dataSource = {};
			var QuoteLineItemId;
			var toastEvent1 = $A.get("e.force:showToast");
			 if(state == 'SUCCESS'){

			 	var returnedValue = response.getReturnValue()[0];

                 if(returnedValue.RejectionReasons__c!=null){
                     component.set("v.motivosRechazoSelec",returnedValue.RejectionReasons__c.split(";"));   
                 }                 
			 	dataSource = returnedValue.PartidaPresupuesto__r.Quote;
			 	dataSource.Account.DireccionFiscal = dataSource.Account.Calle__c +' '+dataSource.Account.NumeroExterior__c+' '+ dataSource.Account.Colonia__c+' '+dataSource.Account.DelegacionMunicipioFiscal__c+' '+dataSource.Account.Estado__c+' C.P '+dataSource.Account.CodigoPostal__c;
			 	QuoteLineItemId = returnedValue.PartidaPresupuesto__r.Id;
			 	dataSource.QuoteLineItem = {};
			 	dataSource.Product2__c ={}
			 	dataSource.Product2__c = returnedValue.PartidaPresupuesto__r.Product2
			 	dataSource.ContactRepresentanteLegal = {}
			 	dataSource.ContactAdministrador = {}
			 	dataSource.ContactRepresentanteLegal.Email = (returnedValue.Contacto__r && returnedValue.Contacto__r.Email ) ? returnedValue.Contacto__r.Email : '';
				dataSource.ContactRepresentanteLegal.Puesto__c = (returnedValue.Contacto__r && returnedValue.Contacto__r.Funcion__c ) ? returnedValue.Contacto__r.Funcion__c : '';
				dataSource.ContactRepresentanteLegal.RazonSocial__c = (returnedValue.Contacto__r && returnedValue.Contacto__r.RazonSocial__c) ? returnedValue.Contacto__r.RazonSocial__c : '';
				dataSource.ContactRepresentanteLegal.Name = (returnedValue.Contacto__r && returnedValue.Contacto__r.Name) ? returnedValue.Contacto__r.Name : '';
				dataSource.ContactRepresentanteLegal.Phone = (returnedValue.Contacto__r && returnedValue.Contacto__r.Phone) ? returnedValue.Contacto__r.Phone : '';
			 	console.log('dataSource.AccountId:',dataSource.AccountId);
                console.log('dataSource.Product2__c:',dataSource.Product2__c);
			 	component.set("v.cuenta", dataSource.AccountId);
			 	component.set("v.oppId",dataSource.OpportunityId);
				this.getMotivosRechazoHistorial(component,dataSource.OpportunityId);
			 	if(dataSource.Opportunity.EnvioXMLTC30__c){
                     component.set("v.isSendXML", true);
                 }
			
                delete returnedValue.PartidaPresupuesto__r;
			 	delete dataSource.ContactId;
			 	//delete dataSource.OpportunityId;
			 	delete dataSource.OwnerId;
			 	delete dataSource.AccountId;
			 	dataSource.User = {};
                dataSource.Contrato2__c ={};
                dataSource.Contrato2__c = returnedValue;
                dataSource.Filiales = [];

                 component.set("v.clientesCompletos",returnedValue.CustomersCreatedAS400__c);
                // dataSource.User.Id = $A.get("$SObjectType.CurrentUser.Id");
                // var user =
                // dataSource.User.Email = (user.Email != undefined)? user.Email:'';
                // dataSource.User.FormaPago__c = ($A.get("$SObjectType.CurrentUser.FormaPago__c") != undefined)?$A.get("$SObjectType.CurrentUser.FormaPago__c"):'';
                // dataSource.User.NumeroTerritorio__c = (user.NumeroTerritorio__c != undefined)? user.NumeroTerritorio__c:'';
                // dataSource.User.ManagerId = (user.Manager.Name != undefined)? user.Manager.Name :'';
			 	// dataSource.Contrato2__c.EtapaContrato__c = returnedValue.EtapaContrato__c;
			 	// dataSource.Contrato2__c.Id = returnedValue.Id;
			 	// dataSource.Contrato2__c.PartidaPresupuesto__c = returnedValue.PartidaPresupuesto__c;			 				

			 	
			 	this.getCotizacion(component,QuoteLineItemId);
			 	this.getPorductoConcepto(component,QuoteLineItemId);
			 	this.getOppAttachments(component);

				this.getUser(component,dataSource.Opportunity.OwnerId );
			 	this.getEntidadLegal(component,contratoId);
			 	if(dataSource.Contrato2__c.EtapaContrato__c == 'Autorizado'){
			 		component.set("v.btnInactive", true);
			 		component.set("v.btnInactiveCheck", false);
			 	}
			 	else{
			 		component.set("v.btnInactive", false);
			 	}
                 if(dataSource.Product2__c.IDInterno__c=="30"&& component.get("v.isSendXML")==false){
                     component.set("v.isXML", false);
                 }
			 	
			 	component.set("v.dataSource", dataSource);
			 	this.getContacts(component,dataSource.Opportunity.AccountId);
                this.getContactosAP(component); //DVM 2 Julio, para atender el requerimiento de mostrar todos los contactos con funcion AP en la pantalla ADV
                

			 }
		});
		$A.enqueueAction(action);

	},
	getMotivosRechazoHistorial : function(component,oppId){
		var action = component.get("c.executeQuery");
		var consulta="SELECT Id, Opportunity__c,Opportunity_status__c, ADV_Start_Date__c, ADV_End_Date__c, Rejection_Reason__c, ADV_Comments__c,Comercial_comments__c	 FROM Rejection_history__c WHERE Opportunity__c = '"+oppId+"' ORDER BY CreatedDate DESC";
		action.setParams({
			query : consulta
		});
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state == 'SUCCESS') {
				component.set('v.historicoMotivosRechazo',response.getReturnValue());
			}
		});
		$A.enqueueAction(action);

	},
	getNewRepresentanteLegal: function(component,entidadLegal){

		var action2 = component.get("c.executeQuery");

		 	console.log('ENTRO getEntidadLegal');

		 	action2.setParams({

				query : "SELECT Id,Direccion__c,Name,RazonSocial__c FROM EntidadLegal__c WHERE Id = '"+entidadLegal+"'"
			});
			action2.setCallback(this,function(response){
				var state = response.getState();

				if(state == 'SUCCESS'){
					var dataSource = component.get("v.dataSource");
					var returnedValue = response.getReturnValue()[0];

					console.log('getNewRepresentanteLegal sin contacto EL;',returnedValue);
					dataSource.Account.RazonSocial__c = (returnedValue.RazonSocial__c != undefined) ? returnedValue.RazonSocial__c : '-';
					dataSource.Account.RFC__c = (returnedValue.Name != undefined) ? returnedValue.Name : '-';
					dataSource.Account.DireccionFiscal = (returnedValue.Direccion__c != undefined) ? returnedValue.Direccion__c : '-';
					component.set("v.dataSource", dataSource);
				}
			});
			$A.enqueueAction(action2);


		this.getAttachment(component,entidadLegal);
		
		/*var action = component.get("c.executeQuery");

	 	console.log('ENTRO getNewRepresentanteLegal');

	 	action.setParams({

			query : "SELECT Id,Contacto__r.Name,Contacto__r.Email,Contacto__r.Phone,Contacto__r.Puesto__c,Contacto__r.Funcion__c FROM Contrato2__c WHERE Id = '"+entidadLegal+"'"
		});
		action.setCallback(this,function(response){
			var state = response.getState();

			console.log('getNewRepresentanteLegal state;',state);

			if(state == 'SUCCESS'){
				var returnedValue = response.getReturnValue()[0];

				console.log('getNewRepresentanteLegal returnedValue',returnedValue);

				if(returnedValue != null || returnedValue != undefined){
					var dataSource = component.get("v.dataSource")
					var repLegal;

					if(returnedValue.Contacto__r.Funcion__c == 'Representante Legal'){
						dataSource.ContactRepresentanteLegal = returnedValue.Contacto__r;
						repLegal = returnedValue.Contacto__r;
					}
					else if(returnedValue.Contacto__r.Funcion__c == 'Quien administra Plataforma'){
						dataSource.ContactAdministrador = returnedValue.Contacto__r;
					}


					if(dataSource.ContactAdministrador == null || dataSource.ContactAdministrador == undefined){
						dataSource.ContactAdministrador = repLegal
					}

					dataSource.Account.RFC__c = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.RFC__c != undefined) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.RFC__c : '-';
					dataSource.Account.DireccionFiscal = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Direccion__c != undefined) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Direccion__c : '-';
					component.set("v.dataSource", dataSource);
					
					console.log('getNewRepresentanteLegal returnedValue:',returnedValue);
				}else{


					var action2 = component.get("c.executeQuery");

				 	console.log('ENTRO getEntidadLegal');

				 	action2.setParams({

						query : "SELECT Id,Direccion__c,RFC__c,RazonSocial__c  FROM EntidadLegal__c WHERE Id = '"+entidadLegal+"'"
					});
					action2.setCallback(this,function(response){
						var state = response.getState();

						if(state == 'SUCCESS'){
							var dataSource = component.get("v.dataSource");
							var returnedValue = response.getReturnValue()[0];

							console.log('sin contacto EL;',returnedValue);
							dataSource.Account.RazonSocial__c = (returnedValue.RazonSocial__c != undefined) ? returnedValue.RazonSocial__c : '-';
							dataSource.Account.RFC__c = (returnedValue.RFC__c != undefined) ? returnedValue.RFC__c : '-';
							dataSource.Account.DireccionFiscal = (returnedValue.Direccion__c != undefined) ? returnedValue.Direccion__c : '-';
							component.set("v.dataSource", dataSource);
						}
					});
					$A.enqueueAction(action2);

				}
				
				
			}
		});
		$A.enqueueAction(action);

		this.getAttachment(component,entidadLegal);*/



	},
	getEntidadLegal: function(component,contratoId){

		var dataSource = {};

	 	var action = component.get("c.executeQuery");

	 	console.log('ENTRO getEntidadLegal');

	 	action.setParams({

			query : "SELECT Id,Entidad_Cuenta__c,Entidad_Cuenta__r.EntidadLegal__c,Entidad_Cuenta__r.EntidadLegal__r.Id,Entidad_Cuenta__r.EntidadLegal__r.RecordType.Name,Entidad_Cuenta__r.EntidadLegal__r.Name,Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c,Entidad_Cuenta__r.EntidadLegal__r.Estatus__c,Entidad_Cuenta__r.EntidadLegal__r.Direccion__c  FROM Contrato2__c WHERE Id = '"+contratoId+"'"
		});
		action.setCallback(this,function(response){
			var state = response.getState();

			if(state == 'SUCCESS'){

				var returnedValue = response.getReturnValue()[0];
				
				console.log('getEntidadLegal returnedValue:',returnedValue);
				if(returnedValue && returnedValue.Entidad_Cuenta__r){
					dataSource.Id = (returnedValue.Entidad_Cuenta__r.EntidadLegal__c) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__c : '' ;
					dataSource.RecordType = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.RecordType.Name) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.RecordType.Name : '';
					dataSource.Name = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Name ) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Name : '' ;
					//dataSource.Nombre__c = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Nombre__c ) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Nombre__c : '';
					dataSource.Direccion__c = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Direccion__c) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Direccion__c : '';
					dataSource.RFC__c = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Name) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Name : '';
					dataSource.RazonSocial__c = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c : '';
					dataSource.Estatus__c = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Estatus__c) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Estatus__c : '';
					dataSource.Disabled = true;

					var dataSource2 = component.get("v.dataSource");

			 		dataSource2.Account.RazonSocial__c = dataSource.RazonSocial__c;
					dataSource2.Account.RFC__c = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Name != undefined) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Name : '-';
					dataSource2.Account.DireccionFiscal = (returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Direccion__c != undefined) ? returnedValue.Entidad_Cuenta__r.EntidadLegal__r.Direccion__c : '-';
					component.set("v.dataSource", dataSource2);

					console.log('getEntidadLegal EL:',dataSource);

					component.set("v.entidadLegal", dataSource);
					component.set("v.eLExist", true);
					this.getAttachment(component,dataSource.Id);
				}					
			}


		});
		$A.enqueueAction(action);
	},
	getFiliales: function(component,contratoId){
		var action = component.get("c.executeQuery");
		var query = "SELECT Id, Name,PlatformAdministrator__r.Name,PlatformAdministrator__r.Email, Contrato_2__c, Entidad_Cuenta__c,Entidad_Cuenta__r.EntidadLegal__c,Entidad_Cuenta__r.EntidadLegal__r.Id,Entidad_Cuenta__r.EntidadLegal__r.RecordType.Name,Entidad_Cuenta__r.EntidadLegal__r.Name,Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c,Entidad_Cuenta__r.EntidadLegal__r.Estatus__c,Entidad_Cuenta__r.EntidadLegal__r.Direccion__c, CodigoAS400__c FROM ContratoFilial__c WHERE Contrato_2__c = '"+contratoId+"'";
		var filiales;	
		action.setParams({
			query: query
		})
		action.setCallback(this,function(response){
			
			var state = response.getState();
			if(state == 'SUCCESS'){

				filiales = component.get("v.filialesSource");
				
				console.log('getFiliales:',response);

				var returnedValue = response.getReturnValue();
				
				for(var x = 0; x < returnedValue.length ; x++){
					console.log('returnedValue',returnedValue[x]);
					
					filiales.push(returnedValue[x]);
				}

				for(var y = 0; y < filiales.length; y++){
					filiales[y].Disabled = true;
					//console.log('filiales[y].Disable:',filiales[y].Disable);
				}
				
				
				
				component.set("v.filialesSource",filiales);
			}
		})
		$A.enqueueAction(action);
	},
	getUser: function(component,userId){
		console.log();
		var action = component.get("c.executeQuery");		
		var query = "Select Id,Manager.Name,Email,NumeroTerritorio__c,TerritorioPosventa__c FROM User WHERE Id = '"+userId+"' Limit 1";
		var dataSource;
		action.setParams({
			query : query
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state == 'SUCCESS'){
				dataSource = component.get("v.dataSource")				
				var returnedValue = response.getReturnValue()[0]
				dataSource.User = returnedValue
				if(dataSource.Opportunity.RecordType != undefined || dataSource.Opportunity.RecordType != null){
					if(dataSource.Opportunity.RecordType.Name != undefined && dataSource.Opportunity.RecordType.Name != 'Venta nueva'){
						dataSource.User.NumeroTerritorio__c = dataSource.User.TerritorioPosventa__c;
					}
				}
				console.log('User:',JSON.parse(JSON.stringify(dataSource.User)));
				component.set("v.dataSource", dataSource);
			}
		})
		$A.enqueueAction(action);
	},
	getOppAttachments : function(component) {
		console.log('into getOppAttachments');

		var toastEvent1 = $A.get("e.force:showToast");
		var oppId = component.get("v.oppId");

		var executeQuery = component.get("c.executeQuery");
		executeQuery.setParams({
			query : "SELECT ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, Id FROM ContentDocumentLink WHERE LinkedEntityId='" + oppId + "'"
		});

		executeQuery.setCallback( this, function( res ) {
			var state = res.getState();
			console.log('reponse getOppAttachments: ', state)
			if( state =='SUCCESS' ) {

				var data = res.getReturnValue();
				console.log('getOppAttachments: ', data);
				if( data.length > 0 ) {
					var { DocumentosOportunidad = {} } = component.get('v.app_edenred.documentos')
					var fileNames = DocumentosOportunidad.label || {}
					var documents = [];
					for( var cd of data ) {
						var doc = { Id: cd.ContentDocumentId };
						doc.Name = cd.ContentDocument && cd.ContentDocument.Title ? cd.ContentDocument.Title : ''
						doc.Title = cd.ContentDocument && cd.ContentDocument.Title ? cd.ContentDocument.Title : ''

						if( fileNames.hasOwnProperty(doc.Title) ) {
							documents.push( doc );
						}

					}

					component.set("v.attachmentSourceOpp", documents);
					component.set("v.app_edenred.render", true);

				} else {

					toastEvent1.setParams({
					"duration": "15000",
					"type": "erro",
					"title": "Advertencia",
					"message": "No se encontraron documentos en la oportunidad."
					});
					toastEvent1.fire();
				}
			}
		});
		$A.enqueueAction(executeQuery);

		/*old version 08/08/2018 - comenta @calvarez
			var toastEvent1 = $A.get("e.force:showToast");
		var oppId = component.get("v.oppId");

		console.log('oppId Attachment: ', oppId);

		var query2 = "SELECT Name, Id FROM Attachment WHERE ParentId ='" + oppId + "'"
		var action3 = component.get("c.executeQuery");
		action3.setParams({
			query : query2
		});

		action3.setCallback( this, function( response ) {
			var state = response.getState();
			var respuesta;
			
			if( state =='SUCCESS' ) {
				respuesta = response.getReturnValue();
				console.log('respuesta OPPattachments:',respuesta);
				if( respuesta.length > 0 ) {
					component.set("v.attachmentSourceOpp", respuesta);
				} else {
					toastEvent1.setParams({
					"duration": "15000",
					"type": "erro",
					"title": "Advertencia",
					"message": "No se encontraron documentos en la oportunidad."
					});
					toastEvent1.fire();
				}
			}
		});
		$A.enqueueAction(action3);
		*/

	},
	getAttachment : function(component,entidadLegal){
		var executeQuery = component.get("c.executeQuery");
		var toastEvent1 = $A.get("e.force:showToast");
		var splitName;
		var attachmentSource = [];

		executeQuery.setParams({query : "SELECT ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, Id, LinkedEntity.RecordType.Name FROM ContentDocumentLink WHERE LinkedEntityId='" + entidadLegal + "'" });
		executeQuery.setCallback( this,function( response ) {
			var state = response.getState();
			if( state == 'SUCCESS' ) {
				var res = response.getReturnValue();

				var elegal = res && res.length > 0 ? res[0] : {}
				var tipoPersonaEL = elegal.LinkedEntity && elegal.LinkedEntity.RecordType ? elegal.LinkedEntity.RecordType.Name : ''
				var tipoPersonaLabel = tipoPersonaEL == 'Persona Moral' ? 'Persona Moral EL' : 'Persona Física EL'
				var { [tipoPersonaLabel]: tipoPersona = {} } = component.get('v.app_edenred.documentos')
				var fileNames = tipoPersona.label || {}

				var documents = [];
				for( var cd of res ) {
					var doc = { Id: cd.ContentDocumentId };
					doc.Name = cd.ContentDocument && cd.ContentDocument.Title ? cd.ContentDocument.Title : ''
					doc.Title = cd.ContentDocument && cd.ContentDocument.Title ? cd.ContentDocument.Title : ''
                    //doc.Name = doc.Name.replace(/_/g, " ");
					doc.Title = doc.Title.replace(/_/g, " ");
					if( fileNames.hasOwnProperty(doc.Title) ) {
						documents.push( doc );
					}
				}

				documents.forEach( function( att, index ) {
					if(att.Name.indexOf('Contrato Ticket Car ') != -1 ) {
		        		splitName = att.Name.split('\_');
		        	} else {
		        		splitName = att.Name.split('\.');
		        	}

		        	if( splitName[0].indexOf('_') != -1 ) {
		        		splitName[0] = splitName[0].replace(/_/g, " ");
		        	}
		        	att.Name = splitName[0]
				})

				var oppAttach = component.get("v.attachmentSourceOpp");

				documents.forEach( function( opp, index ) {
					oppAttach.push(opp);
				})

				component.set("v.attachmentSource", oppAttach);
				component.set("v.app_edenred.render", true);
			} else {
				toastEvent1.setParams({
					"duration": "15000",
					"type": "warning",
					"title": "Advertencia",
					"message": "Error al consultar los documentos asociados a la oportunidad"
				});
				toastEvent1.fire();
			}			

		});
		$A.enqueueAction(executeQuery);

		/*old version 8/08/2018 @calvarez
		var action2 = component.get("c.executeQuery");
		var toastEvent1 = $A.get("e.force:showToast");
		var splitName;
		var attachmentSource = [];

		var query = "SELECT Name, Id FROM Attachment WHERE ParentId ='" + entidadLegal + "'"
		
		action2.setParams({
			query : query
		});
		action2.setCallback(this,function(response){
			var state = response.getState();
			var res;
			
			if(state =='SUCCESS'){
				res=response.getReturnValue();
				res.forEach(function(att,index){
					if(att.Name.indexOf('Contrato Ticket Car ') != -1){
		        		splitName = att.Name.split('\_');
		        	}
		        	else{
		        		splitName = att.Name.split('\.');
		        	}
		        	if(splitName[0].indexOf('_') != -1){
		        		splitName[0] = splitName[0].replace(/_/g, " ");
		        	}
		        	att.Name = splitName[0]
				})

				var oppAttach = component.get("v.attachmentSourceOpp");

				oppAttach.forEach(function(opp,index){
					res.push(opp);
				})

				console.log('getAttachment:',res);
				component.set("v.attachmentSource", res);
								
				// Object.keys(res).forEach(function(key,index){
				// 	attachmentSource.push({name:key,value:''})
				// })
				// Object.values(res).forEach(function(value,index){
				// 	attachmentSource[index].value = value;
				// })
				// component.set("v.attachmentSource", attachmentSource);
				
				// console.log('Attachments' , attachmentSource);
			}
			else 
			{
				toastEvent1.setParams({
					"duration": "15000",
					"type": "warning",
					"title": "Advertencia",
					"message": "Error al consultar los documentos asociados a la oportunidad"
				});
				toastEvent1.fire();
			}			

		});
		$A.enqueueAction(action2);*/
	},

	getCotizacion : function(component, idCotizacion){
		
		var action = component.get("c.executeQuery");
		var query = 'SELECT Id, CantidadTarjetas__c, Description,Product2.IDInterno__c, FormaPago__c, OpcionesMetodoPago__c, OtroMetodoPago__c, TarjetaAsociada__c, TipoTarjeta__c, LineNumber, Subtotal, Quantity, Product2Id, PricebookEntryId, ServiceDate, UnitPrice, ClabeInterbancaria__c, TipoAmex__c, NivelConsumo__c FROM QuoteLineItem WHERE Id=\'' + idCotizacion + '\' AND Escalonamiento__c = NULL ORDER BY Id ASC';
		var dataSource;
		action.setParams({
			query: query
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state == 'SUCCESS'){
				var returnedValue = response.getReturnValue()[0]
				dataSource= component.get("v.dataSource")
				dataSource.QuoteLineItem = returnedValue;
				
				if(returnedValue.FormaPago__c == 'TransferenciaElectronica'){
					component.set("v.transferenciaElectronica",true)
				}
				else if(returnedValue.FormaPago__c == 'American Express'){
					component.set("v.amex",true)
				}
				else if(returnedValue.FormaPago__c == 'Deposito'){
					component.set("v.depositoBancario",true)
				}
				else if(returnedValue.FormaPago__c == 'Otros'){
					component.set("v.otros",true)
				}
				component.set("v.dataSource", dataSource);
                
                //if(returnedValue.Product2.IDInterno__c=='30'||returnedValue.Product2.IDInterno__c=='31'){
                    component.set("v.loadingPage",true);
                    var cmp=component.find("camposCon");
                    cmp.iniciar(dataSource.QuoteLineItem.Id);
                //}
                
				console.log('Datos de Contrato: ', dataSource);
				
				
			}
			else{
				
			}

		})
		$A.enqueueAction(action);
	},

	getPorductoConcepto :  function(component, quoteLineItemId){
		var action = component.get("c.executeQuery");
		var query = 'SELECT Id, Concepto__c,Concepto__r.Orden__c,Concepto__r.Obligatorio__c, Concepto__r.TipoCargo__c, PrecioLista__c, PrecioLista2__c, PrecioFinal__c, Bonificacion__c, VigenciaDescuento__c, CantidadTarjetas__c, PartidaPresupuesto__c, ProductoComparadoID__c FROM ProductoConcepto__c WHERE  Concepto__c != null AND PartidaPresupuesto__c =\'' + quoteLineItemId + '\'';
		var dataSource;
		action.setParams({
			query : query
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state == 'SUCCESS'){
				var returnedValue = response.getReturnValue()

				var datos = {ob: [],op: []}

				for(var concepto of returnedValue){
					
					concepto.TipoCargo__c = concepto.Concepto__r.TipoCargo__c ? concepto.Concepto__r.TipoCargo__c : 'zzzzz'


					concepto.TipoCargo__c = concepto.TipoCargo__c == 'Comisión por el servicio' ? '' : concepto.TipoCargo__c
					
					datos[concepto.Concepto__r.Obligatorio__c ? 'ob' : 'op'].push(concepto)

				}

				for(var tipo in datos){

					datos[tipo+'_ord'] = datos[tipo].sort(function(a,b){ 
						
						if(a.TipoCargo__c < b.TipoCargo__c){

							return -1

						}else if(a.TipoCargo__c > b.TipoCargo__c){

							return 1

						}

						return 0 
					})

				}

				console.log('Productos ordenados:',datos);

				returnedValue = datos.ob_ord.concat(datos.op_ord)

				component.set("v.productosSource", returnedValue);
				
				console.log('Producto concepto', returnedValue)
			}
		})
		$A.enqueueAction(action);
	},
    getMotivosRechazo : function(component, idCotizacion){
        var action=component.get("c.getMotivosDeRechazo");
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.motivosRechazoList",response.getReturnValue());
            }else{
                console.log("ERROR GET MOTIVOS RECHAZO");
            }
        });
        $A.enqueueAction(action);
    },
	getContacts : function(component, idCuenta){

		var action = component.get("c.executeQuery");
		var dataSource = component.get("v.dataSource");				
				
		action.setParams({
			query : "SELECT Id, Name, AccountId, Funcion__c,Email,Puesto__c,Phone FROM Contact where AccountId = '"+idCuenta+"' AND Funcion__c = 'Quien administra Plataforma'"
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state == 'SUCCESS'){
				
				var returnedValue = response.getReturnValue()[0];

				console.log(idCuenta,' Respuesta getContacts:',returnedValue);

				if(returnedValue != null || returnedValue != undefined){ 

					console.log('getContacts Hay Administrador');
														
					dataSource.ContactAdministrador.Email = (returnedValue.Email ) ? returnedValue.Email : '';
					dataSource.ContactAdministrador.Puesto__c = (returnedValue.Funcion__c) ? returnedValue.Funcion__c : '';
					dataSource.ContactAdministrador.Phone = (returnedValue.Phone ) ? returnedValue.Phone : '';
					dataSource.ContactAdministrador.Name = (returnedValue.Name ) ? returnedValue.Name : '';													

				}else{

					console.log('getContacts No existe contacto Administrador, se asigna el RL a Quien Administra.');
					
					console.log('dataSource getContacts:',dataSource);

					dataSource.ContactAdministrador.Email = (dataSource.ContactRepresentanteLegal.Email) ? dataSource.ContactRepresentanteLegal.Email : '' ;
					dataSource.ContactAdministrador.Puesto__c = (dataSource.ContactRepresentanteLegal.Funcion__c) ? dataSource.ContactRepresentanteLegal.Funcion__c : '';
					dataSource.ContactAdministrador.Phone = (dataSource.ContactRepresentanteLegal.Phone) ? dataSource.ContactRepresentanteLegal.Phone : '';
					dataSource.ContactAdministrador.Name =	(dataSource.ContactRepresentanteLegal.Name) ? dataSource.ContactRepresentanteLegal.Name : '' ;

				}

				component.set("v.dataSource", dataSource);
				
			}
		})
		$A.enqueueAction(action);
	},

	save :  function(component, dataSource){
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.updateContratoADV");
		var res;
		component.set("v.btnActionSave", true);
        
        dataSource.Opportunity.StageName = 'Implementación';

		action.setParams({
			jsonContrato: JSON.stringify(dataSource.Contrato2__c),
			jsonOportunidad: JSON.stringify(dataSource.Opportunity)
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state =='SUCCESS'){
				res=response.getReturnValue();
				if(res.Code =='0'){
					toastEvent.setParams({
						"duration": "15000",
						"type": "success",
						"title": "¡Éxito!",
						"message": res.Response
					});
				}
				else{
					toastEvent.setParams({
						"duration": "15000",
						"type": "error",
						"title": "Error",
						"message": res.Response
					});
					
				}
				toastEvent.fire();
			}
			else{
				toastEvent.setParams({
					"duration": "15000",
					"type": "warning",
					"title": "Advertencia",
					"message": "Error al guardar la informacion"
				});
				toastEvent.fire();
			}
			component.set("v.btnActionSave", false);
		})
		$A.enqueueAction(action);
		//console.log('Contrato: ',contrato.CodigoAS400__c);
	},
	aprobar : function(component,dataSource,filiales){
		var action = component.get('c.saveS400Filiales');
		console.log('Filiales SAVE:',filiales);
		action.setParams({
			jsonFiliales: JSON.stringify(filiales)
		})
		action.setCallback(this,function(response){
			var state = response.getState();
            if(state =='SUCCESS'){
                console.log('aprobar success:',response.getReturnValue());
                if(response.getReturnValue()=='Exito'){
                    //Al final guardar Contrato
                    this.aprobarContrato(component,dataSource);
                }else{
                    component.set("v.btnInactiveCheck", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();
                }
			}else{
                component.set("v.btnInactiveCheck", true);
				console.log('aprobar error:',response.getReturnValue())
			}
		});
		$A.enqueueAction(action);
	},
	aprobarContrato: function(component,dataSource){
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.updateContratoADV2");
		var res;
		var subcuent = component.get("v.subCuentas");
		

		console.log('aprobarContrato dataSource:',dataSource.Contrato2__c);
		

		component.set("v.btnActionAprobar", true);
		dataSource.Contrato2__c.EtapaContrato__c = 'Autorizado'
		dataSource.Opportunity.Estatus__c = 'Cerrada'
        dataSource.Opportunity.StageName = 'Implementación'
		dataSource.Opportunity.CodigoClienteAS400__c = dataSource.Contrato2__c.CodigoAS400__c
		dataSource.Opportunity.ComentariosADV__c = dataSource.Contrato2__c.Comentarios_ADV__c
        
        console.log('***************************************************sm '+dataSource.Opportunity.id  );

		action.setParams({
			jsonContrato: JSON.stringify(dataSource.Contrato2__c),
			jsonOportunidad: JSON.stringify(dataSource.Opportunity),
            extras:JSON.stringify(subcuent)
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state =='SUCCESS'){
				res=response.getReturnValue();
				if(res.Code =='0'){
					toastEvent.setParams({
						"duration": "15000",
						"type": "success",
						"title": "¡Éxito al aprobar contrato!",
						"message":res.Response
					});
					component.set("v.dataSource", dataSource);
					component.set("v.btnInactive", true);
					component.set("v.btnInactiveCheck", false);
                    this.generaPDF(component);
				}
				else{
					toastEvent.setParams({
						"duration": "15000",
						"type": "error",
						"title": "Error al aprobar contrato",
						"message": res.Response
					});
                    component.set("v.btnActionAprobar", false);
                	component.set("v.btnInactiveCheck", true);	
                    component.set("v.btnInactive", false);
				}
				toastEvent.fire();
                
			}
			else{
				toastEvent.setParams({
					"duration": "15000",
					"type": "warning",
					"title": "Advertencia",
					"message": "Error al guardar la informacion al aprobar contrato"
				});
				toastEvent.fire();
			}
			//component.set("v.btnActionAprobar", false);
		})
		$A.enqueueAction(action);
	},
  
    generaPDF : function(component){
       var filial=component.get("v.filialesSource",filial);
       var eL=component.get('v.entidadLegal');
       eL.Disabled = true;
       component.set('v.entidadLegal',eL);
       var generatePDFEvent = $A.get("e.c:CON_GeneratePDF_EVENT");
       generatePDFEvent.setParams({params: {filiales: filial,entidadLegal: eL}})
       generatePDFEvent.fire();
   
   }
	,
	rechazar : function(component, dataSource){
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.updateContratoADV");
		var res;
		component.set("v.btnActionRechazar", true);
        
        var motivos=component.get("v.motivosRechazoSelec");
        var textM='';
        if(motivos!=null){
            textM=motivos.join(";");
        }
        dataSource.Contrato2__c.RejectionReasons__c = textM
		dataSource.Contrato2__c.EtapaContrato__c = 'Rechazado para corrección'
		dataSource.Opportunity.Estatus__c = 'Pausada'
		dataSource.Opportunity.StageName = 'Cotización'
		console.log('***********-**_******'+dataSource.Opportunity.StageName);
		dataSource.Opportunity.EnvioCSVOPAM__c = false
		dataSource.Opportunity.EnvioXMLTC30__c = false
        dataSource.Opportunity.RejectedContract__c = true
		dataSource.Opportunity.ComentariosADV__c = dataSource.Contrato2__c.Comentarios_ADV__c
        dataSource.Opportunity.RejectionReasons__c = textM
		action.setParams({
			jsonContrato: JSON.stringify(dataSource.Contrato2__c),
			jsonOportunidad: JSON.stringify(dataSource.Opportunity)
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state =='SUCCESS'){
				res=response.getReturnValue();
				if(res.Code =='0'){
					this.updateOportunidad(component,dataSource.Opportunity)
					component.set("v.dataSource", dataSource);
					component.set("v.btnInactive", true);
					component.set("v.btnInactiveCheck", false);
				}
				else{
					toastEvent.setParams({
						"duration": "15000",
						"type": "error",
						"title": "Error al rechazar contrato",
						"message": res.Response
					});
					toastEvent.fire();
				}
				
			}
			else{
				toastEvent.setParams({
					"duration": "15000",
					"type": "warning",
					"title": "Advertencia",
					"message": "Error al guardar la informacion al rechazar contrato"
				});
				toastEvent.fire();
			}
			component.set("v.btnActionRechazar", false);
		})
		$A.enqueueAction(action);
	},

	updateOportunidad :function(component, oportunidad){
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.updateOportunidadADV");
		var res;
		component.set("v.btnActionRechazar", true);
		oportunidad.StageName = 'Cotización';
		action.setParams({
			jsonOportunidad: JSON.stringify(oportunidad)
		})
		action.setCallback(this,function(response){
			var state = response.getState();
			if(state =='SUCCESS'){
				res=response.getReturnValue();
				if(res.Code =='0'){
					toastEvent.setParams({
						"duration": "15000",
						"type": "success",
						"title": "¡Éxito al rechazar contrato!",
						"message":res.Response
					});
				}
				else{
					toastEvent.setParams({
						"duration": "15000",
						"type": "error",
						"title": "Error al rechazar contrato",
						"message": res.Response
					});
				}
				toastEvent.fire();
			}
			else{
				toastEvent.setParams({
					"duration": "15000",
					"type": "warning",
					"title": "Advertencia",
					"message": "Error al guardar la informacion al rechazar contrato"
				});
				toastEvent.fire();
			}
			component.set("v.btnActionRechazar", false);
		})
		$A.enqueueAction(action);
	},
    
    /*DVM: INICIO, 2 Julio. Para atender el requerimiento de mostrar todos los contactos con función AP en la pantalla ADV*/
    getContactosAP : function(component){
        component.set('v.columnas', [
            {label: 'Nombre', fieldName: 'Name', type: 'text'},
            {label: 'Puesto', fieldName: 'Puesto__c', type: 'text'},
            {label: 'Función', fieldName: 'Funcion__c', type: 'text'},
            {label: 'Teléfono 1', fieldName: 'Phone', type: 'phone'},
            {label: 'Teléfono 2', fieldName: 'Telefono2__c', type: 'phone'},
            {label: 'Email', fieldName: 'Email', type: 'email'}
        ]);
        
        var action = component.get("c.getContactosAP");
                      
        action.setParams({
            "idRegistro": component.get("v.oppId"),
            "nombreObjeto" : "Opportunity"
        });
        
        action.setCallback(this, function(response) {
           var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.contactosAP", response.getReturnValue());
            } 
        });
        
        $A.enqueueAction(action);
    },
    /*DVM: FIN, 2 Julio*/
    createXML : function(component){
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.generaXMLExtras");         
        action.setParams({
            "opportunityId": component.get("v.oppId"),
            "contratoId" : component.get("v.recordId"),
            "filiales" : component.get("v.filialesSource"),
            "extras" :JSON.stringify(component.get("v.subCuentas")) 
        });
        
        action.setCallback(this, function(response) {
           var state = response.getState();
            if (state == "SUCCESS") {
               toastEvent.setParams({
						"duration": "15000",
						"type": "success",
						"title": "Exito",
						"message":"¡Se generaron correctamente los XMLs!"
					});
                	 component.set("v.btnActionXML", false);
                	 component.set("v.isXML", false);
                	toastEvent.fire();
			}
            else{
                toastEvent.setParams({
						"duration": "15000",
						"type": "error",
						"title": "Error",
						"message":"¡Ocurrio un error al generar los XMLs!"
					});
                toastEvent.fire();
                component.set("v.btnActionXML", false);
            }	
        });
        $A.enqueueAction(action);
    },
    generarClientAs400 : function(component, event){
        var dat=component.get("v.dataSource");
        var toastEvent = $A.get("e.force:showToast");
        var action=component.get("c.generarClientesAs400");
        action.setParams({idContrato:dat.Contrato2__c.Id,idQli:dat.Contrato2__c.PartidaPresupuesto__c,idOpp:dat.OpportunityId});
        action.setCallback(this,function(response){
            var state=response.getState();
            console.log("ESTADO:"+state);
            if(state=='SUCCESS'){
                console.log(">>>1");
                var result=response.getReturnValue();
                console.log(">>>"+result.cliente);
                if(result.Code=='0'){
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Exito",
                        "message": "Clientes dados de alta correctamente"
                    });
                    toastEvent.fire();
                    component.set("v.clientesCompletos",true);
                    component.set("v.spinAs400",false);
                }else if(result.Code=='2'){
                    toastEvent.setParams({
                        "type": "warning",
                        "title": "Error",
                        "message": result.Response
                    });
                    toastEvent.fire();
                    component.set("v.spinAs400",false);
                }else if(result.Code=='-1'){
                    var err=result.errores;
                    var errParse=JSON.parse(err);
                    component.set('v.listaErrores',errParse);
                    component.set("v.modalErrores",!component.get("v.modalErrores"));
                    component.set("v.spinAs400",false);
                    /*toastEvent.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": result.Response
                    });
                    toastEvent.fire();*/
                }else{
                    toastEvent.setParams({
                        "type": "warning",
                        "title": "Error",
                        "message": result.Response
                    });
                    toastEvent.fire();
                    component.set("v.spinAs400",false);
                }         
            }else{
                toastEvent.setParams({
					"type": "error",
					"title": "Error",
					"message": "Error al dar de alta los clientes"
				});
				toastEvent.fire();
                component.set("v.spinAs400",false);
            }
        });
        $A.enqueueAction(action);
    }
})