@istest 
public class BatchValidarUltimoPedido_Test {

     @isTest(seeAllData=true)
     public static void TestValidarPedido(){
        Database.executeBatch(new BatchValidarUltimoPedido(),200); 
    }
    
    @isTest(seeAllData=true)
     public static void TestValidarPedidoSchedule(){
        BatchValidarUltimoPedido_Schedule b = new BatchValidarUltimoPedido_Schedule();
         b.execute(null);
    }
}