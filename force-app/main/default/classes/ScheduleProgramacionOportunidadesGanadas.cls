/*
 * Funciona para ejecutar de forma programática (diario a las 5a.m.) la clase BatchOportunidadesGanadas
*/

global class ScheduleProgramacionOportunidadesGanadas Implements Schedulable{
    
    global void execute (SchedulableContext SC){
        BatchOportunidadesGanadas batchOpp = new BatchOportunidadesGanadas();
        ID idBatch = database.executeBatch(batchOpp,50);
    }
}