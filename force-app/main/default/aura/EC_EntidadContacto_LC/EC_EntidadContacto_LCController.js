({
	init : function( component, event, helper ) {

		// EC_EntidadContacto__c

		ctcLightning.config.action.query = 'c.executeQuery'
		ctcLightning.config.action.component = component

		var app_ctc = component.get("v.app_ctc")

		var spinner = component.find("spinner");
		$A.util.removeClass(spinner, "slds-hide");

		var describeSObjects = component.get("c.describeSObjects");
		describeSObjects.setParams({objs: ["Account", "EntidadLegal__c", "Contact", "EntidadCuenta__c", "ContactoEntidad__c"]});
		ctcLightning.aura( describeSObjects, component )
		.then( $A.getCallback( function( res ) {
			ctcLightning.schema( res, component );
			app_ctc["hasError"] 	= true;
			app_ctc["schema"] 		= res || [];
			app_ctc["modal"] 		= {title: 'Agregar'};
			component.set("v.app_ctc", app_ctc);

			console.log("app_ctc: ", app_ctc.schema);
			console.log("ctcLightning: ", ctcLightning);
			console.log("recordId: ", component.get("v.recordId"));

			var getEntidadCuenta = component.get("c.getEntidadCuenta");
			getEntidadCuenta.setParams({idEntidadCuenta: component.get("v.recordId")});
			return ctcLightning.aura( getEntidadCuenta, component )
		}))
		.then( $A.getCallback( function( res ) {

			component.set("v.app_ctc.entidadCuenta", res && res.records && res.records.length > 0 ? res.records[0] : {});
			console.log("v.app_ctc.entidadCuenta.Cuenta__c: ", component.get("v.app_ctc.entidadCuenta").Cuenta__c)

			var getContactoByEntidad = component.get("c.getContactoByEntidad");
			getContactoByEntidad.setParams({idEntidadCuenta: component.get("v.recordId")});
			return ctcLightning.aura( getContactoByEntidad, component )
			
		}))
		.then( $A.getCallback( function( res ) {
			console.log("contactos asociados: ", res)
			component.set("v.app_ctc.contactos", res && res.records ? res.records : []);
			$A.util.addClass(spinner, "slds-hide");
		})).catch( $A.getCallback( function( err ) {
		       console.log("error: ", err );
		}))
	},

	editRecord : function( component, event, helper ) {
		component.set("v.app_ctc.hasError", false);
		// console.log("editRecord", event.getSource().get('v.name'))
		var spinner = component.find("spinner");
		var recordId = event.getSource().get('v.name')
		component.set("v.renderInput", false);

		component.set("v.params", '{"idAccount": "' + component.get("v.app_ctc.entidadCuenta").Cuenta__c + '"}');

		$A.util.removeClass(spinner, "slds-hide");

		if( recordId == 'add' ) {
			console.log("is add")

			var instance = {Cuenta: component.get("v.app_ctc.entidadCuenta.Cuenta__r.Name"), Cuenta__c: component.get("v.app_ctc.entidadCuenta.Cuenta__c"), Entidad_Cuenta__c: component.get("v.app_ctc.entidadCuenta.Id")}
			console.log("editar instance: ", instance)
			component.set("v.instance", instance);
			component.set("v.renderInput", true);
			// var formContacto = component.find("formContacto");
			// $A.util.removeClass(formContacto, "slds-has-error");
			component.set("v.app_ctc.messageContacto", "Seleccione un contacto");

			$A.util.addClass(spinner, "slds-hide");
			component.set("v.app_ctc.hasError", true);
			helper.showHideModal(component);
			setTimeout( function() {
				// $A.util.addClass(formContacto, "slds-has-error");
				component.set("v.app_ctc.hasError", false);
				component.set("v.app_ctc.hasError", true);
			}, 2000)

		} else {
			var getContactoEntidad = component.get("c.getContactoEntidad");
			getContactoEntidad.setParams({idContactoEntidad: recordId});
			ctcLightning.aura( getContactoEntidad, component )
			.then( $A.getCallback( function( res ) {

				var instance = res && res.records && res.records.length > 0 ? res.records[0] : {}
				instance.Cuenta = instance.Entidad_Cuenta__r.Cuenta__r.Name
				console.log("editar instance: ", instance)
				component.set("v.instance", instance);
				component.set("v.renderInput", true);

				$A.util.addClass(spinner, "slds-hide");
				helper.showHideModal(component);
				component.set("v.app_ctc.hasError", false);
			})).catch( $A.getCallback( function( err ) {
			       console.log("error: ", err );
			}))
		}

	},

	removeRecord : function( component, event, helper ) {
		var recordId = event.getSource().get('v.name')
		console.log("removeRecord: ". recordId)
		var getContactoEntidad = component.get("c.getContactoEntidad");
		getContactoEntidad.setParams({idContactoEntidad: recordId});
		ctcLightning.aura( getContactoEntidad, component )
		.then( $A.getCallback( function( res ) {

			var instance = res && res.records && res.records.length > 0 ? res.records[0] : {}
			// instance.Cuenta = instance.Entidad_Cuenta__r.Cuenta__r.Name
			console.log("eliminar instance: ", instance)
			component.set("v.app_ctc.removeMsg", "Eliminar relación con contacto " + instance.Contacto__r.Name);
			component.set("v.app_ctc.removeId", recordId);
			helper.showHideModalRemove(component);
		})).catch( $A.getCallback( function( err ) {
		       console.log("error: ", err );
		}))


	},

	toggleDialog : function( component, event, helper ) {
        helper.showHideModal(component);
    },

    toggleDialogRemove : function( component, event, helper ) {
        helper.showHideModalRemove(component);
    },

	saveRecord : function( component, event, helper ) {
		component.set("v.app_ctc.messageError", "");
		var instance = component.get("v.instance")
		console.log("instance to save: ", instance.Id, instance.Contacto__c, instance.Entidad_Cuenta__c)

		var saveContactoEntidad = component.get("c.saveContactoEntidad");
		saveContactoEntidad.setParams({contactoEntidad: {Id: instance.Id, Contacto__c: instance.Contacto__c, Entidad_Cuenta__c: instance.Entidad_Cuenta__c}});
		ctcLightning.aura( saveContactoEntidad, component )
		.then( $A.getCallback( function( res ) {
			if( res.error ) {
				console.log("error then: ", res.error)
				var err = res.error
				var msg = ''
				if( err.indexOf('_EXCEPTION') != - 1) {
					msg = err.substring(err.indexOf('_EXCEPTION') + 11, err.length)
					msg = msg.replace(": [Contacto__c]", "")
				}
				component.set("v.app_ctc.messageContacto", msg);
				component.set("v.app_ctc.hasError", true);
				console.log("message: ", msg)
			} else {
				console.log("response: ", res)
				helper.showHideModal(component);
				var event = $A.get("e.c:EC_ActualizaEntidadContacto_LE" );
				event.fire();
			}
			
		})).catch( $A.getCallback( function( err ) {
		       console.log("error catch: ", err.getError() );
		}))

	},

	confirmRemoveRecord : function( component, event, helper ) {

		var spinner = component.find("spinner");
		$A.util.removeClass(spinner, "slds-hide");

		var idContactoEntidad = component.get("v.app_ctc.removeId")

		var removeContactoEntidad = component.get("c.removeContactoEntidad");
		removeContactoEntidad.setParams({idContactoEntidad: idContactoEntidad});
		ctcLightning.aura( removeContactoEntidad, component )
		.then( $A.getCallback( function( res ) {
			$A.util.addClass(spinner, "slds-hide");
			if( res.error ) {
				console.log("error then: ", res.error)
			} else {
				console.log("remove success: ", res)
				helper.showHideModalRemove(component);
				var event = $A.get("e.c:EC_ActualizaEntidadContacto_LE" );
				event.fire();
			}
		})).catch( $A.getCallback( function( err ) {
			$A.util.addClass(spinner, "slds-hide");
			console.log("error catch: ", res.error)
		}))

		
	},

	renderError: function( component, event, helper ) {
		console.log("render error: ", component.get("v.app_ctc.hasError"), $('#formElementContacto'))
		// var formContacto = component.find("formContacto");
		if( component.get("v.app_ctc.hasError") ) {
			// $A.util.addClass(formContacto, "slds-has-error");
			$('#formElementContacto').addClass('slds-has-error')
		} else {
			$('#formElementContacto').removeClass('slds-has-error')
			// $A.util.removeClass(formContacto, "slds-has-error");
		}

	},

	navToRecord : function ( component, event, helper ) {
		console.log('navToRecord: ', event)
		var recordId = event.getSource().get('v.name')
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
        });
        navEvt.fire();
    }
})