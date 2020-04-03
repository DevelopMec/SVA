trigger TriggerEmailMessage on EmailMessage (before insert) {
    new TriggerEmailMessageHandler().run();
}