({
    getProfile : function(component) {
         var action = component.get("c.getProfileN"); 
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var nombre= response.getReturnValue();                              
                component.set("v.ProfileName", nombre);  
                console.log("Perfil:" +nombre);
            }
        });
        $A.enqueueAction(action);
        
    },
     Message:function(component){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Alerta!",
            "message": "La opción seleccionada es invalida",
            "type": "alert"
        });
        toastEvent.fire();
    },
    
    Onchange:function(component){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Alerta!",
            "message": "La opción seleccionada es invalida",
            "type": "alert"
        });
        toastEvent.fire();
    }

})