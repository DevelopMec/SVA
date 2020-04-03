@isTest(seeAllData=true)
public class BachOTAsignarEntidadLegal_Test {
    @isTest
    public static void metodo1(){
        Database.executeBatch(new BachOrdenesTrabajoAsignarEntidadLegal(),200);
        Database.executeBatch(new BatchContratoFilial(),200);
    }
}