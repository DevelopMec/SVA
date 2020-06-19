trigger TriggerContrato2 on Contrato2__c (before insert, before update, after update) {
    if(!(Trigger.isUpdate && Trigger.isAfter)){
    	TriggerHandlerContrato2.metodo(Trigger.new);
    }
    if((Trigger.isUpdate||Trigger.isInsert)&&Trigger.isBefore){
        TriggerHandlerContrato2.asignarValores(Trigger.new,Trigger.oldMap);
    }

    if(Trigger.isUpdate && Trigger.isAfter){
        TriggerHandlerContrato2.sendToSIGLO(Trigger.newMap,Trigger.oldMap);
    }
}