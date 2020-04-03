({
	doInit : function(component, event, helper) {
        component.set("v.spin",true);
        component.set('v.columns', [
            {label: 'Campo', fieldName: 'campo', type: 'text'},
            {label: 'Valor Anterior', fieldName: 'valorAnterior', type: 'text'},
            {label: 'Valor Nuevo', fieldName: 'valorNuevo', type: 'text'},
            {label: 'Usuario que realizó la Modificación',fieldName:'urlUsuario',type: 'url', typeAttributes: { label: { fieldName: 'usuario' },target : '_blank'}}
        ]);
        var action=component.get("c.getRegistros");
        action.setParams({idUsuario : component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.registros",response.getReturnValue());
                component.set("v.spin",false);
            }else{
                component.set("v.spin",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": "Error al obtener los registros"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})