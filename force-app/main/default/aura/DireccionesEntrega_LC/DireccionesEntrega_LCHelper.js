({
    getDireccionesTabla : function(component, event, helper){
        var getDireccionesTabla =  component.get("c.getDireccionesTabla");
        getDireccionesTabla.setParams({ contrato2ID : component.get("v.contrato2").Id });
        getDireccionesTabla.setCallback(this, function(direccionesTabla){
            if(direccionesTabla.getState() === "SUCCESS" && direccionesTabla.getReturnValue().length > 0) {
                component.set("v.dirSeleccionadas", direccionesTabla.getReturnValue());
                helper.crearTabla(component, event, helper);
            }
        });
        $A.enqueueAction(getDireccionesTabla);
    },
    
    getDirecciones : function(component, event, helper) {
        var getDirecciones = component.get("c.getCatalogoDirecciones");
        getDirecciones.setParams({ opportunityID : component.get("v.oportunidad").Id });
        getDirecciones.setCallback(this, function(direcciones){
            if (direcciones.getState() === "SUCCESS" && direcciones.getReturnValue().length > 0) {
                component.set("v.totalDirecciones", direcciones.getReturnValue().length);
                component.set("v.catalogoDirecciones" , direcciones.getReturnValue());
                var etapaOpp = component.get("v.oportunidad").StageName;
                if(etapaOpp === 'Alta de cliente' || etapaOpp === 'Implementación' || etapaOpp === 'Ganada' || etapaOpp === 'Perdida'){
                    component.find("tablaDirecciones").set("v.hideCheckboxColumn", true);
                    component.find("picklistDirecciones").set("v.disabled",true);
                }else{
                    var mapa = new Map();
                    component.get("v.catalogoDirecciones").forEach(function(element){
                        mapa.set(element.Id, element);
                    });
                    component.get("v.dirSeleccionadas").forEach( function(element){
                        if(mapa.has(element.Id)){
                            mapa.delete(element.Id);
                        }
                    });
                    component.set("v.catalogoDirecciones", Array.from(mapa.values()));
                    component.find("btn-agregarDireccion").set("v.disabled",true);
                } 
            }
        });
        $A.enqueueAction(getDirecciones);
    },
    
    crearTabla : function(component, event, helper){
        
        component.set('v.columnas', [ {label: 'Calle',                fieldName: 'Calle_Tt__c',                type: 'text'},
                                      {label: '# Ext',                fieldName: 'NumeroExterior_Tt__c',       type: 'text'},
                                      {label: '# Int',                fieldName: 'NumeroInterior_Tt__c',       type: 'text'},
                                      {label: 'Colonia',              fieldName: 'Colonia_Tt__c',             type: 'text'}, 
                                      {label: 'CP',                   fieldName: 'CodigoPostal_Tt__c',        type: 'text'} ,
                                      {label: 'Delegación/Municipio', fieldName: 'DelegacionMunicipio_Tt__c', type: 'text'},
                                      {label: 'Ciudad',               fieldName: 'Ciudad_Tt__c',              type: 'text'},
                                      {label: 'Estado',               fieldName: 'Estado_Tt__c',              type: 'text'}
                                    ]);
    },
    
    muestraMensaje : function(component, event, helper, titulo, mensaje, tipo) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : titulo,
            message: mensaje,
            messageTemplate: 'Record {0} created! See it {1}!',
            duration:' 5000',
            key: 'info_alt',
            type: tipo,
            mode: 'pester'
        });
        toastEvent.fire();
    }
})