trigger Task on Task (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
   new TriggerTaskHandler().run();
}