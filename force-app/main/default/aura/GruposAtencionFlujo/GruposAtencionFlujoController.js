({
    doInit : function(component, event, helper){
        component.set("v.spin",true);
        var action=component.get("c.getTipos");
        action.setParams({idRecord:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.spin",false);
                component.set("v.tiposDeCasos",response.getReturnValue());
            }else{
                component.set("v.spin",false);
                helper.showToast(component,event,"error","Error!","Error al iniciar componente");
            }
        });
        $A.enqueueAction(action);
    },
    cambiarTipo : function(component, event, helper){
        component.set("v.spin",true);
        var action=component.get("c.cambiarTipoCaso");
        var tipoCaso=component.find("tipoCaso").get("v.value");
        action.setParams({tipo:tipoCaso,idRecord:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.spin",false);
                $A.get('e.force:refreshView').fire();                    
                setTimeout(function(){
                    helper.showToast(component,event,"success","Exito!","Tipo de caso cambiado correctamente");
                },1500);
            }else{
                component.set("v.spin",false);
                helper.showToast(component,event,"error","Error!","Error al cambiar el tipo de Caso");
            }
        });
        $A.enqueueAction(action);
    },
    escalacionRechazo : function(component, event, helper){
        console.log(":SIGUIENTE:");
        component.set("v.spin",true);
        var tip=event.getSource().get("v.name");        
        var com='';
        if(tip=='rechazo'){
            com=component.get('v.Comentarios');
            if(com==null||com==''){
                helper.showToast(component,event,"error","Error","Ingrese un comentario para el rechazo!");
                component.set("v.spin",false);
                return;
            }
        }
        var action=component.get("c.escalarRechazarCaso");
        console.log("--->"+tip);
        action.setParams({caso:component.get("v.recordId"),comentarios:com,tipo:tip});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                component.set("v.spin",false);
                if(result.tipo=='success'){
                    $A.get('e.force:refreshView').fire();                    
                    setTimeout(function(){
                        helper.showToast(component,event,result.tipo,result.titulo,result.msj);
                    },1500);
                    if(tip=='rechazo'){
                        var modal = component.find("casoModal");
                        var modalBackdrop = component.find("casoModalBackdrop");
                        $A.util.removeClass(modal,'slds-fade-in-open');
                        $A.util.removeClass(modalBackdrop,'slds-backdrop_open');
                    }
                }else{
                    helper.showToast(component,event,result.tipo,result.titulo,result.msj);
                }                
            }else{
                component.set("v.spin",false);
                helper.showToast(component,event,"error","Error!","Error al escalonar caso");
            }
        });
        $A.enqueueAction(action);
    },
    openModal : function(component, event, helper) {
        var modal = component.find("casoModal");
        var modalBackdrop = component.find("casoModalBackdrop");
        $A.util.addClass(modal,'slds-fade-in-open');
        $A.util.addClass(modalBackdrop,'slds-backdrop_open');
    },
    closeModal : function(component){
        var modal = component.find("casoModal");
        var modalBackdrop = component.find("casoModalBackdrop");
        $A.util.removeClass(modal,'slds-fade-in-open');
        $A.util.removeClass(modalBackdrop,'slds-backdrop_open');
    },
    cerrarAbrirModal : function(component){
        component.set("v.showModal",!component.get("v.showModal"));
    }
})