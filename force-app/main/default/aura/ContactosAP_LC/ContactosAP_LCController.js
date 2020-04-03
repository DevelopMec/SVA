({
	doInit : function(component, event, helper) {
        
        component.set('v.columnas', [
            {label: 'Nombre', fieldName: 'Name', type: 'text'},
            {label: 'Puesto', fieldName: 'Puesto__c', type: 'text'},
            {label: 'Función', fieldName: 'Funcion__c', type: 'text'},
            {label: 'Teléfono 1', fieldName: 'Phone', type: 'phone'},
            {label: 'Teléfono 2', fieldName: 'Telefono2__c', type: 'phone'},
            {label: 'Email', fieldName: 'Email', type: 'email'}
        ]);
        
        var action = component.get("c.getContactosAP");

        action.setParams({
            "idRegistro": component.get("v.recordId"),
            "nombreObjeto" : component.get("v.Objeto")
        });
        
        action.setCallback(this, function(response) {
           var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.contactosAP", response.getReturnValue());
            } 
        });
        
        $A.enqueueAction(action);
	}
})