({
	showContractsContainer: function (component, event, helper) {
		// console.clear();
		console.log(Object.keys(component.get("v.ejecutivo")), component.get("v.ejecutivo").Id, component.get("v.ejecutivo").Name, component.get("v.ejecutivo").Segmento__c);
		console.log('showContractsContainer(), event.getPrams():', JSON.parse(JSON.stringify(event.getParams())));
		var toastEvent = $A.get("e.force:showToast");
		var usr = component.get("v.ejecutivo");
		if (usr) {
			if (!usr.hasOwnProperty("Segmento__c")) {
				toastEvent.setParams({
					"duration": "10000",
					"type": "warning",
					"title": "Advertencia",
					"message": "El Propietario o la Propietaria de la Oportunidad no tiene definido el valor del campo Segmento"
				});
			}
		}
		var showCC = event.getParam("isCCVisible");
		component.set("v.isCCVisible", showCC);
		var onlyReadAnnexAFields = [];
		for (var prop in event.getParam("onlyReadAnnexAFields")) {
			onlyReadAnnexAFields.push(event.getParam("onlyReadAnnexAFields")[prop]);
		}
		console.log("showContractsContainer, onlyReadAnnexAFields:", onlyReadAnnexAFields);
		component.set("v.onlyReadAnnexAFields", onlyReadAnnexAFields);
		// component.set("v.legalRepresentativeData", event.getParam("legalRepresentativeData"));
		var qliId = component.get("v.recordId");
		helper.getInitialData(component, qliId);
		var dataToSave = { qli: qliId, contrato: {}, anexo: {} };
		component.set("v.dataToSave", dataToSave);
	},
	
	saveContractFieldValue: function (component, event, helper) {
		// Constants
		const APINAME_PERS_TARJ = 'Personalizacion_de_Tarjetas__c';
		const APINAME_DIREC_AUX = 'DireccionesAuxiliares__c';
		const LABEL_PERS_TARJ = 'Layout de Personalización de Tarjetas';
		const LABEL_DIREC_AUX = 'Layout de Direcciones Auxiliares';
		// Constants
		// console.log("saveContractFieldValue, event:", event);
		var inputChanged;
		var fieldName = "";
		var value;
		var save = true;
		var inputData = [];
		var objectsByDocument = component.get("v.objectsByDocument");
		var dataToSave = component.get("v.dataToSave");
		if (!dataToSave.hasOwnProperty("contrato")) {
			dataToSave["contrato"] = {};
		}
		if (event.getSource) {
			inputChanged = event.getSource();
			// If the type of the input field is "MULTIPICKLIST"...
			var metadataField = inputChanged.get("v.labelClass") != null ? inputChanged.get("v.labelClass") : {};
			if (metadataField.hasOwnProperty("type")) {
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
				// console.log('saveContractFieldValue(), inputChanged.get("v.value"):', inputChanged.get("v.value"));
				if (metadataField.hasOwnProperty('type') && (metadataField.type === 'MULTIPICKLIST')) {
					let tempValue = inputChanged.get('v.value');
					// console.log('saveContractFieldValue(), tempValue...:', tempValue.split(';'));
					let selectedValues = tempValue.split(';');
					// console.log('saveContractFieldValue(), selectedValues...:', selectedValues);
					if (selectedValues.length > 3) {
						// console.log('saveContractFieldValue(), selectedValues...:', selectedValues.splice(0, 3).toString());
						tempValue = selectedValues.splice(0, 3).toString().replace(/,/g, ';');
						// console.log('saveContractFieldValue(), tempValue:', tempValue);
						inputChanged.set('v.value', tempValue);
						value = tempValue;
					} else {
						tempValue = selectedValues.toString().replace(/,/g, ';');
						value = tempValue;
					}
				} else {
					value = inputChanged.get("v.value");
				}
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
					objectsByDocument.contractSections.some(function (section) {
						if (section.name == id[0]) {
							section.fields.some(function (field) {
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
					objectsByDocument.contractSections.some(function (section) {
						if (section.name == id[0]) {
							section.fields.some(function (field) {
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
		if (save && component.get("v.EtapaOportunidad")=='Contrato') { 
			dataToSave.contrato[fieldName] = value;
			if (fieldName === APINAME_PERS_TARJ) {
				component.set('v.fieldPT', { label: LABEL_PERS_TARJ, name: fieldName, value });
			}
			if (fieldName === APINAME_DIREC_AUX) {
				component.set('v.fieldDA', { label: LABEL_DIREC_AUX, name: fieldName, value });
			}
			// component.set("v.dataToSave", dataToSave);
			// console.log("saveContractFieldValue, dataToSave:", component.get("v.dataToSave"));
			component.set("v.isSaveButtonDisabled", false);
			component.set("v.isFinishButtonDisabled", true);
			component.set("v.isPDFButtonDisabled", true);
			component.set("v.isSendButtonDisabled", true);
			component.set('v.isDataSaved', false);
			// Is it a control field?
			if (inputData.length && inputData.length > 1) {
				var isControlField = inputData[1];
				var sectionName = inputData[2];
				objectsByDocument.contractSections.forEach(function (section) {
					if (section.name == sectionName) {
						// console.log("saveContractFieldValue, section.fields", section.fields);
						section.fields.forEach(function (field) {
							if (field.hasOwnProperty("controlFields")) {
								field.controlFields.forEach(function (controlField) {
									if (controlField.name == fieldName) {
										if (controlField.hasOwnProperty("isParent")) {
											controlField.values.some(function (controlFieldValue) {
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
														if (field.type === 'MULTIPICKLIST') {
															let mpFields = component.find('conMultipicklist');
															console.log('mpFields:', mpFields);
															if (mpFields) {
																if (Array.isArray(mpFields)) {
																	for (let mpField of mpFields) {
																		mpField.set('v.value', '');
																		mpField.set('v.required', false);
																	}
																} else {
																	mpFields.set('v.value', '');
																	mpFields.set('v.required', false);
																}
															}
														}
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
												if (field.type === 'MULTIPICKLIST') {
													let mpFields = component.find('conMultipicklist');
													console.log('mpFields;', mpFields);
													if (mpFields) {
														if (Array.isArray(mpFields)) {
															for (let mpField of mpFields) {
																mpField.set('v.value', '');
																mpField.set('v.required', false);
															}
														} else {
															mpFields.set('v.value', '');
															mpFields.set('v.required', false);
														}
													}
												}
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
			// component.set("v.dataToSave", dataToSave);
			var campos = component.get("v.dependetFieldsCA");
			var updatedAnnexes = component.get("v.objectsByDocument").annexes;
			var updateObj = false
			if (campos && updatedAnnexes && campos.hasOwnProperty(fieldName) && campos[fieldName].length > 0) {
				var campos2copy = {}
				campos[fieldName].forEach(function (field, index) {
					campos2copy[field] = true
				})
				updatedAnnexes.forEach(function (annex) {
					if (annex.fields && annex.fields.length > 0) {
						annex.fields.forEach(function (field) {
							if (campos2copy.hasOwnProperty(field.name)) {
								console.log('annex field:', field);
								dataToSave.anexo[field.name] = value;
								field.value = value
								updateObj = true
							}
						})
					}
				})
			}
                                            
                                            if(fieldName=='Modo_Transaccion__c'&&dataToSave.contrato&&(dataToSave.contrato['Modo_Transaccion__c']=='Virtual'||dataToSave.contrato['Modo_Transaccion__c']=='Fisico')){
                                                objectsByDocument.contractSections.forEach(function (section) {                                                    
                                                    if (section.name == sectionName) {
                                                        section.fields.forEach(function (field) {                                                        
                                                            if (dataToSave.contrato['Modo_Transaccion__c']=='Virtual'&&field.name == "Maneja_Conductores__c") {
                                                                field.value = true;
                                            					field.disabled=true;
                                                                dataToSave.contrato[field.name] = true;
                                                           }else if (dataToSave.contrato['Modo_Transaccion__c']=='Fisico'&&field.name == "TipoTag_PL__c") {
                                                                field.disabled=false;
                                                           }
                                                        });
                                                    }
                                                });
                                            	component.set("v.objectsByDocument", objectsByDocument);
                                            }else if(fieldName=='Modo_Transaccion__c'||fieldName=='Controla_Presencia_Vehiculo_NFC__c'||fieldName=='InventoryControl__c'){
                                                objectsByDocument.contractSections.forEach(function (section) {                                                    
                                                    if (section.name == sectionName) {
                                                        section.fields.forEach(function (field) {                                                        
                                                            if (field.name == "Maneja_Conductores__c") {   
                                                                field.disabled=false;
                                                           }else if(field.name == "TipoTag_PL__c"&&fieldName=='Controla_Presencia_Vehiculo_NFC__c'&&dataToSave.contrato['Controla_Presencia_Vehiculo_NFC__c']==false){
                                                            	field.disabled=true;
                                            					field.value=null;
                                                           }else if(field.name == "Provider__c"&&fieldName=='InventoryControl__c'){
                                                                if(dataToSave.contrato['InventoryControl__c']==false){
                                                                	field.disabled=true;
                                                                }else{
                                            						field.disabled=false;
                                           						}                                                            	
                                            					field.value=null;
                                                           }
                                                        });
                                                    }
                                                });
                                            	component.set("v.objectsByDocument", objectsByDocument);
                                            }
                                            
                                            
			if (updateObj) {
				var objectsByDocument = component.get("v.objectsByDocument");
				objectsByDocument.annexes = updatedAnnexes;
				component.set("v.objectsByDocument", objectsByDocument);
			}
			component.set("v.dataToSave", dataToSave);
		}
	},
	
	saveAnnexFieldValue: function (component, event, helper) {
		// console.log("saveAnnexFieldValue, event:", event);
		var inputChanged;
		var fieldName = "";
		var value;
		var save = true;
		var inputData = [];
		var objectsByDocument = component.get("v.objectsByDocument");
		var dataToSave = component.get("v.dataToSave") != null ? component.get("v.dataToSave") : {};
		if (!dataToSave.hasOwnProperty("anexo")) {
			dataToSave["anexo"] = {};
		}
		if (event.getSource) {
			inputChanged = event.getSource();
			// If the type of the input field is "MULTIPICKLIST"...
			var metadataField = inputChanged.get("v.labelClass") != null ? inputChanged.get("v.labelClass") : {};
			if (metadataField.hasOwnProperty("type")) {
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
					objectsByDocument.annexes.some(function (annex) {
						if (annex.name == id[0]) {
							annex.fields.some(function (field) {
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
					objectsByDocument.annexes.some(function (annex) {
						if (annex.name == id[0]) {
							annex.fields.some(function (field) {
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
				objectsByDocument.annexes.some(function (annex) {
					if (annex.name == id[0]) {
						annex.fields.some(function (field) {
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
		console.log("EtapaOportunidad ****************"+component.get("v.EtapaOportunidad"));
		if (save&&component.get("v.EtapaOportunidad")=='Contrato') { 
			dataToSave.anexo[fieldName] = value;
			component.set("v.dataToSave", dataToSave);
			// console.log("saveAnnexFieldValue, dataToSave:", component.get("v.dataToSave"));
			component.set("v.isSaveButtonDisabled", false);
			component.set("v.isFinishButtonDisabled", true);
			component.set("v.isPDFButtonDisabled", true);
			component.set("v.isSendButtonDisabled", true);
			component.set('v.isDataSaved', false);
			// Is it a control field?
			if (inputData.length && inputData.length > 1) {
				var isControlField = inputData[1];
				var sectionName = inputData[2];
				// console.log("saveAnnexFieldValue, isControlField:", isControlField, ", sectionName:", sectionName);
				objectsByDocument.annexes.forEach(function (section) {
					if (section.name == sectionName) {
						// console.log("saveContractFieldValue, section.fields", section.fields);
						section.fields.forEach(function (field) {
							if (field.hasOwnProperty("controlFields")) {
								field.controlFields.forEach(function (controlField) {
									if (controlField.name == fieldName) {
										if (controlField.hasOwnProperty("isParent")) {
											controlField.values.some(function (controlFieldValue) {
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
	
	validateFields: function (component, event, helper) {
		if(component.get('v.dataToSave.contrato.DireccionFiscal__c')==null||component.get('v.dataToSave.contrato.DireccionFiscal__c')==undefined||component.get('v.dataToSave.contrato.DireccionFiscal__c')==''){
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				duration: '10000',
				type: 'error',
				title: 'Campos obligatorios',
				message: 'Ingrese una dirección fiscal'
			});
			toastEvent.fire();
		}else{
			var objectsByDocument = component.get("v.objectsByDocument");
			var allFieldsCompleted = true;
			for (var objectDocument in objectsByDocument) {
				// console.log("validateFields(), objectDocument:", objectDocument);
				if (objectsByDocument.hasOwnProperty(objectDocument)) {
					objectsByDocument[objectDocument].forEach(function (sectionByObject) {
						// console.log("validateFields(), sectionByObject:", sectionByObject);
						sectionByObject.fields.forEach(function (field) {
							// console.log("validateFields(), field:", field);
							// if (field.name === 'LineasImpresionTarjeta__c') {
							// 	console.log('LineasImpresionTarjeta__c:', field);
							// }
							if ((!field.hasOwnProperty('value') || (field.value === '') || (field.value === 0)) && (field.type !== "BOOLEAN") && (field.type !== 'DATE') && !field.disabled&&field.name!='Otros_correos__c'&&field.name!='Maquila__c'&&field.name!='Tipo_Maquila__c') {
								// console.log("validateFields(), field:", field);
								if (field.type == "MULTIPICKLIST" && !field.hasOwnProperty("value") && field.hasOwnProperty('isVisible') && field.isVisible) {
									var mpFields = component.find("conMultipicklist");
									// console.log('validateFields(), mpFields:', mpFields);
									// Is an array of multipicklists?
									if ($A.util.isArray(mpFields)) {
										// console.log("validateFields(), value: ", mpFields.get("v.value"));
										mpFields.some(function(mp) {
											if (mp.get("v.labelClass").name == field.name) {
												if (mp.get("v.value") != '') {
													field.required = false;
													return true;
												} else {
													field.required = true;
													allFieldsCompleted = false;
												}
											}
											// console.log('validateFields(), field:', field);
										});
									} else {
										// console.log("validateFields(); is an object");
										// console.log("validateFields(), value: ", mpFields.get("v.value"));
										if (mpFields.get("v.value") != '') {
											field.required = false;
										} else {
											// console.log('validateFields(), i\'m in');
											field.required = true;
											allFieldsCompleted = false;
										}
										// console.log('validateFields(), field:', field);
									}
								} else {
									// console.log('i\'m in');
									if ((field.type === 'MULTIPICKLIST') && field.hasOwnProperty('value') && field.hasOwnProperty('isVisible') && field.isVisible) {
										var mpFields = component.find("conMultipicklist");
										// console.log('validateFields(), mpFields:', mpFields);
										// Is an array of multipicklists?
										if ($A.util.isArray(mpFields)) {
											// console.log("validateFields(), value: ", mpFields.get("v.value"));
											mpFields.some(function(mp) {
												if (mp.get("v.labelClass").name == field.name) {
													if (mp.get("v.value") != '') {
														field.required = false;
														return true;
													} else {
														field.required = true;
														allFieldsCompleted = false;
													}
												}
												// console.log('validateFields(), field:', field);
											});
										} else {
											// console.log("validateFields(); is an object");
											// console.log("validateFields(), value: ", mpFields.get("v.value"));
											if (mpFields.get("v.value") != '') {
												field.required = false;
											} else {
												// console.log('validateFields(), i\'m in');
												field.required = true;
												allFieldsCompleted = false;
											}
											// console.log('validateFields(), field:', field);
										}
									} else if (field.isVisible) {
										field.required = true;
										allFieldsCompleted = false;
									} else {
										field.required = false;
									}
								}
							} else {
								field.required = false;
							}
						});
					});
				}
			}
			component.set("v.objectsByDocument", objectsByDocument);
			console.log(JSON.parse(JSON.stringify(component.get('v.selectedLegalEntity'))));
			// Validating account structure fields
			if (component.get('v.selectedLegalEntity') && component.get('v.selectedLegalEntity').hasOwnProperty('Id') && component.get('v.selectedLegalEntity').Id === '') {
				component.set('v.isLERequired', true);
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					duration: '10000',
					type: 'warning',
					title: 'Advertencia',
					message: 'Seleccione una Entidad Legal y un Representante Legal'
				});
				toastEvent.fire();
				allFieldsCompleted = false;
			} else {
				component.set('v.isLERequired', false);
				if (component.get('v.selectedLegalEntity') && component.get('v.selectedLegalEntity').hasOwnProperty('mainLegalRepresentative') && component.get('v.selectedLegalEntity').mainLegalRepresentative.value === '') {
					component.set('v.isLRRequired', true);
					allFieldsCompleted = false;
				} else {
					component.set('v.isLRRequired', false);
				}
			}
			// All fields are completed
			if (allFieldsCompleted) {
				// helper.validateOppAttachmentsFAC(component);
				// helper.finalizeContract(component, allFieldsCompleted);
				helper.validateAttachments(component);
			} else {
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					duration: '10000',
					type: 'warning',
					title: 'Advertencia',
					message: 'Falta llenar algunos campos'
				});
				toastEvent.fire();
			}
		}
	},
		
	saveContractData: function (component, event, helper) {		
		component.set('v.isSaveButtonDisabled', true);
		component.set('v.isFinishButtonDisabled', false);
		component.set('v.isPDFButtonDisabled', false);
		console.log('save(), dataToSave:', JSON.stringify(component.get('v.dataToSave')));
		helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
	},
	
	generatePDF: function (component, event, helper) {
		var generatePDFEvent = $A.get("e.c:CON_GeneratePDF_EVENT");
		generatePDFEvent.fire();
		component.set("v.isPDFGenerated", true);
	},
	
	createDatepicker: function (component, event, helper) {
		var createDatePickerEvent = $A.get("e.c:CON_CreateDatepicker_EVENT");
		createDatePickerEvent.fire();
	},
	
	updateDuplicatedAnnexFields: function (component, event) {
		var annexName = event.getSource().get("v.title");
		//console.log("updateDuplicatedAnnexFields, annexName:", annexName);
		var annexFieldsToSearch = component.get("v.dataToSave").anexo;
		//console.log("updateDuplicatedAnnexFields, annexFieldsToSearch:", annexFieldsToSearch);
		var updatedAnnexes = component.get("v.objectsByDocument").annexes;
		updatedAnnexes.forEach(function (annex) {
			if (annex.name == annexName) {
				annex.fields.forEach(function (field) {
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
	
	hidePDFSpinner: function (component, event) {
		component.set("v.isPDFGenerated", false);
		component.set("v.isSendButtonDisabled", false);
	},
	
	sendEmail: function (component, event, helper) {
		component.set('v.isSending', true);
		helper.getLegalRepresentative(component, component.get('v.opportunityId'));
	},
	
	deleteLayout: function(component, event, helper) {
		'use strict';
		// Constants
		const ERROR_ORIG = 'Error en "deleteLayout()"';
		const APINAME_PERS_TARJ = 'Personalizacion_de_Tarjetas__c';
		const APINAME_DIREC_AUX = 'DireccionesAuxiliares__c';
		const CD_DIR_AUX = 'Direcciones Auxiliares';
		// Constants
		try {
			// console.log('deleteLayout(), event:', event);
			// console.log('deleteLayout(), event.getSource():', event.getSource());
			console.log('deleteLayout(), event.getParams():', JSON.parse(JSON.stringify(event.getParams())));
			let { expression, oldValue, value } = event.getParams();
			if (oldValue.value && !value.value) {
				if (value.name === APINAME_PERS_TARJ) {
					console.log('deleteLayout(), component.get(\'v.layoutPTId\'): "' + component.get('v.layoutPTId') + '"');
					if (component.get('v.layoutPTId')) {
						helper.createActionPromise(component, {
							name: 'deleteLayoutFAC',
							params: {
								attachId: component.get('v.layoutPTId')
							}
						})
						.then((response) => {
							// console.log('deleteLayout(), 1st response:', response);
							console.log('deleteLayout(), 1st response.getReturnValue():', response.getReturnValue());
							let { errors, id, isSuccess } = response.getReturnValue();
							if (isSuccess) {
								component.set('v.layoutPTId', '');
								// let toastEvent = $A.get('e.force:showToast');
								// toastEvent.setParams({
								// 	duration: '10000',
								// 	type: 'success',
								// 	title: '¡Éxito!',
								// 	message: 'El archivo ha sido eliminado correctamente'
								// });
								// toastEvent.fire();
								helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
							} else {
								return Promise.reject(new Error('Ocurrió un problema al eliminar el archivo'));
								// throw new Error('Ocurrió un problema al eliminar el archivo');
								// console.log('After reject or throw');
							}
						})
						.catch((error) => {
							// console.log('i\'m in');
							helper.showError(error, ERROR_ORIG);
						});
					} else {
						helper.createActionPromise(component, {
							name: 'executeQuery',
							params: {
								query: 'SELECT Id, Label FROM PersonalizacionTarjetas__mdt WHERE CodigoProductos__c LIKE \'%' + component.get('v.productCode') + '%\''
							}
						})
						.then((response) => {
							// console.log('deleteLayout(), 1st response:', response);
							console.log('deleteLayout(), 1st response.getReturnValue():', response.getReturnValue());
							let { Id, Label } = response.getReturnValue()[0];
							return helper.createActionPromise(component, {
								name: 'executeQuery',
								params: {
									query: 'SELECT Id, Title FROM ContentDocument WHERE Title LIKE \'' + Label + '%\' LIMIT 1'
								}
							})
						})
						.then((response) => {
							// console.log('deleteLayout(), 2nd response:', response);
							console.log('deleteLayout(), 2nd response.getReturnValue():', response.getReturnValue());
							let { Id, Title } = response.getReturnValue()[0];
							return helper.createActionPromise(component, {
								name: 'executeQuery',
								params: {
									query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.opportunityId') + '\' AND Name LIKE \'' + Title + '%\''
								}
							})
						})
						.then((response) => {
							// console.log('deleteLayout(), 3rd response:', response);
							console.log('deleteLayout(), 3rd response.getReturnValue():', response.getReturnValue());
							let defaultAttachment = { Id: '', Name: '' };
							let { Id, Name } = Object.assign({}, defaultAttachment, response.getReturnValue()[0]);
							console.log('Id: "' + Id + '";', 'Name: "' + Name + '"');
							if (Id) {
								return helper.createActionPromise(component, {
									name: 'deleteLayoutFAC',
									params: {
										attachId: Id
									}
								});
							} else {
								helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
								return Promise.reject({
									error: new Error('Fin de la cola de promesas. No hay ningún "Attachment" que eliminar'),
									isVisible: false
								});
								// let mapError = new Map();
								// mapError.set('error', new Error('Error esperado. No hay ningún "Attachment" que eliminar'));
								// mapError.set('isVisible', false);
								// return Promise.reject(mapError);
							}
						})
						.then((response) => {
							// console.log('deleteLayout(), 4th response:', response);
							console.log('deleteLayout(), 4th response.getReturnValue():', response.getReturnValue());
							let { errors, id, isSuccess } = response.getReturnValue();
							if (isSuccess) {
								component.set('v.layoutPTId', '');
								// let toastEvent = $A.get('e.force:showToast');
								// toastEvent.setParams({
								// 	duration: '10000',
								// 	type: 'success',
								// 	title: '¡Éxito!',
								// 	message: 'El archivo ha sido eliminado correctamente'
								// });
								// toastEvent.fire();
								helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
							} else {
								return Promise.reject({
									error: new Error('Ocurrió un problema al eliminar el archivo'),
									isVisible: true
								});
							}
						})
						.catch(({ error, isVisible } = { error: 'Se implmento "Promise.reject()" sin argumentos', isVisible: false }) => {
						// .catch((response) => {
							// console.log('res:', response);
							// if (response.get('isVisible')) {
							// 	helper.showError(response.get('error'), ERROR_ORIG);
							// } else {
							// 	console.log(response.get('error'));
							// }
							if (isVisible) {
								helper.showError(error, ERROR_ORIG);
							} else {
								console.log(error);
							}
						});
					}
				}
				// else if (value.name === APINAME_DIREC_AUX) {
				// 	console.log('deleteLayout(), component.get(\'v.layoutDAId\'): "' + component.get('v.layoutDAId') + '"');
				// 	if (component.get('v.layoutDAId')) {
				// 		helper.createActionPromise(component, {
				// 			name: 'deleteLayoutFAC',
				// 			params: {
				// 				attachId: component.get('v.layoutDAId')
				// 			}
				// 		})
				// 		.then((response) => {
				// 			console.log('deleteLayout(), 1st response.getReturnValue():', response.getReturnValue());
				// 			let { errors, id, isSuccess } = response.getReturnValue();
				// 			if (isSuccess) {
				// 				component.set('v.layoutDAId', '');
				// 				// let toastEvent = $A.get('e.force:showToast');
				// 				// toastEvent.setParams({
				// 				// 	duration: '10000',
				// 				// 	type: 'success',
				// 				// 	title: '¡Éxito!',
				// 				// 	message: 'El archivo ha sido eliminado correctamente'
				// 				// });
				// 				// toastEvent.fire();
				// 				helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
				// 			} else {
				// 				return Promise.reject(new Error('Ocurrió un problema al eliminar el archivo'));
				// 			}
				// 		})
				// 		.catch((error) => {
				// 			helper.showError(error, ERROR_ORIG);
				// 		});
				// 	} else {
				// 		helper.createActionPromise(component, {
				// 			name: 'executeQuery',
				// 			params: {
				// 				query: 'SELECT Id, Name FROM Attachment WHERE Name LIKE \'' + CD_DIR_AUX + '%\''
				// 			}
				// 		})
				// 		.then((response) => {
				// 			console.log('deleteLayout(), 1st response.getReturnValue():', response.getReturnValue());
				// 			let defaultAttachment = { Id: '', Name: '' };
				// 			let { Id, Name } = Object.assign({}, defaultAttachment, response.getReturnValue()[0]);
				// 			console.log('Id: "' + Id + '";', 'Name: "' + Name + '"');
				// 			if (Id) {
				// 				return helper.createActionPromise(component, {
				// 					name: 'deleteLayoutFAC',
				// 					params: {
				// 						attachId: Id
				// 					}
				// 				});
				// 			} else {
				// 				helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
				// 				return Promise.reject({
				// 					error: new Error('Fin de la cola de promesas. No hay ningún "Attachment" que eliminar'),
				// 					isVisible: false
				// 				});
				// 			}
				// 		})
				// 		.then((response) => {
				// 			console.log('deleteLayout(), 2nd response.getReturnValue():', response.getReturnValue());
				// 			let { errors, id, isSuccess } = response.getReturnValue();
				// 			if (isSuccess) {
				// 				component.set('v.layoutDAId', '');
				// 				// let toastEvent = $A.get('e.force:showToast');
				// 				// toastEvent.setParams({
				// 				// 	duration: '10000',
				// 				// 	type: 'success',
				// 				// 	title: '¡Éxito!',
				// 				// 	message: 'El archivo ha sido eliminado correctamente'
				// 				// });
				// 				// toastEvent.fire();
				// 				helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
				// 			} else {
				// 				return Promise.reject({
				// 					error: new Error('Ocurrió un problema al eliminar el archivo'),
				// 					isVisible: true
				// 				});
				// 			}
				// 		})
				// 		.catch(({ error, isVisible } = { error: 'Se implmento "Promise.reject()" sin argumentos', isVisible: false }) => {
				// 			if (isVisible) {
				// 				helper.showError(error, ERROR_ORIG);
				// 			} else {
				// 				console.log(error);
				// 			}
				// 		});
				// 	}
				// }
			}
		} catch(e) {
			helper.showError(e, ERROR_ORIG);
		}
	},
	
	saveLayoutData: function(component, event, helper) {
		helper.save(component, JSON.stringify(component.get('v.dataToSave')), true);
	}
})