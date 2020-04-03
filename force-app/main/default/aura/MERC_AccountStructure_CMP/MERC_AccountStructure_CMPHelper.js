({
    showToast : function(toastType, toastTittle, toastMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": toastType,
            "title": toastTittle,
            "message": toastMessage
        });
        toastEvent.fire();        
    },
    fetchAffiliates : function(component, event, helper) {
        
        let action = component.get("c.getStructure");
        let idAccount = component.get("v.recordId");
        action.setParams({'idAccount' : idAccount});
        action.setCallback(this,function(response){
			let state = response.getState();
            if(state === 'SUCCESS') {
                let data = response.getReturnValue();
                component.set('v.accountAffiliates',data.afiliados);
                component.set('v.accountGroupers',data.agrupadores);
            }            
        });
        $A.enqueueAction(action);
    }
})