@isTest
public class TriggerContactHandlerTest {
    @isTest
    public static void TriggerContactHandler(){

        Account acc = new Account(Name = 'test');
        insert acc;

        Contact repLegal = new Contact(AccountId = acc.Id, LastName='sfsaf',Funcion__c = 'Representante Legal', Calle__c='callejon',Colonia__C='sanlorenzo',
                                        CodigoPostal__c='53426',Estado__c='Campeche',Ciudad__C='campeche', Curp__c = 'FEPM890204HASRRN08', Nationality__c = 'MEXICO', 
                                        Email = 'test@mail.com', Birthdate = Date.newInstance(1900, 01, 01), MaritalStatus__c = '003', Gender__c = 'Masculino', Phone = '1234');
        insert repLegal;

        repLegal.Email = 'test2@mail.com';
        update repLegal;

        
    }	
}