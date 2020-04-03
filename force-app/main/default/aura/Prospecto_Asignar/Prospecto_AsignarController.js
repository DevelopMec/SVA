({
	doInit : function(component, event, helper) {
		var action = component.get("c.Asignar");
        action.setParams({vId:component.get("v.recordId")});	
         action.setCallback(this,function(response){
            var state = response.getState();
             if (state == "SUCCESS") {
                 
                 var value = response.getReturnValue();
                 if (value != ''){
                 	 console.log('error ' + value);
                     helper.showToast(component, event,'error', 'Error', 'Se ha producido un problema al momento de realizar el proceso, favor contactar al administrador.');   
                 }
                 else{
                    helper.showToast(component, event,'success', '', 'El prospecto ha sido asignado.');    
                 }
             }
         });
        
        $A.enqueueAction(action); 
        
  
	},
    
     doneRendering: function(cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})