({
	IniciarComponente : function(component,event) {
		var action=component.get("c.getDatos");
        action.setParams({recordId:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                component.set("v.contratosFiliales",result);
                console.log(':Datos:'+JSON.stringify(result));
                var cmpTarget = component.find('spinner');
                $A.util.addClass(cmpTarget, 'slds-hide');
            }else{
                console.log("Error IniciarComponente");
            }
        });
        $A.enqueueAction(action);
	}
})