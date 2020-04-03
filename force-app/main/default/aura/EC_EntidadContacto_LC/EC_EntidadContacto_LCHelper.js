({
	showHideModal : function( component ) {
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop_open');
        // component.set("v.showDialog", "false");
    },

	showHideModalRemove : function( component ) {
        var removeDialog = component.find("removeDialog");
        $A.util.toggleClass(removeDialog, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop_open');
        // component.set("v.showDialog", "false");
    }
})