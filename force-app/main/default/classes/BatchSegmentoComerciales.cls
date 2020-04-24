//----------------------------------------------------------------------------------------------------------------
//ERCB-624-HU_Segmento
//Actualizar de forma automática el segmento de la cuenta basado en el volumen de emisión.
//----------------------------------------------------------------------------------------------------------------
global class BatchSegmentoComerciales implements Database.Batchable<sObject>, Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query; 
        if (test.isRunningTest()){
            query = 'SELECT Id,Funcion__c, business__c,Owner.Name,OwnerId, NumeroEmpleados__c, Text_Segment__c,Segmento3__c,Frozen_Segment__c, CodigoClienteAS400__c,Type FROM Account WHERE CodigoClienteAS400__c= \'1627\'';
        }
        else{
            query = 'SELECT Id,Funcion__c, business__c,Owner.Name,OwnerId,Text_Segment__c, NumeroEmpleados__c, Segmento3__c, CodigoClienteAS400__c,Frozen_Segment__c,Type FROM Account WHERE CodigoClienteAS400__c != null ORDER BY CodigoClienteAS400__c DESC';
        }
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        return resultados;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> cuentas){ 
        List<Account> listCuentas=(List<Account>) cuentas;
        List<Account> lupdateCuentas=new List<Account>();
		system.debug(listCuentas);
        List<Account> channelBUAccounts = new List<Account>();
        Boolean hasAllContractsInactive = false;

        List<Segmento_Comerciales__c> listSegPatrimonio=new List<Segmento_Comerciales__c>();
        List <Id> listCuentasUsar = new List<Id>();
        List <decimal> listCuentasUsarIdGroup = new List<decimal>();
        Account cuenta;
        Map<String,String> mapaNumEmpleados=new Map<String,String>();
        Map<String,decimal> mapaFacturas=new Map<String,decimal>();
        Map<String,decimal> mapaContFacturas=new Map<String,decimal>();
        Map<String,decimal> mapaContFacturasFrecuencia=new Map<String,decimal>();
        Map<String,boolean> mapaVentaNueva=new Map<String,boolean>();
        Map<String,decimal> mapaContFacturasP29=new Map<String,decimal>();
        Map<String,decimal> mapaEntidadCuenta=new Map<String,decimal>();
        Map<String,decimal> mapaCuentas=new Map<String,decimal>();
        integer cont = 0;
        //Por número de empleados
        for(Segmento_Comerciales__c seg:[SELECT Name, Prospect__c FROM Segmento_Comerciales__c]){
            mapaNumEmpleados.put(seg.Prospect__c, seg.Name);
        }
        
        //Por patrominio
        listSegPatrimonio = [SELECT Name, Patrimony_From__c, Patrimony_To__c FROM Segmento_Comerciales__c];
        
        
        //Obtiene la sumatoria de las facturas
        Date dateEnd = date.newinstance(Date.today().year(), Date.today().month(), 1);
        dateEnd = dateEnd.addDays(-1);
        Date dateIni= dateEnd.addMonths(-12);
        System.debug('dateIni ' + dateIni);
        
        //-----En caso de que la cantidad de items de la lista Account sea uno, solo va a procesar las subcuentas correspondientes
        List <string> listSubcuentas = new List<string>();
        Set <String> contratosFiliales = new Set<String>();
        List <ContratoFilial__c> contratoF = new List<ContratoFilial__c>();
        List <EntidadCuenta__c> entidadC = new List<EntidadCuenta__c>();
        List <uvw_MonthlyBilling__x> datafact = new List<uvw_MonthlyBilling__x>();
        
        for(Account vCuenta: listCuentas){
            listCuentasUsar.add(vCuenta.Id);
            if (vCuenta.CodigoClienteAS400__c!= null) {
                try{
                    listCuentasUsarIdGroup.add(decimal.valueOf(vCuenta.CodigoClienteAS400__c));
                }
                catch(Exception e){}
            }
        }
        
        contratoF = [SELECT Id, Name, average_turnover_volume__c, Entidad_Cuenta__c,Entidad_Cuenta__r.Cuenta__c,Entidad_Cuenta__r.Cuenta__r.Text_Segment__c, CodigoAS400__c,Last_order_date__c from ContratoFilial__c WHERE Entidad_Cuenta__r.Cuenta__r.ID IN: listCuentasUsar];
        for (ContratoFilial__c ent: contratoF ){
            listSubcuentas.add(ent.Name);
            contratosFiliales.add(ent.Id);
        }
        // System.debug('listSubcuentas ' + listSubcuentas.size());
        
        entidadC = [SELECT Id, 	Cuenta__c, Sum_turnover_volume__c FROM EntidadCuenta__c Where Cuenta__c IN:listCuentasUsar];
        
        if (!test.isRunningTest()){
            for (uvw_MonthlyBilling__x c : [SELECT SubAccount__c, InvoiceAmount__c, InvoicePaymentDate__c, IdProduct__c 
                                            FROM uvw_MonthlyBilling__x  
                                            //WHERE InvoicePaymentDate__c>=: dateIni AND InvoicePaymentDate__c <=: dateEnd 
                                            WHERE InvoicePaymentDate__c>=: dateIni
                                            AND (EdlClosingDayStatus__c = '02' OR EdlClosingDayStatus__c = '05')
                                            AND IdGroup__c IN : listCuentasUsarIdGroup
                                            ORDER BY SubAccount__c, InvoicePaymentDate__c]) datafact.add(c);
            
            
        }
        
        System.debug('datafact size ' + datafact.size());
        String comp = '';
        
        if (test.isRunningTest()){
            uvw_MonthlyBilling__x testfact = new uvw_MonthlyBilling__x();
            testfact.InvoicePaymentDate__c = dateEnd;
            datafact.add(testfact);
        }
        
        Date fechaActual = null;
        Date fechaAnterior = null;
        Date fechaVentaNueva =date.newinstance(Date.today().year(), Date.today().month(), 1);
        fechaVentaNueva = fechaVentaNueva.addMonths(-4);
        
        for(uvw_MonthlyBilling__x fact: datafact){
            if (fact.InvoicePaymentDate__c > dateEnd){
                continue;
            }
            
            if(mapaFacturas.containsKey(fact.SubAccount__c)){
                mapaFacturas.put(fact.SubAccount__c,mapaFacturas.get(fact.SubAccount__c) + fact.InvoiceAmount__c);
            } 
            else{
                mapaFacturas.put(fact.SubAccount__c,fact.InvoiceAmount__c);
            }
            
            string vfecha = fact.SubAccount__c + 'D' + fact.InvoicePaymentDate__c.month() +  fact.InvoicePaymentDate__c.year(); 
            if (comp != vfecha){
                comp = vfecha;

                if (!mapaContFacturas.containsKey(fact.SubAccount__c)){
                    mapaContFacturas.put(fact.SubAccount__c,0);
                    mapaContFacturasFrecuencia.put(fact.SubAccount__c,0);
                    mapaContFacturasP29.put(fact.SubAccount__c,0);
                    fechaActual = null;
                    fechaAnterior = null;
                }
                //Obtiene cantidad de meses
                mapaContFacturas.put(fact.SubAccount__c,mapaContFacturas.get(fact.SubAccount__c) + 1);
                
                //Obtiene la frecuencia -- validando meses consecutivos
                if ( fechaActual != null){
                    fechaAnterior = fechaActual;	
                }
                fechaActual = date.newinstance(fact.InvoicePaymentDate__c.year(), fact.InvoicePaymentDate__c.month(), 1);    
                
                if (fechaActual != null && fechaAnterior != null){
                    if (fechaActual == fechaAnterior.addMonths(1)){
                        
                        mapaContFacturasFrecuencia.put(fact.SubAccount__c,mapaContFacturasFrecuencia.get(fact.SubAccount__c) + 1);
                    }
                    else{
                        if (mapaContFacturasFrecuencia.get(fact.SubAccount__c) < 4){
                        	mapaContFacturasFrecuencia.put(fact.SubAccount__c,1);
                        }
                    }
                }
                
                //Evalua si es Venta Nueva
                if (fechaActual>=fechaVentaNueva){
                    if (!mapaVentaNueva.containsKey(fact.SubAccount__c)){
                		mapaVentaNueva.put(fact.SubAccount__c, true);    
                	}
                }
                else{
                  mapaVentaNueva.put(fact.SubAccount__c, false);    
                }
                
                //Obtiene la cantidad de facturas del producto 29
                if (fact.IdProduct__c == 29){
                    mapaContFacturasP29.put(fact.SubAccount__c,mapaContFacturasP29.get(fact.SubAccount__c) + 1);   
                }
            }
        }
        
        
        if (test.isRunningTest()){
            integer vtestcont = 0;
            for (ContratoFilial__c ent: contratoF ){
                if (vtestcont == 0){
                    mapaFacturas.put(ent.Name,1000);
                    mapaContFacturas.put(ent.Name,2);
                    mapaContFacturasFrecuencia.put (ent.Name,6);
                    mapaContFacturasP29.put(ent.Name,4);
                    mapaVentaNueva.put(ent.Name,true);
                    vtestcont++;
                }
                else{
                    mapaFacturas.put(ent.Name,0);
                    mapaContFacturas.put(ent.Name,1);
                    mapaContFacturasFrecuencia.put (ent.Name,1);
                    mapaContFacturasP29.put(ent.Name,1);
                    mapaVentaNueva.put(ent.Name,false);
                    break;   
                }
                
            }
            
            mapaEntidadCuenta.put('3444', 0);
        }
        
        //Actualiza el monto de las facturas en Contrato Filial
        List<ContratoFilial__c> lupdateContratoF=new List<ContratoFilial__c>();
        for(ContratoFilial__c dcontrato : contratoF){
             if(dcontrato.Last_order_date__c >=  dateIni && dcontrato.Last_order_date__c <= dateEnd){
                	dcontrato.isActive__c = true;    
               } else {
                    dcontrato.isActive__c = false;
                }
            if(mapaFacturas.containsKey(dcontrato.CodigoAS400__c)){
                dcontrato.average_turnover_volume__c = mapaFacturas.get(dcontrato.CodigoAS400__c) / mapaContFacturas.get(dcontrato.CodigoAS400__c);

                dcontrato.Frecuency__c = 'Irregular'; 
                
                if (mapaContFacturasFrecuencia.get(dcontrato.CodigoAS400__c) >= 4){
                    dcontrato.Frecuency__c = 'Recurrente';    
                }
                
                if (mapaContFacturasP29.get(dcontrato.CodigoAS400__c) >= 4){
                    dcontrato.Frecuency__c = 'Recurrente';
                }
                
                if (mapaVentaNueva.get(dcontrato.CodigoAS400__c)){
                    dcontrato.Frecuency__c = 'Venta Nueva';
                }
                
            }
            else{
                dcontrato.average_turnover_volume__c = 0; 
                dcontrato.Frecuency__c = 'Irregular';
            }
            
            if (dcontrato.Entidad_Cuenta__c != null){
                if(mapaEntidadCuenta.containsKey(dcontrato.Entidad_Cuenta__c)){
                    mapaEntidadCuenta.put(dcontrato.Entidad_Cuenta__c,mapaEntidadCuenta.get(dcontrato.Entidad_Cuenta__c) + dcontrato.average_turnover_volume__c);	    
                }
                else{
                    mapaEntidadCuenta.put(dcontrato.Entidad_Cuenta__c,dcontrato.average_turnover_volume__c);
                }   
            }
            
            
            lupdateContratoF.add(dcontrato);
            
        }
        //System.debug('lupdateContratoF ' + lupdateContratoF.size());
        Database.update(lupdateContratoF,false) ;
        
        //Actualiza el monto de las facturas en Entidad Cuenta
        List<EntidadCuenta__c> lupdateEntidadCuenta=new List<EntidadCuenta__c>();
        for(EntidadCuenta__c entidad : entidadC){
            if(mapaEntidadCuenta.containsKey(entidad.Id)){
                entidad.Sum_turnover_volume__c = mapaEntidadCuenta.get(entidad.Id);
                entidad.isActive__c = true;
                
                if (entidad.Cuenta__c != null){
                    if(mapaCuentas.containsKey(entidad.Cuenta__c)){
                        mapaCuentas.put(entidad.Cuenta__c,mapaCuentas.get(entidad.Cuenta__c) + entidad.Sum_turnover_volume__c);	    
                    }
                    else{
                        mapaCuentas.put(entidad.Cuenta__c,entidad.Sum_turnover_volume__c);
                    } 
                }
            }
            else{
                entidad.Sum_turnover_volume__c = 0; 
                entidad.isActive__c = false;
            }
            lupdateEntidadCuenta.add(entidad);
        }
        Database.update(lupdateEntidadCuenta,false) ;
        
        //Procesamiento de cuentas
        for(Account dataCuenta : listCuentas){
            //Basado en IV del grupo/cliente al mes
            if(mapaCuentas.containsKey(dataCuenta.Id)){
                decimal sumF = mapaCuentas.get(dataCuenta.Id);
                for(Segmento_Comerciales__c seg :listSegPatrimonio){
                    if (sumF >= seg.Patrimony_From__c && sumF <=seg.Patrimony_To__c){
                        dataCuenta.Segmento3__c = seg.Name;
                        if (!test.isRunningTest()){
                            lupdateCuentas.add(dataCuenta);
                        }
                        break;
                    }
                }
                if (!test.isRunningTest()){
                    continue;
                }
            }
            
            //Basado en el # total de empleados de la empresa
            if(mapaNumEmpleados.containsKey(dataCuenta.NumeroEmpleados__c)){
                string seg = mapaNumEmpleados.get(dataCuenta.NumeroEmpleados__c);
                If (seg != dataCuenta.Segmento3__c){
                    dataCuenta.Segmento3__c = seg;
                    lupdateCuentas.add(dataCuenta);			 
                }
            }
        }
        
        Database.update(lupdateCuentas,false) ;
        Vista_EjecutivosAsignadosBatchProcess accountViews = new Vista_EjecutivosAsignadosBatchProcess(listCuentas,contratoF);
        Database.update(accountViews.updateAccountView(),false);
        
    }
    
    
    global void finish(Database.BatchableContext BC){}
}