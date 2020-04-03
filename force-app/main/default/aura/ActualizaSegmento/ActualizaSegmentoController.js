({
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
    
    CallUpdateSegment : function(component, event, helper) {
        var changeElement = component.find("btnProcess");
        $A.util.toggleClass(changeElement, "slds-hide");
        
        var action = component.get("c.ActualizarSegmento"); 
        action.setParams({ vId : component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                var theResponse = response.getReturnValue();
                console.log("RESPONSE OK'", theResponse, "'");
            }
        });
        $A.enqueueAction(action);
    }
})