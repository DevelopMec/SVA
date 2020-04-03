@isTest
public class Vista_EjecutivosAsignadosController_Test {
     @isTest(seeAllData=true)
     public static void Test(){
         
         ContratoFilial__c cf = [Select Entidad_Cuenta__r.Cuenta__r.Id
                                 From ContratoFilial__c Where isActive__c=true LIMIT 1];
         
        Vista_EjecutivosAsignadosController.getListEjecutivos(cf.Entidad_Cuenta__r.Cuenta__r.Id);
    }
    

    @isTest
    public static void accountWithoutContract() {
              
        Account acc=new Account();
        acc.Name='test';
        insert acc;
        Contact c=new Contact();
        c.AccountId=acc.Id;
        c.FirstName='test';
        c.LastName='test';
        insert c;
        
        
        Vista_EjecutivosAsignadosController.getListEjecutivos(acc.Id);
    }
    
    

    
}