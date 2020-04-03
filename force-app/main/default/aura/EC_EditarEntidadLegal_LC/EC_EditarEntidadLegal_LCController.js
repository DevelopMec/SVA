({
    init : function( component, event, helper ) {
        var btns = document.getElementsByClassName("forceActionButton")

        //console.log("btns: ", btns)
        for( var btn of btns ) {
            btn.addEventListener('click', function() {
                console.log('click')
            })
            //console.log("btn: ", btn)
        }

        document.onclick = function( event ) {
            event = event || window.event; // IE specials
            var target = event.target || event.srcElement; // IE specials
            while( target !== null && target.nodeName !== "SPAN") {
                target = target.parentNode;
            }

            if( target ) {
                var str = target.innerHTML
                if( str == 'Guardar' || str == 'Guardar y nuevo') {
                    var titles = document.getElementsByClassName("slds-text-heading--medium")
                    setTimeout( function() {
                        var isInEl = false
                        
                        for( var title of titles ) {
                            if( !isInEl ) {
                                isInEl = (title.innerHTML.toLowerCase().indexOf("entidad legal") != -1 || title.innerHTML.toLowerCase().indexOf("modificar el") != -1)
                            }
                        }
                        if( isInEl ) {
                            $A.get("e.force:refreshView").fire();
                        }
                    }, 1000)
                }
            }
        };
    },

	addEntidadLegal : function( component, event, helper ) {
        var recordId = component.get("v.recordId")
        
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "Entidades_Legales__r",
            "parentRecordId": recordId
        });
        relatedListEvent.fire();
    }
})