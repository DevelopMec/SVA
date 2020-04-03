trigger OpenCasesRollUpinAccount on Case (after insert, after update, after delete) {
    //--English--
    //This Code constitutes an Extra-functionality delivered in order to count the Open Tickets of an Account. 
    //The Open Tickets Count functionality was requested as one of the Ticket Scoring Criteria, Ticket Scoring is done through CaseScore and AccountCaseScore Triggers.
    //Ticket Scoring was also delivered as an extra-functionality within the Service Cloud Implementation Project. Extra-Functionalities are not covered by the Project Scope 
    //and Guarantee.
    //The Open Tickets Count Functionality Development is not possible using standard functionality as Roll Up Summary Fields are not allowed for Lookup Relationships
    //This Trigger Code 'simulates' some functions of a Roll Up Summary Field in the Custom Field Open_Cases__c in Account. The Trigger Code is not covered by Guarantee.
    //--Spanish--
    //Este código constituye una funcionalidad extra dada para contar los Tickets Abiertos para una Cuenta
    //La Funcionalidad de Conteo de Tickets Abiertos fue solicitada como uno de los criterios de Puntuación de Tickets, la Puntuación de un Ticket es realizado a través de
    //los Triggers: CaseScore y AccountCaseScore.
    //La Puntuación de Tickets también fue entregada como una funcionalidad extra dentro del Proyecto de Implementación de Service Cloud. Funcionalidades extras 
    //no son cubiertas por el Alcance del Proyecto y Garantía.
    //El Desarrollo de la Funcionalidad de Conteo de Tickets Abiertos no es posible utilizando Funcionalidad Estandar ya que los Campos de Resumen no son permitidos en Relaciones de Búsqueda.
    //Este Código Trigger simula algunas de las Funciones de un Campo de Resumen en el Campo Personalizado Open_Cases__c en la Cuenta. Este Código Desencadenador 
    //no está cubierto por Garantía.
    if (Trigger.isDelete) {
        System.debug('OpenCasesRollUpinAccount Trigger.isDelete');
        Map <Id, Account> accsMap=new Map <Id, Account>();
        Map <Id, Account> accsToUpdateMap=new Map <Id, Account>();
        Set <Id> accsToUpdateIds=new Set <Id>();
        Set <Id> accsIdsForCurrentCases=new Set <Id>();     
        for (Case c : Trigger.old) {
            accsIdsForCurrentCases.add(c.AccountId);
        }
        List<Account> accs=[SELECT Id, Open_Cases__c FROM Account WHERE Id IN :accsIdsForCurrentCases LIMIT 50000];        
        if (!accs.isEmpty()) {
            for (Account acc : accs) {
                accsMap.put(acc.Id, acc);
            }        
        }
        if (!accs.isEmpty()) {
            for (Case c : Trigger.old) {
                if (c.Status!='Concluido' && c.AccountId!=null) {
                    if (accsMap.get(c.AccountId).Open_Cases__c!=null) {
                        accsMap.get(c.AccountId).Open_Cases__c=accsMap.get(c.AccountId).Open_Cases__c-1;
                        accsToUpdateIds.add(c.AccountId);
                    }
                }
            }
            for (Id accId : accsMap.keySet()) {
                if (accsToUpdateIds.contains(accId)) {
                    accsToUpdateMap.put(accId, accsMap.get(accId));
                }
            }            
            update accsToUpdateMap.values();
        }
    }
    if (Trigger.isUpdate) {
        System.debug('OpenCasesRollUpinAccount Trigger.isUpdate');
        Map <Id, Account> accsMap=new Map <Id, Account>();
        Map <Id, Account> accsToUpdateMap=new Map <Id, Account>();
        Set <Id> accsToUpdateIds=new Set <Id>();
        Set <Id> accsIdsForCurrentCases=new Set <Id>();     
        for (Case c : Trigger.new) {
            accsIdsForCurrentCases.add(c.AccountId);
        }
        for (Case c : Trigger.old) {
            accsIdsForCurrentCases.add(c.AccountId);
        }        
        List<Account> accs=[SELECT Id, Open_Cases__c FROM Account WHERE Id IN :accsIdsForCurrentCases LIMIT 50000];
       
        if (!accs.isEmpty()) {
            for (Account acc : accs) {
                accsMap.put(acc.Id, acc);
            }        
        }
        if (!accs.isEmpty()) {
            for (Case c : Trigger.new) {
                    if (c.Status!='Concluido' && c.AccountId!=Trigger.oldMap.get(c.Id).AccountId 
                        && Trigger.oldMap.get(c.Id).AccountId!=null && c.AccountId!=null) { // Req  2253
                            if (accsMap.get(c.AccountId).Open_Cases__c!=null) {
                                accsMap.get(c.AccountId).Open_Cases__c=accsMap.get(c.AccountId).Open_Cases__c+1;
                                accsToUpdateIds.add(c.AccountId);
                            } else {
                                accsMap.get(c.AccountId).Open_Cases__c=1;
                                accsToUpdateIds.add(c.AccountId);
                            }
                            if (accsMap.get(Trigger.oldMap.get(c.Id).AccountId).Open_Cases__c!=null) {
                                accsMap.get(Trigger.oldMap.get(c.Id).AccountId).Open_Cases__c=accsMap.get(Trigger.oldMap.get(c.Id).AccountId).Open_Cases__c-1;
                                accsToUpdateIds.add(Trigger.oldMap.get(c.Id).AccountId);
                            }
                        } else {
                            if(c.Status!='Concluido' && c.AccountId!=Trigger.oldMap.get(c.Id).AccountId 
                               && Trigger.oldMap.get(c.Id).AccountId==null && c.AccountId!=null) { // Req  2253
                                    if (accsMap.get(c.AccountId).Open_Cases__c!=null) {
                                        accsMap.get(c.AccountId).Open_Cases__c=accsMap.get(c.AccountId).Open_Cases__c+1;
                                        accsToUpdateIds.add(c.AccountId);
                                    }                          
                               }
                        }
                    if (c.Status=='Concluido' && Trigger.oldMap.get(c.Id).Status!='Concluido' && c.AccountId!=null) {
                        if (accsMap.get(c.AccountId).Open_Cases__c!=null) {
                            accsMap.get(c.AccountId).Open_Cases__c=accsMap.get(c.AccountId).Open_Cases__c-1;
                            accsToUpdateIds.add(c.AccountId);
                        }
                    }
                    if (c.Status!='Concluido' && Trigger.oldMap.get(c.Id).Status=='Concluido' && c.AccountId!=null) {
                        if (accsMap.get(c.AccountId).Open_Cases__c!=null) {
                            accsMap.get(c.AccountId).Open_Cases__c=accsMap.get(c.AccountId).Open_Cases__c+1;
                            accsToUpdateIds.add(c.AccountId);
                        } else {
                            accsMap.get(c.AccountId).Open_Cases__c=1;
                            accsToUpdateIds.add(c.AccountId);
                        }
                    }                
            }
            for (Id accId : accsMap.keySet()) {
                if (accsToUpdateIds.contains(accId)) {
                    accsToUpdateMap.put(accId, accsMap.get(accId));
                }
            }            
            update accsToUpdateMap.values();        
        }
    }
    
    if (Trigger.isInsert) {
        System.debug('OpenCasesRollUpinAccount Trigger.isInsert');
        Map <Id, Account> accsMap=new Map <Id, Account>();
        Map <Id, Account> accsToUpdateMap=new Map <Id, Account>();
        Set <Id> accsToUpdateIds=new Set <Id>();        
        Set <Id> accsIdsForCurrentCases=new Set <Id>();     
        for (Case c : Trigger.new) {
            accsIdsForCurrentCases.add(c.AccountId);
        }
        List<Account> accs=[SELECT Id, Open_Cases__c FROM Account WHERE Id IN :accsIdsForCurrentCases LIMIT 50000];

        if (!accs.isEmpty()) {
            for (Account acc : accs) {
                accsMap.put(acc.Id, acc);
            }        
        }
        System.debug('accsMap '+accsMap);
        if (!accs.isEmpty()) {
            for (Case c : Trigger.new) {
                if (c.Status!='Concluido' && c.AccountId!=null) {
                    if (accsMap.get(c.AccountId).Open_Cases__c!=null) {
                        accsMap.get(c.AccountId).Open_Cases__c=accsMap.get(c.AccountId).Open_Cases__c+1;
                        accsToUpdateIds.add(c.AccountId);
                    } else {
                        accsMap.get(c.AccountId).Open_Cases__c=1;
                        accsToUpdateIds.add(c.AccountId);
                    }
                }                
            }
            for (Id accId : accsMap.keySet()) {
                if (accsToUpdateIds.contains(accId)) {
                    accsToUpdateMap.put(accId, accsMap.get(accId));
                }
            }
            update accsToUpdateMap.values();      
        }
    }

}