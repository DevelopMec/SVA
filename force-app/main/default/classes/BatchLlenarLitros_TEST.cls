@isTest
public class BatchLlenarLitros_TEST {
	@isTest(seeAllData=true)
    public static void metodo(){
        Database.executeBatch(new BatchLlenarLitros(),2);
    }
}