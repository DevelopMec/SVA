@isTest
public class DocuSignStatusTriggerHandler_TEST {
    @isTest
    public static void metodo1(){
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25'); 
        insert acc;
        Opportunity opp = new Opportunity(IsApprovedCreditEval__c='No',AccountId = acc.Id, Name = 'Prueba', StageName = 'Prospecting', CloseDate = System.today());
        insert opp;
        dsfs__DocuSign_Status__c ds= new dsfs__DocuSign_Status__c(OwnerId=UserInfo.getUserId(),dsfs__Opportunity__c=opp.Id);
        insert ds;
        ds.dsfs__Envelope_Status__c='Delivered';
        update ds;
    }
}