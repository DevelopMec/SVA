@isTest
public class ActualizaActividades_Tst {
    static testmethod void test() {
        
        Task tarea= new Task(Status='Abierta',Subject='Tarea',isAlert__c=true);
        insert tarea;
        Test.startTest();
        ActualizaActividades actividades = new ActualizaActividades();
        actividades.execute(null);
        Test.stopTest();
    }

    
}