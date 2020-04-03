({
	navigateToRecord: function(component, event, helper) {
		if (!event.getSource) {
			let navEvent = $A.get("e.force:navigateToSObject");
			navEvent.setParams({
				"recordId": event.target.id
			});
			navEvent.fire();
		}
	}
})