({
    
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        helper.getQuoteInfo(component, recordId);
    }
    
})