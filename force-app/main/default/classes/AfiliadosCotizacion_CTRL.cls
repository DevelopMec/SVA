public class AfiliadosCotizacion_CTRL {
    @AuraEnabled
    public static responseCotWP crearCotizacion(Quote cot,QuoteLineItem quLiIt,String action){
        responseCotWP res=new responseCotWP();
        Savepoint sp=Database.setSavepoint();
        System.debug('CO:'+cot);
        System.debug('PCO:'+quLiIt);
        try{
            Integer i=[Select count() from Quote where OpportunityId=:cot.OpportunityId];
            cot.Name=cot.Id==null ? 'Cotización '+(i+1) : cot.Name ;
            cot.Pricebook2Id=[Select Id from Pricebook2 where Name = 'Edenred' limit 1].Id;
            upsert cot;
            sincronizarCotizacion(cot.OpportunityId,cot.Id);
            String idQli=crearProductoCotizacion(cot.OpportunityId,cot.Id,quLiIt,action);
            res.status=true;
            res.valores=new Map<String,String>{'idQuote'=>cot.Id,'idQli'=>idQli};
        }catch(DMLException e){            
            res.status=false;
            Integer numErrors = e.getNumDml();
            List<String> lErr=new List<String>();
            for(Integer i=0;i<numErrors;i++) {
                lErr.add(e.getDmlMessage(i));
            }
            res.errores=String.join(lErr, ',');
            Database.rollback(sp);
        }catch(Exception e){
            res.status=false;
            res.errores='Error: '+e.getMessage()+',linea: '+e.getLineNumber();
            Database.rollback(sp);
        }
        System.debug('RES:'+res);
        return res;
    }
    @AuraEnabled
    public static String crearProductoCotizacion(String idOp,String idQ,QuoteLineItem quLiIt,String action){
        if(action=='create'){
            PricebookEntry pe=[SELECT Id, Name, Product2Id, Pricebook2Id from PricebookEntry Where Product2Id=:quLiIt.Product2Id AND Pricebook2.Name = 'Edenred'];
            quLiIt.PricebookEntryId=pe.Id;
            quLiIt.QuoteId=idQ;
            quLiIt.Quantity=1;
            quLiIt.UnitPrice=0;
            System.debug('QLICRE:'+quLiIt);
            insert quLiIt;
        }else{
            //set de campos para QuoteLineItem            
            QuoteLineItem qli=[Select Id,Product2Id,OpportunityLineItemId from QuoteLineItem where Id=:quLiIt.Id];
            if(qli.Product2Id!=quLiIt.Product2Id){
                quLiIt.Id=null;
                deletePreQli(qli);
                PricebookEntry pe=[SELECT Id, Name, Product2Id, Pricebook2Id from PricebookEntry Where Product2Id=:quLiIt.Product2Id AND Pricebook2.Name = 'Edenred'];
                quLiIt.PricebookEntryId=pe.Id;
                quLiIt.QuoteId=idQ;
                quLiIt.Quantity=1;
                quLiIt.UnitPrice=0;
                System.debug('QLICRE:'+quLiIt);
                insert quLiIt;
            }            
        }
        return quLiIt.Id;
    }
    public static void deletePreQli(QuoteLineItem qli){
        List<Anexo__c> lA=[Select Id from Anexo__c where Solucion__c=:qli.Id];
        if(lA!=null&&lA.size()>0){
            Delete lA;
        }
        Delete qli;
    }
    
    public static Map<String,campoExtendWP> getCampos(String camposStr){
        List<String> lFields=camposStr.split(';');
        Map<String,campoExtendWP> mapaCampos=new Map<String,campoExtendWP>();
        map<string,SObjectField> fList = schema.getGlobalDescribe().get('Contrato2__c').getDescribe().fields.getMap();
        for(string str: fList.keySet()){
            if(lFields.contains(fList.get(str).getDescribe().getName())){
                mapaCampos.put(String.valueOf(fList.get(str).getDescribe().getName()),new campoExtendWP(fList.get(str).getDescribe(),new Contrato2__c()));
            }
        }
        return mapaCampos;
    }
    public class campoExtendWP{
        @AuraEnabled public String tipo{get;set;}
        @AuraEnabled public String api{get;set;}
        @AuraEnabled public Object value{get;set;}
        @AuraEnabled public String etiqueta{get;set;}
        @AuraEnabled public List<comboWP> listaValores{get;set;}
        public campoExtendWP(Schema.DescribeFieldResult des,Contrato2__c adv){
            this.tipo=String.valueOf(des.getType());
            this.api=String.valueOf(des.getName());
            this.etiqueta=String.valueOf(des.getLabel());
            if(String.valueOf(des.getType()).equalsIgnoreCase('PICKLIST')||String.valueOf(des.getType()).equalsIgnoreCase('MULTIPICKLIST')){
                this.listaValores=getValores(des.getPicklistValues(),this.api);
            }
            this.value=adv.get(String.valueOf(des.getName()));
        }
    }
    public static List<comboWP> getValores(List<Schema.PicklistEntry> ple,String api){
        List<comboWP> res=new List<comboWP>();
        for( Schema.PicklistEntry pickListVal : ple){
            res.add(new comboWP(pickListVal.getValue(),pickListVal.getLabel()));
        }
        return res;
    }
    
    public without sharing class comboWP{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
        public comboWP(String val,String lab){
            this.label=lab;
            this.value=val;
        }
    }
    
    @AuraEnabled
    public static responseCotWP guardarTarifas(String idQli,List<ProductoConcepto__c> tarifasSelec,Contrato2__c adv){        
        responseCotWP res=new responseCotWP();
        try{
            Map<String,ProductoConcepto__c> mapaExistentes=new Map<String,ProductoConcepto__c>();
            for(ProductoConcepto__c pc : [Select Id,Concepto__c,PartidaPresupuesto__c from ProductoConcepto__c where PartidaPresupuesto__c=:idQli]){
                mapaExistentes.put(pc.Concepto__c+'-'+pc.PartidaPresupuesto__c,pc);            
            }
            for(ProductoConcepto__c pc : tarifasSelec){
                if(mapaExistentes.containsKey(pc.Concepto__c+'-'+pc.PartidaPresupuesto__c)){
                    pc.Id=mapaExistentes.get(pc.Concepto__c+'-'+pc.PartidaPresupuesto__c).Id;
                    mapaExistentes.remove(pc.Concepto__c+'-'+pc.PartidaPresupuesto__c);
                }
            }
            upsert adv;
            upsert tarifasSelec;
            delete mapaExistentes.values();
            res.status=true;
        }catch(DMLException e){            
            res.status=false;
            Integer numErrors = e.getNumDml();
            List<String> lErr=new List<String>();
            for(Integer i=0;i<numErrors;i++) {
                lErr.add(e.getDmlMessage(i));
            }
            res.errores=String.join(lErr, ',');
        }catch(Exception e){
            res.status=false;
            res.errores='Error: '+e.getMessage()+',linea: '+e.getLineNumber();
        }
        System.debug('RESGT>>'+res);
        return res;
    }
    public class responseCotWP{
        @AuraEnabled public boolean status{get;set;}
        @AuraEnabled public String errores{get;set;}
        @AuraEnabled public Map<String,String> valores{get;set;}
    }
    @AuraEnabled
    public static void sincronizarCotizacion(String idOpp,String idCot){
        Opportunity opp=new Opportunity(Id=idOpp);
        opp.SyncedQuoteId=idCot;
        update opp;
    }
    @AuraEnabled
    public static String getQuote(String idOportunidad){
        Integer i=[Select count() from Quote where OpportunityId=:idOportunidad and IsSyncing=true limit 1];
        if(i>0){
            return [Select Id from Quote where OpportunityId=:idOportunidad and IsSyncing=true limit 1].Id;
        }else{
            //Quote quot=new Quote(OpportunityId=idOportunidad);
            //insert quot; 
            return '';
        }
    }
    @AuraEnabled
    public static responseWP getInfo(String idOportunidad){
        responseWP res=new responseWP();
        System.debug('IDOPP:'+idOportunidad);
        //try{
            if(idOportunidad!=null&&idOportunidad!=''){
                res.oportunidad=[Select Id,Name,Familia__c,StageName,SyncedQuoteId,AccountId from Opportunity where Id=:idOportunidad];
                res.cuenta=[Select Id,Name from Account where Id=:res.oportunidad.AccountId];                
                res.cotizaciones=[Select Id,IsSyncing,Name,(Select Id,Product2Id,Product2.IsActive from QuoteLineItems limit 1) from Quote where OpportunityId=:idOportunidad order by CreatedDate ASC];
                List<QuoteLineItem> listQli=new List<QuoteLineItem>();
                Set<String> idsQu=new Set<String>();
                for(Quote q : res.cotizaciones){
                    idsQu.add(q.Id);
                    listQli.addAll(q.QuoteLineItems);
                }
                Map<String,Contrato2__c> mapAdv=new Map<String,Contrato2__c>();
                for(QuoteLineItem ad : [Select Id,QuoteId,(Select Id,electronicPaymentTerm__c,discountDieselMarine__c,discountRiberena__c from Contratos2__r order by CreatedDate DESC limit 1) from QuoteLineItem where QuoteId IN :idsQu]){
                    if(ad.Contratos2__r!=null&&ad.Contratos2__r.size()>0){
                        mapAdv.put(ad.QuoteId, ad.Contratos2__r[0]);
                    }
                }             
                res.contratos=mapAdv;
                
                Map<String,ProductoConcepto__c> mapaPC=new Map<String,ProductoConcepto__c>();
                //List<ProductoConcepto__c> ltemPc;
                for(ProductoConcepto__c pc:[Select Id,Concepto__c,PrecioFinal__c ,PartidaPresupuesto__c from ProductoConcepto__c where PartidaPresupuesto__c IN :listQli]){
                     mapaPC.put(pc.Concepto__c+'-'+pc.PartidaPresupuesto__c,pc);
                }
                res.productosConcepto=mapaPC;
                List<Product2> listProd=[Select Id,isActive,QuoteFields__c,Name,(Select Id,Name,SinEdicion__c,Obligatorio__c,TipoCargo__c,Importe__c,Format__c,Orden__c from Conceptos__r where Activo__c=true order by Orden__c ASC) from Product2 where IsAffiliate__c=true and Family=:res.oportunidad.Familia__c];
                List<Map<String,String>> ltem=new List<Map<String,String>>();
                Map<String,productoWP> mapCon=new Map<String,productoWP>();
                for(Product2 prod : listProd){
                    productoWP tem=new productoWP();
                    tem.listaConceptos=prod.Conceptos__r;
                    tem.camposCotizacion=new List<campoExtendWP>();
                    List<campoWP> lCampos=new List<campoWP>();
                    if(prod.QuoteFields__c!=null){
                        Map<String,campoExtendWP> mapF=getCampos(prod.QuoteFields__c);
                        List<campoExtendWP> lFields=new List<campoExtendWP>();
                        for(campoExtendWP cam:mapF.values()){
                            lFields.add(cam);
                        }
                        tem.camposCotizacion=lFields;
                            
                    }                    
                    mapCon.put(prod.Id, tem);
                    ltem.add(new Map<String,String>{'label'=>prod.Name,'value'=>prod.Id,'IsActive'=>String.valueOf(prod.IsActive)});
                }
                
                res.productos=ltem;
                res.conceptos=mapCon;
            }            
        //}catch(Exception e){
            //System.debug('Error:'+e.getMessage()+', linea:'+e.getLineNumber());
        //}       
        
        return res;
    }
    public class productoWP{
        @AuraEnabled public List<Concepto__c> listaConceptos{get;set;}
        @AuraEnabled public List<campoExtendWP> camposCotizacion{get;set;} 
    }
    
    public class campoWP{
        @AuraEnabled public String api{get;set;}
        @AuraEnabled public String value{get;set;}
    }
    public class responseWP{
        @AuraEnabled public Account cuenta{get;set;}
        @AuraEnabled public Opportunity oportunidad{get;set;}
        @AuraEnabled public Map<String,Contrato2__c> contratos{get;set;}
        @AuraEnabled public List<Quote> cotizaciones{get;set;}
        @AuraEnabled public List<Map<String,String>> productos{get;set;}
        @AuraEnabled public Map<String,productoWP> conceptos{get;set;}
        @AuraEnabled public Map<String,ProductoConcepto__c> productosConcepto{get;set;}               
    }
}