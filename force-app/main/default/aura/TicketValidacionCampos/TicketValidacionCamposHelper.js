({
    iniciar : function(component, event,tipo,titulo,mensaje) {
        console.log("::INIT::");
        component.set("v.spin",true);
        var action=component.get("c.getInfo");
        action.setParams({idTicket:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                if(result.motivo){
                    if(result.lista!=null&&result.lista.length>0){
                        component.set("v.campos",result.lista);
                        component.set("v.esPropietario",result.isOwner);
                        console.log("ESPROP:"+result.isOwner);
                        console.log("LIST:"+JSON.stringify(result.lista));
                        component.set("v.mostrar",true);
                        component.set("v.spin",false);
                    }else{
                        component.set("v.mensaje","No se requieren campos obligatorios.");
                        component.set("v.tipo","info");
                        component.set("v.spin",false);
                    }
                }else{
                    component.set("v.mensaje","Ingrese motivo y submotivo.");
                    component.set("v.tipo","warning");
                    component.set("v.spin",false);
                }
            }else{
                component.set("v.mensaje","No se encontro la combinación de en el catalogo.");
                component.set("v.tipo","warning");
                component.set("v.spin",false);   
            }
        });
        $A.enqueueAction(action);
    },
    showToast : function(component, event,tipo,titulo,mensaje) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":tipo,
            "title": titulo,
            "message": mensaje
        });
        toastEvent.fire();
    }
})