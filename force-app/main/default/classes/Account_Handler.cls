public class Account_Handler {
    
    public static void populateFrozenSegment(Map<Id,Account> triggerNew, Map<Id,Account> triggerOld){
        for(String accId : triggerOld.keySet()){
            if(isFrozenAccount(triggerNew.get(accId),triggerOld.get(accId)) ) {
                triggerNew.get(accId).Frozen_Segment__c = triggerNew.get(accId).Text_Segment__c;
                triggerNew.get(accId).business__c = '';
                triggerNew.get(accId).Funcion__c = '';
            } else if(isExFrozenAccount(triggerNew.get(accId),triggerOld.get(accId))) {
                triggerNew.get(accId).Frozen_Segment__c = '';
            }
        }
    }

    private static Boolean isFrozenAccount(Account newAcc, Account oldAcc){
        return ( (oldAcc.Type != newAcc.Type) && (newAcc.Type == System.Label.exclient) );
    }
    private static Boolean isExFrozenAccount(Account newAcc,Account oldAcc){
        return ( (oldAcc.Type == System.Label.exclient) && (newAcc.Type != System.Label.exclient) );
    }
}