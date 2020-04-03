global class BatchContratoFilial implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
		String query;
        if(!Test.isRunningTest()){        
            query = 'SELECT Id, Contrato_2__c,CodigoAS400__c,Producto__c  FROM ContratoFilial__c where Producto__c=null';
        }else{
            query = 'SELECT Id, Contrato_2__c,CodigoAS400__c,Producto__c  FROM ContratoFilial__c where Producto__c=null limit 10';
        }
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        return resultados;
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> contratosFilial){
        List<ContratoFilial__c> lupdate=new List<ContratoFilial__c>();
        List<ContratoFilial__c> listProd=(List<ContratoFilial__c>) contratosFilial;
        Map<String,String> mapaProductos=new Map<String,String>();
        Map<String,String> mapaProductosAs4=new Map<String,String>();
        Map<String,String> mapaContratos=new Map<String,String>();
        Set<String> IdContratos=new Set<String>();
        for(ContratoFilial__c tem:listProd){
            IdContratos.add(tem.Contrato_2__c);
        }
        for(Contrato2__c contr:[Select Id,PartidaPresupuesto__r.Product2Id from Contrato2__c where Id IN :IdContratos]){
            mapaContratos.put(contr.Id, contr.PartidaPresupuesto__r.Product2Id);
        }        
        for(Product2 prod:[Select Id,ProductCode from Product2]){
            if(!mapaProductos.containsKey(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode : '')){ mapaProductos.put(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode : '', prod.Id); } if(!mapaProductosAs4.containsKey(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode.subString(0,2) : '')){ mapaProductosAs4.put(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode.subString(0,2) : '', prod.Id); }           
        }
        System.debug('mapaContratos:'+JSON.serialize(mapaContratos));
        System.debug('mapaProductos:'+JSON.serialize(mapaProductos));
        for(ContratoFilial__c contratoF : listProd){
            if(contratoF.Contrato_2__c==null){
                if(contratoF.CodigoAS400__c!=null){
                    List<String> codigo=contratoF.CodigoAS400__c.split('-');
                    System.debug('AS400:::'+contratoF.CodigoAS400__c);
                    if(codigo.size()==4){
                        System.debug('PRoducto::'+mapaProductosAs4.get(codigo[1]));
                        if(mapaProductosAs4.containsKey(codigo[1])){
                            contratoF.Producto__c=mapaProductosAs4.get(codigo[1]);
                            lupdate.add(contratoF);
                        }
                    }else if(codigo.size()==2){
                        //codigo 2
                        System.debug('OPAN::'+codigo[1]);
                        if(codigo[1].startsWithIgnoreCase('G')||codigo[1].startsWithIgnoreCase('SEL')){ System.debug('60-M'); contratoF.Producto__c=mapaProductos.get('60-M'); }else if(codigo[1].startsWithIgnoreCase('A')||codigo[1].startsWithIgnoreCase('D')||codigo[1].startsWithIgnoreCase('E')||codigo[1].startsWithIgnoreCase('L')||codigo[1].startsWithIgnoreCase('C')||codigo[1].startsWithIgnoreCase('V')){ System.debug('52-C'); contratoF.Producto__c=mapaProductos.get('52-C'); }else if(codigo[1].startsWithIgnoreCase('R')){ System.debug('81'); contratoF.Producto__c=mapaProductos.get('81'); }else if(codigo[1].startsWithIgnoreCase('P')||codigo[1].startsWithIgnoreCase('IN')){ System.debug('48'); contratoF.Producto__c=mapaProductos.get('48'); }else if(codigo[1].startsWithIgnoreCase('PS')){ System.debug('39'); contratoF.Producto__c=mapaProductos.get('39'); }
                        System.debug('CF::'+contratoF);
                        lupdate.add(contratoF);
                    }
                }
            }else{
                System.debug('Else');
                if(mapaContratos.containsKey(contratoF.Contrato_2__c)&&mapaContratos.get(contratoF.Contrato_2__c)!=null){
                    contratoF.Producto__c=mapaContratos.get(contratoF.Contrato_2__c);
                    lupdate.add(contratoF);
                }
            }
            
        }
        System.debug('ListaUp::'+JSON.serialize(lupdate));
        Database.update(lupdate,false) ;
    }
    
    global void finish(Database.BatchableContext BC){}
}