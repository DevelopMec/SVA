({
    doInit : function(component, event, helper) {
        helper.iniciar(component,event);
	},
    guardadoTerminado : function(component, event, helper) {
        component.set("v.spin",false);
        helper.showToast(component,event,"success","Exito!","Información guardada correctamente");
        
        var action=component.get("c.ValidaEnvioAprobacion");
        action.setParams({idTicket:component.get("v.recordId")});  
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                 if(result.tipo=='success'){
                    $A.get('e.force:refreshView').fire();                    
                    setTimeout(function(){
                        helper.showToast(component,event,result.tipo,result.titulo,result.msj);
                    },1500);
                }
            }
        });
        $A.enqueueAction(action);
    },
   inicioGuardar : function(component, event, helper) {
        component.set("v.spin",true);
    },
    errorGuardar : function(component, event, helper) {
        console.log(":Error recordEditForm:");
        component.set("v.spin",false);
        //helper.showToast(component,event,"error","Error!","Ocurrió un error al guardar la información");    
    },
    recargar : function(component, event, helper) {
        location.reload();     
    }
})