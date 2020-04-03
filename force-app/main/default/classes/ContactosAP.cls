public class ContactosAP {
    @AuraEnabled
    public static List<Object> getContactosAP(String idRegistro, String nombreObjeto){
        List< Object > contactosAp = new List< Object >();
        if(!String.isBlank(idRegistro) && !String.isBlank(nombreObjeto)){
            String query = 'SELECT Id, Name, Puesto__c, Funcion__c, Phone, Telefono2__c, Email FROM Contact WHERE AccountID IN (SELECT AccountId FROM ' +nombreObjeto+ ' WHERE Id = \'' + idRegistro + '\')';
            System.debug(query);
            contactosAp = Database.query(query);
        }
        return contactosAp;
    }
}