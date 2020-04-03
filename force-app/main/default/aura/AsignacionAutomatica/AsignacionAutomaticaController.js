({
    doInit : function(component, event, helper) {
        var action = component.get("c.getUsers"); 
        var items = [];
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var listado= response.getReturnValue();                
                for (var i= 0 ; i < listado.length ; i++){
                   var item = {"label": listado[i].Name,"value":listado[i].Id };
                    items.push(item);                    
                }               
                component.set("v.UserList", items);  
                helper.getProfile(component);
            }
        });
        $A.enqueueAction(action);
    },
    handleChange: function (component, event,helper) {         
        component.set("v.SpinnerVisible",true); 
        component.set("v.Visible",false);    
        var selectedOptionId = event.getParam("value");        
        component.set("v.ObjectName","User");
        component.set("v.recordId",selectedOptionId);
        component.set("v.Visible",true);        
    },
    handleSuccess:function(component,event){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Exito!",
            "message": "El registro a sido actualizado.",
            "type": "success"
        });
        toastEvent.fire();
    },
    handleLoad:function(component,event){
        component.set("v.SpinnerVisible",false); 
    },
    onCh:function(component,event,helper){
        var perfil=component.get("v.ProfileName"); 
        var option = event.getParam("value");        
        console.log('c '+option);
        if(perfil=="Coordinador de implementación"&&option=="Ordenes de trabajo"){
            component.set("v.EnableSave","false");           
        }else if(perfil=="Administración de Ventas"&&option=="Altas de Cliente"){
            component.set("v.EnableSave","false");         
        }else if(perfil!="Administración de Ventas"&&perfil!="Coordinador de implementación"){
            component.set("v.EnableSave","false");         
        }else{
            component.set("v.EnableSave","true");  
            helper.Message(component);
        }
    
        
    }
    
      
})