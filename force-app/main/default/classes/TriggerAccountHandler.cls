public class TriggerAccountHandler extends TriggerHandler {
    
    private Map<Id, Account> newMap;
    private Map<Id, Account> oldMap;
    private List<Account> newList;
    private List<Account> oldList;
    
    public TriggerAccountHandler() {
        this.newMap = (Map<Id, Account>) trigger.newMap;
        this.oldMap = (Map<Id, Account>) trigger.oldMap;
        this.newList = (List<Account>) trigger.new;
        this.oldList = (List<Account>) trigger.old;
    }
    
    public override void afterUpdate() {
        sendToSIGLO(newList);
    }
    
    //Valida si existe algun cambio en los campos que se envian a SIGLO
    public void sendToSIGLO(List<Account> newList){
        System.debug('-------SendToSIGLO---------');
        Set<Id> accIds = new Set<Id>();
        for(Account newAccount : newList){
            Account oldAccount = oldMap.get(newAccount.Id);
            if(newAccount.Website != oldAccount.Website || newAccount.Phone != oldAccount.Phone){
                accIds.add(newAccount.Id);
            }
        }
        if(!accIds.isEmpty()){
            List<Contrato2__c> contratoOpp = [SELECT PartidaPresupuesto__r.Quote.Opportunity.Account.Phone, PartidaPresupuesto__r.Quote.Opportunity.AccountId,
                                              Contacto__r.Account.Website, Contacto__r.AccountId, PartidaPresupuesto__r.Quote.OpportunityId
                                              FROM Contrato2__c 
                                              WHERE (PartidaPresupuesto__r.Quote.Opportunity.AccountId != null AND PartidaPresupuesto__r.Quote.Opportunity.AccountId IN: accIds)
                                              OR (Contacto__r.AccountId != null AND Contacto__r.AccountId IN: accIds)];
            
            List<Opportunity> oppListUPD = new List<Opportunity>();
            for(Contrato2__c contrato : contratoOpp){
                
                //Se envia Website de Contacto -> Account a SIGLO
                if(contrato.Contacto__r.AccountId != null){
                    Account oldAccount = oldMap.get(contrato.Contacto__r.AccountId);
                    if(contrato.Contacto__r.Account.Website != oldAccount.Website){
                        Opportunity oppToUpdate = new Opportunity(Id= contrato.PartidaPresupuesto__r.Quote.OpportunityId, SendToSIGLO__c = true);
                        oppListUPD.add(oppToUpdate);
                    }
                }
                
                //Se envia Phone de Opp -> Account a SIGLO
                if(contrato.PartidaPresupuesto__r.Quote.Opportunity.AccountId != null){
                    Account oldAccount = oldMap.get(contrato.PartidaPresupuesto__r.Quote.Opportunity.AccountId);
                    if(contrato.PartidaPresupuesto__r.Quote.Opportunity.Account.Phone != oldAccount.Phone){
						Opportunity oppToUpdate = new Opportunity(Id= contrato.PartidaPresupuesto__r.Quote.OpportunityId, SendToSIGLO__c = true);
                        oppListUPD.add(oppToUpdate);
                    }
                }
                
            }
            
            if(!oppListUPD.isEmpty()){
                update oppListUPD;
            }
            
        }
        
    }
    
}