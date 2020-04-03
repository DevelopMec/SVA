({
	invokeInit: function(component, event, helper) {
		helper.init(component);
	},
	
	handleLegalEntitySearch: function(component, event, helper) {
		let searchCriteria = event.getSource().get('v.value');
		let legalEntitiesOriginal = component.get('v.legalEntitiesOriginal');
		let updatedLegalEntities = [];
		for (let legalEntity of legalEntitiesOriginal) {
			// if (legalEntity.Name.includes(searchCriteria) || (legalEntity.hasOwnProperty('Nombre__c') && legalEntity.Nombre__c.includes(searchCriteria))) {
			if (legalEntity.RazonSocial__c.toUpperCase().includes(searchCriteria.toUpperCase())) {
				updatedLegalEntities.push(legalEntity);
			}
		}
		component.set('v.legalEntitiesCopy', updatedLegalEntities);
	},
	handleDirFiscales :  function(component, event, helper) {
		//console.log("cambio");
		//alert(event.getParam("value"));
		component.set('v.dataToSave.contrato.DireccionFiscal__c', event.getParam("value"));
		helper.changeButtonGroupState(component);
	},
	
	handleSelectedLegalEntity: function(component, event, helper) {
		console.log('handleSelectedLegalEntity(), event:', event);
		component.find('legal-entities').set('v.value', event.target.title);
		// Retrieving the selected legal entity's instance
		let selectedLegalEntity = component.get('v.legalEntitiesOriginal').find(legalEntity => {
			return legalEntity.Id === event.target.id;
		});
		component.set('v.selectedLegalEntityId', selectedLegalEntity.Id);
		component.set('v.selectedLegalEntity', selectedLegalEntity);
		component.set('v.selectedLegalRepresentativeId', selectedLegalEntity.mainLegalRepresentative.value);
		component.set('v.mainLegalRepresentative', selectedLegalEntity.mainLegalRepresentative.label);
		console.log('handleSelectedLegalEntity(), selectedLegalEntity:', selectedLegalEntity);
		// Determining and setting the corresponding subsidiaries
		component.set('v.subsidiaries', helper.getSubsidiaries(component.get('v.legalEntitiesCopy'), selectedLegalEntity.Id));
		component.set('v.subsidiariesCopy', helper.getSubsidiaries(component.get('v.legalEntitiesCopy'), selectedLegalEntity.Id));
		component.set('v.selectedSubsidiaries', []);
		// Setting the new data to save
		component.set('v.dataToSave.contrato.Entidad_Legal__c', selectedLegalEntity.Id);
		component.set('v.dataToSave.contrato.Contacto__c', selectedLegalEntity.mainLegalRepresentative.value);
		component.set('v.dataToSave.contrato.Entidad_Cuenta__c', selectedLegalEntity.legalEntityAccountId);
		component.set('v.dataToSave.oportunidad.Entidad_Legal__c', selectedLegalEntity.Id);
		component.set('v.dataToSave.oportunidad.Contacto__c', selectedLegalEntity.mainLegalRepresentative.value);
		component.set('v.dataToSave.oportunidad.Entidad_Cuenta__c', selectedLegalEntity.legalEntityAccountId);
		// Updating data to save: deleting all persisted contract - subsidiary records, if they exist
		if (component.get('v.persistedSubsidiaries')) {
			// Resetting contract - subsidiary array to save/update
			component.set('v.dataToSave.contratoFilial.paraGuardar', []);
			// Setting the persisted contract - subsidiary records to delete
			component.set('v.dataToSave.contratoFilial.paraEliminar', component.get('v.persistedSubsidiaries'));
		}
		console.log('handleSelectedLegalEntity(), dataToSave:', JSON.parse(JSON.stringify(component.get('v.dataToSave'))));
		// Changing the button group's state
		helper.changeButtonGroupState(component);
		// Hiding list box
		helper.showHideListbox(component, 'legal-entities');
		component.set('v.isMouseOnLegalEntities', false);
	},
	
	handleSelectedLrFromLe: function(component, event, helper) {
		// console.log('handleSelectedLrFromLe(), event:', event);
		// console.log('handleSelectedLrFromLe(), event...:', event.getSource().get('v.value'));
		let selectedLegalRepresentativeId = event.getSource().get('v.value');
		// console.log('selectedLegalRepresentativeId:', selectedLegalRepresentativeId);
		component.set('v.dataToSave.contrato.Contacto__c', selectedLegalRepresentativeId);
		component.set('v.dataToSave.oportunidad.Contacto__c', selectedLegalRepresentativeId);
		let selectedLegalRepresentative = component.get('v.selectedLegalEntity.legalRepresentatives').find(legalRepresentative => {
			return legalRepresentative.value === selectedLegalRepresentativeId;
		});
		component.set('v.mainLegalRepresentative', selectedLegalRepresentative.label);
		// Changing the button group's state
		helper.changeButtonGroupState(component);
	},
	
	handleSubsidiarySearch: function(component, event, helper) {
		let searchCriteria = event.getSource().get('v.value');
		let subsidiariesOriginal = component.get('v.subsidiaries');
		let updatedSubsidiaries = [];
		for (let subsidiary of subsidiariesOriginal) {
			// if (legalEntity.Name.includes(searchCriteria) || legalEntity.Nombre__c.includes(searchCriteria)) {
			if (subsidiary.RazonSocial__c.toUpperCase().includes(searchCriteria.toUpperCase())) {
				updatedSubsidiaries.push(subsidiary);
			}
		}
		component.set('v.subsidiariesCopy', updatedSubsidiaries);
	},
	
	handleSelectedSubsidiary: function(component, event, helper) {
		component.set('v.selectedSubsidiaryId', event.target.id);
		component.find('subsidiaries').set('v.value', event.target.title);
		// Hiding list box
		helper.showHideListbox(component, 'subsidiaries');
		component.set('v.isMouseOnSubsidiaries', false);
	},
	
	addSelectedSubsidiary: function(component, event, helper) {
		// It was selected a subsidiary?
		if (component.get('v.selectedSubsidiaryId')) {
			// Retrieving the selected subsidiary's instance
			let selectedSubsidiaries = component.get('v.selectedSubsidiaries');
			let selectedSubsidiary = component.get('v.subsidiaries').find(subsidiary => {
				return subsidiary.Id === component.get('v.selectedSubsidiaryId');
			});
			// Setting the main legal representative on the selected subsidiary, if it has more than one legal representative
			helper.setMainLegalRepresentative(selectedSubsidiary);
			selectedSubsidiaries.push(selectedSubsidiary);
			component.set('v.selectedSubsidiaries', selectedSubsidiaries);
			console.log('addSelectedSubsidiary(), selectedSubsidiaries:', selectedSubsidiaries);
			// Setting the new data to save
			let contractSubsToSave = [];
			for (let selectedSubsidiary of selectedSubsidiaries) {
				let tempPersistedSubsidiary = component.get('v.persistedSubsidiaries').find(persistedSubsidiary => {
					return persistedSubsidiary.Entidad_Cuenta__r.EntidadLegal__c === selectedSubsidiary.Id;
				});
				let currentId = tempPersistedSubsidiary ? tempPersistedSubsidiary.Id : null;
				contractSubsToSave.push({ Id: currentId, Contrato_2__c: component.get('v.dataToSave.contrato.Id'), Entidad_Cuenta__c: selectedSubsidiary.legalEntityAccountId });
				// Updating data to save: removing the selected persisted subsidiary record from the contract - subsidiary array to delete if it already includes it
				if (component.get('v.dataToSave.contratoFilial.paraEliminar')) {
					let updatedContractSubsToDelete = component.get('v.dataToSave.contratoFilial.paraEliminar').filter(contractSubToDelete => {
						return currentId !== contractSubToDelete.Id;
					});
					component.set('v.dataToSave.contratoFilial.paraEliminar', updatedContractSubsToDelete);
				}
			}
			component.set('v.dataToSave.contratoFilial.paraGuardar', contractSubsToSave);
			console.log('addSelectedSubsidiary(), dataToSave:', JSON.parse(JSON.stringify(component.get('v.dataToSave'))));
			// Updating the subsidiaries array without the selected one
			let updatedSubsidiaries = component.get('v.subsidiaries').filter(subsidiary => {
				return !(subsidiary.Id === component.get('v.selectedSubsidiaryId'));
			});
			component.set('v.subsidiaries', updatedSubsidiaries);
			component.set('v.subsidiariesCopy', updatedSubsidiaries);
			// Resetting subsidiaries search input's value and the selected subsidiary Id attribute 
			component.find('subsidiaries').set('v.value', '');
			component.set('v.selectedSubsidiaryId', '');
			// Changing the button group's state
			helper.changeButtonGroupState(component);
		} else {
			if (component.get('v.subsidiariesCopy').length > 0) {
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					duration: '10000',
					type: 'warning',
					title: 'Advertencia',
					message: 'Seleccione una Filial del campo Buscar Filial'
				});
				toastEvent.fire();
			} else {
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					duration: '10000',
					type: 'warning',
					title: 'Advertencia',
					message: 'No más Filiales que seleccionar'
				});
				toastEvent.fire();
			}
		}
	},
	
	handleDeselectedSubsidiary: function(component, event, helper) {
		// Retrieving the deselected subsidiary
		let deselectedSubsidiaryId = event.getSource().get('v.name');
		// Updating the selected subsidiaries array without the deselected one
		let updatedSelectedSubsidiaries = component.get('v.selectedSubsidiaries').filter(subsidiary => {
			return !(subsidiary.Id === deselectedSubsidiaryId);
		});
		component.set('v.selectedSubsidiaries', updatedSelectedSubsidiaries);
		// Updating the subsidiaries array with the deselected one 
		let allCurrentSubsidiaries = helper.getSubsidiaries(component.get('v.legalEntitiesCopy'), component.get('v.selectedLegalEntityId'));
		let updatedSubsidiaries = component.get('v.subsidiaries');
		for (let currentSubsidiary of allCurrentSubsidiaries) {
			if (currentSubsidiary.Id === deselectedSubsidiaryId) {
				console.log('currentDeselectedSubsidiary:', currentSubsidiary);
				updatedSubsidiaries.push(currentSubsidiary);
				// Updating the data to save: discarding records to save, if they exist
				if (component.get('v.dataToSave.contratoFilial.paraGuardar')) {
					let updatedContractSubsToSave = component.get('v.dataToSave.contratoFilial.paraGuardar').filter(contractSubToSave => {
						return contractSubToSave.Entidad_Cuenta__c !== currentSubsidiary.legalEntityAccountId;
					});
					console.log('updatedContractSubsToSave:', updatedContractSubsToSave);
					component.set('v.dataToSave.contratoFilial.paraGuardar', updatedContractSubsToSave);
				}
			}
		}
		component.set('v.subsidiaries', updatedSubsidiaries);
		component.set('v.subsidiariesCopy', updatedSubsidiaries);
		// Updating the data to save: records to delete
		// Finding the deselected subsidiary's instance
		let deselectedSubsidiary = updatedSubsidiaries.find(subsidiary => {
			return subsidiary.Id === deselectedSubsidiaryId;
		});
		// Retrieving the current array of subsidiaries to delete, if it exist. Otherwise, create a new array
		let contractSubsToDelete = component.get('v.dataToSave.contratoFilial.paraEliminar') ? component.get('v.dataToSave.contratoFilial.paraEliminar') : [];
		let tempPersistedSubsidiary = component.get('v.persistedSubsidiaries').find(persistedSubsidiary => {
			return persistedSubsidiary.Entidad_Cuenta__r.EntidadLegal__c === deselectedSubsidiary.Id;
		});
		let currentId = tempPersistedSubsidiary ? tempPersistedSubsidiary.Id : null;
		if (currentId) {
			contractSubsToDelete.push({ Id: currentId, Contrato_2__c: component.get('v.dataToSave.contrato.Id'), Entidad_Cuenta__c: deselectedSubsidiary.legalEntityAccountId });
			component.set('v.dataToSave.contratoFilial.paraEliminar', contractSubsToDelete);
		}
		console.log('addSelectedSubsidiary(), dataToSave:', JSON.parse(JSON.stringify(component.get('v.dataToSave'))));
		// Changing the button group's state
		helper.changeButtonGroupState(component);
	},
	
	handleShowHideLEListbox: function(component, event, helper) {
		if (event.getSource) {
			if (!component.get('v.isMouseOnLegalEntities')) {
				helper.showHideListbox(component, event.getSource().getLocalId());
			}
		}
	},
	
	handleShowHideSubListbox: function(component, event, helper) {
		if (event.getSource) {
			if (!component.get('v.isMouseOnSubsidiaries')) {
				helper.showHideListbox(component, event.getSource().getLocalId());
			}
		}
	},
	
	refreshThisView: function(component, event, helper) {
		console.log('refreshThisView(), event.getParams():', JSON.parse(JSON.stringify(event.getParams())));
		let { oldValue, value } = event.getParams();
		console.log(oldValue, value);
		if (!oldValue && value) {
			helper.invokeInit(component);
		}
	},
	
	handleMouseOnLegalEntities: function(component, event, helper) {
		component.set('v.isMouseOnLegalEntities', true);
	},
	
	handleMouseOutsideLegalEntities: function(component, event, helper) {
		if (component.get('v.isMouseOnLegalEntities')) {
			component.set('v.isMouseOnLegalEntities', false);
		}
	},
	
	handleMouseOnSubsidiaries: function(component, event, helper) {
		component.set('v.isMouseOnSubsidiaries', true);
	},
	
	handleMouseOutsideSubsidiaries: function(component, event, helper) {
		if (component.get('v.isMouseOnSubsidiaries')) {
			component.set('v.isMouseOnSubsidiaries', false);
		}
	},
	
	toggleModal: function(component, event, helper) {
		helper.showHideModal(component);
	}
})