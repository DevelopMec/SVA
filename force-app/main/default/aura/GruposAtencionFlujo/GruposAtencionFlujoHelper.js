({
    /*iniciar : function(component,event,proceso){
        console.log("inint");
        var action=component.get("c.getDatos");
        action.setParams({idTicket:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                if(result.Motivo__c==null||result.Motivo__c==''){
                    component.set("v.sinSubmotivo",true);
                    component.set("v.spin",false);  
                }
                if(proceso=='Actualiza'){
                    $A.get('e.force:refreshView').fire();
                    component.set("v.spin",false);
                    setTimeout(function(){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Exito!",
                            "message": "Caso escalado correctamente"
                        });
                        toastEvent.fire();
                    },1000);                        
                }
            }else{
                component.set("v.spin",false);
            }
        });
        $A.enqueueAction(action);  
    },*/
	showToast : function(component, event,tipo,titulo,mensaje) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":tipo,
            "title": titulo,
            "message": mensaje
        });
        toastEvent.fire();
    }
})