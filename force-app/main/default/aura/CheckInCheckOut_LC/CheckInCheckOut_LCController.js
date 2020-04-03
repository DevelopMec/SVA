({
	init : function(component, event, helper) {
		navigator.geolocation.getCurrentPosition(function(position) {
			console.log('\n\n coordenadas: ', position, '\n\n')
		})
		component.set("v.URL", "CheckInCheckOutMap_VFP");
		component.set("v.lcHost", window.location.hostname);
		//console.log('RecordId:', component.get('v.recordId'));
		var userId = $A.get("$SObjectType.CurrentUser.Id");
		// component.set("v.userId", userId);
		// console.log($A.get("$SObjectType.CurrentUser.Id"));
		// Helper calls
		//helper.getTodayDateFAC(component);
		//helper.getEventInformationFAC(component);
		//helper.getEstatusEventoOptionsFAC(component);
		//helper.getComentariosValoracionOptionsFAC(component);
		helper.getUIThemeFAC(component, userId);
		// Helper calls
		
		window.addEventListener("message", function(message) {
			message = message && message.data ? message.data : undefined;
			// console.log("LC - Incoming message:", message);
			// component.set("v.log", JSON.stringify(message));
			if(message) {
				var action = message.action || "Unknown";
				if(action == "render") {
					//console.log("The VFP was rendered");
					component.set("v.vfHost", message.vfHost);
					helper.loadGoogleMap(component, helper);
					component.set("v.loading", true);
				} else if (action == "currentPositionData") {
					//console.log("action: currentPositionData");
					var data = message.data || {};
					var origin = message.origin || "";
					if (component.get("v.sEstatusEvento") == "Planeado") {
						//console.log("EstatusEvento = Planeado");
						let { address = [] } = data;
						component.set("v.sFullStartLocation", (((typeof address[1] !== 'undefined') && (typeof address[1].long_name !== 'undefined')) ? (address[1].long_name + ', ') : '') + (((typeof address[2] !== 'undefined') && (typeof address[2].long_name !== 'undefined')) ? ('Colonia ' + address[2].long_name + ', ') : '') + (((typeof address[4] !== 'undefined') && (typeof address[4].long_name !== 'undefined')) ? ('Delegación ' + address[4].long_name + ', ') : '') + (((typeof address[5] !== 'undefined') && (typeof address[5].long_name !== 'undefined')) ? (address[5].long_name + ', ') : '') + (((typeof address[7] !== 'undefined') && (typeof address[7].long_name !== 'undefined')) ? ('C.P.: ' + address[7].long_name) : ''));
						component.set("v.posData", data.coordinates);
						component.set("v.bShowCheckIn", false);
						if (origin == "doCheckIn") {
							helper.saveCheckInData(component);
							component.set("v.loading", false);
						}
					} else if (component.get("v.sEstatusEvento") == "Iniciado") {
						//console.log("EstatusEvento = Iniciado");
						let { address = [] } = data;
						component.set("v.sFullEndLocation", (((typeof address[1] !== 'undefined') && (typeof address[1].long_name !== 'undefined')) ? (address[1].long_name + ', ') : '') + (((typeof address[2] !== 'undefined') && (typeof address[2].long_name !== 'undefined')) ? ('Colonia ' + address[2].long_name + ', ') : '') + (((typeof address[4] !== 'undefined') && (typeof address[4].long_name !== 'undefined')) ? ('Delegación ' + address[4].long_name + ', ') : '') + (((typeof address[5] !== 'undefined') && (typeof address[5].long_name !== 'undefined')) ? (address[5].long_name + ', ') : '') + (((typeof address[7] !== 'undefined') && (typeof address[7].long_name !== 'undefined')) ? ('C.P.: ' + address[7].long_name) : ''));
						component.set("v.posData", data.coordinates);
						//component.set('v.bShowCheckOut', false);
						if (origin == "doCheckOut") {
							helper.saveCheckOutData(component);
							component.set("v.loading", false);
							helper.getPicklistValues(component, helper);
						}
					} else if (component.get("v.sEstatusEvento") == "Finalizado") {
						//console.log("EstatusEvento = Finalizado");
						if (origin == "initMap") {
							//console.log("Finalizado, component.get(\"v.oEndCoordinates\"):", component.get("v.oEndCoordinates"));
							helper.getCurrentPositionData(component, "LoadEndLocation", component.get("v.oEndCoordinates"));
						}
					}
					component.set("v.loading", false);
				} else if (action == "getDesiredPicklistValues") {
					//console.log("action: getDesiredPicklistValues");
					var data = message.data || {};
					var cvArray = [];
					//console.log("getDesiredPicklistValues, data:", data);
					for (var index in data) {
						cvArray.push(data[index]);
					}
					//console.log("getDesiredPicklistValues, cvArray:", cvArray);
					component.set("v.oCVOptions", cvArray);
				} else {
					//console.log("Unprocessed action:", message.action, "data:", message.data);
				}
			} else {
				//console.log("Error communicating with the VFP");
			}
		}, false);
	},
	
	doCheckIn : function(component, event, helper) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var coordinates = {
				lat: position.coords.latitude,
				lng: position.coords.longitude
				//lat: 19.7,
				//lng: -103.4666
			};
			helper.getCurrentPositionData(component, "doCheckIn", coordinates);
			// helper.saveCheckInData(component);
			component.set("v.loading", true);
			//console.time("loading");
		});
	},
	
	doCheckOut : function(component, event, helper) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var coordinates = {
				lat: position.coords.latitude,
				lng: position.coords.longitude
				//lat: 19.7,
				//lng: -103.4666
			};
			helper.getCurrentPositionData(component, "doCheckOut", coordinates);
			component.set("v.loading", true);
		});
	},
	
	/*saveEventAssessment : function(component, event, helper) {
		var defaultOption;
		if ($A.util.isArray(component.find("defaultSelectOption"))) {
			defaultOption = component.find("defaultSelectOption")[0];
		} else {
			defaultOption = component.find("defaultSelectOption");
		}
		console.log("saveEventAssessment, defaultOption:", defaultOption);
		var cvOptions = component.find("aiCVOptions");
		var cvOptionsValue = "";
		if (cvOptions && cvOptions.get) {
			cvOptionsValue = cvOptions.get("v.value");
			console.log("saveEventAssessment, cvOptionsValue:", cvOptionsValue);
			if (defaultOption && defaultOption.get) {
				console.log("saveEventAssessment, defaultOption.get(\"v.value\"):", defaultOption.get("v.value"));
				if (defaultOption.get("v.value") && !(cvOptionsValue.includes("Ninguno"))) {
					cvOptionsValue += ";Ninguno";
				}
			}
		}
		console.log("saveEventAssessment, cvOptionsValue:", cvOptionsValue);
		var comment = component.find("aiComentario");
		var commentValue = "";
		if (comment && comment.get) {
			commentValue = comment.get("v.value");
		}
		var toastEvent = $A.get("e.force:showToast");
		var action = component.get("c.updateEvent");
		action.setParams({
			eventId: component.get("v.recordId"),
			status: component.get("v.sEstatusEvento"),
			assessment: component.get("v.sVCOption"),
			assessmentOptions: cvOptionsValue,
			assessmentComment: commentValue
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				//console.log("saveEventAssessment, value:", value);
				toastEvent.setParams({
					"duration": "1000",
					"title": "¡Éxito!",
					"message": "Tu evaluación ha sido guardada correctamente",
					"type": "success"
				});
			} else {
				//console.log("saveEventAssessment, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"title": "¡Error!",
					"message": "Hubo un problema al guardar los datos",
					"type": "error"
				});
			}
			$A.get('e.force:closeQuickAction').fire();
			$A.get('e.force:refreshView').fire();
			toastEvent.fire();
		});
		$A.enqueueAction(action);
		//$A.get('e.force:closeQuickAction').fire();
		//helper.getEventInformationFAC(component);
		/*var cvOptions = component.find("aiCVOptions");
		console.log("saveEventExperience, cvOptions:", cvOptions.get("v.value"));
		var comentario = component.find("aiComentario");
		console.log("saveEventExperience, comentario:", comentario.get("v.value"));
		console.log("saveEventExperience, v.sVCOption:", component.get("v.sVCOption"));*/
	//},
	
	changeIcon1 : function(component, event, helper) {
		if (component.get('v.bLIFav1')) {
			component.set('v.bLIFav1', false);
			component.set("v.sVCOption", "Pesimo");
			helper.getPicklistValues(component, helper, "Pesimo");
		} else if (!component.get('v.bLIFav2')) {
			helper.restoreIcons(component);
			component.set('v.bLIFav1', false);
			component.set("v.sVCOption", "Pesimo");
			helper.getPicklistValues(component, helper, "Pesimo");
		} else {
			component.set('v.bLIFav1', true);
			component.set("v.sVCOption", "");
			helper.getPicklistValues(component, helper);
		}
	},
	
	changeIcon2 : function(component, event, helper) {
		if (component.get('v.bLIFav2')) {
			component.set('v.bLIFav1', false);
			component.set('v.bLIFav2', false);
			component.set("v.sVCOption", "Malo");
			helper.getPicklistValues(component, helper, "Malo");
		} else if (!component.get('v.bLIFav3')) {
			helper.restoreIcons(component);
			component.set('v.bLIFav1', false);
			component.set('v.bLIFav2', false);
			component.set("v.sVCOption", "Malo");
			helper.getPicklistValues(component, helper, "Malo");
		} else {
			component.set('v.bLIFav1', true);
			component.set('v.bLIFav2', true);
			component.set("v.sVCOption", "");
			helper.getPicklistValues(component, helper);
		}
	},
	
	changeIcon3 : function(component, event, helper) {
		//console.log("changeIcon3", event.target);
		if (component.get('v.bLIFav3')) {
			component.set('v.bLIFav1', false);
			component.set('v.bLIFav2', false);
			component.set('v.bLIFav3', false);
			component.set("v.sVCOption", "Regular");
			helper.getPicklistValues(component, helper, "Regular");
		} else if (!component.get('v.bLIFav4')) {
			helper.restoreIcons(component);
			component.set('v.bLIFav1', false);
			component.set('v.bLIFav2', false);
			component.set('v.bLIFav3', false);
			component.set("v.sVCOption", "Regular");
			helper.getPicklistValues(component, helper, "Regular");
		} else {
			component.set('v.bLIFav1', true);
			component.set('v.bLIFav2', true);
			component.set('v.bLIFav3', true);
			component.set("v.sVCOption", "");
			helper.getPicklistValues(component, helper);
		}
	},
	
	changeIcon4 : function(component, event, helper) {
		if (component.get('v.bLIFav4')) {
			component.set('v.bLIFav1', false);
			component.set('v.bLIFav2', false);
			component.set('v.bLIFav3', false);
			component.set('v.bLIFav4', false);
			component.set("v.sVCOption", "Bien");
			helper.getPicklistValues(component, helper, "Bien");
		} else if (!component.get('v.bLIFav5')) {
			helper.restoreIcons(component);
			component.set('v.bLIFav1', false);
			component.set('v.bLIFav2', false);
			component.set('v.bLIFav3', false);
			component.set('v.bLIFav4', false);
			component.set("v.sVCOption", "Bien");
			helper.getPicklistValues(component, helper, "Bien");
		} else {
			component.set('v.bLIFav1', true);
			component.set('v.bLIFav2', true);
			component.set('v.bLIFav3', true);
			component.set('v.bLIFav4', true);
			component.set("v.sVCOption", "");
			helper.getPicklistValues(component, helper);
		}
	},
	
	changeIcon5 : function(component, event, helper) {
		if (component.get('v.bLIFav5')) {
			component.set('v.bLIFav1', false);
			component.set('v.bLIFav2', false);
			component.set('v.bLIFav3', false);
			component.set('v.bLIFav4', false);
			component.set('v.bLIFav5', false);
			component.set("v.sVCOption", "Excelente");
			helper.getPicklistValues(component, helper, "Excelente");
		} else {
			helper.restoreIcons(component);
			component.set("v.sVCOption", "");
			helper.getPicklistValues(component, helper);
		}
	},
	
	deselectDefaultOption : function(component, event, helper) {
		// var defaultOption = component.find("defaultSelectOption");
		// // console.log("deselectDefaultOption, defaultOption:", defaultOption);
		// var log = component.get("v.log");
		// var defaultOptionClass = defaultOption.get("v.label");
		// console.log("deselectDefaultOption, defaultOptionClass:", defaultOptionClass);
		// log += ", " + defaultOptionClass;
		// component.set("v.log", log);
		// console.log("deselectDefaultOption, defaultOption.get(\"v.value\"):", defaultOption.get("v.value"));
		// console.log("deselectDefaultOption, defaultOption.get(\"v.label\"):", defaultOption.get("v.label"));
		// defaultOption.set("v.value", true);
		// console.log("deselectDefaultOption, defaultOption.get(\"v.value\"):", defaultOption.get("v.value"));
		// defaultOption.set("v.value", false);
		// console.log("deselectDefaultOption, defaultOption.get(\"v.value\"):", defaultOption.get("v.value"));
		// if (defaultOption && defaultOption.destroy) {
		// 	defaultOption.destroy();
		// }
		// defaultOption.set("v.value", false);
		// defaultOption.set("v.disabled", true);
		// var defaultOption = event.getEventSource();
		// console.log("deselectDefaultOption, defaultOption:", defaultOption);
		// defaultOption.set("v.value", false);
		component.set("v.isDefaultOptionSelected", false);
	},
    
    checkButtonActivation : function(component, event, helper) {
        helper.checkButtonActivationHelper(component);
    }
})