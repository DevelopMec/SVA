({
    getInfoHeader : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var secc={};
        secc.EntidadLegal={"isOpen":true,"name":"EntidadLegal"};
        secc.Filiales={"isOpen":true,"name":"Filiales"};
        component.set("v.secciones",secc);
        console.log('IDQLI::'+component.get("v.recordId"));
		var action=component.get("c.getInfoQli");
        action.setParams({idQli:component.get("v.recordId")});
        action.setCallback(this,function(response){
            console.log("return");
            var state=response.getState();
            if(state=='SUCCESS'){
                console.log(JSON.stringify(response.getReturnValue()));
                var result=response.getReturnValue();
                component.set("v.data",result);
                if(true){
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
                /*if(result.funcionesContactos!=null){
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
                helper.getInfo(component, event,'init');
            }else{
                component.set("v.showSpinner",false);
                console.log("Error");
            }
        });
        $A.enqueueAction(action);
	},
    /*getInfo : function(component, event, helper){
        component.set("v.showSpinner",true);
        var action=component.get("c.getInfoPlantilla");
        action.setParams({idQli:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                if(result.status){
                    //console.log(JSON.stringify(result));
                    component.set("v.secciones",result.seccionesList);
                    component.set("v.dependencias",result.dependencias);
                    for(var i=0;i<result.seccionesList.length;i++){
                        var dep=result.dependencias;             
                        if(dep[result.seccionesList[i].nombreSeccion]){
                            var depControl=JSON.parse(dep[result.seccionesList[i].nombreSeccion]);
                            for(var f=0;f<result.seccionesList[i].listaCampos.length;f++){                            
                                if(depControl[result.seccionesList[i].listaCampos[f].api]){
                                    helper.asignarDependencias(component,result.seccionesList[i].listaCampos[f].api,result.seccionesList[i].listaCampos[f].value,depControl,i);
                                }
                            }
                        }
                    }
                    component.set("v.showSpinner",false);
                }else{
                    alert(result.msj);
                    component.set("v.showSpinner",false);
                }
            }else{
                component.set("v.showSpinner",false);
                alert("Error al obtener plantilla");
                //this.showToast(component,event,"error","Error","Error al obtener plantilla");                
            }
        });
        $A.enqueueAction(action);
    },*/
    cambioEntidad : function(component, event, helper) {
        var enSel=event.getParam("value");
        component.set("v.data.contrato.Contacto__c",'');
        helper.cambioEL(component,event,enSel,'cambio');
    },
    handleClick: function(component, event, helper) {
       /*var nombre = event.getSource().get("v.name");
        var secc= component.get("v.secciones");
        secc[nombre].isOpen=!secc[nombre].isOpen;
        component.set("v.secciones",secc);*/
    },
    agregarFilial: function(component, event, helper) {
        var ind = event.getSource().get("v.id");
        var ch = event.getSource().get("v.checked");
        var info=component.get("v.entidadesFiliales");   
        console.log('::'+JSON.stringify(info));
        var ecDisp=component.get("v.data.ECdisp");
        if(ch){
            if(!info[ind].filial.PlatformAdministrator__c){
                //alert("Agregue Adm");
                helper.showToast(component,event,"warning","Falta información","Ingrese un contacto");
                event.getSource().set("v.checked",false);
            }else{
                if(ecDisp!=null&&ecDisp.length>0){
                    for(var i=0;i<ecDisp.length;i++){
                        if(ecDisp[i].value==info[ind].Id){
                            ecDisp.splice(i, 1);
                            break;
                        }
                    }
                    
                }   
            }            
        }else{
            info[ind].filial.PlatformAdministrator__c='';
            component.set("v.entidadesFiliales",info);
            ecDisp.push({"label":info[ind].EntidadLegal__r.RazonSocial__c,"value":info[ind].Id});
        }
        
        component.set("v.data.ECdisp",ecDisp);
    },
    seleccionarContacto : function(component, event, helper) {
        //console.log(JSON.stringify(component.get("v.data.funcionesContactos")));
    },
    guardar : function(component, event, helper){
        component.set("v.showSpinner",true);
        var operacion=event.getSource().get("v.name");
        //var datosContact=component.get("v.data.funcionesContactos");
        var datosContrato=component.get("v.data.contrato");
        
        if(operacion=='Finalizado'){
                     console.log(datosContrato['Personalizacion_de_Tarjetas__c']);
            //console.log(JSON.stringify(datosContact));
            if(datosContrato.PartidaPresupuesto__r.Quote.Opportunity.Contacto__c==null||datosContrato.PartidaPresupuesto__r.Quote.Opportunity.Contacto__c==''){
                component.set("v.showSpinner",false);
                //alert("Faltan campos obligatorios!!");                
                helper.showToast(component,event,"error","Error","Ingrese un administrador de plataforma en la Oportunidad!!");
                return;
            }
            if(datosContrato['Contacto__c']==null||datosContrato['Contacto__c']==''){
                component.set("v.showSpinner",false);
                //alert("Faltan campos obligatorios!!");                
                helper.showToast(component,event,"error","Error","Ingrese el representante Legal para la Entidad Legal Seleccionada!!");
                return;
            }
            if(datosContrato['FiscalAddress__c']==null||datosContrato['FiscalAddress__c']==''){
                component.set("v.showSpinner",false);
                //alert("Faltan campos obligatorios!!");                
                helper.showToast(component,event,"error","Error","Ingrese una dirección fiscal!!");
                return;
            }
            if(datosContrato['Entidad_Cuenta__c']==null||datosContrato['Entidad_Cuenta__c']==''){
                component.set("v.showSpinner",false);
                //alert("Faltan campos obligatorios!!");                
                helper.showToast(component,event,"error","Error","Ingrese una Entidad Legal!!");
                return;
            }
            /*for(var i=0;i<datosContact.length;i++){
                if(datosContact[i].ContactId__c==null||datosContact[i].ContactId__c==''){
                    component.set("v.showSpinner",false);
                    //alert("Faltan campos obligatorios!!");
                    helper.showToast(component,event,"error","Error","Faltan campos obligatorios!!");
                    return;                    
                }
            } */               
        }
        
        datosContrato['EtapaContrato__c']=operacion;                        
        var info=component.get("v.secciones");
        for(var i=0;i<info.length;i++){
            for(var f=0;f<info[i].listaCampos.length;f++){
                if(operacion=='Finalizado'&&info[i].listaCampos[f].tipo!='BOOLEAN'&&info[i].listaCampos[f].requerido&&!info[i].listaCampos[f].ocultar&&(info[i].listaCampos[f].value==null||info[i].listaCampos[f].value=='')){
                    component.set("v.showSpinner",false);
                    //alert("Faltan campos obligatorios!!");
                    helper.showToast(component,event,"error","Error","Faltan campos obligatorios!!");
                    return;
                }else{
                    datosContrato[info[i].listaCampos[f].api]=info[i].listaCampos[f].value;
                }
            }
        }
        //console.log("DATACON::"+JSON.stringify(datosContrato));
        if(datosContrato['Personalizacion_de_Tarjetas__c']==true){
            //console.log("validaDOC"+component.get("v.data.contrato.PartidaPresupuesto__r.Quote.OpportunityId"));
            //console.log("validaDOC"+component.get("v.data.contrato.PartidaPresupuesto__r.Product2.ProductCode"));
            var action=component.get("c.validarDocumento");
            action.setParams({idOpp:component.get("v.data.contrato.PartidaPresupuesto__r.Quote.OpportunityId"),prodCod:component.get("v.data.contrato.PartidaPresupuesto__r.Product2.ProductCode")});
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=='SUCCESS'){
                    if(!response.getReturnValue()){
                        component.set("v.showSpinner",false);
                        helper.showToast(component,event,"error","Error","Necesita adjuntar el layout de personalización de tarjetas!!");
                        return;
                    }else{
                        helper.guardarContrato(component,event,null,datosContrato,operacion);
                    }
                }else{
                    component.set("v.showSpinner",false);
                    helper.showToast(component,event,"error","Error","Error al validar documentos!!");
                    return;
                }
            });
            $A.enqueueAction(action);
        }else{
            helper.guardarContrato(component,event,null,datosContrato,operacion);
        }
        //helper.guardarContrato(component,event,datosContact,datosContrato,operacion);
    },
    handleLoad: function(cmp, event, helper) {
        console.log("load");
        cmp.set('v.showSpinner', false);
        cmp.set('v.cargo', true);
    },

    handleSubmit: function(cmp, event, helper) {
        console.log("submit");
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
    },

    handleError: function(cmp, event, helper) {
        console.log("error");
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },

    handleSuccess: function(cmp, event, helper) {
        console.log("succes");
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    },
    handleChange : function(component, event, helper) {
        console.log("cambio");
        component.set("v.showSpinner",true);
        var seccTem=event.getSource().get("v.id");
        var campoTem=event.getSource().get("v.name");
        var lisSecc=seccTem.split(";");
        var lisCamp=campoTem.split(";");
        var secc=lisSecc[0];
        var campo=lisCamp[0];
        var indSecc=lisSecc[1];
        var indCampo=lisCamp[1];
        var val;
        if(event.getSource().get("v.type")=='checkbox'){
            val=event.getSource().get("v.checked"); 
        }else{
            val=event.getSource().get("v.value");
        }
        if(campo == "Personalizacion_de_Tarjetas__c"){
            if (val == true){
                component.set("v.personalizacionDeTarjetas",true);
            }else{
                component.set("v.personalizacionDeTarjetas",false);
            }
        }
        var dep=component.get("v.dependencias");
        if(dep[secc]){
            console.log("INIT");
            var depControl=JSON.parse(dep[secc]);
            helper.asignarDependencias(component,campo,val,depControl,indSecc);

            /*if(depControl[campo]){
                if(depControl[campo].valoresAplicables){
                    if(depControl[campo].valoresAplicables.includes(val+'')){
                        if(depControl[campo].camposDependientes){
                            for(var i=0;i<depControl[campo].camposDependientes.length;i++){
                                this.asignarVisibilidad(component,depControl[campo].camposDependientes[i]);
                                if(depControl[depControl[campo].camposDependientes[i]]){
                                    this.asignarDependencias(component,campo,val,depControl);
                                }
                            }
                        }
                    }else{
                        if(depControl[campo].camposDependientes){
                            
                        }
                    }
                }
            }*/
        }else{component.set("v.showSpinner",false);}
    },
    abrirEvaluacionCredito : function(component, event, helper){
         helper.VerificaEstatusEvaluacionCredito(component, true);
        
		var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');        
    },
    cerrarEvaluacionCredito : function(component, event, helper){
		 var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');        
    },
    GuardarEvaluacionCredito : function(component, event, helper){
   		var evalcredito = component.find('evalcredito');
        if (evalcredito.GuardarEvalCredito() == true){
        }
        else{
            helper.showToast(component, event, 'warning', 'Campos Obligatorios', 'Existen campos obligatorios que deben ser completados');
        }
    },
    AprobacionEvaluacionCredito : function(component, event, helper){
   		var evalcredito = component.find('evalcredito');
        if (evalcredito.AprobarEvalCredito() == true){
            var a2 = component.get('c.cerrarEvaluacionCredito');
           $A.enqueueAction(a2);
        }
        else{
            helper.showToast(component, event, 'warning', 'Campos Obligatorios', 'Existen campos obligatorios que deben ser completados');
        }
    },
    generarPDF : function(component, event, helper){
        //component.set("v.generandoPDF",!component.get("v.generandoPDF"));
        window.open('/apex/PdfContract_VFC?id='+component.get("v.recordId"),'_blank');
        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CON_TC3PagoPorConsumo_LC",
            componentAttributes: {
                QuoteLineItem:"{!QuoteLineItem}",
                QuoteLineItemId:"{!QuoteLineItem.Id}",
                QuoteLineItemName:"{!QuoteLineItem.Product2.Name}",
                AccountId:"{!QuoteLineItem.Quote.AccountId}",
                FormaPago:"{!QuoteLineItem.FormaPago__c}"
            },
            isredirect:true
        });
        evt.fire();*/
    },
    cambioDireccion : function(component,event,helper){
        /*var idDir=event.getParam("value");
        var dir=component.get("v.direcciones");
        for(var i=0;i<dir.length;i++){
            if(dir[i].value==idDir){
                var cm=component.find("dirSel").set("v.value",dir[i].label);
                break;
            }
        }  */      
       
    },
    ingresoValor : function(component,event,helper){
        var campo=event.target.name;
        if(campo=='Sucursal_Facturacion_Global__c'||campo=='GrupoFacturacionGlobal_Text__c'||campo=='Cliente_Facturacion_Global__c'){
            var key =  event.keyCode;
            if (key < 48 || key > 57) {
                event.preventDefault();
            }
        }
    },
    sendEmail : function(component,event,helper){
        var action=component.get("c.getInfoSendEmail");
        action.setParams({idContrato : component.get("v.data.contrato.Id")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                console.log(JSON.stringify(result));
                if(!result.idTemplate){
                    helper.showToast(component,event,"warning","Falta información","No se encontro la plantilla");
                    return;
                }
                if(!result.idCont){
                    helper.showToast(component,event,"warning","Falta información","No existe contacto");
                    return;
                }
                if(!result.email){
                    helper.showToast(component,event,"warning","Falta información","No existe email en el contacto");
                    return;
                }
                if(!result.oppId){
                    helper.showToast(component,event,"warning","Falta información","No se encontró la  oportunidad");
                    return;
                }
                if(!result.pdfId){
                    helper.showToast(component,event,"warning","Falta información","No existe contrato asociado ala cotización");
                    return;
                }
                window.open('/one/one.app#/alohaRedirect/_ui/core/email/author/EmailAuthor?p2_lkid=' + result.idCont + '&p3_lkid=' + result.oppId + '&doc_id=' + result.pdfId + '&p24=' + result.email + '&template_id=' + result.idTemplate + '&saveURL=' + result.oppId,"_blank");
            }else{
                helper.showToast(component,event,"error","Error","Error al consultar parametros para email");
            }
        });
        $A.enqueueAction(action);
    }
})