({ 
    getSchema: function( component ) {
    	var act = component.get('c.describeSObjects')        
        act.setParams({objs: ['PlantillaContrato__c', 'Contrato2__c']})
        return ctcLightning.aura( act, component )
	}, 
    getTemplate: function( component ) {
    	var act = component.get('c.executeQuery')
        act.setParams({query: 'SELECT Id, Name, Contenido_del__c, Activo__c, CamposAnexoE__c, Seccion1__c, Seccion2__c, Seccion3__c, Seccion4__c, Seccion5__c, Seccion6__c, AnexoA__c, AnexoB__c, AnexoC__c, AnexoD__c, AnexoE__c, CamposAnexoA__c, CamposAnexoB__c, CamposAnexoC__c, CamposAnexoD__c, Logocontrato__c FROM PlantillaContrato__c WHERE Id=\'a0m5B000001IO3wQAG\''})
       	return ctcLightning.aura( act, component )
	},
    buildForm: function( component, helper ) {
        var app = component.get('v.app_ctc')
        console.log('into buildForm: ', app.template.Seccion1__c , app.schema)
        var fieldsToRender = []
        var fieldsNotFound = []
        if( app.template && app.template.Seccion1__c ) {
            app.template.Seccion1__c.split('\;').forEach( function( fieldStr, index ) {
                if( app.schema.Contrato2__c.hasOwnProperty( fieldStr ) ) {
                    var field = app.schema.Contrato2__c[fieldStr]
                    field.object = 'Contrato2__c'
                    field.path = field.object + '.' + field.name
                    // field.required = true
                    if( index == 0 ) {
                        field.type = 'date'
                    }
                    fieldsToRender.push( field )
                } else {
                    fieldsNotFound.push( fieldStr )
                }
            })
        }
        
        app['fieldsToRender'] = fieldsToRender
        app['fieldsNotFound'] = fieldsNotFound
        
        component.set('v.app_ctc', app)
        
        
        fieldsToRender.forEach( function( field, index ) {
            helper.renderElement( field, component )
        })        
        
        console.log('fieldsToRender: ', fieldsToRender)
        console.log('fieldsNotFound: ', fieldsNotFound)
    },
    
    renderElement: function( field, component ) {

        var config = {
            string      : 'slds-input',
            picklist    : 'slds-select',
        }

        var appContainer = component.find('appContainer')
        // field.input = 'lightning:textarea'
        field.input = 'ui:inputText'
        if( field.type == 'picklist' ) {
            // field.input = 'lightning:select'
            field.input = 'ui:inputSelect'
            field.values = field.values || []
            field.values.sort( function( item_a, item_b ) {
                return item_a.label > item_b.label
            })
        } else if( field.type == 'date' ) {
            field.input = 'ui:inputDate'
        }
        /*$A.createComponent( 'aura:attribute', {
            type: 'string',
            name: 'esunaprueba'
        }, function( element, status, err ) {

                console.log('esunaprueba: ', arguments)
                
                var objectToAttributes = component.get('v.objectToAttributes')
                objectToAttributes.push(element)
                component.set('v.objectToAttributes', objectToAttributes)
        })*/

        $A.createComponent( field.input, {
            	'aura:id'	: field.name,
                'label'		: field.label,
	            'required'	: field.required,
                'onfocus'	: component.getReference('c.handlePress'),
            	'class'     : config[field.type],
                'disabled'  : field.disabled,
                'displayDatePicker': true
            }, function( newElement, status, errorMessage ) {
                if ( status === 'SUCCESS' ) {
                    field.globalId = newElement.getGlobalId()
                    var body = component.get('v.bodyRender')

                    body.push(newElement)
                    component.set('v.bodyRender', body)

                    var objectToRender = component.get('v.objectToRender')
                    //var objectToRender = component.get('v.objectToRender')
                    objectToRender[field.name] = {schema: field, element: []}

                    component.set('v.objectToRender', objectToRender)

                    //objectToRender[field.name].element.push(newElement)
                    component.set('v.objectToRender.' + field.name, newElement)

                    console.log('leer: ', component.get('v.bodyRender.' + field.name))

                    //console.log('objectToRender: ', objectToRender, '\nkeys: ', Object.keys(objectToRender), '\nelement: ', objectToRender[field.name].element, '\ntype bodyRender: ', typeof body, '\ntype objectToRender[field.name]: ', typeof objectToRender[field.name].element, '\nelement body: ', body )
                    
                    if( field.type == 'picklist' || field.type == 'multipicklist' ) {

                        field.values.unshift({label: '--Ninguno--', value: '', selected: true})
                        
                        //console.log(field.name + ': was rendered', newElement )
                    	component.find( field.name ).set('v.options', field.values)

                    } else if( field.type == 'date' ) {

                    }
                    
                } else if ( status === 'INCOMPLETE' ) {
                    console.log('No response from server or client is offline.')
                } else if (status === 'ERROR' ) {
                    console.log('Error: ', errorMessage)
                }
            }
        )
    }
})