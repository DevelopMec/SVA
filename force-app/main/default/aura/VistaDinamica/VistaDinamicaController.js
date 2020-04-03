({
    myAction : function(component, event, helper) {
         var Opselect = component.find("filtro").get("v.value");
        if (Opselect == 'Familia'){
             var a = component.get('c.doInit');
             $A.enqueueAction(a); 
        }
        if (Opselect == 'RFC'){
            var action = component.get("c.getentidades");
            action.setParams({
                recordId: component.get("v.recordId")            
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
        			helper.filterContracts(component,event, response.getReturnValue(), Opselect);
                }   
            });
            $A.enqueueAction(action);
         }
        
        if (Opselect == 'Ejecutivo'){
            var action = component.get("c.getEjecutivos");
            action.setParams({
                recordId: component.get("v.recordId")            
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {      
                    console.log(response.getReturnValue());
        			helper.filterContracts(component,event, response.getReturnValue(), Opselect);
                }   
            });
            $A.enqueueAction(action);
         }
    }, 
    doInit : function(component, event, helper) {  
        var Opselect = component.find("filtro").get("v.value");
        var action = component.get("c.getFamilia");
        action.setParams({
            recordId: component.get("v.recordId"), filtro:Opselect                     
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                let familias = response.getReturnValue();
				let showAll = component.get("v.showAll");
                if (showAll === true) {
                    //Show all contracts
                    component.set("v.familias", familias);  
                } else if (showAll === false) {
                    //Show only active contracts
                    //Remove inactive contracts
                    function selectActives(contrato) {
                        return contrato.isActive__c === true;
					}
                    //Remove array members with empty listacontrato
                    function hasActivesContracts(el) {
                        return el.listacontrato != '';
					}
                    //Iterate over the server response and remove inactive contracts
                    familias.forEach(function(entry){
                        if (entry.listacontrato != undefined) {
                        	entry.listacontrato = entry.listacontrato.filter(selectActives);
                        }
                    })
                    if (familias != undefined) {
                        familias = familias.filter(hasActivesContracts);
                    }
                    component.set("v.familias", familias);  
                }
                console.log(response.getReturnValue());                
            }   
        });
        $A.enqueueAction(action);
    },      
    
    showAll : function(component, event, helper) {
        component.set("v.showAll",true);    
        component.set("v.allButtonVariant", 'brand');  
        component.set("v.activosButtonVariant", 'neutral'); 
        var a = component.get('c.myAction');
        $A.enqueueAction(a); 
    },
    
    showActives : function(component, event, helper) {
        component.set("v.showAll",false);  
        component.set("v.allButtonVariant", 'neutral');  
        component.set("v.activosButtonVariant", 'brand');
        var a = component.get('c.myAction');
        $A.enqueueAction(a); 
    }
    
})