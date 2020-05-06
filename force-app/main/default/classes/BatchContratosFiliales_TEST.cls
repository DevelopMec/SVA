@isTest
public with sharing class BatchContratosFiliales_TEST {
    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'ABCTest';
        insert acc;
        
        EntidadLegal__c entidadLegal = new EntidadLegal__c();
        entidadLegal.Name = 'HIJD93061278A';
        entidadLegal.Cuenta__c = acc.Id;
        insert entidadLegal;
        
        EntidadCuenta__c ec = [SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: acc.Id AND EntidadLegal__c =: entidadLegal.Id limit 1];
        
        Product2 prod = new Product2();
        prod.Name = 'Producto Test';
        prod.Family = 'Ticket Restaurante';
        prod.ProductCode = '1';
        insert prod;
        
        Date oldDate  = date.newinstance(Date.today().year()-2, Date.today().month(), 1);
        Date dateEnd = date.newinstance(Date.today().year(), Date.today().month(), 1);
        dateEnd = dateEnd.addDays(-1);
        
        ContratoFilial__c contratoInactivo = new ContratoFilial__c(Name='01-30-42424-121',CodigoAS400__c='01-30-42424-333',Amount_last_order__c = 0.00,Last_order_date__c = oldDate,isActive__c = true,Entidad_Cuenta__c = ec.Id,Producto__c = prod.Id);
        insert contratoInactivo;
        ContratoFilial__c contratoActivo = new ContratoFilial__c(Name='01-30-42424-323',CodigoAS400__c='01-30-42424-321',Amount_last_order__c = 5000.00,Last_order_date__c = dateEnd,isActive__c = true,Entidad_Cuenta__c = ec.Id,Producto__c = prod.Id);
        insert contratoActivo;
    }
    @IsTest
    static void testActiveContracts(){
        
        Test.startTest();
        Database.executeBatch(new BatchContratosFiliales(),200); 
        Test.stopTest();
        ContratoFilial__c contratosActivos = [SELECT Id,isActive__c,Amount_last_order__c,Last_order_date__c  FROM ContratoFilial__c WHERE CodigoAS400__c = '01-30-42424-321' limit 1];
        System.assertEquals(true, contratosActivos.isActive__c);
    }
    @IsTest
    static void testInactiveContracts(){
        
        Test.startTest();
        Database.executeBatch(new BatchContratosFiliales(),200); 
        Test.stopTest();
        ContratoFilial__c contratosActivos = [SELECT Id,isActive__c,Amount_last_order__c,Last_order_date__c  FROM ContratoFilial__c WHERE CodigoAS400__c = '01-30-42424-333' limit 1];
        System.assertEquals(false, contratosActivos.isActive__c);
    }
}