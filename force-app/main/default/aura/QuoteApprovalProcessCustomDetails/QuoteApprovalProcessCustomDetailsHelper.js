({
    
    getQuoteInfo : function(component, recordId) {
        
        var action = component.get("c.getRelatedQuoteInfo");
        
        action.setParams({
            'recordId' : recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.quote", storeResponse.quoteInfo);
                component.set("v.submitterComment", storeResponse.submitterComment);
                component.set("v.lastComments", storeResponse.lastApproverComments);
                component.set("v.conceptos", storeResponse.conceptos);
                component.set("v.elapsedTime", storeResponse.elapsedTime);
                component.set("v.isQuote", storeResponse.isQuote);
            }
        });
        
        $A.enqueueAction(action);
        
    }
    
})