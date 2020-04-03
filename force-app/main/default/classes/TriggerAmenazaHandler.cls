/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @change	28/02/2020 Add threat validaction activation or deactivation with OpportunityAndThreatValidation__mdt.
* @change	13/03/2020 Add validateRFCSolcionAssignment method [Freeway 2900].
* @change	24/03/2020 Add validateBU method [Freeway 2901].
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public without sharing class TriggerAmenazaHandler extends TriggerHandler{
    
    private List<Amenaza__c> newList;
    private List<Amenaza__c> oldList;
    private Map<Id, Amenaza__c> oldMap;

    public TriggerAmenazaHandler(){
        this.newList = (List<Amenaza__c>) trigger.new;
        this.oldList = (List<Amenaza__c>) trigger.old;
        this.oldMap = (Map<Id, Amenaza__c>) trigger.oldMap;
    }
    
    public override void beforeInsert(){
        validateBU(newList);
        validateRFCSolcionAssignment(newList, null);
        List<OpportunityAndThreatValidation__mdt> threatValidation = [SELECT isActive__c FROM OpportunityAndThreatValidation__mdt WHERE DeveloperName = 'Threat'];
        if ((!threatValidation.isEmpty() && threatValidation[0].isActive__c == true) || Test.isRunningTest()) {
            Set<Id> sas = new Set<Id>();
            Set<Id> secs = new Set<Id>();
            Set<String> sfs = new Set<String>();
            for(Amenaza__c a : this.newList){
                if(a.Estatus__c == 'En atención'){
                    sas.add(a.Cuenta__c);
                    secs.add(a.EntidadCuenta_RB__c);
                    sfs.add(a.Familia__c);
                }
            }
            
            List<Amenaza__c> las = [
                Select Id, Cuenta__c, EntidadCuenta_RB__c, Familia__c, Estatus__c
                from Amenaza__c
                where Estatus__c = 'En atención'
                and Cuenta__c in: sas
                and EntidadCuenta_RB__c in: secs
                and Familia__c in: sfs
            ];
            
            Set<string> scas = new Set<string>();
            for(Amenaza__c a : las){
                scas.add(a.Cuenta__c + '|' + a.EntidadCuenta_RB__c + '|' + a.Familia__c);
            }
            
            for(Amenaza__c a : this.newList){
                if(a.Estatus__c == 'En atención'){
                    if(scas.contains(a.Cuenta__c + '|' + a.EntidadCuenta_RB__c + '|' + a.Familia__c)){
                        a.AddError ('Ya existe un registro de amenaza con estatus "En atención" para eso mismo RFC Solución');
                    }
                }
            }
        }
    }
    
    public override void beforeUpdate(){
        validateRFCSolcionAssignment(newList, oldMap);
    }
    
    //Validate if the RFC-Solution has already an executive assigned. 
    public static void validateRFCSolcionAssignment(List<Amenaza__c> newList, Map<Id, Amenaza__c> oldMap){
        List<Amenaza__c> threatsToValidate = new List<Amenaza__c> ();
        Set<Id> threatsAccIds = new Set<Id>();
        if (oldMap == null) {
            //Is insert.
            for(Amenaza__c threat: newList){
                if (threat.EntidadCuenta_RB__c != null && threat.Familia__c != null) {
                    threatsToValidate.add(threat);
                    threatsAccIds.add(threat.Cuenta__c);
                }
            }
        } else {
            //Is update.
            for(Amenaza__c threat: newList){
                if (threat.EntidadCuenta_RB__c != null && threat.Familia__c != null && ((threat.EntidadCuenta_RB__c != oldMap.get(threat.Id).EntidadCuenta_RB__c) || (threat.Familia__c != oldMap.get(threat.Id).Familia__c)) ) {
                    threatsToValidate.add(threat);
                    threatsAccIds.add(threat.Cuenta__c);
                }
            }
        }
        if (!threatsToValidate.isEmpty()) {
            List<ContratoFilial__c> contratosActivos = [SELECT Entidad_Cuenta__c, Entidad_Cuenta__r.Cuenta__c, Producto__r.Family, Owner.Name, OwnerId FROM ContratoFilial__c
                                                        WHERE Entidad_Cuenta__r.Cuenta__c IN: threatsAccIds AND Producto__r.Family != null
                                                        AND RFC__c != null AND isActive__c = true AND Owner.UserRole.DeveloperName != 'Ejecutivo_Trademarketing'
                                                        AND Producto__r.ProductCode != '30-B' AND OwnerId !=: UserInfo.getUserId()];
            Map<String, ContratoFilial__c> contratosMap = new Map<String, ContratoFilial__c>();
            for(ContratoFilial__c contrato: contratosActivos){
                String solucion = contrato.Producto__r.Family;
                if(solucion == 'Despensa' || solucion == 'Ticket Restaurante' || solucion == 'Regalo' || solucion == 'Vestimenta' || solucion == 'Ayuda social') {
                    solucion = 'Benefits';
                }
                contratosMap.put(contrato.Entidad_Cuenta__r.Cuenta__c + '-' + contrato.Entidad_Cuenta__c + '-' + solucion , contrato);
            }
            for (Amenaza__c amenazaToValidate: threatsToValidate) {
                String solucionAmenaza = amenazaToValidate.Familia__c;
                if(solucionAmenaza == 'Despensa' || solucionAmenaza == 'Ticket Restaurante' || solucionAmenaza == 'Regalo' || solucionAmenaza == 'Vestimenta' || solucionAmenaza == 'Ayuda Social') {
                    solucionAmenaza = 'Benefits';
                }
                if (contratosMap.containsKey(amenazaToValidate.Cuenta__c + '-' + amenazaToValidate.EntidadCuenta_RB__c + '-' + solucionAmenaza)) {
                    amenazaToValidate.addError('Ya existe un ejecutivo asignado para ese RFC en esa solución.');
                }
            }                
        }
    }
    
/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Created	23/03/2020 	Description: Check if there is an excecutive already assigned to the business unit related
						to the solution added to the thread record, if so, show a message and avoid the record
						creation.
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void validateBU(List<Amenaza__c> newList){
        List<Amenaza__c> threatsToValidate = new List<Amenaza__c> ();
        Set<Id> threatsAccIds = new Set<Id>();
        Set<String> threatsSolutions = new Set<String>();
        for(Amenaza__c threat: newList){
            if (threat.Familia__c != null && threat.Cuenta__c != null) {
                threatsToValidate.add(threat);
                threatsAccIds.add(threat.Cuenta__c);
                String solution = threat.Familia__c;
                if (solution == 'Ayuda Social') {
                    solution = 'Ayuda social';
                }
                threatsSolutions.add(solution);
            }
        }
        System.debug('La lista de soluciones entrantes es :' + threatsSolutions);
        //If there are threats to validate
        if (!threatsToValidate.isEmpty()) {
            Map<String, String> solutionAndBUSolutions = new Map<String,String>();
            List<String> allAllowedSolutions = new List<String>();
            for (String solution : threatsSolutions) {
                List<Roles_BusinessUnits_Solutions__mdt> bUSolutions = [Select AllowedSolutions__c
                                                                        FROM Roles_BusinessUnits_Solutions__mdt
                                                                        WHERE BusinessUnit__c != 'Multiproducto' AND AllowedSolutions__c LIKE : '%'+solution+'%' LIMIT 1];
                if (!bUSolutions.isEmpty()) {
                    for (String allowedSolution : bUSolutions[0].AllowedSolutions__c.split(',')) {
                    	//Filling a map with the threat solution as the key and the string containing all allowed solutions for the business unit for that solution.
                        solutionAndBUSolutions.put(allowedSolution,bUSolutions[0].AllowedSolutions__c);
                        //Get in a list all allowed solutions for the business units related to the incoming threats solutions.
                        allAllowedSolutions.add(allowedSolution);
                    }
                }
            }
            System.debug('Mapa de familia y soluciones permitidas: ' + solutionAndBUSolutions);
            System.debug('Lista de soluciones permitidas: ' + allAllowedSolutions);

            //Select contratos filiales related to the accs in the incoming threats and with a solution containing in the business unit solutions related to the threat solution.
            List<ContratoFilial__c> contratosActivos = [SELECT Entidad_Cuenta__r.Cuenta__c, Producto__r.Family FROM ContratoFilial__c
                                                        WHERE Entidad_Cuenta__r.Cuenta__c IN: threatsAccIds
                                                        AND Producto__r.Family != null
                                                        AND Producto__r.Family IN: allAllowedSolutions
                                                        AND isActive__c = true AND OwnerId !=: UserInfo.getUserId()];
            if (!contratosActivos.isEmpty()) {
                System.debug('Contratos activos de esa BU: ' + contratosActivos);
                Map<String, List<ContratoFilial__c>> allSolutionsWhithContracts = new Map<String, List<ContratoFilial__c>>();
                for (ContratoFilial__c contrato : contratosActivos) {
                    //Filling a map with a string with the acc and all allowed solutions for a BU and as value, the list of contratos filiales with a solution containing in the key.
                    if (allSolutionsWhithContracts.containsKey(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family))) {
                        //If the allSolutionsWhithContracts contains the key(acc-allAllowedSolutions) that contains the comtrato filial solution, only add the contrato to the existing value list. 
                        List<ContratoFilial__c> accContracts = allSolutionsWhithContracts.get(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family));
                        accContracts.add(contrato);
                        allSolutionsWhithContracts.put(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family), accContracts);
                    } else {
                        //If the allSolutionsWhithContracts does not contain the key(acc-allAllowedSolutions) that contains the comtrato filial solution, add the key and initialize the value list with the contrato. 
                        allSolutionsWhithContracts.put(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family), new List<ContratoFilial__c> { contrato });
                    }                                      
                }
                System.debug('Mapa de cuenta, familia - Contratos activos: ' + allSolutionsWhithContracts);
                for (Amenaza__c newAmenaza : threatsToValidate) {
                    String solution = newAmenaza.Familia__c;
                    if (solution == 'Ayuda Social') {
                        solution = 'Ayuda social';
                    }
                    //If acc Id and allowed solutions for that business unit is already a key in the map, add the error.
                    if(allSolutionsWhithContracts.containsKey(newAmenaza.Cuenta__c+'-'+solutionAndBUSolutions.get(solution))) {
                        newAmenaza.addError('Este grupo ya tiene asignado un ejecutivo para la Unidad de negocio seleccionada.');
                    }
                }
            }
        }
    }

}