/*************************
 Clases que cubre:
    -TriggerCaseHandler
    -GruposAtencionFlujo_CONT
    -TicketValidacionCampos_CONT
Cambios
Fecha       |   Autor               |   Descripción
24/10/2019  |   Desarrollo Freeway  |   El campo Tarjeta__c se llenó con una cadena de texto en vez de con un número. 
*************************/
@isTest
public class CaseTriggerFlujo_TEST {
    @testSetup
    public static void setup(){
        Submotivo__c sub=new Submotivo__c();
        sub.Tipo_de_Ticket__c='Solicitud';
        sub.Motivo__c='Tarjeta';
        sub.Name='Tarjeta';
        sub.Grupo_Soporte_1__c='test';
        sub.Grupo_Soporte_2__c='test';
        sub.Grupo_Soporte_3__c='test';
        sub.Grupo_Soporte_4__c='test';
        sub.RequiredFields__c='Tarjeta__c';
        insert sub;
        
        ServiceGroups__c sg=new ServiceGroups__c();
        sg.Name='test';
        insert sg;
        ServiceGroups__c sg2=new ServiceGroups__c();
        sg2.Name='test2';
        insert sg2;
        User u=[Select Id from User limit 1];
        ServiceGroupsUser__c sgu=new ServiceGroupsUser__c();       
        sgu.ServiceGroup__c=sg.Id;
        sgu.User__c=u.Id;
        insert sgu;
        
        Account acc=new Account();
        acc.Name='test';
        insert acc;
        Contact c=new Contact();
        c.AccountId=acc.Id;
        c.FirstName='test';
        c.LastName='test';
        insert c;
        
        EntidadLegal__c entidadLegal = new EntidadLegal__c();
        entidadLegal.Name = 'HIJD93061278A';
        entidadLegal.Cuenta__c = acc.Id;
        insert entidadLegal;
        
        EntidadCuenta__c ec=[SELECT Id FROM EntidadCuenta__c WHERE Cuenta__c =: acc.Id AND EntidadLegal__c =: entidadLegal.Id limit 1];
        
        Product2 producto_1 = new Product2();
        producto_1.Name = 'Producto Test';
        producto_1.Family = 'Ticket Restaurante';
        producto_1.ProductCode = '1';
        insert producto_1;
        
        ContratoFilial__c contratoFilial_1 = new ContratoFilial__c();
        contratoFilial_1.Name = '11-22-33333-444';
        contratoFilial_1.Entidad_Cuenta__c = ec.Id;
        contratoFilial_1.Producto__c = producto_1.Id;
        insert contratoFilial_1;
    }
    
    @isTest
    public static void testTriggerCase(){
        
        Account acc=[Select Id from Account limit 1];
        Contact c=[Select Id from Contact limit 1];
        ContratoFilial__c cf=[Select Id from ContratoFilial__c limit 1];
        
        Case caso=new Case();
        caso.Type='Solicitud';
        caso.Origin='Web';
        caso.Status='Abierto';
        caso.AccountId=acc.Id;
        caso.ContactId=c.Id;
        caso.Contrato_Filial__c=cf.Id;
        insert caso;
        Test.startTest();
        caso.Motivo__c='Tarjeta';
        caso.Sub_Motivo__c='Tarjeta';
        update caso;
        
        try{
        caso.Status='En Proceso';
        update caso;
        }catch(Exception e){}
        caso.Tarjeta__c='23456789';
        caso.Status='En Proceso';
        update caso;
        Test.stopTest();
    }
    
    @isTest
    public static void testCaseFlujo(){
        
        Account acc=[Select Id from Account limit 1];
        Contact c=[Select Id from Contact limit 1];
        ContratoFilial__c cf=[Select Id from ContratoFilial__c limit 1];
        
        Case caso = new Case();
        caso.Type='Solicitud';
        caso.Origin='Web';
        caso.Status='Abierto';
        caso.AccountId=acc.Id;
        caso.ContactId=c.Id;
        caso.Contrato_Filial__c=cf.Id;
        caso.Type='Solicitud';
        caso.Motivo__c='Tarjeta';
        caso.Sub_Motivo__c='Tarjeta';
        insert caso;
        
        Test.startTest();
        
        //caso.Type='Solicitud';
        //caso.Motivo__c='Tarjeta';
        //caso.Sub_Motivo__c='Tarjeta';
        //update caso;
        
        GruposAtencionFlujo_CONT.escalarRechazarCaso(caso.Id, 'test', 'escalar');
        GruposAtencionFlujo_CONT.escalarRechazarCaso(caso.Id, 'test', 'rechazar');
        GruposAtencionFlujo_CONT.cambiarTipoCaso('Solicitud', caso.Id);
        GruposAtencionFlujo_CONT.getTipos(caso.Id);
        
        caso.Tarjeta__c='23456789';
        update caso;
        
        GruposAtencionFlujo_CONT.escalarRechazarCaso(caso.Id, 'test', 'escalar');
        caso.Status='Concluido';
        update caso;
        
        GruposAtencionFlujo_CONT.escalarRechazarCaso(caso.Id, 'test', 'escalar');

        
        Test.stopTest();
        
        List<id> ids= new List<id>();
        ids.add(caso.Id);
        GrupoAtencionFlujo_Siguiente.SiguienteGrupoAtencion(ids);
    }
    
    @isTest
    public static void testCaseFlujoRechazo(){
        
        Account acc=[Select Id from Account limit 1];
        Contact c=[Select Id from Contact limit 1];
        ContratoFilial__c cf=[Select Id from ContratoFilial__c limit 1];
        
        Case caso=new Case();
        caso.Type='Solicitud';
        caso.Origin='Web';
        caso.Status='Abierto';
        caso.AccountId=acc.Id;
        caso.ContactId=c.Id;
        caso.Contrato_Filial__c=cf.Id;
        insert caso;
        
        Test.startTest();
        
        caso.Type='Solicitud';
        caso.Motivo__c='Tarjeta';
        caso.Sub_Motivo__c='Tarjeta';
        caso.Tarjeta__c='23456789';
        update caso;
        
        GruposAtencionFlujo_CONT.escalarRechazarCaso(caso.Id, 'test', 'rechazar');
        caso.Status='En Proceso';
        update caso;
        
        GruposAtencionFlujo_CONT.escalarRechazarCaso(caso.Id, 'test', 'rechazar');
        Test.stopTest();
    }
    
    @isTest
    public static void testCaseCampos(){
        
        Account acc=[Select Id from Account limit 1];
        Contact c=[Select Id from Contact limit 1];
        ContratoFilial__c cf=[Select Id from ContratoFilial__c limit 1];
        
        Case caso=new Case();
        caso.Type='Solicitud';
        caso.Origin='Web';
        caso.Status='Abierto';
        caso.AccountId=acc.Id;
        caso.ContactId=c.Id;
        caso.Contrato_Filial__c=cf.Id;
        insert caso;
        
        Test.startTest();
        caso.Type='Solicitud';
        caso.Motivo__c='Tarjeta';
        caso.Sub_Motivo__c='Tarjeta';
        caso.Tarjeta__c='23456789';
        update caso;
        
        TicketValidacionCampos_CONT.getInfo(caso.Id);
       
        Test.stopTest();
    }
    
     @isTest
    public static void TestCaseValidaEnvioAprobacion(){
        Account acc=[Select Id from Account limit 1];
        Contact c=[Select Id from Contact limit 1];
        ContratoFilial__c cf=[Select Id from ContratoFilial__c limit 1];
        User u = [Select Id from User Where Department= 'Contabilidad' and IsActive= true limit 1];
        
        Case caso=new Case();
        caso.Type='Solicitud';
        caso.Motivo__c='Facturacion';
        //caso.Sub_Motivo__c='Re clasificacion';
        caso.Origin='Web';
        caso.Status='Abierto';
        caso.AccountId=acc.Id;
        caso.ContactId=c.Id;
        caso.Contrato_Filial__c=cf.Id;
        caso.OwnerId = u.Id;
        insert caso;    
      
        Submotivo__c sub = new Submotivo__c();
        sub.Tipo_de_Ticket__c = caso.Type;
        sub.Motivo__c = caso.Motivo__c;
        sub.Name = caso.Sub_Motivo__c;
        sub.RequiredFields__c = 'Contrato_Filial__c';
        insert sub;
        
        TicketValidacionCampos_CONT.ValidaEnvioAprobacion(caso.Id);
    }
}