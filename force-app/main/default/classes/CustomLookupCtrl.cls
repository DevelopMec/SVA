/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Creation	-/03/2020 Controller for Lightning component CustomLookup [Freeway req. 2900].
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class CustomLookupCtrl {
    
/**
* Método para buscar registros a partir de la searchKeyWord y el nombre del objeto sobre el que debe buscar.
*/
    @AuraEnabled
    public static List<sObject> fetchLookupValues(String searchKeyWord, String ObjectName) {
        String searchKey = searchKeyWord + '%';
        
        List<sObject> returnList = new List<SObject>();
        //Minimun length to search 
        
        if (ObjectName == 'User') {
            //Search users, only from commercial area.
            returnList = [SELECT Id, Name FROM User WHERE Name LIKE:searchKey and isActive = true
                          AND (Profile.Name = 'Ventas' OR Profile.Name = 'Posventa' OR Profile.Name = 'Trademarketing'
                               OR Profile.Name = 'Mantenimiento')
                          ORDER BY Name];
        }
        return returnList;
    }

}