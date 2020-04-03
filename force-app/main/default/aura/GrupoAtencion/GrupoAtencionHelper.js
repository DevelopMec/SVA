({
	escalarCaso : function(component, casoId) {
        var toastEvent = $A.get('e.force:showToast');
        var refreshPage = $A.get('e.force:refreshView');
        var action = component.get("c.siguienteCaso");
        action.setParams({
            "dato": casoId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var dataMap = response.getReturnValue();
                console.log(dataMap.message);
                if(dataMap.status == 'success'){
                    toastEvent.setParams({
                        'title':'Success!',
                        'type':'success',
                        'mode':'dismissable',
                        'message': dataMap.message
                    });
                    toastEvent.fire();
                    refreshPage.fire();
                }else if(dataMap.status == 'warning'){
                    toastEvent.setParams({
                        'title':'Warning!',
                        'type':'warning',
                        'mode':'dismissable',
                        'message': dataMap.message
                    });
                    toastEvent.fire();
                }else if(dataMap.status == 'error'){
                    toastEvent.setParams({
                        'title':'Error!',
                        'type':'error',
                        'mode':'dismissable',
                        'message': dataMap.message
                    });
                    toastEvent.fire();
                }
            }else{
                alert('Error in getting data');
            }
        });
        $A.enqueueAction(action);
    },
    rechazarCaso : function(component, casoId,coment) {
        var toastEvent = $A.get('e.force:showToast');
        var refreshPage = $A.get('e.force:refreshView');
        var action = component.get("c.anteriorCaso");
        action.setParams({
            "dato": casoId,
            "dato2":coment
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var dataMap = response.getReturnValue();
                if(dataMap.status == 'success'){
                    toastEvent.setParams({
                        'title':'Success!',
                        'type':'success',
                        'mode':'dismissable',
                        'message': dataMap.message
                    });
		            var modal = component.find("casoModal");
                    var modalBackdrop = component.find("casoModalBackdrop");
                    $A.util.removeClass(modal,'slds-fade-in-open');
                    $A.util.removeClass(modalBackdrop,'slds-backdrop_open');
					component.set("v.Comentarios", "");
                    toastEvent.fire();
                    refreshPage.fire();
                    		
               }else if(dataMap.status == 'warning'){
                    toastEvent.setParams({
                        'title':'Warning!',
                        'type':'warning',
                        'mode':'dismissable',
                        'message': dataMap.message
                    });
                   		var modal = component.find("casoModal");
                        var modalBackdrop = component.find("casoModalBackdrop");
                        $A.util.removeClass(modal,'slds-fade-in-open');
                        $A.util.removeClass(modalBackdrop,'slds-backdrop_open');
                   		component.set("v.Comentarios", "");
                    	toastEvent.fire();
                }else if(dataMap.status == 'error'){
                    toastEvent.setParams({
                        'title':'Error!',
                        'type':'error',
                        'mode':'dismissable',
                        'message': dataMap.message
                    });
                    toastEvent.fire();
                }
            }else{
                alert('Error in getting data');
            }
        });
        $A.enqueueAction(action);
    },
})