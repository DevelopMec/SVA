global class BatchValidarUltimoPedido implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;  
        Date vdate = date.today();
        vdate = vdate.addDays(-1);
        query = 'SELECT Id FROM Account LIMIT 1'; 
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        return resultados; 
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> pedidos){
        
        List<uvw_OrdersInformation__x> listPedidos= new List<uvw_OrdersInformation__x>();
        Map<String,Decimal> mapaContratoFilial=new Map<String,Decimal>();
        Map<String,String> mapaContratoFilial2=new Map<String,String>();
        Map<String,String> mapaProductos=new Map<String,String>();
        List <string> listContratoFilial = new List<string>();
        List <string> listEntidadCuenta = new List<string>();
        List <string> listContratoFilialExiste = new List<string>();
        Map<String,String> mapaEntidadCuenta = new Map<String,String>();
        List<ContratoFilial__c> lupdateContratoFilial=new List<ContratoFilial__c>();
        Map<String,date> mapaContratoFilialFecha=new Map<String,date>();
        
        for(Product2 prod:[Select Id,ProductCode from Product2]){
            mapaProductos.put((prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode : ''), prod.Id);
        }
        
        Date vdate = date.today();
        vdate = vdate.addDays(-1);
        if (!test.isRunningTest()){
            for (uvw_OrdersInformation__x c : [SELECT Id, OrderDate__c, Contrato_Filial__c, BonusAmount__c, IdGroup__c, TaxPayerId__c FROM uvw_OrdersInformation__x WHERE OrderDate__c>=: vdate  ORDER BY OrderDate__c DESC]) listPedidos.add(c);
        }
        for (uvw_OrdersInformation__x datapedido: listPedidos){
            if(mapaContratoFilial.containsKey(datapedido.Contrato_Filial__c)){
                continue;
            }
            else{
                mapaContratoFilial.put(datapedido.Contrato_Filial__c, datapedido.BonusAmount__c);
                mapaContratoFilial2.put(datapedido.Contrato_Filial__c, datapedido.TaxPayerId__c);
                listEntidadCuenta.add(datapedido.TaxPayerId__c);
                listContratoFilial.add(datapedido.Contrato_Filial__c);
                mapaContratoFilialFecha.put(datapedido.Contrato_Filial__c,date.valueOf(String.valueOf(datapedido.OrderDate__c)));
            } 
            
        }
        
        if(test.isRunningTest()){
            mapaContratoFilial.put('01-29-01627-003', 100);
            mapaContratoFilial2.put('01-29-01627-003', 'SAP080618EJ3');
            listEntidadCuenta.add('SAP080618EJ3');
            listContratoFilial.add('01-29-01627-003');
             mapaContratoFilialFecha.put('01-29-01627-003',date.today());
            
            mapaContratoFilial.put('01-29-11627-333', 100);
            mapaContratoFilial2.put('01-29-11627-333', 'SAP080619993');
            listEntidadCuenta.add('SAP080618EJ3');
            listContratoFilial.add('01-29-11627-333');
            mapaContratoFilialFecha.put('01-29-11627-333',date.today());
        }
        
        for (ContratoFilial__c dataContrato: [SELECT Id, CodigoAS400__c FROM ContratoFilial__c WHERE  CodigoAS400__c IN : listContratoFilial] ){
            dataContrato.Last_order_date__c = mapaContratoFilialFecha.containsKey(dataContrato.CodigoAS400__c) ? mapaContratoFilialFecha.get(dataContrato.CodigoAS400__c) : vdate.addDays(-1);
            dataContrato.Amount_last_order__c = mapaContratoFilial.get(dataContrato.CodigoAS400__c);
            listContratoFilialExiste.add(dataContrato.CodigoAS400__c);
            lupdateContratoFilial.add(dataContrato) ;   
        }
        System.debug('lupdateContratoFilial ' + lupdateContratoFilial.size());
        Database.update(lupdateContratoFilial,false);
        
        //----------CREAR CONTRATOS FILIAL NO ENCONTRADO------------------------------------
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
          
            List<String> vproducto = vContrato.split('-');
            string vRFC = mapaContratoFilial2.get(vContrato);
            
            System.debug('vContrato ' + vContrato + ' vRFC ' + vRFC);
            
            //crear contrato filial
            ContratoFilial__c cContratoF = new ContratoFilial__c();
            cContratoF.Name = vContrato;
            cContratoF.CodigoAS400__c = vContrato;
            cContratoF.Last_order_date__c = vdate;
            cContratoF.Amount_last_order__c = mapaContratoFilial.get(vContrato);
            if(mapaEntidadCuenta.containsKey(vRFC)){
                cContratoF.Entidad_Cuenta__c = mapaEntidadCuenta.get(vRFC);
            }
            cContratoF.Producto__c = mapaProductos.get(vproducto[1]);
            
            lupdateContratoFilial.add(cContratoF);
        }
        System.debug('laddContratoFilial2 ' + lupdateContratoFilial.size() );
        if (lupdateContratoFilial.size() > 0){
           DataBase.insert(lupdateContratoFilial, false);
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC){}
    
}