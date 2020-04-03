@isTest
private class OpportunityClosing_Schedule_Test{
    @isTest static void test_method_one(){
        Opportunity_closing__c cs = new Opportunity_closing__c();
        cs.No_follow_up_alert__c = 5;
        cs.No_follow_up_closing__c = 6;
        cs.No_client_operations_alert__c = 12;
        cs.No_client_operations_closing__c = 13;
        insert cs;
        
        String CRON_EXP = '0 0 0 15 3 ? 2030';
        System.schedule('OpportunityClosing_Schedule_Test', CRON_EXP, new OpportunityClosing_Schedule());
    }
}