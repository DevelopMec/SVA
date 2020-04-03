({
    init : function(component, event, helper) {        
        var action = component.get("c.getQuoteItemId");
        action.setParams({
            idOportunidad : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var result=response.getReturnValue();
                var idQuote = result.Id;
                
                if(result.Quote.Opportunity.StageName=='Cotización'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"warning",
                        "title": "Información!",
                        "message": "El contrato no puede abrirse en etapa Cotización!!"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }else{
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:AltaContrato_CMP",
                        componentAttributes: {
                            recordId : idQuote
                        }
                    });
                    evt.fire();
                }
                
                
                /*var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/apex/CON_LCsContainer_VFP?id="+idQuote,
                    "isredirect": "true"
                });
                urlEvent.fire();*/
                
               /* if(result.Product2.IDInterno__c!='30'&& result.Product2.ProductCode!='31'){
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/apex/CON_LCsContainer_VFP?id="+idQuote,
                        "isredirect": "true"
                    });
                    urlEvent.fire();
                }else{
                
                    // var urlEvent = $A.get("e.force:navigateToURL");
                    //urlEvent.setParams({
                      //  "url": "/apex/AltaContrato_VF",
                        //"isredirect": "true"
                    //});
                    //urlEvent.fire();
                    
                    if(result.Quote.Opportunity.StageName=='Cotización'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"warning",
                            "title": "Información!",
                            "message": "El contrato no puede abrirse en etapa Cotización!!"
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                    }else{
                        var evt = $A.get("e.force:navigateToComponent");
                        evt.setParams({
                            componentDef : "c:AltaContrato_CMP",
                            componentAttributes: {
                                recordId : idQuote
                            }
                        });
                        evt.fire();
                    }
                }*/
            }
        });
        $A.enqueueAction(action);
        
    }
})