({    
    
  
    doInit : function(component, event, helper) {
        
       
        
        var action = component.get("c.EncuentraValores");
        action.setParams({
            recordId: component.get("v.recordId")
        });
      
        action.setCallback(this, function(response){
            var caso = response.getReturnValue();
                
           
            component.set("v.caso", caso);         
        });
 
        $A.enqueueAction(action);
    },
 

    handleSuccess : function(component, event, helper) {
        
        //var eventParams = event.getParams();
        //debbuger;
        //var eventParams = event.getParams("error"); 
        console.log(" Response : ", JSON.parse(JSON.stringify(event.getParams("error"))));
        //console.log(" Response : ", JSON.stringify(eventParams));
        //debugger;
        //var toastEvent = $A.get("e.force:showToast");
   		//toastEvent.setParams({duration:'7000', "title": "Mensaje preventivo: Los campos sin mensaje de error han sido guardados exitosamente.","message":"Si algún campo muestra mensaje de error, corríja su valor, y de nuevo pulse Guardar", "type": "success"});
        //toastEvent.fire();
        
    },
    
	handleError: function(component, event) { 
	//alert('Error Here' +event); 
	console.log(event); 
	var eventParams = event.getParams("error"); 
        console.log(" Response : ", JSON.parse(JSON.stringify(event.getParams("error"))));
        //debbuger;
        //console.log(" Response : ", JSON.stringify(eventParams));
       //debbuger;
        
                 			console.log('Error: ' + component.get("v.eventParams"));
            				var toastEvent = $A.get("e.force:showToast");
        					toastEvent.setParams({duration:'4000',"title": "Error!","message": "Revise y repita el ingreso de datos","type": "error"});
        					toastEvent.fire();
						    event.preventDefault();
        	
	},
    
  

 	handleSubmit: function(component, event) { 
       // event.preventDefault();
        
	//alert('Error Here' +event); 
	console.log(event); 
        //debugger;
	var listacampos = event.getParams();
        
        
        
        console.log('listacampos sin convertirla a string:'+ listacampos);
        console.log(" listacampos convertida a string : ", JSON.stringify(listacampos));
        var campos= JSON.stringify(listacampos);
        //debugger;
            
        console.log(" listacampos convertida a string con la variable campos:"+ campos);
        console.log(" $A.util.isEmpty(campos) ", $A.util.isEmpty(campos));
        var eventoFuente = event.getSource();
		var idEventofuente = eventoFuente.getLocalId(); 
        console.log(" Fuente del evento ", idEventofuente);
             //debugger;
        
          var spcs = /:"\s*"/gi;
        if (campos.includes(':null') ||  $A.util.isEmpty(campos) || campos.match(spcs)  )    
         {
              //debugger;
          
             listacampos["TicketCampoVacio__c"] = true;
  			component.find(idEventofuente).submit(listacampos);
  
           //debugger;
             
             console.log(" campos guardados ", JSON.stringify(listacampos));
              debugger;
             var toastEvent = $A.get("e.force:showToast"); 
        	toastEvent.setParams({duration:'4000',"title": "Hay campos que no fueron llenados","message": "Los campos que si fueron llenados, han sido guardados exitosamente, ","type": 'success'});
        	toastEvent.fire();
         }
        else
        {
            // debugger;
            
             
             listacampos["TicketCampoVacio__c"] = false;
  			component.find(idEventofuente).submit(listacampos);
        
            console.log(" campos guardados ", JSON.stringify(listacampos));
              //debugger;
            
        	var toastEvent = $A.get("e.force:showToast");
        	toastEvent.setParams({duration:'4000',"title": "Exito","message": "Todos los campos han sido guardados exitosamente, ","type": 'success'});
        	toastEvent.fire();
        }
           
               
        //console.log(" Response : ", JSON.parse(JSON.stringify(event.getParams("fields"))));
        //debbuger;
        	
	},   
    
    
    
    
    

     // llamado por aura:waiting event  
    showSpinner: function(component, event, helper) {
       // HACE EL Spinner attribute true para mostrar el icono del spinner móvil 
        component.set("v.Spinner", true); 
   },
    
 // llamado por aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // HACE EL Spinner attribute false para esconder el icono del spinner móvil
       component.set("v.Spinner", false);
    },
  
    
      
  navToRecord : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
                 
        navEvt.setParams({
            "recordId": component.get("v.caso.Id")
            
        });
       
            navEvt.fire();
    },
    
    
    
    
    
    
    
})