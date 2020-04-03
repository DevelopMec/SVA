({
	
	mapAnnexAData : function(component, qliId) {
		debugger;
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT FormaPago__c, Product2.Name, Quote.Opportunity.Familia__c, (SELECT Concepto_Tipo_Cargo__c, PrecioFinal__c FROM Productos_Concepto__r), (SELECT Id, EtapaContrato__c FROM Contratos2__r) FROM QuoteLineItem WHERE Id = '" + qliId + "' LIMIT 1"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue()[0];
				console.log("mapAnnexAData, returnedValue:", returnedValue);
				// var fieldsToBeMapped = ["Cobro por transacción", "Cargo por envío", "Cargo por tarjeta activa", "TAG Ticket Car", "Vehiculo/Mes NFC", "Cuota por transacción con TAG", "Comisión por el servicio"];
				var dataToSave = { qli: qliId, contrato: {}, anexo: {} };
				var fieldsToBeMapped;
				if (returnedValue.Product2.Name == "Ticket Car 3.0" && returnedValue.Quote.Opportunity.Familia__c == "Combustible") {
					fieldsToBeMapped = {
						"Cobro por transacción": "Transacciones__c",
						"Cargo por envío": "CargoporEnvio__c",
						"Cargo por tarjeta activa": "CuentaActiva__c",
						"TAG Ticket Car": "Etiqueta__c",
						"Vehiculo/Mes NFC": "Mensualidad__c",
						"Cuota por transacción con TAG": "CargoTAG__c",
						"Comisión por el servicio": "Contraprestacion__c",
						"FormaPago__c": "FormaPago__c",
						"FrecuenciaFacturacion__c": "PeriodoFacturacion__c"
					};
				} else if ((returnedValue.Product2.Name == "Vale Despensas Edenred - Chip" || returnedValue.Product2.Name == "Vale Despensas Edenred -Banda") && returnedValue.Quote.Opportunity.Familia__c == "Despensa") {
					fieldsToBeMapped = {
						"Comisión por el servicio": "ComisionServicio__c",
						"Cargo por dispersión de saldo": "ComisionFijaAS__c",
						"Cuota por cuenta activa": "CuentaActiva__c",
						"Tarjeta titular": "TarjetaTitular__c",
						"Reposición de tarjetas": "ReposicionTarjeta__c",
						"Tarjeta adicional": "TarjetaAdicional__c",
						"Renovación de tarjeta": "RenovacionTarjeta__c"
					};
				} else if (returnedValue.Product2.Name == "Empresarial Edenred" && returnedValue.Quote.Opportunity.Familia__c == "Empresarial") {
					fieldsToBeMapped = {
						"Comisión por el servicio": "ComisionServicio__c",
						"Renovación de tarjeta": "EmisionTarjetas__c",
						"Reposición de tarjetas": "ReposicionTarjeta__c",
						"Cargo por envío": "EnvioTarjetas__c",
						"Cuota por implementación": "ImplementacionInscripcion__c",
						"Mensualidad del cliente": "Mensualidad__c",
						"Cuota por cuenta activa": "CuentaActiva__c"
					};
				} else {
					fieldsToBeMapped = {};
				}
				for (var typeCharge in fieldsToBeMapped) {
					returnedValue.Productos_Concepto__r.some(function(pc) {
						if (pc.Concepto_Tipo_Cargo__c == typeCharge) {
							dataToSave.anexo[fieldsToBeMapped[typeCharge]] = pc.PrecioFinal__c;
							return true;
						}
					});
				};
				if (returnedValue.FormaPago__c) {
					dataToSave.anexo["FormaPago__c"] = returnedValue.FormaPago__c;
				}
				console.log("mapAnnexAData, dataToSave:", dataToSave);
				if (returnedValue.Contratos2__r) {
					this.showContractsContainer(component, fieldsToBeMapped);
				} else {
					this.createRecords(component, dataToSave, fieldsToBeMapped);
				}
			} else {
				console.log("mapAnnexAData, state:", state);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener los datos de los concepto producto"
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
		debugger
		var showCCEvent = component.getEvent("showCC");
		showCCEvent.setParams({ "isCCVisible": true, "onlyReadAnnexAFields": fieldsToBeMapped, "hasCLR": component.get("v.hasLegalRepresentative") });
		showCCEvent.fire();
	}
})