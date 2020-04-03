@isTest
private class Batch_GetListEjecutivos_Test{

    @isTest
    static void test_method_one(){
        Batch_GetListEjecutivos batch = new Batch_GetListEjecutivos();
        Database.executeBatch(batch, 1);
    }
}