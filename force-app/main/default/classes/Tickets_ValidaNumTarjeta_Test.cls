@istest 
public class Tickets_ValidaNumTarjeta_Test {

    @isTest
    public static void Test(){
        
         Negocio__c config = new Negocio__c();
        config.TicketUsuario_Tarjeta_Client_id__c = '331';
        config.TicketUsuario_Tarjeta_Client_secret__c = 'pfbqEawMkMDzLHFx584g';
        config.TicketUsuario_Tarjeta_X_Client_id__c = '331';
        config.TicketUsuario_Tarjeta_X_Client_secret__c = 'pfbqEawMkMDzLHFx584g';
        config.TicketUsuario_Tarjeta_Grant_type__c = 'client_credentials';
        config.TicketUsuario_Tarjeta_Scope__c = 'hana.mx.ben';
        config.TicketUsuario_Tarjeta_DataURL__c = 'https://xp-crm-beneficiaries-prep-mx-v1.us-w1.cloudhub.io/api/cards?operation=GetDetail';
        config.TicketUsuario_Tarjeta_TokenURL__c = 'http://prep-ermx-is4.us-e1.cloudhub.io/connect/token';
        insert config;    
        
        Case ticket = new Case();
        ticket.Type = 'Asesoría Usuario';
        ticket.Tarjeta__c = '6036810600010448';
        ticket.ContactName__c = 'test';
        ticket.Origin = 'Correo';
        ticket.PaperVoucher__c = false;
        insert ticket;
        
        Case ticket2 = new Case();
        ticket2 = new Case();
        ticket2.Type = 'Asesoría';
        ticket2.Tarjeta__c = '';
        ticket2.ContactName__c = 'test';
        ticket.Origin = 'Correo';
        ticket2.PaperVoucher__c = true;
        ticket2.ID_de_la_Llamada__c = '1';
        insert ticket2;

        product2 prod = new product2();
        prod.Card_Relationship__c = '603681';
        prod.ProductCode = '12';
        prod.Name = 'Producto12';
        insert prod;
        
        prod = new product2();
        prod.Card_Relationship__c = '';
        prod.ProductCode = '30';
        prod.Name = 'Producto30';
       insert prod;
        
        
        Test.setMock(HttpCalloutMock.class, new Tickets_ValidaNumTarjeta_WS_Mock());
        Tickets_ValidaNumTarjeta_CONT.buscarTarjeta('','');
        Test.startTest();
        
        
        Tickets_ValidaNumTarjeta_CONT result =  Tickets_ValidaNumTarjeta_CONT.ObtenerDatos(ticket.Id,'');
        System.debug('result ' + result);
         Tickets_ValidaNumTarjeta_CONT.GuardarDatos(ticket.Id,'3');
        Tickets_ValidaNumTarjeta_CONT.GuardarDatos(ticket.Id,'6036810600010448');
       Tickets_ValidaNumTarjeta_CONT.GuardarDatos(ticket2.Id,'04E6C392AB4A80');
        Tickets_ValidaNumTarjeta_CONT.GuardarDatos(ticket2.Id,'xxxx');
       
        
        Test.stopTest();
    }
    
}