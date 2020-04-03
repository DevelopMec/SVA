trigger TriggerQuoteLineItem on QuoteLineItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	new TriggerQuoteLineItemHandler().run();
}