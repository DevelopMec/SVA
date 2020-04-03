({
	doInit : function(component, event, helper) {
		var action = component.get("c.GetAccountShared");
        console.log("*********"+ component.get("v.recordId"));
        action.setParams({
			IdAccount : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state == 'SUCCESS'){
               component.set("v.dataAccountShare", response.getReturnValue());               
            }
        });
		$A.enqueueAction(action);
	}
})