({
	getInitialData : function(component, qliId) {
		// Constants
		const CON_CLI_MAN= 'Contrato Clientes Mantenimiento';
		// Constants
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Product2.Name, Product2.Family, Product2.ProductCode, Quote.Opportunity.bloqueoLP__c,Quote.Opportunity.Familia__c, Quote.Opportunity.StageName, (SELECT Id, EtapaContrato__c FROM Contratos2__r), (SELECT Id FROM Anexos__r), Quote.Opportunity.Name, Quote.Opportunity.Account.Name, Quote.Opportunity.Account.TipoPersona__c, Quote.Opportunity.Account.Sector__c, FormaPago__c, Quote.Opportunity.VentaTradeMarketing_PL__c FROM QuoteLineItem WHERE Id = '" + qliId + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			var toastEvent1 = $A.get("e.force:showToast");
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue()[0];
				console.log("CC - getInitialData, returnedValue:", returnedValue);
				// Does the QuoteLineItem have a Contract record?
				if (returnedValue.hasOwnProperty("FormaPago__c")) {
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
                    component.set("v.obligatorio",returnedValue.Quote.Opportunity.bloqueoLP__c);
                    component.set("v.producFamily",returnedValue.Product2.Family);
					component.set("v.accountId", returnedValue.Quote.Opportunity.AccountId);
					component.set("v.quoteId", returnedValue.QuoteId);
					component.set("v.productCode", returnedValue.Product2.ProductCode);
                    component.set("v.ventaTradeMarketing", returnedValue.Quote.Opportunity.VentaTradeMarketing_PL__c); //DVM 3 Julio, para el requerimiento de asignación de OT Trade Marketing
					// Is the Opportunity's StageName equal to "Alta de Cliente"?
                    if(returnedValue.Product2.Family=='Combustible'){component.set('v.obligatorio',true);}
                    if(returnedValue.Product2.Family=='Mantenimiento'){component.set('v.obligatorio',true);}
                    if(returnedValue.Product2.Family=='Empresarial'){component.set('v.obligatorio',true);}
                    
					
					if (returnedValue.Quote.Opportunity.StageName == "Alta de cliente") {
						component.set("v.isFinishButtonDisabled", true);
					}
                    
                    console.log("EtapaOportunidad " +returnedValue.Quote.Opportunity.StageName)
					component.set("v.EtapaOportunidad", returnedValue.Quote.Opportunity.StageName);
					if(component.get("v.EtapaOportunidad")!='Contrato'){
						component.set("v.isPDFButtonDisabled", true);
						component.set("v.isSaveButtonDisabled", true);
						component.set("v.isFinishButtonDisabled", true);
						component.set("v.isSendButtonDisabled", true);
						component.set('v.isDataSaved', true);
						component.set('v.isCCVisible', false)

					} 
                    
					var headerData = returnedValue;
					component.set("v.headerData", headerData);
					// Does the QuoteLineItem have a valid Product's Name and Opportunity's family?
					if (returnedValue.Product2.ProductCode == "30" || returnedValue.Product2.ProductCode == "30-B" || returnedValue.Product2.ProductCode == "30-G" || returnedValue.Product2.ProductCode == "30-E" || returnedValue.Product2.ProductCode == "30-S" && returnedValue.Quote.Opportunity.Familia__c == "Combustible") {
						component.set("v.contractTitle", "Contrato Ticket Car 3.0");
						this.getContractTemplates(component, "Contrato Ticket Car 3.0 Pospago");
					}else if(returnedValue.Product2.ProductCode == "30-TC4" && returnedValue.Quote.Opportunity.Familia__c == "Combustible"){
                        component.set("v.contractTitle", "Contrato Ticket Car 4.0");
						this.getContractTemplates(component, "Contrato Ticket Car 4.0 Pospago");
                    } else if ((returnedValue.Product2.ProductCode == "12" || returnedValue.Product2.ProductCode == "32" || returnedValue.Product2.ProductCode == "32-W" || returnedValue.Product2.ProductCode == "32-CH") && returnedValue.Quote.Opportunity.Familia__c == "Despensa") {
						component.set("v.contractTitle", "Contrato Vale Despensas Edenred");
						if (returnedValue.Product2.ProductCode == "12") {
							this.getContractTemplates(component, "Contrato Vale Despensas Edenred -Banda");
						} else if (returnedValue.Product2.ProductCode == "32" || returnedValue.Product2.ProductCode == "32-W" || returnedValue.Product2.ProductCode == "32-CH") {
							this.getContractTemplates(component, "Contrato Vale Despensas Edenred - Chip");
						}
						this.getContractTemplates(component, "Contrato Vale Despensas Edenred");
					} else if (returnedValue.Product2.ProductCode == "29" && returnedValue.Quote.Opportunity.Familia__c == "Empresarial") {
						component.set("v.contractTitle", "Contrato Empresarial Edenred");
						this.getContractTemplates(component, "Contrato Empresarial Edenred");
					} else if (((returnedValue.Product2.ProductCode == "60-D") || (returnedValue.Product2.ProductCode == "60-M") || (returnedValue.Product2.ProductCode == "60-P")) && returnedValue.Quote.Opportunity.Familia__c == "Combustible") {
						component.set("v.contractTitle", "Contrato Clientes Ecovale Combustible");
						this.getContractTemplates(component, "Contrato Clientes ECOVALE combustible");
					} else if (((returnedValue.Product2.ProductCode == "41") || (returnedValue.Product2.ProductCode == "51") || (returnedValue.Product2.ProductCode == "61") || (returnedValue.Product2.ProductCode == "71") || (returnedValue.Product2.ProductCode == "81") || (returnedValue.Product2.ProductCode == "91") || (returnedValue.Product2.ProductCode == "18") || (returnedValue.Product2.ProductCode == "38") || (returnedValue.Product2.ProductCode == "48") || (returnedValue.Product2.ProductCode == "48-W") || (returnedValue.Product2.ProductCode == "48-CH") || (returnedValue.Product2.ProductCode == "58") || (returnedValue.Product2.ProductCode == "14") || (returnedValue.Product2.ProductCode == "34")) && ((returnedValue.Quote.Opportunity.Familia__c == "Ticket Restaurante") || (returnedValue.Quote.Opportunity.Familia__c == "Regalo") || (returnedValue.Quote.Opportunity.Familia__c == "Vestimenta"))) {
						component.set("v.contractTitle", "Contrato Clientes Multiproducto");
						this.getContractTemplates(component, "Contrato Clientes Multiproducto");
					} else if (((returnedValue.Product2.ProductCode == "39") || (returnedValue.Product2.ProductCode == "39-C")) && (returnedValue.Quote.Opportunity.Familia__c == "Ayuda Social")) {
						if (returnedValue.Quote.Opportunity.Account.hasOwnProperty("Sector__c")) {
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
					} else if ((returnedValue.Product2.ProductCode == '31') && (returnedValue.Quote.Opportunity.Familia__c == 'Mantenimiento')) {
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
		
       /*DV*/
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
        /*DV*/
        
        //alert(query);
        action.setParams({
            query : query
            //query: "SELECT Seccion1__c, Seccion2__c, Seccion3__c, Seccion4__c, Seccion5__c, Seccion6__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c FROM PlantillaContrato__c WHERE Name = '" + templateName + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue()[0];
                
                
 				/*DV*/          
                if(templateName === 'Contrato Clientes TVBE Papel' || templateName === 'Contrato Clientes Multiproducto'){
                    
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                    	var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;DiscountFree__c;CorreoRecibeFactura__c;Otros_correos__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    returnedValue.Seccion2__c = facturacion;
                    
                /*DVM: Inicio, 3 Julio: Para atender requerimiento de asignación OT Trade Marketing*/
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    if(component.get("v.ventaTradeMarketing") === 'SI'){
                        var DetallesPedido = "ModoOperacionCliente_PL__c;Personalizacion_de_Tarjetas__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";    
                    	//var DetallesPedido = "ModoOperacionCliente_PL__c;Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";    
                    }
                     
                     if(templateName === 'Contrato Clientes TVBE Papel'){
                     	 //returnedValue.Seccion1__c = 'Personalizacion_de_Tarjetas__c';
                     }else{
                     	returnedValue.Seccion1__c = DetallesPedido;
                     }
                /*DVM: Inicio, 3 Julio: Para atender requerimiento de asignación OT Trade Marketing*/
                   
                }else if(templateName === 'Contrato Vale Despensas Edenred -Banda' || templateName === 'Contrato Vale Despensas Edenred - Chip'){
                    
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;Deduce__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var facturacion = "Frecuencia_de_Pedido__c;Deduce__c;DiscountFree__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c;CorreoRecibeFactura__c;Otros_correos__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;Tipo_Reposicion__c;FrecuenciaReposicion_PL__c";
                    returnedValue.Seccion1__c = DetallesPedido;
                }else if(templateName === 'Contrato Empresarial Edenred'){
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;FrecuenciaEstadoCuenta__c;CorreoRecibeFactura__c;Otros_correos__c";
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;TipoPedidoTarjetas__c";//DYAMPI
                    returnedValue.Seccion1__c = DetallesPedido;
                }else if(templateName === 'Contrato Plus Edenred Chip' || templateName === 'Contrato Plus Edenred Banda'){
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;FrecuenciaEstadoCuenta__c;CorreoRecibeFactura__c;Otros_correos__c";
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c;Opcion_Habilitada_ATM__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;Opcion_Habilitada_ATM__c";
                    returnedValue.Seccion1__c = DetallesPedido;
                }else if(templateName === 'Contrato Clientes ECOVALE Despensa' || templateName === 'Contrato Clientes ECOVALE Combustible'){
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;Deduce__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var facturacion = "Frecuencia_de_Pedido__c;DiscountFree__c;Deduce__c;ComisionMinima__c;PeriodicidadComplemento__c;Emision_complemento__c;CorreoRecibeFactura__c;Otros_correos__c";
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
                    var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c;Otros_correos__c;LineasImpresionTarjeta__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;DiscountFree__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c;Otros_correos__c;LineasImpresionTarjeta__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    
                    returnedValue.Seccion6__c = condicionesOperativas;
                    var lineaOperativa = "Tipo_de_Facturacion__c;Linea_Operativa__c;Frecuencia_Liberacion_Automatica__c;Ventana_de_Riesgos__c;MontoGarantia__c";
                    returnedValue.Seccion3__c = lineaOperativa;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;TipoPedidoTarjetas__c";//DYAMPI
                    returnedValue.Seccion1__c = DetallesPedido;
                }else if(templateName === 'Contrato Ticket Car 4.0 Pospago'){
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c;Otros_correos__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var condicionesOperativas = "Item_Contratacion__c;EmpresaPrincipal_PL__c;NombreEmpresaPrincipal_Text__c;TipoPago__c;DiscountFree__c;ComoFactura__c;Frecuencia_de_Pedido__c;ComisionMinima__c;CondicionesPagoPlazo__c;FrecuenciaFacturacion__c;Consolidador__c;Sucursal_Facturacion_Global__c;GrupoFacturacionGlobal_Text__c;Cliente_Facturacion_Global__c;Facturacion_Cargos__c;Facturacion_Comision__c;Facturacion_Plasticos__c;CEO__c;TipoCliente__c;CorreoRecibeFactura__c;Otros_correos__c;TipoPlastico__c;TipoPlasticoFinanciero_PL__c;ModoOffline__c;Permite_autorizacion_telefonica__c;PermiteCreacionFoliosAT_Checkbox__c;Opera_TC_Truck__c;ImprimeLogo__c;TicketBomba__c;ControlVolumetrico__c;CentroCostosPorcentaje_Checkbox__c;BombaPropia__c;TipoPagoBombaPropia__c;InventoryControl__c;TypeInventoryControl__c;Provider__c;Maneja_Nota_Vale__c;No_Mostrar_Km__c;GPS_Checkbox__c;Maneja_Conductores__c;Controla_Presencia_Vehiculo_NFC__c;Modo_Transaccion__c;TipoTag_PL__c;ManejaAutoconsumo_Checkbox__c;CuotaMensual_Currency__c;CuotaLitros_Currency__c;Maquila__c;Tipo_Maquila__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    
                    returnedValue.Seccion6__c = condicionesOperativas;
                    var lineaOperativa = "Tipo_de_Facturacion__c;Linea_Operativa__c;Frecuencia_Liberacion_Automatica__c;Ventana_de_Riesgos__c;MontoGarantia__c";
                    returnedValue.Seccion3__c = lineaOperativa;
                    //var DetallesPedido = "Personalizacion_de_Tarjetas__c;DireccionesAuxiliares__c";
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;TipoPedidoTarjetas__c";//DYAMPI
                    returnedValue.Seccion1__c = DetallesPedido;
                    /*var condicionesOperativas = this.getFieldsOrder(component,event,"Item_Contratacion__c-1;EmpresaPrincipal_PL__c-2;NombreEmpresaPrincipal_Text__c-3;TipoPago__c-4;ComoFactura__c-5;Frecuencia_de_Pedido__c-6;ComisionMinima__c-7;CondicionesPagoPlazo__c-8;FrecuenciaFacturacion__c-9;Consolidador__c-10;Sucursal_Facturacion_Global__c-11;GrupoFacturacionGlobal_Text__c-12;Cliente_Facturacion_Global__c-13;Facturacion_Cargos__c-14;Facturacion_Comision__c-15;Facturacion_Plasticos__c-16;CEO__c-17;TipoCliente__c-18;CorreoRecibeFactura__c-19;Otros_correos__c-20;LineasImpresionTarjeta__c-21;TipoPlastico__c-22;TipoPlasticoFinanciero_PL__c-23;ModoOffline__c-24;Permite_autorizacion_telefonica__c-25;PermiteCreacionFoliosAT_Checkbox__c-26;Opera_TC_Truck__c-27;ImprimeLogo__c-28;TicketBomba__c-29;ControlVolumetrico__c-30;CentroCostosPorcentaje_Checkbox__c-31;BombaPropia__c-32;TipoPagoBombaPropia__c-33;Maneja_Nota_Vale__c-34;No_Mostrar_Km__c-35;GPS_Checkbox__c-36;Maneja_Conductores__c-37;Controla_Presencia_Vehiculo_NFC__c-38;Modo_Transaccion__c-39;TipoTag_PL__c-40;ManejaAutoconsumo_Checkbox__c-41;CuotaMensual_Currency__c-42;CuotaLitros_Currency__c-43;Maquila__c-44;Tipo_Maquila__c-45");//returnedValue.Seccion6__c;
                    if(component.get("v.qliFormaPago") === 'American Express'){                        
                        var secc1=condicionesOperativas.substring(0,condicionesOperativas.indexOf("TipoPago__c")+12);
                        var secc2=condicionesOperativas.substring(condicionesOperativas.indexOf("TipoPago__c")+11,condicionesOperativas.length);
                        condicionesOperativas = secc1+"DiscountFree__c"+secc2;
                    }
                    returnedValue.Seccion6__c = condicionesOperativas;
                    /var lineaOperativa = "Tipo_de_Facturacion__c;Linea_Operativa__c;Frecuencia_Liberacion_Automatica__c;Ventana_de_Riesgos__c;MontoGarantia__c";
                    returnedValue.Seccion3__c = lineaOperativa;
                    
                    var DetallesPedido = "Personalizacion_de_Tarjetas__c;TipoPedidoTarjetas__c";
                    returnedValue.Seccion1__c = DetallesPedido;*/
                }else if(templateName === 'Contrato Clientes TV Combustible Papel'){
                    /*DVM: INICIO 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    var facturacion = "Frecuencia_de_Pedido__c;ComisionMinima__c;CorreoRecibeFactura__c;Otros_correos__c";
                    if(component.get("v.qliFormaPago") === 'American Express'){
                        var facturacion = "Frecuencia_de_Pedido__c;DiscountFree__c;ComisionMinima__c;CorreoRecibeFactura__c;Otros_correos__c";
                    }
                    /*DVM: FIN 27 de Junio: Agregado para mapear la dependencia de DiscountFree con método de pago AMEX*/
                    returnedValue.Seccion2__c = facturacion;
                    //var DetallesPedido = "DireccionesAuxiliares__c";
                    //returnedValue.Seccion1__c = '';
                }
                
                /*DV*/
                    
                /*if(returnedValue.Seccion1__c==null){
                    returnedValue.Seccion1__c="Tipo_Maquila__c";
                }else{
                    returnedValue.Seccion1__c=returnedValue.Seccion1__c+";Tipo_Maquila__c";
                }*/
                
				if (returnedValue.hasOwnProperty("CamposAnexoA__c")) {
					var camposBase = returnedValue.CamposAnexoA__c;
					var camposBaseOrdenado = ''
					var opciones           = fieldsBySObjects.PlantillaContrato__c.CamposAnexoA__c.picklistEntries;
					var camposConfigurados = {}
					camposBase.split(';').forEach( function( campo, index ) {
						camposConfigurados[campo] = true
					})
					
					opciones.forEach(function( opcion, index ) {
						if( camposConfigurados.hasOwnProperty(opcion.value) ) {
							
							if( camposBaseOrdenado.length > 0 ) {
								camposBaseOrdenado += ';'
							}
							camposBaseOrdenado += opcion.value
						}
					})
					
					returnedValue.CamposAnexoA__c = camposBaseOrdenado;
				}
				var fieldsBySections = [];
				var allContractFields = "";
				var allAnnexFields = "";
				var sections = returnedValue;

				console.log("secciones************** "+JSON.stringify(sections));
				for (var sectionName in sections) {
					if (sections.hasOwnProperty(sectionName) && (sectionName != "Id")) {
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
					if (allFieldsBySObject.hasOwnProperty(SObjectFields)) {
						var lastIndex = allFieldsBySObject[SObjectFields].length - 1;
						allFieldsBySObject[SObjectFields] = allFieldsBySObject[SObjectFields].substr(0, lastIndex);
						var tempObject = {};
						var tempFields = allFieldsBySObject[SObjectFields].split(",");
						tempFields.forEach(function(field) {
							if (!tempObject.hasOwnProperty(field)) {
								tempObject[field] = field;
							}
						});
						allFieldsBySObject[SObjectFields] = Object.keys(tempObject).toString();
					}
				}
				// console.log("fieldsBySections:", fieldsBySections, ", allFieldsBySObject:", allFieldsBySObject);
				// this.getFieldsBySObjects(component, fieldsBySections, allFieldsBySObject);
				
				var dataToSave = component.get("v.dataToSave");
				if (dataToSave.contrato.hasOwnProperty("Id")) {
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
    getFieldsOrder : function(component,event,campos){
        var items=campos.split(";");
        var itemsNotOrder=[];
        for(var i=0;i<items.length;i++){
            var tem=items[i].split("-");
            
            itemsNotOrder.push({"campo":tem[0],"orden":tem[1]});
        }
        console.log("VERRRR:"+JSON.stringify(itemsNotOrder));
        var itemsOrder=itemsNotOrder.sort(function compare(a, b) {
            const genreA = a.orden.toUpperCase();
            const genreB = b.orden.toUpperCase();
            
            let comparison = 0;
            if (genreA > genreB) {
                comparison = 1;
            } else if (genreA < genreB) {
                comparison = -1;
            }
            return comparison;
        });
        var resp="";
        for(var i=0;i<itemsOrder.length;i++){
            if(i<itemsOrder.length-1){
                resp+=itemsOrder[i].campo+";";
            }else{
                resp+=itemsOrder[i].campo;
            }
        }
        return resp;
    },
	getContractFieldValues : function(component, fieldsBySObjects, fieldsBySections, allFieldsBySObject) {
		// console.log("allFieldsBySObject.contractFields", allFieldsBySObject.contractFields);
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		console.log( component.get("v.dataToSave").contrato.Id +" getContractFieldValues campos:  "+allFieldsBySObject.contractFields);
		action.setParams({
			query: "SELECT " + allFieldsBySObject.contractFields + " FROM Contrato2__c WHERE Id = '" + component.get("v.dataToSave").contrato.Id + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state = "SUCCESS") {
				// console.log("getContractFieldValues, response.getReturnValue():", response.getReturnValue());
				var returnedValue = response.getReturnValue()[0];
				console.log("getContractFieldValues, returnedValue:", returnedValue);
				var dataToSave = component.get("v.dataToSave") != null ? component.get("v.dataToSave") : { anexo: {} };
				if (dataToSave.anexo.hasOwnProperty("Id")) {
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
	
	getAnnexFieldValues : function(component, fieldsBySObjects, fieldsBySections, valuesByContractFields, allFieldsBySObject) {
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.executeQuery");
		console.log('id anexo papu '+ allFieldsBySObject.annexFields +component.get("v.dataToSave").anexo.Id);
		action.setParams({
			query: "SELECT " + allFieldsBySObject.annexFields + " FROM Anexo__c WHERE Id = '" + component.get("v.dataToSave").anexo.Id + "'"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state = "SUCCESS") {
				//console.log("getAnnexFieldValues, response.getReturnValue():", response.getReturnValue());
				var returnedValue = response.getReturnValue()[0] || {};
				console.log("returned papu "+returnedValue);
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
		console.log('fieldsBySObjects:', fieldsBySObjects);
		console.log('valuesByAnnexFields:', valuesByAnnexFields);
		// Constants
		const PRODUCT_CODE_3 = '3';
		const PRODUCT_CODE_9 = '9';
		const APINAME_PERS_TARJ = 'Personalizacion_de_Tarjetas__c';
		const APINAME_DIREC_AUX = 'DireccionesAuxiliares__c';
		const LABEL_PERS_TARJ = 'Layout de Personalización de Tarjetas';
		const LABEL_DIREC_AUX = 'Layout de Direcciones Auxiliares';
		const CON_CLI_MAN= 'Contrato Clientes Mantenimiento';
		// Constants
		var dependentFieldsBySObject = component.get("v.dependentFieldsBySObject");
        console.log('dependentFieldsBySObject:', dependentFieldsBySObject);
		// console.log("getSections, fieldsBySections:", fieldsBySections);
		var contractSections = [];
		var annexes = [];
		fieldsBySections.forEach(function(section) {
			// console.log("getSections, section:", section);
			var tempSection = [];
			var tempSObject = {};
			for (var SObject in fieldsBySObjects) {
				if (fieldsBySObjects.hasOwnProperty(SObject)) {
					section.fieldNames.forEach(function(fieldName) {
						if (fieldsBySObjects[SObject].hasOwnProperty(fieldName) && (section.originObject == SObject)) {
							fieldsBySObjects[SObject][fieldName]["isVisible"] = true;
							if (dependentFieldsBySObject != null) {
								var tempControlFields = [];
								// Setting up dependent fields
								for (var dfSObject in dependentFieldsBySObject) {
									if (dependentFieldsBySObject.hasOwnProperty(dfSObject)) {
										if (dfSObject == SObject) {
											for (var controlField in dependentFieldsBySObject[dfSObject]) {
												if (dependentFieldsBySObject[dfSObject].hasOwnProperty(controlField)) {
													// console.log("getSections, controlField:", controlField);
													for (var controlFieldValue in dependentFieldsBySObject[dfSObject][controlField]) {
														// console.log("getSections, controlFieldValue:", controlFieldValue);
														if (dependentFieldsBySObject[dfSObject][controlField].hasOwnProperty(controlFieldValue)) {
															dependentFieldsBySObject[dfSObject][controlField][controlFieldValue].forEach(function(dependentField) {
																if (dependentField == fieldName) {
																	var tempFieldValues = [];
																	if (controlFieldValue == "verdadero") {
																		tempFieldValues.push(true);
																	} else {
																		tempFieldValues.push(controlFieldValue);
																	}
																	if (!fieldsBySObjects[dfSObject][dependentField].hasOwnProperty("controlFields")) {
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
																} else if (controlField == fieldName && !fieldsBySObjects[dfSObject][controlField].hasOwnProperty("isControlField")) {
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
								if (fieldsBySObjects[SObject][fieldName].hasOwnProperty("controlFields")) {
									var lastIndex = fieldsBySObjects[SObject][fieldName].controlFields.length - 1;
									fieldsBySObjects[SObject][fieldName].controlFields[lastIndex]["isParent"] = true;
								}
								for (var dfSObject in dependentFieldsBySObject) {
									if (dependentFieldsBySObject.hasOwnProperty(dfSObject)) {
										if (dfSObject == SObject) {
											for (var controlField in dependentFieldsBySObject[dfSObject]) {
												if (dependentFieldsBySObject[dfSObject].hasOwnProperty(controlField)) {
													// console.log("getSections, controlField:", controlField);
													for (var controlFieldValue in dependentFieldsBySObject[dfSObject][controlField]) {
														// console.log("getSections, controlFieldValue:", controlFieldValue);
														if (dependentFieldsBySObject[dfSObject][controlField].hasOwnProperty(controlFieldValue)) {
															dependentFieldsBySObject[dfSObject][controlField][controlFieldValue].forEach(function(dependentField) {
																if (fieldsBySObjects[dfSObject][controlField].hasOwnProperty("value")) {
																	if (fieldsBySObjects[dfSObject][dependentField].hasOwnProperty("controlFields")) {
																		fieldsBySObjects[dfSObject][dependentField].controlFields.forEach(function(cf) {
																			if (cf.name == controlField && cf.hasOwnProperty("isParent")) {
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
							if (valuesByContractFields.hasOwnProperty(fieldName) && SObject == "Contrato2__c") {
								// Is the current field a date type?
								if (fieldsBySObjects[SObject][fieldName].type == "DATE") {
									var aux = valuesByContractFields[fieldName].split("-");
									fieldsBySObjects[SObject][fieldName]["value"] = aux[2] + "/" + aux[1] + "/" + aux[0];
								} else {
									fieldsBySObjects[SObject][fieldName]["value"] = valuesByContractFields[fieldName];
								}
							}
							// Does the current annex field have a value?
							if (valuesByAnnexFields.hasOwnProperty(fieldName) && SObject == "Anexo__c") {
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
							if (component.get("v.currentContractStage") == "Finalizado") {
								fieldsBySObjects[SObject][fieldName]["disabled"] = false;
								component.set("v.isFinishButtonDisabled", false);
								component.set("v.isSendButtonDisabled", true);
								component.set('v.isContractFinalized', false);
							}
							//fieldsBySObjects[SObject][fieldName]["required"] = false;
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
						tempSObject.contractSections = [];
						var fieldsByAnnexASections = [
							{
								name: "Condiciones Comerciales y Filiales del Cliente",
								listFields: [
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
							tempSObject.contractSections.push(tempObject);
							if (section.name === 'Condiciones Comerciales y Filiales del Cliente') {
								tempArray = [];
								tempObject = {};
								for (let field of tempSObject.fields) {
									if ((field.name === 'FechaContrato__c') || (field.name === 'NombreCliente__c')) {
										tempArray.push(field);
									}
								}
								tempObject = { name: 'Sin Nombre', fields: tempArray };
								tempSObject.sections.push(tempObject);
							}
						});
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						if (!(component.get("v.qliFormaPago") == "American Express")) {
							tempSObject.isVisible = false;
							tempSObject.fields = [];
						} else {
							tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						}
					}
					// Fields mapping between "Pantalla Funcionalidades" and "Anexo A"
					let campos = {
						FrecuenciaFacturacion__c: ['PeriodoFacturacion__c']
					}
					component.set("v.dependetFieldsCA", campos);
					// Fields mapping between "Pantalla Funcionalidades" and "Anexo A"
				} else if (component.get("v.contractTitle") == "Contrato Vale Despensas Edenred") {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo B") {
						tempSObject.sections.push({ name: "Proceso Operativo", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						if (!(component.get("v.qliFormaPago") == "American Express")) {
							tempSObject.isVisible = false;
							tempSObject.fields = [];
						} else {
							tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
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
				} else if (component.get("v.contractTitle") == "Contrato Clientes Ecovale Combustible") {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						if (!(component.get("v.qliFormaPago") == "American Express")) {
							tempSObject.isVisible = false;
							tempSObject.fields = [];
						} else {
							tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						}
					}
				} else if (component.get("v.contractTitle") == "Contrato Clientes Multiproducto") {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo B") {
						tempSObject.sections.push({ name: "Proceso Operativo", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						if (!(component.get("v.qliFormaPago") == "American Express") || (component.get("v.productCode") == "48") || (component.get("v.productCode") == "58")) {
							tempSObject.isVisible = false;
							tempSObject.fields = [];
						} else {
							tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						}
					}
				} else if ((component.get("v.contractTitle") == "Contrato Clientes TPlus Privado") || (component.get("v.contractTitle") == "Contrato Clientes TPlus Público")) {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo B") {
						tempSObject.sections.push({ name: "Proceso Operativo", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					}
				} else if ((component.get("v.contractTitle") == "Contrato Ecovale Despensa")) {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo C") {
						tempSObject.sections.push({ name: "Ley Antilavado y Protección de Datos Personales", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						if (!(component.get("v.qliFormaPago") == "American Express") || (component.get("v.productCode") == "48") || (component.get("v.productCode") == "58")) {
							tempSObject.isVisible = false;
							tempSObject.fields = [];
						} else {
							tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						}
					}
				} else if ((component.get("v.contractTitle") == "Contrato Clientes TVBE Papel")) {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						if (!(component.get("v.qliFormaPago") == "American Express") || (component.get("v.productCode") == "48") || (component.get("v.productCode") == "58")) {
							tempSObject.isVisible = false;
							tempSObject.fields = [];
						} else {
							tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						}
					}
				} else if ((component.get("v.contractTitle") == "Contrato Clientes TV Combustible Papel")) {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					} else if (tempSObject.name == "Campos Anexo D") {
						if (!(component.get("v.qliFormaPago") == "American Express") || (component.get("v.productCode") == "48") || (component.get("v.productCode") == "58")) {
							tempSObject.isVisible = false;
							tempSObject.fields = [];
						} else {
							tempSObject.sections.push({ name: "Cargos a Tarjetas American Express Sistema Tickets", fields: tempSObject.fields });
						}
					}
				} else if ((component.get('v.contractTitle') == CON_CLI_MAN)) {
					if (tempSObject.name == "Campos Anexo A") {
						tempSObject.sections.push({ name: "Condiciones Comerciales y Filiales del Cliente", fields: tempSObject.fields });
					}
					// Fields mapping between "Pantalla Funcionalidades" and "Anexo A"
					let fields = {
						FrecuenciaFacturacion__c: ['PeriodoFacturacion__c'],
						DepositoOperacional__c: ['MontoDO__c']
					}
					component.set("v.dependetFieldsCA", fields);
					// Fields mapping between "Pantalla Funcionalidades" and "Anexo A"
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
		// Show or Hide the field "Personalizacion_de_Tarjetas__c" depending on the current product (code). Else, Show or hide the "Layout - PT" button group depending on the value of such field
		// if ((component.get('v.productCode') === PRODUCT_CODE_3) || (component.get('v.productCode') === PRODUCT_CODE_9)) {
		// 	contractSections[0].fields.some(function(field) {
		// 		if (field.name === APINAME_PERS_TARJ) {
		// 			field.isVisible = false;
		// 			return true;
		// 		}
		// 	});
		// } else {
		// 	contractSections[0].fields.some(function(field) {
		// 		if (field.name === APINAME_PERS_TARJ) {
		// 			component.set('v.fieldPT', { label: LABEL_PERS_TARJ, name: field.name, value: field.value });
		// 			// component.set('v.fieldPT.value', field.value);
		// 			return true;
		// 		}
		// 	});
		// }
		// // Show or hide the "Layout - DA" button group depending on the value of such field
		// contractSections[0].fields.some(function(field) {
		// 	if (field.name === APINAME_DIREC_AUX) {
		// 		component.set('v.fieldDA', { label: LABEL_DIREC_AUX, name: field.name, value: field.value });
		// 		return true;
		// 	}
		// });
		
        
		for (let contractSection of contractSections) {
            
            if(component.get("v.contractTitle") == "Contrato Ticket Car 4.0"||component.get("v.contractTitle") == "Contrato Ticket Car 3.0"){
                if(contractSection.name=='Condiciones Operativas'){
                    for (let field of contractSection.fields) {
                        if(component.get("v.contractTitle") == "Contrato Ticket Car 4.0"){
                            if (field.name == 'Item_Contratacion__c') {
                                field.disabled=true;
                                //field.value='TC Avanzado';
                            }
                            if(field.name=='Controla_Presencia_Vehiculo_NFC__c'){
                                field.disabled=true;
                                //field.value=true;
                            }                        
                            if(field.name=='Modo_Transaccion__c'){
                                field.picklistEntries=[{"label":"Virtual","value":"Virtual"}]
                            }
                        }else if(component.get("v.contractTitle") == "Contrato Ticket Car 3.0"){
                            if(field.name=='Modo_Transaccion__c'){
                                //field.picklistEntries=[{"label":"Fisico","value":"Fisico"}]
                                if(component.get("v.productCode")=='30'){
                                    field.picklistEntries=[{"label":"Fisico","value":"Fisico"}]
                                }else if(component.get("v.productCode")=='30-B'){
                                    field.picklistEntries=[{"label":"Fisico","value":"Fisico"},{"label":"Virtual","value":"Virtual"}]
                                }
                            }
                        }
                    }
                }
            }
            
			for (let field of contractSection.fields) {
				if (field.name === APINAME_PERS_TARJ) {
					if ((component.get('v.productCode') === PRODUCT_CODE_3) || (component.get('v.productCode') === PRODUCT_CODE_9)) {
						field.isVisible = false;
					} else {
						component.set('v.fieldPT', { label: LABEL_PERS_TARJ, name: field.name, value: field.value });
					}
				} else if (field.name === APINAME_DIREC_AUX) {
					component.set('v.fieldDA', { label: LABEL_DIREC_AUX, name: field.name, value: field.value });
                    console.log('STRANGER ==> ');
                    console.log(component.get('v.fieldDA')['label']);
                    console.log(component.get('v.fieldDA')['name']);
                    console.log(component.get('v.fieldDA')['value']);
				}
			}
		}
		
        //console.log("VERRRRS"+JSON.stringify(contractSections));
        
		component.set("v.objectsByDocument", { contractSections: contractSections, annexes: annexes });
		component.set("v.isDataReady", true);
		var objectsByDocument = component.get("v.objectsByDocument");
		// console.log("getSections, annexes:", annexes);
		console.log("getSections, objectsByDocument:", objectsByDocument);
		console.log("getSections, contractSections:", contractSections);
		console.log("getSections, annexes:", annexes);
	},
	
	save : function(component, dataToSave, isToastVisible) {
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
				if (!dataToSave.contrato.hasOwnProperty("Id")) {
					dataToSave.contrato["Id"] = returnedValue.Id;
					component.set("v.dataToSave", dataToSave);
					component.set("v.currentContractStage", "En proceso");
				}
				if (!dataToSave.anexo.hasOwnProperty("Id")) {
					dataToSave.anexo["Id"] = returnedValue.Id;
					component.set("v.dataToSave", dataToSave);
				}
				//console.log("save, dataToSave:", dataToSave);
				component.set('v.isDataSaved', true);
				if (isToastVisible) {
					toastEvent.setParams({
						"duration": "10000",
						"type": "success",
						"title": "¡Éxito!",
						"message": "Los datos han sido guardados correctamente"
					});
					toastEvent.fire();
				}
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
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	validateOppAttachmentsFAC : function(component) {
		console.clear();
		// Constants
		const FILE_NAME_DIR_AUX = 'Direcciones Auxiliares';
		const FILE_NAME_ID_CLIE = 'Id. de Cliente';
		// Constants
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
				console.log("validateOppAttachmentsFAC(), returnedValue:", returnedValue);
				if (returnedValue && returnedValue.relatedAccount && returnedValue.relatedAccount.Account) {
					if (returnedValue.relatedAccount.Account.hasOwnProperty("TipoPersona__c")) {
						var documentationComplete = true;
						var accTypePerson = returnedValue.relatedAccount.Account.TipoPersona__c;
						var docsByTypePerson = returnedValue.docsByTypePerson[accTypePerson];
						console.log('validateOppAttachmentsFAC(), returnedValue.oppAttachments:', returnedValue.oppAttachments);
						console.log("validateOppAttachmentsFAC(), docsByTypePerson:", docsByTypePerson);
						docsByTypePerson.forEach(function(doc) {
							doc.loaded = false;
							returnedValue.oppAttachments.forEach(function(attachment) {
								// console.log('attachment:', attachment);
								if ((doc.apiName == "ContratoFirmado__c") || (doc.apiName == "AdjuntoA__c")) {
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
							// console.log("validateOppAttachmentsFAC, doc:", doc);
							if (!doc.loaded) {
								documentationComplete = false;
							}
						});
						console.log("validateOppAttachmentsFAC(), 1st stage, documentationComplete:", documentationComplete);
						if (documentationComplete) {
							// Checking if the "Id. de Cliente" file is already loaded
							if(component.get('v.fieldPT.value')) {
								let isIdClientePresent = returnedValue.oppAttachments.some(attachment => {
									return attachment.Name.includes(FILE_NAME_ID_CLIE);
								});
								// console.log('validateOppAttachmentsFAC(), 2nd stage, isIdClientePresent:', isIdClientePresent);
								if (!isIdClientePresent) {
									documentationComplete = false;
								}
							}
						} else {
							console.log("validateOppAttachmentsFAC(), 2nd stage, documentationComplete:", documentationComplete);
							this.finalizeContract(component, documentationComplete);
							return;
						}
						console.log("validateOppAttachmentsFAC(), 2nd stage, documentationComplete:", documentationComplete);
						if (documentationComplete) {
							let layoutLabel = '';
							// Checking if the field "Personalizacion_de_Tarjetas__c" is checked
							if (component.get('v.fieldPT.value')) {
								this.createActionPromise(component, {
									name: 'executeQuery',
									params: {
										query: 'SELECT Id, Label FROM PersonalizacionTarjetas__mdt WHERE CodigoProductos__c LIKE \'%' + component.get('v.productCode') + '%\' LIMIT 1'
									}
								})
								.then((response) => {
									console.log('validateOppAttachmentsFAC(), 1st response.getReturnValue():', response.getReturnValue());
									let { Id, Label } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', Label: '' };
									console.log('Id:', Id + ', Label:', Label);
									if (Label) {
										layoutLabel = Label;
										return this.createActionPromise(component, {
											name: 'executeQuery',
											params: {
												query: 'SELECT Id, Title FROM ContentDocument WHERE Title LIKE \'' + Label + '%\' LIMIT 1'
											}
										});
									} else {
										return Promise.reject(new Error(`El código de producto "${component.get('v.productCode')}" no está asociado con ningún layout de acuerdo al tipo de metadatos personalizados "Personalización Tarjetas"`));
									}
								})
								.then((response) => {
									// console.log('validateOppAttachmentsFAC(), 2nd response:', response);
									console.log('validateOppAttachmentsFAC(), 2nd response.getReturnValue():', response.getReturnValue());
									let { Id, Title } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', Title: '' };
									if (Title) {
										let isPTFilePresent = returnedValue.oppAttachments.some(attachment => {
											return attachment.Name.includes(Title);
										});
										console.log('validateOppAttachmentsFAC(), isPTFilePresent:', isPTFilePresent);
										if (!isPTFilePresent) {
											documentationComplete = false;
										}
										console.log("validateOppAttachmentsFAC(), 3rd stage, documentationComplete:", documentationComplete);
										if (documentationComplete) {
											// Checking if the field "DireccionesAuxiliares__c" is checked
											if (component.get('v.fieldDA.value')) {
												this.createActionPromise(component, {
													name: 'executeQuery',
													params: {
														query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.accountId') + '\''
													}
												})
												.then(response => {
													// console.log('validateOppAttachmentsFAC(), 1st response:', response);
													console.log('validateOppAttachmentsFAC(), 1st response.getReturnValue():', response.getReturnValue());
													let accountAttachments = (response.getReturnValue() && Array.isArray(response.getReturnValue())) ? response.getReturnValue() : [];
													let isDAFilePresent = accountAttachments.some(attachment => {
														return attachment.Name.includes(FILE_NAME_DIR_AUX);
													});
													console.log('validateOppAttachmentsFAC(), isDAFilePresent:', isDAFilePresent);
													if (!isDAFilePresent) {
														documentationComplete = false;
													}
													console.log("validateOppAttachmentsFAC(), 4th stage, documentationComplete:", documentationComplete);
													this.finalizeContract(component, documentationComplete);
												})
												.catch(error => {
													this.showError(error, 'Error en "helper.validateOppAttachmentsFAC()"');
												});
											} else {
												console.log("validateOppAttachmentsFAC(), 4th stage, documentationComplete:", documentationComplete);
												this.finalizeContract(component, documentationComplete);
											}
										} else {
											console.log("validateOppAttachmentsFAC(), 4th stage, documentationComplete:", documentationComplete);
											this.finalizeContract(component, documentationComplete);
										}
									} else {
										return Promise.reject(new Error(`No se encuentra ningún layout con una etiqueta similar a "${layoutLabel}" en el objeto "Archivo"`));
									}
								})
								.catch((error) => {
									this.showError(error, 'Error en "helper.validateOppAttachmentsFAC()"');
								});
							} else {
								// Checking if the field "DireccionesAuxiliares__c" is checked
								if (component.get('v.fieldDA.value')) {
									this.createActionPromise(component, {
										name: 'executeQuery',
										params: {
											query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.accountId') + '\''
										}
									})
									.then(response => {
										// console.log('validateOppAttachmentsFAC(), 1st response:', response);
										console.log('validateOppAttachmentsFAC(), 1st response.getReturnValue():', response.getReturnValue());
										let accountAttachments = (response.getReturnValue() && Array.isArray(response.getReturnValue())) ? response.getReturnValue() : [];
										let isDAFilePresent = accountAttachments.some(attachment => {
											console.log('accountAttachments[], attachment:', attachment);
											return attachment.Name.includes(FILE_NAME_DIR_AUX);
										});
										console.log('validateOppAttachmentsFAC(), isDAFilePresent:', isDAFilePresent);
										if (!isDAFilePresent) {
											documentationComplete = false;
										}
										console.log("validateOppAttachmentsFAC(), 3rd stage, documentationComplete:", documentationComplete);
										this.finalizeContract(component, documentationComplete);
									})
									.catch(error => {
										this.showError(error, 'Error en "helper.validateOppAttachmentsFAC()"');
									});
								} else {
									console.log("validateOppAttachmentsFAC(), 3rd stage, documentationComplete:", documentationComplete);
									this.finalizeContract(component, documentationComplete);
								}
							}
						} else {
							console.log("validateOppAttachmentsFAC(), 3rd stage, documentationComplete:", documentationComplete);
							this.finalizeContract(component, documentationComplete);
						}
					} else {
						toastEvent.setParams({
							"duration": "10000",
							"type": "warning",
							"title": "Advertencia",
							"message": "El campo 'Tipo de Persona' de la Cuenta de la Oportunidad no tiene un valor definido"
						});
					}
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
	
	validateAttachments: function(component) {
		// console.clear();
		// Constants
		const FILE_NAME_DIR_AUX = 'Direcciones Auxiliares';
		// Constants
		// Variables
		let documentationComplete = true;
		let layoutLabel = '';
		let layoutTitle = '';
		let oppAttachments = [];
		let daToastEvent = $A.get('e.force:showToast');
		let ptToastEvent = $A.get('e.force:showToast');
		// Variables
		daToastEvent.setParams({
			duration: '10000',
			type: 'warning',
			title: 'Advertencia',
			message: 'Falta anexar el Layout de Direcciones Auxiliares'
		});
		ptToastEvent.setParams({
			duration: '10000',
			type: 'warning',
			title: 'Advertencia',
			message: 'Falta anexar el correspondiente Layout de Personalización de Tarjetas'
		});
		// Checking if the field "Personalizacion_de_Tarjetas__c" is checked
		if (component.get('v.fieldPT.value')) {
			this.createActionPromise(component, {
				name: 'executeQuery',
				params: {
					query: 'SELECT Id, Label FROM PersonalizacionTarjetas__mdt WHERE CodigoProductos__c LIKE \'%' + component.get('v.productCode') + '%\' LIMIT 1'
				}
			})
			.then(response => {
				console.log('validateAttachments(), 1st response.getReturnValue():', response.getReturnValue());
				let { Id, Label } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', Label: '' };
				console.log('Id:', Id + ', Label:', Label);
				if (Label) {
					layoutLabel = Label;
					return this.createActionPromise(component, {
						name: 'executeQuery',
						params: {
							query: 'SELECT Id, Title FROM ContentDocument WHERE Title LIKE \'' + Label + '%\' LIMIT 1'
						}
					});
				} else {
					return Promise.reject(new Error(`El código de producto "${component.get('v.productCode')}" no está asociado con ningún layout de acuerdo al tipo de metadatos personalizados "Personalización Tarjetas"`));
				}
			})
			.then(response => {
				console.log('validateAttachments(), 2nd response.getReturnValue():', response.getReturnValue());
				let { Id, Title } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', Title: '' };
				console.log('Id: ' + Id, 'Title: ' + Title);
				if (Title) {
					layoutTitle = Title;
					return this.createActionPromise(component, {
						name: 'executeQuery',
						params: {
							query: 'SELECT Id, Name, ParentId FROM Attachment WHERE ((ParentId = \'' + component.get('v.opportunityId') + '\' AND Name LIKE \'' + Title + '%\') OR (ParentId = \'' + component.get('v.accountId') + '\' AND Name LIKE \'' + FILE_NAME_DIR_AUX + '%\'))'
						}
					});
				} else {
					return Promise.reject(new Error(`No se encuentra ningún layout con una etiqueta similar a "${layoutLabel}" en el objeto "Archivo"`));
				}
			})
			.then(response => {
				console.log('validateAttachments(), 3rd response.getReturnValue():', response.getReturnValue());
				if (response && response.getReturnValue && response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
					oppAttachments = response.getReturnValue();
					let isPTFilePresent = oppAttachments.some(attachment => {
						return attachment.Name.includes(layoutTitle);
					});
					console.log('validateAttachments(), isPTFilePresent:', isPTFilePresent);
					if (!isPTFilePresent) {
						documentationComplete = false;
						ptToastEvent.fire();
					}
					console.log("validateAttachments(), 1st stage, documentationComplete:", documentationComplete);
					if (documentationComplete) {
						// Checking if the field "DireccionesAuxiliares__c" is checked
						if (component.get('v.fieldDA.value')) {
							let isDAFilePresent = oppAttachments.some(attachment => {
								return attachment.Name.includes(FILE_NAME_DIR_AUX);
							});
							console.log('validateAttachments(), isDAFilePresent:', isDAFilePresent);
							if (!isDAFilePresent) {
								documentationComplete = false;
								daToastEvent.fire();
							}
							console.log("validateAttachments(), 2nd stage, documentationComplete:", documentationComplete);
							this.finalizeContract(component, documentationComplete);
						} else {
							console.log("validateAttachments(), 2nd stage, documentationComplete:", documentationComplete);
							this.finalizeContract(component, documentationComplete);
						}
					} else {
						console.log("validateOppAttachmentsFAC(), 1st stage, documentationComplete:", documentationComplete);
						this.finalizeContract(component, documentationComplete);
					}
				} else {
					documentationComplete = false;
					ptToastEvent.fire();
					console.log("validateAttachments(), 1st stage, documentationComplete:", documentationComplete);
					this.finalizeContract(component, documentationComplete);
					// return Promise.reject(new Error('No se encontraron los correspondientes Archivos Adjuntos de la Oportunidad y/o de la Cuenta'));
				}
			})
			.catch((error) => {
				this.showError(error, 'Error en "helper.validateAttachments()"');
			});
		} else {
			// Checking if the field "DireccionesAuxiliares__c" is checked
			if (component.get('v.fieldDA.value')) {
				this.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.accountId') + '\' AND Name LIKE \'' + FILE_NAME_DIR_AUX + '%\''
					}
				})
				.then(response => {
					// console.log('validateAttachments(), 1st response:', response);
					console.log('validateAttachments(), 1st response.getReturnValue():', response.getReturnValue());
					if (response && response.getReturnValue && response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
						let accountAttachments = response.getReturnValue();
						let isDAFilePresent = accountAttachments.some(attachment => {
							return attachment.Name.includes(FILE_NAME_DIR_AUX);
						});
						console.log('validateAttachments(), isDAFilePresent:', isDAFilePresent);
						if (!isDAFilePresent) {
							documentationComplete = false;
							daToastEvent.fire();
						}
						console.log("validateAttachments(), 1st stage, documentationComplete:", documentationComplete);
						this.finalizeContract(component, documentationComplete);
					} else {
						documentationComplete = false;
						daToastEvent.fire();
						console.log("validateAttachments(), 1st stage, documentationComplete:", documentationComplete);
						this.finalizeContract(component, documentationComplete);
						// return Promise.reject(new Error(`No se encontró ningún Archivo Adjunto "${FILE_NAME_DIR_AUX}" asociado a la Cuenta`));
					}
				})
				.catch(error => {
					this.showError(error, 'Error en "helper.validateAttachments()"');
				});
			} else {
				console.log("validateAttachments(), 1st stage, documentationComplete:", documentationComplete);
				this.finalizeContract(component, documentationComplete, false);
			}
		}
	},
	
	finalizeContract: function(component, documentationComplete, isThereAnyFileFlag) {
		if (documentationComplete) {
			let isThereAnyFile = (isThereAnyFileFlag !== undefined) ? isThereAnyFileFlag : true;
			let dataToSave = component.get('v.dataToSave');
			dataToSave.finalizar = 'finalizar';
			console.log(JSON.stringify(dataToSave));
			this.createActionPromise(component, {
				name: 'guardaContrato',
				params: {
					strData: JSON.stringify(dataToSave)
				}
			})
			.then(response => {
				console.log('helper.finalizeContract(), 1st response');
				// console.log('helper.finalizeContract(), response.getReturnValue():', response.getReturnValue());
				// Is the documentation complete?
				console.log('helper.finalizeContract(), documentationComplete:', documentationComplete);
				// if (documentationComplete) {
					let objectsByDocument = component.get('v.objectsByDocument');
					/*for (let objectDocument in objectsByDocument) {
						if (objectsByDocument.hasOwnProperty(objectDocument)) {
							objectsByDocument[objectDocument].forEach(function(sectionByObject) {
								sectionByObject.fields.forEach(function(field) {
									field.disabled = true;
								});
							});
						}
					}*/
					component.set('v.objectsByDocument', objectsByDocument);
					// let dataToSave = component.get("v.dataToSave");
					// dataToSave.finalizar = "finalizar";
					// console.log(JSON.stringify(dataToSave));
					if (isThereAnyFile) {
						let toastEvent = $A.get('e.force:showToast');
						toastEvent.setParams({
							duration: '10000',
							type: 'success',
							title: '¡Éxito!',
							message: 'La documentación está completa: Contrato Finalizado'
						});
						toastEvent.fire();
					} else {
						let toastEvent = $A.get('e.force:showToast');
						toastEvent.setParams({
							duration: '10000',
							type: 'success',
							title: '¡Éxito!',
							message: 'Contrato Finalizado'
						});
						toastEvent.fire();
					}
					// this.save(component, JSON.stringify(dataToSave));
					component.set('v.isFinishButtonDisabled', true);
					component.set('v.isSendButtonDisabled', false);
					component.set('v.isContractFinalized', false);
				/* } else {
					let toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						duration: '10000',
						type: 'warning',
						title: 'Advertencia',
						message: 'Falta anexar algunos documentos a la oportunidad'
					});
					toastEvent.fire();
				} */
			})
			.catch(error => {
				console.log('helper.finalizeContract(), error:', error);
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					duration: '10000',
					type: 'error',
					title: 'Error',
					message: 'Ocurrió un problema al guardar los datos. Revise que el valor de los campos sea apropiado así como también que los correos electrónicos respeten el formato "usuario@compañia.com"'
				});
				toastEvent.fire();
			});
		}
	},
	
	getLegalRepresentative: function(component, oppId) {
		var action = component.get("c.executeQuery");
		action.setParams({
			query: "SELECT Id, Contacto__r.Email FROM Opportunity WHERE Id = '" + oppId + "' AND Contacto__r.Funcion__c = 'Representante Legal'"
		});
		action.setCallback(this, function(response) {
			if (response && (response.getState() === "SUCCESS")) {
				var returnedValue = response.getReturnValue();
				if (returnedValue && Array.isArray(returnedValue) && (returnedValue.length > 0)) {
					if (returnedValue[0].hasOwnProperty('Contacto__r') && returnedValue[0].Contacto__r.hasOwnProperty('Id') && returnedValue[0].Contacto__r.hasOwnProperty('Email')) {
						this.getQuoteDocument(component, returnedValue[0].Contacto__r);
					} else {
						component.set('v.isSending', false);
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"mode": "sticky",
							"type": "warning",
							"title": "Advertencia",
							"message": "Ocurrió un problema al obtener la información del Contacto"
						});
						toastEvent.fire();
					}
				} else {
					component.set('v.isSending', false);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"mode": "sticky",
						"type": "warning",
						"title": "Advertencia",
						"message": "Para poder enviar por email el contrato es necesario que la Oportunidad tenga asociada un Contacto con función de Representante Legal"
					});
					toastEvent.fire();
				}
			} else {
				component.set('v.isSending', false);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"duration": "10000",
					"type": "error",
					"title": "Error",
					"message": "Ocurrió un problema al obtener los Contactos de la Oportunidad"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	
	getQuoteDocument: function(component, legalRepresentativeData) {
		// Constants
		const FUNC_NAME = 'helper.getQuoteDocument()';
		// Constants
		// Variables
		let templateId = '';
		// Variables
		// console.log(FUNC_NAME, '> legalRepresentativeData >>>', legalRepresentativeData);
		this.createActionPromise(component, {
			name: 'executeQuery',
			params: {
				query: 'SELECT Id FROM EmailTemplate WHERE DeveloperName = \'Envio_del_contrato\' LIMIT 1'
			}
		})
		.then(response => {
			// console.log(FUNC_NAME, '> response >>>', response);
			if (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
				templateId = response.getReturnValue()[0].Id;
				return this.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT IdPDFContrato__c FROM Quote WHERE Id = \'' + component.get('v.quoteId') + '\' LIMIT 1'
					}
				});
			} else {
				return Promise.reject(new Error('No se encontró la plantilla de correo electrónico "Envio_del_contrato"'));
			}
		})
		.then(response => {
			// console.log(FUNC_NAME, '> response >>>', response);
			if (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
				let returnedValue = response.getReturnValue()[0];
				if (returnedValue.hasOwnProperty('IdPDFContrato__c')) {
					window.open('/one/one.app#/alohaRedirect/_ui/core/email/author/EmailAuthor?p2_lkid=' + legalRepresentativeData.Id + '&p3_lkid=' + component.get('v.opportunityId') + '&doc_id=' + returnedValue.IdPDFContrato__c + '&p24=' + legalRepresentativeData.Email + '&template_id=' + templateId + '&saveURL=' + component.get('v.opportunityId'));
				} else {
					let toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						duration: '10000',
						type: 'warning',
						title: 'Advertencia',
						message: 'La Cotización no tiene asociada un Contrato'
					});
					toastEvent.fire();
				}
				component.set('v.isSending', false);
			} else {
				component.set('v.isSending', false);
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					duration: '10000',
					type: 'warning',
					title: 'Advertencia',
					message: 'Esta Cotización no tiene un Contrato para enviar'
				});
				toastEvent.fire();
			}
		})
		.catch(error => {
			this.showError(error, 'Error en "helper.getQuoteDocument()"');
		});
	},
	
	createActionPromise: function(component, action) {
		return new Promise($A.getCallback((resolve, reject) => {
			let { name, params } = action;
			let a = component.get('c.' + name);
			a.setParams(params);
			a.setCallback(this, response => {
				// DO NOT USE "this"
				// console.log('createActionPromise(), response:', response);
				console.log('createActionPromise(), response.getState():', response.getState());
				// console.log('createActionPromise(), response.getReturnValue():', response.getReturnValue());
				if (response.getState() === 'SUCCESS') {
					let returnedValue = response.getReturnValue();
					if (!('exceptionTypeName' in returnedValue)) {
						resolve(response);
					} else {
						reject(new Error('Error en "helper.createActionPromise()":' + returnedValue.message + ', Rastreo de Pila: ' + returnedValue.stackTraceString));
					}
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(a);
		}));
	},
	
	showError: function(error, customErrorMessage) {
		customErrorMessage = customErrorMessage ? customErrorMessage + '. ' : '';
		try {
			if ((typeof error) === 'object') {
				console.log('showError(), error:', error);
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					mode: 'sticky',
					type: 'error',
					title: '¡Error!',
					message: customErrorMessage + 'Nombre del Error: ' + error.name + '. Mensaje: ' + error.message
				});
				toastEvent.fire();
			} else {
				throw new Error('Error en "helper.showError()": El argumento "error" debe ser de tipo "Object"');
			}
		} catch(e) {
			console.log('e:', e);
		}
	}
})