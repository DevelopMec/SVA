({
	init : function(component, event, helper) {
		helper.mapAnnexAData(component, component.get("v.recordId"));
	},
	
	doNext : function(component, event, helper) {
		// var showCCEvent = component.getEvent("showCC");
		// showCCEvent.setParams({ "isCCVisible": true });
		// showCCEvent.fire();
		// helper.createRecords(component, component.get("v.recordId"));
		helper.mapAnnexAData(component, component.get("v.recordId"));
	},
	
	navigateToRecord : function(component, event, helper) {
		if (!event.getSource) {
			// console.log("event:", event, event.target.id);
			var navEvent = $A.get("e.force:navigateToSObject");
			navEvent.setParams({
				"recordId": event.target.id
			});
			navEvent.fire();
		}
	}
})