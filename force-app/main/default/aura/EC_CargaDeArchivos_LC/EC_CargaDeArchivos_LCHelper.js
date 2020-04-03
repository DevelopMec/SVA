({
	/* uploadA: function(component, file, fileContents,attachmentName,oppFieldName, attachmentId, insertFile) {
		//var MAX_FILE_SIZE_B: 4 500 000; // 6 000 000 * 3/4 to account for base64
		var CHUNK_SIZE = 1000000; // Use a multiple of 4
		var fromPos = 0;
		console.log('antes Math.min');
		var toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);
		console.log('despues Math.min;',toPos);
		// uploadA(component, uploadedFile, fileContents, 'test', 'test', attachmentId, true);
		// start with the initial chunk
		this.uploadChunk(component, file, fileContents, fromPos, toPos, attachmentId, attachmentName, oppFieldName, insertFile);
	}, */
	
	// uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId,attachmentName,oppFieldName) {
	/* uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId, attachmentName, oppFieldName, insertFile) {

		console.log('\n\nuploadChunk: ', component, fromPos, toPos, attachId, attachmentName, oppFieldName);
		var CHUNK_SIZE = 1000000;
			// var action = component.get("c.saveTheChunk"); 
			var action = component.get("c.saveAttachmentMultipart"); 
			var chunk = fileContents.substring(fromPos, toPos);

			var toastEvent = $A.get("e.force:showToast");

		//  console.log('entro uploadChunk');
		// 	console.log('oppFieldName:',oppFieldName);
		// 	console.log('attachmentName:',attachmentName);
				
		// 	console.log('file:',file);
		// 	console.log('attachId:',attachId);

	// Id parentId, String attachmentName, String attachmentBody, String elFieldName, Id attchId, Boolean insertFile, String contentType
			
			action.setParams({
					parentId: component.get("v.recordId"),
					attachmentName: attachmentName + '.pdf',
					attachmentBody: chunk, 
					elFieldName: oppFieldName,
					attchId: attachId,
					insertFile: insertFile,
					contentType: file.type,
			});
			// action.setParams({
			// 		parentId: component.get("v.recordId"),
			// 		fileName: attachmentName,
			// 		base64Data: encodeURIComponent(chunk), 
			// 		contentType: file.type,
			// 		fileId: attachId,
			// 		elFieldName:oppFieldName,
			// });
			
			action.setCallback(this, function(a) {
					
				var state = a.getState();
					
					if( state == "SUCCESS" ) {
			
			console.log('responsegetReturnValue: ', a.getReturnValue());
							// attachId = a.getReturnValue();
							attachId = a.getReturnValue().Attachment_Id;

							console.log('result attachId: ', attachId)
							
							fromPos = toPos;
							toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);

							if (fromPos < toPos) {
									this.uploadChunk(component, file, fileContents, fromPos, toPos, attachId, attachmentName, oppFieldName, false);  

							} else {

									var value = attachId;
									var documents = component.get("v.documents");
									
									attachmentName = attachmentName.replace(/_/g, " ");				
									
									for (var i = 0; i < documents.length; i++) {
											if(attachmentName.indexOf('FM3') != -1){
													attachmentName = 'Formula Migratoria 3';
											}
											if (documents[i].name == attachmentName) {
													
													documents[i].loaded = true;
													documents[i].Id = value;
													break;
											}
									}
									
									//console.log("saveAttachmentFAC, documents:", documents);
									component.set("v.documents", documents);
									
									component.set("v.loading", false);
									
									toastEvent.setParams({
											"duration": "1000",
											"type": "success",
											"title": "¡Éxito!",
											"message": "El archivo '" + attachmentName + "' ha sido guardado correctamente"
									});
									
									toastEvent.fire();
									
									this.changeELStatus(component,documents,attachmentName);
								
						}
					} if( state == "ERROR" ){
									
							component.set("v.loading", false);
							toastEvent.setParams({
									"duration": "1000",
									"type": "Error",
									"title": "Error",
									"message": "Error al cargar archivo"
							});
							
							toastEvent.fire();
					}
					
			});
					
			$A.enqueueAction(action); 
			
	}, */
	
	getContacts : function(component) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_getForeignContact");

		action.setParams({
			elId: component.get("v.recordId")
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {

				var value = response.getReturnValue();

				console.log('Valor Contacto Extranjero:',value);
				component.set('v.foreignContact',value);

			} else {

				var msgs = this.errorMessage(response);

				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});

				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},

	getRecordTypeEL : function(component) {
		
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_getRelatedAccountInformation");
		
		action.setParams({
			elId: component.get("v.recordId")
		});
		
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				
				var value = response.getReturnValue();
				
				//console.log("EC_getRelatedAccountInformation, value:", value);
				console.log("RecordType, value.RecordType.Name:", value.RecordType.Name);
				
				component.set("v.typeOfPerson", value.RecordType.Name);
				// this.getDocsByTypePersonFAC(component, relatedAccount.TipoPersona__c);
				//this.getContactLegalRepresentativeEL(component, value.RecordType.Name, component.get("v.recordId"));
				this.getDocsByTypePersonEL(component, value.RecordType.Name);
				
			} else {
				
				var msgs = this.errorMessage(response);
				
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
				
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},	
	
	getDocsByTypePersonEL : function(component, typePerson) {
		
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_getDocsByTypePerson");
		var foreignContact = component.get('v.foreignContact');
		
		/*action.setParams({
			docType: typePerson
		});*/
		action.setCallback(this, function(response) {
			
			var state = response.getState();
			
			if (state == "SUCCESS") {
				
				var value = response.getReturnValue();
				//console.log("EC_getDocsByTypePerson, value:", value);
				//var naturalPersonDocuments = value["Persona Física"];
				//var legalPersonDocuments = value["Persona Moral"];
				//console.log("getTiposDocumentoFAC, naturalPersonDocuments:", naturalPersonDocuments);
				//console.log("getTiposDocumentoFAC, legalPersonDocuments:", legalPersonDocuments);
				
				//console.log('EC_getDocsByTypePerson RecordType.Name:',typePerson);
				
				var documentNames = value[typePerson+' EL'];
				var documents = [];
				
				console.log('EC_getDocsByTypePerson documentNames:',documentNames);
				
				documentNames.forEach(function(document) {
					
					if (document.apiName == 'FM3__c') {
						if (foreignContact == true) {
							
							document.isVisible = true;
							document.loaded = false;
							documents.push(document);
							
						}
					}else{
						document.isVisible = true;
						document.loaded = false;
						documents.push(document);
					}
					
				});
				
				//console.log("getDocsByTypePersonFAC, documents:", documents);
				
				component.set("v.documents", documents);
				// this.getAttachmentsEL(component);
				this.getAttachmentsEL2(component);
				
			} else {
				
				var msgs = this.errorMessage(response);
				
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},
	
	/* getAttachmentsEL : function(component) {

		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_getAttachments");

		action.setParams({
			elId: component.get("v.recordId"),
		});

		action.setCallback(this, function(response) {

			var state = response.getState();

			if (state == "SUCCESS") {

				var value = response.getReturnValue();				
				var documents = component.get("v.documents");

				for (var i = 0; i < documents.length; i++) {
					for (var j = 0; j < value.length; j++) {

						value[j].Name = value[j].Name.replace(/_/g, " ");
						console.log(documents[i].name+'.pdf = '+value[j].Name);

						if(value[j].Name.indexOf('FM3') != -1){
							value[j].Name = 'Formula Migratoria 3.pdf';
						}

						if ((documents[i].name + ".pdf") == value[j].Name) {

							documents[i].loaded = true;
							documents[i].Id = value[j].Id;
						}
					}
				}

				var statusEL = false;

				for (var x = 0; x < documents.length; x++) {
					
					if (!documents[x].Id) {
						
						statusEL = true;
						break;
					}
				}

				if(!statusEL){
					component.set("v.readOnly", true);
				}

				console.log("EC_getAttachments, documents:", documents);
				component.set("v.documents", documents);

			} else {
				
				var msgs = this.errorMessage(response);

				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	}, */
	
	getAttachmentsEL2 : function(component) {
		
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_getAttachments2");
		
		action.setParams({
			elId: component.get("v.recordId"),
		});
		
		action.setCallback(this, function(response) {
			
			var state = response.getState();
			
			if (state == "SUCCESS") {
				
				var value = response.getReturnValue();
				var documents = component.get("v.documents");
				
				console.log('getAttachmentsEL2(), value:', value);
				console.log('getAttachmentsEL2(), documents value:', documents);
				
				for (var i = 0; i < documents.length; i++) {
					for (var j = 0; j < value.length; j++) {
						
						value[j].ContentDocument.Title = value[j].ContentDocument.Title.replace(/_/g, " ");
						console.log('getAttachmentsEL2(), ' + documents[i].name+'.pdf = '+value[j].ContentDocument.Title);
						
						if(value[j].ContentDocument.Title.indexOf('FM3') != -1){
							value[j].ContentDocument.Title = 'Formula Migratoria 3.pdf';
						}
						
						if (documents[i].name == value[j].ContentDocument.Title) {
							
							documents[i].loaded = true;
							documents[i].Id = value[j].ContentDocumentId;
							// documents[i].ContentDocumentId = value[j].ContentDocumentId;
						}
					}
				}
				
				var statusEL = false;
				
				for (var x = 0; x < documents.length; x++) {
					
					if (!documents[x].Id) {
						
						statusEL = true;
						break;
					}
				}
				
				if(!statusEL){
					component.set("v.readOnly", true);
				}
				
				console.log("getAttachmentsEL2(), documents:", documents);
				component.set("v.documents", documents);
				
			} else {
				
				var msgs = this.errorMessage(response);
				
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},
	
	updateAttachmentEL : function(component, attachmentId, attachmentBody) {

		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_updateAttachment");

		action.setParams({
			attachmentId: attachmentId,
			attachmentBody: attachmentBody
		});

		action.setCallback(this, function(response) {

			var state = response.getState();

			if (state == "SUCCESS") {
				//console.log("Entré EC_updateAttachment");
				component.set("v.loading", false);

				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo ha sido actualizado correctamente"
				});

			} else {
				
				var msgs = this.errorMessage(response);

				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});

			}
			toastEvent.fire();
			$A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action);
	},
	
	/* deleteAttachmentEL : function(component, attachmentId, elFieldName) {

		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_deleteAttachment");

		action.setParams({
			attachmentId: attachmentId,
			elId: component.get("v.recordId"),
			elFieldName: elFieldName
		});

		action.setCallback(this, function(response) {

			console.log(response);

			var state = response.getState();
			var attachmentName = '';

			if (state == "SUCCESS") {
				//var value = response.getReturnValue();
				var documents = component.get("v.documents");

				for (var i = 0; i < documents.length; i++) {

					if (documents[i].Id == attachmentId) {
						attachmentName = documents[i].name;
						documents[i].loaded = false;
						documents[i].Id = "";
						break;

					}
				}

				//console.log("deleteAttachmentFAC, documents:", documents);
				component.set("v.documents", documents);
				component.set("v.loading", false);

				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo ha sido eliminado correctamente"
				});

				this.entidadLegalEstatus(component,'Incompleta');

			} else {
				
				var msgs = this.errorMessage(response);

				component.set("v.loading", false);
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});

			}
			toastEvent.fire();
			//$A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action);
	}, */
	
	deleteAttachmentEL2 : function(component, attachmentId, elFieldName) {
		
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_deleteAttachment2");
		
		action.setParams({
			attachmentId: attachmentId,
			elId: component.get("v.recordId"),
			elFieldName: elFieldName
		});
		
		action.setCallback(this, function(response) {
			
			console.log(response);
			
			var state = response.getState();
			var attachmentName = '';
			
			if (state == "SUCCESS") {
				//var value = response.getReturnValue();
				var documents = component.get("v.documents");
				
				for (var i = 0; i < documents.length; i++) {
					
					if (documents[i].Id == attachmentId) {
						attachmentName = documents[i].name;
						documents[i].loaded = false;
						documents[i].Id = "";
						// documents[i].ContentDocumentId = "";
						break;
						
					}
				}
				
				//console.log("deleteAttachmentFAC, documents:", documents);
				component.set("v.documents", documents);
				component.set("v.loading", false);
				
				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo ha sido eliminado correctamente"
				});
				
				this.entidadLegalEstatus(component,'Incompleta');
				
			} else {
				
				var msgs = this.errorMessage(response);
				
				component.set("v.loading", false);
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
				
			}
			toastEvent.fire();
			//$A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action);
	},
	
	saveAttachmentEL2 : function(component, attId, attachmentName, elFieldName) {
		
		console.log('entro saveAttachmentEL2!');
		
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_saveAttachment2");
		
		console.log('despues de action');
		
		action.setParams({
			elId: component.get("v.recordId"),
			attId: attId,
			attachmentName: attachmentName,
			elFieldName: elFieldName
		});
		
		console.log('despues de action.setParams');
		
		action.setCallback(this, function(response) {
			//console.log('Respuesta save:',response);
			var state = response.getState();
			var documents = [];
			
			if (state == "SUCCESS") {
				
				component.set("v.loading", false);
				// attachmentName = attachmentName.replace(/_/g, " ");
				
				/*var value = response.getReturnValue();
				documents = component.get("v.documents");
				
				attachmentName = attachmentName.replace(/_/g, " ");
				
				for (var i = 0; i < documents.length; i++) {
					if(attachmentName.indexOf('FM3') != -1){
						attachmentName = 'Formula Migratoria 3';
					}
										console.log(documents[i].name+' = '+attachmentName+' value:'+value);
					if (documents[i].name == attachmentName) {
						
						documents[i].loaded = true;
						documents[i].Id = value;
						break;
					}
				}
				
				
				component.set("v.documents", documents);
				
				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo '" + attachmentName + "' ha sido guardado correctamente"
				});
				
				this.changeELStatus(component,documents,attachmentName);*/

				// setear Completa ó Incompleta
				// var _this = this
				// var documentosCargados = component.get('c.EC_getAttachments2');
				// documentosCargados.setParams({ elId: component.get("v.recordId") })
				// ctcLightning.aura( documentosCargados, component, this)
				// .then( $A.getCallback( function( res ) {
    //                 console.log('result records EC_getAttachments2: ', res )
    //                 var docs = []
    //                 if( res && res.length > 0 ) {
    //                 	for( var docr of res ) {
    //                 		var doc = {Id: docr.Id}
    //                 		doc.name = docr.ContentDocument && docr.ContentDocument.Title ? docr.ContentDocument.Title : ''
    //                 		docs.push(doc)
    //                 	}
    //                 	_this.changeELStatus(component, docs, attachmentName);
    //                 }

    //             })).catch( $A.getCallback( function( err ) {
    //             	console.log('error EC_getAttachments2: ', err)

    //         	}))
    			this.changeELStatus(component,documents,attachmentName);
				
				$A.get('e.force:showToast')
					.setParams({
						duration: '10000',
						type: 'success',
						title: '¡Éxito!',
						message: 'El archivo ha sido cargado correctamente'
					})
					.fire();
				
				this.getAttachmentsEL2(component);
				
			} else {
				
				var msgs = this.errorMessage(response);
				
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
			}
			toastEvent.fire();
			
			/*$A.get("e.force:refreshView").fire();*/
		});
		$A.enqueueAction(action);
	},
	
	/* saveAttachmentEL : function(component, attachmentName, attachmentBody, elFieldName) {

		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.EC_saveAttachment");

		// if(attachmentName.indexOf('Migratoria') != -1){
		// 	attachmentName = 'FM3';
		// }

		action.setParams({
			elId: component.get("v.recordId"),
			attachmentName: attachmentName,
			attachmentBody: attachmentBody,
			elFieldName: elFieldName
		});

		 action.setCallback(this, function(response) {
			//console.log('Respuesta save:',response);
			var state = response.getState();
			var documents;

			if (state == "SUCCESS") {

				component.set("v.loading", false);
				
				var value = response.getReturnValue();
				documents = component.get("v.documents");

				attachmentName = attachmentName.replace(/_/g, " ");

				

				for (var i = 0; i < documents.length; i++) {
					if(attachmentName.indexOf('FM3') != -1){
						attachmentName = 'Formula Migratoria 3';
					}
					if (documents[i].name == attachmentName) {
						
						documents[i].loaded = true;
						documents[i].Id = value;
						break;
					}
				}
				
				//console.log("saveAttachmentFAC, documents:", documents);
				component.set("v.documents", documents);

				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo '" + attachmentName + "' ha sido guardado correctamente"
				});

				this.changeELStatus(component,documents,attachmentName);

			} else {

				var msgs = this.errorMessage(response);

				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
			}
			toastEvent.fire();
			
			// $A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action);
	}, */
	
	changeELStatus: function(component,documents,attachmentName){
		var toastEvent = $A.get("e.force:showToast");
		var statusEL = false;

		var typeOfPerson = component.get("v.typeOfPerson");

		console.log(typeOfPerson,'entro changeELStatus',attachmentName);		

		for (var x = 0; x < documents.length; x++) {
								
			if(typeOfPerson == 'Persona Moral'){

				if (!documents[x].Id) {
				
					if(((documents[x].name.indexOf('Registro Patronal') != -1 )) || (documents[x].name.indexOf('Formula Migratoria 3') != -1 )){

						console.log('Moral No obligatorio:',documents[x].name);

					}else{					
						
							statusEL = true;
							console.log('Moral Obligatorio:',documents[x].name,':statusEL:',statusEL);
							break;
						
					}
				}
							
			}else{

				if(documents[x].name.indexOf('CURP') !=-1 ){

					console.log('Fisicado No obligatorio:',documents[x].name);
					
				}else{
					
					if (!documents[x].Id) {
						
						statusEL = true;
						console.log('Fisicado Obligatorio:',documents[x].name,':statusEL:',statusEL);
						break;
					}
				}

			}
		}				
				
		

		console.log('statusEL:',statusEL,':valida documents:',documents);

		if(!statusEL){

			this.entidadLegalEstatus(component,'Completa');

		}else{
			
			$A.get("e.force:refreshView").fire();

		}

		
	},
	
	entidadLegalEstatus : function(component,estatus){
		var toastEvent = $A.get("e.force:showToast");
		var action2 = component.get("c.EC_updateStatus");
		action2.setParams({
			elId: component.get("v.recordId"),
			status: ''+estatus
		});

		action2.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {

				component.set("v.readOnly", true);

				console.log('Respuesta changeELStatus:',response.getReturnValue());

				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El estatus de la entidad Legal a sido cambiado a: "+estatus
				});

			} else {

				var msgs = this.errorMessage(response);

				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": msgs
				});
			}
			toastEvent.fire();
			$A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action2);
	},
	
	errorMessage : function (response){
		var errors = response.getError()
		var msgs = ''
		console.log("error confirmRemove: ", errors)
		if( errors && errors[0] && errors[0].pageErrors ) {
			for( var error of errors[0].pageErrors ) {
				msgs += error.message  
			}
		}

		return msgs;
	}
})