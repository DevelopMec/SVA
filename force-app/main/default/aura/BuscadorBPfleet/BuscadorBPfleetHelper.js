({
    showToast : function(component, event, tipo,titulo,msj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":tipo,
            "title": titulo,
            "message": msj
        });
        toastEvent.fire();
    },
    crearNewLead : function(component, event,nombreCuenta,rfc,idRecordTpype){
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Lead",
            "defaultFieldValues": {
                'RFC__c' : rfc.replace(/\s/g, ""),
                'Company' : nombreCuenta,
                'RecordTypeId': idRecordTpype
            }
        });
        createRecordEvent.fire();
    }
})