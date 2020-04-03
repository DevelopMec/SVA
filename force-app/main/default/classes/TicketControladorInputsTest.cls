@isTest
public class  TicketControladorInputsTest {
      
    
    
   @isTest public static Void testTickets() {
      new TicketControladorInputs();
       /*Direccion__c TicketCodigoPostal= New Direccion__c(Name='Mex-1111',CodigoPostal__c='11-1111');
       insert TicketCodigoPostal; System.debug('TicketCodigoPostal **********: '+TicketCodigoPostal);
             
       
       Account Ticketcuenta = New Account(Name = 'ticketcuentaprueba', 	Sector__c='Público', Phone='1111111', Giro__c='Construccion', Subgiro__c='Edificacion', Calle__c='El Parque', NumeroExterior__c='1111', ColMpoCpEdo__c= TicketCodigoPostal.Id);
      
       insert Ticketcuenta; System.debug('Ticketcuenta: **********'+Ticketcuenta);
       
       Contact Ticketcontacto =  New Contact(FirstName = 'ticketcontactoprueba', LastName = 'ticketcontactoprueba', AccountId=Ticketcuenta.Id );
       
       insert Ticketcontacto; System.debug('Ticketcontacto: **********'+Ticketcontacto);
       
       Id TicketEntLegId = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();
       System.debug('TicketEntidadLegalId: **********'+TicketEntLegId);
       

       EntidadLegal__c TicketEntLeg = New EntidadLegal__c(RecordTypeId=TicketEntLegId, Name= 'BAFD941005LS0', RazonSocial__c='EntLegalRSocial' );
       insert TicketEntLeg  ;System.debug('TicketEntidadLegal: **********'+TicketEntLeg);
       
       EntidadCuenta__c TicketEntidadCuenta = 	New EntidadCuenta__c(Cuenta__c= Ticketcuenta.Id, Name='Entidad-1111', EntidadLegal__c=TicketEntLeg.Id);
       System.debug('TicketEntidadCuenta: **********'+TicketEntidadCuenta);
        insert TicketEntidadCuenta;   
       
       Contrato2__c TicketContrato2 = New Contrato2__c(Name='TickectContrato2', Cuenta__c= Ticketcuenta.Id);
        insert TicketContrato2;  System.debug('Ticketcontratofl: **********'+TicketContrato2); 
       
       ContratoFilial__c Ticketcontratofl = New ContratoFilial__c(Name= 'Ticketcontratofl',	Entidad_Cuenta__c=TicketEntidadCuenta.Id, Contrato_2__c=TicketContrato2.Id);
       insert Ticketcontratofl;System.debug('Ticketcontratofl: **********'+Ticketcontratofl); 
       
       
       
      Case TicketCaso= New Case(AccountId =Ticketcuenta.Id, ContactId=Ticketcontacto.Id, Contrato_Filial__c=Ticketcontratofl.Id, Type='Asesoría', ID_de_la_Llamada__c='10');  
      insert TicketCaso;   System.debug('Ticket: **********'+TicketCaso); 
       
       
       
      
     Test.startTest();  
       
      Case b = TicketControladorInputs.EncuentraValores(TicketCaso.Id);
       
     system.debug('****************** Final del Test ****************************');
       System.assertEquals(Ticketcuenta.Id,b.AccountId);
       System.assertEquals(Ticketcontacto.Id,b.ContactId);
       System.assertEquals(Ticketcontratofl.Id,b.Contrato_Filial__c);
       System.assertEquals('Asesoría',b.Type);
       Test.stopTest(); 
     
       
       
        */}
        
}