({
	consultar : function(component, event, helper) {
        component.set("v.spin",true);
		var action=component.get("c.oneExcute");
        var suc=component.find("Sucursal").get("v.value");
        var prod=component.find("Producto").get("v.value");
        var grup=component.find("Grupo").get("v.value");
        var clien=component.find("Cliente").get("v.value");
        var toastEvent = $A.get("e.force:showToast");
        if(suc!=null&&suc!=''&&prod!=null&&prod!=''&&grup!=null&&grup!=''&&clien!=null&&clien!=''){
            action.setParams({sucursal:suc,producto:prod,grupo:grup,cliente:clien});
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=='SUCCESS'){
                    var result=response.getReturnValue();
                    var tit='';
                    if(result.tipo=='error'){
                        tit='Error!';
                    }else{
                        tit='Exito!';
                    }
                    toastEvent.setParams({
                        "title": tit,
                        "type":result.tipo,
                        "message": result.msj
                    });
                    toastEvent.fire();
                    component.set("v.spin",false);
                }else{
                    console.log("Error");
                    component.set("v.spin",false);
                }
            });
            $A.enqueueAction(action);
        }else{
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Ingrese todos los datos"
            });
            toastEvent.fire();
            component.set("v.spin",false);
        }
    }
})