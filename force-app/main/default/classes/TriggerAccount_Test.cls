@isTest
public class TriggerAccount_Test {
    
    @isTest
    static void createAccount(){
        
        User ejecutivo = [SELECT Id FROM User WHERE Profile.Name = 'Ventas' AND isActive = true LIMIT 1];
        System.runAs(ejecutivo){
            Account cuenta = new Account(Name='Cuenta Prueba', Phone='1029218271',NumeroEmpleados__c='51-125', esConversionLead_Checkbox__c=false);
            insert cuenta;
            
            CatalogoDirecciones__c direccion = new CatalogoDirecciones__c();
            direccion.Calle_Tt__c = 'Lago Alberto';
            direccion.Ciudad_Tt__c = 'CDMX';
            direccion.CodigoPostal_Tt__c = '11420';
            direccion.Colonia_Tt__c = 'Polanco';
            direccion.CuentaID__c = cuenta.Id;
            direccion.DelegacionMunicipio_Tt__c = 'Miguel Hidalgo';
            direccion.Estado_Tt__c = 'CDMX';
            direccion.Name = 'Lago Alberto';
            direccion.Tipo_Pt__c ='Cuenta';
            
            insert direccion;
            
            cuenta.Calle__c = 'Mariano Escobedo';
            cuenta.NumeroInterior__c = '90';
            cuenta.CodigoPostal__c = '11520';
            cuenta.Colonia__c = 'Parques Polanco';
            
            update cuenta;
        }
    }
}