({
    init : function( component, event, helper ) {

        //console.log('kendo: ', kendo)
        var app = component.get('v.app_ctc')
        var contrato = component.get('v.contrato')
        
        helper.getSchema( component )
        .then( $A.getCallback( function( res ) {
            ctcLightning.schema( res )
            app['schema'] = res || {}
            return helper.getTemplate( component )
        }))
        .then( $A.getCallback( function( res ) {
            app['template'] = res && res.length > 0 ? res[0] : {}
            component.set('v.app_ctc', app)
            helper.buildForm( component, helper )
        })).catch( function( err ) {
            
            console.log('error: ', err)
            // $A.util.sanitizeHtml('<a href="https://www.google.com">hola</a>')
            ctcLightning.message( 'Ocurrió \n un error<a href="https://google.com">hola</a>'  )
            
        })
    }, 
    

    handlePress : function( component, event, helper ) {
        var el = component.find("appContainer").getElement()

        // Find the button by the aura:id value
        var name = '' // event.getElement().name
        console.log("Event: ", event, 
                    '\n name: ', name, 
                    '\n value  : ', event.getSource().get('v.class'), 
                    '\n getSource : ', event.getSource(), 
                    '\n resume  : ', event.resume(), 
                    '\n getName  : ', event.getName(), 
                    '\n kendo  : ', el, 
                    '\n getParams --  : ', Object.keys(event.getParams())
                   )
        //console.log("button pressed", event, component, event.getSource().getName())
    }
})