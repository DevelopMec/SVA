({
	init : function(component, event, helper) {
		console.clear();
		helper.getInitialData(component, component.get("v.recordId"));
	},
	
	doNext : function(component, event, helper) {
		// var showCCEvent = component.getEvent("showCC");
		// showCCEvent.setParams({ "isCCVisible": true });
		// showCCEvent.fire();
		// helper.createRecords(component, component.get("v.recordId"));
		helper.mapAnnexAData(component, component.get("v.recordId"));
	}
})