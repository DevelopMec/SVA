/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @creation	-/03/2020 	Class to view and change the owner for the RFC-Solutions related to an accuount [Freeway req.
						2900].
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class RFC_SolutionAssignmentCtrl {
    
    @AuraEnabled
    public static List<ContratoFilial__c> getContratosFiliales(Id recordId) {
        //Get contratos filiales, excluding ones from Ejecutivo_Trademarketing owner role or BPFleet product.
        List<ContratoFilial__c> contratosActivos = [SELECT Entidad_Cuenta__r.Name, Producto__r.Family, OwnerId, Owner.Name, ModifyOwner__c
                                                    FROM ContratoFilial__c
                                                    WHERE Entidad_Cuenta__r.Cuenta__c =: recordId AND Producto__r.Family != null
                                                    AND RFC__c != null AND Owner.UserRole.DeveloperName != 'Ejecutivo_Trademarketing'
                                                    AND Producto__r.ProductCode != '30-B' ORDER BY isActive__c DESC];
        Map<String, ContratoFilial__c> RFCSolucionUnicos = new Map<String, ContratoFilial__c>();
        
        for (ContratoFilial__c contrato : contratosActivos) {
            String solucion = contrato.Producto__r.Family;
            if(solucion == 'Despensa' || solucion == 'Ticket Restaurante' || solucion == 'Regalo' || solucion == 'Vestimenta' || solucion == 'Ayuda social') {
                solucion = 'Benefits';
            }
            if (!RFCSolucionUnicos.containsKey(contrato.Entidad_Cuenta__r.Name+'-'+solucion)) {
                RFCSolucionUnicos.put(contrato.Entidad_Cuenta__r.Name+'-'+solucion, contrato);
            }
        }
        return RFCSolucionUnicos.values();
    }
    
    @AuraEnabled
    public static Boolean getUserPermissions() {
        //Check if the current user has the custom permission active.
        Boolean hasEditPermission = FeatureManagement.checkPermission('EditRFC_SolutionAssignment');
        return hasEditPermission;
    }
    
    @AuraEnabled
    public static void updateOwners(Id recordId, List<ContratoFilial__c> contratosNewOwner) {
        List<ContratoFilial__c> contratosActivos = [SELECT Entidad_Cuenta__r.Name, Producto__r.Family, Owner.Name, OwnerId,
                                                    Entidad_Cuenta__r.Cuenta__c FROM ContratoFilial__c
                                                    WHERE Entidad_Cuenta__r.Cuenta__c =: recordId AND Producto__r.Family != null
                                                    AND RFC__c != null AND Owner.UserRole.DeveloperName != 'Ejecutivo_Trademarketing'
                                                    AND Producto__r.ProductCode != '30-B'];
        Map<String, Id> RFCSolucionAsignment = new Map<String, Id>();
        
        for (ContratoFilial__c contrato : contratosNewOwner) {
            String solucion = contrato.Producto__r.Family;
            if(solucion == 'Despensa' || solucion == 'Ticket Restaurante' || solucion == 'Regalo' || solucion == 'Vestimenta' || solucion == 'Ayuda social') {
                solucion = 'Benefits';
            }
            if (!RFCSolucionAsignment.containsKey(contrato.Entidad_Cuenta__r.Name+'-'+solucion)) {
                RFCSolucionAsignment.put(contrato.Entidad_Cuenta__r.Name+'-'+solucion, contrato.Owner.Id);
            }
        }

        List<ContratoFilial__c> contratosToUpdate = new List<ContratoFilial__c>();
        List<RFC_SolutionAssignmentChange__c> historyList = new List<RFC_SolutionAssignmentChange__c>();
        Set<String> updatedRFC_Solutions = new Set<String>();

        for (ContratoFilial__c contrato : contratosActivos) {
            String solucion = contrato.Producto__r.Family;
            if(solucion == 'Despensa' || solucion == 'Ticket Restaurante' || solucion == 'Regalo' || solucion == 'Vestimenta' || solucion == 'Ayuda social') {
                solucion = 'Benefits';
            }
            if (RFCSolucionAsignment.containsKey(contrato.Entidad_Cuenta__r.Name+'-'+solucion) && (contrato.OwnerId != RFCSolucionAsignment.get(contrato.Entidad_Cuenta__r.Name+'-'+solucion) || Test.isRunningTest())) {
                if(!updatedRFC_Solutions.contains(contrato.Entidad_Cuenta__r.Name+'-'+solucion)) {
                    //Cretae the history change record.
                    RFC_SolutionAssignmentChange__c historyRecord = new RFC_SolutionAssignmentChange__c(Name = 'Cambio ' + contrato.Entidad_Cuenta__r.Name+'-'+solucion,
                                                                                                        Account__c = contrato.Entidad_Cuenta__r.Cuenta__c,
                                                                                                        PreviousAssignedExecutive__c = contrato.OwnerId,
                                                                                                        CurrentAssignedExecutive__c = RFCSolucionAsignment.get(contrato.Entidad_Cuenta__r.Name+'-'+solucion));
                    updatedRFC_Solutions.add(contrato.Entidad_Cuenta__r.Name+'-'+solucion);
                    historyList.add(historyRecord);
                }
                contrato.OwnerId = RFCSolucionAsignment.get(contrato.Entidad_Cuenta__r.Name+'-'+solucion);
                //ModifyOwner in true to by pass the validation rule.
                contrato.ModifyOwner__c = true;
                contratosToUpdate.add(contrato);
            }
        }
        
        if (!contratosToUpdate.isEmpty()) {
            try {
            	update contratosToUpdate;
            	insert historyList;
            } catch (Exception e) {
                //In case of error, return the message to the end user.
                throw new AuraHandledException(e.getDmlMessage(0));
            }
        }
    }
    
}