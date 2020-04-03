public with sharing class GrupoAtencionController{
@AuraEnabled
//BOTON SIGUIENTE
	public static Map<String,String> siguienteCaso(Id dato){
	//Obtiene los datos del caso 
	Case registroV = [Select Grupo_de_Atencion__c, Grupo_atencion_siguiente__c,Grupo_atencion_anterior__c,Motivo__c,
                   		  Sub_Motivo__c,Familia__c,Type,Status,TicketCampoVacio__c
						  FROM Case 
                          Where Id =: dato 
                          limit 1];
        
	String grupoAtencionAnte = registroV.Grupo_atencion_anterior__c;
	String grupoAtencion = registroV.Grupo_de_Atencion__c; 
	String grupoAtencionSig = registroV.Grupo_atencion_siguiente__c;
	String motivo = registroV.Motivo__c;
	String submotivo = registroV.Sub_Motivo__c;
	String tipo = registroV.Type;
	String familia = registroV.Familia__c;
	String estado = registroV.Status;
	Boolean camposVacios = registroV.TicketCampoVacio__c;
	Map<String,String> resultMap = new Map<String,String>();
        
		try{
			if(estado != 'Concluido' && estado !='Cancelado'){
				if(grupoAtencionSig != '--'){
					if(!camposVacios){
						Submotivo__c mdb = [SELECT Grupo_Soporte_1__c,Grupo_Soporte_2__c,
                        Grupo_Soporte_3__c,Grupo_Soporte_4__c,Grupo_Soporte_5__c,Grupo_Soporte_6__c,Grupo_Soporte_7__c
                       				FROM Submotivo__c
                        			WHERE Name =:submotivo and Motivo__c=: motivo and Tipo_de_Ticket__c =: tipo];
                
						Map<String, Object> fieldsToValue = mdb.getPopulatedFieldsAsMap();
						Object[] submotList = new List<Object>();
                    
						for (String fieldName : fieldsToValue.keySet()){
							Object value = fieldsToValue.get(fieldName);
							if (value != null && fieldName != 'Id'){
								if(value == 'TI' && familia == 'Benefits'){
									submotList.add('TI BENEFITS');
								}else if(value == 'TI' && familia == 'Ticket Car'){
									submotList.add('TI TICKET CAR');
								}else if(value == 'TI' && familia == 'Ticket Empresarial'){
									submotList.add('TI TICKET EMPRESARIAL');
								}else{
	                                submotList.add(value);
								}
        					}
						}
        		
	   					//Asigna los valores nuevos a los campos
	                	if(motivo != 'Re facturación'){
							if(grupoAtencion != 'CALIDAD'){
								registroV.Grupo_atencion_anterior__c = grupoAtencion;
                            }else{
                                registroV.Grupo_atencion_anterior__c = 'CALIDAD';
                            }
                			registroV.Grupo_de_Atencion__c = grupoAtencionSig;    
        					registroV.Asignar_Propietario__c = true;
                			Integer indexNumb = submotList.indexOf(registroV.Grupo_de_Atencion__c)+1;
                				if(indexNumb == submotList.size()){
                    				registroV.Grupo_atencion_siguiente__c = '--';
                				}else if(indexNumb < submotList.size()){
                    				Object grupoS = submotList.get(indexNumb);
                    				registroV.Grupo_atencion_siguiente__c = grupoS.toString(); 
                				}	                
	                
	                	}else{
	                			registroV.Grupo_atencion_anterior__c = '--';
	                			registroV.Grupo_de_Atencion__c = 'CONTABILIDAD';    
	                			registroV.Asignar_Propietario__c = true;
	                			registroV.Grupo_atencion_siguiente__c = '--';
	                	}

	                	if(estado == 'Abierto'){
	                    	registroV.Status = 'En Proceso';
	                	}else if (estado == 'En Proceso'){
	                    	registroV.Status = 'En Proceso';
	                	}
	            		//Actualiza el registro
	             		update registroV;
	                
	             		resultMap.put('status','success');
	             		resultMap.put('message','Caso escalado correctamente');

					}else{
						//Mensaje de que hay campos vacios
						resultMap.put('status','warning');
             			resultMap.put('message','Complete todos los campos de la sección: Información De Ticket');
					}

				}else if(grupoAtencionSig == '--' && motivo == 'Re facturación'){
					//Cuando el campo grupo atencion siguiente es --
					resultMap.put('status','warning');
             		resultMap.put('message','La escalación se debe hacer manualmente');

				}else{
					//Cuando el campo grupo atencion siguiente es --
					resultMap.put('status','warning');
             		resultMap.put('message','No hay más grupos para asignar');
				}
			}else{
				//El caso está cerrado
				resultMap.put('status','warning');
             	resultMap.put('message','El caso está cerrado');
			}			
   
            //FINAL DEL TRY
		}
		catch(Exception e){
             resultMap.put('status','error');
             resultMap.put('message',e.getMessage());
         }
         return resultMap;
	}
    
	@AuraEnabled
    public static Map<String,String> anteriorCaso(Id dato,String dato2){
       
	Case recordCase = [Select Grupo_de_Atencion__c, Grupo_atencion_siguiente__c,Grupo_atencion_anterior__c, Sub_Motivo__c ,
                           Comentarios_Grupo_Atencion__c,Motivo__c,Familia__c,Type,OwnerId
                           FROM Case 
                           Where Id =: dato 
                           limit 1];

	String grupoAtencionAnte = recordCase.Grupo_atencion_anterior__c;
	String grupoAtencion = recordCase.Grupo_de_Atencion__c; 
	String grupoAtencionSig = recordCase.Grupo_atencion_siguiente__c;
	String submotivo = recordCase.Sub_Motivo__c;
	String motivo = recordCase.Motivo__c;
	String tipo = recordCase.Type;
	String familia = recordCase.Familia__c;
    Map<String,String> resultMap = new Map<String,String>();
    ///
    Comentario_de_Rechazo__c coment;
    Id profileAdmin = [SELECT Name FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator' LIMIT 1].Id;
    String strOwnerId = recordCase.OwnerId;
    String currentUser = UserInfo.getUserId(); 
    Id currentProfile = UserInfo.getProfileId();
        
		try{
			if(motivo != null && submotivo != null){
				if( (strOwnerId == currentUser) || (currentProfile == profileAdmin) ||(Test.isRunningTest()) ){
					//if(true){
					if(motivo != 'Re facturación'){
						if(grupoAtencionAnte != '--'){
						Submotivo__c mdb = [SELECT Grupo_Soporte_1__c,Grupo_Soporte_2__c,
								Grupo_Soporte_3__c,Grupo_Soporte_4__c,Grupo_Soporte_5__c,Grupo_Soporte_6__c,Grupo_Soporte_7__c
								FROM Submotivo__c
								WHERE Name =:submotivo and Motivo__c=: motivo and Tipo_de_Ticket__c =: tipo];
                
                 		Map<String, Object> fieldsToValue = mdb.getPopulatedFieldsAsMap();
				 		Object[] submotList = new List<Object>();
							for (String fieldName : fieldsToValue.keySet()){
								Object value = fieldsToValue.get(fieldName);
								if (fieldsToValue.get(fieldName) != null && fieldName != 'Id'){
									if(value == 'TI' && familia == 'Benefits'){
										submotList.add('TI BENEFITS');
									}else if(value == 'TI' && familia == 'Ticket Car'){
										submotList.add('TI TICKET CAR');
									}else if(value == 'TI' && familia == 'Ticket Empresarial'){
										submotList.add('TI TICKET EMPRESARIAL');
									}else{
										submotList.add(value);
									}
        						}
							}                
        
                		recordCase.Grupo_atencion_siguiente__c = grupoAtencion;
                		recordCase.Grupo_de_Atencion__c = 'CALIDAD';
                		recordCase.Grupo_atencion_anterior__c = '--';                           
                		recordCase.Asignar_Propietario__c = true;
                		///
                		coment = new Comentario_de_Rechazo__c();
                		coment.Name = dato2;
                		coment.Fecha_Hora__c = System.now();
		                coment.Grupo_de_Atencion__c = grupoAtencion;
		                coment.Ticket__c = recordCase.Id;
		                coment.Usuario__c = strOwnerId.startsWith('005') ? strOwnerId : null;
		                insert coment;
		                

		                update recordCase;             
		             	resultMap.put('status','success');
		             	resultMap.put('message','Caso rechazado correctamente');   
				
					}else{
				resultMap.put('status','warning');
				resultMap.put('message','No hay más grupos para asignar');
			}   
            
			}else{
				resultMap.put('status','warning');
				resultMap.put('message','El rechazo se debe realizar manualmente');
			}	
				}else{
					resultMap.put('status','warning');
					resultMap.put('message','No cuenta con los permisos necesarios para realizar esta acción');
				}				

			}else{
				resultMap.put('status','warning');
				resultMap.put('message','Motivo y Submotivo no han sido seleccionados');
			} 
             //final del try
		}
		catch(Exception e){
			resultMap.put('status','error');
			resultMap.put('message',e.getMessage());
		}
		return resultMap;
	}
}