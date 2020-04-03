({
	getInitialData : function(component, qliId) {
		const CON_CLI_MAN= 'Contrato Clientes Mantenimiento';
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Product2.Name, Product2.ProductCode, Quote.Opportunity.Familia__c, Quote.Opportunity.StageName, (SELECT Id, EtapaContrato__c FROM Contratos2__r), (SELECT Id FROM Anexos__r), Quote.Opportunity.Name, Quote.Opportunity.Account.Name, Quote.Opportunity.Account.TipoPersona__c, Quote.Opportunity.Account.Sector__c, FormaPago__c, Quote.Opportunity.VentaTradeMarketing_PL__c, Quote.Opportunity.Maquila__c, Quote.Opportunity.Maquilador__c  FROM QuoteLineItem WHERE Id = '" + qliId + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			var toastEvent1 = $A.get("e.force:showToast");
			if (state == "SUCCESS") {
                var returnedValue = response.getReturnValue()[0] || {} ;
				console.log("CC - getInitialData, returnedValue:", returnedValue);
				component.set("v.maquila",returnedValue.Quote.Opportunity.Maquila__c);
				component.set("v.maquilador",returnedValue.Quote.Opportunity.Maquilador__c);

				// Does the QuoteLineItem have a Contract record?
				if (returnedValue && returnedValue.hasOwnProperty("FormaPago__c")) {
					component.set("v.qliFormaPago", returnedValue.FormaPago__c);
				}
				if (returnedValue.Contratos2__r) {
					component.set("v.isThereContractRecord", true);
					var dataToSave = component.get("v.dataToSave");
					dataToSave.contrato["Id"] = returnedValue.Contratos2__r[0].Id;
					var currentContractStage = returnedValue.Contratos2__r[0].EtapaContrato__c;
					component.set("v.currentContractStage", currentContractStage);
					// Does the QuoteLineItem have an Annex record?
					if (returnedValue.Anexos__r) {
						dataToSave.anexo["Id"] = returnedValue.Anexos__r[0].Id;
					}
					component.set("v.dataToSave", dataToSave);
				}
				// Does the QuoteLineItem have Quote, Opportunity, and Account records?
				var toastEvent2 = $A.get("e.force:showToast");
				if (returnedValue.Product2 && returnedValue.Quote && returnedValue.Quote.Opportunity && returnedValue.Quote.Opportunity.Account) {
					component.set("v.opportunityId", returnedValue.Quote.OpportunityId);
					component.set("v.accountId", returnedValue.Quote.Opportunity.AccountId);
					component.set("v.quoteId", returnedValue.QuoteId);
					component.set("v.productCode", returnedValue.Product2.ProductCode);
                    component.set("v.ventaTradeMarketing", returnedValue.Quote.Opportunity.VentaTradeMarketing_PL__c); //DVM 3 Julio, para el requerimiento de asignación de OT Trade Marketing
					// Is the Opportunity's StageName equal to "Alta de Cliente"?
					if (returnedValue.Quote.Opportunity.StageName == "Alta de cliente") {
						component.set("v.isFinishButtonDisabled", true);
					}
					var headerData = returnedValue;
					component.set("v.headerData", headerData);
					// Does the QuoteLineItem have a valid Product's Name and Opportunity's family?
					if ((returnedValue.Product2.ProductCode == "30" || returnedValue.Product2.ProductCode == "30-B" || returnedValue.Product2.ProductCode == "30-S" || returnedValue.Product2.ProductCode == "30-E" || returnedValue.Product2.ProductCode == "30-G") && returnedValue.Quote.Opportunity.Familia__c == "Combustible") {
						component.set("v.contractTitle", "Contrato Ticket Car 3.0");
						this.getContractTemplates(component, "Contrato Ticket Car 3.0");
					} else if(returnedValue.Product2.ProductCode == "30-TC4" && returnedValue.Quote.Opportunity.Familia__c == "Combustible"){
                        component.set("v.contractTitle", "Contrato Ticket Car 4.0");
						this.getContractTemplates(component, "Contrato Ticket Car 4.0");
                    } else if ((returnedValue.Product2.ProductCode == "12" || returnedValue.Product2.ProductCode == "32" || returnedValue.Product2.ProductCode == "32-CH" || returnedValue.Product2.ProductCode == "32-W") && returnedValue.Quote.Opportunity.Familia__c == "Despensa") {
						component.set("v.contractTitle", "Contrato Vale Despensas Edenred");
						if (returnedValue.Product2.ProductCode == "12") {
							this.getContractTemplates(component, "Contrato Vale Despensas Edenred -Banda");
						} else if (returnedValue.Product2.ProductCode == "32") {
							this.getContractTemplates(component, "Contrato Vale Despensas Edenred - Chip");
						}
						this.getContractTemplates(component, "Contrato Vale Despensas Edenred");
					} else if (returnedValue.Product2.ProductCode == "29" && returnedValue.Quote.Opportunity.Familia__c == "Empresarial") {
						component.set("v.contractTitle", "Contrato Empresarial Edenred");
						this.getContractTemplates(component, "Contrato Empresarial Edenred");
					} else if (((returnedValue.Product2.ProductCode == "60-D") || (returnedValue.Product2.ProductCode == "60-M") || (returnedValue.Product2.ProductCode == "60-P")) && returnedValue.Quote.Opportunity.Familia__c == "Combustible") {
						component.set("v.contractTitle", "Contrato Clientes Ecovale Combustible");
						this.getContractTemplates(component, "Contrato Clientes ECOVALE combustible");
					} else if (((returnedValue.Product2.ProductCode == "41") || (returnedValue.Product2.ProductCode == "51") || (returnedValue.Product2.ProductCode == "61") || (returnedValue.Product2.ProductCode == "71") || (returnedValue.Product2.ProductCode == "81") || (returnedValue.Product2.ProductCode == "91") || (returnedValue.Product2.ProductCode == "18") || (returnedValue.Product2.ProductCode == "38") || (returnedValue.Product2.ProductCode == "48") || (returnedValue.Product2.ProductCode == "48-CH") || (returnedValue.Product2.ProductCode == "48-W") || (returnedValue.Product2.ProductCode == "58") || (returnedValue.Product2.ProductCode == "14") || (returnedValue.Product2.ProductCode == "34")) && ((returnedValue.Quote.Opportunity.Familia__c == "Ticket Restaurante") || (returnedValue.Quote.Opportunity.Familia__c == "Regalo") || (returnedValue.Quote.Opportunity.Familia__c == "Vestimenta"))) {
						component.set("v.contractTitle", "Contrato Clientes Multiproducto");
						this.getContractTemplates(component, "Contrato Clientes Multiproducto");
					} else if (((returnedValue.Product2.ProductCode == "39") || (returnedValue.Product2.ProductCode == "39-C")) && (returnedValue.Quote.Opportunity.Familia__c == "Ayuda Social")) {
						if (returnedValue && returnedValue.Quote && returnedValue.Quote.Opportunity && returnedValue.Quote.Opportunity.Account && returnedValue.Quote.Opportunity.Account.hasOwnProperty("Sector__c")) {
							console.log("getInitialData, returnedValue.Quote.Opportunity.Account.Sector__c:", returnedValue.Quote.Opportunity.Account.Sector__c);
							if (returnedValue.Quote.Opportunity.Account.Sector__c == "Privado") {
								component.set("v.contractTitle", "Contrato Clientes TPlus Privado");
								this.getContractTemplates(component, "Contrato Plus Edenred Banda");
							} else if (returnedValue.Quote.Opportunity.Account.Sector__c == "Público") {
								component.set("v.contractTitle", "Contrato Clientes TPlus Público");
								this.getContractTemplates(component, "Contrato Plus Edenred Chip");
							} else {
								console.log("La Cuenta de esta Oportunidad no tiene seleccionado algún valor del campo Sector");
							}
						} else {
							console.log("La Cuenta de esta Oportunidad no tiene definido el valor del campo Sector");
						}
					} else if (((returnedValue.Product2.ProductCode == "52-C") || (returnedValue.Product2.ProductCode == "62-C") || (returnedValue.Product2.ProductCode == "69-C")) && returnedValue.Quote.Opportunity.Familia__c == "Despensa") {
						component.set("v.contractTitle", "Contrato Ecovale Despensa");
						this.getContractTemplates(component, "Contrato Clientes ECOVALE Despensa");
					} else if (((returnedValue.Product2.ProductCode == "1") || (returnedValue.Product2.ProductCode == "9")) && ((returnedValue.Quote.Opportunity.Familia__c == "Ticket Restaurante") || (returnedValue.Quote.Opportunity.Familia__c == "Despensa"))) {
						component.set("v.contractTitle", "Contrato Clientes TVBE Papel");
						this.getContractTemplates(component, "Contrato Clientes TVBE Papel");
					} else if ((returnedValue.Product2.ProductCode == "3") && (returnedValue.Quote.Opportunity.Familia__c == "Combustible")) {
						component.set("v.contractTitle", "Contrato Clientes TV Combustible Papel");
						this.getContractTemplates(component, "Contrato Clientes TV Combustible Papel");
					}else if ((returnedValue.Product2.ProductCode == '31') && (returnedValue.Quote.Opportunity.Familia__c == 'Mantenimiento')) {
						component.set('v.contractTitle', CON_CLI_MAN);
						this.getContractTemplates(component, CON_CLI_MAN);
					} else {
						toastEvent2.setParams({
							"duration": "10000",
							"type": "warning",
							"title": "Advertencia",
							"message": "Actualmente el nombre del Producto o la familia de la Oportunidad no tienen asociada una plantilla"
						});
						toastEvent2.fire();
						component.set("v.isDataReady", true);
					}
				} else {
					toastEvent2.setParams({
						"duration": "10000",
						"type": "warning",
						"title": "Advertencia",
						"message": "No existe una Cotización, Oportunidad o Cuenta asociada a esta Partida de Presupuesto"
					});
					toastEvent2.fire();
				}
			} else {
				console.log("getInitialData, state:", state);
				toastEvent1.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener los datos relacionados con la Partida de Presupuesto"
				});
				toastEvent1.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	getContractTemplates : function(component, contractName) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Id, Name, CampoControl__c FROM PlantillaContrato__c WHERE Name LIKE '" + contractName + "%'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				console.log("getContractTemplates, response.getReturnValue():", response.getReturnValue());
				var returnedValue = response.getReturnValue()[0];
				/*var returnedValue = {};
				// console.log("getContractTemplates, returnedValue:", returnedValue);
				if (component.get("v.contractTitle") == "Contrato Vale Despensas Edenred") {
					var headerData = component.get("v.headerData");
					response.getReturnValue().some(function(template) {
						if (template.Name.includes(headerData.Product2.Name)) {
							returnedValue = template;
							return true;
						}
					});
				} else {
					returnedValue = response.getReturnValue()[0];
				}*/
				if (returnedValue.CampoControl__c) {
					var dependentFieldsBySObject = JSON.parse(returnedValue.CampoControl__c);
					// console.log("getContractTemplates, dependentFieldsBySObject:", dependentFieldsBySObject);
					component.set("v.dependentFieldsBySObject", dependentFieldsBySObject);
				}
				console.log("getContractTemplates, returnedValue:", returnedValue);
				// this.getSectionsByTemplate(component, returnedValue.Name);
				this.getFieldsBySObjects(component, returnedValue.Name);
			} else {
				console.log("getContractTemplates, state:", state);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener las plantillas del contrato"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	// getFieldsBySObjects : function(component, fieldsBySections, allFieldsBySObject) {
	getFieldsBySObjects : function(component, templateName) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.describeSObjects");
		action.setParams({
			objs: ["Contrato2__c", "PlantillaContrato__c", "Anexo__c"]
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				console.log("getFieldsBySObjects, returnedValue:", returnedValue);
				
				this.getSectionsByTemplate(component, templateName, returnedValue);
				
			} else {
				// console.log("getFieldsBySObjects, state:", state);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener los campos del contrato"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	getSectionsByTemplate : function(component, templateName, fieldsBySObjects) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		
        /*DVM INICIO: 12/julio/2018 MODIFICACION para cubrir el requerimiento de igualar los campos mostrados en Pantalla de Funcionalidades y Pantalla de ADV*/
        var query;
        if(templateName === 'Contrato Clientes TVBE Papel'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Clientes Multiproducto'){
            query = "SELECT Seccion2__c, Seccion1__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Empresarial Edenred'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Plus Edenred Chip' || templateName === 'Contrato Plus Edenred Banda'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Clientes ECOVALE Despensa' || templateName === 'Contrato Clientes ECOVALE Combustible'){
            query = "SELECT Seccion2__c, Seccion1__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName.includes("Contrato Clientes Mantenimiento") == true){
            query = "SELECT Seccion2__c, Seccion1__c, Seccion3__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Ticket Car 3.0 Pospago' || templateName === 'Contrato Ticket Car 3.0 Prepago' || templateName === 'Contrato Ticket Car 3.0 Basico'){
            query = "SELECT Seccion6__c, Seccion3__c, Seccion1__c, Seccion2__c, Seccion4__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Clientes TV Combustible Papel'){
            query = "SELECT Seccion2__c, Seccion1__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Vale Despensas Edenred -Banda' || templateName === 'Contrato Vale Despensas Edenred - Chip'){
            query = "SELECT Seccion2__c, Seccion1__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Ticket Car 4.0 Pospago'){
            query = "SELECT Seccion6__c,Seccion3__c,Seccion1__c, Seccion2__c, Seccion4__c, Seccion5__c  FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }
        /*DVM FIN: 12/julio/2018 MODIFICACION para cubrir el requerimiento de igualar los campos mostrados en Pantalla de Funcionalidades y Pantalla de ADV*/
        
        /*DVM INICIO: 26/junio/2018 MODIFICACION para cubrir el requerimiento de igualar los campos mostrados en Pantalla de Funcionalidades y Pantalla de ADV
        var query;
        if(templateName === 'Contrato Clientes TVBE Papel'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Clientes Multiproducto'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Empresarial Edenred'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Plus Edenred Chip' || templateName === 'Contrato Plus Edenred Banda'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Clientes ECOVALE Despensa' || templateName === 'Contrato Clientes ECOVALE Combustible'){
            query = "SELECT Seccion2__c, Seccion1__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName.includes("Contrato Clientes Mantenimiento") == true){
            query = "SELECT Seccion2__c, Seccion1__c, Seccion3__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Ticket Car 3.0 Pospago' || templateName === 'Contrato Ticket Car 3.0 Prepago' || templateName === 'Contrato Ticket Car 3.0 Basico'){
            query = "SELECT Seccion6__c, Seccion3__c, Seccion1__c, Seccion2__c, Seccion4__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Clientes TV Combustible Papel'){
            query = "SELECT Seccion2__c, Seccion1__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }else if(templateName === 'Contrato Vale Despensas Edenred -Banda' || templateName === 'Contrato Vale Despensas Edenred - Chip'){
            query = "SELECT Seccion2__c, Seccion1__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'";
        }
        DVM FIN: 26/junio/2018 MODIFICACION para cubrir el requerimiento de igualar los campos mostrados en Pantalla de Funcionalidades y Pantalla de ADV*/
        
        action.setParams({
			query: query
            //LINEA ORIGINAL => "SELECT Seccion1__c, Seccion2__c, Seccion3__c, Seccion4__c, Seccion5__c, Seccion6__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue()[0];
                
               /*DV*/          
                if(templateName === 'Contrato Clientes TVBE Papel' || templateName === 'Contrato Clientes Multiproducto'){
                    
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                    	var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;DiscountFree__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    returnedValue.Seccion2__c = facturacion;
                    
                /*DVM: Inicio, 3 Julio: Para atender requerimiento de asignación OT Trade Marketing*/
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    if(component.get("v.ventaTradeMarketing") === 'SI'){
                        //alert(component.get("v.ventaTradeMarketing"));
                    	//var DetallesPedido = "ModoOperacionCliente_PL__c;Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                        var DetallesPedido = "ModoOperacionCliente_PL__c;Personalizacion_de_Tarjetas__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";    
                    }
                /*DVM: Inicio, 3 Julio: Para atender requerimiento de asignación OT Trade Marketing*/
                    if(!templateName === 'Contrato Clientes TVBE Papel'){
                     	 returnedValue.Seccion1__c = DetallesPedido;
                     }
                   
                
                    
                }else if(templateName === 'Contrato Vale Despensas Edenred -Banda' || templateName === 'Contrato Vale Despensas Edenred - Chip'){
                    
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;Deduce__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var facturacion = "Frecuencia_de_Pedido__c;Deduce__c;DiscountFree__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    returnedValue.Seccion1__c = DetallesPedido;
                }else if(templateName === 'Contrato Empresarial Edenred'){
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;FrecuenciaEstadoCuenta__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;TipoPedidoTarjetas__c";//DYAMPI
                    returnedValue.Seccion1__c = DetallesPedido;
                }else if(templateName === 'Contrato Plus Edenred Chip' || templateName === 'Contrato Plus Edenred Banda'){
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;FrecuenciaEstadoCuenta__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Opcion_Habilitada_ATM__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;Opcion_Habilitada_ATM__c";
                    returnedValue.Seccion1__c = DetallesPedido;
                }else if(templateName === 'Contrato Clientes ECOVALE Despensa' || templateName === 'Contrato Clientes ECOVALE Combustible'){
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;Deduce__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var facturacion = "Frecuencia_de_Pedido__c;DiscountFree__c;Deduce__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    returnedValue.Seccion1__c = DetallesPedido;
                    
                }else if(templateName.includes("Contrato Clientes Mantenimiento") == true){
                    var lineaOperativa = "Linea_Operativa__c;FeeFijoVehiculo__c;APartirDe__c;Dia_de_corte__c;MontoEstimadoConsumoMensual__c";
                    returnedValue.Seccion3__c = lineaOperativa;
                    var facturacion = "Tipo_de_Facturacion__c;CondicionesPagoPlazo__c;Frecuencia_de_Pedido__c;DepositoOperacional__c;DiasCredito__c;FrecuenciaFacturacion__c";
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c";
                    returnedValue.Seccion1__c = DetallesPedido;
                    
                }else if(templateName === 'Contrato Ticket Car 3.0 Pospago' || templateName === 'Contrato Ticket Car 3.0 Prepago' || templateName === 'Contrato Ticket Car 3.0 Basico'){
                    
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    //quitar CorreoRecibeFactura__c;Otros_correos__c;
                    var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;LineasImpresionTarjeta__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        //quitar CorreoRecibeFactura__c;Otros_correos__c;
                        var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;DiscountFree__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;LineasImpresionTarjeta__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    
                    returnedValue.Seccion6__c = condicionesOperativas;
                    var lineaOperativa = "Tipo_de_Facturacion__c;Linea_Operativa__c;Frecuencia_Liberacion_Automatica__c;Ventana_de_Riesgos__c;MontoGarantia__c";
                    returnedValue.Seccion3__c = lineaOperativa;
                }else if(templateName === 'Contrato Ticket Car 4.0 Pospago'){
                    var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c;Otros_correos__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;DiscountFree__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c;Otros_correos__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    }
                    returnedValue.Seccion6__c = condicionesOperativas;
                    var lineaOperativa = "Tipo_de_Facturacion__c;Linea_Operativa__c;Frecuencia_Liberacion_Automatica__c;Ventana_de_Riesgos__c;MontoGarantia__c";
                    returnedValue.Seccion3__c = lineaOperativa;
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;TipoPedidoTarjetas__c";//DYAMPI
                    returnedValue.Seccion1__c = DetallesPedido;
                    
                }else if(templateName === 'Contrato Clientes TV Combustible Papel'){
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var facturacion = "Frecuencia_de_Pedido__c;DiscountFree__c;ComisionMinima__c";//;CorreoRecibeFactura__c;Otros_correos__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "DireccionesAuxiliares__c";
                    //var DetallesPedido = "";
                    //returnedValue.Seccion1__c = DetallesPedido;
                }
                
                /*DV*/

                /*if(returnedValue.Seccion1__c==null){
                    returnedValue.Seccion1__c="Otros_correos__c";
                }else{
                    returnedValue.Seccion1__c=returnedValue.Seccion1__c+";Otros_correos__c";
                }*/
                
                console.log("Maquilador :"+ component.get("v.maquila"));
                if(component.get("v.maquila")==true){
                	if(returnedValue.Seccion1__c==null){
                		returnedValue.Seccion1__c="Maquila__c;Tipo_Maquila__c";
                	}else{
                		returnedValue.Seccion1__c=returnedValue.Seccion1__c+";Maquila__c;Tipo_Maquila__c"
                	}                	                	
                }
				console.log("getSectionsByTemplate, returnedValue:", returnedValue);
				if (returnedValue && returnedValue.hasOwnProperty('CamposAnexoA__c')) {
					var camposBase = returnedValue.CamposAnexoA__c;
					var camposBaseOrdenado = ''
					var opciones           = fieldsBySObjects.PlantillaContrato__c.CamposAnexoA__c.picklistEntries;
					var camposConfigurados = {}
					camposBase.split(';').forEach( function( campo, index ) {
						camposConfigurados[campo] = true
					})
					
					opciones.forEach(function( opcion, index ) {
						if(camposConfigurados && camposConfigurados.hasOwnProperty(opcion.value) ) {
							
							if( camposBaseOrdenado.length > 0 ) {
								camposBaseOrdenado += ';'
							}
							camposBaseOrdenado += opcion.value
						}
					})
					
					returnedValue.CamposAnexoA__c = camposBaseOrdenado;
				} else {
					/*let toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						duration: '10000',
						type: 'warning',
						title: 'Advertencia',
						message: 'El campo "CamposAnexoA__c" está vacío, favor de llenar.'
					});
					toastEvent.fire();*/
				}
				
				var fieldsBySections = [];
				var allContractFields = "";
				var allAnnexFields = "";
				var sections = returnedValue;
				for (var sectionName in sections) {
					if (sections && sections.hasOwnProperty(sectionName) && (sectionName != "Id")) {
						var tempSObject = {};
						tempSObject.name = sectionName;
						tempSObject.fieldNames = sections[sectionName].split(";");
						if (sectionName.includes("Seccion")) {
							allContractFields += sections[sectionName].replace(/;/g, ",") + ",";
							tempSObject.originObject = "Contrato2__c";
						} else if (sectionName.includes("CamposAnexo")) {
							allAnnexFields += sections[sectionName].replace(/;/g, ",") + ",";
							tempSObject.originObject = "Anexo__c";
						}
						fieldsBySections.push(tempSObject);
					}
				}
				var allFieldsBySObject = {};
				allFieldsBySObject.contractFields = allContractFields;
				allFieldsBySObject.annexFields = allAnnexFields;
				for (var SObjectFields in allFieldsBySObject) {
					if (allFieldsBySObject && allFieldsBySObject.hasOwnProperty(SObjectFields)) {
						var lastIndex = allFieldsBySObject[SObjectFields].length - 1;
						allFieldsBySObject[SObjectFields] = allFieldsBySObject[SObjectFields].substr(0, lastIndex);
						var tempObject = {};
						var tempFields = allFieldsBySObject[SObjectFields].split(",");
						tempFields.forEach(function(field) {
							if (tempObject && !tempObject.hasOwnProperty(field)) {
								tempObject[field] = field;
							}
						});
						allFieldsBySObject[SObjectFields] = Object.keys(tempObject).toString();
					}
				}
				// console.log("fieldsBySections:", fieldsBySections, ", allFieldsBySObject:", allFieldsBySObject);
				// this.getFieldsBySObjects(component, fieldsBySections, allFieldsBySObject);
				
				var dataToSave = component.get("v.dataToSave");
				if (dataToSave && dataToSave.contrato && dataToSave.contrato.hasOwnProperty("Id")) {
					this.getContractFieldValues(component, fieldsBySObjects, fieldsBySections, allFieldsBySObject);
					//console.log("getFieldsBySObjects, getContractFieldValues");
				} else {
					this.getSections(component, fieldsBySObjects, fieldsBySections, {}, {});
					//console.log("getFieldsBySObjects, getSections");
				}
				
			} else {
				console.log("getSectionsPerTemplate, state:", state);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener los campos de secciones del contrato"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	getContractFieldValues : function(component, fieldsBySObjects, fieldsBySections, allFieldsBySObject) {
		// console.log("allFieldsBySObject.contractFields", allFieldsBySObject.contractFields);
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
        console.log('getContractFieldValues allFieldsBySObject.contractFields:',allFieldsBySObject.contractFields);
		action.setParams({
			query: "SELECT " + allFieldsBySObject.contractFields + " FROM Contrato2__c WHERE Id = '" + component.get("v.dataToSave").contrato.Id + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state = "SUCCESS") {
				// console.log("getContractFieldValues, response.getReturnValue():", response.getReturnValue());
				var returnedValue = response.getReturnValue()[0];
				console.log("getContractFieldValues, returnedValue:", returnedValue);
                
                //obtener attachment de la cuenta si Direcciones Auxiliares tru
                if(returnedValue && returnedValue.DireccionesAuxiliares__c == true){
                    this.getDireccionesAttachment(component,component.get("v.accountId"));
                }

				var dataToSave = component.get("v.dataToSave") != null ? component.get("v.dataToSave") : { anexo: {} };
				if (dataToSave && dataToSave.anexo && dataToSave.anexo.hasOwnProperty("Id")) {
					this.getAnnexFieldValues(component, fieldsBySObjects, fieldsBySections, returnedValue, allFieldsBySObject);
					//console.log("getContractFieldValues, getAnnexFieldValues");
				} else {
					this.getSections(component, fieldsBySObjects, fieldsBySections, returnedValue, {});
					//console.log("getContractFieldValues, getSections");
				}
			} else {
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al recuperar los datos de los campos de contrato"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
    getDireccionesAttachment : function(component,accountID){
        var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Name, Id FROM Attachment WHERE ParentId ='"+accountID+"'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state = "SUCCESS") {
                
                var res = response.getReturnValue();
                
                if(res.length > 0){
                    console.log('getDireccionesAttachment:',res);
                    component.set("v.attachmentDireccionAux", res);
                    
                }else{
                    toastEvent.setParams({
                        "duration": "10000",
                        "type": "warning",
                        "title": "Advertencia",
                        "message": "Validar que se haya cargado correctamente archivo de Direcciones Auxiliares en Funcionalidades."
                    });
                    toastEvent.fire();
                }
				
			}
		});
		$A.enqueueAction(action);
    },
	getAnnexFieldValues : function(component, fieldsBySObjects, fieldsBySections, valuesByContractFields, allFieldsBySObject) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT " + allFieldsBySObject.annexFields + " FROM Anexo__c WHERE Id = '" + component.get("v.dataToSave").anexo.Id + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state = "SUCCESS") {
				//console.log("getAnnexFieldValues, response.getReturnValue():", response.getReturnValue());
				var returnedValue = response.getReturnValue()[0];
				// console.log("getAnnexFieldValues, returnedValue:", returnedValue);
				this.getSections(component, fieldsBySObjects, fieldsBySections, valuesByContractFields, returnedValue);
			} else {
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al recuperar los datos de los campos de anexo"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	getSections : function(component, fieldsBySObjects, fieldsBySections, valuesByContractFields, valuesByAnnexFields) {
		var dependentFieldsBySObject = component.get("v.dependentFieldsBySObject");
		console.log("getSections, fieldsBySections:", fieldsBySections);
		var contractSections = [];
		var annexes = [];
		fieldsBySections.forEach(function(section) {
			// console.log("getSections, section:", section);
			var tempSection = [];
			var tempSObject = {};
			for (var SObject in fieldsBySObjects) {
				if (fieldsBySObjects && fieldsBySObjects.hasOwnProperty(SObject)) {
					section.fieldNames.forEach(function(fieldName) {
						if (fieldsBySObjects && fieldsBySObjects[SObject] && fieldsBySObjects[SObject].hasOwnProperty(fieldName) && (section.originObject == SObject)) {
							fieldsBySObjects[SObject][fieldName]["isVisible"] = true;
							if (dependentFieldsBySObject != null) {
								var tempControlFields = [];
								// Setting up dependent fields
								for (var dfSObject in dependentFieldsBySObject) {
									if (dependentFieldsBySObject && dependentFieldsBySObject.hasOwnProperty(dfSObject)) {
										if (dfSObject == SObject) {
											for (var controlField in dependentFieldsBySObject[dfSObject]) {
												if (dependentFieldsBySObject && dependentFieldsBySObject[dfSObject] && dependentFieldsBySObject[dfSObject].hasOwnProperty(controlField)) {
													// console.log("getSections, controlField:", controlField);
													for (var controlFieldValue in dependentFieldsBySObject[dfSObject][controlField]) {
														// console.log("getSections, controlFieldValue:", controlFieldValue);
														if (dependentFieldsBySObject && dependentFieldsBySObject[dfSObject][controlField] && dependentFieldsBySObject[dfSObject][controlField].hasOwnProperty(controlFieldValue)) {
															dependentFieldsBySObject[dfSObject][controlField][controlFieldValue].forEach(function(dependentField) {
																if (dependentField == fieldName) {
																	var tempFieldValues = [];
																	if (controlFieldValue == "verdadero") {
																		tempFieldValues.push(true);
																	} else {
																		tempFieldValues.push(controlFieldValue);
																	}
																	if (fieldsBySObjects && fieldsBySObjects[dfSObject][dependentField] && !fieldsBySObjects[dfSObject][dependentField].hasOwnProperty("controlFields")) {
																		tempControlFields.push({ name: controlField, values: tempFieldValues });
																	} else {
																		fieldsBySObjects[dfSObject][dependentField].controlFields.forEach(function(cf) {
																			if (cf.name == controlField) {
																				cf.values.push(controlFieldValue);
																			} else {
																				tempControlFields.push({ name: controlField, values: tempFieldValues });
																			}
																		});
																	}
																	fieldsBySObjects[dfSObject][dependentField]["controlFields"] = tempControlFields;
																	// console.log("fieldsBySObjects[dfSObject][dependentField][\"controlFields\"]:", fieldsBySObjects[dfSObject][dependentField].controlFields);
																	fieldsBySObjects[dfSObject][dependentField].isVisible = false;
																} else if (controlField == fieldName && fieldsBySObjects && fieldsBySObjects[dfSObject][controlField] && !fieldsBySObjects[dfSObject][controlField].hasOwnProperty("isControlField")) {
																	fieldsBySObjects[dfSObject][controlField]["isControlField"] = true;
																}
															});
														}
													}
												}
											}
										}
									}
								}
								if (fieldsBySObjects && fieldsBySObjects[SObject][fieldName] && fieldsBySObjects[SObject][fieldName].hasOwnProperty("controlFields")) {
									var lastIndex = fieldsBySObjects[SObject][fieldName].controlFields.length - 1;
									if (lastIndex >= 0) {
										fieldsBySObjects[SObject][fieldName].controlFields[lastIndex]["isParent"] = true;
									}
								}
								for (var dfSObject in dependentFieldsBySObject) {
									if (dependentFieldsBySObject && dependentFieldsBySObject.hasOwnProperty(dfSObject)) {
										if (dfSObject == SObject) {
											for (var controlField in dependentFieldsBySObject[dfSObject]) {
												if (dependentFieldsBySObject && dependentFieldsBySObject[dfSObject] && dependentFieldsBySObject[dfSObject].hasOwnProperty(controlField)) {
													// console.log("getSections, controlField:", controlField);
													for (var controlFieldValue in dependentFieldsBySObject[dfSObject][controlField]) {
														// console.log("getSections, controlFieldValue:", controlFieldValue);
														if (dependentFieldsBySObject && dependentFieldsBySObject[dfSObject][controlField] && dependentFieldsBySObject[dfSObject][controlField].hasOwnProperty(controlFieldValue)) {
															dependentFieldsBySObject[dfSObject][controlField][controlFieldValue].forEach(function(dependentField) {
																if (fieldsBySObjects && fieldsBySObjects[dfSObject][controlField] && fieldsBySObjects[dfSObject][controlField].hasOwnProperty("value")) {
																	if (fieldsBySObjects && fieldsBySObjects[dfSObject][dependentField] && fieldsBySObjects[dfSObject][dependentField].hasOwnProperty("controlFields")) {
																		fieldsBySObjects[dfSObject][dependentField].controlFields.forEach(function(cf) {
																			if (cf && cf.name == controlField && cf.hasOwnProperty("isParent")) {
																				cf.values.some(function(cfv) {
																					if (fieldsBySObjects[dfSObject][controlField].value == cfv) {
																						fieldsBySObjects[dfSObject][dependentField].isVisible = true;
																						return true;
																					}
																				});
																			}
																		});
																	}
																}
															});
														}
													}
												}
											}
										}
									}
								}
							}
							// Does the current contract field have a value?
							if (valuesByContractFields && valuesByContractFields.hasOwnProperty(fieldName) && SObject == "Contrato2__c") {
								// Is the current field a data type?
								if (fieldsBySObjects[SObject][fieldName].type == "DATE") {
									var aux = valuesByContractFields[fieldName].split("-");
									fieldsBySObjects[SObject][fieldName]["value"] = aux[2] + "/" + aux[1] + "/" + aux[0];
								} else {
									fieldsBySObjects[SObject][fieldName]["value"] = valuesByContractFields[fieldName];
								}
							}
							// Does the current annex field have a value?
							if (valuesByAnnexFields && valuesByAnnexFields.hasOwnProperty(fieldName) && SObject == "Anexo__c") {
								// Is the current field a date type?
								if (fieldsBySObjects[SObject][fieldName].type == "DATE") {
									var aux = valuesByAnnexFields[fieldName].split("-");
									fieldsBySObjects[SObject][fieldName]["value"] = aux[2] + "/" + aux[1] + "/" + aux[0];
								} else {
									fieldsBySObjects[SObject][fieldName]["value"] = valuesByAnnexFields[fieldName];
								}
							}
							// Is the current field a number type?
							if (fieldsBySObjects[SObject][fieldName].type == "DOUBLE" || fieldsBySObjects[SObject][fieldName].type == "PERCENT") {
								var precision = fieldsBySObjects[SObject][fieldName].precision;
								var scale = fieldsBySObjects[SObject][fieldName].scale;
								fieldsBySObjects[SObject][fieldName]["maxValue"] = Number((Math.pow(10, (precision - scale)) - 1) + "." + (Math.pow(10, scale) - 1));
							}
							// Is the current opportunity's stagename equal to "Alta de cliente"?
							// if (component.get("v.opportunityStageName") == "Alta de cliente") {
							// 	fieldsBySObjects[SObject][fieldName]["disabled"] = true;
							// }
							if (component.get("v.currentContractStage") == "Finalizado" || component.get("v.adv")) {
								fieldsBySObjects[SObject][fieldName]["disabled"] = true;
								component.set("v.isFinishButtonDisabled", true);
								component.set("v.isSendButtonDisabled", false);
							}
							fieldsBySObjects[SObject][fieldName]["required"] = false;
							tempSection.push(fieldsBySObjects[SObject][fieldName]);
						}
					});
				}
			}
			tempSObject.name = fieldsBySObjects["PlantillaContrato__c"][section.name].label;
			tempSObject.fields = tempSection;
			if (!fieldsBySObjects["PlantillaContrato__c"][section.name].label.includes("Campos Anexo")) {
				contractSections.push(tempSObject);
			} else {
				tempSObject.isVisible = true;
				tempSObject.sections = [];
				if (component.get("v.contractTitle") == "Contrato Ticket Car 3.0"||component.get("v.contractTitle") == "Contrato Ticket Car 4.0") {
					if (tempSObject.name == "Campos Anexo A") {
						var fieldsByAnnexASections = [
							{
								name: "Condiciones Comerciales y Filiales del Cliente",
								listFields: [
									"FechaContrato__c",
									"NombreCliente__c",
									"CuotaAdscripcion__c",
									"CuotaAnual__c",
									"Transacciones__c",
									"CargoporEnvio__c",
									"CuentaActiva__c"
								]
							},
							{
								name: "Administración de Autoconsumo",
								listFields: [
									"CuentaAutoconsumo__c",
									"MensualidadAutoconsumo__c",
									"CuotaLitros__c",
									"FormaPago__c"
								]
							},
							{
								name: "Presencia Vehicular",
								listFields: [
									"Etiqueta__c",
									"Bonificacion__c",
									"VigenciaTarjetas__c",
									"Mensualidad__c",
									"CargoTAG__c",
									"PeriodoFacturacion__c",
									"Contraprestacion__c"
								]
							},
							{
								name: "Cuota por Tarjetas",
								listFields: [
									"DescuentoEquivalente__c",
									"Vigencia__c"
								]
							}
						];
						// console.log("getSections, fieldsByAnnexASections:", fieldsByAnnexASections);
						fieldsByAnnexASections.forEach(function(section) {
							var tempArray = [];
							var tempObject = {};
							section.listFields.forEach(function(fieldName) {
								tempSObject.fields.forEach(function(field) {
									if (field.name == fieldName) {
										tempArray.push(field);
									}
								});
							});
							tempObject = { name: section.name, fields: tempArray };
							tempSObject.sections.push(tempObject);
						});
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						if (!(component.get("v.qliFormaPago") == "American Express")) {
							tempSObject.isVisible = false;
						}
					}
					var campos = {
						FrecuenciaFacturacion__c: ['PeriodoFacturacion__c']
					}
					component.set("v.dependetFieldsCA", campos);
				} else if (component.get("v.contractTitle") == "Contrato Vale Despensas Edenred") {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo B") {
						tempSObject.sections.push({ name: "Proceso Operativo", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						if (!(component.get("v.qliFormaPago") == "American Express")) {
							tempSObject.isVisible = false;
						}
					}
				} else if (component.get("v.contractTitle") == "Contrato Empresarial Edenred") {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo B") {
						tempSObject.sections.push({ name: "Proceso Operativo", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					}
				}
				// For every Annex A of all Contracts, set this fields to read only mode
				if (tempSObject.name == "Campos Anexo A") {
					component.get("v.onlyReadAnnexAFields").forEach(function(orf) {
						tempSObject.fields.forEach(function(field) {
							if (field.name == orf) {
								field["disabled"] = true;
								if (field.type == "STRING" || field.type == "PICKLIST" || field.type == "MULTIPICKLIST") {
									if (!field.value) {
										field.value = "";
									}
								} else if (field.type == "BOOLEAN") {
									if (!field.value) {
										field.value = false;
									}
								} else if ((field.type == "DOUBLE") || (field.type == "PERCENT")) {
									if (!field.value) {
										field.value = 0;
									}
								}
							}
						});
					});
				}
				annexes.push(tempSObject);
			}
		});
		component.set("v.objectsByDocument", { contractSections: contractSections, annexes: annexes });
		component.set("v.isDataReady", true);
		var objectsByDocument = component.get("v.objectsByDocument");
		// console.log("getSections, annexes:", annexes);
		console.log("getSections, objectsByDocument:", JSON.parse(JSON.stringify(objectsByDocument)));
	},
	
	save : function(component, dataToSave) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.guardaContrato");
		action.setParams({
			strData: dataToSave
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				console.log("save, returnedValue:", returnedValue);
				var dataToSave = component.get("v.dataToSave") != null ? component.get("v.dataToSave") : { contrato: {}, anexo: {} };
				if (dataToSave && dataToSave.contrato && !dataToSave.contrato.hasOwnProperty("Id")) {
					dataToSave.contrato["Id"] = returnedValue.Id;
					component.set("v.dataToSave", dataToSave);
					component.set("v.currentContractStage", "En proceso");
				}
				if (dataToSave && dataToSave.anexo &&!dataToSave.anexo.hasOwnProperty("Id")) {
					dataToSave.anexo["Id"] = returnedValue.Id;
					component.set("v.dataToSave", dataToSave);
				}
				//console.log("save, dataToSave:", dataToSave);
				toastEvent.setParams({
					"duration": "10000",
					"type": "success",
					"title": "¡Éxito!",
					"message": "Los datos han sido guardados correctamente"
				});
			} else {
				console.log("save, state:", state);
				var returnedValue = response.getReturnValue();
				console.log("save, returnedValue:", returnedValue);
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al guardar los datos"
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},
	
	validateOppAttachmentsFAC : function(component) {
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
				var documentationComplete = true;
				var accTypePerson = returnedValue.relatedAccount.Account.TipoPersona__c;
				var docsByTypePerson = returnedValue.docsByTypePerson[accTypePerson];
				// console.log("validateOppAttachmentsFAC, docsByTypePerson:", docsByTypePerson);
				docsByTypePerson.forEach(function(doc) {
					doc.loaded = false;
					returnedValue.oppAttachments.forEach(function(attachment) {
						var name = doc.ContentDocument && doc.ContentDocument.Title ? doc.ContentDocument.Title : '' 
						// if (attachment.Name.includes(doc.name)) { old version 9/08/2018 @calvarez
						if (name.includes(doc.name)) {
							doc.loaded = true;
						}
					});
					// console.log("validateOppAttachmentsFAC, doc:", doc);
					if (!doc.loaded) {
						documentationComplete = false;
						// console.log("documentationComplete:", documentationComplete);
					}
				});
				if (documentationComplete) {
					var objectsByDocument = component.get("v.objectsByDocument");
					for (var objectDocument in objectsByDocument) {
						if (objectsByDocument && objectsByDocument.hasOwnProperty(objectDocument)) {
							objectsByDocument[objectDocument].forEach(function(sectionByObject) {
								sectionByObject.fields.forEach(function(field) {
									field.disabled = true;
								});
							});
						}
					}
					component.set("v.objectsByDocument", objectsByDocument);
					var dataToSave = component.get("v.dataToSave");
					dataToSave.finalizar = "finalizar";
					console.log(JSON.stringify(dataToSave));
					toastEvent.setParams({
						"duration": "10000",
						"type": "success",
						"title": "¡Éxito!",
						"message": "La documentación está completa"
					});
					this.save(component, JSON.stringify(dataToSave));
					component.set("v.isFinishButtonDisabled", true);
					component.set("v.isSendButtonDisabled", false);
				} else {
					toastEvent.setParams({
						"duration": "10000",
						"type": "warning",
						"title": "Advertencia",
						"message": "Falta anexar algunos documentos a la oportunidad"
					});
				}
			} else {
				console.log("mapAnnexADataFAC, state:", state);
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
	
	getContactLegalRepresentative : function(component) {
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Id, Email FROM Contact WHERE AccountId = '" + component.get("v.accountId") + "' AND Funcion__c = 'Representante Legal'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue()[0];
				console.log("getContactLegalRepresentative, returnedValue:", returnedValue);
				this.createQuoteDocumentFAC(component, returnedValue);
			} else {
				console.log("getContactLegalRepresentative, state:", state);
			}
		});
		$A.enqueueAction(action);
	},
	
	createQuoteDocumentFAC : function(component, contactData) {
		var action = component.get("c.createQuoteDocument");
		action.setParams({
			oppId: component.get("v.opportunityId"),
			qliId: component.get("v.recordId"),
			quoteId: component.get("v.quoteId")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				console.log("createQuoteDocumentFAC, returnedValue:", returnedValue);
				var urlEvent = $A.get("e.force:navigateToURL");
				urlEvent.setParams({
					"url": "/one/one.app#/alohaRedirect/_ui/core/email/author/EmailAuthor?p2_lkid=" + contactData.Id + "&p3_lkid=" + component.get("v.opportunityId") + "&doc_id=" + returnedValue + "&p24=" + contactData.Email
				});
				urlEvent.fire();
			} else {
				console.log("createQuoteDocumentFAC, state:", state);
			}
		});
		$A.enqueueAction(action);
	}
})