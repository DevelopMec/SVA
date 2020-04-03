trigger CaseScore on Case (before insert, before update) {
    //--English--
    //This Code constitutes an Extra-functionality delivered in order to calculate a Ticket Score taking into account Eight (8) criteria.
    //Ticket Scoring was delivered as an Extra-functionality within the Service Cloud Implementation Project. Extra-Functionalities are not covered by the Project Scope 
    //and Guarantee.
    //One Ticket Scoring Criteria called "Open Tickets Count" is convered by the Trigger OpenCasesRollUpinAccount, it was also delivered as Extra-functionality. 
    //CaseScore Trigger works in conjunction with AccountCaseScore Trigger.
    //--Spanish--
    //Este código constituye una Funcionalidad Extra brindada para calcular la Puntuación de un Ticket teniendo en cuenta 8 criterios.
    //La Puntuación de Tickets fue brindada como una Funcionalidad Extra en el Proyecto de Implementación Service Cloud. Las Funcionalidades Extras no están cubiertas por el Alcance
    //del Proyecto ni Garantía.
    //Uno de los Criterios de Puntuación de Tickets llamadao "Conteo de Tickets Abiertos" es cubierto por el Trigger OpenCasesRollUpinAccount, este también fue entregado como
    //Funcionalidad Extra.
    //Desencadenador CaseScore trabaja en conjunto con el Desencadenador AccountCaseScore.
    /*Integer scoreSegmentoComercial, scoreCanaldeAtencion, scoreSector, scoreOportunidadesAbiertas, scoreAmenazasdeAtricion, scoreSubmotivo, scoreTemperaturadelContacto, scoreHayTicketsAbiertos;
    Integer pesoCriterioSegmentoComercial, pesoCriterioCanaldeAtencion, pesoCriterioSector, pesoCriterioOportunidadesAbiertas, pesoCriterioAmenazasdeAtricion, pesoCriterioSubmotivo, pesoCriterioTemperaturadelContacto, pesoCriterioHayTicketsAbiertos;
    pesoCriterioSegmentoComercial=10;
    pesoCriterioCanaldeAtencion=20;
    pesoCriterioSector=10;
    pesoCriterioOportunidadesAbiertas=5;
    pesoCriterioAmenazasdeAtricion=5;
    pesoCriterioSubmotivo=25;
    pesoCriterioTemperaturadelContacto=15;
    pesoCriterioHayTicketsAbiertos=10;
    for (Case c : Trigger.new) {
        switch on c.Segmento_Comercial__c {
            when 'Key' {
                scoreSegmentoComercial=5;
            }
            when 'Large' {
                scoreSegmentoComercial=4;
            }
            when 'Medium-M2' {
                scoreSegmentoComercial=3;
            }
            when 'Medium-M1' {
                scoreSegmentoComercial=2;
            }
            when 'Small-S3' {
                scoreSegmentoComercial=2;
            }
            when 'Small-S2' {
                scoreSegmentoComercial=1;
            }
            when 'Small-S1' {
                scoreSegmentoComercial=0;
            }                
            when else {
                scoreSegmentoComercial=0;
            }
        }
        switch on c.Canal_de_Atencion__c {
            when 'Regular' {
                scoreCanaldeAtencion=1;
            }
            when 'Elite' {
                scoreCanaldeAtencion=5;
            }
            when 'VIP' {
                scoreCanaldeAtencion=3;
            }                
            when else {
                scoreCanaldeAtencion=0;
            }
        }
        switch on c.Sector__c {
            when 'Público' {
                scoreSector=5;
            }
            when 'Privado' {
                scoreSector=3;
            }               
            when else {
                scoreSector=0;
            }
        }
        switch on c.Sector__c {
            when 'Público' {
                scoreSector=5;
            }
            when 'Privado' {
                scoreSector=3;
            }               
            when else {
                scoreSector=0;
            }
        }
        if (c.Oportunidades_Abiertas__c) {
            scoreOportunidadesAbiertas=5;
        } else {
            scoreOportunidadesAbiertas=0;
        }
        if (c.Amenazas_de_Atricion__c) {
            scoreAmenazasdeAtricion=5;
        } else {
            scoreAmenazasdeAtricion=0;
        }
        switch on c.Sub_Motivo__c {
            when 'Abono a cuenta corriente' {
                scoreSubmotivo=0;
            }
            when 'Activación' {
                scoreSubmotivo=0;
            }
            when 'Actualización de dirección auxiliar' {
                scoreSubmotivo=5;
            }
            when 'Adenda/Factura No Emitida' {
                scoreSubmotivo=3;
            }
            when 'Administrador' {
                scoreSubmotivo=0;
            }
            when 'Alta de conductores' {
                scoreSubmotivo=0;
            }
            when 'Alta de un jefe' {
                scoreSubmotivo=0;
            }
            when 'Aplicación de pago' {
                scoreSubmotivo=5;
            }
            when 'Apoderado Legal' {
                scoreSubmotivo=0;
            }
            when 'Asesoría' {
                scoreSubmotivo=0;
            }
            when 'Asignación' {
                scoreSubmotivo=0;
            }
            when 'Asignación de saldo' {
                scoreSubmotivo=0;
            }
            when 'Asignación IVR' {
                scoreSubmotivo=0;
            }
            when 'AT por tarjeta con problemas' {
                scoreSubmotivo=5;
            }
            when 'AT por terminal dañada' {
                scoreSubmotivo=5;
            }
            when 'Baja de pedido de fondos' {
                scoreSubmotivo=5;
            }
            when 'Bloqueo de cuenta' {
                scoreSubmotivo=5;
            }
            when 'Cambio De Cliente (subcuenta)' {
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=0;
                }                   
            }
            when 'Cambio De Comisión' {
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=0;
                }
            }
            when 'Cambio de datos (Empleado)' {
                scoreSubmotivo=3;
            }
            when 'Cambio de dirección de entrega' {
                scoreSubmotivo=0;
            }
            when 'Cambio De Domicilio' {
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=0;
                }
            }
            when 'Cambio de fecha' {
                scoreSubmotivo=0;
            }
            when 'Cambio de fecha de entrega' {
                scoreSubmotivo=0;
            }
            when 'Cambio De Metodo De Pago' {
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=0;
                }
            }
            when 'Cambio de No. de Nómina masivo' {
                scoreSubmotivo=3;
            }
            when 'Cambio de No. de Nómina único' {
                scoreSubmotivo=3;
            }
            when 'Cambio de persona' {
                scoreSubmotivo=0;
            }
            when 'Cambio De Razón Social' {
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=0;
                }
            }
            when 'Cancelación Definitiva De Factura' {
                scoreSubmotivo=3;
            }
            when 'Cancelación de pedido' {
                scoreSubmotivo=5;
            }
            when 'Cancelación Factura de Fondos' {
                scoreSubmotivo=5;
            }
            when 'Carga masiva' {
                scoreSubmotivo=0;
            }
            when 'Cargo no reconocido en ATM' {
                scoreSubmotivo=0;
            }
            when 'Cargo no reconocidos' {
                scoreSubmotivo=0;
            }
            when 'Cobro de más' {
                scoreSubmotivo=0;
            }
            when 'Cobro de menos' {
                scoreSubmotivo=0;
            }
            when 'Comisión' {
                scoreSubmotivo=3;
            }
            when 'Cómo se paga' {
                scoreSubmotivo=0;
            }
            when 'Conciliación de cuenta' {
                scoreSubmotivo=0;
            }
            when 'Conciliación de cuentas del afiliado' {
                scoreSubmotivo=3;
            }
            when 'Conciliación de cuentas del cliente' {
                scoreSubmotivo=3;
            }
            when 'Conciliación de Factura' {
                scoreSubmotivo=3;
            }
            when 'Conciliación de movimientos de tarjeta' {
                scoreSubmotivo=3;
            }
            when 'Confirmación de Archivos enviados el Servidor' {
                scoreSubmotivo=0;
            }
            when 'Corrección De RFC' {
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=0;
                }
            }
            when 'Corte especial' {
                scoreSubmotivo=3;
            }
            when 'Creación de cuentas' {
                scoreSubmotivo=0;
            }
            when 'Creación estructura' {
                scoreSubmotivo=0;
            }
            when 'Crear administrador nuevo' {
                scoreSubmotivo=0;
            }
            when 'Cuenta' {
                scoreSubmotivo=0;
            }
            when 'Cuenta Corriente' {
                scoreSubmotivo=0;
            }
            when 'Cuenta mancomunada' {
                scoreSubmotivo=3;
            }
            when 'Cuota de Adscripción' {
                scoreSubmotivo=3;
            }
            when 'de diferente grupo' {
                scoreSubmotivo=5;
            }
            when 'del mismo grupo' {
                scoreSubmotivo=5;
            }
            when 'de Pedido de Saldos TVDE' {
                scoreSubmotivo=5;
            }
            when 'de Pedidos de vales con emisión de bonos' {
                scoreSubmotivo=5;
            }
            when 'de Pedidos de vales sin emisión de bonos' {
                scoreSubmotivo=5;
            }
            when 'Desbloqueo de Cuenta' {
                scoreSubmotivo=5;
            }
            when 'Descarga' {
                scoreSubmotivo=0;
            }
            when 'Descarga de proformas' {
                scoreSubmotivo=0;
            }
            when 'Descarga facturas' {
                scoreSubmotivo=0;
            }
            when 'Dirección Auxiliar' {
                scoreSubmotivo=0;
            }
            when 'Domicilio Fiscal' {
                scoreSubmotivo=0;
            }
            when 'El estatus del pedido no cambia' {
                scoreSubmotivo=5;
            }
            when 'Envío de factura' {
                scoreSubmotivo=0;
            }
            when 'Envío de proformas' {
                scoreSubmotivo=0;
            }
            when 'Envío de reportes' {
                scoreSubmotivo=0;
            }
            when 'Error al solicitar saldo a su cuenta corriente' {
                scoreSubmotivo=3;
            }
            when 'Error de registro en la app' {
                scoreSubmotivo=3;
            }
            when 'Error Edenred (cancela re facturación y vuelve a generar)' {
                scoreSubmotivo=5;
            }
            when 'Error en la carga del layout' {
                scoreSubmotivo=5;
            }
            when 'Error en la dispersión' {
                scoreSubmotivo=5;
            }
            when 'Estatus de entrega' {
                scoreSubmotivo=0;
            }
            when 'Estatus de incidencia' {
                scoreSubmotivo=0;
            }
            when 'Generación de Reporte de Gastos' {
                scoreSubmotivo=0;
            }
            when 'Generar proforma' {
                scoreSubmotivo=0;
            }
            when 'Habilitar reglas' {
                scoreSubmotivo=0;
            }
            when 'Lentitud/ intermitencia en la app' {
                scoreSubmotivo=5;
            }
            when 'Lentitud/ intermitencia en la web' {
                scoreSubmotivo=5;
            }
            when 'Liberación de pedido' {
                scoreSubmotivo=5;
            }
            when 'Liberación de pedido de saldo' {
                scoreSubmotivo=0;
            }
            when 'Manejo de Controles' {
                scoreSubmotivo=0;
            }
            when 'Movimientos de Tarjeta' {
                scoreSubmotivo=0;
            }
            when 'No puede transaccionar en eCommerce' {
                scoreSubmotivo=5;
            }
            when 'No puedo retirar efectivo del ATM' {
                scoreSubmotivo=5;
            }
            when 'No puedo transaccionar' {
                scoreSubmotivo=5;
            }
            when 'No reconoce la entrega' {
                scoreSubmotivo=3;
            }
            when 'No se puede descargar el documento' {
                scoreSubmotivo=3;
            }
            when 'No se refleja la dispersión' {
                scoreSubmotivo=5;
            }
            when 'Nota de servicio' {
                scoreSubmotivo=3;
            }
            when 'Pedido incompleto' {
                scoreSubmotivo=3;
            }
            when 'Pedido incorrecto (ordenamiento)' {
                scoreSubmotivo=3;
            }
            when 'Plantillas de carga masiva' {
                scoreSubmotivo=0;
            }
            when 'Plásticos' {
                scoreSubmotivo=3;
            }
            when 'Productos Electrónicos' {
                scoreSubmotivo=0;
            }
            when 'Productos Papel' {
                scoreSubmotivo=0;
            }
            when 'Programación reportes' {
                scoreSubmotivo=0;
            } 
            when 'Rastreo de pedido' {
                scoreSubmotivo=0;
            }
            when 'Razón Social' {
                scoreSubmotivo=0;
            } 
            when 'Re programación' {
                scoreSubmotivo=0;
            }
            when 'Reactivación cuenta Empleado' {
                scoreSubmotivo=3;
            } 
            when 'Reembolso al afiliado' {
                scoreSubmotivo=0;
            }
            when 'Reenvío' {
                scoreSubmotivo=0;
            } 
            when 'Renovación' {
                scoreSubmotivo=0;
            }
            when 'Reporte de movimientos' {
                scoreSubmotivo=0;
            } 
            when 'Retiro saldo empleado no vigente' {
                scoreSubmotivo=5;
            }
            when 'Retiro saldo empleado vigente' {
                scoreSubmotivo=5;
            } 
            when 'Retiro saldo por omisión de entrega de plástico' {
                scoreSubmotivo=5;
            }
            when 'Retraso en la entrega del documento' {
                scoreSubmotivo=3;
            } 
            when 'Sobres abiertos/maltratados' {
                scoreSubmotivo=3;
            }
            when 'Solicitud' {
                scoreSubmotivo=0;
            } 
            when 'Stock' {
                scoreSubmotivo=0;
            }
            when 'Subcuentas' {
                scoreSubmotivo=0;
            } 
            when 'Tarjetas' {
                scoreSubmotivo=0;
            }
            when 'Unificación o Separación de Comisión o Plásticos' {
                System.debug('entró a Unificación o Separación de Comisión o Plásticos');
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=0;
                }
                System.debug('scoreSubmotivo '+scoreSubmotivo);
            } 
            when 'Unificación o Separación de Transacciones' {
                if (c.Motivo__c=='Re facturación') {
                    scoreSubmotivo=3;
                }
                if (c.Motivo__c=='_Re facturación') {
                    scoreSubmotivo=3;
                }
            }
            when 'Uso de la plataforma' {
                scoreSubmotivo=0;
            } 
            when 'Vales dañados' {
                scoreSubmotivo=3;
            }
            when 'Vales Ex empleados - TDVE' {
                scoreSubmotivo=0;
            }                 
            when else {
                scoreSubmotivo=0;
            }
        }            
        switch on c.Temperatura_del_Contacto__c {
            when 'Molesto' {
                scoreTemperaturadelContacto=5;
            }
            when 'Moderado' {
                scoreTemperaturadelContacto=3;
            }
            when 'Tranquilo' {
                scoreTemperaturadelContacto=0;
            }                
            when else {
                scoreAmenazasdeAtricion=0;
            }
        }
        //--English--
        //Comment this lines in order to not consider Account Open Tickets as one of Ticket Scoring Criteria, also modify the final calculation to delete scoreHayTicketsAbiertos from the calculation and make relevant adjustments
        //Inicio
        //--Spanish--
        //Comentar estas líneas para no considerar los Tickets Abiertos de las Cuenta como uno de los Criterios de Puntuación de Casos, también modifique el cálculo final para eliminar scoreHayTicketsAbiertos del cálculo y realice los ajustes pertinenetes.
        //Start
        if (c.Tickets_Abiertos__c==null) {
            scoreHayTicketsAbiertos=0;
        } else {
            if (c.Tickets_Abiertos__c==0) {
                scoreHayTicketsAbiertos=0;
            } else {
                if (c.Tickets_Abiertos__c>0) {
                    scoreHayTicketsAbiertos=5;
                }
            }                
        }
        //--English--
        //End
        //--Spanish--
        //Final
        
        //
        //Final Calculation
        try{
            c.Score3__c=(scoreSegmentoComercial*pesoCriterioSegmentoComercial+scoreCanaldeAtencion*pesoCriterioCanaldeAtencion+scoreSector*pesoCriterioSector+scoreOportunidadesAbiertas*pesoCriterioOportunidadesAbiertas+scoreAmenazasdeAtricion*pesoCriterioAmenazasdeAtricion+scoreSubmotivo*pesoCriterioSubmotivo+scoreTemperaturadelContacto*pesoCriterioTemperaturadelContacto+scoreHayTicketsAbiertos*pesoCriterioHayTicketsAbiertos)/5;
        }catch(Exception e){
            System.debug('ERROR:'+e.getMessage());
        }
    }*/
}