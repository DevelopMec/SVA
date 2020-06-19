/**********************************************************************************
Developed by: Freeway Consulting
Author: Hector Diaz
Project:  "Edenred" 
Description: .
---------------------------------------------------------------------------------
Version       Date         Author                   Description
------ ---------- ---------------------------------------------------------------
1.0       18-Mayo-2020      Hector Diaz               Initial version
*************************************************************************************/
@isTest
public class TriggerEscalationCaseHandler_tst {
    static Account acc;
    static Contact ctc;
    static List<EntidadCuenta__c> listEntidadCuenta;
    @isTest static void testMethodTriggerEscalationCaseHandler(){ 
        acc = new Account();
        acc.Name = 'Acc Test';
        insert acc;

        ctc = new Contact();
        ctc.LastName = 'LastName';
        ctc.AccountId = acc.Id;
        insert ctc;

        EntidadLegal__c entidadLegal = new EntidadLegal__c();
        entidadLegal.Name = 'HIGJ770413EV9';
        entidadLegal.Cuenta__c = acc.Id;
        entidadLegal.RFC__c = 'HIGJ770413EV9';
        insert entidadLegal;
        
        listEntidadCuenta = [SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: acc.Id AND EntidadLegal__c =: entidadLegal.Id];

        Product2 producto_2 = new Product2();
        producto_2.Name = 'Producto Test';
        producto_2.Family = 'Combustible';
        producto_2.ProductCode = '2';
        insert producto_2;
        
        
        ContratoFilial__c contratoFilial_2 = new ContratoFilial__c();
        contratoFilial_2.Name = '11-22-33333-444';
        contratoFilial_2.Entidad_Cuenta__c = listEntidadCuenta[0].Id;
        contratoFilial_2.Producto__c = producto_2.Id;
        insert contratoFilial_2;


        
        Case caso_2 = new Case();
        caso_2.AccountId = acc.Id;
        caso_2.ContactId = ctc.Id;
        caso_2.Contrato_Filial__c = contratoFilial_2.Id;
        caso_2.Type = 'Solicitud';      
        caso_2.Status = 'Abierto';
        caso_2.Origin = 'Web';
        insert caso_2; 

        escalation_History__c objescalationH = new escalation_History__c();
        objescalationH.Name = 'EscalacionCaso';
        objescalationH.ticket__c = caso_2.Id;
        insert objescalationH;

        escalation_History__c objescalation2 = new escalation_History__c();
        objescalation2.Name = 'EscalacionCaso';
        objescalation2.ticket__c = caso_2.Id;
        insert objescalation2;

        TriggerEscalationCaseHandler objTriggerEscalation = new TriggerEscalationCaseHandler();
    }
}