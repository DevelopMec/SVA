@isTest
public class IngresarIdLlamadaTicket_CONT_TEST {
    @isTest
    public static void testMethod1(){
        Case c=new Case(Origin='Web',SuppliedName = 'Prueba');
        insert c;
        IngresarIdLlamadaTicket_CONT.setIdLlamada(c.Id, 'Test');
    }
}