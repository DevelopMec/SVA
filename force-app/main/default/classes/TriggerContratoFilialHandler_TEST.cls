@isTest
public class TriggerContratoFilialHandler_TEST {
    @isTest
    public static void metodo1(){
        insert new ContratoFilial__c(Name='01-32-53666-002',CodigoAS400__c='01-32-53666-002');
        
        ContratoFilial__c cf = new ContratoFilial__c(Name='01-32-53644-002',CodigoAS400__c='01-32-53644-002');
        insert cf; 
        
        Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true, ProductCode = '222', SendToSIGLO__c = true, IDInterno__c = '29');
        insert prod;
        
        cf.Producto__c = prod.Id;
        update cf;
        
        
    }	
}