/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Creation	-/03/2020 Controller for Lightning component CustomLookup [Freeway req. 2900].
* @Change	21/05/2020 Add searcher for EconomicActivity__c (used in AltaContrato_CONT component Lightning).
			[Freeway req. 3319].
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class CustomLookupCtrl {
    
/**
* Método para buscar registros a partir de la searchKeyWord y el nombre del objeto sobre el que debe buscar.
*/
    @AuraEnabled
    public static List<sObject> fetchLookupValues(String searchKeyWord, String ObjectName) {
        System.debug('keyWord' + searchKeyWord);
                System.debug('object' + ObjectName);

        String searchKey = searchKeyWord + '%';
        
        List<sObject> returnList = new List<SObject>();
        //Minimun length to search 
        
        if (ObjectName == 'User') {
            //Search users, only from commercial area.
            returnList = [SELECT Id, Name FROM User WHERE Name LIKE:searchKey and isActive = true
                          AND (Profile.Name = 'Ventas' OR Profile.Name = 'Posventa' OR Profile.Name = 'Trademarketing'
                               OR Profile.Name = 'Mantenimiento')
                          ORDER BY Name];
        } else if (ObjectName == 'EconomicActivity__c') {
            searchKey = '%'+searchKey;
            //Search all economic activities.
            returnList = [SELECT Id, Name FROM EconomicActivity__c WHERE Name LIKE:searchKey
                          ORDER BY Name];
        }
        return returnList;
    }

}