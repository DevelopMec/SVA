@isTest
public class TicketEntitlementAssignTest {
    
    
   /*@isTest public static Void testEntitlement() {
      
            
       Direccion__c TicketCodigoPostal= New Direccion__c(Name='Mex-1111',CodigoPostal__c='11-1111');
       insert TicketCodigoPostal; System.debug('TicketCodigoPostal **********: '+TicketCodigoPostal);
             
       
       Account Ticketcuenta = New Account(Name = 'ticketcuentaprueba', 	Sector__c='Público', Phone='1111111', Giro__c='Construccion', Subgiro__c='Edificacion', Calle__c='El Parque', NumeroExterior__c='1111', ColMpoCpEdo__c= TicketCodigoPostal.Id);
       Account Entcuenta = New Account(Name = 'Entitlements', 	Sector__c='Privado', Phone='1111111', Giro__c='Construccion', Subgiro__c='Edificacion', Calle__c='El Parque', NumeroExterior__c='1111', ColMpoCpEdo__c= TicketCodigoPostal.Id);

       insert Ticketcuenta; System.debug('Ticketcuenta: **********'+Ticketcuenta);
       insert Entcuenta;System.debug('Entcuenta: **********'+Entcuenta);
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
       
            
     	string SubmotivosAplicables1 = 'Administrador;Apoderado Legal;Cambio de No. de Nómina masivo;Cambio de persona;de diferente grupo;del mismo grupo;Dirección Auxiliar;Domicilio Fiscal;No reconoce la entrega;Pedido incompleto;Pedido incorrecto (ordenamiento);Razón Social;Sobres abiertos/maltratados;Vales dañados';
	 	Entitlement TicketEnt1 =  New Entitlement(Name='3 días hábiles', AccountId=Entcuenta.Id ,Submotivos_Aplicables__c=SubmotivosAplicables1);
    	string SubmotivosAplicables2 = 'Cargo no reconocido en ATM;Cargo no reconocidos;Cobro de más;Cobro de menos;Reembolso al afiliado';
	    Entitlement TicketEnt2 =  New Entitlement(Name='30 a 45 días hábiles', 	AccountId=Entcuenta.Id, Submotivos_Aplicables__c=SubmotivosAplicables2);
	    string SubmotivosAplicables3 = 'Adenda/Factura No Emitida;Bloqueo de cuenta;Cambio De Cliente (subcuenta);Cambio De Comisión;Cambio De Domicilio;Cambio de fecha;Cambio De Metodo De Pago;Cambio De Razón Social;Cancelación Definitiva De Factura;De Servicio Comisión;Conciliación de cuentas del afiliado;Conciliación de Factura;Conciliación de movimientos de tarjeta;Corrección De RFC;Corte especial;Cuota de Adscripción;Error Edenred (cancela re facturación y vuelve a generar);No se puede descargar el documento;No se refleja la dispersión;De Servicios por Plásticos;Retiro saldo empleado no vigente;Retiro saldo empleado vigente;Retiro saldo por omisión de entrega de plástico;Unificación o Separación de Comisión o Plásticos;Unificación o Separación de Transacciones;Vales_ Ex_empleados_-_TDVE';
        Entitlement TicketEnt3 =  New Entitlement(Name='7 días hábiles', AccountId=Entcuenta.Id, Submotivos_Aplicables__c=SubmotivosAplicables3);
        string SubmotivosAplicables4 = 'Actualización de dirección auxiliar;Cambio de datos (Empleado);Cambio de No. de Nómina único;Cancelación de pedido;Cancelación Factura de Fondos;Conciliación de cuentas del cliente;de Pedido de Saldos TVDE;de Pedidos de vales con emisión de bonos;de Pedidos de vales sin emisión de bonos;El estatus del pedido no cambia;Error al solicitar saldo a su cuenta corriente;Error de registro en la app;Error en la carga del layout;Error en la dispersión;Lentitud/ intermitencia en la app;Lentitud/ intermitencia en la web;Liberación de pedido;No puede transaccionar en eCommerce;No puedo retirar efectivo del ATM;No puedo transaccionar;Rastreo de pedido;Reactivación cuenta Empleado;Retraso en la entrega del documento';    
        Entitlement TicketEnt4 =  New Entitlement(Name='24 horas', 	AccountId=Entcuenta.Id  , Submotivos_Aplicables__c =SubmotivosAplicables4);
	   insert TicketEnt1;  insert TicketEnt2;  insert TicketEnt3;  insert TicketEnt4;  
       System.debug('TicketEnt3.Id: **********'+TicketEnt3.Id);
       System.debug('TicketEnt4.Id: **********'+TicketEnt4.Id);
      
       
      Case TicketCaso= New Case(AccountId =Ticketcuenta.Id,  Type='Incidencia', EntitlementId=TicketEnt4.Id, Motivo__c='Conciliación', Sub_Motivo__c='Conciliación de cuentas del cliente', ContactId=Ticketcontacto.Id, Contrato_Filial__c=Ticketcontratofl.Id, ID_de_la_Llamada__c='10');  

       Test.startTest(); 
       insert TicketCaso;
      			 System.debug('Ticket: **********'+TicketCaso); 
     
       
                 										
                 System.debug('TicketCaso.Sub_Motivo__c: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+TicketCaso.Sub_Motivo__c);         
                 
       TicketCaso.Sub_Motivo__c='Conciliación de movimientos de tarjeta';
       
                 System.debug('TicketCaso.Sub_Motivo__c: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+TicketCaso.Sub_Motivo__c);  
                 
     
       update ticketcaso;
      
       Case TicketCasoUpdated =[Select Id, EntitlementId, Sub_Motivo__c From Case where Id=: TicketCaso.Id];
       system.debug('Ticketcuenta.EntitlementId = '+TicketCasoUpdated.EntitlementId);
        System.assertEquals(TicketEnt3.Id, TicketCasoUpdated.EntitlementId);
         
		Test.stopTest(); 
                  
 
        }*/
    
    

}