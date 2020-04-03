/**
	* Author 		Desarrollo Freeway
	* Date 			01/01/2020
	* Clases que cubre:
		-ApprovalProcessCustomCommentsController
**/
@isTest
public class ApprovalProcessCustomCommentsCtrl_Test {
    
    @testSetup static void setup() {
        User adminUser = [Select Id from User where Profile.Name = 'Administrador del Sistema' and IsActive=true limit 1];
        /*User u = [Select Id,UserRole.DeveloperName,State from User where Segmento__c='MLK' and IsActive=true limit 1];
        System.runAs(u){
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
            l.Email = 'tes@te.co';
            l.Phone = '65432456789';
            l.Giro__c = 'Construccion';
            l.Subgiro_PL__c = 'Edificacion';
            insert l;
            
            Task t = new Task();
            t.WhoId = l.Id;
            insert t;
            
            l.Status = 'En curso';
            update l;
            
            Database.LeadConvert dlc = new Database.LeadConvert();
            dlc.setConvertedStatus('Calificado');
            dlc.setLeadId(l.Id);
            Database.convertLead(dlc,true);
            
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
            cot.RequiredApprovalLevel__c = 1;
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
            Approval.ProcessResult result = Approval.process(app);
        }*/
    }
    
    //@isTest static void getCommentsFromProcessInstanceStep() {
        //Quote cot = [SELECT Id FROM Quote];
        //ProcessInstanceStep processInstStep = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId =: cot.Id];	
        //Test.startTest();
        //ApprovalProcessCustomCommentsController.allApprovalInfo response = ApprovalProcessCustomCommentsController.getCommentsInfo(processInstStep.Id);
        //Test.stopTest();
        //System.assertEquals(true, response.isQuote, 'The object related to the approval process is a Quote.');
   // }
    
    @isTest static void getCommentsFromProcessInstanceWI() {
        //Quote cot = [SELECT Id FROM Quote];
        //ProcessInstanceWorkItem processWI = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId =: cot.Id];	
        Test.startTest();
        ApprovalProcessCustomCommentsController.getCommentsInfo('');
        Test.stopTest();
        //System.assertEquals(true, response.isQuote, 'The object related to the approval process is a Quote.');
    }
    /*
    @isTest static void insertCommentsFromProcessInstanceStep() {
        User u = [Select Id,UserRole.DeveloperName,State from User where Segmento__c='MLK' and IsActive=true limit 1];
        Quote cot = [SELECT Id FROM Quote];
        System.runAs(u){
            ProcessInstanceStep processInstStep = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId =: cot.Id];	
            Test.startTest();
            ApprovalProcessCustomCommentsController.insertComments(processInstStep.Id, 'Test comments.');
            Test.stopTest();
            Comment__c insertedComment = [SELECT Id,Comment__c FROM Comment__c WHERE Comment__c = 'Test comments.'];
            System.assertEquals('Test comments.', insertedComment.Comment__c, 'The comment has been inserted.');
        }
    }
    
    @isTest static void insertCommentsFromProcessInstanceWI() {
        User u = [Select Id,UserRole.DeveloperName,State from User where Segmento__c='MLK' and IsActive=true limit 1];
        Quote cot = [SELECT Id FROM Quote];
        System.runAs(u){
            ProcessInstanceWorkItem processWI = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId =: cot.Id];	
            Test.startTest();
            ApprovalProcessCustomCommentsController.insertComments(processWI.Id, 'Test comments.');
            Test.stopTest();
            Comment__c insertedComment = [SELECT Id,Comment__c FROM Comment__c WHERE Comment__c = 'Test comments.'];
            System.assertEquals('Test comments.', insertedComment.Comment__c, 'The comment has been inserted.');
        }
    }*/
    
}