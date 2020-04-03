/**
    * Author        Desarrollo Freeway
    * Date          01/01/2020
    * Clases que cubre:
        -QuoteMultilevelApprovalProcess
        -QuoteTriggerHandler
        -QuoteTrigger
**/
@isTest
public class QuoteMultilevelApprovalProcess_Test {
    
    
    @testSetup static void setup() {
        User adminUser = [Select Id from User where Profile.Name = 'Administrador del Sistema' and IsActive=true limit 1];
        //User u = [Select Id,UserRole.DeveloperName,State from User where Segmento__c='MLK' and UserRole.Name = '' IsActive=true limit 1];
        UserRole r = new UserRole(DeveloperName = 'EjecutivoCrossSell', Name = 'Ejecutivo Cross Sell');
        insert r;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Administrador del Sistema' OR Name='System Administrator']; 
        User testUser = new User(Alias = 'testus', Email = 'test_user@testorg.com', 
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = r.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test_user@testorg.com');
        insert testUser;
        System.runAs(testUser){
            Lead l = new Lead();
            l.Status = 'Contactado';
            l.CategoriaSolucion__c = 'Combustible';
            l.Competidor__c = 'Amex';
            l.ProductoInteres__c = 'Combustible';
            l.FirstName = 'Lead Test';
            l.NumEmpleados__c = '1-25';
            l.RFC__c = 'AAPD940930NE4';
            l.Company = 'tes';
            l.LastName = 'test';
            l.LeadSource = 'Cambaceo';
            l.Email = 'tes@te.com';
            l.Phone = '6543245678';
            l.Giro__c = 'Construccion';
            l.Sector__c='Público';
            l.Subgiro_PL__c = 'Edificacion';
            insert l;
            
            Task t = new Task();
            t.WhoId = l.Id;
            insert t;
             Test.startTest();
            l.Status = 'En curso';
            update l;
            
            Database.LeadConvert dlc = new Database.LeadConvert();
            dlc.setConvertedStatus('Calificado');
            dlc.setLeadId(l.Id);
            Database.convertLead(dlc,true);
            Test.stopTest();
            Opportunity opp = [Select Id, AccountId from Opportunity limit 1]; 
            
            Contact con = new Contact();
            con.FirstName = 'FN Test';
            con.LastName = 'LN Test';
            con.Email = 'con@test.com';
            con.AccountId = opp.AccountId;
            insert con;
            
            opp.Contacto__c = con.Id;
            update opp;
            
            Product2 prod = new Product2();
            prod.Name = '30-TC';
            prod.ProductCode = '30';
            insert prod;
            
            PricebookEntry pe = new PricebookEntry();
            pe.Pricebook2Id = Test.getStandardPricebookId();
            pe.IsActive = true;
            pe.Product2Id = prod.Id;
            pe.UnitPrice = 0;
            insert pe;
            
            Quote cot = new Quote();
            cot.OpportunityId = opp.Id;
            cot.Name = 'Opportunity Test';
            cot.Pricebook2Id = Test.getStandardPricebookId();
            cot.RequiredApprovalLevel__c = 3;
            insert cot;
            
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = cot.Id;
            qli.PricebookEntryId = pe.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 1;
            qli.Product2Id = prod.Id;
            insert qli;
            
            //Submit Quote for Approval
            Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
            app.setObjectId(cot.id);
            app.setProcessDefinitionNameOrId('QuoteApprovalLevel1');
            app.setNextApproverIds(new Id[] {adminUser.Id});
            //Approval.ProcessResult result = Approval.process(app);
        }
    }
    
    @isTest static void commentsRequiredTest() {
        Quote cot = [SELECT Id FROM Quote];
        //ProcessInstanceWorkItem processInstWI = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId =: cot.Id];    
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setAction('Reject');
        //req2.setWorkitemId(processInstWI.Id);
        
        Test.startTest();
        try {
            Approval.ProcessResult result2 =  Approval.process(req2);
        } catch  (Exception e) {
            //System.assert(e.getMessage().contains('Favor de incluir los comentarios.'),'The comments are required for reject and approve.');
        }
        Test.stopTest();
    }
    
    @isTest static void grantedApproveLevel1() {
        Quote cot = [SELECT Id FROM Quote];
        //ProcessInstanceWorkItem processInstWI = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId =: cot.Id];    
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setAction('Approve');
        req2.setComments('Approve test comments.');
        //req2.setWorkitemId(processInstWI.Id);
        Test.startTest();
        //Approval.ProcessResult result2 =  Approval.process(req2);
        Test.stopTest();
        //ProcessInstanceWorkItem processInstPending = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId =: cot.Id
        //                                        AND ProcessInstance.Status = 'Pending'];    
        //System.assert(processInstPending != null, 'Se envió el segundo proceso de aprobación');
    }
            
}