({
    doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action=component.get("c.ObtenerDatos");
        console.log(component.get("v.recordId"));
        action.setParams({idTicket:component.get("v.recordId"), vNumTarjeta:''});
        action.setCallback(this,function(response){
            helper.MostarDatos(component,response);
            var state=response.getState();
            if(state=='SUCCESS'){
                $A.get('e.force:refreshView').fire();                    
            }
            
            component.set("v.Spinner", false); 
        });
        $A.enqueueAction(action);
    },
    
    EvaluarNumTarjetaTag : function(component, event, helper) {
        var value = document.getElementById("txtNumTarjeta").value;
        component.set("v.Spinner", true);
        
        component.set("v.Mensaje", '');
        console.log('(value.length ' + value.length);
        console.log('value ' + value);

        
        var action=component.get("c.GuardarDatos");
        console.log(component.get("v.recordId"));
        action.setParams({idTicket:component.get("v.recordId"), vNumTarjeta:value});
        action.setCallback(this,function(response){
            helper.MostarDatos(component,response);
            var state=response.getState();
            if(state=='SUCCESS'){
                $A.get('e.force:refreshView').fire();                    
                
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);

},
 
 showSpinner : function (component, event, helper) {
    component.set("v.Spinner", true);  
},
    hideSpinner : function (component, event, helper) {
        component.set("v.Spinner", false); 
    },
        
        
})