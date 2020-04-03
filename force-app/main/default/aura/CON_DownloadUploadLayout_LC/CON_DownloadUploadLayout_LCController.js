({
	downloadLayout: function(component, event, helper) {
		'use strict';
		console.clear();
		// Constants
		const APINAME_PERS_TARJ = 'Personalizacion_de_Tarjetas__c';
		const APINAME_DIREC_AUX = 'DireccionesAuxiliares__c';
		const FILE_NAME_DIR_AUX = 'Direcciones Auxiliares';
		// Constants
		// Variables
		let isToastVisible = true;
		// Variables
		console.log('downloadLayout(), event.getSource().get(\'v.name\')', event.getSource().get('v.name'));
		try {
			if (event.getSource().get('v.name') === APINAME_PERS_TARJ) {
				let layoutLabel = '';
				helper.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT Id, Label FROM PersonalizacionTarjetas__mdt WHERE CodigoProductos__c LIKE \'%' + component.get('v.productCode') + '%\' LIMIT 1'
					}
				})
				.then(response => {
					// console.log('downloadLayout(), 1st response:', response);
					// console.log('downloadLayout(), 1st response.getReturnValue():', response.getReturnValue());
					let { Label } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', Label: '' };
					// console.log('Label:', Label);
					layoutLabel = Label;
					if (Label) {
						return helper.createActionPromise(component, {
							name: 'executeQuery',
							params: {
								query: 'SELECT Id, (SELECT Id FROM ContentVersions LIMIT 1) FROM ContentDocument WHERE Title LIKE \'' + Label + '%\' LIMIT 1'
							}
						});
					} else {
						return Promise.reject(new Error(`El código de producto "${component.get('v.productCode')}" no está asociado con ningún layout de acuerdo al tipo de metadatos personalizados "Personalización Tarjetas"`));
					}
				})
				.then(response => {
					// console.log('downloadLayout(), 2nd response:', response);
					// console.log('downloadLayout(), 2nd response.getReturnValue():', response.getReturnValue());
					let { ContentVersions } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', ContentVersions: [] };
					// console.log('ContentVersions:', ContentVersions);
					if (ContentVersions && Array.isArray(ContentVersions) && (ContentVersions.length > 0)) {
						let { Id } = ContentVersions[0];
						// console.log('Id:', Id);
						let downloadEvent = $A.get('e.force:navigateToURL');
						downloadEvent.setParams({
							url: '/sfc/servlet.shepherd/version/download/' + Id + '?operationContext=S1'
						});
						downloadEvent.fire();
					} else {
						return Promise.reject(new Error(`No se encontró ningún layout con una etiqueta similar a "${layoutLabel}" en el objeto "Archivo"`));
					}
				})
				.catch(error => {
					helper.showError(error);
				});
			} else if (event.getSource().get('v.name') === APINAME_DIREC_AUX) {
				helper.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.accountId') + '\' AND Name LIKE \'' + FILE_NAME_DIR_AUX + '%\' LIMIT 1'
					}
				})
				.then(response => {
					console.log('downloadLayout(), 1st response');
					console.log('downloadLayout(), response.getReturnValue():', response.getReturnValue());
					if (response && response.getReturnValue && response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
						let { Id, Name } = response.getReturnValue()[0];
						// let downloadEvent = $A.get('e.force:navigateToURL');
						// downloadEvent.setParams({
						// 	url: '/servlet/servlet.FileDownload?file=' + Id + '&operationContext=S1'
						// });
						// downloadEvent.fire();
						window.open('/servlet/servlet.FileDownload?file=' + Id + '&operationContext=S1');
						isToastVisible = false;
						return Promise.reject(new Error('Fin de la cola de promesas'));
					} else {
						return helper.createActionPromise(component, {
							name: 'executeQuery',
							params: {
								query: 'SELECT Id, (SELECT Id FROM ContentVersions) FROM ContentDocument WHERE Title LIKE \'%' + FILE_NAME_DIR_AUX + '%\' LIMIT 1'
							}
						});
					}
				})
				.then(response => {
					// console.log('downloadLayout(), 2nd response.getReturnValue():', response.getReturnValue());
					let { ContentVersions } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', ContentVersions: [] };
					// console.log('ContentVersions:', ContentVersions);
					if (ContentVersions && Array.isArray(ContentVersions) && (ContentVersions.length > 0)) {
						let { Id } = ContentVersions[0];
						let downloadEvent = $A.get('e.force:navigateToURL');
						downloadEvent.setParams({
							url: '/sfc/servlet.shepherd/version/download/' + Id + '?operationContext=S1'
						});
						downloadEvent.fire();
					} else {
						return Promise.reject(new Error(`No se encontró ningún layout con una etiqueta similar a "${FILE_NAME_DIR_AUX}" en el objeto "Archivo"`));
					}
				})
				.catch(error => {
					helper.showError(error, isToastVisible);
				});
			}
		} catch(e) {
			helper.showError(e);
		}
	},
	
	/* uploadLayout: function(component, event, helper) {
		'use strict';
		console.clear();
		// Constants
		const ERROR_ORIG = 'Error en "uploadLayout()"';
		const APINAME_PERS_TARJ = 'Personalizacion_de_Tarjetas__c';
		const APINAME_DIREC_AUX = 'DireccionesAuxiliares__c';
		const FILE_NAME_DIR_AUX = 'Direcciones Auxiliares';
		const FILE_EXT = '.' + event.getSource().get('v.files')[0].name.split('.').pop();
		// Constants
		// Variables
		let attachment = {};
		let layoutTitle = '';
		// Variables
		try {
			component.set('v.isSpinnerVisible', true);
			if (event.getSource().get('v.name') === APINAME_PERS_TARJ) {
				let layoutLabel = '';
				helper.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT Id, Label FROM PersonalizacionTarjetas__mdt WHERE CodigoProductos__c LIKE \'%' + component.get('v.productCode') + '%\' LIMIT 1'
					}
				})
				.then(response => {
					// console.log('uploadLayout(), 1st response:', response);
					console.log('uploadLayout(), 1st response.getReturnValue():', response.getReturnValue());
					let { Label } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', Label: '' };
					layoutLabel = Label;
					if (Label) {
						return helper.createActionPromise(component, {
							name: 'executeQuery',
							params: {
								query: 'SELECT Id, Title FROM ContentDocument WHERE Title LIKE \'%' + Label + '%\' LIMIT 1'
							}
						});
					} else {
						return Promise.reject(new Error(`El código de producto "${component.get('v.productCode')}" no está asociado con ningún layout de acuerdo al tipo de metadatos personalizados "Personalización Tarjetas"`));
					}
				})
				.then(response => {
					// console.log('uploadLayout(), 2nd response:', response);
					console.log('uploadLayout(), 2nd response.getReturnValue():', response.getReturnValue());
					if (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
						component.set('v.contentDocument', response.getReturnValue()[0]);
						let { Title } = response.getReturnValue()[0];
						layoutTitle = Title;
						if (Title) {
							return helper.createActionPromise(component, {
								name: 'executeQuery',
								params: {
									query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.opportunityId') + '\' AND Name LIKE \'%' + Title + '%\''
								}
							});
						} else {
							return Promise.reject(new Error(`No se encontró ningún layout con una etiqueta similar a "${layoutLabel}" en el objeto "Archivo"`));
						}
					} else {
						return Promise.reject(new Error(`No se encontró ningún layout con una etiqueta similar a "${layoutLabel}" en el objeto "Archivo"`));
					}
				})
				.then(response => {
					// console.log('uploadLayout(), 3rd response:', response);
					console.log('uploadLayout(), 3rd response.getReturnValue():', response.getReturnValue());
					attachment = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: null };
					return new Promise((resolve, reject) => {
						let fr = new FileReader();
						fr.readAsDataURL(event.getSource().get('v.files')[0]);
						fr.onload = () => {
							let tempResult = fr.result;
							tempResult = tempResult.split(',');
							resolve(tempResult[1]);
						};
						fr.onerror = () => {
							reject(new Error('Ocurrió un problema al leer el archivo'));
						}
					});
				})
				.then(response => {
					console.log('uploadLayout(), 4th response. attachment:', attachment);
					// console.log('uploadLayout(), 4th response:', response, ', attachment:', attachment);
					return helper.createActionPromise(component, {
						name: 'saveLayout',
						params: {
							attachId: attachment.Id,
							parentId: component.get('v.opportunityId'),
							attachName: layoutTitle,
							attachBody: response,
							docType: FILE_EXT
						}
					});
				})
				.then(response => {
					// console.log('uploadLayout(), 5th response:', response);
					console.log('uploadLayout(), 5th response.getReturnValue():', response.getReturnValue());
					let { id, isSuccess } = (response.getReturnValue() && ((typeof response.getReturnValue()) == 'object')) ? response.getReturnValue() : { isSuccess: false };
					console.log('id:', id + ', isSuccess:', isSuccess);
					if (isSuccess) {
						component.set('v.layoutId', id);
						component.set('v.isSpinnerVisible', false);
						let uploadInput = component.find('uploadInput');
						uploadInput.set('v.value', '');
						// let toastEvent = $A.get('e.force:showToast');
						// toastEvent.setParams({
						// 	duration: '10000',
						// 	type: 'success',
						// 	title: '¡Éxito!',
						// 	message: 'El archivo ha sido cargado correctamente'
						// });
						// toastEvent.fire();
						// Invoking the CON_ContractsContainer_LC's save method
						let invokeSaveEvent = component.getEvent('invokeSaveMethod');
						invokeSaveEvent.fire();
					} else {
						throw new Error('Ocurrió un problema al cargar el archivo');
					}
				})
				.catch((error) => {
					helper.showError(error, ERROR_ORIG);
				});
			} else if (event.getSource().get('v.name') === APINAME_DIREC_AUX) {
				helper.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.accountId') + '\' AND Name LIKE \'%' + FILE_NAME_DIR_AUX + FILE_EXT + '%\''
					}
				})
				.then(response => {
					console.log('uploadLayout(), 1st response.getReturnValue():', response.getReturnValue());
					attachment = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: null };
					return new Promise((resolve, reject) => {
						let fr = new FileReader();
						fr.readAsDataURL(event.getSource().get('v.files')[0]);
						fr.onload = () => {
							let tempResult = fr.result;
							tempResult = tempResult.split(',');
							resolve(tempResult[1]);
						};
						fr.onerror = () => {
							reject(new Error('Ocurrió un problema al leer el archivo'));
						}
					});
				})
				.then(response => {
					console.log('uploadLayout(), 2nd response. attachment:', attachment)
					// console.log('uploadLayout(), 2nd response:', response);
					return helper.createActionPromise(component, {
						name: 'saveLayout',
						params: {
							attachId: attachment.Id,
							parentId: component.get('v.accountId'),
							attachName: FILE_NAME_DIR_AUX,
							attachBody: response,
							docType: FILE_EXT
						}
					});
				})
				.then(response => {
					console.log('uploadLayout(), 3rd response.getReturnValue():', response.getReturnValue());
					let { id, isSuccess } = (response.getReturnValue() && ((typeof response.getReturnValue()) == 'object')) ? response.getReturnValue() : { isSuccess: false };
					if (isSuccess) {
						component.set('v.layoutId', id);
						component.set('v.isSpinnerVisible', false);
						let uploadInput = component.find('uploadInput');
						uploadInput.set('v.value', '');
						// let toastEvent = $A.get('e.force:showToast');
						// toastEvent.setParams({
						// 	duration: '10000',
						// 	type: 'success',
						// 	title: '¡Éxito!',
						// 	message: 'El archivo ha sido cargado correctamente'
						// });
						// toastEvent.fire();
						// Invoking the CON_ContractsContainer_LC's save method
						let invokeSaveEvent = component.getEvent('invokeSaveMethod');
						invokeSaveEvent.fire();
					} else {
						throw new Error('Ocurrió un problema al cargar el archivo');
					}
				})
				.catch((error) => {
					helper.showError(error, ERROR_ORIG);
				});
			}
		} catch(e) {
			helper.showError(e, ERROR_ORIG);
		}
	}, */
	
	handleUploadLayout: function(component, event, helper) {
       // component.set('v.obligatorio',true);   
		console.clear();
		// Constants
		const ERROR_ORIG = 'Error en "uploadLayout()"';
		const APINAME_PERS_TARJ = 'Personalizacion_de_Tarjetas__c';
		const APINAME_DIREC_AUX = 'DireccionesAuxiliares__c';
		const FILE_NAME_DIR_AUX = 'Direcciones Auxiliares';
		const MAX_FILE_SIZE = 6000000;
		const FILE_EXT = '.' + event.getSource().get('v.files')[0].name.split('.').pop();
		// Constants
		// Variables
		let attachment = {};
		let layoutTitle = '';
		let uploadedFile;
		// Variables
		try {
			component.set('v.isSpinnerVisible', true);
			if (event.getSource().get('v.name') === APINAME_PERS_TARJ) {
				let layoutLabel = '';
				helper.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT Id, Label FROM PersonalizacionTarjetas__mdt WHERE CodigoProductos__c LIKE \'%' + component.get('v.productCode') + '%\' LIMIT 1'
					}
				})
				.then(response => {
					// console.log('uploadLayout(), 1st response:', response);
					console.log('uploadLayout(), 1st response.getReturnValue():', response.getReturnValue());
					let { Label } = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: '', Label: '' };
					layoutLabel = Label;
					if (Label) {
						return helper.createActionPromise(component, {
							name: 'executeQuery',
							params: {
								query: 'SELECT Id, Title FROM ContentDocument WHERE Title LIKE \'%' + Label + '%\' LIMIT 1'
							}
                      
						});
					} else {
						return Promise.reject(new Error(`El código de producto "${component.get('v.productCode')}" no está asociado con ningún layout de acuerdo al tipo de metadatos personalizados "Personalización Tarjetas"`));
                       			}
				})
				.then(response => {
					// console.log('uploadLayout(), 2nd response:', response);
					console.log('uploadLayout(), 2nd response.getReturnValue():', response.getReturnValue());
					if (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) {
						component.set('v.contentDocument', response.getReturnValue()[0]);
						let { Title } = response.getReturnValue()[0];
						layoutTitle = Title;
						if (Title) {
							return helper.createActionPromise(component, {
								name: 'executeQuery',
								params: {
									query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.opportunityId') + '\' AND Name LIKE \'%' + Title + '%\''
								}
							});
        				helper.bloqueo(component,component.get('v.opportunityId'));	
						} else {
							return Promise.reject(new Error(`No se encontró ningún layout con una etiqueta similar a "${layoutLabel}" en el objeto "Archivo"`));
                    		
						}
					} else {
						return Promise.reject(new Error(`No se encontró ningún layout con una etiqueta similar a "${layoutLabel}" en el objeto "Archivo"`));
						
					}
				})
				.then(response => {
					// console.log('uploadLayout(), 3rd response:', response);
					console.log('uploadLayout(), 3rd response.getReturnValue():', response.getReturnValue());
					attachment = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: null };
					return new Promise((resolve, reject) => {
						let fr = new FileReader();
						uploadedFile = event.getSource().get('v.files')[0];
						// console.log('typeof uploadedFile', typeof uploadedFile);
						fr.readAsDataURL(uploadedFile);
						fr.onload = () => {
							let frResult = fr.result;
							frResult = frResult.split(',');
							resolve(frResult[1]);
                    		
						};
						fr.onerror = () => {
							reject(new Error('Ocurrió un problema al leer el archivo'));
                    		
						}
					});
				})
				.then(response => {
					console.log('uploadLayout(), 4th Callback');
					// console.log('uploadLayout(), 4th response. attachment:', attachment);
					// console.log('uploadLayout(), 4th response:', response, ', attachment:', attachment);
					console.log('response.length:', response.length);
					if (uploadedFile.size < MAX_FILE_SIZE) {
						helper.handleFileUpload(component, component.get('v.opportunityId'), attachment.Id, layoutTitle, response, FILE_EXT);
						
                } else {
						return Promise.reject(new Error('El archivo que está intentando subir pesa más de 4 MB'));
                        
					}
					/* return helper.createActionPromise(component, {
						name: 'saveLayout',
						params: {
							attachId: attachment.Id,
							parentId: component.get('v.opportunityId'),
							attachName: layoutTitle,
							attachBody: response,
							docType: FILE_EXT
						}
					}); */
				})
				/* .then(response => {
					// console.log('uploadLayout(), 5th response:', response);
					console.log('uploadLayout(), 5th response.getReturnValue():', response.getReturnValue());
					let { id, isSuccess } = (response.getReturnValue() && ((typeof response.getReturnValue()) == 'object')) ? response.getReturnValue() : { isSuccess: false };
					console.log('id:', id + ', isSuccess:', isSuccess);
					if (isSuccess) {
						component.set('v.layoutId', id);
						component.set('v.isSpinnerVisible', false);
						let uploadInput = component.find('uploadInput');
						uploadInput.set('v.value', '');
						// let toastEvent = $A.get('e.force:showToast');
						// toastEvent.setParams({
						// 	duration: '10000',
						// 	type: 'success',
						// 	title: '¡Éxito!',
						// 	message: 'El archivo ha sido cargado correctamente'
						// });
						// toastEvent.fire();
						// Invoking the CON_ContractsContainer_LC's save method
						let invokeSaveEvent = component.getEvent('invokeSaveMethod');
						invokeSaveEvent.fire();
					} else {
						throw new Error('Ocurrió un problema al cargar el archivo');
					}
				}) */
				.catch((error) => {
					component.set('v.isSpinnerVisible', false);
					helper.showError(error, ERROR_ORIG);
				});
			} else if (event.getSource().get('v.name') === APINAME_DIREC_AUX) {
				helper.createActionPromise(component, {
					name: 'executeQuery',
					params: {
						query: 'SELECT Id, Name FROM Attachment WHERE ParentId = \'' + component.get('v.accountId') + '\' AND Name LIKE \'%' + FILE_NAME_DIR_AUX + FILE_EXT + '%\''
					}
				})
				.then(response => {
					console.log('uploadLayout(), 1st response.getReturnValue():', response.getReturnValue());
					attachment = (response.getReturnValue() && Array.isArray(response.getReturnValue()) && (response.getReturnValue().length > 0)) ? response.getReturnValue()[0] : { Id: null };
					return new Promise((resolve, reject) => {
						let fr = new FileReader();
						uploadedFile = event.getSource().get('v.files')[0];
						fr.readAsDataURL(uploadedFile);
						fr.onload = () => {
							let tempResult = fr.result;
							tempResult = tempResult.split(',');
							resolve(tempResult[1]);
						};
						fr.onerror = () => {
							reject(new Error('Ocurrió un problema al leer el archivo'));
						}
					});
				})
				.then(response => {
					console.log('uploadLayout(), 2nd response. attachment:', attachment)
					// console.log('uploadLayout(), 2nd response:', response);
					console.log('uploadedFile.size:', uploadedFile.size);
					if (uploadedFile.size < MAX_FILE_SIZE) {
						helper.handleFileUpload(component, component.get('v.accountId'), attachment.Id, FILE_NAME_DIR_AUX, response, FILE_EXT);
					} else {
						return Promise.reject(new Error('El archivo que está intentando subir pesa más de 4 MB'));
					}
					/* return helper.createActionPromise(component, {
						name: 'saveLayout',
						params: {
							attachId: attachment.Id,
							parentId: component.get('v.accountId'),
							attachName: FILE_NAME_DIR_AUX,
							attachBody: response,
							docType: FILE_EXT
						}
					}); */
				})
				/* .then(response => {
					console.log('uploadLayout(), 3rd response.getReturnValue():', response.getReturnValue());
					let { id, isSuccess } = (response.getReturnValue() && ((typeof response.getReturnValue()) == 'object')) ? response.getReturnValue() : { isSuccess: false };
					if (isSuccess) {
						component.set('v.layoutId', id);
						component.set('v.isSpinnerVisible', false);
						let uploadInput = component.find('uploadInput');
						uploadInput.set('v.value', '');
						// let toastEvent = $A.get('e.force:showToast');
						// toastEvent.setParams({
						// 	duration: '10000',
						// 	type: 'success',
						// 	title: '¡Éxito!',
						// 	message: 'El archivo ha sido cargado correctamente'
						// });
						// toastEvent.fire();
						// Invoking the CON_ContractsContainer_LC's save method
						let invokeSaveEvent = component.getEvent('invokeSaveMethod');
						invokeSaveEvent.fire();
					} else {
						throw new Error('Ocurrió un problema al cargar el archivo');
					}
				}) */
				.catch((error) => {
					component.set('v.isSpinnerVisible', false);
					helper.showError(error, ERROR_ORIG);
				});
			}
		} catch(e) {
			helper.showError(e, ERROR_ORIG);
		}
	}
})