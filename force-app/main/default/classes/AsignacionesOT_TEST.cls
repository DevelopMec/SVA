/*************************
Cambios
Fecha		|	Autor 	          	|	Descripción
01/11/2019  | 	Desarrollo Freeway	|	Se modifica el método metodo1 para llenar los campos Giro__c y Subgiro_PL__c del prospecto y que esté en el estatus correcto antes de convertirlo.
										Se cambia el valor del campo Tipo_de_Ticket__c para la variable sub.
*************************/

@isTest
public class AsignacionesOT_TEST {
    @testSetup
    public static void testSetup(){
        List<sObject> listG=new List<sObject>();
        ServiceGroups__c  sg=new ServiceGroups__c();
        sg.Name='test';
        sg.RecordTypeId=Schema.SObjectType.ServiceGroups__c.getRecordTypeInfosByDeveloperName().get('WorkOrders').getRecordTypeId();
        listG.add(sg);
        ServiceGroups__c  s2=new ServiceGroups__c();
        s2.Name='test2';
        s2.RecordTypeId=Schema.SObjectType.ServiceGroups__c.getRecordTypeInfosByDeveloperName().get('WorkOrders').getRecordTypeId();
        listG.add(s2);
        insert listG;
        listG.clear();
        ServiceGroupsUser__c sgu=new ServiceGroupsUser__c();
        sgu.ServiceGroup__c=sg.Id;
        sgu.User__c=UserInfo.getUserId();
        listG.add(sgu);
        ServiceGroupsUser__c sgu2=new ServiceGroupsUser__c();
        sgu2.ServiceGroup__c=s2.Id;
        sgu2.User__c=UserInfo.getUserId();
        listG.add(sgu2);
        insert listG;
        
        User u=[Select Id,UserRole.DeveloperName,State from User where Segmento__c='MLK' and IsActive=true limit 1];
        System.runAs(u){
            SubMotivo__c sub=new SubMotivo__c();
            sub.RecordTypeId=Schema.SObjectType.SubMotivo__c.getRecordTypeInfosByDeveloperName().get('WorkOrders').getRecordTypeId();
            sub.Name='test';
            sub.Role__c=u.UserRole.DeveloperName;
            sub.AssignmentBy__c='Directa';
            sub.Tipo_de_Ticket__c='Solicitud';
            sub.Grupo_Soporte_1__c='test';
            sub.Motivo__c='Asignación OT';
            sub.Grupo_Soporte_2__c='test2';
            insert sub;
            Lead l=new Lead();
            l.Status='Contactado';
            l.CategoriaSolucion__c='Combustible';
            l.Competidor__c='Amex';
            l.ProductoInteres__c='Combustible';
            l.FirstName='test';
            l.NumEmpleados__c='1-25';
            l.RFC__c='AAPD940930NE4';
            l.Company='tes';
            l.LastName='test';
            l.LeadSource='Cambaceo';
            l.Email='tes@te.co';
            l.Phone='6543245678';
            l.Giro__c = 'Construccion';
            l.Subgiro_PL__c = 'Edificacion';
            l.Sector__c='Público';
            insert l;
            Task t=new Task();
            t.WhoId=l.Id;
            insert t;
            l.Status = 'En curso';
            update l;
            Test.startTest();
            Database.LeadConvert dlc=new Database.LeadConvert();
            dlc.setConvertedStatus('Calificado');
            dlc.setLeadId(l.Id);
            Database.convertLead(dlc,true);
            Test.stopTest();
        }
    }
	@isTest
    public static void metodo1(){        
        User u=[Select Id,UserRole.DeveloperName,State from User where Segmento__c='MLK' and IsActive=true limit 1];
        System.runAs(u){            
            Opportunity opp=[Select Id,StageName from Opportunity limit 1];            
            Product2 prod=new Product2();
            prod.Name='30-TC';
            prod.ProductCode='30';
            insert prod;
            System.debug('1::'+opp.StageName);
            PricebookEntry pe=new PricebookEntry();
            pe.Pricebook2Id=Test.getStandardPricebookId();
            pe.IsActive=true;
            pe.Product2Id=prod.Id;
            pe.UnitPrice=0;
            insert pe;
            System.debug('2');
            Quote cot=new Quote();
            cot.OpportunityId=opp.Id;
            cot.Name='test';
            cot.Pricebook2Id=Test.getStandardPricebookId();
            insert cot;
            System.debug('3');
            Test.startTest();
            QuoteLineItem qli=new QuoteLineItem();
            qli.QuoteId=cot.Id;
            qli.PricebookEntryId=pe.Id;
            qli.Quantity=1;
            qli.UnitPrice=1;
            qli.Product2Id=prod.Id;
            insert qli;
            System.debug('4');
            Contrato2__c adv=new Contrato2__c();
            adv.Activo__c=true;
            adv.PartidaPresupuesto__c=qli.Id;
            insert adv;            
            
            System.debug('5');
            WorkOrder wo=new WorkOrder();
            wo.Oportunidad__c=opp.Id;
            wo.Estatus__c='Pedido de tarjetas';
            insert wo;
            Submotivo__c sub=[Select Id from Submotivo__c limit 1];
            sub.AssignmentBy__c='State';
            sub.Values__c=u.State;
            update sub;
            System.debug('6');
            WorkOrder wo2=new WorkOrder();
            wo2.Oportunidad__c=opp.Id;
            wo2.Estatus__c='Pedido de tarjetas';
            insert wo2;
            sub.AssignmentBy__c='Familia__c';
            sub.Values__c='Combustible';
            update sub;
            WorkOrder wo3=new WorkOrder();
            wo3.Oportunidad__c=opp.Id;
            wo3.Estatus__c='Pedido de tarjetas';
            insert wo3;
            wo3.Estatus__c='Concluida';
            wo3.StartDate=Date.today().addDays(-1);
            wo3.VolumenEmisionMensual2__c=100;
            update wo3;
            Test.stopTest();
        }
    }    
}