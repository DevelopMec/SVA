({
	doInit : function(component, event, helper) {
        component.set("v.isLoad",true);
		var action=component.get("c.getInfo");
        action.setParams({idRegistro : component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.isLoad",false);
                component.set("v.habilitarAprobacion",response.getReturnValue());
            }else{
                component.set("v.isLoad",false);
                helper.showToast(component,event,"error","Error!","Error al iniciar componente");
            }
        });
        $A.enqueueAction(action);
	},
    solicitarAprob : function(component, event, helper) {
        component.set("v.isLoad",true);
		var action=component.get("c.solicitarAprobacion");
        action.setParams({idRegistro : component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            console.log("VER::"+state);
            console.log("VER>::"+response.getReturnValue());
            if(state=='SUCCESS'){
                if(response.getReturnValue()=='Error'){
                    helper.showToast(component,event,"warning","Error!","Error no se encontró usuario aprobador");
                    return;
                }
                component.set("v.isLoad",false);
                component.set("v.verAprob",false);
                helper.showToast(component,event,"success","Exito!","Solicitud de aprobación envida");
                setTimeout(function(){
                    $A.get('e.force:refreshView').fire();
                },1000);
            }else{
                component.set("v.isLoad",false);
                helper.showToast(component,event,"error","Error!","Error al solicitar Aprobación");
            }
        });
        $A.enqueueAction(action);
	}
})