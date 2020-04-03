({
	init : function( component, event, helper ) {
		var spinner = component.find("spinner");
		ctcLightning.spinner.show( component, "spinner" )



		var recordId = component.get("v.recordId");
		var listaAS400 = component.get("c.listaAS400");
		listaAS400.setParams({ accountId: recordId });
		console.log('id cuenta '+recordId);
		
		var app_ctc = component.get("v.app_ctc")

		ctcLightning.aura( listaAS400, component )
		.then( $A.getCallback( function( res ) {
			app_ctc.instance = {}
			app_ctc.codigos = []
            app_ctc.filiales = []
			var codigos = res && res.records ? res.records : []
            var sinContrato = res && res.filiales ? res.filiales : []
            var codigosAs4 = res && res.codigosAs ? res.codigosAs : []
            
			console.log('id codigos '+codigos);
			var familys = {}
            var familia;
            var producto;
            var mapId = {};
            
            for(var codAs of codigosAs4){
                mapId[codAs.CodigoAS400__c]=codAs.Id;
            }
            component.set("v.mapaFilial",mapId);
            
            for(var filial of sinContrato){
                var QueProducto=filial.CodigoAS400__c.split("-");
                if( QueProducto.length>1){
                    producto=QueProducto[1];
                    console.log('id producto********* '+producto);
                    if( producto=='11' ||producto=='21'||producto=='41'||producto=='61'||producto=='51'||producto=='71'||producto=='81'||producto=='91'||producto=='01'){
                    	familia='Ticket Restaurante';
                	}
                    else if (producto=='14'||producto=='04' ||producto=='34'|| producto=='54' ||producto=='64'||producto=='44') {
                        familia='Vestimenta';
                    }
                     else if ( producto=='18' ||producto=='08'||producto=='38'||producto=='68'||producto=='78'||producto=='58'||producto=='PR') {
                        familia='Regalo';
                    }
                     else if ( producto=='12'||producto=='02' ||producto=='19'||producto=='32' ||producto=='72'||producto=='52'||producto=='62'||producto=='69'||producto=='LF'||producto=='LFC'||producto=='LFE'||producto=='LFP'||producto=='LFM'||producto=='LM'||producto=='LMC'||producto=='PR'||producto=='AL'||producto=='DI'||producto=='DS'||producto=='DSC'||producto=='DSH') {
                        familia='Despensa';
                    }
                     else if ( producto=='29'||producto=='09' ) {
                        familia='Empresarial';
                    }
                      else if ( producto=='39' ) {
                        familia='Ayuda Social';
                    }
                     else if ( producto=='30'||producto=='24' ||producto=='03'||producto=='GS'||producto=='GCP' ||producto=='GSC' ||producto=='GSD' ||producto=='GH' ||producto=='GSM' ||producto=='GSH'||producto=='05'||producto=='03' ) {
                        familia='Combustible';
                    }
                    else if ( producto=='31'  ) {
                        familia='Mantenimiento';
                    }
                        else{
                            familia="Subcuenta";
                        }
                    console.log('id familia '+familia);
                }
                
                var ff= {Id:filial.Id,CodigoAS400__c: filial.CodigoAS400__c, Type: 'Entidad',ProductName:producto,RFC__c:filial.Entidad_Cuenta__r.Name,Nombre__c:filial.NombreEL__c}
                 if( !familys.hasOwnProperty(familia) ) {
					 familys[familia]=[]
				}                
                 familys[familia].push(ff);                
            }            
			for( var codigo of codigos ) {
				var record = {CodigoAS400__c: codigo.CodigoAS400__c, Type: 'Entidad',RazonSocial__c:codigo.Entidad_Legal__r.RazonSocial__c}

				console.log('codigo'+codigo);

				var family = codigo.PartidaPresupuesto__r && codigo.PartidaPresupuesto__r.Product2 && codigo.PartidaPresupuesto__r.Product2.Family ? codigo.PartidaPresupuesto__r.Product2.Family : ''
				console.log('family  '+codigo.CodigoAS400__c);
				console.log('family2  '+codigo.Entidad_Legal__r.Name);
				// nueva estructura
				if(  family && !familys.hasOwnProperty(family) ) {
					familys[family] = []
				}


				if( codigo.Entidad_Legal__r ) {
					record.Nombre__c = codigo.Entidad_Legal__r.RazonSocial__c || ''
					record.RFC__c = codigo.Entidad_Legal__r.Name || ''
                    record.ProductName = codigo.PartidaPresupuesto__r.Product2.Name || ''
                    //record.RazonSocial__c = codigo.Entidad_Legal__r.RazonSocial__c || ''
				}
				app_ctc.codigos.push(record)
				console.log('app_ctc'+record);

				// nueva estructura
				familys[family].push(record)
				if( codigo.Contratos_Filial__r ) {
					for( var filial of codigo.Contratos_Filial__r ) {
						var record2 = {CodigoAS400__c: filial.CodigoAS400__c, Type: 'Filial'}
						if( filial.Entidad_Cuenta__r ) {
							record2.Nombre__c = filial.Entidad_Cuenta__r.NombreEL__c || ''
							record2.RFC__c = filial.Entidad_Cuenta__r.RFCEL__c || ''
                            record2.ProductName = codigo.PartidaPresupuesto__r.Product2.Name || ''
                            //record2.RazonSocial__c = codigo.Entidad_Cuenta__r.RazonSocial__c.Name || ''
						}
						app_ctc.codigos.push(record2)
						console.log('app_ctc'+record2);
						// nueva estructura
						familys[family].push(record2)
					}
				}

			}
            
             
            
  
			// nueva estructura
			var listFamilys = []
			for( var family in familys ) {
				listFamilys.unshift({Name: family, Value: familys[family]})
			}
			app_ctc.codigosFamilia = listFamilys || []

			component.set("v.app_ctc", app_ctc)
            //console.log(JSON.stringify(app_ctc));
			console.log('app_ctcq'+app_ctc.codigosFamilia);
			ctcLightning.spinner.hide( component, "spinner" )
		})).catch( $A.getCallback( function( err ) {
			ctcLightning.spinner.hide( component, "spinner" )
		}))
        
        
        var urlAs400 = component.get("c.getURL");
		
		ctcLightning.aura( urlAs400, component )
        .then( $A.getCallback( function( res ) {
            component.set("v.urlAS400", res)
        })).catch( $A.getCallback( function( err ) {
            ctcLightning.spinner.hide( component, "spinner" )
        }))
	},

	viewUrl : function( component, event, helper ) {
        var ur=event.getSource().get("v.label");
        var mapIds=component.get("v.mapaFilial");
        var urId=mapIds[ur];
        if(urId!=null&&urId!=undefined&&urId!=''){
           window.open("/"+urId,"_blank"); 
        }
		/*var as400 = event.getSource().get("v.value");
		var instance = component.get("v.app_ctc.instance");
        var urlAS400 = component.get("v.urlAS400");
        console.log(urlAS400);
		instance.renderUrl = true;
		instance.as400 = as400;
		//instance.url = 'http://saedrmex01db100/ReportServer/Pages/ReportViewer.aspx?/Comun/CRM/BIR_CRM_Facturacion_Pedidos&IdUser=OCAMARGO&Tipo=1&Valor=' + as400
        instance.url = urlAS400+'&Tipo=4&Valor='+ as400;
        component.set("v.app_ctc.instance", instance)
		ctcLightning.modal.open( component, "urlDialog", "overlay" )*/
	},

	closeModal : function( component, event, helper ) {
		ctcLightning.modal.close( component, "urlDialog", "overlay" )
		component.set("v.app_ctc.instance", {})
	}
})