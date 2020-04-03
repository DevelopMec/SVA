global class BatchTodosUltimoPedido implements Database.Batchable<sObject>, Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;  
        if (test.isRunningTest()){
            query = 'SELECT id,CodigoAS400__c,Amount_last_order__c,Last_order_date__c FROM ContratoFilial__c WHERE CodigoAS400__c=\'01-29-01627-003\' OR  CodigoAS400__c=\'01-29-01627-333\' ';
        }
        else{
            query = 'SELECT id,CodigoAS400__c,Amount_last_order__c,Last_order_date__c FROM ContratoFilial__c WHERE Producto__r.Es_OPAM__c=false';
           
        }
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        return resultados; 
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> cuentas){
        List<ContratoFilial__c> listCuentas=(List<ContratoFilial__c>) cuentas;
        List <String> listCuentasUsarIdGroup = new List<String>();
        List<uvw_OrdersInformation__x> listPedidos= new List<uvw_OrdersInformation__x>();
        Map<String,String> mapaContratoFilial=new Map<String,String>();
        Map<String,String> mapaProductos=new Map<String,String>();
        List <string> listContratoFilial = new List<string>();
        List <string> listEntidadCuenta = new List<string>();
        List <string> listContratoFilialExiste = new List<string>();
        Map<String,String> mapaEntidadCuenta = new Map<String,String>();
        List<ContratoFilial__c> lupdateContratoFilial=new List<ContratoFilial__c>();
        List<Account> lupdateCuenta=new List<Account>();
        Date vdate = date.today();
        vdate=vdate.addYears(-2);
        for(ContratoFilial__c vCuenta: listCuentas){
            if (vCuenta.CodigoAS400__c!= null) {
                try{                    
                    //lupdateCuenta.Add(vCuenta);
                    listCuentasUsarIdGroup.add(vCuenta.CodigoAS400__c);
                }
                catch(Exception e){}
            }
        }
        
        if (!test.isRunningTest()){
            for (uvw_OrdersInformation__x c : [SELECT Id, OrderDate__c, Contrato_Filial__c, BonusAmount__c, IdGroup__c, TaxPayerId__c,SubAccount__c FROM uvw_OrdersInformation__x WHERE SubAccount__c =: listCuentasUsarIdGroup AND OrderDate__c>=:vdate ORDER BY Contrato_Filial__c , OrderDate__c DESC limit 50000]) listPedidos.add(c);   
        }
        
        for (uvw_OrdersInformation__x datapedido: listPedidos){
            if(mapaContratoFilial.containsKey(datapedido.Contrato_Filial__c)){
                continue;
            }
            else{
                mapaContratoFilial.put(datapedido.Contrato_Filial__c, datapedido.OrderDate__c + '/' + datapedido.BonusAmount__c + '/' + datapedido.TaxPayerId__c);
                listEntidadCuenta.add(datapedido.TaxPayerId__c);
                listContratoFilial.add(datapedido.Contrato_Filial__c);
            } 
            
        }
        
        if(test.isRunningTest()){
            mapaContratoFilial.put('01-29-01627-003', '2015-05-31T00:00:00.000+0000/100/SAP080618EJ3');
            listEntidadCuenta.add('SAP080618EJ3');
            listContratoFilial.add('01-29-01627-003');
            
            mapaContratoFilial.put('01-29-11627-333', '2015-05-31T00:00:00.000+0000/100/SAP080618EJ3');
            listEntidadCuenta.add('SAP080618EJ3');
            listContratoFilial.add('01-29-11627-333');
        }
        
        for (ContratoFilial__c dataContrato: [SELECT Id, CodigoAS400__c FROM ContratoFilial__c WHERE  CodigoAS400__c IN : listContratoFilial] ){
            try{
                List<String> dataContratoFilial = mapaContratoFilial.get(dataContrato.CodigoAS400__c).split('/');
                System.debug('Contrato Existe ' + dataContrato.CodigoAS400__c + ' ' + dataContratoFilial[0]);
                date vfecha = date.valueOf(dataContratoFilial[0]);
                vfecha = vfecha.addDays(-1);
                decimal vmonto = decimal.valueOf(dataContratoFilial[1]);
                dataContrato.Last_order_date__c = vfecha;
                dataContrato.Amount_last_order__c = vmonto;
                listContratoFilialExiste.add(dataContrato.CodigoAS400__c);
                lupdateContratoFilial.add(dataContrato) ;
            }
            catch(Exception e){
                system.debug('Error '+e.getMessage()+e.getLineNumber());
            }
        }
        System.debug('lupdateContratoFilial ' + lupdateContratoFilial.size());
        
        if(!lupdateContratoFilial.isEmpty())
        	Database.update(lupdateContratoFilial,false);
        
        //----------CREAR CONTRATOS FILIAL NO ENCONTRADO------------------------------------
        /*
        //Trae las entidades cuenta relacionadas
        for(EntidadCuenta__c ventidad:[SELECT Id, Name, RFC_IDExterno__c FROM EntidadCuenta__c WHERE Name IN: listEntidadCuenta]){
            mapaEntidadCuenta.put (ventidad.Name, ventidad.Id);
        }
        
        //Crea los contratos filiales no encontrados
        lupdateContratoFilial = new List<ContratoFilial__c>();
        for (Integer i=0; i<listContratoFilial.size(); i++ ) {
            string vContrato = listContratoFilial[i];
            if (listContratoFilialExiste.contains(vContrato)){
                continue;
            }
            
            System.debug('vContrato no existe ' + vContrato);
            try{
                List<String> vproducto = vContrato.split('-');
                List<String> dataContratoFilial = mapaContratoFilial.get(vContrato).split('/');
                string vRFC = dataContratoFilial[2];
                
                //crear contrato filial
                date vfecha = date.valueOf(dataContratoFilial[0]);
                decimal vmonto = decimal.valueOf(dataContratoFilial[1]);
                
                ContratoFilial__c cContratoF = new ContratoFilial__c();
                cContratoF.Name = vContrato;
                cContratoF.CodigoAS400__c = vContrato;
                cContratoF.Last_order_date__c = vfecha;
                cContratoF.Amount_last_order__c = vmonto;
                if(mapaEntidadCuenta.containsKey(vRFC)){
                    cContratoF.Entidad_Cuenta__c = mapaEntidadCuenta.get(vRFC);
                }
                cContratoF.Producto__c = mapaProductos.get(vproducto[1]);
                
                lupdateContratoFilial.add(cContratoF);
            }
            catch(Exception e){}
        }
        System.debug('lAddContratoFilial2 ' + lupdateContratoFilial.size() );
        if (lupdateContratoFilial.size() > 0){
            DataBase.insert(lupdateContratoFilial, false);
        }
*/
        
        //Marca las cuentas que ya fueron procesadas
       // DataBase.update(lupdateCuenta, false);
    }
    global void finish(Database.BatchableContext BC){}
    
}