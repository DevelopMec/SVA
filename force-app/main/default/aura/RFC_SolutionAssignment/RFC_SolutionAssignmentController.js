({
    doInit : function(component, event, helper) { 
		//Get contratos filiales list
        var action = component.get("c.getContratosFiliales");
        action.setParams({
            recordId: component.get("v.recordId")                     
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {      
                component.set("v.contratosList",response.getReturnValue());      
                //Check if the user has edit permission
                var action2 = component.get("c.getUserPermissions");
                action2.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {   
                        component.set("v.hasEditPermission",response.getReturnValue());                 
                    }   
                });       
                $A.enqueueAction(action2);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleEditClick : function(component, event, helper) { 
        component.set("v.isEditing",true);                 
    },
    
    handleCancelClick : function(component, event, helper) { 
        var action = component.get("c.getContratosFiliales");
        action.setParams({
            recordId: component.get("v.recordId")                     
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {      
                //Close the lookup fields and return them to their initial values.
                component.set("v.contratosList",response.getReturnValue());      
                component.set("v.isEditing",false);                 
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSaveClick : function(component, event, helper) { 
        var contratosList = component.get('v.contratosList');
        let invalidOwners = contratosList.filter(contrato => {
            return contrato.Owner.Id == null
        });
        //Check if all assignments have an owner selected in the lookup fields in order to update the owner.
        if (invalidOwners.length > 0) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error:",
                "message": "El ejecutivo asignado no puede estar vacío.",
                "type": "error",
            });
            toastEvent.fire();                
        } else {
            //Update contratos filiales owners.
            var action = component.get("c.updateOwners");
            action.setParams({
                recordId: component.get("v.recordId"),
                contratosNewOwner: component.get("v.contratosList")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                    //var updateEvent = $A.get("e.c:RefreshVistaDinamicaEvent");
                    //updateEvent.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    component.set("v.isEditing", false);      
                    toastEvent.setParams({
                        "title": "¡Bien!",
                        "message": "La asignación se ha realizado de manera correcta.",
                        "type": "success"
                    });
                    toastEvent.fire();
                } else if (state === "ERROR") {
                	let returnError = response.getError()[0].message;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error:",
                        "message": returnError,
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    }
})