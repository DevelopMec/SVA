({
    
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        helper.getCommentsInfo(component, recordId);
    },
    
    sendComments : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('recordId ' +recordId );
        var comments = component.get("v.newComment");
        if (comments != '') {
            helper.sendComments(component, recordId, comments);
        }
    }
    
})