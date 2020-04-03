({
	 MostarDatos: function(component,response){
		 var state=response.getState();
         if(state=='SUCCESS'){
            var result=response.getReturnValue();
            component.set('v.objDatosTarjeta', result);
            component.set('v.Mensaje', result.vError); 
             if (result.vError != ''){
                 component.set("v.datosVisibles", false);
             }
             else{
                 component.set("v.datosVisibles", true);
             }
             
             var action=component.get("c.buscarTarjeta");
             action.setParams({idTicket:component.get("v.recordId"),numT:result.RealNumTarjetaTag});
             action.setCallback(this,function(responseSec){
                 var stateSec=responseSec.getState();
                 if(stateSec=='SUCCESS'){
                     var resultSec=responseSec.getReturnValue();
                     if(resultSec.status=='success'){
                         component.set("v.objDatosTarjeta.NomProducto",resultSec.producto);
                         component.set("v.objDatosTarjeta.NomCuenta",resultSec.cuenta);	
                         component.set("v.objDatosTarjeta.IdSubCuenta",resultSec.subcuenta);
                     }else{
                         if (result.vError2 != ''){
                             var toastEvent = $A.get("e.force:showToast");
                             toastEvent.setParams({
                                 "type":"warning",
                                 "title": "Advertencia!",
                                 "message": result.vError2
                             });
                             toastEvent.fire();    
                         }
                         if (result.vError != ''){
                             var toastEvent2 = $A.get("e.force:showToast");
                             toastEvent2.setParams({
                                 "type":"warning",
                                 "title": "Advertencia!",
                                 "message": result.vError
                             });
                             toastEvent2.fire();    
                         }
                     }
                 }else if(stateSec!='SUCCESS'){
                     if (result.vError2 != ''){
                         var toastEvent = $A.get("e.force:showToast");
                         toastEvent.setParams({
                             "type":"warning",
                             "title": "Advertencia!",
                             "message": result.vError2
                         });
                         toastEvent.fire();    
                     }
                     if (result.vError != ''){
                         var toastEvent2 = $A.get("e.force:showToast");
                         toastEvent2.setParams({
                             "type":"warning",
                             "title": "Advertencia!",
                             "message": result.vError
                         });
                         toastEvent2.fire();    
                     }
                 }
             });
             $A.enqueueAction(action);
        }	
	}
 
})