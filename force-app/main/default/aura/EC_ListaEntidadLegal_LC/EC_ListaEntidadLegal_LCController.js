({
	init: function( component, event, helper ) {
        console.log("INICIO7");
		// EC_ListaEntidadLegal_LC
				
		var spinner = component.find("spinner");
		ctcLightning.spinner.show( component, "spinner" )
		
        helper.obtenerDirecciones(component,'');
        
		var recordId = component.get("v.recordId");
		var act = component.get("c.describeSObjects");
		act.setParams({objs: ["Account", "Opportunity", "Contact", "EntidadLegal__c", "EntidadCuenta__c", "ContactoEntidad__c", "Direccion__c"]});
		                
		var app_ctc = component.get("v.app_ctc")

		ctcLightning.aura( act, component )
		.then( $A.getCallback( function( res ) {

			console.log("ctcLightning into component: ", ctcLightning)
			ctcLightning.config.action.query = "c.executeQuery";
			ctcLightning.config.action.component = component;

			ctcLightning.schema( res, component );

			app_ctc["schema"] 		= res || [];
			app_ctc["instance"] 	= {};
			app_ctc["recordId"] 	= recordId;
			ctcLightning.spinner.hide( component, "spinner" )
			var required = true
			app_ctc.schema.EntidadLegal__c.RecordTypeId.required = required
			
            app_ctc.schema.EntidadLegal__c.Name.required = required
			app_ctc.schema.EntidadLegal__c.RazonSocial__c.required = required
			app_ctc.schema.EntidadLegal__c.Calle__c.required = required
			app_ctc.schema.EntidadLegal__c.NumeroExterior__c.required = required
			app_ctc.schema.EntidadLegal__c.NumeroInterior__c.required = false
			app_ctc.schema.EntidadLegal__c.Colonia__c.required = required
			app_ctc.schema.EntidadLegal__c.DelegacionMunicipioFiscal__c.required = required
			app_ctc.schema.EntidadLegal__c.CodigoPostal__c.required = false
			app_ctc.schema.EntidadLegal__c.Ciudad__c.required = required
			app_ctc.schema.EntidadLegal__c.Estado__c.required = required
            app_ctc.schema.EntidadLegal__c.TipoSociedad_PL__c.required = required //DVM Para el catalog e tipos de sociedades

			console.log("schema: ", res)

			var getEntidadByAccount = component.get("c.getEntidadByAccount");
			getEntidadByAccount.setParams({accountId: recordId});
			return ctcLightning.aura( getEntidadByAccount, component);
		}))
		.then( $A.getCallback( function( res ) {
			console.log("resultD: ", res)
			if( res && res.records ) {
				var entidadesLegales = []
				for ( var entidad of res.records ) {

					var entidadLegal = { Id : entidad.EntidadLegal__c }
                    
                    //DYAMPI
                    entidadLegal.Address__c=entidad.EntidadLegal__r.Address__c || ''
                    
					entidadLegal.EntidadCuenta__c = entidad.Id
					if( entidad.EntidadLegal__r ) {
						entidadLegal.RazonSocial__c = entidad.EntidadLegal__r.RazonSocial__c || ''
						entidadLegal.Name = entidad.EntidadLegal__r.Name || ''
						entidadLegal.Estatus__c = entidad.EntidadLegal__r.Estatus__c || ''
						if( entidad.EntidadLegal__r.RecordType ) {
							entidadLegal.Type = entidad.EntidadLegal__r.RecordType.Name || ''
						}
					}
					entidadesLegales.push( entidadLegal );
				}
				app_ctc["entidadesLegales"] = entidadesLegales;
				component.set("v.app_ctc", app_ctc);

				console.log("entidadesLegales: ", entidadesLegales);
			}
		})).catch( $A.getCallback( function( err ) {
		       console.log("error: ", err );
		}))
	},

    refrescarDirecciones: function(component, event, helper) {
        helper.obtenerDirecciones(component,'refresh');
    },
    
    crearDirecc: function(component, event, helper) {
        var actionAPI = component.find("quickActionAPI");
        var args = { actionName :"Account.NuevaDireccion" };
        actionAPI.selectAction(args).then(function(result) {
            console.log("nose");
        }).catch(function(e) {
            if (e.errors) {
                console.log("error"+JSON.stringify(e));
            }
        })
    },
    
	viewRecord: function( component, event, helper ) {
		var id = event.getSource().get("v.value");
	    var urlEvent = $A.get("e.force:navigateToURL");
	    urlEvent.setParams({
	      "url": "/" + id
	    });
	    urlEvent.fire();
	},
    
    tipoSociedad: function(component, event, helper){
        component.set("v.idPersonaFisica", event.getSource().get("v.value"));
        component.find("mySelect").set("v.value", "");
    }, 

	editRecord: function( component, event, helper ) {
        
        //DVM: Inicio para Picklist TIPO de SOCIEDAD
        var picklistValues  = component.get("c.getTipoDeSociedad");
        var opts=[];
        
        picklistValues.setCallback(this, function(a) {
            opts.push({"class": "optionClass", label: "-- Selecionar --", value: ""});
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set("v.options", opts);
        });
        
        $A.enqueueAction(picklistValues); 
        //DVM Fin para Picklist TIPO de SOCIEDAD

                
		ctcLightning.spinner.show( component, "spinner" )
		component.set("v.app_ctc.instance", {});
		var id = event.getSource().get("v.value");
		var action = id == "0" ? "Agregar entidad legal" : "Editar entidad legal"

        var recordTypes = {}
		var recordTypesList = []

		var getRecordsType = component.get("c.getRecordsType");
		getRecordsType.setParams({sObjectName: "EntidadLegal__c"});
		ctcLightning.aura( getRecordsType, component)
		.then( $A.getCallback( function( res ) {
			// console.log("RecordType: ", res)
			if( res && res.records ) {
				recordTypes = res.records || {}
			}

			if( id != "0" ) {
				var getEntidadCuenta = component.get("c.getEntidadCuenta");
				getEntidadCuenta.setParams({idEntidadCuenta: id});
				return ctcLightning.aura( getEntidadCuenta, component)
			}
		}))
		.then( $A.getCallback( function( res ) {
			console.log("getEntidadCuenta final: ", res)
			var instance = {action: action}
			instance.EntidadLegal = {}
			instance.disabled = false
            
			if( res && res.records ) {
				var rec = res.records[0] || {}
				instance.Id = id
				instance.Cuenta__c = rec.Cuenta__c
				instance.EntidadLegal__c = rec.EntidadLegal__c || ''
				instance.disabled = rec.hasOwnProperty("Administraci_n_de_Ventas__r") && rec.Administraci_n_de_Ventas__r.length > 0


				if( rec.EntidadLegal__r ) {
					instance.EntidadLegal = rec.EntidadLegal__r
					instance.CodigoPostal__c = instance.EntidadLegal.CodigoPostal__c
                    instance.TipoSociedad_PL__c = instance.EntidadLegal.TipoSociedad_PL__c //DV Add
                    //DV Inicio 
                    if(instance.EntidadLegal.TipoSociedad_PL__c != '' || instance.EntidadLegal.TipoSociedad_PL__c != null){ 
                        component.set("v.selectedValue", instance.EntidadLegal.TipoSociedad_PL__c);
                        console.log("ME SIENTO VIVO  ", instance.EntidadLegal.TipoSociedad_PL__c); 
                    } //DV Final
					instance.Contacto__r = { Name: rec.EntidadLegal__r.CodigoPostal__c + '-' + rec.EntidadLegal__r.Colonia__c}
					console.log("cp: ", instance.CodigoPostal__c)

					if( instance.EntidadLegal.RecordTypeId ) {
						instance.EntidadLegal.Type = recordTypes[instance.EntidadLegal.RecordTypeId].Name || ''
						instance.EntidadLegal.RazonSocial__c = instance.EntidadLegal.Type == 'Persona Física' ? instance.EntidadLegal.RazonSocial__c : instance.EntidadLegal.RazonSocial__c
					}
				}
			} else {
				component.set("v.app_ctc.instance.errors", ["Complete la información solicitada"])
			}

			Object.keys(recordTypes).forEach( function( key, index ) {
                var rt = recordTypes[key]
				rt.selected = instance.EntidadLegal && key == instance.EntidadLegal.RecordTypeId
				recordTypesList.push( rt )
			})

			instance.recordTypesList = recordTypesList || []
			instance.recordTypes = recordTypes || {}
			instance.render = true

			if( !instance.EntidadLegal.RecordTypeId ) {
				instance.EntidadLegal.RecordTypeId = instance.recordTypesList[0].Id
			}

			console.log("edit instance: ", instance)
			
            
			component.set( "v.app_ctc.instance", instance );
			ctcLightning.spinner.hide( component, "spinner" )
			ctcLightning.modal.open( component, "editDialog", "overlay" )
            
            if(recordTypes[instance.EntidadLegal.RecordTypeId].Name === 'Persona Física'){ component.find("mySelect").set("v.value", ""); }
            component.set("v.idPersonaFisica", instance.EntidadLegal.RecordTypeId);
            
		})).catch( $A.getCallback( function( err ) {
			var errors = err.getError()
			console.log("error editRecord: ", err, errors)
		}))
	},

	closeRecord: function( component, event, helper ) {
		ctcLightning.modal.close( component, "editDialog", "overlay" )
	},

	saveRecord: function( component, event, helper ) {
        
        var allValid = component.find('inputField').reduce(function ( validSoFar, inputCmp ) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
         }, true);
         if (allValid) {
			component.set("v.app_ctc.instance.errors", [])
			ctcLightning.spinner.show( component, "spinner" )
			console.log("saveRecord: ", JSON.parse(JSON.stringify(component.get("v.app_ctc.instance"))))
			var instance_ = component.get("v.app_ctc.instance")

			component.set("v.app_ctc.instance", instance_)
			var el = {Cuenta__c: component.get("v.recordId")}
			var ec = {}

			for( var key of Object.keys(instance_.EntidadLegal) ) {
                //DV Inicio
                console.log(key);

                if(key === "RazonSocial__c" && component.find("mySelect").get("v.value") != ''){
                    var nombreRazonSocial = instance_.EntidadLegal[key];
                    if(nombreRazonSocial.indexOf(",") != -1){
                        var nombreSinTipoSociedad = nombreRazonSocial.split(",");
                        el[key] = nombreSinTipoSociedad[0] + ", " + component.find("mySelect").get("v.value");
                    }else{
                        el[key] = instance_.EntidadLegal[key] + ", " + component.find("mySelect").get("v.value");
                    }
                }else{
                    el[key] = instance_.EntidadLegal[key] //Linea original
                    console.log(el[key]);
                }
                //DV Fin
			}
			// if( instance_.recordTypes && instance_.recordTypes[el.RecordTypeId] && instance_.recordTypes[el.RecordTypeId].Name == 'Persona Física' ) {
			// 	el.Nombre__c = el.RazonSocial__c || ''
			// 	el.RazonSocial__c = ''
			// } else {
			// 	el.Nombre__c = ''
			// }
			// el.RFC__c = ''
			if( instance_.EntidadLegal__c ) {
				el.Id = instance_.EntidadLegal__c
			}
			if( !instance_.CodigoPostal__c__o ) {
				component.set("v.app_ctc.instance.Contacto__r.Name", null)
			} else {
				component.set("v.app_ctc.instance.Contacto__r.Name", instance_.CodigoPostal__c__o.CodigoPostal__c + '-' + instance_.CodigoPostal__c__o.Colonia__c)
			}

			if(!component.get("v.app_ctc.instance.EntidadLegal.Direccion_Cuenta__c")){
				el.CodigoPostal__c = instance_.CodigoPostal__c
			}
            
            el.TipoSociedad_PL__c =  component.find("mySelect").get("v.value") //DV Add
			console.log("\n\nEntidadLegal 1: ", el)

            
			var guardaEntidadLegal = component.get("c.guardaEntidadLegal");
			guardaEntidadLegal.setParams({ entidadLegal: el });
			ctcLightning.aura( guardaEntidadLegal, component)
			.then( $A.getCallback( function( res ) {
				console.log("\nguardaEntidadLegal: ", res)
				
				ctcLightning.spinner.hide( component, "spinner" )	

				if( res ) {
					if( res.error ) {
						var errors = []
						var schemaEntidad = JSON.parse(JSON.stringify(component.get("v.app_ctc.schema.EntidadLegal__c")))
						for( var field of res.error ) {
							var errormsg = schemaEntidad[field] ? (schemaEntidad[field].label + ' es requerido') : field
							errors.push( errormsg )
						}

						component.set("v.app_ctc.instance.errors", errors)

					} else {
						ctcLightning.modal.close( component, "editDialog", "overlay" )
						$A.get( "e.c:EC_ActualizaEntidadLegal_LE" ).fire();
					}
				}

			})).catch( $A.getCallback( function( err ) {
				console.log("error guardaEntidadLegal: ", err)
				ctcLightning.spinner.hide( component, "spinner" )
				var errors = err.getError()
				console.log("error guardaEntidadLegal: ", err, "\nerrors: ", errors[0])
				var msgs = []
				if( errors && errors[0] && errors[0].fieldErrors ) {
					for( var field in errors[0].fieldErrors ) {
						console.log("field: ", field, errors[0].fieldErrors[field])
						for( var error of errors[0].fieldErrors[field] ) {
							if( error.message ) {
								msgs.push( error.message ) 
							}
						}
					}
				}

				if( errors && errors[0] && errors[0].pageErrors ) {
					for( var error of errors[0].pageErrors ) {
						// console.log("field: ", field, errors[0].fieldErrors[field])
						// for( var error of errors[0].fieldErrors[field] ) {
							if( error.message ) {
								msgs.push( error.message ) 
							}
						// }
					}
				}

				component.set("v.app_ctc.instance.errors", msgs)
				console.log("msgs: ", msgs)
			}))

        } else {
        }
        
	},

	validateRFC: function( component, event, helper ) {
		console.log("validateRFC: ", component.get("v.app_ctc.instance.EntidadLegal.Name"))
		console.log("instance Id: ", component.get("v.app_ctc.instance.Id"))
		console.log("EntidadLegal__c Id: ", component.get("v.app_ctc.instance.EntidadLegal__c"))

		var idEntidadLegal = component.get("v.app_ctc.instance.EntidadLegal__c")

		component.set("v.app_ctc.instance.rfcDisponible", false)
		component.set("v.app_ctc.instance.rfcNodisponible", false)
		component.set("v.app_ctc.instance.rfcNodisponibleMsg", "")
		component.set("v.app_ctc.instanceAux", null)
		var recordId = component.get("v.recordId");
		var getEntidadByRFC = component.get("c.getEntidadByRFC");
		var rfc = component.get("v.app_ctc.instance.EntidadLegal.Name")
		getEntidadByRFC.setParams({ rfc: rfc});
		ctcLightning.aura( getEntidadByRFC, component)
		.then( $A.getCallback( function( res ) {
			if( res && res.records && res.records.length > 0 ) {

				var instanceRfc = res.records[0] || {}
				if( idEntidadLegal != instanceRfc.Id ) {
					if( instanceRfc.Entidades_Cuenta__r ) {
						component.set("v.app_ctc.instance.rfcNodisponible", true)
						var msg = rfc +' ya está en uso por la cuenta: '
						msg += instanceRfc.Cuenta__r && instanceRfc.Cuenta__r.Name ? instanceRfc.Cuenta__r.Name : ''
						msg += ', propietario: '
						msg += instanceRfc.Cuenta__r && instanceRfc.Cuenta__r.Owner && instanceRfc.Cuenta__r.Owner.Name ? instanceRfc.Cuenta__r.Owner.Name : ''
						// msg += instanceRfc.Cuenta__r && instanceRfc.Cuenta__r.Owner && instanceRfc.Cuenta__r.Owner.Email ? instanceRfc.Cuenta__r.Owner.Email : ''

						component.set("v.app_ctc.instance.rfcNodisponibleMsg",  msg )
					} else {
						component.set("v.app_ctc.instance.rfcDisponible", true)
						component.set("v.app_ctc.instanceAux", instanceRfc)
					}
				}

				// var allValid = component.find('inputField').reduce(function ( validSoFar, inputCmp ) {
		            //inputCmp.showHelpMessageIfInvalid();
		            // var name = inputCmp.get("v.name")
		            // if( name && name == 'Name' ) {
		            	// console.log("input: ", inputCmp.get("v.name"), validSoFar, inputCmp)
		            	// inputCmp.set("v.errors", [{message:"RFC ya existe"}]);
		            	// inputCmp.set("v.validity", {valid:false, badInput :true});
		            	// inputCmp.showHelpMessageIfInvalid();
		            	
		        //     }
		        //     return validSoFar && inputCmp.get('v.validity').valid;
		        // }, true);
			}
			console.log("respuesta rfc: ", res)
		})).catch( $A.getCallback( function( err ) {
			// var errors = err.getError()
			console.log("error editRecord: ", err)
		}))

	},

	useRFC: function( component, event, helper ) {
		var instanceAux = JSON.parse(JSON.stringify(component.get("v.app_ctc.instanceAux")))
		// {Cuenta__c: component.get("v.recordId")}

		component.set("v.app_ctc.instance.rfcDisponible", false)

		component.set("v.app_ctc.instance.EntidadLegal.RecordTypeId", instanceAux.RecordTypeId)
		component.set("v.app_ctc.instance.EntidadLegal.RazonSocial__c", instanceAux.RazonSocial__c)
		component.set("v.app_ctc.instance.EntidadLegal.Cuenta__c", component.get("v.recordId"))
		component.set("v.app_ctc.instance.EntidadLegal.Id", instanceAux.Id)
		component.set("v.app_ctc.instance.EntidadLegal.Calle__c", instanceAux.Calle__c)
		component.set("v.app_ctc.instance.EntidadLegal.NumeroExterior__c", instanceAux.NumeroExterior__c)
		component.set("v.app_ctc.instance.EntidadLegal.Colonia__c", instanceAux.Colonia__c)
		component.set("v.app_ctc.instance.EntidadLegal.DelegacionMunicipioFiscal__c", instanceAux.DelegacionMunicipioFiscal__c)
		component.set("v.app_ctc.instance.EntidadLegal.CodigoPostal__c", instanceAux.CodigoPostal__c)
		component.set("v.app_ctc.instance.EntidadLegal.Ciudad__c", instanceAux.Ciudad__c)
		component.set("v.app_ctc.instance.EntidadLegal.Estado__c", instanceAux.Estado__c)


		console.log("instanceAux to use: ", instanceAux)
	},

	editContacts: function( component, event, helper ) {
		// ctcLightning.spinner.hide( component, "spinner" )
		var id = event.getSource().get("v.value");
		var instance = {action: "Asociar Representante Legal"}
		instance.Id = id
		instance.renderContacts = true
		component.set( "v.app_ctc.instance", instance );

		ctcLightning.modal.open( component, "editContactos", "overlay" )
	},

	closeContacts: function( component, event, helper ) {
		ctcLightning.modal.close( component, "editContactos", "overlay" )
		component.set( "v.app_ctc.instance", {} );
		$A.get("e.c:EC_ActualizaEntidadLegal_LE" ).fire();
	},

	editDocuments: function( component, event, helper ) {
		// ctcLightning.spinner.hide( component, "spinner" )
		var id = event.getSource().get("v.value");
		var instance = {action: "Cargar documentos"}
		instance.Id = id
		instance.renderDocuments = true
		component.set( "v.app_ctc.instance", instance );
		ctcLightning.modal.open( component, "editDocumentos", "overlay" )
	},

	closeDocuments: function( component, event, helper ) {
		ctcLightning.modal.close( component, "editDocumentos", "overlay" )
		component.set( "v.app_ctc.instance", {} );
		$A.get("e.c:EC_ActualizaEntidadLegal_LE" ).fire();
	},

	showRemove: function( component, event, helper ) {
		// ctcLightning.spinner.hide( component, "spinner" )
		var id = event.getSource().get("v.value");
		var instance = {action: "Eliminar entidad legal de cuenta"}
		instance.Id = id

		var getEntidadCuenta = component.get("c.getEntidadCuenta");
		getEntidadCuenta.setParams({idEntidadCuenta: id});
		ctcLightning.aura( getEntidadCuenta, component)
		.then( $A.getCallback( function( res ) {

			var ec = res && res.records && res.records.length > 0 ? res.records[0] : {}
			console.log("success getEntidadCuenta: ", ec)
			instance.action = 'Eliminar ' + ( ec.EntidadLegal__r && ec.EntidadLegal__r.RazonSocial__c ? ec.EntidadLegal__r.RazonSocial__c : '' ) + ' de cuenta'
			component.set( "v.app_ctc.instance", instance );
			ctcLightning.modal.open( component, "removeDialog", "overlay" )

		})).catch( $A.getCallback( function( err ) {
			var errors = err.getError()
			console.log("error showRemove: ", err, errors)
		}))
	},

	closeRemove: function( component, event, helper ) {
		ctcLightning.modal.close( component, "removeDialog", "overlay" )
		component.set( "v.app_ctc.instance", {} );
	},

	confirmRemove: function( component, event, helper ) {
		ctcLightning.spinner.show( component, "spinner" )
		component.set("v.app_ctc.instance.errors", [])
		
		var eliminaEntidadCuenta = component.get("c.eliminaEntidadCuenta");
		eliminaEntidadCuenta.setParams({idEntidadCuenta: component.get( "v.app_ctc.instance.Id")});
		ctcLightning.aura( eliminaEntidadCuenta, component)
		.then( $A.getCallback( function( res ) {
			
			console.log("success eliminaEntidadCuenta: ", res)

			if( res && !res.error ) {
				component.set( "v.app_ctc.instance", {} );
				ctcLightning.modal.close( component, "removeDialog", "overlay" )
				$A.get("e.c:EC_ActualizaEntidadLegal_LE" ).fire();
			}
			ctcLightning.spinner.hide( component, "spinner" )

		})).catch( $A.getCallback( function( err ) {
			var errors = err.getError()
			var msgs = []
			console.log("error confirmRemove: ", err, errors)
			if( errors && errors[0] && errors[0].pageErrors ) {
				for( var error of errors[0].pageErrors ) {
					msgs.push( error.message ) 
				}
			}
			component.set("v.app_ctc.instance.errors", msgs)
			console.log("msgs: ", msgs)
			// component.set( "v.app_ctc.instance", {} );
			// ctcLightning.modal.close( component, "removeDialog", "overlay" )
			ctcLightning.spinner.hide( component, "spinner" )
		}))
	},
    
	selectCodigoPostal: function( component, event, helper ) {
		console.log("selectCodigoPostal: ", JSON.parse(JSON.stringify(component.get("v.app_ctc.instance.CodigoPostal__c__o"))))
		var direccion = component.get("v.app_ctc.instance.CodigoPostal__c__o")
		if( direccion ) {
			var el = component.get("v.app_ctc.instance.EntidadLegal")
			el.Colonia__c = direccion.Colonia__c
			el.DelegacionMunicipioFiscal__c = direccion.DelegacionMunicipio__c
			el.Ciudad__c = direccion.Ciudad__c
			el.Estado__c = direccion.Estado__c
			el.CodigoPostal__c = direccion.CodigoPostal__c
			component.set("v.app_ctc.instance.EntidadLegal", el)
		}
	},

	getDireccion: function( component, event, helper ) {
		var cmpTarget = component.find('buscador');
		var cmpFake = component.find('fake');
		if(component.get("v.app_ctc.instance.EntidadLegal.Direccion_Cuenta__c")){

			var actual = component.get("v.app_ctc.instance.EntidadLegal");
			var recordId = component.get("v.recordId");
			var action = component.get("c.getAddressAccount");
			var direccion = component.get("v.params");
			
        	
        	action.setParams({ accountId : recordId });
        	action.setCallback(this, function(response) {
            var state = response.getState();
	            if (state === "SUCCESS") {
	            	var el = response.getReturnValue()
	            	console.log('po ' + el.CodigoPostal__c);
	            	console.log('po 2 ' + direccion);
	            	direccion= el.CodigoPostal__c;
	            	console.log('qq 2 ' + direccion);
	            	actual.Direccion_Cuenta__c = true;
	            	actual.Colonia__c = el.Colonia__c;
					actual.DelegacionMunicipioFiscal__c = el.DelegacionMunicipioFiscal__c;
					actual.Ciudad__c = el.Ciudad__c;
					actual.Estado__c = el.Estado__c;
					actual.CodigoPostal__c = el.CodigoPostal__c;
					actual.Calle__c=el.Calle__c;
					actual.NumeroExterior__c=el.NumeroExterior__c;
					actual.NumeroInterior__c=el.NumeroInterior__c;
					component.set("v.app_ctc.instance.EntidadLegal", actual)   
					$A.util.addClass(cmpTarget, 'slds-hide'); 
					$A.util.removeClass(cmpFake, 'slds-hide'); 
        			$A.util.addClass(cmpFake, 'slds-p-horizontal_medium slds-p-top_medium');

	            }
        	});
        	 $A.enqueueAction(action);
		}
		else{
				$A.util.removeClass(cmpTarget, 'slds-hide'); 
        		$A.util.addClass(cmpTarget, 'slds-p-horizontal_medium slds-p-top_medium');
        		$A.util.removeClass(cmpFake, 'slds-p-horizontal_medium slds-p-top_medium'); 
        		$A.util.addClass(cmpFake, 'slds-hide');
	    }		
	}

})