({
    
    getCommentsInfo : function(component, recordId) {
        
        var action = component.get("c.getCommentsInfo");
        
        action.setParams({
            'recordId' : recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set('v.commentsInfo', storeResponse.comments);
                component.set('v.isQuote', storeResponse.isQuote);
                component.set('v.isPending', storeResponse.isPending);
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    sendComments : function(component, recordId, comments) {
        
        var action = component.get("c.insertComments");
        
        action.setParams({
            'recordId' : recordId,
            'comment' : comments
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //var storeResponse = response.getReturnValue();
                //component.set('v.commentsInfo', storeResponse);
		        component.set('v.newComment','');
                $A.get('e.force:refreshView').fire();
            }
        });
        
        $A.enqueueAction(action);
        
    }
    
})