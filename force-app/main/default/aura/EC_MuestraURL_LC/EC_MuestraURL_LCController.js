({
	init : function(component, event, helper) {
		var recordId = component.get("v.recordId");
		var executeQuery = component.get("c.executeQuery");
        
        var codigoAs400 = '';
        
		executeQuery.setParams({ query: "SELECT Id, Codigo_AS400__c FROM WorkOrder WHERE Id='" + recordId +"'" });
		
		var app_ctc = component.get("v.app_ctc")
		app_ctc.instance = {}

		ctcLightning.aura( executeQuery, component )
		.then( $A.getCallback( function( res ) {
			if( res && res[0] && res[0].Codigo_AS400__c ) {
				//app_ctc.instance.url = 'https://www.reforma.com?tipo=' + res[0].Codigo_AS400__c
				codigoAs400=res[0].Codigo_AS400__c
				app_ctc.instance.as400 = res[0].Codigo_AS400__c
				app_ctc.instance.renderUrl = true
                
                var executeQuery = component.get("c.executeQuery");
                executeQuery.setParams({ query: "Select URL__c from URLAs400__mdt  Where DeveloperName = 'URLAS400'" });
                ctcLightning.aura( executeQuery, component )
                .then( $A.getCallback( function( res ) {
                    if( res && res[0] && res[0].URL__c ) {
                        app_ctc.instance.url =  res[0].URL__c+'&Tipo=4&Valor='+codigoAs400;
                    }
                    console.log(app_ctc);
                    component.set("v.app_ctc", app_ctc)
                })).catch( $A.getCallback( function( err ) {
                    console.log("error URLCTC: ", err)
                }))
			}
		})).catch( $A.getCallback( function( err ) {
			console.log("error listaAS400: ", err)
		}))
	}
})