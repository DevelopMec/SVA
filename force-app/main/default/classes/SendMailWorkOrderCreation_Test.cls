/**
    * Author        Desarrollo Freeway
    * Date          28/11/2019
                    Clases que cubre:
                        -SendMailWorkOrderCreation
**/

@isTest
public class SendMailWorkOrderCreation_Test {

    @isTest static void alertTest() {
        ServiceGroups__c sg = new ServiceGroups__c();
        sg.Name = 'test';
        sg.RecordTypeId = Schema.SObjectType.ServiceGroups__c.getRecordTypeInfosByDeveloperName().get('WorkOrders').getRecordTypeId();
        insert sg;
        
        ServiceGroupsUser__c sgu = new ServiceGroupsUser__c();
        sgu.ServiceGroup__c = sg.Id;
        sgu.User__c = UserInfo.getUserId();
        insert sgu;
       
        User u = [Select Id,UserRole.DeveloperName,State from User where Segmento__c='MLK' and IsActive=true limit 1];
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
            l.Sector__c='Público';
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
            insert cot;
            
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = cot.Id;
            qli.PricebookEntryId = pe.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 1;
            qli.Product2Id = prod.Id;
            insert qli;
            
            Test.startTest();
            Contrato2__c adv = new Contrato2__c();
            adv.Activo__c = true;
            adv.PartidaPresupuesto__c = qli.Id;
            insert adv;
            
            List<WorkOrder> workOrders = new List<WorkOrder>();
            
                SubMotivo__c sub = new SubMotivo__c();
                sub.RecordTypeId = Schema.SObjectType.SubMotivo__c.getRecordTypeInfosByDeveloperName().get('WorkOrders').getRecordTypeId();
                sub.Name = 'Submotivo Test';
                sub.Role__c = u.UserRole.DeveloperName;
                sub.AssignmentBy__c = 'Directa';
                sub.Tipo_de_Ticket__c = 'Solicitud';
                sub.Grupo_Soporte_1__c = 'test';
                sub.Motivo__c = 'Asignación OT';
                sub.Grupo_Soporte_2__c = 'test2';
                insert sub;
            
                WorkOrder wo = new WorkOrder();
                wo.Oportunidad__c = opp.Id;
                wo.Estatus__c = 'Pedido de tarjetas';
                wo.Correo_Contacto_Asociado__c = 'con@test.com';
                insert wo;
                List<EmailMessage> messageList = ([Select Subject From EmailMessage Where Subject Like 'Inicio-Implementacion%']);
                if (!messageList.isEmpty()) {
                    delete messageList;
                }
                workOrders.add(wo);
                SendMailWorkOrderCreation.alert(workOrders);
            Test.stopTest();
            EmailMessage messageByCode = [Select Subject From EmailMessage Where Subject Like 'Inicio-Implementacion%'];
            System.assert(messageByCode.Subject != null, 'The method sends the email.');
        }
    }
      
    @isTest static void testGetTemplatesMap() {
        Test.startTest();
        List<EmailTemplate> template = SendMailWorkOrderCreation.getTemplate();
        Test.stopTest();
        System.assert(!template.isEmpty(), 'The method returns the email templates map.');
    }
}