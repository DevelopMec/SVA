({
    doInit : function(component, event, helper) {
        //alert("DAF");
        //alert(component.get("v.recordId"));
        //component.set("v.recordId", "0062900000735yLAAQ"); 
        var getOportunidadContrato = component.get("c.getOportunidadContrato");
        getOportunidadContrato.setParams({ recordID : component.get("v.recordId") });
        getOportunidadContrato.setCallback( this , function(oportunidadContrato){
            
            $A.enqueueAction(component.get('c.bloqueaEnADV'));
            
            if (oportunidadContrato.getState() === "SUCCESS" && oportunidadContrato.getReturnValue() !== null) {
                console.log("getOportunidadContrato: " + oportunidadContrato.getState() + ", Objeto devuelto:  " + "\n" + JSON.stringify(oportunidadContrato.getReturnValue()));
                component.set("v.contrato2",   oportunidadContrato.getReturnValue());
                var reponseOpp = oportunidadContrato.getReturnValue().PartidaPresupuesto__r.Quote.Opportunity;
                component.set("v.oportunidad", reponseOpp);
                if(reponseOpp.NumberOfShipments__c === 0){
                	console.log(oportunidadContrato.getState() + " Para poder agregar una dirección de entrega es necesario agregar un número de envios en la cotización");
                	$A.util.addClass(component.find("picklistDirecciones"),'slds-hide');
	                helper.muestraMensaje(component, event, helper, "Direcciones de Entrega", "Para poder agregar una dirección de entrega es necesario agregar un número de envios en la cotización", "Information");
                } else {
                    if(oportunidadContrato.getReturnValue().DireccionesAuxiliares__c === true){
                        $A.util.addClass(component.find("picklistDirecciones"),'slds-hide');
                        $A.util.addClass(component.find("btn-agregarDireccion"),'slds-hide');
                        $A.util.addClass(component.find("btn-quitarDireccion"),'slds-hide');
                        $A.util.addClass(component.find("tablaDirecciones"),'slds-hide');
                        $A.util.addClass(component.find("guardar"),'slds-hide');
                    }
                    else{
                        helper.getDireccionesTabla(component, event, helper);
                        helper.getDirecciones(component, event, helper);
                    }
                }
            }else
            if(oportunidadContrato.getState() === "ERROR"){
                console.log(oportunidadContrato.getState() + " No se tiene un Contrato2 asociado a la Oportunidad");
                $A.util.addClass(component.find("picklistDirecciones"),'slds-hide');
                helper.muestraMensaje(component, event, helper, "Direcciones de Entrega", "Es necesario tener un Contrato para poder elegir Direcciones de Entrega", "Information");
            }
        });
        $A.enqueueAction(getOportunidadContrato);
    },
    
    agregarDireccion : function(component, event, helper){
        helper.crearTabla(component, event, helper);
        var dirRestantes      = new Array();
        var direccionesTabla = component.get("v.dirSeleccionadas");
        var opp = component.get("v.oportunidad");
        var numberOfShipments = opp.NumberOfShipments__c;
        component.get("v.catalogoDirecciones").forEach(function(direccion){
            if(component.get("v.dirSelected") !== direccion.Id) dirRestantes.push(direccion);
            else {
                if (direccionesTabla.length+1 > numberOfShipments) {
                    dirRestantes.push(direccion)
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Direcciones de Entrega",
                        "message": "Solo puedes agregar la cantidad de direcciones igual o menor al indicado en Numero de envíos dentro de la cotización",
                        "type": "info"
                    });
                    toastEvent.fire();
                } else {                
                    direccionesTabla.push(direccion);
                }
            }
        });
        
        component.set("v.catalogoDirecciones" , dirRestantes);
        component.set("v.dirSeleccionadas" , direccionesTabla);
        
        component.find("guardar").set("v.disabled",false);
        component.find("btn-agregarDireccion").set("v.disabled",true);
        
    },
    
    agregarQuitar: function (component, event) {
        var catalogoDirecciones = component.get("v.catalogoDirecciones");
        var selected  = new Array();
        var dirTabla  = new Map();
        var iterador;
       
        component.get("v.dirSeleccionadas").forEach(function(element){
            dirTabla.set(element.Id, element);
        });
        
        component.find("tablaDirecciones").getSelectedRows().forEach(function(element){
            if(dirTabla.has(element.Id)){
                catalogoDirecciones.push(element);
                dirTabla.delete(element.Id);
            }
        });
        
        iterador = dirTabla.values();
        for (let letra of iterador) {
            selected.push(letra); 
        }
        component.set("v.catalogoDirecciones", catalogoDirecciones);
        component.set("v.dirSeleccionadas", selected);
        component.find("guardar").set("v.disabled",false);

    },
    
    guardar: function(component, event, helper){
        if(component.find("picklistDirecciones").get("v.value") === 'direccionesAux'){
            var contrato2   = JSON.stringify(component.get("v.contrato2"));
            var saveDirAux = component.get("c.saveDirAux");
            saveDirAux.setParams({ bandera : 'true', contrato2 : contrato2});
            saveDirAux.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Contrato actualizado con bandera');
                    $A.util.addClass(component.find("guardar"),'slds-hide');
                    $A.util.addClass(component.find("picklistDirecciones"),'slds-hide');
                    helper.muestraMensaje(component, event, helper,"Direcciones de Entrega", "El Layout se ha guardado correctamente", "Success");
                }
            });
            $A.enqueueAction(saveDirAux);
        }else{
            var direcciones = JSON.stringify(component.get("v.dirSeleccionadas"));
            var contrato2   = JSON.stringify(component.get("v.contrato2"));
            
            var accion = component.get("c.pruebaApex");
            accion.setParams({ direcciones : direcciones , contrato2 : contrato2, contrato2ID : component.get("v.contrato2").Id });
            accion.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("Envio exitoso");
                    component.find("guardar").set("v.disabled",true);
                    helper.muestraMensaje(component, event, helper,"Direcciones de Entrega", "Las Direcciones se han guardado correctamente", "Success");
                }
            });
            $A.enqueueAction(accion);
        }
    },
    
    cambiarEstatus : function(component, event) {
        if(event.getSource().get("v.name") === 'picklistDirecciones' && event.getSource().get("v.value") === 'direccionesAux'){
            $A.util.addClass(component.find("btn-agregarDireccion"),'slds-hide');
            $A.util.addClass(component.find("btn-quitarDireccion"),'slds-hide');
            $A.util.addClass(component.find("tablaDirecciones"),'slds-hide');
            component.set("v.contrato2.DireccionesAuxiliares__c",true);
            component.find("guardar").set("v.disabled", false);
        }else
        if(event.getSource().get("v.name") === 'picklistDirecciones' && event.getSource().get("v.value") !== ''){
            component.find("btn-agregarDireccion").set("v.disabled",false);
            component.set("v.contrato2.DireccionesAuxiliares__c",false);
            $A.util.removeClass(component.find("tablaDirecciones"),'slds-hide');
            $A.util.removeClass(component.find("btn-quitarDireccion"),'slds-hide');

        }else
        if(event.getSource().get("v.name") === 'picklistDirecciones' && event.getSource().get("v.value") === ''){
            component.set("v.contrato2.DireccionesAuxiliares__c",false);
            component.find("btn-agregarDireccion").set("v.disabled",true);
        }else{
            var deshabilitado = event.getSource().get("v.selectedRows").length > 0 ? false : true;
            component.find("btn-quitarDireccion").set("v.disabled",deshabilitado);
        }
    },
    
    bloqueaEnADV : function(component, event, helper){
        var getOportunidadContrato = component.get("c.getOportunidadContrato");
        getOportunidadContrato.setParams({ recordID : component.get("v.recordId") });
        getOportunidadContrato.setCallback( this , function(oportunidadContrato){
            if (oportunidadContrato.getState() === "SUCCESS" && oportunidadContrato.getReturnValue() !== null && oportunidadContrato.getReturnValue().PartidaPresupuesto__r.Quote.Opportunity.StageName === 'Alta de cliente') {
                $A.util.addClass(component.find("picklistDirecciones"),'slds-hide');
                $A.util.addClass(component.find("btn-agregarDireccion"),'slds-hide');
                $A.util.addClass(component.find("btn-quitarDireccion"),'slds-hide');
                $A.util.addClass(component.find("guardar"),'slds-hide');
                component.find("tablaDirecciones").set("v.hideCheckboxColumn", true);
                component.set("v.bandera", true);
            }else{
                  var getDirecciones = component.get("c.getCatalogoDirecciones");
                  getDirecciones.setParams({ opportunityID :  component.get("v.recordId")}); //component.get("v.oportunidad").Id
                  getDirecciones.setCallback(this, function(direcciones){
                      if(direcciones.getState() === "SUCCESS" && direcciones.getReturnValue().length > component.get("v.totalDirecciones")){

                          component.set("v.catalogoDirecciones" , direcciones.getReturnValue());
                          var mapa = new Map();
                          component.get("v.catalogoDirecciones").forEach( element => { mapa.set(element.Id, element); });
                          component.get("v.dirSeleccionadas").forEach( element => { if(mapa.has(element.Id)){ mapa.delete(element.Id); }});
                          component.set("v.catalogoDirecciones", Array.from(mapa.values()));
                          component.find("btn-agregarDireccion").set("v.disabled",true);
                      }
                  });
                  $A.enqueueAction(getDirecciones);
              }
        });
        $A.enqueueAction(getOportunidadContrato);
    }
})