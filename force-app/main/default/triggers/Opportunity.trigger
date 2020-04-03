trigger Opportunity on Opportunity (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    System.debug('TRIGGEROPPB::'+trigger.isBefore+'---'+trigger.isUpdate);
    System.debug('TRIGGEROPPA::'+trigger.isAfter+'---'+trigger.isUpdate);
    System.debug('TRIGGEROPPLIM::'+Limits.getQueries());
    new TriggerOpportunityHandler().run();
}