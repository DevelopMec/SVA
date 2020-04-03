({
	getInfoHeader : function(component, event, helper) {        
        component.set("v.showSpinner",true);
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.idQli;
            // add your code here
        }
        var secc={};
        //secc.EntidadLegal={"isOpen":true,"name":"EntidadLegal"};
        //secc.Filiales={"isOpen":true,"name":"Filiales"};
        //component.set("v.secciones",secc);
        console.log('IDQLI::'+param1);
		var action=component.get("c.getInfoQli");
        action.setParams({idQli:param1});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                //console.log(JSON.stringify(response.getReturnValue()));
                var result=response.getReturnValue();
                component.set("v.data",result);
               /* if(true){
                    component.set("v.representantes",result.representantes[result.contrato.Entidad_Cuenta__c]);
                    component.set("v.entidadSel",result.mapaEC[result.contrato.Entidad_Cuenta__c]);
                    var tem='';
                    if(result.mapaEC[result.contrato.Entidad_Cuenta__c]){
                        tem=result.mapaEC[result.contrato.Entidad_Cuenta__c].Id;
                    }else{
                        tem='';
                    }
                    helper.cambioEL(component,event,tem,'init');
                }
                if(result.direcciones!=null){
                    var listDirecciones=[];
                    for(var i=0;i<result.direcciones.length;i++){
                        var dir=result.direcciones[i].Calle_Tt__c+' '+result.direcciones[i].NumeroExterior_Tt__c+' '+result.direcciones[i].NumeroInterior_Tt__c +' '+result.direcciones[i].Colonia_Tt__c+' '+result.direcciones[i].DelegacionMunicipio_Tt__c+' '+result.direcciones[i].Estado_Tt__c+' C.P '+result.direcciones[i].CodigoPostal_Tt__c ;
						listDirecciones.push({"label":dir.replace("undefined",""),"value":result.direcciones[i].Id});
                    }
                    component.set("v.direcciones",listDirecciones);
                    component.set("v.showSpinner",false);
                }
                if(result.funcionesContactos!=null){
                    var contacFunction=[];
                    for(var i=0;i<result.funcionesContactos.length;i++){
                        var conId;
                        var IdCr;
                        if(result.contactosGuardados[result.funcionesContactos[i]]){
                            conId=result.contactosGuardados[result.funcionesContactos[i]].ContactId__c;
                            IdCr=result.contactosGuardados[result.funcionesContactos[i]].Id;
                        }else{
                            conId=null;
                            IdCr=null;
                        }
                        contacFunction.push({"Role__c":result.funcionesContactos[i],"ContactId__c":conId,"OpportunityId__c":result.headerData.Quote.OpportunityId,"Id":IdCr});
                    }
                    component.set("v.data.funcionesContactos",contacFunction);
                    component.set("v.showSpinner",false);
                }*/
                helper.getInfo(component, event);
            }else{
                component.set("v.showSpinner",false);
                console.log("Error");
                var cmpEvent = component.getEvent("hideSpin");
                cmpEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})