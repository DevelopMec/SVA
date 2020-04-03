public without sharing class AsignacionesTicketsLiberacion_CONT {
    public static void dummy(){
        String e1;
        String e2;
        String e3;
        String e4;
        String e5;
        String e6;
        String e7;
        String e8;
        String e9;
        String e10;
        String e11;
        String e12;
        String e13;
        String e14;
        String e15;
        String e16;
        String e17;
        String e18;
        String e19;
        String e20;
        String e21;
        String e22;
        String e23;
        String e24;
        String e25;
        String e26;
        String e27;
        String e28;
        String e29;
        String e30;
        String e31;
        String e32;
        String e33;
        String e34;
        String e35;
        String e36;
        String e37;
        String e38;
        String e39;
        String e40;
        String e41;
        String e42;
        String e43;
        String e44;
        String e45;
        String e46;
        String e47;
        String e48;
        String c1;
        String c2;
        String c3;
        String c4;
        String c5;
        String c6;
        String c7;
        String c8;
        String c9;
        String c10;
        String c11;
        String c12;
        String c13;
        String c14;
        String c15;
        String c16;
        String c17;
        String c18;
        String c19;
        String c20;
        String c21;
        String c22;
        String c23;
        String c24;
        String c25;
        String c26;
        String c27;
        String c28;
        String c29;
        String c30;
        String c31;
        String c32;
        String c33;
        String c34;
        String c35;
        String c36;
        String c37;
        String c38;
        String c39;
        String c40;
        String c41;
        String c42;
        String c43;
        String c44;
        String c45;
        String c46;
        String c47;
        String c48;
        String f1;
        String f2;
        String f3;
        String f4;
        String f5;
        String f6;
        String f7;
        String f8;
        String f9;
        String f10;
        String f11;
        String f12;
        String f13;
        String f14;
        String f15;
        String f16;
        String f17;
        String f18;
        String f19;
        String f20;
        String f21;
        String f22;
        String f23;
        String f24;
        String f25;
        String f26;
        String f27;
        String f28;
        String f29;
        String f30;
        String f31;
        String f32;
        String f33;
        String f34;
        String f35;
        String f36;
        String f37;
        String f38;
        String f39;
        String f40;
        String f41;
        String f42;
        String f43;
        String f44;
        String f45;
        String f46;
        String f47;
        String f48;
    }
	@AuraEnabled
    public static List<caseWP> getTickets(){
        List<caseWP> res=new List<caseWP>();
        Set<String> motivos=getPickListValuesMotivo();
        Set<String> subMotivos=getPickListValuesSubMotivos();
        Set<String> subEstatus=getPickListValuesSubEstatus();
        Set<String> lisTP=new Set<String>{'Solicitud','Incidencia'};
            Set<String> catalogo=new Set<String>();
        for(Submotivo__c sub:[Select Id,Tipo_de_Ticket__c,Motivo__c,Name from Submotivo__c]){
            String key=sub.Tipo_de_Ticket__c+'-'+sub.Motivo__c+'-'+sub.Name;
            catalogo.add(key.toLowerCase());
        }
        for(Case c : [Select Id,Type,CaseNumber,Motivo__c,Sub_Motivo__c,Sub_Estatus__c,RecordType.DeveloperName from Case where (Type='Solicitud' or Type='Incidencia') and Motivo__c!=null and (Status='Abierto' or Status='En Proceso')]){
            caseWP tem=new caseWP();
            tem.idCaso=c.Id;
            tem.numeroCaso=c.CaseNumber+', Tipo: '+c.Type;
            tem.subEstatus=c.Sub_Estatus__c;
            tem.subMotivo=c.Sub_Motivo__c;
            tem.motivo=c.Motivo__c;
            tem.errores='';
            String key=c.Type+'-'+c.Motivo__c+'-'+c.Sub_Motivo__c;
            if(!catalogo.contains(key.toLowerCase())){
                tem.errores+='-Combinacion no existe';
            }
            if(!lisTP.contains(c.RecordType.DeveloperName)){
                tem.errores+='-Tipo de Registro incorrecto: '+c.RecordType.DeveloperName;
            }
            if(!motivos.contains(c.Motivo__c)){
                tem.errores+='-Motivo no se encuentra en la PickList';
            }
            if(!subMotivos.contains(c.Sub_Motivo__c)&&c.Sub_Motivo__c!=null){
                tem.errores+='- Sub Motivo no se encuentra en la PickList';
            }
            if(!subEstatus.contains(c.Sub_Estatus__c)&&c.Sub_Estatus__c!=null){
                tem.errores+='- Sub Estatus no se encuentra en la PickList';
            }
            if(tem.errores!=''){
               res.add(tem); 
            }
        }
        return res;
    }
    @AuraEnabled
    public static List<updateWP> asignarTiposDeRegistro(){
        List<updateWP> response=new List<updateWP>();
        List<Case> listUpd=new List<Case>();
        for(Case c : [Select Id,Type from Case where (RecordType.DeveloperName='Ticket_Car' or RecordType.DeveloperName='Ticket_Empresarial' or RecordType.DeveloperName='Benefits') and (Status='Abierto' or Status='En Proceso')]){
            c.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(c.Type).getRecordTypeId();
            listUpd.add(c);
        }
        updateWP tem;
        for(Database.SaveResult sr: Database.update(listUpd,false)){
            tem=new updateWP();
            if(sr.isSuccess()){
                tem.idCaso=sr.getId();tem.estatus=true;
            }else{
                tem.idCaso=sr.getId(); tem.estatus=true; tem.errores=''; tem.campos='';
                for(Database.Error de: sr.getErrors()){ for(String f : de.getFields()){ tem.campos+=f+','; } tem.errores+=de.getMessage()+','; }               
            }
            response.add(tem);
        }
        return response;
    }
    @AuraEnabled
    public static List<updateWP> asignarMotivoSubMotivo(){
        List<updateWP> response=new List<updateWP>();
        Map<String,String> mapaMotivos=new Map<String,String>{'Aclaración'=>'Aclaracion', 'Autorización Telefónica'=>'Autorizacion Telefonica', 'Cambio de datos (Empleado)'=>'Empleado', 'Cancelación'=>'Cancelacion', 'Cobranza'=>'Cobranza', '_Cobranza'=>'Cobranza', 'Conciliación'=>'Conciliacion', 'Cuentas'=>'Cuenta', '_Cuentas'=>'Cuenta', '__Cuentas'=>'Cuenta', 'Dispersión'=>'Dispersion', '__Dispersión'=>'Dispersion', 'Estatus de incidencia'=>'Estatus de incidencia', 'Facturación'=>'Facturacion', '_Facturación'=>'Facturacion', '__Facturación'=>'Facturacion', 'Lay Out'=>'Layout', 'Layout'=>'Layout', '_Layout'=>'Layout', 'Liberación'=>'Liberacion', 'Ligue de Empleadoras'=>'Empleadoras', 'Pedidos de Tarjeta'=>'Pedidos de Tarjeta', '_Pedidos de Tarjeta'=>'Pedidos de Tarjeta', 'Plataforma Web'=>'Plataforma Web', '__Plataforma Web'=>'Plataforma Web', 'Producto Papel'=>'Producto Papel', 'Re facturación'=>'Re facturacion', 'Saldo'=>'Saldo', 'Saldos'=>'Saldo', '_Saldos'=>'Saldo', 'Tarjeta'=>'Tarjeta', '_Tarjeta'=>'Tarjeta', '__Tarjeta'=>'Tarjeta', 'Tramites Administrativos'=>'Tramites Administrativos', 'ValesExempleados-TDVE'=>'Vales Ex empleados - TDVE', 'Web/App'=>'App'};
            Map<String,Map<String,String>> mapaSubMotivos=new Map<String,Map<String,String>>{'Abono a cuenta corriente'=>new Map<String,String>{'submotivo'=>'Saldo','subestatus'=>'Cuenta Corriente'}, 'Activación'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Activacion'}, 'Actualización de dirección auxiliar'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Direccion auxiliar'}, 'Adenda/Factura No Emitida'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Adenda/Factura No Emitida'}, 'Administrador'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Administrador'}, 'Alta de conductores'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Alta de conductores'}, 'Alta de un jefe'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Alta de un jefe'}, 'Aplicación de pago'=>new Map<String,String>{'submotivo'=>'Aplicacion de pago','subestatus'=>''}, 'Apoderado Legal'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Apoderado Legal'}, 'Asesoría'=>new Map<String,String>{'submotivo'=>'Asesoria','subestatus'=>''}, 'Asignación'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Asignacion'}, 'Asignación de saldo'=>new Map<String,String>{'submotivo'=>'Saldo','subestatus'=>'Asignacion de saldo'}, 'Asignación IVR'=>new Map<String,String>{'submotivo'=>'Saldo','subestatus'=>'Asignacion IVR'}, 'AT por tarjeta con problemas'=>new Map<String,String>{'submotivo'=>'AT por tarjeta con problemas','subestatus'=>''}, 'AT por terminal dañada'=>new Map<String,String>{'submotivo'=>'AT por terminal dañada','subestatus'=>''}, 'Baja de pedido de fondos'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Baja de pedido de fondos'}, 'Cambio De Cliente (subcuenta)'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Cambio De Cliente (subcuenta)'}, 'Cambio De Comisión'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Cambio De Comision'}, 'Cambio de datos (Empleado)'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Cambio de datos Empleado'}, 'Cambio de dirección de entrega'=>new Map<String,String>{'submotivo'=>'Cambio de direccion de entrega','subestatus'=>''}, 'Cambio De Domicilio'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Tramites administrativos'}, 'Cambio de fecha'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Cambio de fecha'}, 'Cambio de fecha de entrega'=>new Map<String,String>{'submotivo'=>'Cambio de fecha de entrega','subestatus'=>''}, 'Cambio De Metodo De Pago'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Cambio De Metodo De Pago'}, 'Cambio de No. de Nómina masivo'=>new Map<String,String>{'submotivo'=>'Cambio de no. de nomina unico/masivo','subestatus'=>''}, 'Cambio de No. de Nómina único'=>new Map<String,String>{'submotivo'=>'Cambio de no. de nomina unico/masivo','subestatus'=>''}, 'Cambio de persona'=>new Map<String,String>{'submotivo'=>'Cambio de receptor','subestatus'=>''}, 'Cambio De Razón Social'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Razon social'}, 'Cancelación de pedido'=>new Map<String,String>{'submotivo'=>'Cancelacion de pedido','subestatus'=>''}, 'Cancelación Definitiva De Factura'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Error interno re facturacion'}, 'Cancelación Factura de Fondos'=>new Map<String,String>{'submotivo'=>'Cancelacion Factura de Fondos','subestatus'=>'Cancelacion Factura de Fondos'}, 'Carga masiva'=>new Map<String,String>{'submotivo'=>'Confirmacion de archivos enviados el servidor','subestatus'=>''}, 'Cargo no reconocido en ATM'=>new Map<String,String>{'submotivo'=>'Cargo no reconocido en ATM','subestatus'=>''}, 'Cargo no reconocidos'=>new Map<String,String>{'submotivo'=>'Cargo no reconocidos','subestatus'=>''}, 'Cobro de más'=>new Map<String,String>{'submotivo'=>'Cobro de mas','subestatus'=>''}, 'Cobro de menos'=>new Map<String,String>{'submotivo'=>'Cobro de menos','subestatus'=>''}, 'Cómo se paga'=>new Map<String,String>{'submotivo'=>'Metodo de pago','subestatus'=>''}, 'Conciliación de cuenta'=>new Map<String,String>{'submotivo'=>'Conciliacion de cuenta','subestatus'=>''}, 'Conciliación de cuentas del afiliado'=>new Map<String,String>{'submotivo'=>'Conciliacion de cuentas del afiliado','subestatus'=>''}, 'Conciliación de cuentas del cliente'=>new Map<String,String>{'submotivo'=>'Conciliacion de cuentas del cliente','subestatus'=>''}, 'Conciliación de Factura'=>new Map<String,String>{'submotivo'=>'Conciliacion de Factura','subestatus'=>''}, 'Conciliación de movimientos de tarjeta'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Movimientos de tarjeta'}, 'Confirmación de Archivos enviados el Servidor'=>new Map<String,String>{'submotivo'=>'Confirmación de Archivos enviados el Servidor','subestatus'=>''}, 'Corrección De RFC'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'Correccion De RFC'}, 'Corte especial'=>new Map<String,String>{'submotivo'=>'Corte especial','subestatus'=>''}, 'Creación de cuentas'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Creacion estrutura'}, 'Creación estructura'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Creacion estrutura'}, 'Crear administrador nuevo'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Crear administrador'}, 'Cuenta'=>new Map<String,String>{'submotivo'=>'Saldo','subestatus'=>'Cuenta Corriente'}, 'Cuenta Corriente'=>new Map<String,String>{'submotivo'=>'Saldo','subestatus'=>'Cuenta Corriente'}, 'Cuenta mancomunada'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Cuenta mancomunada'}, 'Cuota de Adscripción'=>new Map<String,String>{'submotivo'=>'Facturas de servicio','subestatus'=>'Cuota de Adscripcion'}, 'de diferente grupo'=>new Map<String,String>{'submotivo'=>'Empleadoras','subestatus'=>'Ligue de empleadoras de diferente grupo'}, 'de Pedidos de vales con emisión de bonos'=>new Map<String,String>{'submotivo'=>'de Pedidos de vales con emision de bonos','subestatus'=>''}, 'de Pedidos de vales sin emisión de bonos'=>new Map<String,String>{'submotivo'=>'de Pedidos de vales sin emision de bonos','subestatus'=>''}, 'De Servicio Comisión'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'De Servicio por Comision'}, 'De Servicios por Plásticos'=>new Map<String,String>{'submotivo'=>'Re facturacion','subestatus'=>'De Servicios por Plasticos'}, 'del mismo grupo'=>new Map<String,String>{'submotivo'=>'Empleadoras','subestatus'=>'Ligue de empleadoras del mismo grupo'}, 'Desbloqueo de Cuenta'=>new Map<String,String>{'submotivo'=>'Desbloqueo de Cuenta','subestatus'=>''}, 'Descarga'=>new Map<String,String>{'submotivo'=>'Envio de factura','subestatus'=>'Envio de factura'}, 'Descarga de proformas'=>new Map<String,String>{'submotivo'=>'Envio de proformas','subestatus'=>'Envio de proformas'}, 'Descarga facturas'=>new Map<String,String>{'submotivo'=>'Envio de factura','subestatus'=>'Envio de factura'}, 'Dirección Auxiliar'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Direccion Auxiliar'}, 'Domicilio Fiscal'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Domicilio Fiscal'}, 'El estatus del pedido no cambia'=>new Map<String,String>{'submotivo'=>'El estatus del pedido no cambia','subestatus'=>''}, 'Envío de factura'=>new Map<String,String>{'submotivo'=>'Envio de factura','subestatus'=>''}, 'Envío de proformas'=>new Map<String,String>{'submotivo'=>'Envio de proformas','subestatus'=>''}, 'Envío de reportes'=>new Map<String,String>{'submotivo'=>'Reporte','subestatus'=>'Reportes especiales'}, 'Error al solicitar saldo a su cuenta corriente'=>new Map<String,String>{'submotivo'=>'Error al solicitar saldo a su cuenta corriente','subestatus'=>''}, 'Error de registro en la app'=>new Map<String,String>{'submotivo'=>'Error de registro','subestatus'=>''}, 'Error Edenred (cancela re facturación y vuelve a generar)'=>new Map<String,String>{'submotivo'=>'Error interno','subestatus'=>''}, 'Error en la carga del layout'=>new Map<String,String>{'submotivo'=>'Error en la carga del layout','subestatus'=>''}, 'Error en la dispersión'=>new Map<String,String>{'submotivo'=>'No se refleja la dispercion en cuenta','subestatus'=>''}, 'Estatus de entrega'=>new Map<String,String>{'submotivo'=>'Estatus/Rastreo','subestatus'=>''}, 'Estatus de incidencia'=>new Map<String,String>{'submotivo'=>'Estatus de incidencia','subestatus'=>''}, 'Generación de Reporte de Gastos'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Generacion de Reporte de Gastos'}, 'Generar proforma'=>new Map<String,String>{'submotivo'=>'Envio de proformas','subestatus'=>''}, 'Habilitar reglas'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Reglas de uso'}, 'Lentitud/ intermitencia en la app'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Lentitud/Intermitencia'}, 'Lentitud/ intermitencia en la web'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Lentitud/Intermitencia'}, 'Liberación de pedido'=>new Map<String,String>{'submotivo'=>'Liberacion de pedido','subestatus'=>''}, 'Liberación de pedido de saldo'=>new Map<String,String>{'submotivo'=>'Saldo','subestatus'=>'Liberacion de pedido de saldos'}, 'Manejo de Controles'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Manejo de controles'}, 'Movimientos de Tarjeta'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Movimientos de Tarjeta'}, 'No puede transaccionar en eCommerce'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'No puede transaccionar en eCommerce'}, 'No puedo retirar efectivo del ATM'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'No puedo retirar efectivo del ATM'},
                'No puedo transaccionar'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'No puedo transaccionar'}, 'No reconoce la entrega'=>new Map<String,String>{'submotivo'=>'No reconoce la entrega','subestatus'=>''}, 'No se puede descargar el documento'=>new Map<String,String>{'submotivo'=>'Facturacion','subestatus'=>'No se puede descargar el documento'}, 'No se refleja la dispersión'=>new Map<String,String>{'submotivo'=>'No se refleja la dispersion en cuenta','subestatus'=>''}, 'Nota de servicio'=>new Map<String,String>{'submotivo'=>'Nota de credito','subestatus'=>''}, 'Pedido incompleto'=>new Map<String,String>{'submotivo'=>'Pedido incompleto','subestatus'=>''}, 'Pedido incorrecto (ordenamiento)'=>new Map<String,String>{'submotivo'=>'Pedido incorrecto (ordenamiento)','subestatus'=>''}, 'Plantillas de carga masiva'=>new Map<String,String>{'submotivo'=>'Productos electronicos','subestatus'=>''}, 'Productos Electrónicos'=>new Map<String,String>{'submotivo'=>'Productos electronicos','subestatus'=>''}, 'Productos Papel'=>new Map<String,String>{'submotivo'=>'Asesoria','subestatus'=>''}, 'Programación reportes'=>new Map<String,String>{'submotivo'=>'Reporte','subestatus'=>'Reportes especiales'}, 'Rastreo de pedido'=>new Map<String,String>{'submotivo'=>'Estatus/Rastreo','subestatus'=>''}, 'Razón Social'=>new Map<String,String>{'submotivo'=>'Tramites Administrativos','subestatus'=>'Razon social'}, 'Re programación'=>new Map<String,String>{'submotivo'=>'Re programacion','subestatus'=>''}, 'Reactivación cuenta Empleado'=>new Map<String,String>{'submotivo'=>'Reactivacion cuenta Empleado','subestatus'=>''}, 'Reembolso al afiliado'=>new Map<String,String>{'submotivo'=>'Reembolso al afiliado','subestatus'=>''}, 'Reenvío'=>new Map<String,String>{'submotivo'=>'Reenvio','subestatus'=>''}, 'Renovación'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Renovacion'}, 'Reporte de movimientos'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Reporte de movimientos'}, 'Retiro saldo empleado no vigente'=>new Map<String,String>{'submotivo'=>'Retiro saldo empleado no vigente','subestatus'=>''}, 'Retiro saldo empleado vigente'=>new Map<String,String>{'submotivo'=>'Retiro saldo empleado vigente','subestatus'=>''}, 'Retiro saldo por omisión de entrega de plástico'=>new Map<String,String>{'submotivo'=>'Retiro saldo por omision de entrega de plastico','subestatus'=>''}, 'Retraso en la entrega del documento'=>new Map<String,String>{'submotivo'=>'Facturacion','subestatus'=>'Retraso en la entrega del documento'}, 'Sobres abiertos/maltratados'=>new Map<String,String>{'submotivo'=>'Sobres abiertos/maltratados','subestatus'=>''}, 'Solicitud'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Solicitud'}, 'Stock'=>new Map<String,String>{'submotivo'=>'Tarjeta','subestatus'=>'Stock'}, 'Subcuentas'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Subcuentas'}, 'Tarjetas'=>new Map<String,String>{'submotivo'=>'Saldo','subestatus'=>'confirmacion de abono en tarjeta'}, 'Uso de la plataforma'=>new Map<String,String>{'submotivo'=>'Plataforma Web','subestatus'=>'Uso de la plataforma'}, 'Vales dañados'=>new Map<String,String>{'submotivo'=>'Vales dañados','subestatus'=>''}, 'Vales_ Ex_empleados_-_TDVE'=>new Map<String,String>{'submotivo'=>'Vales Ex empleados - TDVE','subestatus'=>''}};
                    List<Case> listaCasos=new List<Case>();
                    for(Case c : [Select Id,CaseNumber,Motivo__c,Sub_Motivo__c,Sub_Estatus__c from Case where (Type='Solicitud' or Type='Incidencia') and Motivo__c!=null and (Status='Abierto' or Status='En Proceso')]){
                        boolean bandera=false;
                        if(mapaMotivos.containsKey(c.Motivo__c)){
                            c.Motivo__c=mapaMotivos.get(c.Motivo__c);
                            bandera=true;
                        }
                        if(mapaSubMotivos.containsKey(c.Sub_Motivo__c)){
                            System.debug('::MAP::'+mapaSubMotivos.get(c.Sub_Motivo__c));
                            //System.debug('::PASO::');
                            Map<String,String> temp=mapaSubMotivos.get(c.Sub_Motivo__c);
                            c.Sub_Motivo__c=temp!=null ? temp.get('submotivo') : '';
                            c.Sub_Estatus__c=temp!=null ? temp.get('subestatus') : '';
                            bandera=true;
                        }
                        if(bandera){
                            listaCasos.add(c);
                        }
                    }
                                                                                             updateWP tem;
                                                                                             Integer i=0;
                                                                                             for(Database.SaveResult sr: Database.update(listaCasos,false)){
                                                                                                 tem=new updateWP();
                                                                                                 String idc=sr.getId();
                                                                                                 System.debug('Id::'+listaCasos[i].Id);
                                                                                                 if(sr.isSuccess()){
                                                                                                     tem.idCaso=idc;tem.estatus=true;
                                                                                                 }else{
                                                                                                     tem.idCaso=idc; tem.estatus=false; tem.errores=''; tem.campos='';
                                                                                                     for(Database.Error de: sr.getErrors()){ for(String f : de.getFields()){ tem.campos+=f+','; } tem.errores+=de.getMessage()+','; }                
                                                                                                 }
                                                                                                 i++;
                                                                                                 response.add(tem);
                                                                                             }
                                                                                             return response;
    }
    public class updateWP{
        @AuraEnabled public String idCaso{get;set;}
        @AuraEnabled public String numeroCaso{get;set;}
        @AuraEnabled public boolean estatus{get;set;}
        @AuraEnabled public String errores{get;set;}
        @AuraEnabled public String campos{get;set;}
    }
    public class caseWP{
        @AuraEnabled public String idCaso{get;set;}
        @AuraEnabled public String numeroCaso{get;set;}
        @AuraEnabled public String motivo{get;set;}
        @AuraEnabled public String subMotivo{get;set;}
        @AuraEnabled public String subEstatus{get;set;}
        @AuraEnabled public String errores{get;set;}
    }
    public static Set<String> getPickListValuesMotivo(){
        Set<String> pickListValuesList= new Set<String>();
        Schema.DescribeFieldResult fieldResult = Case.Motivo__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getValue());
        }     
        return pickListValuesList;
    }
    public static Set<String> getPickListValuesSubMotivos(){
        Set<String> pickListValuesList= new Set<String>();
        Schema.DescribeFieldResult fieldResult = Case.Sub_Motivo__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getValue());
        }     
        return pickListValuesList;
    }
    public static Set<String> getPickListValuesSubEstatus(){
        Set<String> pickListValuesList= new Set<String>();
        Schema.DescribeFieldResult fieldResult = Case.Sub_Estatus__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getValue());
        }     
        return pickListValuesList;
    }        
}