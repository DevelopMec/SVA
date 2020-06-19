trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert, after undelete, after update, before delete, before insert, before update) {
    new TriggerContentDLHandler().run();
}