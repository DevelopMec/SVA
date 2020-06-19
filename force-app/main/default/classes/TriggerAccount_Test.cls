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
            
            Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true, ProductCode = '222', SendToSIGLO__c = true, IDInterno__c = '29');
        	insert prod;
            
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        	insert standardPrice;

            Opportunity oppFisica = new Opportunity(Name = 'oppFisica', StageName = 'Contrato', CloseDate = Date.Today(), Account = cuenta);
            insert oppFisica;
            
            Quote quoteFisica = new Quote(Name = 'test', OpportunityId = oppFisica.Id, Pricebook2Id = pricebookId, OperationsInDollars__c = 'Sí', TransactionsEstimatedNumber__c = 7);
            insert quoteFisica;
            
            QuoteLineItem qliFisica = new QuoteLineItem(QuoteId = quoteFisica.Id, PricebookEntryId = standardPrice.Id, Quantity = 3, UnitPrice = 3, Product2Id = prod.Id);
        	insert qliFisica;
            
            Contact repLegal = new Contact(AccountId = cuenta.Id, LastName='sfsaf',Funcion__c = 'Representante Legal', Calle__c='callejon',Colonia__C='sanlorenzo',
                                           CodigoPostal__c='53426',Estado__c='Campeche',Ciudad__C='campeche', Curp__c = 'FEPM890204HASRRN08', Nationality__c = 'MEXICO', 
                                           Email = 'test@mail.com', Birthdate = Date.newInstance(1900, 01, 01), MaritalStatus__c = '003', Gender__c = 'Masculino', Phone = '1234');
            insert repLegal;
            
            Contrato2__c contrato2Fisica = new Contrato2__c(Name = 'test', Contacto__c = repLegal.Id, PartidaPresupuesto__c = qliFisica.Id);
            insert contrato2Fisica;
            
            cuenta.Calle__c = 'Mariano Escobedo';
            cuenta.NumeroInterior__c = '90';
            cuenta.CodigoPostal__c = '11520';
            cuenta.Colonia__c = 'Parques Polanco';
            cuenta.Website = 'test';
            cuenta.Phone = '123';
            
            update cuenta;
        }
    }
}