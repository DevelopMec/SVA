({
    doInit : function(component, event, helper) {
        var action=component.get("c.getDatos");
        console.log(component.get("v.IdOportunidad"));
        action.setParams({idOportunidad:component.get("v.IdOportunidad")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                component.set("v.NombreCliente", result.NombreCliente);
                component.set("v.Producto", result.Producto);
                component.set("v.NumCliente", result.NumCliente);
                component.set("v.Sector", result.Sector);
                component.set("v.LineaOperativa", result.LineaOperativa);
                component.set("v.DiasCredito",result.DiasCredito);
                component.set("v.PorcComision",result.PorcComision);
                component.set("v.FrecuenciaFacturacion",result.FrecuenciaFacturacion);
                component.set("v.GarantiaNegociando",result.GarantiaNegociando);
                console.log('(result.IsApprovedCreditEval__c ' + result.ProcesoAprobacion);
                if (result.ProcesoAprobacion == "En Proceso" ||  result.ProcesoAprobacion == "Si" ){
                	component.set("v.IsReadOnly",true);    
                }
                
                if (result.FrecuenciaFacturacion != null){
                    component.set("v.FrecuenciaFacturacion",result.FrecuenciaFacturacion);
                    
                    var a = component.get('c.cambiaPeriodoLiberacion');
                 	$A.enqueueAction(a);
                }
                else{
                    component.set("v.FrecuenciaFacturacion","Semanal");
                    component.set("v.GarantiaNegociando","Depósito en Efectivo");
                }
            }
        });
          
        $A.enqueueAction(action);
        
    },
    
    cambiaPeriodoLiberacion: function(component,event,helper){
        var acc = component.find("selectPeriodoLiberacion").get("v.value");
        component.set("v.FrecuenciaFacturacion",acc);
        
        var a = component.get('c.ActualizaDiaCredito');
        $A.enqueueAction(a);
    },
    
    ActualizaDiaCredito: function(component,event,helper){
        var value = component.find("txtdiasCredito").get("v.value");
        var vsemana;
		
        if (value == ""){
           component.set("v.SemanasCredito",""); 
            component.set("v.NoLiberaciones","");
            return;
        }
        
        if (value <= 7){vsemana = 1;}else{
            if (value <= 14){vsemana = 2;}else{
                if (value <= 21){vsemana = 3;}else{
                    if (value <= 28){vsemana = 4;}else{
                        if (value <= 31){vsemana = 5;}else{
                            if (value => 32){vsemana = 'Necesitas Autorización Especial';}}}}}}
              
        component.set("v.SemanasCredito",vsemana);
        
        var a = component.get('c.ActualizaDatos');
        $A.enqueueAction(a);
        
    },
    
    DebeEnviarEntregar: function(component,event,helper){
    	 var value = component.find("selectGarantia").get("v.value"); 

        var vValeGarantia = component.find("txtValeGarantia").get("v.value");
        var debeEnviar;
        var debeEntregar;
        var varchivo;
        
        if (vValeGarantia == ""){vValeGarantia = 0;}
        
        if (value == "Depósito en Efectivo"){
            varchivo = "Formato de Buro en Original";
        	debeEnviar = "Formato de Buro en Original";
            debeEntregar = "Realizar Deposito en Efectivo, el Correo del Cliente Deberás Gestionarlo con Hugo Marquez y Alejandro Roa (Cobranza), Así Como con Bernardo Valverde y Ana Gonzalez (Contabilidad)";
        }
        
        if (value == "Carta Stand By"){
            varchivo = "Carta Stand By";
        	debeEnviar = "Carta Stand By";
            debeEntregar = "Entregar Carta Stand By Emitida por el Banco en Original, con el Texto Autorizado por Juridico";
        }
        
        if (value == "Fianza"){
             varchivo = "Fianza de Crédito";
        	debeEnviar = "Fianza de Crédito";
            debeEntregar = "Fianza en Original y/o PDF (Electronica) con el Texto Autorizado por Juridico";
        }
        
        if (value == "**Pagaré**"){
             varchivo = "Formato de Buro en Original";
            if (vValeGarantia<=500000){
            	debeEnviar = "Formato de Buro en Original";
            }
            if (vValeGarantia>=501000){
            	debeEnviar = "Formato de Buro en Original, Estados Financieros Internos Año Anterior y Parcial del Año Actual, Últimas Dos Declaraciones de Hacienda";
            }
            debeEntregar = "Pagaré Original en Papel Seguridad y PDF de Acta Constitutiva o Poder Notarial, La Persona que Firma el Pagaré, se Valida que Tenga Facultades para Titulos de Crédito";
        }
        
         if (value == "Garantía Mixta"){
             varchivo = "Formato de Buro en Original";
             if (vValeGarantia<=500000){
        		debeEnviar = "Formato de Buro en Original";
             }
             if (vValeGarantia>=501000){
             	debeEnviar = "Formato de Buro en Original, Si Consideras Incluir un Pagaré Mayor a $500,000.00 Debes Entregara Estados Financieros Internos Año Anterior y Parcial del Año Actual, Últimas Dos Declaraciones de Hacienda";
             }
            debeEntregar = "Realizar Deposito en Efectivo, Carta Stand By Original, Fianza Original y/o PDF (Electronica). Pagaré en Papel Seguridad y PDF de Acta Constitutiva o Poder Notarial, La Persona que Firma el Pagaré, se Valida que Tenga Facultades para Titulos de Crédito";
        }
        
        if (value == "Sin Garantía (VR)"){
            varchivo = "Formato de Buro en Original";
            if (vValeGarantia<=300000){
        		debeEnviar = "Formato de Buro en Original, por Correo Solicitar Estudio de Riesgo al Analista de Crédito, Con Esta Respuesta Debes Gestionar Vo. Bo. del Gerente Comercial Avalando la Falta de Garantía";
            }
            if (vValeGarantia>=301000){
             	debeEnviar = "Formato de Buro en Original, por Correo Solicitar Estudio de Riesgo al Analista de Crédito, Con Esta Respuesta Debes Gestionar Vo. Bo. de la Dirección Comercial y Dirección de Finanzas Avalando la Falta de Garantía";
            }
            debeEntregar = "Este es un Movimiento Interno de EDENRED";
        }
        
        
        component.set("v.DebeEnviar",debeEnviar);
        component.set("v.DebeEntregar",debeEntregar);
       
        if (varchivo != ''){
            var listarchivos = [{ name: varchivo}];
    
            var action = component.get("c.getOppAttachments");
            action.setParams({oppId:component.get("v.IdOportunidad")});
             action.setCallback(this,function(response){
                var state = response.getState();
                if (state == "SUCCESS") {
                    var value = response.getReturnValue();
    
                    var documentNames = listarchivos;
                    var documents = [];
                    documentNames.forEach(function(document) {
                        document.isVisible = true;
                        
                        for (var i = 0; i < value.length; i++) {
                            if (value[i].ContentDocument.Title == document.name){
                                document.Id = value[i].ContentDocumentId;
                                document.loaded = true;
                                break;
                            }
                            else{
                                document.loaded = false;  
                            }
                        }
                        
                        documents.push(document);
                    });
        
                    component.set('v.documents', documents);
                    
                }
            });
        }
        
        $A.enqueueAction(action); 
    },
    
      ActualizaDatos: function(component,event,helper){
          var vPeridoLiberacion = component.find("selectPeriodoLiberacion").get("v.value");
          var vSemanaCredito = component.find("txtSemanaCredito").get("v.value");
          var vNoLiberaciones;
          
          if (vSemanaCredito == ""){
             component.set("v.NoLiberaciones","");
              component.set("v.ValeGarantia","0");
              return;
          }
          
          //-------------------------No. De Liberaciones Totales-------------------------
          if (vPeridoLiberacion == "Semanal"){
              if (vSemanaCredito < "6"){
                  vNoLiberaciones = vSemanaCredito + 1;  
              }
              else{
                vNoLiberaciones = vSemanaCredito;  
              }   
          }
          
          if (vPeridoLiberacion == "Quincenal"){
              if (vSemanaCredito == "Necesitas Autorización Especial"){vNoLiberaciones = vSemanaCredito;}else{
              if (vSemanaCredito >="1" && vSemanaCredito < "3"){vNoLiberaciones = "2";}else{
                  if (vSemanaCredito >="3" && vSemanaCredito < "5"){vNoLiberaciones = "3";}else{
                      if (vSemanaCredito ="5"){vNoLiberaciones = "4";}}}}
          }
          
          if (vPeridoLiberacion == "Mensual"){
              if (vSemanaCredito == "Necesitas Autorización Especial"){vNoLiberaciones = vSemanaCredito;}else{
              if (vSemanaCredito >="1" && vSemanaCredito < "5"){vNoLiberaciones = "2";}else{
                  if (vSemanaCredito ="5"){vNoLiberaciones = "2";}}}
          }
          
          component.set("v.NoLiberaciones",vNoLiberaciones);
          
          //-------------------------Días periodo de fact-------------------------
          var vPeriodofact;
          if (vPeridoLiberacion == "Semanal"){vPeriodofact = 7;}
          if (vPeridoLiberacion == "Quincenal"){vPeriodofact = 14;}
          if (vPeridoLiberacion == "Mensual"){vPeriodofact = 30;}
          component.set("v.Periodofact",vPeriodofact);
          
          //-------------------------Total de Días a Crédito-------------------------
          var vTotalDiasCredito;
          var vDiasCredito = component.find("txtdiasCredito").get("v.value");
          if (vDiasCredito != ""){
          	vTotalDiasCredito = Number(vDiasCredito) + Number(vPeriodofact);
          }
          component.set("v.TotalDiasCredito",vTotalDiasCredito);
          
          
          //-------------------------¿Cuánto Debe Valer la Garantía?-------------------------
         var vValeGarantia = 0;
          if (vNoLiberaciones != "Necesitas Autorización Especial" && vLineaOperativa != "" ){
              var vLineaOperativa = component.find("txtLineaOperativa").get("v.value");
              if (vDiasCredito >= vTotalDiasCredito){
                vValeGarantia = "Necesitas Autorización Especial";    
              }else{
                 vValeGarantia = vLineaOperativa * vNoLiberaciones;
                 vValeGarantia =  vValeGarantia.toFixed(2);
              }
          }
          
         component.set("v.ValeGarantia",vValeGarantia);
          
          
 
          //-------------------------Comision-------------------------
          var vComision = 0;
          var vPorcComision = component.find("txtPorcComision").get("v.value");
          
          if (vLineaOperativa != "" && vPorcComision !=""){
              vComision = vLineaOperativa * (vPorcComision / 100);
              vComision = vComision.toFixed(2);
          }
          component.set("v.Comision", vComision); 
          
          //-------------------------Costo financiero/punto equilibrio-------------------------
          var vCostoFinanciero = 0;
          if (vLineaOperativa != "" && vTotalDiasCredito !=""){
              vCostoFinanciero = (vLineaOperativa/30 * vTotalDiasCredito) * (0.12/360) * vTotalDiasCredito;
              vCostoFinanciero = vCostoFinanciero.toFixed(2);
          }
          component.set("v.CostoFinanciero",vCostoFinanciero);
          
          //-------------------------Utilidad/Pérdida-------------------------
          var vUtilidaPerdida = 0;
          if (vComision > vCostoFinanciero){
              vUtilidaPerdida = vComision - vCostoFinanciero;
              vUtilidaPerdida = vUtilidaPerdida.toFixed(2);
          }
          component.set("v.UtilidaPerdida",vUtilidaPerdida);
          
          //-------------------------Conclusión-------------------------
          if (vComision > vCostoFinanciero){
              component.set("v.Conclusion","Utilidad");
          }
          else{
            component.set("v.Conclusion","Perdida");  
          }
          
       var a2 = component.get('c.DebeEnviarEntregar');
       $A.enqueueAction(a2);
      },
    
    Guardar: function(component,event,helper){
        return helper.Guardar(component,event, false);
    },
     
     Aprobar: function(component,event,helper){
        return helper.Guardar(component,event, true);
     },
    
   handleUploadDoc: function(component, event, helper) {
       const JS_UNDEFINED_TYPE = 'undefined';
		// Getting the uploaded files...
		let oppId = component.get('v.IdOportunidad');
		let [ newTitle, oppFieldName ] = event.getSource().get('v.name').split('-');
		let { name, documentId } = event.getParam('files')[0];

		if ((typeof documentId !== JS_UNDEFINED_TYPE) && (documentId !== '')) {
			helper.showToast(component, event,'success', '¡Éxito!', 'El archivo ha sido cargado correctamente');
			
			helper.createActionPromise(component, { name: 'updateDocAndOpp', params: { documentId, newTitle, oppId, oppFieldName } })
				.then(response => {
					helper.handleDocAndOppUpdate(component, response, newTitle);
				})
				.catch(error => {
					console.log('handleUploadDoc(), error:', error);
				});
                                                                                      
                   var a = component.get('c.DebeEnviarEntregar');
                 	$A.enqueueAction(a);
		} else {
            helper.showToast(component, event, 'error', 'Error', 'Ocurrió un problema al cargar el archivo. Vuelva a intentarlo de nuevo más tarde.');                                                                          
		}
	},
                                       
	handleDeleteDoc: function(component, event, helper) {
		// Variables
		let oppId = component.get('v.IdOportunidad');
		var oldDocId = event.getSource().get('v.name');
		// Variables
		helper.createActionPromise(component, { name: 'deleteDocUpdateOpp', params: { oldDocId, oppId } })
			.then(response => {
				let { errors, id, isSuccess } = response.getReturnValue();
				if (isSuccess) {
                    helper.showToast(component, event, 'success', '¡Éxito!', 'El archivo fue eliminado correctamente');                                                              
					              
                    var a = component.get('c.DebeEnviarEntregar');
                 	$A.enqueueAction(a);
                                               
				} else {
                      helper.showToast(component, event, 'error', 'Error', 'Ocurrió un problema al eliminar el archivo: ' + errors);                                                                 
				}
			})
			.catch(error => {
				console.log('handleDeleteDoc(), error:', error);
			});
	},
	
     handleDownloadDoc: function(component, event, helper) {
		var documentId = event.getSource().get('v.name');
		window.open('/sfc/servlet.shepherd/document/download/' + documentId);
	},
})