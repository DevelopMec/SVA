({
	Buscar : function(component, event, helper) {
        component.set('v.isLoad',true);
         component.set('v.dataEL',null);
        component.set('v.dataAccount',null);
		helper.helperMethod(component);
		helper.helperLead(component);
        helper.helperOpportunity(component);
        helper.helperContact(component);
    },
    search : function(component, event, helper) {
        if(event.keyCode === 13){
            component.set('v.isLoad',true);
            component.set('v.dataEL',null);
            component.set('v.dataAccount',null);
            helper.helperMethod(component);
            helper.helperLead(component);
            helper.helperOpportunity(component);
            helper.helperContact(component);
        }
        
    },
    searchAccount : function(component, event, helper) {
        $A.createComponent(   
                "c:AccountShare",{  
                    'recordId':event.getSource().get("v.tabindex")
                },
                function(newComponent){
                    component.set("v.body",newComponent); 
                });   
        
    },
    closeModal : function(component, event, helper) {
        component.set("v.body",null);
    }
    
})