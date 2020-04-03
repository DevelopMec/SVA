({
	init: function(component) {
		// console.clear();
		this.obtenerDirecciones(component);
		component.set('v.dataToSave.oportunidad.Id', component.get('v.opportunityId'));
		if (component.get('v.dataToSave.contratoFilial')) {
			component.set('v.dataToSave.contratoFilial', {});
		}
		console.log('accountId:', component.get('v.accountId'));
		console.log('helper.init(), dataToSave:', JSON.parse(JSON.stringify(component.get('v.dataToSave'))));
		// Variables
		let persistedAccountStructureData = {};
		let persistedSubsidiaries = [];
		// Variables
        console.log("ELCONTRATO:"+component.get('v.dataToSave.contrato.Id'));
		this.createActionPromise(component, {
			name: 'getAccountsStructureFromContract',
			params: {
				contractId: component.get('v.dataToSave.contrato.Id')
			}
		})
		.then(response => {
			console.log('helper.init(), 1st response');
			console.log('helper.init(), response.getReturnValue():', response.getReturnValue());
			if (response.getReturnValue()) {
				persistedAccountStructureData = response.getReturnValue();
				return this.createActionPromise(component, {
					name: 'getContractSubsidiaries',
					params: {
						contractId: component.get('v.dataToSave.contrato.Id')
					}
				});
			} else {
				component.set('v.errorMessage', 'No se encontró ningun registro de Contrato');
				return Promise.reject(new Error('Error en "helper.init()": No se encontró ningun registro de Contrato'));
			}
		})
		.then(response => {
			console.log('helper.init(), 2nd response');
			console.log('helper.init(), response.getReturnValue():', response.getReturnValue());
			if (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
				persistedSubsidiaries = response.getReturnValue();
			} else {
				persistedSubsidiaries = [];
			}
			component.set('v.persistedSubsidiaries', persistedSubsidiaries);
			return this.createActionPromise(component, {
				name: 'getLegalEntitiesThroughAcc',
				params: {
					accId: component.get('v.accountId')
				}
			});
		})
		.then(response => {
			console.log('helper.init(), 3rd response');
			console.log('helper.init(), response.getReturnValue():', response.getReturnValue());
			if (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
				this.orderInitData(component, response.getReturnValue(), persistedAccountStructureData, persistedSubsidiaries);
			} else {
				component.set('v.errorMessage', 'No se encontró ninguna Entidad Legal Asociada a la Cuenta de la Oportunidad');
				return Promise.reject(new Error('Error en "helper.init()": No se encontró ninguna Entidad Legal Asociada a la Cuenta de la Oportunidad'));
			}
		})
		.catch(error => {
			console.log(`helper.init(), error: ${error}`);
		}); 
	},
	obtenerDirecciones : function(component){
		console.log("obtenerDirecciones"); 
		var action=component.get("c.getDireccionesFiscales");
		action.setParams({idCuenta:component.get("v.accountId"),idOpp:component.get("v.opportunityId")});
		action.setCallback(this,function(response){
			var state=response.getState(); 
			if(state=='SUCCESS'){
				console.log("RESPONSE::"+JSON.stringify(response.getReturnValue()));
				var result=response.getReturnValue().lisDir;
				var direcciones=[];
				if(result!=null&&result.length>0){
					for (var i =0; i<result.length; i++) {
						//Calle__c+' '+NumeroExterior__c+' '+Colonia__c+' '+DelegacionMunicipioFiscal__c+' '+Estado__c+' C.P '+CodigoPostal__c;
						var dir=this.validateString(result[i].Calle_Tt__c)+' '+this.validateString(result[i].NumeroExterior_Tt__c)+' '+this.validateString(result[i].NumeroInterior_Tt__c) +' '+this.validateString(result[i].Colonia_Tt__c)+' '+this.validateString(result[i].DelegacionMunicipio_Tt__c)+' '+this.validateString(result[i].Estado_Tt__c)+' C.P '+this.validateString(result[i].CodigoPostal_Tt__c) ;
                        //var dir=result[i].Calle_Tt__c+' '+result[i].NumeroExterior_Tt__c+' '+result[i].NumeroInterior_Tt__c +' '+result[i].Colonia_Tt__c+' '+result[i].DelegacionMunicipio_Tt__c+' '+result[i].Estado_Tt__c+' C.P '+result[i].CodigoPostal_Tt__c ;
						direcciones.push({"label":dir,"value":dir});
					}					
				}
				component.set("v.direccionSelec",response.getReturnValue().valor);
				component.set('v.dataToSave.contrato.DireccionFiscal__c', response.getReturnValue().valor);
				component.set("v.direccionesFiscales",direcciones);
				
			}else{
				console.log("Error obtenerDirecciones");
			}
		});
		$A.enqueueAction(action);
	},
        validateString : function(valor){
            if(valor==null||valor==undefined){
                return '';
            }else{
               return valor;
            }
        },
	orderInitData: function(component, legalEntitiesWithlegalReps, persistedAccountStructureData, persistedSubsidiaries) {
		console.log('orderInitData(), persistedAccountStructureData:', persistedAccountStructureData);
		console.log('orderInitData(), persistedSubsidiaries:', persistedSubsidiaries);
		// Constants
		const JS_TYPE_OBJECT = 'object';
		const FIELD_ENTIDAD_LEGAL = 'Entidad_Legal__c';
		const FIELD_CONTACTO = 'Contacto__c';
		// Constants
		let tempLEsWithLRs = [];
		for (let { Contactos_Entidad1__r, EntidadLegal__c, EntidadLegal__r, Id } of legalEntitiesWithlegalReps) {
			let le = EntidadLegal__r;
			if (Contactos_Entidad1__r && ((typeof Contactos_Entidad1__r) === JS_TYPE_OBJECT) && (Array.isArray(Contactos_Entidad1__r)) && (Contactos_Entidad1__r.length > 0)) {
				let legalReps = [];
				for (let legalRep of Contactos_Entidad1__r) {
					legalReps.push({ value: legalRep.Contacto__r.Id, label: legalRep.Contacto__r.Name });
				}
				le.legalRepresentatives = legalReps;
			} else {
				le.legalRepresentatives = [];
			}
			le.legalEntityAccountId = Id;
			le.mainLegalRepresentative = { value: '', label: '' };
			tempLEsWithLRs.push(le);
		}
		console.log('helper.orderInitData(), tempLEsWithLRs:', tempLEsWithLRs);
console.log("VERR::"+JSON.stringify(persistedAccountStructureData));
		let selectedLegalEntity = { Id: '' };
		if (persistedAccountStructureData.hasOwnProperty(FIELD_ENTIDAD_LEGAL)) {
			selectedLegalEntity = tempLEsWithLRs.find(lewlr => {
				return lewlr.Id === persistedAccountStructureData[FIELD_ENTIDAD_LEGAL];
			});
		} else {
			if ((tempLEsWithLRs.length - 1) === 0) {
				selectedLegalEntity = tempLEsWithLRs[0];
				component.set('v.dataToSave.contrato.Entidad_Legal__c', selectedLegalEntity.Id);
				component.set('v.dataToSave.contrato.Entidad_Cuenta__c', selectedLegalEntity.legalEntityAccountId);
				component.set('v.dataToSave.oportunidad.Entidad_Legal__c', selectedLegalEntity.Id);
				component.set('v.dataToSave.oportunidad.Entidad_Cuenta__c', selectedLegalEntity.legalEntityAccountId);
			}
		}console.log("HASS2"+selectedLegalEntity);
		if (persistedAccountStructureData.hasOwnProperty(FIELD_CONTACTO) && selectedLegalEntity.hasOwnProperty('legalRepresentatives')) {
			selectedLegalEntity.mainLegalRepresentative = selectedLegalEntity.legalRepresentatives.find(lr => {
				return lr.value === persistedAccountStructureData[FIELD_CONTACTO];
			});
			if (typeof selectedLegalEntity.mainLegalRepresentative === 'undefined') {
				selectedLegalEntity.mainLegalRepresentative = { value: '', label: '' };
			}
		} else {
			selectedLegalEntity.mainLegalRepresentative = { value: '', label: '' };
		}
		console.log('orderInitData(), selectedLegalEntity:', selectedLegalEntity);
		component.set('v.selectedLegalEntityId', selectedLegalEntity.Id);
		component.set('v.selectedLegalEntity', selectedLegalEntity);
		component.set('v.selectedLegalRepresentativeId', selectedLegalEntity.mainLegalRepresentative.value);
		component.set('v.mainLegalRepresentative', selectedLegalEntity.mainLegalRepresentative.label);
		component.set('v.legalEntitiesOriginal', tempLEsWithLRs);
		component.set('v.legalEntitiesCopy', tempLEsWithLRs);
		// Setting the selected subsidiaries array if there's any persisted subsidiary
		let subsidiaries = this.getSubsidiaries(tempLEsWithLRs, selectedLegalEntity.Id);
		if (persistedSubsidiaries.length > 0) {
			let selectedSubsidiaries = [];
			let updatedSubsidiaries = [];
			for (let subsidiary of subsidiaries) {
				let tempPersistedSubsidiary = persistedSubsidiaries.find(persistedSubsidiary => {
					return persistedSubsidiary.Entidad_Cuenta__r && persistedSubsidiary.Entidad_Cuenta__r.EntidadLegal__c ? persistedSubsidiary.Entidad_Cuenta__r.EntidadLegal__c.includes(subsidiary.Id) : undefined;
				});
				if (tempPersistedSubsidiary) {
					// this.setMainLegalRepresentative(subsidiary);
					subsidiary.mainLegalRepresentative = selectedLegalEntity.mainLegalRepresentative;
					selectedSubsidiaries.push(subsidiary);
				} else {
					updatedSubsidiaries.push(subsidiary);
				}
			}
			component.set('v.selectedSubsidiaries', selectedSubsidiaries);
			console.log('orderInitData(), selectedSubsidiaries:', selectedSubsidiaries);
			component.set('v.subsidiaries', updatedSubsidiaries);
			component.set('v.subsidiariesCopy', updatedSubsidiaries);
			console.log('orderInitData(), updatedSubsidiaries:', updatedSubsidiaries);
		} else {
			component.set('v.subsidiaries', subsidiaries);
			component.set('v.subsidiariesCopy', subsidiaries);
			console.log('orderInitData(), subsidiaries:', subsidiaries);
		}
		// All the information needed to show the rest of the component body is complete
		component.set('v.isDataReady', true);
		console.log('helper.init(), dataToSave:', JSON.parse(JSON.stringify(component.get('v.dataToSave'))));
	},
	
	getSubsidiaries: function(legalEntitiesCopy, selectedLegalEntityId) {
		try {
			if (((typeof legalEntitiesCopy) === 'object') && Array.isArray(legalEntitiesCopy)) {
				if ((typeof selectedLegalEntityId) === 'string') {
					let subsidiaries = legalEntitiesCopy.filter(legalEntity => {
						return !legalEntity.Id.includes(selectedLegalEntityId);
					});
					return subsidiaries;
				} else {
					throw new Error('Error en "helper.getSubsidiaries()": El argumento "selectedLegalEntityId" debe ser de tipo "String"');
				}
			} else {
				throw new Error('Error en "helper.getSubsidiaries()": El argumento "legalEntitiesCopy" debe ser de tipo "Array"');
			}
		} catch(e) {
			console.log(e);
		}
	},
	
	setMainLegalRepresentative: function(selectedSubsidiary) {
		if (selectedSubsidiary.legalRepresentatives.length > 0) {
			selectedSubsidiary.mainLegalRepresentative = selectedSubsidiary.legalRepresentatives[0];
		}
	},
	
	showHideModal: function(component) {
		let modal = component.find('modal');
		$A.util.toggleClass(modal, 'slds-fade-in-open');
		let overlay = component.find('overlay');
		$A.util.toggleClass(overlay, 'slds-backdrop_open');
		component.set('v.showModal', false);
	},
	
	showHideListbox: function(component, listboxName) {
		try {
			if ((typeof listboxName) === 'string') {
				let listbox = component.find(listboxName + '-listbox');
				$A.util.toggleClass(listbox, 'slds-hide');
			} else {
				throw new Error('Error en "helper.showHideListbox()": el argumento "listboxName" debe ser de tipo "String"');
			}
		} catch(e) {
			console.log(e);
		}
	},
	
	invokeInit: function(component) {
		this.init(component);
	},
	
	changeButtonGroupState: function(component) {
		component.set("v.finishButtonFlag", true);
		component.set("v.saveButtonFlag", false);
		component.set("v.emailButtonFlag", true);
		component.set("v.pdfButtonFlag", true);
		component.set('v.isDataSaved', false);
	},
	
	createActionPromise: function(component, action) {
		return new Promise($A.getCallback((resolve, reject) => {
			let { name, params } = action;
			let a = component.get('c.' + name);
			a.setParams(params);
			a.setCallback(this, response => {
				// DO NOT USE "this"
				console.log(`helper.createActionPromise(), action: ${name}, response.getState(): ${response.getState()}`);
				if (response.getState() === 'SUCCESS') {
					let returnedValue = response.getReturnValue();
					if (!('exceptionTypeName' in returnedValue)) {
						resolve(response);
					} else {
						reject(new Error(`Error en "helper.createActionPromise()": ${returnedValue.message}, Rastreo de Pila: ${returnedValue.stackTraceString}`));
					}
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(a);
		}));
	}
})