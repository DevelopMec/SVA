({
	IniciarComponente : function(component,event) {
        component.set("v.spin",true);
		var action=component.get("c.getDatos");
        action.setParams({recordId:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                //console.log("ver:::"+JSON.stringify(result));
                if(result.length>=1){
                    component.set("v.tieneEscalonamiento",true);
                    component.set("v.etapa",result[0].Quote.Opportunity.StageName);
                }
                component.set("v.productos",result);
                component.set("v.productosIn",result);
                component.set("v.spin",false);
            }else{
                console.log("Error IniciarComponente");
            }
        });
        $A.enqueueAction(action);
	}
})