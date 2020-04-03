({
	doInit : function(component, event, helper) {        
        var action = component.get("c.getListEjecutivos");
        action.setParams({
            recordId: component.get("v.recordId")  
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //location.reload();
            //alert('se actualiza');
            if (state === "SUCCESS") {      
                component.set("v.ejecutivos",response.getReturnValue());                 
                console.log(response.getReturnValue()); 
                //
                //
            }   
        });
        $A.enqueueAction(action);
    }
})