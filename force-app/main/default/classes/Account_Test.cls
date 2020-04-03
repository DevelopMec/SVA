@isTest
public class Account_Test {
    
    @testSetup
    public static void setAccountData() {
        List<Account> cuentas = new List<Account>{new Account(
            Name='Prueba',
            NumeroEmpleados__c = '51-125',
            Type='Cliente',
            Frozen_Segment__c = ''
        ), new Account(
            Name='Prueba2',
            NumeroEmpleados__c = '51-125',
            Type='Ex Cliente',
            Frozen_Segment__c = 'Small-3'
        )};
        insert cuentas;
    }
    
    @isTest
    public static void frozenSegment() {
        Test.startTest();
        Account cuenta = [SELECT Id, Name,Type,Text_Segment__c,Frozen_Segment__c FROM Account WHERE Name='Prueba' limit 1];
        cuenta.Type = Label.exclient;
        update cuenta; 
        Test.stopTest();
    }
    
    @isTest
    public static void exFrozenSegment() {
        Test.startTest();
        Account cuenta = [SELECT Id, Name,Type,Text_Segment__c,Frozen_Segment__c FROM Account WHERE Name='Prueba2' limit 1];
        cuenta.Type = 'Cliente';
        update cuenta;
        Test.stopTest();
    }
}