public class AmenazasDeCuentaController {
	
    @AuraEnabled
    public static List<Amenaza__c> getAmenazas(Id recordId) {
        
        Id idCuenta = [SELECT AccountId FROM Case WHERE Id =: recordId].AccountId;
        List<Amenaza__c> listAmenazas = [SELECT Name, Motivo__c, FechaAtricion__c, Estatus__c FROM Amenaza__c WHERE Cuenta__c =: idCuenta];
        
        return listAmenazas;
    }
}