({
	/* getAccountInformation: function(component) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.getRelatedAccountInformation");
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				// console.log("getAccountInformation, value:", value);
				var relatedAccount = value.Account;
				if (value.Account) {
					if (value.Account.hasOwnProperty("TipoPersona__c")) {
						// console.log("getAccountInformation, relatedAccount.TipoPersona__c:", relatedAccount.TipoPersona__c);
						component.set("v.typeOfPerson", relatedAccount.TipoPersona__c);
						// this.getDocsByTypePersonFAC(component, relatedAccount.TipoPersona__c);
						this.getContactLegalRepresentativeFAC(component, relatedAccount.TipoPersona__c, component.get("v.recordId"));
					}
				}
			} else {
				console.log("getAccountInformation, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": "Hubo un problema al obtener los datos de la cuenta relacionada"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	}, */
	
	getContactLegalRepresentativeFAC: function(component, typePerson, oppId) {
		var action = component.get("c.getContactLegalRepresentative");
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				// console.log("getContactLegalRepresentativeFAC, returnedValue:", returnedValue);
				var alerts = component.get("v.alerts");
				if ((returnedValue != null) && (returnedValue.length > 0)) {
					var clp = {};
					if ((returnedValue.length - 1) == 0) {
						component.set("v.isForeign", true);
						clp.description = "";
						clp.isVisible = false;
					} else {
						component.set("v.isForeign", false);
						clp.description = "Esta Oportunidad tiene más de un Contacto como Representante Legal";
						clp.isVisible = true;
					}
				}
				alerts.push(clp);
				component.set("v.alerts", alerts);
				this.getDocsByTypePersonFAC(component, typePerson);
			} else {
				console.log("getContactLegalRepresentativeFAC, state:", state);
			}
		});
		$A.enqueueAction(action);
	},
	
	getDocsByTypePersonFAC: function(component, typePerson) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.getDocsByTypePerson");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				console.log("getDocsByTypePersonFAC, value:", value);
				//var naturalPersonDocuments = value["Persona Física"];
				//var legalPersonDocuments = value["Persona Moral"];
				//console.log("getTiposDocumentoFAC, naturalPersonDocuments:", naturalPersonDocuments);
				//console.log("getTiposDocumentoFAC, legalPersonDocuments:", legalPersonDocuments);
				var documentNames = value[typePerson];
				var documents = [];
				documentNames.forEach(function(document) {
					if (document.apiName == 'FM3__c') {
						if (component.get("v.isForeign")) {
							document.isVisible = true;
						} else {
							document.isVisible = false;
						}
					} else {
						document.isVisible = true;
					}
					document.loaded = false;
					documents.push(document);
				});
				// console.log("getDocsByTypePersonFAC, documents:", documents);
				component.set("v.documents", documents);
				this.getOppAttachmentsFAC(component);
			} else {
				console.log("getTiposDocumentoFAC, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": "Hubo un problema al obtener los datos de la configuración personalizada \"TiposDocumento__c\""
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},
	
	getOppAttachmentsFAC: function(component) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.getOppAttachments");
		action.setParams({
			oppId: component.get("v.recordId"),
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				// console.log("getOppAttachmentsFAC, value:", value);
				var documents = component.get("v.documents");
				for (var i = 0; i < documents.length; i++) {
					for (var j = 0; j < value.length; j++) {
						if ((documents[i].name + ".pdf") == value[j].Name) {
							documents[i].loaded = true;
							documents[i].Id = value[j].Id;
						}
					}
				}
				// console.log("getOppAttachmentsFAC, documents:", documents);
				component.set("v.documents", documents);
			} else {
				console.log("getOppAttachmentsFAC, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": "Hubo un problema al obtener los archivos adjuntos de la opportunidad"
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},
	
	updateAttachmentFAC: function(component, attachmentId, attachmentBody) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.updateAttachment");
		action.setParams({
			attachmentId: attachmentId,
			attachmentBody: attachmentBody
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				//console.log("Entré");
				component.set("v.loading", false);
				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo ha sido actualizado correctamente"
				});
			} else {
				console.log("updateAttachmentFAC, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": "Hubo un problema al actualizar el archivo"
				});
			}
			toastEvent.fire();
			$A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action);
	},
	
	/* deleteAttachmentFAC: function(component, attachmentId, oppFieldName) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.deleteAttachment");
		action.setParams({
			attachmentId: attachmentId,
			oppId: component.get("v.recordId"),
			oppFieldName: oppFieldName
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				//var value = response.getReturnValue();
				var documents = component.get("v.documents");
				for (var i = 0; i < documents.length; i++) {
					if (documents[i].Id == attachmentId) {
						documents[i].loaded = false;
						documents[i].Id = "";
						break;
					}
				}
				console.log("deleteAttachmentFAC, documents:", documents);
				component.set("v.documents", documents);
				component.set("v.loading", false);
				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo ha sido eliminado correctamente"
				});
			} else {
				console.log("deleteAttachmentFAC, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": "Hubo un problema al eliminar el archivo"
				});
			}
			toastEvent.fire();
			$A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action);
	}, */
	
	/* saveAttachmentFAC: function(component, attachmentName, attachmentBody, oppFieldName) {
		var action = component.get("c.saveAttachment");
		action.setParams({
			oppId: component.get("v.recordId"),
			attachmentName: attachmentName,
			attachmentBody: attachmentBody,
			oppFieldName: oppFieldName
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				component.set("v.loading", false);
				var value = response.getReturnValue();
				var documents = component.get("v.documents");
				for (var i = 0; i < documents.length; i++) {
					if (documents[i].name == attachmentName) {
						documents[i].loaded = true;
						documents[i].Id = value;
						break;
					}
				}
				console.log("saveAttachmentFAC, documents:", documents);
				component.set("v.documents", documents);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"duration": "1000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "El archivo '" + attachmentName + "' ha sido guardado correctamente"
				});
				toastEvent.fire();
			} else {
				console.log("saveAttachmentFAC, state:", state, response.getError());
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"duration": "1000",
					"type": "error",
					"title": "Error",
					"message": "Hubo un problema al guardar el archivo '" + attachmentName + "'"
				});
				toastEvent.fire();
			}
			$A.get("e.force:refreshView").fire();
		});
		$A.enqueueAction(action);
	}, */
	
	handleDocAndOppUpdate: function(component, response, newTitle) {
		let { errors, id, isSuccess } = response.getReturnValue();
		// Does updating the name was successful?
		if (isSuccess) {
			// Updating the list of documents in the client...
			let documents = component.get('v.documents');
			for (let i = 0; i < documents.length; i++) {
				if (documents[i].name == newTitle) {
					documents[i].loaded = true;
					documents[i].Id = id;
					break;
				}
			}
			console.log('documents: ', documents);
			component.set('v.documents', documents);
			$A.get('e.force:refreshView').fire();
		} else {
			$A.get('e.force:showToast')
				.setParams({
					duration: '10000',
					type: 'error',
					title: 'Error',
					message: 'Ocurrió un problema al actualizar el nombre del archivo: ' + errors
				})
				.fire();
		}
	},
	
	createActionPromise: function(component, action) {
		return new Promise($A.getCallback((resolve, reject) => {
			let { name, params } = action;
			let a = component.get('c.' + name);
			a.setParams(params);
			a.setCallback(this, response => {
				console.log(`helper.createActionPromise(), action: ${name}, response.getState(): ${response.getState()}`);
				if (response.getState() === 'SUCCESS') {
					let returnedValue = response.getReturnValue();
					if (!('exceptionTypeName' in returnedValue)) {
						resolve(response);
					} else {
						reject(new Error(`Error en "helper.createActionPromise()": ${returnedValue.message}, Rastreo de Pila: ${returnedValue.stackTraceString}`));
					}
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(a);
		}));
	}
})