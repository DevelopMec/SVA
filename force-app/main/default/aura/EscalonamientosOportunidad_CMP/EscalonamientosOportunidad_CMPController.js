({
	editarEnabled : function(component, event, helper) {
        var compEvent = component.getEvent("edicionShow");
        compEvent.fire();
	},
    guardarInfo : function(component, event, helper) {
        var productos=component.get("v.productos");
        var tem=true;
        for(var i=0;i<productos.length;i++){
            if(productos[i].ServiceDate==null||productos[i].UnitPrice==""||(component.get("v.etapa")=='Implementación' && component.get("v.comentarios")==null)){
                tem=false;                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Complete todos los campos"
                });
                toastEvent.fire();
                break;
            }
        }
        if(tem){
            helper.guardar(component,event);
        }
	},
    validarFechas : function(component, event, helper) {
        var index=event.getSource().get("v.name");
        var productos=component.get("v.productos");
        
        for(var i=0;i<productos.length;i++){
            for(var f=i+1;f<productos.length;f++){
                if(productos[i].ServiceDate>=productos[f].ServiceDate){
                    component.set("v.botonEditar",true);
                    i=productos.length;
                    break;
                }else{
                    component.set("v.botonEditar",false);
                }
            }  
        }
	}
})