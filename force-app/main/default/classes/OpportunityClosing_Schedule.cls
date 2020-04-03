global class OpportunityClosing_Schedule implements Schedulable{
    global void execute(SchedulableContext sc){
        OpportunityClosing.FollowUpAlert();
        OpportunityClosing.FollowUpClosing();
        OpportunityClosing.ClientOperationsAlert();
        OpportunityClosing.ClientOperationsClosing();
    }
}