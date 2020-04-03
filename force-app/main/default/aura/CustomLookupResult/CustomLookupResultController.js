({
    selectRecord : function(component, event, helper){      
        //Get the selected record from list.
        var getSelectRecord = component.get("v.oRecord");
        //Call the event.
        var compEvent = component.getEvent("oSelectedRecordEvent");
        //Set the Selected sObject Record to the event attribute.
        compEvent.setParams({"recordByEvent" : getSelectRecord });  
        //Fire the event
        compEvent.fire();
    },
})