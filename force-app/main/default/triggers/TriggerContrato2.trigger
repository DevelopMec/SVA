trigger TriggerContrato2 on Contrato2__c (before insert, before update) {
    TriggerHandlerContrato2.metodo(Trigger.new);
    if((Trigger.isUpdate||Trigger.isInsert)&&Trigger.isBefore){
        TriggerHandlerContrato2.asignarValores(Trigger.new,Trigger.oldMap);
    }
}