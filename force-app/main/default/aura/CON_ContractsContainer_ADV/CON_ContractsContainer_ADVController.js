({
	showContractsContainer : function(component, event, helper) {
		var showCC = event.getParam("isCCVisible");
		component.set("v.isCCVisible", showCC);
		var onlyReadAnnexAFields = [];
		for (var prop in event.getParam("onlyReadAnnexAFields")) {
			onlyReadAnnexAFields.push(event.getParam("onlyReadAnnexAFields")[prop]);
		}
		console.log("onlyReadAnnexAFields:", onlyReadAnnexAFields);
		component.set("v.onlyReadAnnexAFields", onlyReadAnnexAFields);
		var qliId = component.get("v.recordId");
		helper.getInitialData(component, qliId);
		var dataToSave = { qli: qliId, contrato: {}, anexo: {} };
		component.set("v.dataToSave", dataToSave);
	},
	
	saveContractFieldValue : function(component, event, helper) {
		// console.log("saveContractFieldValue, event:", event);
		var inputChanged;
		var fieldName = "";
		var value;
		var save = true;
		var inputData = [];
		var objectsByDocument = component.get("v.objectsByDocument");
		var dataToSave = component.get("v.dataToSave");
		if (dataToSave && !dataToSave.hasOwnProperty("contrato")) {
			dataToSave["contrato"] = {};
		}
		if (event.getSource) {
			inputChanged = event.getSource();
			// If the type of the input field is "MULTIPICKLIST"...
			var metadataField = inputChanged.get("v.labelClass") != null ? inputChanged.get("v.labelClass") : { };
			if (metadataField && metadataField.hasOwnProperty("type")) {
				if (metadataField.type == "MULTIPICKLIST" || metadataField.type == "DATE") {
					inputData = inputChanged.get("v.label").split("-");
					// console.log("saveContractFieldValue, inputData:", inputData);
					fieldName = metadataField.name;
				}
			} else {
				inputData = inputChanged.get("v.name").split("-");
				// console.log("saveContractFieldValue, inputData:", inputData);
				fieldName = inputData[0];
			}
			// Check the type of the input field to determine the way to obtain its value
			if (inputChanged.get("v.type") && (inputChanged.get("v.type") == "checkbox")) {
				value = inputChanged.get("v.checked");
			} else {
				value = inputChanged.get("v.value");
			}
		} else {
			// console.log("saveContractFieldValue, event:", event);
			if (event.type == "change") {
				fieldName = event.target.name;
				var tempValue = event.target.value;
				var re = /([0-9]{2}|[0-9]{1})\/([0-9]{2}|[0-9]{1})\/[0-9]{4}/;
				// console.log("saveContractFieldValue, value.match(re):", tempValue.match(re));
				var id = event.target.id;
				id = id.split("-");
				// console.log("saveContractFieldValue, id:", id);
				if (tempValue.match(re)) {
					objectsByDocument.contractSections.some(function(section) {
						if (section.name == id[0]) {
							section.fields.some(function(field) {
								if (field.name == id[1]) {
									// console.log("field:", field);
									field.required = false;
									field.value = tempValue;
									return true;
								}
							});
							return true;
						}
					});
					component.set("v.objectsByDocument", objectsByDocument);
					save = true;
					var aux = tempValue.split("/");
					value = aux[2] + "-" + aux[1] + "-" + aux[0];
				} else {
					objectsByDocument.contractSections.some(function(section) {
						if (section.name == id[0]) {
							section.fields.some(function(field) {
								if (field.name == id[1]) {
									// console.log("field:", field);
									field.required = true;
									return true;
								}
							});
							return true;
						}
					});
					component.set("v.objectsByDocument", objectsByDocument);
					save = false;
				}
			} else {
				fieldName = event.name;
				var aux = event.value.split("/");
				value = aux[2] + "-" + aux[1] + "-" + aux[0];
			}
			// console.log("saveContractFieldValue, fieldName:", fieldName, ", value:", value);
		}
		if (save) {
			dataToSave.contrato[fieldName] = value;
			// component.set("v.dataToSave", dataToSave);
			// console.log("saveContractFieldValue, dataToSave:", component.get("v.dataToSave"));
			component.set("v.isSaveButtonDisabled", false);
			component.set("v.isFinishButtonDisabled", true);
			component.set("v.isPDFButtonDisabled", true);
			// Is it a control field?
			if (inputData.length && inputData.length > 1) {
				var isControlField = inputData[1];
				var sectionName = inputData[2];
				objectsByDocument.contractSections.forEach(function(section) {
					if (section.name == sectionName) {
						// console.log("saveContractFieldValue, section.fields", section.fields);
						section.fields.forEach(function(field) {
							if (field && field.hasOwnProperty("controlFields")) {
								field.controlFields.forEach(function(controlField) {
									if (controlField.name == fieldName) {
										if (controlField && controlField.hasOwnProperty("isParent")) {
											controlField.values.some(function(controlFieldValue) {
												// console.log("value:", value, "controlFieldValue:", controlFieldValue);
												// console.log("saveContractFieldValue, field.hasOwnProperty(\"isParent\"):", field);
												if (controlFieldValue == value) {
													field.isVisible = true;
													return true;
												} else {
													field.isVisible = false;
													if (field.type == "STRING" || field.type == "PICKLIST" || field.type == "MULTIPICKLIST") {
														field.value = "";
														dataToSave.contrato[field.name] = "";
													} else if (field.type == "BOOLEAN") {
														field.value = false;
														dataToSave.contrato[field.name] = false;
													} else if ((field.type == "DOUBLE") || (field.type == "PERCENT")) {
														field.value = 0;
														dataToSave.contrato[field.name] = 0;
													}
												}
											});
										} else {
											// console.log("saveContractFieldValue, field:", field);
											field.isVisible = false;
											if ((field.type == "STRING") || (field.type == "PICKLIST") || (field.type == "MULTIPICKLIST")) {
												field.value = "";
												dataToSave.contrato[field.name] = "";
											} else if (field.type == "BOOLEAN") {
												field.value = false;
												dataToSave.contrato[field.name] = false;
											} else if ((field.type == "DOUBLE") || (field.type == "PERCENT")) {
												field.value = 0;
												dataToSave.contrato[field.name] = 0;
											}
										}
									}
								})
							}
						});
					}
				});
				component.set("v.objectsByDocument", objectsByDocument);
			}
			component.set("v.dataToSave", dataToSave);
			var campos = component.get("v.dependetFieldsCA");
			var updatedAnnexes = component.get("v.objectsByDocument").annexes;
			var updateObj = false
			if( campos && updatedAnnexes && campos.hasOwnProperty(fieldName) && campos[fieldName].length > 0 ) {
				var campos2copy = {}
				campos[fieldName].forEach( function( field, index ) {
					campos2copy[field] = true
				})
				updatedAnnexes.forEach( function( annex ) {
					if( annex.fields && annex.fields.length > 0 ) {
						annex.fields.forEach( function( field ) {
							if(campos2copy && campos2copy.hasOwnProperty(field.name) ) {
								field.value = value
								updateObj = true
							}
						})
					}
				})
			}
			if( updateObj ) {
				var objectsByDocument = component.get("v.objectsByDocument");
				component.set("v.objectsByDocument", objectsByDocument);
			}
		}
	},
	
	saveAnnexFieldValue : function(component, event, helper) {
		// console.log("saveAnnexFieldValue, event:", event);
		var inputChanged;
		var fieldName = "";
		var value;
		var save = true;
		var inputData = [];
		var objectsByDocument = component.get("v.objectsByDocument");
		var dataToSave = component.get("v.dataToSave") != null ? component.get("v.dataToSave") : { };
		if (dataToSave && !dataToSave.hasOwnProperty("anexo")) {
			dataToSave["anexo"] = {};
		}
		if (event.getSource) {
			inputChanged = event.getSource();
			// If the type of the input field is "MULTIPICKLIST"...
			var metadataField = inputChanged.get("v.labelClass") != null ? inputChanged.get("v.labelClass") : { };
			if (metadataField && metadataField.hasOwnProperty("type")) {
				if (metadataField.type == "MULTIPICKLIST" || metadataField.type == "DATE") {
					inputData = inputChanged.get("v.label").split("-");
					// console.log("saveAnnexFieldValue, inputData:", inputData);
					fieldName = metadataField.name;
				}
			} else {
				inputData = inputChanged.get("v.name").split("-");
				// console.log("saveAnnexFieldValue, inputData:", inputData);
				fieldName = inputData[0];
			}
			// Check the type of the input field to determine the way to obtain its value
			if (inputChanged.get("v.type") && (inputChanged.get("v.type") == "checkbox")) {
				value = inputChanged.get("v.checked");
			} else {
				value = inputChanged.get("v.value");
			}
			// Check the validity of the email input field
			// console.log(inputChanged.get("v.validity"));
			// console.log("saveAnnexFieldValue, value:", value);
		} else {
			// console.log("saveAnnexFieldValue, event:", event);
			var id = [];
			if (event.type == "change") {
				// console.log("saveAnnexFieldValue, event.type:", event.type);
				fieldName = event.target.name;
				var tempValue = event.target.value;
				// console.log("saveAnnexFieldValue, tempValue:", tempValue);
				var re = /([0-9]{2}|[0-9]{1})\/([0-9]{2}|[0-9]{1})\/[0-9]{4}/;
				// console.log("saveAnnexFieldValue, value.match(re):", tempValue.match(re));
				id = event.target.id;
				id = id.split("-");
				// console.log("saveAnnexFieldValue, id:", id);
				if (tempValue.match(re)) {
					objectsByDocument.annexes.some(function(annex) {
						if (annex.name == id[0]) {
							annex.fields.some(function(field) {
								if (field.name == id[1]) {
									console.log("true, field:", field);
									field.required = false;
									field.value = tempValue;
									return true;
								}
							});
							return true;
						}
					});
					component.set("v.objectsByDocument", objectsByDocument);
					save = true;
					var aux = tempValue.split("/");
					value = aux[2] + "-" + aux[1] + "-" + aux[0];
				} else {
					objectsByDocument.annexes.some(function(annex) {
						if (annex.name == id[0]) {
							annex.fields.some(function(field) {
								if (field.name == id[1]) {
									// console.log("false, field:", field);
									field.required = true;
									return true;
								}
							});
							return true;
						}
					});
					component.set("v.objectsByDocument", objectsByDocument);
					save = false;
				}
			} else {
				// console.log("saveAnnexFieldValue, event.type:", event.type);
				fieldName = event.name;
				var aux = event.value.split("/");
				value = aux[2] + "-" + aux[1] + "-" + aux[0];
				id = event.id.split("-");
				objectsByDocument.annexes.some(function(annex) {
					if (annex.name == id[0]) {
						annex.fields.some(function(field) {
							if (field.name == id[1]) {
								// console.log("false, field:", field);
								field.required = false;
								field.value = event.value;
								return true;
							}
						});
						return true;
					}
				});
				component.set("v.objectsByDocument", objectsByDocument);
			}
			// console.log("saveAnnexFieldValue, fieldName:", fieldName, ", value:", value);
		}
		if (save) {
			dataToSave.anexo[fieldName] = value;
			component.set("v.dataToSave", dataToSave);
			// console.log("saveAnnexFieldValue, dataToSave:", component.get("v.dataToSave"));
			component.set("v.isSaveButtonDisabled", false);
			component.set("v.isFinishButtonDisabled", true);
			component.set("v.isPDFButtonDisabled", true);
			// Is it a control field?
			if (inputData.length && inputData.length > 1) {
				var isControlField = inputData[1];
				var sectionName = inputData[2];
				// console.log("saveAnnexFieldValue, isControlField:", isControlField, ", sectionName:", sectionName);
				objectsByDocument.annexes.forEach(function(section) {
					if (section.name == sectionName) {
						// console.log("saveContractFieldValue, section.fields", section.fields);
						section.fields.forEach(function(field) {
							if (field.hasOwnProperty("controlFields")) {
								field.controlFields.forEach(function(controlField) {
									if (controlField.name == fieldName) {
										if (controlField.hasOwnProperty("isParent")) {
											controlField.values.some(function(controlFieldValue) {
												// console.log("value:", value, "controlFieldValue:", controlFieldValue);
												// console.log("saveContractFieldValue, field.hasOwnProperty(\"isParent\"):", field);
												if (controlFieldValue == value) {
													field.isVisible = true;
													return true;
												} else {
													field.isVisible = false;
													if (field.type == "STRING" || field.type == "PICKLIST" || field.type == "MULTIPICKLIST") {
														field.value = "";
														dataToSave.anexo[field.name] = "";
													} else if (field.type == "BOOLEAN") {
														field.value = false;
														dataToSave.anexo[field.name] = false;
													} else if ((field.type == "DOUBLE") || (field.type == "PERCENT")) {
														field.value = 0;
														dataToSave.anexo[field.name] = 0;
													}
												}
											});
										} else {
											// console.log("saveContractFieldValue, field:", field);
											field.isVisible = false;
											if ((field.type == "STRING") || (field.type == "PICKLIST") || (field.type == "MULTIPICKLIST")) {
												field.value = "";
												dataToSave.anexo[field.name] = "";
											} else if (field.type == "BOOLEAN") {
												field.value = false;
												dataToSave.anexo[field.name] = false;
											} else if ((field.type == "DOUBLE") || (field.type == "PERCENT")) {
												field.value = 0;
												dataToSave.anexo[field.name] = 0;
											}
										}
									}
								})
							}
						});
					}
				});
				component.set("v.objectsByDocument", objectsByDocument);
			}
		}
	},
	
	validateFields : function(component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		var objectsByDocument = component.get("v.objectsByDocument");
		var allFieldsCompleted = true;
		for (var objectDocument in objectsByDocument) {
			// console.log("validateFields, objectDocument:", objectDocument);
			if (objectsByDocument.hasOwnProperty(objectDocument)) {
				objectsByDocument[objectDocument].forEach(function(sectionByObject) {
					// console.log("validateFields, sectionByObject:", sectionByObject);
					sectionByObject.fields.forEach(function(field) {
						// console.log("validateFields, field:", field);
						if ((!field.hasOwnProperty("value") || field.value == '' || field.value == 0) && field.type != "BOOLEAN" && !field.disabled) {
							// console.log("validateFields, field:", field);
							if (field.isVisible) {
								field.required = true;
								allFieldsCompleted = false;
							} else {
								field.required = false;
							}
						} else {
							field.required = false;
						}
					});
				});
			}
		}
		component.set("v.objectsByDocument", objectsByDocument);
		if (allFieldsCompleted) {
			// for (var objectDocument in objectsByDocument) {
			// 	if (objectsByDocument.hasOwnProperty(objectDocument)) {
			// 		objectsByDocument[objectDocument].forEach(function(sectionByObject) {
			// 			sectionByObject.fields.forEach(function(field) {
			// 				field.disabled = true;
			// 			});
			// 		});
			// 	}
			// }
			// component.set("v.objectsByDocument", objectsByDocument);
			// var dataToSave = component.get("v.dataToSave");
			// dataToSave.finalizar = "finalizar";
			// // Insert new contract stage and value for the new validation field here
			// console.log(JSON.stringify(dataToSave));
			// helper.save(component, JSON.stringify(dataToSave));
			// component.set("v.isFinishButtonDisabled", true);
			helper.validateOppAttachmentsFAC(component);
		} else {
			toastEvent.setParams({
				"duration": "1000",
				"type": "warning",
				"title": "Advertencia",
				"message": "Falta llenar algunos campos"
			});
			toastEvent.fire();
		}
	},
	
	saveContractData : function(component, event, helper) {
		component.set("v.isSaveButtonDisabled", true);
		component.set("v.isFinishButtonDisabled", false);
		component.set("v.isPDFButtonDisabled", false);
		var dataToSave = component.get("v.dataToSave");
		console.log(JSON.stringify(dataToSave));
		helper.save(component, JSON.stringify(dataToSave));
	},
	
	generatePDF : function(component, event, helper) {
		var generatePDFEvent = $A.get("e.c:CON_GeneratePDF_EVENT");
		generatePDFEvent.fire();
		component.set("v.isPDFGenerated", true);
	},
	
	createDatepicker : function(component, event, helper) {
		var createDatePickerEvent = $A.get("e.c:CON_CreateDatepicker_EVENT");
		createDatePickerEvent.fire();
	},
	
	updateDuplicatedAnnexFields : function(component, event) {
		var annexName = event.getSource().get("v.title");
		//console.log("updateDuplicatedAnnexFields, annexName:", annexName);
		var annexFieldsToSearch = component.get("v.dataToSave").anexo;
		//console.log("updateDuplicatedAnnexFields, annexFieldsToSearch:", annexFieldsToSearch);
		var updatedAnnexes = component.get("v.objectsByDocument").annexes;
		updatedAnnexes.forEach(function(annex) {
			if (annex.name == annexName) {
				annex.fields.forEach(function(field) {
					for (var fieldToSearch in annexFieldsToSearch) {
						if (fieldToSearch == field.name) {
							//console.log("field:", field);
							if (field.type == "DATE") {
								var aux = annexFieldsToSearch[fieldToSearch].split("-");
								field.value = aux[2] + "/" + aux[1] + "/" + aux[0];
							} else {
								field.value = annexFieldsToSearch[fieldToSearch];
							}
						}
					}
				});
			}
		});
		// console.log("updatedAnnexes:", updatedAnnexes);
		var objectsByDocument = component.get("v.objectsByDocument");
		component.set("v.objectsByDocument", objectsByDocument);
	},
	
	navigateToRecord : function(component, event) {
		if (!event.getSource) {
			// console.log("event:", event, event.target.id);
			var navEvent = $A.get("e.force:navigateToSObject");
			navEvent.setParams({
				"recordId": event.target.id
			});
			navEvent.fire();
		}
	},
	
	hidePDFSpinner : function(component, event) {
		// console.log("hidePDFSpinner, event:", event);
		component.set("v.isPDFGenerated", false);
	},
	
	sendEmail : function(component, event, helper) {
		helper.getContactLegalRepresentative(component);
	},
	downloadAttachmentDireccionAux : function(component, event, helper) {
		// var url = location.href;
		// console.log("downloadAttachment, url:", url);
		var pressedButton = event.getSource();
		var attachmentId = pressedButton.get("v.name");
		//var urlEvent = $A.get("e.force:navigateToURL");
        
        console.log('entro a downloadAttachmentDireccionAux');
        console.log('attachmentId:',attachmentId);

		//urlEvent.setParams({
		//	"url": "../servlet/servlet.FileDownload?file=" + attachmentId
		//});
		window.open("../servlet/servlet.FileDownload?file=" + attachmentId);
        //console.log('urlParams:',urlEvent);
		//urlEvent.fire();
	}
})