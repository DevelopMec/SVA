@isTest
private class Batch_GetListEjecutivos_Test{

    @isTest
    static void test_method_one(){
        Batch_GetListEjecutivos batchT = new Batch_GetListEjecutivos(true);
        Database.executeBatch(batchT, 1000);
        
        Batch_GetListEjecutivos batchF = new Batch_GetListEjecutivos(false);
        Database.executeBatch(batchF, 1000);
    }
}