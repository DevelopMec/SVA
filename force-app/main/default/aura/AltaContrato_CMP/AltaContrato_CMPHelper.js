({
    getInfo : function(component, event,origen){
        console.log("getInfo");
        component.set("v.showSpinner",true);
        var action=component.get("c.getInfoPlantilla");
        action.setParams({idQli:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                console.log("return getInfo");
                var result=response.getReturnValue();
                if(result.status){
                    //console.log(JSON.stringify(result));
                    component.set("v.secciones",result.seccionesList);
                    component.set("v.advInfo",result.adv);
                    component.set("v.dependencias",result.dependencias);
                    component.set('v.bankAccSel',result.adv.Bank_Account__c);
                    for(var i=0;i<result.seccionesList.length;i++){
                        var dep=result.dependencias;             
                        if(dep[result.seccionesList[i].nombreSeccion]){
                            var depControl=JSON.parse(dep[result.seccionesList[i].nombreSeccion]);
                            for(var f=0;f<result.seccionesList[i].listaCampos.length;f++){                            
                                if(depControl[result.seccionesList[i].listaCampos[f].api]){
                                    this.asignarDependencias(component,result.seccionesList[i].listaCampos[f].api,result.seccionesList[i].listaCampos[f].value,depControl,i,origen,result.adv);
                                }
                            }
                        }
                    }
                    
                    if (result.adv!=null&&result.adv.Personalizacion_de_Tarjetas__c == true){
                        //console.log("true");
                        component.set("v.personalizacionDeTarjetas",true);
                    }else{
                        //console.log("flse");
                        component.set("v.personalizacionDeTarjetas",false);
                    }
                    component.set("v.showSpinner",false);
                }else{
                    component.set("v.showSpinner",false);
                    this.showToast(component,event,"error","Error",result.msj);               
                }
            }else{
                component.set("v.showSpinner",false);
                this.showToast(component,event,"error","Error","Error al obtener plantilla");
            }
        });
        $A.enqueueAction(action);
    },
    cambioEL : function(component, event, enSel,origen) {
        console.log("cambioE");
        var datos=component.get("v.data");
        component.set("v.entidadSel",datos.mapaEC[enSel]);
        component.set("v.representantes",datos.representantes[enSel]);        
        var listEl=[];
        var listEcDisp=[];
        var fil={};
        var tamElList=datos.entidadesCuenta.length;
        for(var i=0;i<tamElList;i++){
            console.log("cambioEL"+i);
            if(datos.entidadesCuenta[i].value!=enSel){
                fil={};
                if(datos.filiales[datos.entidadesCuenta[i].value]){
                    fil=datos.mapaEC[datos.entidadesCuenta[i].value];
                    fil.filial=datos.filiales[datos.entidadesCuenta[i].value];
                    if(origen=='init'){
                        fil.check=true;
                    }
                }else{
                    fil=datos.mapaEC[datos.entidadesCuenta[i].value];
                    if(datos.headerData.Product2.IsAffiliate__c){
                        fil.filial={"AccountEntity__c":fil.Id};
                    }else{
                        fil.filial={"Entidad_Cuenta__c":fil.Id};
                    }
                    if(origen=='init'){
                        fil.check=false;
                    }
                    listEcDisp.push(datos.entidadesCuenta[i]);
                }
                listEl.push(fil);
            }else{
                listEcDisp.push(datos.entidadesCuenta[i]);
            }
            
        }
        component.set("v.entidadesFiliales",listEl);
        component.set("v.data.ECdisp",listEcDisp);
        
        console.log("cambioELFIN");
        component.set("v.showSpinner",false);
        //console.log("del::"+JSON.stringify(listEcDisp));
    },
    agregarFiliales : function(component,idEL) {
        var filiales=component.get("v.filialesAdd");
        if(filiales!=null){
            filiales.push(idEL);
            component.set("v.filialesAdd",filiales);
        }else{
            var fil=[];
            fil.push(idEL);
            component.set("v.filialesAdd",fil);
        }        
        //console.log("add::");
        //console.log("add::"+JSON.stringify(component.get("v.entidadesFiliales")));
    },
    eliminarFiliales : function(component,idEL) {
        var filiales=component.get("v.filialesAdd");
        var tem=[];
        for(var fil in filiales){
            if(fil!=idEL){
                tem.push(fil);
            }
        }
        if(tem!=null&&tem!=0){
            component.set("v.filialesAdd",tem);
        }else{
            component.set("v.filialesAdd",null);
        }
        //console.log("del::"+JSON.stringify(component.get("v.filialesAdd")));
    },
    guardarContrato : function(component, event, datosContrato, operacion, establecimientos){
        //Inicio SIGLO
        let sendToSIGLO = component.get("v.data.headerData.Product2.SendToSIGLO__c");
        let entidadLegal = null;
        let errorMessage = null;
        var fil=component.get("v.entidadesFiliales");
        if (sendToSIGLO) {
            entidadLegal = component.get("v.entidadSel.EntidadLegal__r");
            if (entidadLegal.AccountNumber__c == undefined || entidadLegal.KeyNumber__c == undefined || entidadLegal.Geolocation__c == undefined) {
                errorMessage = 'Favor de llenar todos los campos obligatorios en la sección Entidad Legal.';
            } else if ((entidadLegal.PersonType__c == 'Persona Moral - Mexicana' || entidadLegal.PersonType__c == 'Persona Moral - Extranjera') && (entidadLegal.DeedDate__c == undefined || entidadLegal.EconomicActivity__r == undefined || entidadLegal.EconomicActivity__r.Id == undefined )) {
                errorMessage = 'Favor de llenar todos los campos obligatorios en la sección Entidad Legal.';
            } else if (entidadLegal.PersonType__c == 'Persona Moral - Mexicana' && (entidadLegal.FEA__c == undefined || entidadLegal.DeedNumber__c == undefined)) {
                errorMessage = 'Favor de llenar todos los campos obligatorios en la sección Entidad Legal.';
            } else if (fil != undefined && fil.length > 0) {
                var incorrectFiliales = fil.filter(function(filial) {
                    return filial.EntidadLegal__r.PersonType__c != entidadLegal.PersonType__c && filial.check == true;
                });
                if (incorrectFiliales != undefined && incorrectFiliales.length > 0) {
                	errorMessage = 'La entidad legal filial deberá tener el mismo tipo de persona y nacionalidad que la entidad principal.';
                }
            }
        }
        if (errorMessage != null) {
            this.showToast(component,event,"error","Error", errorMessage);
            component.set("v.showSpinner",false);
        } else {
        //Fin SIGLO
            
            //var fil=component.get("v.entidadesFiliales");
            //console.log(":::"+JSON.stringify(fil));
            var lisF=[];
            if(fil!=null&&fil.length>0){
                for(var i=0;i<fil.length;i++){
                    if(fil[i].check){
                        lisF.push(fil[i].filial);//({"Entidad_Cuenta__c":fil[i].Id,"PlatformAdministrator__c":fil[i].PlatformAdministrator__c});
                    } 
                }
            }
            //console.log("GUARDACONTR: "+JSON.stringify(lisF));
            var action=component.get("c.guardarInfo");
            action.setParams({ contrato:datosContrato,
                              filiales:JSON.stringify(lisF),
                              establishments:establecimientos,
                              esAfiliado : component.get("v.data.headerData.Product2.IsAffiliate__c"),
                              //SIGLO
                              entidadLegal : entidadLegal
                              //SIGLO
                             });
            action.setCallback(this,function(response){
                //console.log(state);
                var state=response.getState();
                if(state=='SUCCESS'){
                    var result=response.getReturnValue();
                    if(result=='exito'){
                        component.set("v.showSpinner",false);
                        if(operacion=='En proceso'){
                            //alert("Información guardada correctamente");
                            this.showToast(component,event,"success","Exito","Información guardada correctamente");
                            $A.get('e.force:refreshView').fire();
                        }else if(operacion=='Finalizado'){
                            //alert("Contrato Finalizado!");
                            this.showToast(component,event,"success","Exito","Contrato Finalizado");
                            $A.get('e.force:refreshView').fire();
                        }else{
                            //aler("SIN OPERACIÓN");
                            this.showToast(component,event,"error","Error","SIN OPERACIÓN");
                        }
                        
                    }else{
                        component.set("v.showSpinner",false);
                        //alert(result);
                        this.showToast(component,event,"error","Error",result);
                    }
                }else{
                    component.set("v.showSpinner",false);
                    //alert("Error al guardar");
                    this.showToast(component,event,"error","Error","Error al guardar");
                }
            });
            $A.enqueueAction(action);
        }
    },
    showToast : function(component, event, tipo,titulo,msj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : tipo,
            "title": titulo,
            "message": msj
        });
        toastEvent.fire();
    },
    asignarDependencias : function(component,campo,val,depControl,indSecc,origen,advInfo){
        //console.log("asigDEP");
        if(depControl[campo]){
            if(depControl[campo][val+'']){
                var listCampTot=[];
                if(depControl[campo].camposDependientesOcultar){
                    listCampTot=depControl[campo].camposDependientesOcultar;
                }
                
                for(var i=0;i<depControl[campo][val+''].length;i++){
                    var index = listCampTot.indexOf(depControl[campo][val+''][i]);
                    //console.log("index:"+index);
                    if (index > -1) {
                        listCampTot.splice(index, 1);
                    }
                    this.asignarVisibilidad(component,indSecc,depControl[campo][val+''][i],'mostrar',origen,advInfo);
                }
                
                for(var i=0;i<listCampTot.length;i++){
                    this.asignarVisibilidad(component,indSecc,listCampTot[i],'ocultar',origen,advInfo);
                }
                this.restricciones(component,campo,val,indSecc,origen,advInfo);
                //component.set("v.showSpinner",false);
            }else{
                if(depControl[campo].camposDependientesOcultar){
                    for(var i=0;i<depControl[campo].camposDependientesOcultar.length;i++){
                        this.asignarVisibilidad(component,indSecc,depControl[campo].camposDependientesOcultar[i],'ocultar',origen,advInfo);
                    }
                }
                this.restricciones(component,campo,val,indSecc,origen,advInfo);
                //component.set("v.showSpinner",false);
            }            
            
            //Credito comentado, no se libera.
            /*if (campo == "TipoPago__c"){
                if (val == "Pospago"){
                    component.set("v.isCreditEvaluationButtonVisible", true);
                    this.VerificaEstatusEvaluacionCredito(component,false);
                }
                else{
                    component.set("v.isFinishButtonDisabled", false);
                    component.set("v.isCreditEvaluationButtonVisible", false);
                }
            }*/
        }else{
            component.set("v.showSpinner",false);
        } 
    },
    restricciones : function(component,campo,val,indSecc,origen,advInfo) {
        //CEAM:3375 >>>
        var fields = {};
        var depFields = {};
        var data=component.get("v.data.headerData");
        var modalidadPago = data.PaymentMethod__c ? data.PaymentMethod__c : null;
        
        depFields={ "Modo_Transaccion__c": { "Virtual": [ { "campo": "Maneja_Conductores__c", "value": true, "disabled": true } ], "Fisico": [ { "campo": "Maneja_Conductores__c", "value": false, "disabled": false } ] }, "TipoPago__c": { "Prepago": [ { "campo": "CondicionesPagoPlazo__c", "value": "0", "disabled": true },{ "campo": "Facturacion_Cargos_Prepago__c", "value": "Separado del Consumo", "disabled": true } ],"Pospago": [ { "campo": "CondicionesPagoPlazo__c", "value": "0", "disabled": false } ] } };
        //console.log('Object.keys(fields).length: ',Object.keys(fields).length);
        //console.log('ORIGEN: ',origen);

        // MODALIDAD DE PAGO:
        if(modalidadPago && Object.keys(fields).length < 1 && origen == 'init') {
            //ContractingItem__c, PaymentMethod__c, OperatingLine__c, ReleasePeriod__c, WarrantyValue__c, CreditDays__c
            var lineaOperativa = data.OperatingLine__c ? data.OperatingLine__c : null;
            var frecuenciaLiberacionAutomatica = data.ReleasePeriod__c ? data.ReleasePeriod__c : null;
            var montoGarantia = data.WarrantyValue__c ? data.WarrantyValue__c : null;
            var condicionesPagoPlazo = data.CreditDays__c ? data.CreditDays__c : null;
            var itemContratacion = data.ContractingItem__c ? data.ContractingItem__c : null;
            //console.log('MODALIDADPAGO: ',modalidadPago);
            var disable = modalidadPago ? true : false;
            var itemContratacionPrepago = modalidadPago == 'Prepago' ? false : true;

            if(depFields.TipoPago__c.Pospago.length > 0) {
                for(var i=0;i<depFields.TipoPago__c.Pospago.length;i++){
                    if(!depFields.TipoPago__c.Pospago[i].campo == 'Linea_Operativa__c' && !depFields.TipoPago__c.Pospago[i].value){
                        depFields.TipoPago__c.Pospago.push({campo:"Linea_Operativa__c", "value": lineaOperativa, "disabled": disable});
                    } else {
                        depFields.TipoPago__c.Pospago[i].value = lineaOperativa
                    }
                    if(!depFields.TipoPago__c.Pospago[i].campo == 'Frecuencia_Liberacion_Automatica__c' && !depFields.TipoPago__c.Pospago[i].value){
                        depFields.TipoPago__c.Pospago.push({campo:"Frecuencia_Liberacion_Automatica__c", "value": frecuenciaLiberacionAutomatica, "disabled": disable});
                    } else {
                        depFields.TipoPago__c.Pospago[i].value = frecuenciaLiberacionAutomatica;
                    }
                    if(!depFields.TipoPago__c.Pospago[i].campo == 'MontoGarantia__c' && !depFields.TipoPago__c.Pospago[i].value){
                        depFields.TipoPago__c.Pospago.push({campo:"MontoGarantia__c", "value": montoGarantia, "disabled": disable});
                    } else {
                        depFields.TipoPago__c.Pospago[i].value = montoGarantia;
                    }
                    if(!depFields.TipoPago__c.Pospago[i].campo == 'CondicionesPagoPlazo__c' && !depFields.TipoPago__c.Pospago[i].value){
                        depFields.TipoPago__c.Pospago.push({campo:"CondicionesPagoPlazo__c", "value": condicionesPagoPlazo, "disabled": disable});
                    } else {
                        depFields.TipoPago__c.Pospago[i].value = condicionesPagoPlazo;
                    }
                }
            }

            //depFields.TipoPago__c.Pospago.push({campo:"Linea_Operativa__c", "value": lineaOperativa, "disabled": disable});
            //depFields.TipoPago__c.Pospago.push({campo:"Frecuencia_Liberacion_Automatica__c", "value": frecuenciaLiberacionAutomatica, "disabled": disable});
            //depFields.TipoPago__c.Pospago.push({campo:"MontoGarantia__c", "value": montoGarantia, "disabled": disable});
            //depFields.TipoPago__c.Pospago.push({campo:"CondicionesPagoPlazo__c", "value": condicionesPagoPlazo, "disabled": disable});

            fields = {"TipoPago__c": {"value": modalidadPago, "disabled": disable},"Item_Contratacion__c" : {"value": itemContratacion, "disabled": itemContratacionPrepago}};
            origen = null;
        }
        if (fields[campo]) {
            var info = component.get("v.secciones");
            for (var i = 0; i < Object.keys(fields).length; i++) {
                var indiceF = -1;
                for (var f = 0; f < info[indSecc].listaCampos.length; f++) {
                    if (info[indSecc].listaCampos[f].api == Object.keys(fields)[i]) {
                        indiceF = f;
                        break;
                    }
                }
                if (indiceF != -1) {
                    info[indSecc].listaCampos[indiceF].deshabilitado = fields[campo].disabled;
                    if (origen == 'init') {
                        info[indSecc].listaCampos[indiceF].value=advInfo[Object.keys(fields)[i]];
                    } else {
                        info[indSecc].listaCampos[indiceF].value = fields[campo].value;
                    }
                }
            }
            component.set("v.showSpinner", false);
        } 
        //CEAM:3375 <<<
        
        //var depFields={ "Modo_Transaccion__c": { "Virtual": [ { "campo": "Maneja_Conductores__c", "value": true, "disabled": true } ], "Fisico": [ { "campo": "Maneja_Conductores__c", "value": false, "disabled": false } ] }, "TipoPago__c": { "Prepago": [ { "campo": "CondicionesPagoPlazo__c", "value": "0", "disabled": true },{ "campo": "Facturacion_Cargos_Prepago__c", "value": "Separado del Consumo", "disabled": true } ],"Pospago": [ { "campo": "CondicionesPagoPlazo__c", "value": "0", "disabled": false } ] } };
        if(depFields[campo] ){
            var info=component.get("v.secciones");
            if(depFields[campo][val+'']){
                //console.log(depFields[campo][val+'']);
                for(var i=0;i<depFields[campo][val+''].length;i++){
                    var indiceF=-1;
                    for (var f=0; f<info[indSecc].listaCampos.length; f++) {
                        if ( info[indSecc].listaCampos[f].api ==  depFields[campo][val+''][i].campo) {
                            indiceF = f;
                            break;
                        }
                    }
                    //console.log(info[indSecc].listaCampos[indiceF]);
                    if(indiceF!=-1){
                        info[indSecc].listaCampos[indiceF].deshabilitado=depFields[campo][val+''][i].disabled;
                        if(origen=='init'){
                            info[indSecc].listaCampos[indiceF].value=advInfo[depFields[campo][val+''][i].campo];
                        }else{
                            info[indSecc].listaCampos[indiceF].value=depFields[campo][val+''][i].value;
                        }
                    }
                    //console.log(info[indSecc].listaCampos[indiceF]);
                }
                component.set("v.showSpinner",false);
            }else{
                component.set("v.showSpinner",false);
            }
            component.set("v.secciones",info);
        }else{
            component.set("v.showSpinner",false);
        }
    },
    asignarVisibilidad : function(component,indSecc,campo,accion,origen,advInfo){        
        var info=component.get("v.secciones");
        for(var i=0;i<info[indSecc].listaCampos.length;i++){
            if(info[indSecc].listaCampos[i].api==campo){
                if(accion=='ocultar'){
                    info[indSecc].listaCampos[i].ocultar=true;
                    info[indSecc].listaCampos[i].value=null;
                    info[indSecc].sizeSecc=info[indSecc].sizeSecc-1;
                    /*if(info[indSecc].listaCampos[i].api=='NombreEmpresaPrincipal_Text__c'){
                        component.set("v.grupoPrimeVisible",false);
                    }*/
                }else if(accion=='mostrar'){
                    if(info[indSecc].listaCampos[i].api=='PrimeGroupName__c'&&component.get("v.grupoPrimeNoConsultados")){
                        //console.log("INICIO");
                        component.set("v.showSpinnerPrime",true);
                        var action=component.get("c.getGruposPrime");
                        var grupo=component.get("v.data.contrato.PartidaPresupuesto__r.Quote.Opportunity.Account.CodigoClienteAS400__c");
                        var producto=component.get("v.data.contrato.PartidaPresupuesto__r.Product2.ProductCode");
                        if(grupo==null||grupo==''){
                            component.set("v.showSpinnerPrime",false);
                            this.showToast(component,event,"error","Error","No existe grupo en la cuenta para consultar los grupos");
                            return;
                        }
                        if(producto==null||producto==''){
                            component.set("v.showSpinnerPrime",false);
                            this.showToast(component,event,"error","Error","El producto no cuenta con código");
                            return;
                        }
                        action.setParams({codigoProducto : producto,grupoNum : grupo});
                        action.setCallback(this,function(response){
                            var state=response.getState();
                            if(state=='SUCCESS'){
                                //console.log("FIN:"+JSON.stringify(info));
                                component.set("v.secciones["+indSecc+'].listaCampos['+i+'].listaValores',response.getReturnValue());
                                //component.set("v.listGrupos",response.getReturnValue());
                                //component.set("v.grupoPrimeVisible",true); 
                                component.set("v.grupoPrimeNoConsultados",false);                               
                                component.set("v.showSpinnerPrime",false);
                            }else{
                                component.set("v.showSpinnerPrime",false);
                                this.showToast(component,event,"error","Error","Error al consultar grupos prime");  
                            }
                        });
                        $A.enqueueAction(action);
                    }
                    info[indSecc].listaCampos[i].ocultar=false;
                    info[indSecc].sizeSecc=info[indSecc].sizeSecc+1;
                    if(origen=='init'){                        
                        info[indSecc].listaCampos[i].value=advInfo[info[indSecc].listaCampos[i].api];
                    }
                }         
                break;
            }
        }
        component.set("v.secciones",info);
    },
    
    VerificaEstatusEvaluacionCredito: function (component, abreventana){
        var action=component.get("c.VerificaEstatusEvaluacionCredito");
        action.setParams({idOpp:component.get("v.data.IdOpp")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                var status = result.StatusCreditEval;
                if (status == 'En Proceso'){
                    component.set("v.StatusCreditEval_InProcess",true);
                }
                
                if (status == 'Si'){
                    component.set("v.StatusCreditEval_InProcess",false);
                    component.set("v.StatusCreditEval_Approved",true); 
                }
                else{
                    component.set("v.isFinishButtonDisabled", true);
                }
                
                if (status != 'En Proceso' && status!= 'Si' && !abreventana){
                    this.showToast(component, event, 'warning', 'Tipo de Pago Pospago - Datos Obligatorios', 'Favor de llenar con los datos y documentos necesarios el análisis del pedido');
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    setCheckedEstablishments : function(component, establecimientosGuardados) {
        let allEstablishments = component.find("establishmentId");
        if(Array.isArray(allEstablishments)) {
            allEstablishments.forEach(function(value){
                if(establecimientosGuardados.includes(value.get("v.name"))){
                    value.set("v.checked",true);
                }             
            });
        } else {
            if(establecimientosGuardados.includes(allEstablishments.get("v.name"))){
                allEstablishments.set("v.checked",true);
            }   
        }
    },
    getCheckedEstablishments : function(component,event,helper) {
        let establishments = component.find("establishmentId");
        let selectedEstablishments = [];
        if(establishments){
            if(Array.isArray(establishments)) {
                selectedEstablishments = establishments.filter((value) => value.get("v.checked") == true).map(filteredValue => filteredValue.get("v.name"));
            } else {
                selectedEstablishments = establishments.get("v.checked") == true ? establishments.get("v.name") : [];
            }
        }
        return selectedEstablishments;
    }
    
})