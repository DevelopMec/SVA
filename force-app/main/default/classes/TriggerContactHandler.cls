public class TriggerContactHandler extends TriggerHandler {
    
    private Map<Id, Contact> newMap;
    private Map<Id, Contact> oldMap;
    private List<Contact> newList;
    private List<Contact> oldList;
    
    public TriggerContactHandler() {
        this.newMap = (Map<Id, Contact>) trigger.newMap;
        this.oldMap = (Map<Id, Contact>) trigger.oldMap;
        this.newList = (List<Contact>) trigger.new;
        this.oldList = (List<Contact>) trigger.old;
    }
    
    public override void afterUpdate() {
        sendToSIGLO();
    }

	//Valida si existe algun cambio en los campos que se envian a SIGLO
	public void sendToSIGLO(){
        System.debug('-------SendToSIGLO---------');
        Set<Id> contactIds = new Set<Id>();
        for(Contact newContact : newMap.values()){
            Contact oldContact = oldMap.get(newContact.Id);
            if(newContact.Name != oldContact.Name || newContact.Email != oldContact.Email || newContact.Phone != oldContact.Phone || newContact.Birthdate != oldContact.Birthdate || 
                newContact.Curp__c != oldContact.Curp__c || newContact.LastName != oldContact.LastName || newContact.Nationality__c != oldContact.Nationality__c || newContact.Telefono2__c != oldContact.Telefono2__c || 
                newContact.Calle__c != oldContact.Calle__c || newContact.NumeroExterior__c != oldContact.NumeroExterior__c || newContact.NumeroInterior__c != oldContact.NumeroInterior__c || 
                newContact.Colonia__c != oldContact.Colonia__c || newContact.BirthState__c != oldContact.BirthState__c || newContact.Fax != oldContact.Fax || newContact.ElectorID__c != oldContact.ElectorID__c || newContact.Estado__c != oldContact.Estado__c || newContact.CodigoPostal__c != oldContact.CodigoPostal__c || 
                newContact.ProfessionName__c != oldContact.ProfessionName__c || newContact.Gender__c != oldContact.Gender__c || newContact.BirthCountry__c != oldContact.BirthCountry__c ||newContact.DelegacionMunicipio__c != oldContact.DelegacionMunicipio__c || newContact.MaritalStatus__c != oldContact.MaritalStatus__c || newContact.FirstName != oldContact.FirstName){
                contactIds.add(newContact.Id);
               }
        }

        if(!contactIds.isEmpty()){
            List<Contrato2__c> contratoOpp = [SELECT Contacto__c, Contacto__r.Name, Contacto__r.Email, Contacto__r.Phone, Contacto__r.Birthdate, Contacto__r.Curp__c, 
                                                    Contacto__r.LastName, Contacto__r.Nationality__c, Contacto__r.Telefono2__c, Contacto__r.Calle__c, Contacto__r.NumeroExterior__c, 
                                                    Contacto__r.NumeroInterior__c, Contacto__r.Colonia__c, Contacto__r.BirthState__c, Contacto__r.Fax, Contacto__r.ElectorID__c, Contacto__r.Estado__c,
                                                    Contacto__r.CodigoPostal__c, Contacto__r.ProfessionName__c, Contacto__r.Gender__c, Contacto__r.BirthCountry__c,
                                                    Contacto__r.DelegacionMunicipio__c, Contacto__r.MaritalStatus__c, Contacto__r.FirstName,
                                                    PartidaPresupuesto__r.Quote.OpportunityId
                                                FROM Contrato2__c 
                                                WHERE Contacto__c IN: contactIds
                                                AND PartidaPresupuesto__r.Quote.OpportunityId != null];
            List<Opportunity> oppListUPD = new List<Opportunity>();
            for(Contrato2__c contrato : contratoOpp){
                Opportunity oppToUpdate = new Opportunity(Id= contrato.PartidaPresupuesto__r.Quote.OpportunityId, SendToSIGLO__c = true);
                oppListUPD.add(oppToUpdate);
            }

            if(!oppListUPD.isEmpty()){
                update oppListUPD;
            }

        }

    }
    
}