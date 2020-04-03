@istest 
public class BatchTodosUltimoPedido_Test {
    
    @isTest(seeAllData=true)
     public static void TestTodosPedido(){
        Database.executeBatch(new BatchTodosUltimoPedido(),200); 
    }

}