({
	doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Nombre', fieldName: 'label', type: 'text'},
            {type:  'button',initialWidth: 150,typeAttributes: {label: 'Seleccionar', name: 'Seleccionar', disabled: false}}
        ]);
        
		var action=component.get("c.obtenerUsuarios");
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                var lUsuarios=[];
                for(var i=0;i<result.length;i++){
                    lUsuarios.push({"label":result[i].Name,"value":result[i].Id});
                }
                component.set("v.listaUsuarios",lUsuarios);
            }else{
                console.log("Ocurrio un error doInit");
            }
        });
        $A.enqueueAction(action);
	},
    reasignarOportunidad : function(component, event, helper) {
        console.log("Inicio reasignarOportunidad");
        component.set("v.spinner",true);
        var nuProp=component.get("v.idSeleccionado");
        var action=component.get("c.reasignarOpp");
        action.setParams({idOportunidad:component.get("v.recordId"),idNuevoPropietario:nuProp});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                if(result){    
                    component.set("v.spinner",false);
                    component.set("v.mensaje",{msj:'Se ha reasignado correctamente la oportunidad',tipo:'confirm',titulo:'Exito!'});
                    component.set("v.mostrarAlerta",true);
                    setTimeout(function(){
                        component.set("v.mostrarAlerta",false);
                        location.reload();
                    },2000);                    
                }else{
                    component.set("v.spinner",false);
                    component.set("v.mensaje",{msj:"Ha ocurrido un error",tipo:'warning',titulo:'Error!'});
                    component.set("v.mostrarAlerta",true);
                    setTimeout(function(){
                        component.set("v.mostrarAlerta",false);
                    },2000);                    
                }
            }else{
                console.log("Ocurrio un error doInit");
            }
            component.set("v.spinner",false);
        });
        $A.enqueueAction(action);
    },
    buscar : function(component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        var temBusq = component.find('enter-search').get('v.value');
        if (isEnterKey) {
            component.set('v.issearching', true);
            var listaUser=component.get("v.listaUsuarios");
            var listSec=[];
            for(var i=0;i<listaUser.length;i++){
                if((listaUser[i].label.toLowerCase()).includes(temBusq.toLowerCase())){
                    listSec.push({"label":listaUser[i].label,"value":listaUser[i].value});
                }
            }
            if(listSec.length==0){
                component.set("v.mensaje",{msj:'Sin resultados',tipo:'info',titulo:'Informacion!'});
                component.set("v.mostrarAlerta",true);
                setTimeout(function(){
                    component.set("v.mostrarAlerta",false);
                },1000); 
                component.set('v.issearching', false);
            }
            component.set('v.listaUsuariosBusqueda', listSec);
            component.set('v.issearching', false);
        }
    },
    seleccionar : function(component, event, helper) {
        var row = event.getParam('row');
        component.find("usuarioSelec").set("v.value",row.label);
        component.set("v.idSeleccionado",row.value);
        component.set("v.habilitarAsig",false);
    },
})