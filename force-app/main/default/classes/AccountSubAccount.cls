public class AccountSubAccount {
	@InvocableMethod(label='Update account estatus' description='Update account estatus.')    
    public static void updateAccountEstatus(List <EntidadCuenta__c> entidadesList) {
        Set<Id> entidadesIds = new Set<Id>();
        Map<Id, Account> accountsToUpdateMap = new Map<Id, Account>();
        if (entidadesList != null && !entidadesList.isEmpty() && entidadesList.size() > 0) {
            for(EntidadCuenta__c entidad : entidadesList) {
                entidadesIds.add(entidad.Id);
            }
            List<EntidadCuenta__c> entidades = [SELECT Cuenta__c, Cuenta__r.SolutionsText__c, 
                                                (SELECT Producto__r.Family, isActive__c FROM Contratos_Filial__r 
                                                 WHERE Producto__r.Family != null AND RFC__c != null AND isActive__c = true)
                                                FROM EntidadCuenta__c WHERE Id IN: entidadesIds];        
            
            if(entidades.size() > 0){
                for(EntidadCuenta__c entidad : entidades){                    
                    if(entidad.Cuenta__c != null){
                        Account accToUpdate = new Account();
                        if(!entidad.Contratos_Filial__r.isEmpty() && entidad.Contratos_Filial__r != null){                       
                            accToUpdate.Id = entidad.Cuenta__c;
                            accToUpdate.Status__c = 'Activo';
                        } else{
                            accToUpdate.Id = entidad.Cuenta__c;
                            accToUpdate.Status__c = 'Inactivo';
                        }
                        accountsToUpdateMap.put(accToUpdate.id, accToUpdate);
                    }
                }
            }
            if (!accountsToUpdateMap.isEmpty() && accountsToUpdateMap.size() > 0) {
                database.update(accountsToUpdateMap.values(), false);
            }
        }
    }
}