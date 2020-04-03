public class OpportunityClosing{
    public static void FollowUpAlert(){
        OC_FollowUpAlert_Batch batch = new OC_FollowUpAlert_Batch();
        Database.executeBatch(batch, 100);
    }
    
    public static void FollowUpClosing(){
        OC_FollowUpClosing_Batch batch = new OC_FollowUpClosing_Batch();
        Database.executeBatch(batch, 100);
    }
    
    public static void ClientOperationsAlert(){
        OC_ClientOperationsAlert_Batch batch = new OC_ClientOperationsAlert_Batch();
        Database.executeBatch(batch, 5);
    }
    
    public static void ClientOperationsClosing(){
        OC_ClientOperationsClosing_Batch batch = new OC_ClientOperationsClosing_Batch();
        Database.executeBatch(batch, 5);
    }
}