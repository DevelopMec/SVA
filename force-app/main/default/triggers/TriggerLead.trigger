trigger TriggerLead on Lead (before update, before insert, after insert, after update) {
    new TriggerLeadHandler().run();
}