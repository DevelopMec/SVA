({
	guardar : function(component,event) {
        component.set("v.spinner",true);
        var toastEvent = $A.get("e.force:showToast");
		var action=component.get("c.guardarDatos");
        action.setParams({info:JSON.stringify(component.get("v.productos")),comentarios:component.get("v.comentarios")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){                
                toastEvent.setParams({
                    "title": "Exito!",
                    "type":"success",
                    "message": "Información actualizada correctamente"
                });
                toastEvent.fire();
                component.set("v.spinner",false);
                location.reload();
            }else{
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Error al guardar los registros"
                });
                toastEvent.fire();
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
	}
})