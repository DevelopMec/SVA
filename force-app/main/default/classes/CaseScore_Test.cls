@isTest
private class CaseScore_Test {

	static Submotivo__c subMotivo, subMotivo_2;
	static Account acc_1, acc_2;
	static Contact ctc;
	static List<EntidadCuenta__c> listEntidadCuenta;

	static void init() {

		acc_1 = new Account();
		acc_1.Name = 'Acc Test';
		insert acc_1;

		acc_2 = new Account();
		acc_2.Name = 'Acc Test';
		acc_2.NumeroEmpleados__c = '1-25';
		acc_2.Canal_de_Atencion__c = 'VIP';
		acc_2.Sector__c = 'Privado';
		acc_2.Open_Cases__c = 1;
		insert acc_2;

		Opportunity opp = new Opportunity();
		opp.AccountId = acc_2.Id;
		opp.Name = 'Test';
		opp.StageName = 'Cotizacion';
		opp.CloseDate = System.today().addDays(1);
		insert opp;

		//Id recordTypeBenefits = [SELECT Id FROM RecordType WHERE Name = 'Benefits' AND SObjectType = 'Case' LIMIT 1].Id;
	}

    @isTest static void test_method_one() {
     
     	init();

        List<Case> listCasos = new List<Case>();

        Case caso_1 = new Case();
		caso_1.AccountId = acc_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		listCasos.add(caso_1);
		
		Case caso_2 = new Case();
		caso_2.AccountId = acc_2.Id;
		caso_2.Type = 'Solicitud';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		caso_2.Motivo__c = 'ValesExempleados-TDVE';
		caso_2.Sub_Motivo__c = 'Vales_ Ex_empleados_-_TDVE';
		caso_2.Temperatura_del_Contacto__c = 'Molesto';
		listCasos.add(caso_2);

		Case caso_3 = new Case();
		caso_3.AccountId = acc_1.Id;
		caso_3.Type = 'Incidencia';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		caso_3.Motivo__c = 'Pedidos de Tarjeta';
		caso_3.Sub_Motivo__c = 'Vales dañados';
		caso_3.Temperatura_del_Contacto__c = 'Tranquilo';
		listCasos.add(caso_3);

		Case caso_4 = new Case();
		caso_4.AccountId = acc_1.Id;
		caso_4.Type = 'Asesoría';		
		caso_4.Status = 'Abierto';
		caso_4.Origin = 'Web';
		caso_4.Motivo__c = '__Plataforma Web';
		caso_4.Sub_Motivo__c = 'Uso de la plataforma';
		//caso_4.Temperatura_del_Contacto__c = 'Tranquilo';
		listCasos.add(caso_4);

		Case caso_5 = new Case();
		caso_5.AccountId = acc_1.Id;
		caso_5.Type = 'Incidencia';		
		caso_5.Status = 'Abierto';
		caso_5.Origin = 'Web';
		caso_5.Motivo__c = 'Re facturación';
		caso_5.Sub_Motivo__c = 'Unificación o Separación de Transacciones';
		listCasos.add(caso_5);

		Case caso_6 = new Case();
		caso_6.AccountId = acc_1.Id;
		caso_6.Type = 'Incidencia';		
		caso_6.Status = 'Abierto';
		caso_6.Origin = 'Web';
		caso_6.Motivo__c = 'Re facturación';
		caso_6.Sub_Motivo__c = 'Unificación o Separación de Comisión o Plásticos';
		listCasos.add(caso_6);

		Case caso_7 = new Case();
		caso_7.AccountId = acc_1.Id;
		caso_7.Type = 'Asesoría';		
		caso_7.Status = 'Abierto';
		caso_7.Origin = 'Web';
		caso_7.Motivo__c = 'Saldo';
		caso_7.Sub_Motivo__c = 'Tarjetas';
		listCasos.add(caso_7);

		Case caso_8 = new Case();
		caso_8.AccountId = acc_1.Id;
		caso_8.Type = 'Asesoría';		
		caso_8.Status = 'Abierto';
		caso_8.Origin = 'Web';
		caso_8.Motivo__c = '__Plataforma Web';
		caso_8.Sub_Motivo__c = 'Subcuentas';
		listCasos.add(caso_8);

		Case caso_9 = new Case();
		caso_9.AccountId = acc_1.Id;
		caso_9.Type = 'Asesoría';		
		caso_9.Status = 'Abierto';
		caso_9.Origin = 'Web';
		caso_9.Motivo__c = '__Tarjeta';
		caso_9.Sub_Motivo__c = 'Stock';
		listCasos.add(caso_9);

		Case caso_10 = new Case();
		caso_10.AccountId = acc_1.Id;
		caso_10.Type = 'Asesoría';		
		caso_10.Status = 'Abierto';
		caso_10.Origin = 'Web';
		caso_10.Motivo__c = '__Tarjeta';
		caso_10.Sub_Motivo__c = 'Solicitud';
		listCasos.add(caso_10);

		Case caso_11 = new Case();
		caso_11.AccountId = acc_1.Id;
		caso_11.Type = 'Incidencia';		
		caso_11.Status = 'Abierto';
		caso_11.Origin = 'Web';
		caso_11.Motivo__c = 'Pedidos de Tarjeta';
		caso_11.Sub_Motivo__c = 'Sobres abiertos/maltratados';
		listCasos.add(caso_11);

		Case caso_12 = new Case();
		caso_12.AccountId = acc_1.Id;
		caso_12.Type = 'Incidencia';		
		caso_12.Status = 'Abierto';
		caso_12.Origin = 'Web';
		caso_12.Motivo__c = 'Facturación';
		caso_12.Sub_Motivo__c = 'Retraso en la entrega del documento';
		listCasos.add(caso_12);

		Case caso_13 = new Case();
		caso_13.AccountId = acc_1.Id;
		caso_13.Type = 'Solicitud';		
		caso_13.Status = 'Abierto';
		caso_13.Origin = 'Web';
		caso_13.Motivo__c = '_Saldos';
		caso_13.Sub_Motivo__c = 'Retiro saldo por omisión de entrega de plástico	';
		listCasos.add(caso_13);

		Case caso_14 = new Case();
		caso_14.AccountId = acc_1.Id;
		caso_14.Type = 'Solicitud';		
		caso_14.Status = 'Abierto';
		caso_14.Origin = 'Web';
		caso_14.Motivo__c = '_Saldos';
		caso_14.Sub_Motivo__c = 'Retiro saldo empleado vigente';
		listCasos.add(caso_14);

		Case caso_15 = new Case();
		caso_15.AccountId = acc_1.Id;
		caso_15.Type = 'Solicitud';		
		caso_15.Status = 'Abierto';
		caso_15.Origin = 'Web';
		caso_15.Motivo__c = '_Saldos';
		caso_15.Sub_Motivo__c = 'Retiro saldo empleado no vigente';
		listCasos.add(caso_15);

		Case caso_16 = new Case();
		caso_16.AccountId = acc_1.Id;
		caso_16.Type = 'Solicitud';		
		caso_16.Status = 'Abierto';
		caso_16.Origin = 'Web';
		caso_16.Motivo__c = '_Tarjeta';
		caso_16.Sub_Motivo__c = 'Reporte de movimientos';
		listCasos.add(caso_16);

		Case caso_17 = new Case();
		caso_17.AccountId = acc_1.Id;
		caso_17.Type = 'Asesoría';		
		caso_17.Status = 'Abierto';
		caso_17.Origin = 'Web';
		caso_17.Motivo__c = '__Tarjeta';
		caso_17.Sub_Motivo__c = 'Renovación';
		listCasos.add(caso_17);

		Case caso_18 = new Case();
		caso_18.AccountId = acc_1.Id;
		caso_18.Type = 'Solicitud';		
		caso_18.Status = 'Abierto';
		caso_18.Origin = 'Web';
		caso_18.Motivo__c = '_Facturación';
		caso_18.Sub_Motivo__c = 'Reenvío';
		listCasos.add(caso_18);

		Case caso_19 = new Case();
		caso_19.AccountId = acc_1.Id;
		caso_19.Type = 'Solicitud';		
		caso_19.Status = 'Abierto';
		caso_19.Origin = 'Web';
		caso_19.Motivo__c = 'Aclaración';
		caso_19.Sub_Motivo__c = 'Reembolso al afiliado';
		listCasos.add(caso_19);

		Case caso_20 = new Case();
		caso_20.AccountId = acc_1.Id;
		caso_20.Type = 'Solicitud';		
		caso_20.Status = 'Abierto';
		caso_20.Origin = 'Web';
		caso_20.Motivo__c = '_Cuentas';
		caso_20.Sub_Motivo__c = 'Reactivación cuenta Empleado';
		listCasos.add(caso_20);

		Test.startTest();

		Database.insert(listCasos, false);
		
		Test.stopTest();
    }

    @isTest static void test_method_two() {
     
     	init();

     	List<Case> listCasos = new List<Case>();

     	Case caso_1 = new Case();
		caso_1.AccountId = acc_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		caso_1.Motivo__c = '_Pedidos de Tarjeta';
		caso_1.Sub_Motivo__c = 'Re programación';
		listCasos.add(caso_1);

		Case caso_2 = new Case();
		caso_2.AccountId = acc_1.Id;
		caso_2.Type = 'Solicitud';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		caso_2.Motivo__c = 'Tramites Administrativos';
		caso_2.Sub_Motivo__c = 'Razón Social';
		listCasos.add(caso_2);

		Case caso_3 = new Case();
		caso_3.AccountId = acc_1.Id;
		caso_3.Type = 'Solicitud';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		caso_3.Motivo__c = '_Pedidos de Tarjeta';
		caso_3.Sub_Motivo__c = 'Rastreo de pedido';
		listCasos.add(caso_3);

		Case caso_4 = new Case();
		caso_4.AccountId = acc_1.Id;
		caso_4.Type = 'Asesoría';		
		caso_4.Status = 'Abierto';
		caso_4.Origin = 'Web';
		caso_4.Motivo__c = '__Facturación';
		caso_4.Sub_Motivo__c = 'Programación reportes';
		listCasos.add(caso_4);

		Case caso_5 = new Case();
		caso_5.AccountId = acc_1.Id;
		caso_5.Type = 'Asesoría';		
		caso_5.Status = 'Abierto';
		caso_5.Origin = 'Web';
		caso_5.Motivo__c = 'Lay Out';
		caso_5.Sub_Motivo__c = 'Productos Papel';
		listCasos.add(caso_5);

		Case caso_6 = new Case();
		caso_6.AccountId = acc_1.Id;
		caso_6.Type = 'Asesoría';		
		caso_6.Status = 'Abierto';
		caso_6.Origin = 'Web';
		caso_6.Motivo__c = 'Lay Out';
		caso_6.Sub_Motivo__c = 'Productos Electrónicos';
		listCasos.add(caso_6);

		Case caso_7 = new Case();
		caso_7.AccountId = acc_1.Id;
		caso_7.Type = 'Asesoría';		
		caso_7.Status = 'Abierto';
		caso_7.Origin = 'Web';
		caso_7.Motivo__c = '__Dispersión';
		caso_7.Sub_Motivo__c = 'Plantillas de carga masiva';
		listCasos.add(caso_7);

		Case caso_8 = new Case();
		caso_8.AccountId = acc_1.Id;
		caso_8.Type = 'Incidencia';		
		caso_8.Status = 'Abierto';
		caso_8.Origin = 'Web';
		caso_8.Motivo__c = 'Pedidos de Tarjeta';
		caso_8.Sub_Motivo__c = 'Pedido incorrecto (ordenamiento)';
		listCasos.add(caso_8);

		Case caso_9 = new Case();
		caso_9.AccountId = acc_1.Id;
		caso_9.Type = 'Incidencia';		
		caso_9.Status = 'Abierto';
		caso_9.Origin = 'Web';
		caso_9.Motivo__c = 'Pedidos de Tarjeta';
		caso_9.Sub_Motivo__c = 'Pedido incompleto';
		listCasos.add(caso_9);

		Case caso_10 = new Case();
		caso_10.AccountId = acc_1.Id;
		caso_10.Type = 'Solicitud';		
		caso_10.Status = 'Abierto';
		caso_10.Origin = 'Web';
		caso_10.Motivo__c = '_Facturación';
		caso_10.Sub_Motivo__c = 'Nota de servicio';
		listCasos.add(caso_10);

		Case caso_11 = new Case();
		caso_11.AccountId = acc_1.Id;
		caso_11.Type = 'Incidencia';		
		caso_11.Status = 'Abierto';
		caso_11.Origin = 'Web';
		caso_11.Motivo__c = 'Dispersión';
		caso_11.Sub_Motivo__c = 'No se refleja la dispersión';
		listCasos.add(caso_11);

		Case caso_12 = new Case();
		caso_12.AccountId = acc_1.Id;
		caso_12.Type = 'Incidencia';		
		caso_12.Status = 'Abierto';
		caso_12.Origin = 'Web';
		caso_12.Motivo__c = 'Facturación';
		caso_12.Sub_Motivo__c = 'No se puede descargar el documento';
		listCasos.add(caso_12);

		Case caso_13 = new Case();
		caso_13.AccountId = acc_1.Id;
		caso_13.Type = 'Incidencia';		
		caso_13.Status = 'Abierto';
		caso_13.Origin = 'Web';
		caso_13.Motivo__c = 'Pedidos de Tarjeta';
		caso_13.Sub_Motivo__c = 'No reconoce la entrega';
		listCasos.add(caso_13);

		Case caso_14 = new Case();
		caso_14.AccountId = acc_1.Id;
		caso_14.Type = 'Incidencia';		
		caso_14.Status = 'Abierto';
		caso_14.Origin = 'Web';
		caso_14.Motivo__c = 'Tarjeta';
		caso_14.Sub_Motivo__c = 'No puedo transaccionar';
		listCasos.add(caso_14);

		Case caso_15 = new Case();
		caso_15.AccountId = acc_1.Id;
		caso_15.Type = 'Incidencia';		
		caso_15.Status = 'Abierto';
		caso_15.Origin = 'Web';
		caso_15.Motivo__c = 'Tarjeta';
		caso_15.Sub_Motivo__c = 'No puedo retirar efectivo del ATM';
		listCasos.add(caso_15);

		Case caso_16 = new Case();
		caso_16.AccountId = acc_1.Id;
		caso_16.Type = 'Incidencia';		
		caso_16.Status = 'Abierto';
		caso_16.Origin = 'Web';
		caso_16.Motivo__c = 'Tarjeta';
		caso_16.Sub_Motivo__c = 'No puede transaccionar en eCommerce';
		listCasos.add(caso_16);

		Case caso_17 = new Case();
		caso_17.AccountId = acc_1.Id;
		caso_17.Type = 'Asesoría';		
		caso_17.Status = 'Abierto';
		caso_17.Origin = 'Web';
		caso_17.Motivo__c = '__Tarjeta';
		caso_17.Sub_Motivo__c = 'Movimientos de Tarjeta';
		listCasos.add(caso_17);

		Case caso_18 = new Case();
		caso_18.AccountId = acc_1.Id;
		caso_18.Type = 'Asesoría';		
		caso_18.Status = 'Abierto';
		caso_18.Origin = 'Web';
		caso_18.Motivo__c = '__Plataforma Web';
		caso_18.Sub_Motivo__c = 'Manejo de Controles';
		listCasos.add(caso_18);

		Case caso_19 = new Case();
		caso_19.AccountId = acc_1.Id;
		caso_19.Type = 'Asesoría';		
		caso_19.Status = 'Abierto';
		caso_19.Origin = 'Web';
		caso_19.Motivo__c = 'Saldo';
		caso_19.Sub_Motivo__c = 'Liberación de pedido de saldo';
		listCasos.add(caso_19);

		Case caso_20 = new Case();
		caso_20.AccountId = acc_1.Id;
		caso_20.Type = 'Incidencia';		
		caso_20.Status = 'Abierto';
		caso_20.Origin = 'Web';
		caso_20.Motivo__c = 'Cobranza';
		caso_20.Sub_Motivo__c = 'Liberación de pedido';
		listCasos.add(caso_20);

     	Test.startTest();

		Database.insert(listCasos, false);
		
		Test.stopTest();
    }

    @isTest static void test_method_three() {
     
     	init();

     	List<Case> listCasos = new List<Case>();

     	Case caso_1 = new Case();
		caso_1.AccountId = acc_1.Id;
		caso_1.Type = 'Incidencia';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		caso_1.Motivo__c = 'Web/App';
		caso_1.Sub_Motivo__c = 'Lentitud/ intermitencia en la web';
		listCasos.add(caso_1);

		Case caso_2 = new Case();
		caso_2.AccountId = acc_1.Id;
		caso_2.Type = 'Incidencia';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		caso_2.Motivo__c = 'Web/App';
		caso_2.Sub_Motivo__c = 'Lentitud/ intermitencia en la app';
		listCasos.add(caso_2);

		Case caso_3 = new Case();
		caso_3.AccountId = acc_1.Id;
		caso_3.Type = 'Asesoría';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		caso_3.Motivo__c = '__Plataforma Web';
		caso_3.Sub_Motivo__c = 'Habilitar reglas';
		listCasos.add(caso_3);

		Case caso_4 = new Case();
		caso_4.AccountId = acc_1.Id;
		caso_4.Type = 'Asesoría';		
		caso_4.Status = 'Abierto';
		caso_4.Origin = 'Web';
		caso_4.Motivo__c = '__Facturación';
		caso_4.Sub_Motivo__c = 'Generar proforma';
		listCasos.add(caso_4);

		Case caso_5 = new Case();
		caso_5.AccountId = acc_1.Id;
		caso_5.Type = 'Asesoría';		
		caso_5.Status = 'Abierto';
		caso_5.Origin = 'Web';
		caso_5.Motivo__c = '__Plataforma Web';
		caso_5.Sub_Motivo__c = 'Generación de Reporte de Gastos';
		listCasos.add(caso_5);

		Case caso_6 = new Case();
		caso_6.AccountId = acc_1.Id;
		caso_6.Type = 'Solicitud';		
		caso_6.Status = 'Abierto';
		caso_6.Origin = 'Web';
		caso_6.Motivo__c = 'Estatus de incidencia';
		caso_6.Sub_Motivo__c = 'Estatus de incidencia';
		listCasos.add(caso_6);

		Case caso_7 = new Case();
		caso_7.AccountId = acc_1.Id;
		caso_7.Type = 'Solicitud';		
		caso_7.Status = 'Abierto';
		caso_7.Origin = 'Web';
		caso_7.Motivo__c = '_Pedidos de Tarjeta';
		caso_7.Sub_Motivo__c = 'Estatus de entrega';
		listCasos.add(caso_7);

		Case caso_8 = new Case();
		caso_8.AccountId = acc_1.Id;
		caso_8.Type = 'Incidencia';		
		caso_8.Status = 'Abierto';
		caso_8.Origin = 'Web';
		caso_8.Motivo__c = 'Dispersión';
		caso_8.Sub_Motivo__c = 'Error en la dispersión';
		listCasos.add(caso_8);

		Case caso_9 = new Case();
		caso_9.AccountId = acc_1.Id;
		caso_9.Type = 'Incidencia';		
		caso_9.Status = 'Abierto';
		caso_9.Origin = 'Web';
		caso_9.Motivo__c = 'Layout';
		caso_9.Sub_Motivo__c = 'Error en la carga del layout';
		listCasos.add(caso_9);

		Case caso_10 = new Case();
		caso_10.AccountId = acc_1.Id;
		caso_10.Type = 'Incidencia';		
		caso_10.Status = 'Abierto';
		caso_10.Origin = 'Web';
		caso_10.Motivo__c = 'Re facturación';
		caso_10.Sub_Motivo__c = 'Error Edenred (cancela re facturación y vuelve a generar)';
		listCasos.add(caso_10);

		Case caso_11 = new Case();
		caso_11.AccountId = acc_1.Id;
		caso_11.Type = 'Incidencia';		
		caso_11.Status = 'Abierto';
		caso_11.Origin = 'Web';
		caso_11.Motivo__c = 'Web/App';
		caso_11.Sub_Motivo__c = 'Error de registro en la app';
		listCasos.add(caso_11);

		Case caso_12 = new Case();
		caso_12.AccountId = acc_1.Id;
		caso_12.Type = 'Incidencia';		
		caso_12.Status = 'Abierto';
		caso_12.Origin = 'Web';
		caso_12.Motivo__c = 'Saldos';
		caso_12.Sub_Motivo__c = 'Error al solicitar saldo a su cuenta corriente';
		listCasos.add(caso_12);

		Case caso_13 = new Case();
		caso_13.AccountId = acc_1.Id;
		caso_13.Type = 'Asesoría';		
		caso_13.Status = 'Abierto';
		caso_13.Origin = 'Web';
		caso_13.Motivo__c = '__Facturación';
		caso_13.Sub_Motivo__c = 'Envío de reportes';
		listCasos.add(caso_13);

		Case caso_14 = new Case();
		caso_14.AccountId = acc_1.Id;
		caso_14.Type = 'Solicitud';		
		caso_14.Status = 'Abierto';
		caso_14.Origin = 'Web';
		caso_14.Motivo__c = '_Facturación';
		caso_14.Sub_Motivo__c = 'Envío de proformas';
		listCasos.add(caso_14);

		Case caso_15 = new Case();
		caso_15.AccountId = acc_1.Id;
		caso_15.Type = 'Solicitud';		
		caso_15.Status = 'Abierto';
		caso_15.Origin = 'Web';
		caso_15.Motivo__c = '_Facturación';
		caso_15.Sub_Motivo__c = 'Envío de factura';
		listCasos.add(caso_15);

		Case caso_16 = new Case();
		caso_16.AccountId = acc_1.Id;
		caso_16.Type = 'Incidencia';		
		caso_16.Status = 'Abierto';
		caso_16.Origin = 'Web';
		caso_16.Motivo__c = 'Pedidos de Tarjeta';
		caso_16.Sub_Motivo__c = 'El estatus del pedido no cambia';
		listCasos.add(caso_16);

		Case caso_17 = new Case();
		caso_17.AccountId = acc_1.Id;
		caso_17.Type = 'Solicitud';		
		caso_17.Status = 'Abierto';
		caso_17.Origin = 'Web';
		caso_17.Motivo__c = 'Tramites Administrativos';
		caso_17.Sub_Motivo__c = 'Domicilio Fiscal';
		listCasos.add(caso_17);

		Case caso_18 = new Case();
		caso_18.AccountId = acc_1.Id;
		caso_18.Type = 'Solicitud';		
		caso_18.Status = 'Abierto';
		caso_18.Origin = 'Web';
		caso_18.Motivo__c = 'Tramites Administrativos';
		caso_18.Sub_Motivo__c = 'Dirección Auxiliar';
		listCasos.add(caso_18);

		Case caso_19 = new Case();
		caso_19.AccountId = acc_1.Id;
		caso_19.Type = 'Asesoría';		
		caso_19.Status = 'Abierto';
		caso_19.Origin = 'Web';
		caso_19.Motivo__c = '__Facturación';
		caso_19.Sub_Motivo__c = 'Descarga facturas';
		listCasos.add(caso_19);

		Case caso_20 = new Case();
		caso_20.AccountId = acc_1.Id;
		caso_20.Type = 'Asesoría';		
		caso_20.Status = 'Abierto';
		caso_20.Origin = 'Web';
		caso_20.Motivo__c = '__Facturación';
		caso_20.Sub_Motivo__c = 'Descarga de proformas';
		listCasos.add(caso_20);

     	Test.startTest();

		Database.insert(listCasos, false);
		
		Test.stopTest();
    }

    @isTest static void test_method_four() {
     
     	init();

     	List<Case> listCasos = new List<Case>();

     	Case caso_1 = new Case();
		caso_1.AccountId = acc_1.Id;
		caso_1.Type = 'Asesoría';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		caso_1.Motivo__c = '__Facturación';
		caso_1.Sub_Motivo__c = 'Descarga';
		listCasos.add(caso_1);

		Case caso_2 = new Case();
		caso_2.AccountId = acc_1.Id;
		caso_2.Type = 'Solicitud';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		caso_2.Motivo__c = '_Cobranza';
		caso_2.Sub_Motivo__c = 'Desbloqueo de Cuenta';
		listCasos.add(caso_2);

		Case caso_3 = new Case();
		caso_3.AccountId = acc_1.Id;
		caso_3.Type = 'Solicitud';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		caso_3.Motivo__c = 'Cancelación';
		caso_3.Sub_Motivo__c = 'de Pedidos de vales sin emisión de bonos';
		listCasos.add(caso_3);

		Case caso_4 = new Case();
		caso_4.AccountId = acc_1.Id;
		caso_4.Type = 'Solicitud';		
		caso_4.Status = 'Abierto';
		caso_4.Origin = 'Web';
		caso_4.Motivo__c = 'Cancelación';
		caso_4.Sub_Motivo__c = 'de Pedidos de vales con emisión de bonos';
		listCasos.add(caso_4);

		Case caso_5 = new Case();
		caso_5.AccountId = acc_1.Id;
		caso_5.Type = 'Solicitud';		
		caso_5.Status = 'Abierto';
		caso_5.Origin = 'Web';
		caso_5.Motivo__c = 'Cancelación';
		caso_5.Sub_Motivo__c = 'de Pedido de Saldos TVDE';
		listCasos.add(caso_5);

		Case caso_6 = new Case();
		caso_6.AccountId = acc_1.Id;
		caso_6.Type = 'Solicitud';		
		caso_6.Status = 'Abierto';
		caso_6.Origin = 'Web';
		caso_6.Motivo__c = 'Ligue de Empleadoras';
		caso_6.Sub_Motivo__c = 'del mismo grupo';
		listCasos.add(caso_6);

		Case caso_7 = new Case();
		caso_7.AccountId = acc_1.Id;
		caso_7.Type = 'Solicitud';		
		caso_7.Status = 'Abierto';
		caso_7.Origin = 'Web';
		caso_7.Motivo__c = 'Ligue de Empleadoras';
		caso_7.Sub_Motivo__c = 'de diferente grupo';
		listCasos.add(caso_7);

		Case caso_8 = new Case();
		caso_8.AccountId = acc_1.Id;
		caso_8.Type = 'Incidencia';		
		caso_8.Status = 'Abierto';
		caso_8.Origin = 'Web';
		caso_8.Motivo__c = 'Re facturación';
		caso_8.Sub_Motivo__c = 'Cuota de Adscripción';
		listCasos.add(caso_8);

		Case caso_9 = new Case();
		caso_9.AccountId = acc_1.Id;
		caso_9.Type = 'Solicitud';		
		caso_9.Status = 'Abierto';
		caso_9.Origin = 'Web';
		caso_9.Motivo__c = 'Plataforma Web';
		caso_9.Sub_Motivo__c = 'Cuenta mancomunada';
		listCasos.add(caso_9);

		Case caso_10 = new Case();
		caso_10.AccountId = acc_1.Id;
		caso_10.Type = 'Asesoría';		
		caso_10.Status = 'Abierto';
		caso_10.Origin = 'Web';
		caso_10.Motivo__c = 'Saldo';
		caso_10.Sub_Motivo__c = 'Cuenta Corriente';
		listCasos.add(caso_10);

		Case caso_11 = new Case();
		caso_11.AccountId = acc_1.Id;
		caso_11.Type = 'Asesoría';		
		caso_11.Status = 'Abierto';
		caso_11.Origin = 'Web';
		caso_11.Motivo__c = 'Saldo';
		caso_11.Sub_Motivo__c = 'Cuenta';
		listCasos.add(caso_11);

		Case caso_12 = new Case();
		caso_12.AccountId = acc_1.Id;
		caso_12.Type = 'Asesoría';		
		caso_12.Status = 'Abierto';
		caso_12.Origin = 'Web';
		caso_12.Motivo__c = '__Plataforma Web';
		caso_12.Sub_Motivo__c = 'Crear administrador nuevo';
		listCasos.add(caso_12);

		Case caso_13 = new Case();
		caso_13.AccountId = acc_1.Id;
		caso_13.Type = 'Asesoría';		
		caso_13.Status = 'Abierto';
		caso_13.Origin = 'Web';
		caso_13.Motivo__c = '__Plataforma Web';
		caso_13.Sub_Motivo__c = 'Creación estructura';
		listCasos.add(caso_13);

		Case caso_14 = new Case();
		caso_14.AccountId = acc_1.Id;
		caso_14.Type = 'Asesoría';		
		caso_14.Status = 'Abierto';
		caso_14.Origin = 'Web';
		caso_14.Motivo__c = '__Cuentas';
		caso_14.Sub_Motivo__c = 'Creación de cuentas';
		listCasos.add(caso_14);

		Case caso_15 = new Case();
		caso_15.AccountId = acc_1.Id;
		caso_15.Type = 'Incidencia';		
		caso_15.Status = 'Abierto';
		caso_15.Origin = 'Web';
		caso_15.Motivo__c = 'Re facturación';
		caso_15.Sub_Motivo__c = 'Corte especial';
		listCasos.add(caso_15);

		Case caso_16 = new Case();
		caso_16.AccountId = acc_1.Id;
		caso_16.Type = 'Incidencia';		
		caso_16.Status = 'Abierto';
		caso_16.Origin = 'Web';
		caso_16.Motivo__c = 'Re facturación';
		caso_16.Sub_Motivo__c = 'Corrección De RFC';
		listCasos.add(caso_16);

		Case caso_17 = new Case();
		caso_17.AccountId = acc_1.Id;
		caso_17.Type = 'Solicitud';		
		caso_17.Status = 'Abierto';
		caso_17.Origin = 'Web';
		caso_17.Motivo__c = '_Layout';
		caso_17.Sub_Motivo__c = 'Confirmación de Archivos enviados el Servidor';
		listCasos.add(caso_17);

		Case caso_18 = new Case();
		caso_18.AccountId = acc_1.Id;
		caso_18.Type = 'Incidencia';		
		caso_18.Status = 'Abierto';
		caso_18.Origin = 'Web';
		caso_18.Motivo__c = 'Conciliación';
		caso_18.Sub_Motivo__c = 'Conciliación de movimientos de tarjeta';
		listCasos.add(caso_18);

		Case caso_19 = new Case();
		caso_19.AccountId = acc_1.Id;
		caso_19.Type = 'Solicitud';		
		caso_19.Status = 'Abierto';
		caso_19.Origin = 'Web';
		caso_19.Motivo__c = '_Facturación';
		caso_19.Sub_Motivo__c = 'Conciliación de Factura';
		listCasos.add(caso_19);

		Case caso_20 = new Case();
		caso_20.AccountId = acc_1.Id;
		caso_20.Type = 'Incidencia';		
		caso_20.Status = 'Abierto';
		caso_20.Origin = 'Web';
		caso_20.Motivo__c = 'Conciliación';
		caso_20.Sub_Motivo__c = 'Conciliación de cuentas del cliente';
		listCasos.add(caso_20);

     	Test.startTest();

		Database.insert(listCasos, false);
		
		Test.stopTest();
    }

    @isTest static void test_method_five() {
     
     	init();

     	List<Case> listCasos = new List<Case>();

     	Case caso_1 = new Case();
		caso_1.AccountId = acc_1.Id;
		caso_1.Type = 'Incidencia';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		caso_1.Motivo__c = 'Conciliación';
		caso_1.Sub_Motivo__c = 'Conciliación de cuentas del afiliado';
		listCasos.add(caso_1);

		Case caso_2 = new Case();
		caso_2.AccountId = acc_1.Id;
		caso_2.Type = 'Asesoría';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		caso_2.Motivo__c = '__Cuentas';
		caso_2.Sub_Motivo__c = 'Conciliación de cuenta';
		listCasos.add(caso_2);

		Case caso_3 = new Case();
		caso_3.AccountId = acc_1.Id;
		caso_3.Type = 'Asesoría';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		caso_3.Motivo__c = '__Facturación';
		caso_3.Sub_Motivo__c = 'Cómo se paga';
		listCasos.add(caso_3);

		Case caso_4 = new Case();
		caso_4.AccountId = acc_1.Id;
		caso_4.Type = 'Solicitud';		
		caso_4.Status = 'Abierto';
		caso_4.Origin = 'Web';
		caso_4.Motivo__c = 'Aclaración';
		caso_4.Sub_Motivo__c = 'Cobro de menos';
		listCasos.add(caso_4);

		Case caso_5 = new Case();
		caso_5.AccountId = acc_1.Id;
		caso_5.Type = 'Solicitud';		
		caso_5.Status = 'Abierto';
		caso_5.Origin = 'Web';
		caso_5.Motivo__c = 'Aclaración';
		caso_5.Sub_Motivo__c = 'Cobro de más';
		listCasos.add(caso_5);

		Case caso_6 = new Case();
		caso_6.AccountId = acc_1.Id;
		caso_6.Type = 'Solicitud';		
		caso_6.Status = 'Abierto';
		caso_6.Origin = 'Web';
		caso_6.Motivo__c = 'Aclaración';
		caso_6.Sub_Motivo__c = 'Cargo no reconocidos';
		listCasos.add(caso_6);

		Case caso_7 = new Case();
		caso_7.AccountId = acc_1.Id;
		caso_7.Type = 'Solicitud';		
		caso_7.Status = 'Abierto';
		caso_7.Origin = 'Web';
		caso_7.Motivo__c = 'Aclaración';
		caso_7.Sub_Motivo__c = 'Cargo no reconocido en ATM';
		listCasos.add(caso_7);

		Case caso_8 = new Case();
		caso_8.AccountId = acc_1.Id;
		caso_8.Type = 'Asesoría';		
		caso_8.Status = 'Abierto';
		caso_8.Origin = 'Web';
		caso_8.Motivo__c = 'Saldo';
		caso_8.Sub_Motivo__c = 'Carga masiva';
		listCasos.add(caso_8);

		Case caso_9 = new Case();
		caso_9.AccountId = acc_1.Id;
		caso_9.Type = 'Solicitud';		
		caso_9.Status = 'Abierto';
		caso_9.Origin = 'Web';
		caso_9.Motivo__c = '_Facturación';
		caso_9.Sub_Motivo__c = 'Cancelación Factura de Fondos';
		listCasos.add(caso_9);

		Case caso_10 = new Case();
		caso_10.AccountId = acc_1.Id;
		caso_10.Type = 'Solicitud';		
		caso_10.Status = 'Abierto';
		caso_10.Origin = 'Web';
		caso_10.Motivo__c = '_Pedidos de Tarjeta';
		caso_10.Sub_Motivo__c = 'Cancelación de pedido';
		listCasos.add(caso_10);

		Case caso_11 = new Case();
		caso_11.AccountId = acc_1.Id;
		caso_11.Type = 'Incidencia';		
		caso_11.Status = 'Abierto';
		caso_11.Origin = 'Web';
		caso_11.Motivo__c = 'Re facturación';
		caso_11.Sub_Motivo__c = 'Cancelación Definitiva De Factura';
		listCasos.add(caso_11);

		Case caso_12 = new Case();
		caso_12.AccountId = acc_1.Id;
		caso_12.Type = 'Incidencia';		
		caso_12.Status = 'Abierto';
		caso_12.Origin = 'Web';
		caso_12.Motivo__c = 'Re facturación';
		caso_12.Sub_Motivo__c = 'Cambio De Razón Social';
		listCasos.add(caso_12);

		Case caso_13 = new Case();
		caso_13.AccountId = acc_1.Id;
		caso_13.Type = 'Solicitud';		
		caso_13.Status = 'Abierto';
		caso_13.Origin = 'Web';
		caso_13.Motivo__c = '_Pedidos de Tarjeta';
		caso_13.Sub_Motivo__c = 'Cambio de persona';
		listCasos.add(caso_13);

		Case caso_14 = new Case();
		caso_14.AccountId = acc_1.Id;
		caso_14.Type = 'Solicitud';		
		caso_14.Status = 'Abierto';
		caso_14.Origin = 'Web';
		caso_14.Motivo__c = 'Liberación';
		caso_14.Sub_Motivo__c = 'Cambio de No. de Nómina único';
		listCasos.add(caso_14);

		Case caso_15 = new Case();
		caso_15.AccountId = acc_1.Id;
		caso_15.Type = 'Solicitud';		
		caso_15.Status = 'Abierto';
		caso_15.Origin = 'Web';
		caso_15.Motivo__c = 'Liberación';
		caso_15.Sub_Motivo__c = 'Cambio de No. de Nómina masivo';
		listCasos.add(caso_15);

		Case caso_16 = new Case();
		caso_16.AccountId = acc_1.Id;
		caso_16.Type = 'Incidencia';		
		caso_16.Status = 'Abierto';
		caso_16.Origin = 'Web';
		caso_16.Motivo__c = 'Re facturación';
		caso_16.Sub_Motivo__c = 'Cambio De Metodo De Pago';
		listCasos.add(caso_16);

		Case caso_17 = new Case();
		caso_17.AccountId = acc_1.Id;
		caso_17.Type = 'Solicitud';		
		caso_17.Status = 'Abierto';
		caso_17.Origin = 'Web';
		caso_17.Motivo__c = '_Pedidos de Tarjeta';
		caso_17.Sub_Motivo__c = 'Cambio de fecha de entrega';
		listCasos.add(caso_17);

		Case caso_18 = new Case();
		caso_18.AccountId = acc_1.Id;
		caso_18.Type = 'Incidencia';		
		caso_18.Status = 'Abierto';
		caso_18.Origin = 'Web';
		caso_18.Motivo__c = 'Re facturación';
		caso_18.Sub_Motivo__c = 'Cambio de fecha';
		listCasos.add(caso_18);

		Case caso_19 = new Case();
		caso_19.AccountId = acc_1.Id;
		caso_19.Type = 'Incidencia';		
		caso_19.Status = 'Abierto';
		caso_19.Origin = 'Web';
		caso_19.Motivo__c = 'Re facturación';
		caso_19.Sub_Motivo__c = 'Cambio De Domicilio';
		listCasos.add(caso_19);

		Case caso_20 = new Case();
		caso_20.AccountId = acc_1.Id;
		caso_20.Type = 'Solicitud';		
		caso_20.Status = 'Abierto';
		caso_20.Origin = 'Web';
		caso_20.Motivo__c = '_Pedidos de Tarjeta';
		caso_20.Sub_Motivo__c = 'Cambio de dirección de entrega';
		listCasos.add(caso_20);

     	Test.startTest();

		Database.insert(listCasos, false);
		
		Test.stopTest();
    }

    @isTest static void test_method_six() {
     
     	init();

     	List<Case> listCasos = new List<Case>();

     	Case caso_1 = new Case();
		caso_1.AccountId = acc_1.Id;
		caso_1.Type = 'Solicitud';		
		caso_1.Status = 'Abierto';
		caso_1.Origin = 'Web';
		caso_1.Motivo__c = 'Cambio de datos (Empleado)';
		caso_1.Sub_Motivo__c = 'Cambio de datos (Empleado)';
		listCasos.add(caso_1);

		Case caso_2 = new Case();
		caso_2.AccountId = acc_1.Id;
		caso_2.Type = 'Incidencia';		
		caso_2.Status = 'Abierto';
		caso_2.Origin = 'Web';
		caso_2.Motivo__c = 'Re facturación';
		caso_2.Sub_Motivo__c = 'Cambio De Comisión';
		listCasos.add(caso_2);

		Case caso_3 = new Case();
		caso_3.AccountId = acc_1.Id;
		caso_3.Type = 'Incidencia';		
		caso_3.Status = 'Abierto';
		caso_3.Origin = 'Web';
		caso_3.Motivo__c = 'Re facturación';
		caso_3.Sub_Motivo__c = 'Cambio De Cliente (subcuenta)';
		listCasos.add(caso_3);

		Case caso_4 = new Case();
		caso_4.AccountId = acc_1.Id;
		caso_4.Type = 'Incidencia';		
		caso_4.Status = 'Abierto';
		caso_4.Origin = 'Web';
		caso_4.Motivo__c = 'Cuentas';
		caso_4.Sub_Motivo__c = 'Bloqueo de cuenta';
		listCasos.add(caso_4);

		Case caso_5 = new Case();
		caso_5.AccountId = acc_1.Id;
		caso_5.Type = 'Solicitud';		
		caso_5.Status = 'Abierto';
		caso_5.Origin = 'Web';
		caso_5.Motivo__c = 'Plataforma Web';
		caso_5.Sub_Motivo__c = 'Baja de pedido de fondos';
		listCasos.add(caso_5);

		Case caso_6 = new Case();
		caso_6.AccountId = acc_1.Id;
		caso_6.Type = 'Incidencia';		
		caso_6.Status = 'Abierto';
		caso_6.Origin = 'Web';
		caso_6.Motivo__c = 'Autorización Telefónica';
		caso_6.Sub_Motivo__c = 'AT por terminal dañada';
		listCasos.add(caso_6);

		Case caso_7 = new Case();
		caso_7.AccountId = acc_1.Id;
		caso_7.Type = 'Incidencia';		
		caso_7.Status = 'Abierto';
		caso_7.Origin = 'Web';
		caso_7.Motivo__c = 'Autorización Telefónica';
		caso_7.Sub_Motivo__c = 'AT por tarjeta con problemas';
		listCasos.add(caso_7);

		Case caso_8 = new Case();
		caso_8.AccountId = acc_1.Id;
		caso_8.Type = 'Asesoría';		
		caso_8.Status = 'Abierto';
		caso_8.Origin = 'Web';
		caso_8.Motivo__c = 'Saldo';
		caso_8.Sub_Motivo__c = 'Asignación IVR';
		listCasos.add(caso_8);

		Case caso_9 = new Case();
		caso_9.AccountId = acc_1.Id;
		caso_9.Type = 'Asesoría';		
		caso_9.Status = 'Abierto';
		caso_9.Origin = 'Web';
		caso_9.Motivo__c = 'Saldo';
		caso_9.Sub_Motivo__c = 'Asignación de saldo';
		listCasos.add(caso_9);

		Case caso_10 = new Case();
		caso_10.AccountId = acc_1.Id;
		caso_10.Type = 'Asesoría';		
		caso_10.Status = 'Abierto';
		caso_10.Origin = 'Web';
		caso_10.Motivo__c = '__Tarjeta';
		caso_10.Sub_Motivo__c = 'Asignación';
		listCasos.add(caso_10);

		Case caso_11 = new Case();
		caso_11.AccountId = acc_1.Id;
		caso_11.Type = 'Asesoría';		
		caso_11.Status = 'Abierto';
		caso_11.Origin = 'Web';
		caso_11.Motivo__c = 'Producto Papel';
		caso_11.Sub_Motivo__c = 'Asesoría';
		listCasos.add(caso_11);

		Case caso_12 = new Case();
		caso_12.AccountId = acc_1.Id;
		caso_12.Type = 'Solicitud';		
		caso_12.Status = 'Abierto';
		caso_12.Origin = 'Web';
		caso_12.Motivo__c = 'Tramites Administrativos';
		caso_12.Sub_Motivo__c = 'Apoderado Legal';
		listCasos.add(caso_12);

		Case caso_13 = new Case();
		caso_13.AccountId = acc_1.Id;
		caso_13.Type = 'Incidencia';		
		caso_13.Status = 'Abierto';
		caso_13.Origin = 'Web';
		caso_13.Motivo__c = 'Cobranza';
		caso_13.Sub_Motivo__c = 'Aplicación de pago';
		listCasos.add(caso_13);

		Case caso_14 = new Case();
		caso_14.AccountId = acc_1.Id;
		caso_14.Type = 'Asesoría';		
		caso_14.Status = 'Abierto';
		caso_14.Origin = 'Web';
		caso_14.Motivo__c = '__Plataforma Web';
		caso_14.Sub_Motivo__c = 'Alta de un jefe';
		listCasos.add(caso_14);

		Case caso_15 = new Case();
		caso_15.AccountId = acc_1.Id;
		caso_15.Type = 'Asesoría';		
		caso_15.Status = 'Abierto';
		caso_15.Origin = 'Web';
		caso_15.Motivo__c = '__Plataforma Web';
		caso_15.Sub_Motivo__c = 'Alta de conductores';
		listCasos.add(caso_15);

		Case caso_16 = new Case();
		caso_16.AccountId = acc_1.Id;
		caso_16.Type = 'Solicitud';		
		caso_16.Status = 'Abierto';
		caso_16.Origin = 'Web';
		caso_16.Motivo__c = 'Tramites Administrativos';
		caso_16.Sub_Motivo__c = 'Administrador';
		listCasos.add(caso_16);

		Case caso_17 = new Case();
		caso_17.AccountId = acc_1.Id;
		caso_17.Type = 'Incidencia';		
		caso_17.Status = 'Abierto';
		caso_17.Origin = 'Web';
		caso_17.Motivo__c = 'Re facturación';
		caso_17.Sub_Motivo__c = 'Adenda/Factura No Emitida';
		listCasos.add(caso_17);

		Case caso_18 = new Case();
		caso_18.AccountId = acc_1.Id;
		caso_18.Type = 'Incidencia';		
		caso_18.Status = 'Abierto';
		caso_18.Origin = 'Web';
		caso_18.Motivo__c = 'Pedidos de Tarjeta';
		caso_18.Sub_Motivo__c = 'Actualización de dirección auxiliar';
		listCasos.add(caso_18);

		Case caso_19 = new Case();
		caso_19.AccountId = acc_1.Id;
		caso_19.Type = 'Asesoría';		
		caso_19.Status = 'Abierto';
		caso_19.Origin = 'Web';
		caso_19.Motivo__c = '__Tarjeta';
		caso_19.Sub_Motivo__c = 'Activación';
		listCasos.add(caso_19);

		Case caso_20 = new Case();
		caso_20.AccountId = acc_1.Id;
		caso_20.Type = 'Asesoría';		
		caso_20.Status = 'Abierto';
		caso_20.Origin = 'Web';
		caso_20.Motivo__c = '__Dispersión';
		caso_20.Sub_Motivo__c = 'Abono a cuenta corriente';
		listCasos.add(caso_20);

     	Test.startTest();

		Database.insert(listCasos, false);
		
		Test.stopTest();
    }
}