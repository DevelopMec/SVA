({
    filterContracts : function(component, event, returnedValue, origin) {
        let showAll = component.get("v.showAll");
        if (showAll === true) {
            //Show all contracts
            if (origin == 'RFC') {
            	component.set("v.entidades", returnedValue);  
            } else if (origin == 'Ejecutivo') {
            	component.set("v.ejecutivos", returnedValue);  
            }
        } else if (showAll === false){
            //Show only active contracts
            //Remove inactive contracts
            function selectActives(contrato) {
                return contrato.isActive__c === true;
            }
            //Remove array members with empty listacontrato
            function hasActivesContracts(el) {
                return el.listacontrato != '';
            }
            //Remove array members with empty setProducto
            function hasSetProducto(el) {
                return el.setProducto != '';
            }
            //Iterate over the server response and remove inactive contracts
            returnedValue.forEach(function(entry){
                entry.setProducto.forEach(function(childrenEntry){
                    if (childrenEntry.listacontrato != undefined) {
                        childrenEntry.listacontrato = childrenEntry.listacontrato.filter(selectActives);
                    }
                })
                if (entry.setProducto != undefined) {
                    entry.setProducto = entry.setProducto.filter(hasActivesContracts);
                }
            })
            if (origin == 'RFC') {
            	component.set("v.entidades", returnedValue);  
            } else if (origin == 'Ejecutivo' && returnedValue != undefined) {
               	returnedValue = returnedValue.filter(hasSetProducto);
            	component.set("v.ejecutivos", returnedValue);  
            }
        }
        var a = component.get('c.doInit');
        $A.enqueueAction(a); 
    }
})