({
    ingresarId : function(component, event, helper) {
        component.set("v.spin",true);
        var idL=component.find("idLlamada").get("v.value");
        if(idL!=null&&idL!=''&&idL.trim()!=''){
            var action=component.get("c.setIdLlamada");
            action.setParams({idCaso:component.get("v.recordId"),idLlamada:idL});
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=='SUCCESS'){
                    helper.showToast(component,event,"success","Exito!","Id de Llamada ingresado correctamente");
                    component.set("v.spin",false);
                    $A.get('e.force:refreshView').fire();
                }else{
                    helper.showToast(component,event,"error","Error!","Error setIdLlamada");
                    component.set("v.spin",false);
                }
            });
            $A.enqueueAction(action);
        }else{
            helper.showToast(component,event,"error","Error!","Ingrese un Id de Llamada");
            component.set("v.spin",false);
        }
	}
})