({
    searchHelper : function(component, event, getInputkeyWord) {
        //To include different functions for different objects.
        if(component.get("v.objectAPIName") == 'User') {
            this.searchForUser(component, event, getInputkeyWord);
        }
        
    },
    //Search users
    searchForUser : function(component, event, getInputkeyWord) {
        var action = component.get("c.fetchLookupValues");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //Set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        $A.enqueueAction(action);
    }
})