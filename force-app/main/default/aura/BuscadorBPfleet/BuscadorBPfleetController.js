({
	buscarDatos : function(component, event, helper) {
        component.set("v.isLoad",true);
		var rfc=component.find("rfc").get("v.value");
        var nombreCom=component.find("nombreEmpresa").get("v.value");
        if((rfc==null||rfc=='')&&(nombreCom==null||nombreCom=='')){
            component.set("v.isLoad",false);
            helper.showToast(component,event,"error","Error!","Ingrese información para buscar");
        }else{
            if(rfc==null||rfc==''){
                rfc='';
            }
            var action=component.get("c.getDatosBuscar");
            action.setParams({rfcBuscar:rfc.replace(/\s/g, ""),nombreEmpresa:nombreCom});
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=='SUCCESS'){
                    var result=response.getReturnValue();
                    
                    var res=[];
                    for(var i=0;i<result.listaEl.length;i++){
                        var stat;
                        if(result.mapaStatus[result.listaEl[i].RFCEL__c]){
                            stat=result.mapaStatus[result.listaEl[i].RFCEL__c];
                        }else{
                            stat='El RFC existe en BPfleet';
                        }
                        res.push({"enLe":result.listaEl[i],"status":stat,"estatusInt":result.mapaStatusInt[result.listaEl[i].RFCEL__c]});
                    }
                    //console.log(JSON.stringify(res));
                    if(res==null||res.length<=0){
                        component.set("v.sinResultados",true);
                    }else{
                        component.set("v.sinResultados",false);
                    }
                    component.set("v.listaEL",res);
                    component.set("v.isLoad",false);
                }else{
                    component.set("v.isLoad",false);
                    helper.showToast(component,event,"error","Error!","Error al buscar Información");
                }
            });
            $A.enqueueAction(action);
        }
	},
    crearLead : function (component, event, helper) {
        component.set("v.isLoad",true);
        var nombreCuenta=event.getSource().get("v.name");
        var valores=nombreCuenta.split(';');
        //var rfc=component.find("rfc").get("v.value");
        var action=component.get("c.getRecordTypeBP");
        action.setParams({objeto:'Lead',nombreApi:'BPfleet'});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.isLoad",false);
                helper.crearNewLead(component,event,valores[0],valores[1],response.getReturnValue());
            }else{
                component.set("v.isLoad",false);
                helper.showToast(component,event,"error","Error!","Error al crear colaboración");
            }
        });
        $A.enqueueAction(action);
    },
    crearColaboracionCuenta : function(component,event,helper){
        component.set("v.isLoad",true);
        var setRfc=event.getSource().get("v.name");
        var action=component.get("c.crearColaboracion");
        action.setParams({rfc:setRfc});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                component.set("v.isLoad",false);
                helper.showToast(component,event,result.tipo,result.titulo,result.msj);
                setTimeout(function(){
                    if(result.idOpp){
                        window.open('/'+result.idOpp,'_blank');
                    }
                },1500);
            }else{
                component.set("v.isLoad",false);
                helper.showToast(component,event,"error","Error!","Error al crear colaboración");
            }
        });
        $A.enqueueAction(action);
    }
})