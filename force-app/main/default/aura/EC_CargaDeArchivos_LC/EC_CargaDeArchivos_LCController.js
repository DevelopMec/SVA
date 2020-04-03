({
	/* finishedLoad : function(component, event, helper) {
		console.log('finishedLoad:', arguments);
	}, */
	
	init : function(component, event, helper) {
		// console.clear();
		// console.log('ctcLightning: ', ctcLightning);
		console.log(`[ ${component.getName()} ]`);
		// Helper calls
		helper.getContacts(component);
		helper.getRecordTypeEL(component);
		// Helper calls
	},
	
	// uploadAttachment : function(component, event, helper) {
	// 	var MAX_FILE_SIZE_S = 6000000;
	// 	var toastEvent = $A.get("e.force:showToast");
	// 	var pressedButton = event.getSource();
	// 	//console.log("uploadFile, pressedButton:", pressedButton);
	// 	var name = pressedButton.get("v.name").split("-");
	// 	var attachmentName = name[0];
	// 	var oppFieldName = name[1];

	// 	if(pressedButton.get("v.files")[0].name.indexOf('.pdf') != -1){
	// 		component.set("v.loading", true);
	// 		console.log("attachmentName:", attachmentName, ", oppFieldName:", oppFieldName);
	// 		console.log("uploadAttachment, pressedButton.get(\"v.files\"):", pressedButton.get("v.files")[0].name);

	// 		attachmentName = attachmentName.replace(/\s/g, "_");
					
	// 		var uploadedFile = pressedButton.get("v.files")[0];
	//           console.log('uploadedFile:',uploadedFile.size);

			

	// 		/*if (uploadedFile.size <= MAX_FILE_SIZE_S) {

	// 			toastEvent.setParams({
	// 				"duration": "2000",
	// 				"type": "warning",
	// 				"title": "Advertencia",
	// 				"message": "El archivo que está intentado subir tiene un tamaño superior a los 25MB. Reduzca el tamaño del archivo y vuelva a intentarlo"
	// 		});
	// 			component.set("v.loading", false);
	// 			toastEvent.fire();

	// 			return;

	// 		}	*/			
				
	// 		var fr = new FileReader();
	// 		fr.readAsDataURL(uploadedFile);

	//         fr.onload = function() {
	//             var fileContents = fr.result;
	//               console.log('fileContents: ',fileContents.length);
	//     	    var base64Mark = 'base64,';
	//             var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

	//             fileContents = fileContents.substring(dataStart);
	//             if(fileContents.length > MAX_FILE_SIZE_S) {
	// 				toastEvent.setParams({
	// 					"duration": "2000",
	// 					"type": "danger",
	// 					"title": "Advertencia",
	// 					"message": "El archivo que está intentado subir tiene un tamaño superior a los 4MB. Reduzca el tamaño del archivo y vuelva a intentarlo"
	// 				});
	// 				component.set("v.loading", false);
	// 				toastEvent.fire();
	// 				return;

	//             } else {
	//     	    	helper.uploadA(component, uploadedFile, fileContents, attachmentName, oppFieldName, null, true);
	//             }

	//             /*console.log('component:',component)
	//             console.log('uploadedFile:',uploadedFile)
	//             console.log('fileContents:',fileContents)
	//             console.log('attachmentName:',attachmentName)
	//             console.log('oppFieldName:',oppFieldName)*/
					
	//         };
														
	// 	}else{
	// 		toastEvent.setParams({
	// 			"duration": "2000",
	// 			"type": "warning",
	// 			"title": "Advertencia",
	// 			"message": "Solo se admiten archivos en formato PDF"
	// 		});
	// 		toastEvent.fire();
	// 	}
	// },
	
	deleteAttach : function(component, event, helper) {
		component.set("v.loading", true);
		// var pressedButton = event.getSource();
		// var name = pressedButton.get("v.name").split("-");
		// var documentId = name[0];
		// var oppFieldName = name[1];
		let [ documentId, elFieldName ] = event.getSource().get('v.name').split('-');
		console.log("deleteAttach(), documentId:", documentId, ", elFieldName:", elFieldName);
		// helper.deleteAttachmentEL(component, documentId, elFieldName);
		helper.deleteAttachmentEL2(component, documentId, elFieldName);
	},
	
	downloadAttachment : function(component, event, helper) {
		// var url = location.href;
		// console.log("downloadAttachment, url:", url);
		var pressedButton = event.getSource();
		var attachmentId = pressedButton.get("v.name");
		var urlEvent = $A.get("e.force:navigateToURL");
		
		console.log('downloadAttachment() ContentDocument ID;', attachmentId);
		
		/*urlEvent.setParams({
			"url": "../servlet/servlet.FileDownload?file=" + attachmentId+ "&operationContext=S1"
		});
		
		urlEvent.fire();*/
		
		// window.open("/servlet/servlet.FileDownload?file=" + attachmentId+ "&operationContext=S1");
		// window.open("/sfc/servlet.shepherd/version/download/" + attachmentId);
		window.open("/sfc/servlet.shepherd/document/download/" + attachmentId);
	},
	
	/* editAttachment : function(component, event, helper) {
		
		var MAX_FILE_SIZE = 6000000;
		var toastEvent = $A.get("e.force:showToast");
		//var pressedButton = event.getSource();
		//var attachmentId = pressedButton.get("v.name");
		var input = event.target;
		console.log("editAttachment, input -> : ", input);
		var attachmentId = input.name;
		console.log("\n\neditAttachment, attachmentId:", attachmentId);
		//console.log("input:", input);
		//console.log("input.files:", input.files);
		var uploadedFile = input.files[0];
		// console.log("editAttachment, uploadedFile:", uploadedFile);
		// console.log("editAttachment, uploadedFile.size:", uploadedFile.size);
		if (uploadedFile.size <= MAX_FILE_SIZE) {
			component.set("v.loading", true);
			var fr = new FileReader();
			fr.readAsDataURL(uploadedFile);
			fr.onload = function() {

				var fileContents = fr.result;
								console.log('fileContents: ',fileContents.length);
						var base64Mark = 'base64,';
							var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

							fileContents = fileContents.substring(dataStart);

							helper.uploadA(component, uploadedFile, fileContents, 'test', 'test', attachmentId, true);

				document.getElementsByName(attachmentId)[0].value = '';
			};
			fr.onerror = function(error) {
				console.log("fr.onerror, error:", error);
			};
		} else {
			toastEvent.setParams({
				"duration": "2000",
				"type": "warning",
				"title": "Advertencia",
				"message": "El archivo que está intentado subir tiene un tamaño superior a los 4MB. Reduzca el tamaño del archivo y vuelva a intentarlo"
			});
			toastEvent.fire();
		}
		// component.set("v.loading", true);
		// var MAX_FILE_SIZE = 4000000;
		// var toastEvent = $A.get("e.force:showToast");
		// //var pressedButton = event.getSource();
		// //var attachmentId = pressedButton.get("v.name");
		// //console.log("editAttachment, attachmentId:", attachmentId);
		// var input = event.target;
		// console.log("editAttachment, input:", input);
		// var attachmentId = input.name;
		// //console.log("input:", input);
		// //console.log("input.files:", input.files);
		// var uploadedFile = input.files[0];
		// // console.log("editAttachment, uploadedFile:", uploadedFile);
		// // console.log("editAttachment, uploadedFile.size:", uploadedFile.size);
		// if (uploadedFile.size <= MAX_FILE_SIZE) {
		// 	var fr = new FileReader();
		// 	fr.readAsDataURL(uploadedFile);
		// 	fr.onload = function() {
		// 		//console.log("fr.onload, fr.result:", fr.result);
		// 		var tempResult = fr.result;
		// 		tempResult = tempResult.split(",");
		// 		var attachmentBody = tempResult[1];
		// 		//console.log("attachmentBody", attachmentBody);
		// 		helper.updateAttachmentEL(component, attachmentId, attachmentBody);

		// 		document.getElementsByName(attachmentId)[0].value = '';
		// 	};
		// 	fr.onerror = function(error) {
		// 		console.log("fr.onerror, error:", error);
		// 	};
		// } else {
		// 	toastEvent.setParams({
		// 		"duration": "2000",
		// 		"type": "warning",
		// 		"title": "Advertencia",
		// 		"message": "El archivo que está intentado subir tiene un tamaño superior a los 4MB. Reduzca el tamaño del archivo y vuelva a intentarlo"
		// 	});
		// 	toastEvent.fire();
		// }
	}, */
	
	editAttachment: function(component, event, helper) {
		// Constants
		const ACTION_SUCCESS_STATE = 'SUCCESS';
		// Constants
		// Variables
		let elId = component.get('v.recordId');
		let { name, documentId } = event.getParam('files')[0];
		let [ oldDocId, newTitle, elFieldName ] = event.getSource().get('v.name').split('-');
		// Variables
		console.log(`handleEditDoc(), oldDocId: ${oldDocId}, newTitle: ${newTitle}`);
		let actionDeleteDoc = component.get('c.EC_deleteAttachment2');
		actionDeleteDoc.setParams({
			attachmentId: oldDocId,
			elId,
			elFieldName
		});
		actionDeleteDoc.setCallback(this, responseDeleteDoc => {
			console.log('editAttachment(), responseDeleteDoc.getState():', responseDeleteDoc.getState());
			if (responseDeleteDoc.getState() === ACTION_SUCCESS_STATE) {
				console.log('editAttachment(), responseDeleteDoc.getReturnValue():', responseDeleteDoc.getReturnValue());
				newTitle = newTitle.replace(/\s/g, "_");
				helper.saveAttachmentEL2(component, documentId, newTitle, elFieldName);
			} else {
				$A.get('e.force:showToast')
					.setParams({
						duration: '10000',
						type: 'error',
						title: 'Error',
						message: 'Ocurrió un problema al eliminar el archivo anterior: ' + responseDeleteDoc.getError()
					})
					.fire();
			}
		});
		$A.enqueueAction(actionDeleteDoc);
	},
	
	handleUploadFinished : function(component, event, helper) {
		console.log('handleUploadFinished!');
		var uploadedFiles = event.getParam("files");
		var documentId = uploadedFiles[0].documentId;
		var fileName = uploadedFiles[0].name;
		
		var pressedButton = event.getSource();
		var name = pressedButton.get("v.name").split("-");
		var attachmentName = name[0];
		var elFieldName = name[1];
		
		attachmentName = attachmentName.replace(/\s/g, "_");
		console.log("documentId: ",documentId," attachmentName:", attachmentName," elFieldName:"+elFieldName);
		helper.saveAttachmentEL2(component, documentId, attachmentName, elFieldName);
	}
})