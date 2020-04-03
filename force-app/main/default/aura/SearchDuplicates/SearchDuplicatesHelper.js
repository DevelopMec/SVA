({
	helperMethod : function(component) {
		var action = component.get("c.GetEntidadLegal");
        action.setParams({
			nombre : component.find("RazonSocial").get("v.value"),
            rfc:  component.find("RFC").get("v.value"),
            idGrupo:  component.find("idGrupo").get("v.value")
        });
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state == 'SUCCESS'){
               component.set("v.dataEL", response.getReturnValue());
               this.helperAccount(component);
            }else{
              this.helperAccount(component);
            }
        });
		$A.enqueueAction(action);
	},
    helperAccount : function(component) {
		var action = component.get("c.GetAccount");
        action.setParams({
			nombre : component.find("RazonSocial").get("v.value"),
            idGrupo:  component.find("idGrupo").get("v.value")
        });
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state == 'SUCCESS'){
               component.set("v.dataAccount", response.getReturnValue());  
            }
        });
		$A.enqueueAction(action);
	},
   helperLead : function(component) {
    var action = component.get("c.GetLead");
        action.setParams({
      nombre : component.find("RazonSocial").get("v.value")
        });
        action.setCallback(this,function(response){
          var state = response.getState();
            if(state == 'SUCCESS'){
               component.set("v.dataLead", response.getReturnValue());
            }
        });
    $A.enqueueAction(action);
  },
   helperOpportunity : function(component) {
    var action = component.get("c.GetOpportunity");
        action.setParams({
      nombre : component.find("RazonSocial").get("v.value")
        });
        action.setCallback(this,function(response){
          var state = response.getState();
            if(state == 'SUCCESS'){
               component.set("v.dataOpportunity", response.getReturnValue());
            }
          });
    $A.enqueueAction(action);
  },
   helperContact : function(component) {
    var action = component.get("c.GetContact");
        action.setParams({
      nombre : component.find("RazonSocial").get("v.value")
        });
        action.setCallback(this,function(response){
          var state = response.getState();
            if(state == 'SUCCESS'){
               component.set("v.dataContact", response.getReturnValue());
               component.set('v.isLoad',false);
            }else{
               component.set('v.isLoad',false); 
            }
        });
    $A.enqueueAction(action);
  }
})