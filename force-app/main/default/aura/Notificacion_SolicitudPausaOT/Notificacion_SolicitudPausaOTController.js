({
    doInit : function(component, event, helper) {
        var action=component.get("c.getDatos");
        //alert('pausado');
        action.setParams({recordId:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                /*var listM=[];
                for(var i=0;i<result.listM.length;i++){
                    listM.push({"value":result.listM[i],"label":result.listM[i]});
                }*/
                component.set("v.datos",result.listM);
                component.set("v.pendiente",result.pendientePausa);
                component.set("v.perfil",result.perfil);
                component.set("v.comentarioacp",result.comentario);
                if(result.pendientePausa == true){
                  component.set("v.dueno",true);  
                }               
                component.set("v.pausaaceptada",result.estadoAcepRecha);
                if(result.estadoAcepRecha == true){
                    component.set("v.vista",true);
                }
                component.set("v.pausarechaza",result.estadorechaza);
                if(result.estadorechaza==true){
                    component.set("v.vistarechazo",true);
                }
                
                console.log("pendiente "+result.pendientePausa);
                console.log("perfil " + result.perfil);
                console.log("okaceptacion " + result.estadoAcepRecha);
                console.log("okrechazo " + result.estadorechaza);
                console.log("estado " + result.estadoAcepRecha);
            }else{
                /*component.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Error!",
                    "message": "Error al iniciar componente",                        
                });*/
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": "Error al iniciar componente"
                });
                toastEvent.fire();
                
                console.log("Error doInit");
            }
            var cmpTarget = component.find('spinner');
            $A.util.addClass(cmpTarget, 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    solicitarPausa : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.spin",true);
        var action=component.get("c.solicitudPausa");
        var motivosSelect=component.find("motivo").get("v.value");
        var coment=component.find("comentarios").get("v.value");
        console.log("m:"+motivosSelect);
        if(motivosSelect!=null&&motivosSelect!=''){
            //var motivosString=motivosSelect.toString();
            action.setParams({recordId:component.get("v.recordId"),motivos:motivosSelect,comentarios:coment});
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=='SUCCESS'){
                    var result=response.getReturnValue();
                    if(result){   
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Exito!",
                            "message": "Se ha echo la solicitud para pausar la Orden de trabajo"
                        });
                        toastEvent.fire();
                        setTimeout(function(){
                            location.reload();
                        },1500);
                        /*component.find('notifLib').showNotice({
                            "variant": "info",
                            "header": "Exito!",
                            "message": "Se ha echo la solicitud para pausar la Orden de trabajo",
                            closeCallback: function() {
                                location.reload();
                            }
                        });*/
                    }else{
                        toastEvent.setParams({
                            "type":"error",
                            "title": "Error!",
                            "message": "Ha ocurrido un error al solicitar la pausa de la orden de trabajo"
                        });
                        toastEvent.fire();
                        /*component.find('notifLib').showNotice({
                            "variant": "error",
                            "header": "Error!",
                            "message": "Ha ocurrido un error al solicitar la pausa de la orden de trabajo",                        
                        });*/
                    }
                    component.set("v.spin",false);
                }else{
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Ha ocurrido un error al solicitar la pausa de la orden de trabajo"
                    });
                    toastEvent.fire();
                    /* component.find('notifLib').showNotice({
                            "variant": "error",
                            "header": "Error!",
                            "message": "Ha ocurrido un error al solicitar la pausa de la orden de trabajo",                        
                        });*/
                    console.log("Error SolicitarPausa");
                    component.set("v.spin",false);
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.spin",false);
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Ingrese un motivo para poder solicitar la pausa de la Orden de trabajo"
            });
            toastEvent.fire();
            /*component.set("v.mostrarAlerta",true);
            component.set("v.spin",false);
            setTimeout(function(){
                component.set("v.mostrarAlerta",false);
            },2000);*/
        }
        
    },
    solicitarRevision : function(component, event, helper) {
        console.log("INICIOREV");
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.spin",true);
        var action=component.get("c.solicitaRevision");
        var coment=component.find("comentariosEjecutivo").get("v.value");
        console.log("INICIOREV2");
        if(coment!=null&&coment!=''){
            console.log("INICIOREVtrue");
            action.setParams({recordId:component.get("v.recordId"),comentarios:coment});
            console.log("INICIOREVtrue2");
            action.setCallback(this,function(response){
                var state=response.getState();console.log("INICIOREVtruestst");
                if(state=='SUCCESS'){console.log("INICIOREVtruesuc");
                                     var result=response.getReturnValue();
                                     if(result){
                                         toastEvent.setParams({
                                             "type":"success",
                                             "title": "Exito!",
                                             "message": "Se ha echo la solicitud para la revisión de la Orden de trabajo"
                                         });
                                         toastEvent.fire();
                                         setTimeout(function(){
                                             location.reload();
                                         },1500);
                                         /*component.find('notifLib').showNotice({
                            "variant": "info",
                            "header": "Exito!",
                            "message": "Se ha echo la solicitud para la revisión de la Orden de trabajo",
                            closeCallback: function() {
                                location.reload();
                            }
                        });*/
                    }else{
                        toastEvent.setParams({
                            "type":"error",
                            "title": "Error!",
                            "message": "Ha ocurrido un error al solicitar la revisión de la orden de trabajo"
                        });
                        toastEvent.fire();
                        /*component.find('notifLib').showNotice({
                            "variant": "error",
                            "header": "Error!",
                            "message": "Ha ocurrido un error al solicitar la revisión de la orden de trabajo",                        
                        });*/
                    }
                                     component.set("v.spin",false);
                                    }else{
                                        toastEvent.setParams({
                                            "type":"error",
                                            "title": "Error!",
                                            "message": "Ha ocurrido un error al solicitar la revisión de la orden de trabajo"
                                        });
                                        toastEvent.fire();
                                        /*component.find('notifLib').showNotice({
                        "variant": "error",
                        "header": "Error!",
                        "message": "Ha ocurrido un error al solicitar la revisión de la orden de trabajo",                        
                    });*/
                    console.log("Error SolicitarRevision");
                    component.set("v.spin",false);
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.spin",false);
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Ingrese un comentario para solicitar la revisión"
            });
            toastEvent.fire();
            /*component.set("v.mostrarAlertaEj",true);
            component.set("v.spin",false);
            setTimeout(function(){
                component.set("v.mostrarAlertaEj",false);
            },2000);*/
        }
        
    },
    aceptar : function(component,event,helpe){
        console.log("aceptar pausa");
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.spin",true);
        var action=component.get("c.aceptapausa");
        var coment=component.find("comentariosEjecutivo").get("v.value");
        console.log("aceptar pausa2");
        console.log('erro')
        if(coment!=null&&coment!=''){
            console.log("INICIOREVtrue");
            action.setParams({"recordId":component.get("v.recordId"),
                              "comentarios":coment});
            console.log("INICIOREVtrue2");
            action.setCallback(this,function(response){
                var state=response.getState();console.log("INICIOREVtruestst");
                if(state=='SUCCESS'){console.log("INICIOREVtruesuc");                                     
                                     var result=response.getReturnValue();                                     
                                     component.set("v.comentarioacp",result.comentario);
                                     console.log("returcon "+result.comentario);
                                     component.set("v.status",result.estatus);
                                     console.log("returestatu " + result.estatus);
                                     
                                     if(result){
                                        var come= component.set("v.comentarioacp",result.comentario);
                                         console.log("returcon "+result.comentario);
                                        var esta= component.set("v.status",result.estatus);
                                         console.log("returestatu " + result.estatus);
                                         toastEvent.setParams({
                                             "type":"success",
                                             "title": "Exito!",
                                             "message": "Se ha aceptado correctamente la pausa de la Orden de trabajo"
                                         });
                                         toastEvent.fire();
                                         setTimeout(function(){
                                             location.reload();
                                         },1500);
                                     }else{
                                         toastEvent.setParams({
                                             "type":"error",
                                             "title": "Error!",
                                             "message": "Ha ocurrido un error al aceptar la pausa de la orden de trabajo"
                                         });
                                         toastEvent.fire();
                                     }
                                     component.set("v.spin",false);
                                    }else{
                                        toastEvent.setParams({
                                            "type":"error",
                                            "title": "Error!",
                                            "message": "Ha ocurrido un error al aceptar la pausa de la orden de trabajo"
                                        });
                                        toastEvent.fire();
                                        console.log("Error SolicitarRevision");
                                        component.set("v.spin",false);
                                    }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.spin",false);
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Ingrese un comentario para la aceptacion de la pausa"
            });
            toastEvent.fire();
        }
        
    },   
    rechazar : function(component,event,helpe){
        console.log("aceptar pausa");
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.spin",true);
        var action=component.get("c.rechazarpausa");
        var coment=component.find("comentariosEjecutivo").get("v.value");
        console.log("aceptar pausa2");
        if(coment!=null&&coment!=''){
            console.log("INICIOREVtrue");
            action.setParams({recordId:component.get("v.recordId"),comentarios:coment});
            console.log("INICIOREVtrue2");
            action.setCallback(this,function(response){
                var state=response.getState();console.log("INICIOREVtruestst");
                if(state=='SUCCESS'){console.log("INICIOREVtruesuc");
                                     var result=response.getReturnValue();
                                     if(result){
                                        var come= component.set("v.comentarioacp",result.comentario);
                                        console.log("returcon "+result.comentario);
                                        var esta= component.set("v.status",result.estatus);
                                        console.log("returestatu " + result.estatus);
                                         toastEvent.setParams({
                                             "type":"success",
                                             "title": "Exito!",
                                             "message": "Se ha rechazado correctamente la pausa de la Orden de trabajo"
                                         });
                                         toastEvent.fire();
                                         setTimeout(function(){
                                             location.reload();
                                         },1500);
                                     }else{
                                         toastEvent.setParams({
                                             "type":"error",
                                             "title": "Error!",
                                             "message": "Ha ocurrido un error al aceptar la pausa de la orden de trabajo"
                                         });
                                         toastEvent.fire();
                                     }
                                     component.set("v.spin",false);
                                    }else{
                                        toastEvent.setParams({
                                            "type":"error",
                                            "title": "Error!",
                                            "message": "Ha ocurrido un error al aceptar la pausa de la orden de trabajo"
                                        });
                                        toastEvent.fire();
                                        console.log("Error SolicitarRevision");
                                        component.set("v.spin",false);
                                    }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.spin",false);
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Ingrese un comentario para la aceptacion de la pausa"
            });
            toastEvent.fire();
        }
        
    },   
    pausar : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        var action=component.get("c.pausarOT");
        action.setParams({recordId:component.get("v.recordId")});
        action.setCallback(this,function(response){  
			var result=response.getReturnValue();            
            component.set("v.pendiente",false);
            component.set("v.pendiente",result);
            component.set("v.vista",result);
            location.reload();
        });       
        $A.enqueueAction(action);
        
    },    
    okrechazo: function(component,event, helper){ 
        var toastEvent = $A.get("e.force:showToast");
        var action=component.get("c.rechazo");
        action.setParams({recordId:component.get("v.recordId")});
        action.setCallback(this,function(response){  
			var result=response.getReturnValue();            
            component.set("v.pendiente",false);
            component.set("v.pendiente",result);
            component.set("v.vista",result);
            location.reload();
        });
        

        $A.enqueueAction(action);
    }
})