({
    obtenerDirecciones : function( component ,origen){
        component.set("v.spin",true);
        
        var recordId = component.get("v.recordId");
        var actionD=component.get("c.getDireccionesCuenta");
        actionD.setParams({idAcc:recordId});
        actionD.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                var listDir=[];
                for(var i=0;i<result.length;i++){
                    listDir.push({"label":result[i].Name,"value":result[i].Id});
                }
                //console.log("resultD:"+JSON.stringify(listDir));
                component.set("v.listDireccionesCuenta",listDir);
                component.set("v.spin",false);
                if(origen=='refresh'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Direcciones actualizadas!"
                    });
                    toastEvent.fire();   
                }
            }else{
                console.log("Error obtener direcciones");
            }
        });    
        $A.enqueueAction(actionD);
    },
	redirectToCreate : function( component ) {
		var recordTypeId 		= component.get('v.app_ctc.recordTypeId')
		var accountId 			= component.get('v.app_ctc.accountId')
		var createRecordEvent 	= $A.get('e.force:createRecord')

		createRecordEvent.setParams({
	        'entityApiName': 'EntidadLegal__c',
	        'recordTypeId': recordTypeId,
	        'defaultFieldValues': {
	        	'Cuenta__c': accountId
	        },
	        'panelOnDestroyCallback': function(event) {
                var urlEvent = $A.get("e.force:navigateToURL")
			    urlEvent.setParams({
			      'url': '/' + accountId
			    })
			    urlEvent.fire()
            }
	    })
    	createRecordEvent.fire()
	}
})