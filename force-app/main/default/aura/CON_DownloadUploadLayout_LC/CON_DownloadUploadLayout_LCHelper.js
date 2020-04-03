({
	handleFileUpload: function(component, parentId, attachmentId, name, encodedString, type) {
		// Constants
		const MAX_CHUNK_SIZE = 1000000;
		const FUNC_NAME = 'handleFileUpload()';
		const ACTION_SUCCESS_STATE = 'SUCCESS';
		// Constants
		// Variables
		let startPosition = 0;
		let endPosition = Math.min(encodedString.length, (startPosition + MAX_CHUNK_SIZE));
		let isInsertOrUpdate = true;
		// Variables
		if (attachmentId !== null) {
			this.createActionPromise(component, {
				name: 'deleteLayoutFAC',
				params: {
					attachId: attachmentId
				}
			})
			.then(response => {
				console.log(FUNC_NAME, ', 1st Callback, response:', response);
				let { getState, getError, getReturnValue } = response;
				if (getState() === ACTION_SUCCESS_STATE) {
					let { errors, id, isSuccess } = getReturnValue();
					if (isSuccess) {
						this.uploadFile(component, parentId, undefined, name, encodedString, type, startPosition, endPosition, isInsertOrUpdate);
					} else {
						return Promise.reject(new Error('Ocurrió un problema al eliminar el archivo:' + errors));
					}
				} else {
					return Promise.reject(new Error('Ocurrió un problema al eliminar el archivo:' + getError()));
				}
			})
			.catch(error => {
				component.set('v.isSpinnerVisible', false);
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					mode: 'sticky',
					type: 'error',
					title: '¡Error!',
					message: 'Nombre del Error: ' + error.name + '. Mensaje: ' + error.message
				});
				toastEvent.fire();
			});
		} else {
			this.uploadFile(component, parentId, attachmentId, name, encodedString, type, startPosition, endPosition, isInsertOrUpdate);
		}
	},
	
	uploadFile: function(component, parentId, attachmentId, name, encodedString, type, startPosition, endPosition, isInsertOrUpdate) {
		console.log(arguments);
		// Constants
		const FUNC_NAME = 'uploadFile()';
		const MAX_CHUNK_SIZE = 1000000;
		const ACTION_SUCCESS_STATE = 'SUCCESS';
		// Constants
		let chunckToSend = encodedString.substring(startPosition, endPosition);
		this.createActionPromise(component, {
			name: 'saveLayoutAttachment',
			params: {
				attachmentId,
				parentId,
				name,
				encodedString: chunckToSend,
				type,
				isInsertOrUpdate
			}
		})
		.then(response => {
			console.log(FUNC_NAME, ', 1st Callback, response:', response);
			let { getState, getError, getReturnValue } = response;
			if (getState() === ACTION_SUCCESS_STATE) {
				let { errors, id, isCreated, isSuccess } = getReturnValue();
				startPosition = endPosition;
				console.log(FUNC_NAME, ', startPosition:', startPosition);
				endPosition = Math.min(encodedString.length, (startPosition + MAX_CHUNK_SIZE));
				console.log(FUNC_NAME, ', endPosition:', endPosition);
				if (startPosition < endPosition) {
					isInsertOrUpdate = false;
					this.uploadFile(component, parentId, id, name, encodedString, type, startPosition, endPosition, isInsertOrUpdate);
				} else {
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
				}
			} else {
				return Promise.reject(new Error('Ocurrió un problema al cargar el archivo:' + getError()));
			}
		})
		.catch(error => {
			component.set('v.isSpinnerVisible', false);
			let toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				mode: 'sticky',
				type: 'error',
				title: '¡Error!',
				message: 'Nombre del Error: ' + error.name + '. Mensaje: ' + error.message
			});
			toastEvent.fire();
		});
	},
	
	createActionPromise: function(component, action) {
		return new Promise($A.getCallback((resolve, reject) => {
			let a = component.get('c.' + action.name);
			a.setParams(action.params);
			a.setCallback(this, (response) => {
				console.log('this:', this);
				// console.log('createActionPromise(), response:', response);
				console.log('createActionPromise(), response.getState():', response.getState());
				// console.log('createActionPromise(), response.getReturnValue():', response.getReturnValue());
				if (response.getState() === 'SUCCESS') {
					let returnedValue = response.getReturnValue();
					if (!('exceptionTypeName' in returnedValue)) {
						resolve(response);
					} else {
						reject(new Error('Error en "helper.createActionPromise()":' + returnedValue.message + ', Rastreo de Pila: ' + returnedValue.stackTraceString));
					}
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(a);
		}));
	},
	
	showError: function(error, customErrorMessage, isToastVisible) {
		customErrorMessage = customErrorMessage ? customErrorMessage + '. ' : '';
		isToastVisible = (isToastVisible !== undefined) ? isToastVisible : true;
		try {
			if ((typeof error) === 'object') {
				console.log('showError(), error:', error);
				if (!isToastVisible) {
					let toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						mode: 'sticky',
						type: 'error',
						title: '¡Error!',
						message: customErrorMessage + 'Nombre del Error: ' + error.name + '. Mensaje: ' + error.message
					});
					toastEvent.fire();
				}
			} else {
				throw new Error('Error en "helper.showError()": El argumento "error" debe ser de tipo "Object"');
			}
		} catch(e) {
			console.log('e:', e);
		}
	},
        
    bloqueo: function(component,event,idoportunidad){       
        var action = component.get("c.bloqueo");
        
        action.setParams({
            idoportunidad:idoportunidad
		});
        action.setCallback(this, function(response) {
            
        });
		$A.enqueueAction(action);
    }

})