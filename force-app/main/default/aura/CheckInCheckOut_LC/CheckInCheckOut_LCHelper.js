({
	saveCheckOutData : function(component) {
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
		var toastEvent = $A.get('e.force:showToast');
		var action = component.get("c.updateEvent");
		action.setParams({
			eventId: component.get("v.recordId"),
			status: component.get("v.sEstatusEvento"),
			endAddress: component.get("v.sFullEndLocation"),
            assessment: component.get("v.sVCOption"),
			assessmentOptions: cvOptionsValue,
			assessmentComment: commentValue
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				//console.log("doCheckOut, value:", value);
				component.set("v.bShowStartEventInfo", false);
				this.saveEndLocationFAC(component, component.get("v.posData"));
				component.set("v.datiFechaHoraFin", value.FechaHoraFin__c);
				component.set("v.sEstatusEvento", value.EstatusEvento__c);
				component.set("v.sFullEndLocation", value.DireccionFin__c);
				toastEvent.setParams({
					"duration": "1000",
					"title": "¡Éxito!",
					"message": "Haz hecho Check-Out correctamente",
					"type": "success"
				});
			} else {
				//console.log("doCheckOut, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"title": "¡Error!",
					"message": "Hubo un problema al guardar los datos",
					"type": "error"
				});
			}
			$A.get('e.force:refreshView').fire();
			toastEvent.fire();
		});
		$A.enqueueAction(action);
        
		//$A.get('e.force:closeQuickAction').fire();
	},
	
	saveCheckInData : function(component) {
		var toastEvent = $A.get('e.force:showToast');
		var action = component.get("c.updateEvent");
		action.setParams({
			eventId: component.get("v.recordId"),
			status: component.get("v.sEstatusEvento"),
			startAddress: component.get("v.sFullStartLocation")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				//console.log("doCheckIn, value:", value);
				this.saveStartLocationFAC(component, component.get("v.posData"));
				//helper.getCurrentAddress(component, helper);
				component.set("v.datiFechaHoraInicio", value.FechaHoraInicio__c);
				component.set("v.sEstatusEvento", value.EstatusEvento__c);
				component.set("v.sFullStartLocation", value.DireccionInicio__c);
				//component.set("v.bShowCheckOut", false);
				//console.timeEnd("loading");
				toastEvent.setParams({
					"duration": "1000",
					"title": "¡Éxito!",
					"message": "Haz hecho Check-In correctamente",
					"type": "success"
				});
			} else {
				//console.log("doCheckIn, state:", state);
				toastEvent.setParams({
					"duration": "1000",
					"title": "¡Error!",
					"message": "Hubo un problema al guardar los datos",
					"type": "error"
				});
			}
			$A.get('e.force:refreshView').fire();
			toastEvent.fire();
		});
		$A.enqueueAction(action);
		//$A.get('e.force:closeQuickAction').fire();
	},
	
	getCurrentPositionData : function(component, origin, coordinates) {
		//console.log("getCurrentPositionData, arguments:", arguments);
		var message = {
			action: "getCurrentPositionData",
			//coordinates: { lat: 19.7, lng: -103.4666 }
			origin: origin,
			coordinates: coordinates
		};
		var ctcMap_Page = component.find("ctcMap_Page")
		if( ctcMap_Page && typeof ctcMap_Page.getElement  == 'function' ) {
			var vfWindow = component.find("ctcMap_Page").getElement().contentWindow;
			vfWindow.postMessage(JSON.parse(JSON.stringify(message)), component.get("v.vfHost"));
		}
	},
	
	getPicklistValues: function(component, helper, option) {
		var message = {
			action: "getDesiredPicklistValues",
			origin: window.location.hostname,
			field: "ValoracionCita__c",
			fieldChild: "ComentariosValoracion__c",
			value: option
		};
		var ctcMap_Page = component.find("ctcMap_Page")
		if( ctcMap_Page && typeof ctcMap_Page.getElement  == 'function' ) {
			var vfWindow = component.find("ctcMap_Page").getElement().contentWindow;
			vfWindow.postMessage(JSON.parse(JSON.stringify(message)), component.get("v.vfHost"));
		}
	},
	
	loadGoogleMap : function(component, helper) {
        
        navigator.geolocation.getCurrentPosition(function(position) {
            var coordinates = {
				lat: position.coords.latitude,
				lng: position.coords.longitude
			}
			var message = {
                action: "loadGoogleMap",
                origin: window.location.hostname,
				coordinates: coordinates
			};
			var ctcMap_Page = component.find("ctcMap_Page")
			if( ctcMap_Page && typeof ctcMap_Page.getElement  == 'function' ) {
				var vfWindow = component.find("ctcMap_Page").getElement().contentWindow;
				vfWindow.postMessage(JSON.parse(JSON.stringify(message)), component.get("v.vfHost"));
			}
        })
	},
	
	saveStartLocationFAC : function(component, message) {
		//console.log("saveStartLocationFAC, arguments:", arguments)
		var action = component.get("c.saveStartLocation");
		action.setParams({
			"eventLocation": {
				Id: component.get("v.recordId"),
				UbicacionInicio__Latitude__s: message.lat,
				UbicacionInicio__Longitude__s: message.lng
			}
		});
		action.setCallback(this, function(response) {
			//console.log("saveStartLocationFAC, response.getReturnValue():", response.getReturnValue());
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				//console.log("saveStartLocationFAC, value:", value);
				/*component.set("v.oStartEventLocation", {
					Latitude: value.UbicacionInicio__Latitude__s,
					Longitude: value.UbicacionInicio__Longitude__s
				});*/
			} else {
				//console.log("saveStartLocationFAC, state:", state);
			}
			//var loadData = component.get('c.loadData')
			//loadData(component, {}, helper)
			//console.log('loadData: ', loadData)
			//component.init();
		});
		$A.enqueueAction(action);
	},
	
	saveEndLocationFAC : function(component, message) {
		//console.log("saveEndLocationFAC, arguments:", arguments)
		var action = component.get("c.saveEndLocation");
		action.setParams({
			"eventLocation": {
				Id: component.get("v.recordId"),
				UbicacionFin__Latitude__s: message.lat,
				UbicacionFin__Longitude__s: message.lng
			}
		});
		action.setCallback(this, function(response) {
			//console.log("saveEndLocationFAC, response.getReturnValue():", response.getReturnValue());
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				//console.log("saveEndLocationFAC, value;", value);
			} else {
				//console.log("saveEndLocationFAC, state:", state);
			}
		});
		$A.enqueueAction(action);
	},
	
	restoreIcons : function(component) {
		component.set('v.bLIFav1', true);
		component.set('v.bLIFav2', true);
		component.set('v.bLIFav3', true);
		component.set('v.bLIFav4', true);
		component.set('v.bLIFav5', true);
	},
	
	getEventInformationFAC : function(component) {
		var action = component.get("c.getEventInformation");
		action.setParams({
			eventId: component.get("v.recordId")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				//console.log("getEventInformationFAC, value:", value);
				component.set("v.events", value);
				/*var startDate = new Date(value.StartDateTime);
				startDate = startDate.getFullYear() + '-' + (startDate.getMonth() + 1) + '-' + startDate.getDate();*/
				let startDate = value.StartDateTime.split('T')[0].toString();
				//console.log(startDate);
				startDate = startDate.replace(/-0+/g, '-');
				var todayDate = component.get("v.daTodayDate");
				//console.log(todayDate);
				todayDate = todayDate.replace(/-0+/g, '-');
				//console.log("getEventInformationFAC, startDate:", startDate, "todayDate:", todayDate);
				if (1 == 1) {
					//if (true) {
					var requiredFields = "";
					//console.log("Las fechas coinciden");
					component.set("v.bItsToday", true);
					component.set("v.sEstatusEvento", value.EstatusEvento__c);
					component.set("v.sEventsName", value.Asunto__c);
					if (value.hasOwnProperty("Who")) {
						component.set("v.sContactName", value.Who.Name);
					} else {
						requiredFields += 'Contacto';
					}
					component.set("v.datiFechaHoraInicio", value.FechaHoraInicio__c);
					component.set("v.sFullStartLocation", value.DireccionInicio__c);
					component.set("v.datiFechaHoraFin", value.FechaHoraFin__c);
					component.set("v.sFullEndLocation", value.DireccionFin__c);
					component.set("v.oEndCoordinates", { lat: Number(value.UbicacionFin__Latitude__s), lng: Number(value.UbicacionFin__Longitude__s) });
					component.set("v.sValoracionCita", value.ValoracionCita__c);
					component.set("v.sCamposRequeridos", requiredFields);
				} else {
					//console.log("Las fechas son diferentes");
					component.set("v.bItsToday", false);
					//component.set("v.sInvalidDateMessage", "Lo sentimos, el día del evento ha caducado");
				}
			} else {
				//console.log("getEventInformationFAC, state", state);
			}
		});
		$A.enqueueAction(action);
	},
	
	getTodayDateFAC : function(component) {
		var action = component.get("c.getTodayDate");
		action.setCallback(this, function(response) {
			var state = response.getState();
			var value = response.getReturnValue();
			if (state == "SUCCESS") {
				//console.log("getTodayDateFAC, value:", value);
				component.set("v.daTodayDate", value);
				this.getEventInformationFAC(component);
			} else {
				//console.log("getTodayDateFAC, state:", state);
			}
		});
		$A.enqueueAction(action);
	},
	
	getComentariosValoracionOptionsFAC : function(component) {
		var action = component.get("c.getComentariosValoracionOptions");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				var cvArray = [];
				//console.log("getComentariosValoracionOptionsFAC, value:", value);
				for (var index in value) {
					cvArray.push(value[index]);
				}
				console.log("getComentariosValoracionOptionsFAC, cvArray:", cvArray);
				component.set("v.oCVOptions", cvArray);
			} else {
				//console.log("getComentariosValoracionOptionsFAC, state:", state);
			}
		});
		$A.enqueueAction(action);
	},
	
	getUIThemeFAC : function(component, userId) {
		var action = component.get("c.getUITheme");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var value = response.getReturnValue();
				component.set("v.sUIThemeDisplayed", value);
				this.getUserInfoFAC(component, userId);
			} else {
				console.log("getUIThemeFAC, state:", state);
			}
		});
		$A.enqueueAction(action);
	},
	
	getUserInfoFAC : function(component, userId) {
		var action = component.get("c.getUserInfo");
		action.setParams({
			userId: userId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var returnedValue = response.getReturnValue();
				//console.log("getUserInfoFAC, returnedValue:", returnedValue);
				component.set("v.userInfo", returnedValue);
				this.getTodayDateFAC(component);
			} else {
				console.log("getUserInfoFAC, state:", state);
			}
		});
		$A.enqueueAction(action);
	},

	checkButtonActivationHelper : function(component) {
        var defaultOption;
        if ($A.util.isArray(component.find("defaultSelectOption"))) {
            defaultOption = component.find("defaultSelectOption")[0];
        } else {
            defaultOption = component.find("defaultSelectOption");
        }
        var cvOptions = component.find("aiCVOptions");
        var cvOptionsValue = "";
        if (cvOptions && cvOptions.get) {
            cvOptionsValue = cvOptions.get("v.value");
            if (defaultOption && defaultOption.get) {
                if (defaultOption.get("v.value") && !(cvOptionsValue.includes("Ninguno"))) {
                    cvOptionsValue += ";Ninguno";
                }
            }
        }
        var comment = component.find("aiComentario");
        var commentValue = "";
        if (comment && comment.get) {
            commentValue = comment.get("v.value");
        } 
        //console.log('El valor seleccionado es: ' + cvOptionsValue);
        //console.log('El comentario es: ' + commentValue);
        if (commentValue != '' && commentValue != undefined && cvOptionsValue != '' && cvOptionsValue != undefined) {
            component.set("v.bShowCheckOut",false);    
        } else {
            component.set("v.bShowCheckOut",true);    
        }
    }
})