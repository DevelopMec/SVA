({
	getInitialData : function(component, qliId) {
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Quote.Opportunity.Name, Quote.Opportunity.StageName, Quote.Opportunity.Account.Name, Product2.Name, Quote.Opportunity.Familia__c FROM QuoteLineItem WHERE Id = '" + qliId + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue()[0];
				console.log("VC - getInitialData, returnedValue:", returnedValue);
                console.log("VC - getInitialData, yeah:", returnedValue.Quote.Opportunity.AccountId);
                component.set('v.AccountID', returnedValue.Quote.Opportunity.AccountId);
				if (returnedValue.Quote && returnedValue.Quote.Opportunity && returnedValue.Quote.Opportunity.Account) {
					component.set("v.headerData", returnedValue);
					component.set("v.opportunityId", returnedValue.Quote.OpportunityId);
					if (returnedValue.Quote.Opportunity.StageName != 'Cotización'  ) {
						// component.set("v.isCorrectOppsStageName", true);
						this.tieneRFCs(component);
						
					} else {
						// component.set("v.isCorrectOppsStageName", false);
						// component.set("v.isNextButtonVisible", false);
						component.set('v.isDataReady', true);
                        
					}
					// this.getOppContacts(component, returnedValue.Quote.OpportunityId);
				}
			} else {
				console.log("getInitialData, state:", state);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener datos de la Oportunidad y de la Cuenta"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	getOppContacts : function(component, oppId) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Id, Contacto__r.Email, Contacto__r.Extranjero__c FROM Opportunity WHERE Id = '" + oppId + "' AND Contacto__r.Funcion__c = 'Representante Legal'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				console.log("getOppContacts, returnedValue:", returnedValue);
				if (returnedValue.length > 0) {
					if ((returnedValue.length - 1) == 0) {
						component.set("v.hasLegalRepresentative", true);
						if (returnedValue[0].Contacto__r) {
							var lrData = {};
							lrData.Id = returnedValue[0].Contacto__r.Id;
							lrData.Email = returnedValue[0].Contacto__r.Email;
							lrData.IsForeign = returnedValue[0].Contacto__r.Extranjero__c;
							component.set("v.legalRepresentativeData", lrData);
							console.log("getOppContacts, lrData:", lrData);
							// this.validateOppAttachmentsFAC(component);
							component.set("v.isDataReady", true);
						}
					} else {
						component.set("v.hasLegalRepresentative", false);
						// component.set("v.isNextButtonVisible", false);
						component.set("v.isDataReady", true);
						toastEvent.setParams({
							"duration": "10000",
							"type": "warning",
							"title": "Advertencia",
							"message": "Esta Oportunidad tiene más de un Contacto como Representante Legal"
						});
						toastEvent.fire();
					}
				} else {
					component.set("v.hasLegalRepresentative", false);
					// component.set("v.isNextButtonVisible", false);
					component.set("v.isDataReady", true);
					toastEvent.setParams({
						"mode": "sticky",
						"type": "warning",
						"title": "Advertencia",
						"message": "Para poder comprobar los documentos de la Oportunidad es necesario que esta tenga asociada un Contacto con función de Representante Legal"
					});
					toastEvent.fire();
				}
				// component.set("v.isDataReady", true);
			} else {
				console.log("getOppContacts, state:", state);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener los Contactos de la Oportunidad."
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	validateOppAttachmentsFAC : function(component) {
		var lrd = component.get("v.legalRepresentativeData");
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.validateOppAttachments");
		action.setParams({
			oppId : component.get("v.opportunityId")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				console.log("validateOppAttachmentsFAC, returnedValue:", returnedValue);
				if (returnedValue && returnedValue.relatedAccount && returnedValue.relatedAccount.Account) {
					// if (returnedValue.relatedAccount.Account.hasOwnProperty("TipoPersona__c")) {
						var documentationComplete = true;
						console.log("Documents by Type of Person:", returnedValue.docsByTypePerson[returnedValue.relatedAccount.Account.TipoPersona__c]);
						returnedValue.docsByTypePerson[returnedValue.relatedAccount.Account.TipoPersona__c].forEach(function(doc) {
							doc.loaded = false;
							returnedValue.oppAttachments.forEach(function(attachment) {
								if ((doc.apiName == "ContratoFirmado__c")) {
									doc.loaded = true;
								} else {
									if ((doc.apiName == "FM3__c") && !lrd.IsForeign) {
										doc.loaded = true;
									} else {
										if (attachment.Name.includes(doc.name)) {
											doc.loaded = true;
										}
									}
								}
							});
							if (!doc.loaded) {
								documentationComplete = false;
							}
						});
						console.log("validateOppAttachmentsFAC, documentationComplete:", documentationComplete);
						if (documentationComplete) {
							component.set("v.documentationComplete", true);
						} else {
							component.set("v.documentationComplete", false);
						}
						component.set("v.isDataReady", true);
					// } else {
					// 	toastEvent.setParams({
					// 		"duration": "10000",
					// 		"type": "warning",
					// 		"title": "Advertencia",
					// 		"message": "El campo 'Tipo de Persona' de la Cuenta de la Oportunidad no tiene un valor definido"
					// 	});
					// }
				}
			} else {
				console.log("validateOppAttachmentsFAC, state:", state);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al validar los documentos de la oportunidad"
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},
	
	mapAnnexAData : function(component, qliId) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT FormaPago__c, Product2.Name, Product2.ProductCode, Quote.Opportunity.Familia__c, Quote.Opportunity.Account.RazonSocial__c, (SELECT Concepto_Tipo_Cargo__c, PrecioFinal__c FROM Productos_Concepto__r), (SELECT Id, EtapaContrato__c FROM Contratos2__r) FROM QuoteLineItem WHERE Id = '" + qliId + "' LIMIT 1"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue()[0];
				console.log("mapAnnexAData, returnedValue:", returnedValue);
				if (returnedValue && returnedValue.Product2 && returnedValue.Quote && returnedValue.Quote.Opportunity && returnedValue.Quote.Opportunity.Account) {
					// var fieldsToBeMapped = ["Cobro por transacción", "Cargo por envío", "Cargo por tarjeta activa", "TAG Ticket Car", "Vehiculo/Mes NFC", "Cuota por transacción con TAG", "Comisión por el servicio"];
					var dataToSave = { qli: qliId, contrato: {}, anexo: {} };
					var fieldsToBeMapped;
					if (returnedValue.Product2.ProductCode == "30" && returnedValue.Quote.Opportunity.Familia__c == "Combustible") {
						fieldsToBeMapped = {
                            "Cuota de adscripción - Grande" : "CuotaAdscripcionGrande_Text__c", 
                            "Cuota de adscripción - Pyme" : "CuotaAdscripcionPyme_Text__c",
                            "Anualidad - Grande" : "AnualidadGrande_Text__c",
                            "Anualidad - Pyme" : "AnualidadPyme_Text__c",
							"Cobro por transacción": "Transacciones__c",
							"Cargo por envío": "CargoEnvio_Text__c",
							"Cargo por tarjeta activa": "CuentaActiva__c",
							"TAG Ticket Car": "Etiqueta__c",
							"Vehiculo/Mes NFC": "Mensualidad__c",
							"Cuota por transacción con TAG": "CargoTAG__c",
							"Comisión por el servicio": "ComisionServicio__c",
							"FormaPago__c": "FormaPago__c",
							"FrecuenciaFacturacion__c": "PeriodoFacturacion__c",
							"Razón Social": "NombreCliente__c",
                            "Cargo por refacturación" : "CargoRefactura__c"
						};
                    } else if((returnedValue.Product2.ProductCode == "14" || returnedValue.Product2.ProductCode == "34") && returnedValue.Quote.Opportunity.Familia__c == "Vestimenta") {
                        fieldsToBeMapped = { 
                            "Tarjeta titular / Stock": "TarjetaTitular__c",
							"Reposición de tarjetas": "ReposicionTarjeta__c",
							"Renovación de tarjeta": "RenovacionTarjeta__c",
                            "Cargo por envío": "CargoEnvio_Text__c",
							"Cargo por dispersión de saldo": "CuotaDispersion__c",
                            "Comisión por el servicio": "ComisionServicio__c",
                            "Cargo por refacturación": "CargoRefactura__c",
                            "Cuota por cuenta activa": "CuentaActiva__c",
                        };
                    } else if((returnedValue.Product2.ProductCode == "18" || returnedValue.Product2.ProductCode == "48" || returnedValue.Product2.ProductCode == "58") && returnedValue.Quote.Opportunity.Familia__c == "Regalo"){
                        fieldsToBeMapped = { 
                            "Comisión por el servicio": "ComisionServicio__c",
                            "Cargo por envío": "CargoEnvio_Text__c",
                            "Cargo por refacturación": "CargoRefactura__c",
                            "Renovación de tarjeta": "RenovacionTarjeta__c",
                            "Reposición de tarjetas": "ReposicionTarjeta__c",
                            "Tarjeta titular / Stock": "TarjetaTitular__c",
							"Cargo por dispersión de saldo": "CuotaDispersion__c",
                            "Cuota por impresión de logo a color" : "CuotaImpresionLogoColor_Text__c",
                            "Cuota por impresión de logo a una tinta" : "CuotaImpresionLogoUnaTinta_Text__c"

                        };
                    }else if ((returnedValue.Product2.ProductCode == "1" || returnedValue.Product2.ProductCode == "41" || returnedValue.Product2.ProductCode == "61" || returnedValue.Product2.ProductCode == "91" || returnedValue.Product2.ProductCode == "71" || returnedValue.Product2.ProductCode == "81") && returnedValue.Quote.Opportunity.Familia__c == "Ticket Restaurante"){
                       fieldsToBeMapped = {
                           "Razón Social": "NombreCliente__c",
                           "Comisión por el servicio": "ComisionServicio__c",
                           "Cargo por envío": "CargoEnvio_Text__c",
                           "Cargo por refacturación": "CargoRefactura__c",
                           "Cuota por cuenta activa": "CuentaActiva__c",
                           "Renovación de tarjeta": "RenovacionTarjeta__c",
                           "Tarjeta titular / Stock": "TarjetaTitular__c",
                           //"Cargo por dispersión de saldo": "ComisionFijaAS__c",
                           "Cuota por impresión de logo a una tinta" : "CuotaImpresionLogoUnaTinta_Text__c",
                           "Cuota por impresión de logo a color" : "CuotaImpresionLogoColor_Text__c",
                           "Cargo por cancelación" : "CargoCancelacion_Text__c",
                           "Cargo por ensobretado" : "CargoEnsobretado_Text__c",
                           "Reposición de tarjetas": "ReposicionTarjeta__c",
                           "Cargo por dispersión de saldo" : "CuotaDispersion__c",
                           "Cobro por transacción rechazada" : "CobroTransaccionRechazada_Text__c"
                       };

                    }else if ((returnedValue.Product2.ProductCode == "12" || returnedValue.Product2.ProductCode == "32") && returnedValue.Quote.Opportunity.Familia__c == "Despensa") {
						fieldsToBeMapped = {
							"Comisión por el servicio": "ComisionServicio__c",
							"Cargo por dispersión de saldo": "ComisionFijaAS__c",
							"Cuota por cuenta activa": "CuentaActiva__c",
							"Tarjeta titular / Stock": "TarjetaTitular__c",
							"Reposición de tarjetas": "ReposicionTarjeta__c",
							"Tarjeta adicional": "TarjetaAdicional__c",
							"Renovación de tarjeta": "RenovacionTarjeta__c",
							"Razón Social": "NombreCliente__c"
						};
					} else if (returnedValue.Product2.ProductCode == "29" && returnedValue.Quote.Opportunity.Familia__c == "Empresarial") {
						fieldsToBeMapped = {
							"Comisión por el servicio": "ComisionServicio__c",
							"Cargo por envío": "CargoEnvio_Text__c",
                            'Cargo por refacturación': 'CargoRefactura__c',
                            "Cuota por Anualidad" : "CuotaAnual__c",
                            "Cuota por cuenta activa": "CuentaActiva__c",
							"Mensualidad de cliente": "CuotaMensualidad_Text__c",
							"Renovación de tarjeta": "RenovacionTarjeta__c",
							"Reposición de tarjetas": "ReposicionTarjeta__c",
							"Tarjeta titular": "TarjetaTitular__c",
							"Cargo por dispersión de saldo": "CuotaDispersion__c",
                            "Cuota de adscripción - Grande" : "CuotaAdscripcionGrande_Text__c", 
                            "Cuota de adscripción - Pyme" : "CuotaAdscripcionPyme_Text__c",
							"Cuota por implementación": "CuotaImplementacion_Text__c",
							"Razón Social": "NombreCliente__c"
                            

						};
					} else if (((returnedValue.Product2.ProductCode == "60-D") || (returnedValue.Product2.ProductCode == "60-M") || (returnedValue.Product2.ProductCode == "60-P")) && returnedValue.Quote.Opportunity.Familia__c == "Combustible") {
						fieldsToBeMapped = {
							"Razón Social": "NombreCliente__c",
                            "Comisión por el servicio": "ComisionServicio__c",
                            "Cuota por Inscripción" : "CuotaInscripcion_Text__c",
                            "Reposición de tarjetas": "ReposicionTarjeta__c",
                            "Tarjeta titular": "TarjetaTitular__c"
						};
					} /*else if (((returnedValue.Product2.ProductCode == "41") || (returnedValue.Product2.ProductCode == "51") || (returnedValue.Product2.ProductCode == "61") || (returnedValue.Product2.ProductCode == "71") || (returnedValue.Product2.ProductCode == "81") || (returnedValue.Product2.ProductCode == "91") || (returnedValue.Product2.ProductCode == "18") || (returnedValue.Product2.ProductCode == "38") || (returnedValue.Product2.ProductCode == "48") || (returnedValue.Product2.ProductCode == "58") || (returnedValue.Product2.ProductCode == "14") || (returnedValue.Product2.ProductCode == "34")) && ((returnedValue.Quote.Opportunity.Familia__c == "Ticket Restaurante") || (returnedValue.Quote.Opportunity.Familia__c == "Regalo") || (returnedValue.Quote.Opportunity.Familia__c == "Vestimenta"))) {
						fieldsToBeMapped = {
							"Razón Social": "NombreCliente__c"
						};
					}*/ else if (((returnedValue.Product2.ProductCode == "39") || (returnedValue.Product2.ProductCode == "39-C")) && (returnedValue.Quote.Opportunity.Familia__c == "Ayuda Social")) {
						fieldsToBeMapped = {
                            "Comisión por el servicio": "ComisionServicio__c",
							"Cargo por envío": "CargoEnvio_Text__c",
							"Razón Social": "NombreCliente__c",
                            "Cuota por Anualidad" : "CuotaAnual__c",
                            "Cuota por cuenta activa": "CuentaActiva__c",
                            "Cuota por mensualidad" : "CuotaMensualidad_Text__c",
							"Renovación de tarjeta": "RenovacionTarjeta__c",
							"Reposición de tarjetas": "ReposicionTarjeta__c",
							"Tarjeta titular": "TarjetaTitular__c",
							"Cargo por dispersión de saldo": "CuotaDispersion__c",
                            "Cuota de adscripción - Grande" : "CuotaAdscripcionGrande_Text__c", 
                            "Cuota de adscripción - Pyme" : "CuotaAdscripcionPyme_Text__c",
                            "Cuota por implementación" : "CuotaImplementacion_Text__c"
						};
					} else if (((returnedValue.Product2.ProductCode == "52-C") || (returnedValue.Product2.ProductCode == "62-C") || (returnedValue.Product2.ProductCode == "69-C")) && returnedValue.Quote.Opportunity.Familia__c == "Despensa") {
						fieldsToBeMapped = {
                            "Comisión por el servicio": "ComisionServicio__c",
                            "Cobro por transacción rechazada" : "CobroTransaccionRechazada_Text__c",
                            "Reposición de tarjetas": "ReposicionTarjeta__c",
                            "Tarjeta adicional": "TarjetaAdicional__c",
                            "Tarjeta titular / Stock": "TarjetaTitular__c",
                            "Cargo por dispersión de saldo": "CuotaDispersion__c",
							"Razón Social": "NombreCliente__c",
                            "Cuota por cuenta activa" : "CuentaActiva__c"
						};
					} else if (returnedValue.Product2.ProductCode == "9" && returnedValue.Quote.Opportunity.Familia__c == "Despensa") {
						fieldsToBeMapped = {
							"Comisión por el servicio": "ComisionServicio__c"
						};
					} else if ((returnedValue.Product2.ProductCode == "3") && (returnedValue.Quote.Opportunity.Familia__c == "Combustible")) {
						fieldsToBeMapped = {
							"Razón Social": "NombreCliente__c",
                            "Comisión por el servicio": "ComisionServicio__c"
						};
					} else if ((returnedValue.Product2.ProductCode == '31') && (returnedValue.Quote.Opportunity.Familia__c == 'Mantenimiento')) {
						fieldsToBeMapped = {
							'FrecuenciaFacturacion__c': 'PeriodoFacturacion__c',
							'DepositoOperacional__c': 'MontoDO__c',
							'Cargo por refacturación': 'CargoRefactura__c',
							'Fijo por vehículo': 'FijoVehiculo__c',
							'Renta de plataforma': 'RentaPlataforma__c',
							'Razón Social': 'NombreCliente__c',
							'FormaPago__c': 'FormaPago__c'
						};
					} else {
						fieldsToBeMapped = {};
					}
					console.log('mapAnnexAData(), returnedValue.Productos_Concepto__r:', returnedValue.Productos_Concepto__r);
					for (let typeCharge in fieldsToBeMapped) {
						returnedValue.Productos_Concepto__r.some(function(pc) {
							if (pc.Concepto_Tipo_Cargo__c == typeCharge) {
								dataToSave.anexo[fieldsToBeMapped[typeCharge]] = pc.PrecioFinal__c; //Verificar para vigencia 
								return true;
							}
						});
					}
					if (returnedValue.FormaPago__c) {
						dataToSave.anexo["FormaPago__c"] = returnedValue.FormaPago__c;
					}
					if (returnedValue.Quote.Opportunity.Account.hasOwnProperty("RazonSocial__c")) {
						dataToSave.anexo["NombreCliente__c"] = returnedValue.Quote.Opportunity.Account.RazonSocial__c;
					}
					// this.createRecords(component, dataToSave, fieldsToBeMapped);
					console.log("mapAnnexAData, dataToSave:", dataToSave);
					/*if (returnedValue.Contratos2__r) {
						this.showContractsContainer(component, fieldsToBeMapped);
					} else {
						this.createRecords(component, dataToSave, fieldsToBeMapped);
					}*/
					if (returnedValue.hasOwnProperty("Contratos2__r") && returnedValue.Contratos2__r[0].hasOwnProperty("EtapaContrato__c") && (returnedValue.Contratos2__r[0].EtapaContrato__c == "Finalizado")) {
						console.log("Contract Stage:", returnedValue.Contratos2__r[0].EtapaContrato__c);
						this.showContractsContainer(component, fieldsToBeMapped);
					} else {
						console.log("Creating records...");
						this.createRecords(component, dataToSave, fieldsToBeMapped);
					}
				} else {
					toastEvent.setParams({
						"duration": "10000",
						"type": "error",
						"title": "Error",
						"message": "La Partida de Presupuesto no tiene asociado un Producto, una Cotización, una Oportunidad o una Cuenta"
					});
					toastEvent.fire();
				}
			} else {
				console.log("mapAnnexAData, state:", state);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener los datos de la Partida de Presupuesto"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	createRecords : function(component, dataToSave, fieldsToBeMapped) {
		var action = component.get("c.guardaContrato");
		action.setParams({
			strData: JSON.stringify(dataToSave)
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				console.log("createRecords, returnedValue:", returnedValue);
				this.showContractsContainer(component, fieldsToBeMapped);
			} else {
				console.log("createRecords, state:", state);
				let toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al guardar los datos"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	showContractsContainer : function(component, fieldsToBeMapped) {
		var showCCEvent = component.getEvent("showCC");
		// showCCEvent.setParams({ "isCCVisible": true, "onlyReadAnnexAFields": fieldsToBeMapped, "legalRepresentativeData": component.get("v.legalRepresentativeData") });
		showCCEvent.setParams({ "isCCVisible": true, "onlyReadAnnexAFields": fieldsToBeMapped });
		showCCEvent.fire();
	},
    
    tieneRFCs : function(component) {
        var action = component.get("c.getEntidadCuenta");
        var idA=component.get("v.AccountID");
        action.setParams({
			AccountIs: idA
		});
		
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
                console.log("**************yeah* "+returnedValue);
                if(returnedValue){
                    component.set("v.isDataReady", true);
                	component.set("v.leyenda", "Es necesario generar una entidad legal (RFC) a la cuenta, antes de crear el contrato.");
                }else{
                    component.set("v.isDataReady", false);
                    this.mapAnnexAData(component, component.get("v.recordId"));
                }
                    
			}
		});
		$A.enqueueAction(action);
	}
 
})