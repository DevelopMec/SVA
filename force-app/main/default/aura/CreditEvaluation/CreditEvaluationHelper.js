({
    Guardar: function(component,event,vAprobar){
        component.find('txtLineaOperativa').showHelpMessageIfInvalid();
        component.find('txtdiasCredito').showHelpMessageIfInvalid();
        component.find('txtPorcComision').showHelpMessageIfInvalid();
        
        var vPeriodoLiberacion = component.find("selectPeriodoLiberacion").get("v.value");
       	var vLineaOperativa = component.find("txtLineaOperativa").get("v.value");
        var vdiasCredito = component.find("txtdiasCredito").get("v.value");
        var vPorcComision = component.find("txtPorcComision").get("v.value");
        var vGarantiaNegocio = component.find("selectGarantia").get("v.value");
        
        var vdocpendientes = false;
        var vdocumentos = component.get("v.documents");
        for (var i = 0; i < vdocumentos.length; i++) {
            if (!vdocumentos[i].loaded) {
                vdocpendientes = true;
                break;
            }
        }
        
        
        if (vLineaOperativa != "" && vdiasCredito != "" && vPorcComision != "" && !vdocpendientes){
            console.log ('Entro a guardar');
             var action=component.get("c.GuardarDatos");
        action.setParams({idOportunidad:component.get("v.IdOportunidad"),
                          periodoLiberacion:vPeriodoLiberacion,
                          lineaOperativa:vLineaOperativa,
                          diasCredito:vdiasCredito,
                          PorcComision:vPorcComision,
                          garantiaNegociando:vGarantiaNegocio,
                          Aprobar: vAprobar
                         });
   
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=='SUCCESS'){
                    if (vAprobar){
                    	this.showToast(component, event, "success",  "", "Enviado a aprobación");
                    }
                    else{
                        this.showToast(component, event, "success",  "", "Datos Guardados");
                    }
                    var a2 = component.get('c.doInit');
       				$A.enqueueAction(a2);
                }
                else{
                    console.log('Error en guardar ' + state.getError());
                }
            });
            
            $A.enqueueAction(action);
            
            return true;
        }
        else{
            return false;
        }
   
    },
    
    handleDocAndOppUpdate: function(component, response, newTitle) {
		let { errors, id, isSuccess } = response.getReturnValue();
		// Does updating the name was successful?
		if (isSuccess) {
			// Updating the list of documents in the client...
			let documents = component.get('v.documents');
			for (let i = 0; i < documents.length; i++) {
				if (documents[i].name == newTitle) {
					documents[i].loaded = true;
					documents[i].Id = id;
					break;
				}
			}
			console.log('documents: ', documents);
			component.set('v.documents', documents);
		} else {
			$A.get('e.force:showToast')
				.setParams({
					duration: '10000',
					type: 'error',
					title: 'Error',
					message: 'Ocurrió un problema al actualizar el nombre del archivo: ' + errors
				})
				.fire();
		}
	},
    
	createActionPromise: function(component, action) {
		return new Promise($A.getCallback((resolve, reject) => {
			let { name, params } = action;
			let a = component.get('c.' + name);
			a.setParams(params);
			a.setCallback(this, response => {
				console.log(`helper.createActionPromise(), action: ${name}, response.getState(): ${response.getState()}`);
				if (response.getState() === 'SUCCESS') {
					let returnedValue = response.getReturnValue();
					if (!('exceptionTypeName' in returnedValue)) {
						resolve(response);
					} else {
						reject(new Error(`Error en "helper.createActionPromise()": ${returnedValue.message}, Rastreo de Pila: ${returnedValue.stackTraceString}`));
					}
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(a);
		}));
	},
    
    showToast : function(component, event, tipo,titulo,msj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : tipo,
            "title": titulo,
            "message": msj
        });
        toastEvent.fire();
    },
})