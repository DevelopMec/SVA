global class ActualizaActividades implements Schedulable {
     global void execute(SchedulableContext SC) {
      List<Task> tareas=[SELECT id, Status from Task where isAlert__c=true and Status!= 'Concluida'];
         for(Task tarea: tareas){
             tarea.Status='Concluida';
         }
         if(!tareas.isEmpty()) {
             update tareas;
         }
         
   }

}