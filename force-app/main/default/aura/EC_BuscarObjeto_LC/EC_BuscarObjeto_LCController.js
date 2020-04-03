({
	init : function( component, event, helper ) {
		ctcLightning.config.action.query = 'c.executeQuery'
		ctcLightning.config.action.component = component
        var renderProperties = component.get("v.renderProperties").split('\,')

        console.log('instance buscar objeto: ', JSON.parse(JSON.stringify(component.get('v.instance'))))
        console.log('params: ', component.get('v.params'))
        console.log('auraAction: ', component.get('v.auraAction'))
        var icon = component.get("v.fireEvent") ? 'map' : 'user'
        // component.set('v.instance.fields.IdSelected', component.get('v.instance.fields.EntidadLegal__c.value'))

		var globalId = component.getGlobalId()
		setTimeout( function() {
			// console.log('is reference: ', globalId )
			$('[id="' + globalId + '_inputSearch"]').typeahead({
                hint: false,
                highlight: true,
                minLength: component.get("v.minLength")
              },
              {
                name: 'states',
                source: function( query, datasource, processAsync ) {

                    var getEntidadByName = component.get(component.get('v.auraAction'));
                    var params = component.get('v.params') ? JSON.parse(component.get('v.params')) : {}
                    
                    params[component.get('v.paramSearch')] = query;
                    getEntidadByName.setParams(params);

                    return ctcLightning.aura( getEntidadByName, component)
                    .then( $A.getCallback( function( res ) {
                        console.log('result records: ', res )
                        return processAsync( res.records )
                    }))
                },
                display: function( data ) {

                    var value = ''
                    renderProperties.forEach( function( property, index ) {
                        if( value.length > 0 ) {
                            value += ' '
                        } 
                        value += ctcLightning.path( property, data )
                    })
                    return value
                },
                templates: {
                    empty: [
                        'No hay resultados'
                    ],
                    pending: [
                        '  <span class="fa fa-spinner fa-pulse fa-2x fa-fw"/>Buscando...'
                    ],
                    suggestion: function( data ) {

                        var value = ''
                        renderProperties.forEach( function( property, index ) {
                            if( value.length > 0 ) {
                                value += ' '
                            } 
                            value +=  ctcLightning.path( property, data )
                        })
                        return '<div><span class="slds-icon_container slds-icon-standard-user" title="Description of icon when needed"> <svg class="slds-icon slds-icon--small" aria-hidden="true"> <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/_slds/icons/action-sprite/svg/symbols.svg#' + icon + '" /> </svg></span> ' + value + '</div>'
                    }
                },
                limit: 10
              })
		}, 500)

        $('[id="' + globalId + '_inputSearch"]').on("paste keyup", function( event ) {
            console.log("event change: ",$(this).val(), arguments); 
            if( event.key != 'Tab' ) {
                var field = component.get('v.field')
                component.set('v.instance.' + field.name, null)
                component.set('v.instance.' + field.name + '__o', null)
                component.set("v.hasError", true);
                component.set("v.messageError", "Seleccione un contacto");
            }
        });


        $('[id="' + globalId + '_inputSearch"]').bind('typeahead:autocomplete', function( ev, suggestion ) {
            console.log('typeahead:autocomplete: ', arguments)
            var field = component.get('v.field')
            var selectedProperty = ctcLightning.path( component.get("v.selectedProperty"), suggestion )
            component.set('v.instance.' + field.name, selectedProperty)
            component.set("v.hasError", false);
        })
        $('[id="' + globalId + '_inputSearch"]').bind('typeahead:select', function( ev, suggestion ) {
            console.log('select: ', arguments);
            var field = component.get('v.field')
            var selectedProperty = ctcLightning.path( component.get("v.selectedProperty"), suggestion )
            component.set('v.instance.' + field.name, selectedProperty)
            component.set('v.instance.' + field.name + '__o', suggestion)
            component.set("v.hasError", false);
            console.log('fireEvent: ', component.get("v.fireEvent"))
            if( component.get("v.fireEvent") ) {
                // $A.get("e.c:" + component.get("v.fireEvent")).fire();
                component.getEvent("Event_Selected").fire();
            }

            // console.log("instance: ", component.get("v.instance." + field.name))
        });
	},
    changeInput: function( component, event, helper ) {
        console.log("changeInput")
    }
})