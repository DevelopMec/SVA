({
    muestraAmenazas : function(component, event, helper) {
        var action = component.get("c.getAmenazas");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var listAmenazas = response.getReturnValue();
            component.set("v.listAmenazas", listAmenazas);
        });
        $A.enqueueAction(action);
    }
})