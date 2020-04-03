@isTest
public class BatchContratoFilial_TEST {
	@isTest(seeAllData=true)
    public static void testBatch(){
        Database.executeBatch(new BatchContratoFilial(),200);
    }
}