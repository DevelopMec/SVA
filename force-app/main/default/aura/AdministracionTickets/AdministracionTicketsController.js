({
	ticketsRiesgo : function(component, event, helper) {
        component.set("v.spin",true);
		var action=component.get("c.getTickets");
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.ticketsRiesgo",response.getReturnValue().sort((a, b) => (a.subMotivo > b.subMotivo) ? 1 : -1));
                component.set("v.spin",false);
                component.set("v.verTickets",true);
                component.set("v.verResultTR",false);
                component.set("v.verResultMSS",false);
            }else{
                component.set("v.verTickets",false);
                component.set("v.verResultTR",false);
                component.set("v.verResultMSS",false);
                component.set("v.spin",false);
                console.log("Error getTickets");
            }
        });
        $A.enqueueAction(action);
	},
    setTipoRegistro : function(component, event, helper) {
        component.set("v.spin",true);
		var action=component.get("c.asignarTiposDeRegistro");
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.resultTR",response.getReturnValue());
                component.set("v.verTickets",false);
                component.set("v.verResultTR",true);
                component.set("v.verResultMSS",false);
                component.set("v.spin",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Tipo de registro actualizado"
                });
                toastEvent.fire();
            }else{
                component.set("v.verTickets",false);
                component.set("v.verResultTR",false);
                component.set("v.verResultMSS",false);
                component.set("v.spin",false);
                console.log("Error setTipoRegistro");
            }
        });
        $A.enqueueAction(action);
	},
    setMotivoSubMotivo : function(component, event, helper) {
        component.set("v.spin",true);
		var action=component.get("c.asignarMotivoSubMotivo");
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.verTickets",false);
                component.set("v.verResultTR",false);
                component.set("v.verResultMSS",true);
                component.set("v.spin",false);
                component.set("v.resultMSS",response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue()));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "valores actualizados"
                });
                toastEvent.fire();
            }else{
                component.set("v.verTickets",false);
                component.set("v.verResultTR",false);
                component.set("v.verResultMSS",false);
                component.set("v.spin",false);
                console.log("Error setMotivoSubMotivo");
            }
        });
        $A.enqueueAction(action);
	}
})