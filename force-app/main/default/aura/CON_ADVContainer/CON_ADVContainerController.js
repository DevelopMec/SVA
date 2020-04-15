({
    hideSpinGlobal : function(component,event,helper){
        console.log("EVENT");
        component.set("v.loadingPage",false);
    },
    clickTest : function(component, event, helper){
        alert('nam');
        var nam=event.getSource().get("v.name");
        alert('-'+nam);
    },
   init : function(component, event, helper) {
    helper.getMotivosRechazo(component,event);
    console.log('init : ', ctcLightning);
      
       var contratoId = component.get("v.recordId");
       $A.createComponent("c:DireccionesEntrega_LC", {
           "aura:id" : "recordId",
           "recordId" : contratoId
       }, function(newCmp,status,errorMessage) {
           if (component.isValid()) {
               if(status == "ERROR") {
                   console.log('Error Message--',errorMessage);
               }
               component.set("v.dirEntregaCMP", newCmp);
           }
       });
      var describeSObjects = component.get('c.describeSObjects')
      describeSObjects.setParams({ objs: ['TiposDocumento__c']})
      ctcLightning.aura( describeSObjects, component )
      .then( $A.getCallback( function( res ) {
        component.set('v.app_edenred.schema', res); 

        var executeQuery = component.get("c.executeQuery");
        executeQuery.setParams({query: "SELECT Id, Name, ActaConstitutivaCliente__c, AdjuntoA__c, AltaSHCP__c, CURP__c, CedulaRFC__c, ComprobanteDomicilioCliente__c, ComprobanteDomicilioFiscal__c, ConstanciaRFCCliente__c, ConstanciaRFC__c, ContratoFirmado__c, FM3__c, IdentificacionOficialCliente__c, PoderNotarial__c, RFCDoc__c, RFC__c, RegistroPatronal__c, Comprobante_de_Domicilio_Afiliado__c, Constancia_de_Situaci_n_Fiscal__c, Estado_de_Cuenta__c, ActaConstitutiva__c FROM TiposDocumento__c WHERE Name LIKE '%EL' or Name LIKE '%DocumentosOportunidad%'"})
        return ctcLightning.aura( executeQuery, component )
      }))
      .then( $A.getCallback( function( res ) {
        if( res && res.length > 0 ) {
          var documentos = {};
          var { TiposDocumento__c = {} } = component.get('v.app_edenred.schema');
          for( var doc of res ) {
            documentos[doc.Name] = doc;
            documentos[doc.Name].label = {};
            for( var field in doc ) {
              if( doc[field] == true && TiposDocumento__c.hasOwnProperty(field) ) {
                // documentos[doc.Name].label[field] = TiposDocumento__c[field].label;
                var label = TiposDocumento__c[field].label
                
                //archivo válido para ser mostrado, es decir, puede haber más ContentDocument Asociados a Opportunity ó EntidadLegal__c
                documentos[doc.Name].label[label] = TiposDocumento__c[field].label;
              } else if( doc[field] == false ) {
                delete documentos[doc.Name][field];
              }
            }
          }
          console.log('documentos: ', documentos)

          component.set('v.app_edenred.documentos', documentos);
          helper.getInitialData(component, contratoId);
          helper.getFiliales(component, contratoId);
        }

      })).catch( $A.getCallback( function( err ) {
           console.log("error: ", err );
      }))


      // helper.getInitialData(component, contratoId);
      // helper.getFiliales(component, contratoId);


   },
   addRows : function(component, event, helper) {
         
       var folios = component.get("v.subCuentas");
       var len = folios.length;
       console.log("add");
        folios.push({
            'Name':len+1,
            'CodigoAS400':''
        });
        component.set("v.subCuentas",folios);
   },
   deleteRow : function(component, event, helper) {
         
       var folios = component.get("v.subCuentas");
       var len = folios.length;
       if(len>0){
            folios.splice(len-1, 1);
            component.set("v.subCuentas",folios);
       }      
   },
   handleClick : function(component, event, helper){
      
      var url = location.href;  // entire url including querystring - also: window.location.href;
      var baseURL = url.substring(0, url.indexOf('/', 14));
       
      console.log('handleClick:',event.target.name); 
      var attachName = event.target.name;
      var attachId = event.target.id;
      
       if(attachName.indexOf('.pdf') != -1){
          var url = baseURL+"/servlet/servlet.FileDownload?file=" + attachId;
          console.log('URL:'+ url);     
          component.set("v.isOpen", true);
          component.set("v.urlPDF", url);
       }else{
           //window.open("../servlet/servlet.FileDownload?file=" + attachId); original 8/08/2018
           // window.location = "/lightning/r/ContentDocument/" + attachId + "/view";
           // window.open("/sfc/servlet.shepherd/version/download/" + attachId)
           console.log('download attachId: ', attachId, $A.get('e.lightning:openFiles'));
           $A.get('e.lightning:openFiles').fire({recordIds: [attachId] }); 
      }
   },
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
 
   likenClose: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer 
      // and set set the "isOpen" attribute to "False for close the model Box.
      alert('thanks for like Us :)');
      component.set("v.isOpen", false);
   },

   guardaContrato : function(component, event, helper) {
   
      var dataSource = component.get("v.dataSource");

      helper.save(component,dataSource);
   },
    generarClientes : function(component, event, helper){
        console.log("INICIO GENERA");
        component.set("v.spinAs400",true);
        var contrato = component.get("v.dataSource");
        var filial = component.get("v.filialesSource");
        var extras = component.get("v.subCuentas"); 
        var codigos=[];
        if(contrato && contrato.Contrato2__c && contrato.Contrato2__c.CodigoAS400__c && contrato.Contrato2__c.CodigoAS400__c.length > 0){
            var filialFlag = true;
            codigos.push(contrato.Contrato2__c.CodigoAS400__c);
            if(filial && filial.length > 0){
                if(filial){
                    for(var x = 0; x < filial.length; x ++){
                        if(filial[x].CodigoAS400__c == undefined || filial[x].CodigoAS400__c.length == 0){
                            filialFlag = false;
                        }else{
                            console.log();
                            codigos.push(filial[x].CodigoAS400__c);
                        }                    
                    }
                } 
            }
            
            if( extras.length>0){
                for(var x = 0; x < extras.length; x ++){
                    if(extras[x].CodigoAS400.length == 0|| extras[x].CodigoAS400 == undefined ){
                        filialFlag = false;
                    }else{
                        codigos.push(extras[x].CodigoAS400);
                    }
                }
            }
            if(!filialFlag){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "duration": "15000",
                    "type": "error",
                    "title": "Error al aprobar",
                    "message": "Debe contar con codigos AS400"
                });            
                toastEvent.fire();
                component.set("v.spinAs400",false);
            }else{
                console.log("LLAMA HELPER");
                helper.generarClientAs400(component,event);
            }
        }else{
            var toastEvent2 = $A.get("e.force:showToast");
            console.log('Llenar filiales2',toastEvent2);
            toastEvent2.setParams({
                "duration": "15000",
                "type": "error",
                "title": "Error al aprobar",
                "message": "Debe contar con codigos AS400"
            });
            toastEvent2.fire();
            component.set("v.spinAs400",false);
        }   
    },

   aprobarADV : function(component, event, helper){

      console.log('entro a aprobar');

      var contrato = component.get("v.dataSource");
      var filial = component.get("v.filialesSource");
      var extras = component.get("v.subCuentas"); 
       
       console.log("fffff1::::"+JSON.stringify(filial));
 console.log("fffff2::::"+JSON.stringify(extras));
        console.log("fffff3::::"+JSON.stringify(contrato));
      if(contrato && contrato.Contrato2__c && contrato.Contrato2__c.CodigoAS400__c && contrato.Contrato2__c.CodigoAS400__c.length > 0){
         var filialFlag = true;
         
         console.log(filial,':filiales:',filial.length);
         
         if(filial && filial.length > 0){

            console.log('entro if filiales');

            if(filial){
               for(var x = 0; x < filial.length; x ++){
                  if(filial[x].CodigoAS400__c == undefined || filial[x].CodigoAS400__c.length == 0){
                     console.log('no existe codigo');
                     filialFlag = false;
                  }else{
                     console.log(filial[x].CodigoAS400__c.length,'exite codigo:',filial[x].CodigoAS400__c);
                  }
                 
               }
            } 
         }
          
       	if( extras.length>0){
           for(var x = 0; x < extras.length; x ++){
               if(extras[x].CodigoAS400.length == 0|| extras[x].CodigoAS400 == undefined ){
                   filialFlag = false;
               }
           }
       	}

         console.log('filialFlag out:',filialFlag);

         if(!filialFlag){
            console.log('Llenar filiales1');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                 "duration": "15000",
                 "type": "error",
                 "title": "Error al aprobar",
                 "message": "Debe contar con codigos AS400"
            });            
             toastEvent.fire();

         }else{

         	if(filial){
               for(var x = 0; x < filial.length; x ++){
                 filial[x].Disabled = true;
               }
            }
                       
            var eL = component.get('v.entidadLegal');
            eL.CodigoAS400__c = contrato.Contrato2__c.CodigoAS400__c;
            //eL.Disabled = true;
             
            component.set("v.filialesSource",filial);
            component.set('v.entidadLegal',eL);
            //component.set("v.btnInactiveCheck", false);

            helper.aprobar(component,contrato,filial);
             
            //var generatePDFEvent = $A.get("e.c:CON_GeneratePDF_EVENT");
            //generatePDFEvent.setParams({params: {filiales: filial,entidadLegal: eL}})
            //generatePDFEvent.fire();

         }
      }else{

         var toastEvent2 = $A.get("e.force:showToast");
         console.log('Llenar filiales2',toastEvent2);
         toastEvent2.setParams({
             "duration": "15000",
             "type": "error",
             "title": "Error al aprobar",
             "message": "Debe contar con codigos AS400"
         });
         toastEvent2.fire();
      }  
   },
	
   rechazarADV : function(component, event, helper){

      var toastEvent2 = $A.get("e.force:showToast");
      var dataSource =  component.get("v.dataSource");

       var motivos=component.get("v.motivosRechazoSelec");
      //if(dataSource.Contrato2__c.Comentarios_ADV__c == null || dataSource.Contrato2__c.Comentarios_ADV__c == undefined || dataSource.Contrato2__c.Comentarios_ADV__c.length == 0){
      if(motivos == null || motivos == undefined || motivos.length == 0){
         
         toastEvent2.setParams({
             "duration": "15000",
             "type": "error",
             "title": "Error al rechazar",
             "message": "Debe ingresar al menos un motivo para rechazar."
         });

         toastEvent2.fire();
         
      }else{
         helper.rechazar(component,dataSource);
      }
   },

   updateData: function(component,event,helper){

      console.log('entro updateData:',event.target.id);

      var filial = component.get('v.filialesSource');
      var eL = component.get('v.entidadLegal');
      
      if(eL){
         eL.Disabled = (eL.Id == event.target.id) ? false : true;                   
      }      
      component.set('v.entidadLegal',eL);

      if(filial){
         for(var x = 0; x < filial.length; x ++){
            filial[x].Disabled = (filial[x].Entidad_Cuenta__r.EntidadLegal__r.Id == event.target.id) ? false : true;            
         }
      }   
      component.set('v.filialesSource',filial);   

      helper.getNewRepresentanteLegal(component,event.target.id);

   },
   hidePDFSpinner: function (component, event) {
      console.log('evento hidePDFSpinner:',event.getParam('isReady'));
      component.set("v.btnActionAprobar", false);
   },
    
    generaXML: function (component, event,helper) {
        console.log('evento hidePDFSpinner:');
        component.set("v.btnActionXML", true);
        helper.createXML(component);
        
    },
    ocultarMostrar : function(component, event,helper){
        component.set("v.modalErrores",!component.get("v.modalErrores"));
    }
})