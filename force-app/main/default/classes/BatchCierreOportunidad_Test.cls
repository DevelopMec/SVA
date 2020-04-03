@istest 
public class BatchCierreOportunidad_Test {
    @isTest(seeAllData=true)
    public static void TestCierreOportunidad(){
        test.startTest();
        Database.executeBatch(new BatchCierreOportunidad(),200); 
        test.stopTest();
    }
    
    @isTest(seeAllData=false)
    public static void TestCierreOportunidadSchedule(){
        test.startTest();
        BatchCierreOportunidad_Schedule b = new BatchCierreOportunidad_Schedule();
        b.execute(null);
        test.stopTest();
    }
}