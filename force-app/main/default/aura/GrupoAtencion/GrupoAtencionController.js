({
    siguiente : function (component,event,helper){
        console.log('entrando al controller escalarCaso');
        var caso = component.get('v.recordId');
        //console.log("Create expense: " + JSON.stringify(caso));
        helper.escalarCaso(component,caso);
    },
    anterior : function (component,event,helper){
        console.log('entrando al controller escalarCaso');
        var casoId = component.get('v.recordId');
        var coment = component.get('v.Comentarios');
        
        //helper.rechazarCaso(component,casoId,coment);
        var textareaField = component.find("textArea");
        var value = textareaField.get('v.value');

        var validity = component.find("textArea").get("v.validity");
        console.log(validity.valid);
        if(validity.valid){
            console.log("Sin errores");
            helper.rechazarCaso(component,casoId,coment);
        }else{
            console.log("Error");
            textareaField.showHelpMessageIfInvalid();

        }    


    },
    openModal : function(component, event, helper) {
        var modal = component.find("casoModal");
        var modalBackdrop = component.find("casoModalBackdrop");
        $A.util.addClass(modal,'slds-fade-in-open');
        $A.util.addClass(modalBackdrop,'slds-backdrop_open');
    },
    closeModal : function(component){
        var modal = component.find("casoModal");
        var modalBackdrop = component.find("casoModalBackdrop");
        $A.util.removeClass(modal,'slds-fade-in-open');
        $A.util.removeClass(modalBackdrop,'slds-backdrop_open');
    },
})