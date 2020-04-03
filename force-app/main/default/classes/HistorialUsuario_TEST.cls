@isTest
public class HistorialUsuario_TEST {
    @testSetup
    public static void setup(){
        GeneralCatalog__c gc=new GeneralCatalog__c(Name='Campos Historial de Usuario',Value__c='FirstName;ProfileId;UserRoleId',RecordTypeId=Schema.SObjectType.GeneralCatalog__c.getRecordTypeInfosByDeveloperName().get('GenericRecord').getRecordTypeId());
        insert gc;
    }
	@isTest
    public static void metodo1(){        
        Test.startTest();
        Profile p=[Select Id from Profile where Name LIKE '%Posventa%'  limit 1];
        User u=[Select Id,Name from User where Profile.Name LIKE '%Ventas%' limit 1];
        u.FirstName='Test';
        u.ProfileId=p.Id;
        u.UserRoleId=null;
        update u;
        HistorialUsuario_CONT.getRegistros(u.Id);
        Test.stopTest();
    }
    @isTest
    public static void metodo2(){        
        Test.startTest();
        User u=[Select Id,Name from User where Profile.Name LIKE '%Ventas%' limit 1];
        insert new UserHistory__c(Field__c='FisrtName',PriorValue__c='Test',NewValue__c='Test2',UserPerformsModification__c=UserInfo.getUserId(),User__c=u.Id);
        HistorialUsuario_CONT.getRegistros(u.Id);
        Test.stopTest();
    }
}