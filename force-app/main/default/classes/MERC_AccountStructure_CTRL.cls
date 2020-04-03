public class MERC_AccountStructure_CTRL {
    @AuraEnabled
    public static structureWrapper getStructure(String idAccount) {
        structureWrapper structure = new structureWrapper();
        structure.afiliados = [Select Id,Name,AccountEntity__c,Grouper__c FROM Affiliate__c WHERE AccountEntity__r.Cuenta__c=:idAccount AND isActive__c = true];
        structure.agrupadores = [Select Id,Account__c,Name,Code__c FROM Grouper__c WHERE Account__c =: idAccount];
 		return structure;
    }
    
    public class structureWrapper  {
        public structureWrapper () {
            
        }
        @AuraEnabled
        Public List<Affiliate__c> afiliados{get;set;}
        @AuraEnabled
        Public List<Grouper__c> agrupadores{get;set;}
    }
}