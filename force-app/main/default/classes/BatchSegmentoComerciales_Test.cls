@istest 
public class BatchSegmentoComerciales_Test {

    @isTest(seeAllData=true)
     public static void TestSegmentoBatch(){
        Database.executeBatch(new BatchSegmentoComerciales(),200); 
    }
    

    @isTest(seeAllData=true)
    public static void TestSegmentoBoton(){
       Account acc = [Select Id, NumeroEmpleados__c, Segmento3__c,Text_Segment__c FROM Account WHERE CodigoClienteAS400__c  = '1627' LIMIT 1];
       ActualizaSegmento.ActualizarSegmento(acc.Id);
    }
    
    @isTest(seeAllData=true)
    public static void TestSegmentoSchedule(){
      BatchSegmentoComerciales_Schedule seg = new BatchSegmentoComerciales_Schedule();
      seg.execute(null);
    }
    
}