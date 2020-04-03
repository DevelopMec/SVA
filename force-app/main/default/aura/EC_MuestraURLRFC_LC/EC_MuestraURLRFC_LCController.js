({
	init : function(component, event, helper) {
		var recordId = component.get("v.recordId");
		var executeQuery = component.get("c.executeQuery");
		executeQuery.setParams({ query: "SELECT Id, Name FROM EntidadLegal__c WHERE Id='" + recordId +"'" });
		
		var app_ctc = component.get("v.app_ctc")
		app_ctc.instance = {}
		var codigoAs400 = '';
        
        //Se consulta la información para obtener el RFC de la entidad Legal a través del campo NAME
		ctcLightning.aura( executeQuery, component )
		.then( $A.getCallback( function( res ) {
			console.log("success executeQuery: ", res)
			if( res && res[0] && res[0].Name ) {
				app_ctc.instance.as400 = res[0].Name
				app_ctc.instance.renderUrl = true
				codigoAs400= res[0].Name
                
                //Se obtiene la URL del tipo de metadato con la finalidad de mostrarlo en pantalla
                var executeQuery = component.get("c.executeQuery");
                executeQuery.setParams({ query: "Select URL__c from URLAs400__mdt  Where DeveloperName = 'URLAS400'" });
                ctcLightning.aura( executeQuery, component )
                .then( $A.getCallback( function( res ) {
                    if( res && res[0] && res[0].URL__c ) {
                        app_ctc.instance.url =  res[0].URL__c+'&Tipo=3&Valor='+codigoAs400;
                    }
                    component.set("v.app_ctc", app_ctc)
                })).catch( $A.getCallback( function( err ) {
                    console.log("error URLCTC: ", err)
                }))
			}
			component.set("v.app_ctc", app_ctc)
		})).catch( $A.getCallback( function( err ) {
			console.log("error listaAS400: ", err)
		}))
	}
})