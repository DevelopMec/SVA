public without sharing class AltaContrato_CONT {
    public static Map<String,List<comboWP>> mapProd=new Map<String,List<comboWP>>{
        '30'=>new List<comboWP>{new comboWP('Fisico','Fisico')},
            '30-TC4'=>new List<comboWP>{new comboWP('Virtual','Virtual')},
                '30-B'=>new List<comboWP>{new comboWP('Virtual','Virtual'),new comboWP('Fisico','Fisico')},
                    '31-Tipo_Maquila__c'=>new List<comboWP>{new comboWP('Daimler Mantenimiento','Daimler Mantenimiento')},
                        '31'=>new List<comboWP>{new comboWP('A Demanda','A Demanda'),new comboWP('Semanal','Semanal'),new comboWP('Quincenal','Quincenal'),new comboWP('DIAMES01','DIAMES01'),new comboWP('Especial al 24','Especial al 24')},
                        '33-ComoFactura__c'=>new List<comboWP>{new comboWP('Empresa','Empresa')},
                        '33-Frecuencia_de_Pedido__c'=>new List<comboWP>{new comboWP('Mensual','Mensual')},
                        '33-FrecuenciaFacturacion__c'=>new List<comboWP>{new comboWP('Mensual','Mensual')},
                        '33-Facturacion_Cargos__c'=>new List<comboWP>{new comboWP('Separado del consumo','Separado del consumo')},
                        '33-Facturacion_Plasticos__c'=>new List<comboWP>{new comboWP('Separado del consumo','Separado del consumo')},
                        '33-TipoPago__c'=>new List<comboWP>{new comboWP('Prepago','Prepago')},
                        '33-Item_Contratacion__c'=>new List<comboWP>{new comboWP('Nectar','Nectar')},
                        '33-Package__c'=>new List<comboWP>{new comboWP('Básico','Básico'),new comboWP('Avanzado','Avanzado'),new comboWP('Por comisión','Por comisión')}
    };
    
    @AuraEnabled
    public static plantillaWP getInfoPlantilla(String idQli){
        plantillaWP res = new plantillaWP();
        try{
            string templateId = [Select Id, Product2.ContractTemplate__c from QuoteLineItem where Id =: idQli].Product2.ContractTemplate__c;
            PlantillaContrato__c pl = [Select Id, (Select Id, Name, SectionFields__c, Dependencies__c, RequiredFields__c, DisabledFields__c from ContractSections__r order by Order__c ASC) from PlantillaContrato__c where Id =: templateId];
            String camposStr='';
            String camposObligatorios='';
            String camposDesh='';
            if(pl.ContractSections__r!=null&&pl.ContractSections__r.size()>0){
                for(Integer i=0;i<pl.ContractSections__r.size();i++){
                    if(i<pl.ContractSections__r.size()-1){
                        camposDesh=camposDesh+(pl.ContractSections__r[i].DisabledFields__c!=null ? pl.ContractSections__r[i].DisabledFields__c+';' : '');
                        camposObligatorios=camposObligatorios+(pl.ContractSections__r[i].RequiredFields__c!=null ? pl.ContractSections__r[i].RequiredFields__c+';' : '');
                        camposStr=camposStr+pl.ContractSections__r[i].SectionFields__c+';';
                    }else{
                        camposDesh=camposDesh+(pl.ContractSections__r[i].DisabledFields__c!=null ? pl.ContractSections__r[i].DisabledFields__c+'' : '');
                        camposObligatorios=camposObligatorios+(pl.ContractSections__r[i].RequiredFields__c!=null ? pl.ContractSections__r[i].RequiredFields__c+'' : '');
                        camposStr=camposStr+pl.ContractSections__r[i].SectionFields__c+'';
                    }
                }

                camposStr=camposStr.trim();
                camposObligatorios=camposObligatorios.trim();
                camposDesh=camposDesh.trim();
                String query='Select '+camposStr.replaceAll(';', ',')+',Bank_Account__c,PartidaPresupuesto__r.Product2.ProductCode,PartidaPresupuesto__r.Product2.IDInterno__c,PartidaPresupuesto__r.Quote.Opportunity.Account.CodigoClienteAS400__c from Contrato2__c where PartidaPresupuesto__c=:idQli and PartidaPresupuesto__r.Quote.IsSyncing=true order by CreatedDate DESC limit 1';
                //System.debug('Q::'+query);
                res.query=query;
                Contrato2__c adv=Database.query(query);
                res.adv=adv;
                Map<String,campoWP> mapaCampos=getCampos(adv,camposStr,camposObligatorios,camposDesh);
                List<SeccionesWP> secciones=new List<SeccionesWP>();
                SeccionesWP sec;
                res.dependencias=new Map<String,String>();
                for(ContractSection__c cs : pl.ContractSections__r){
                    res.dependencias.put(cs.Name,cs.Dependencies__c);
                    sec=new SeccionesWP();
                    sec.nombreSeccion=cs.Name;
                    List<campoWP> campos=new List<campoWP>();
                    if(cs.SectionFields__c!=null){
                        for(String field : cs.SectionFields__c.split(';')){
                            if(mapaCampos.containsKey(field)){
                                campos.add(mapaCampos.get(field));
                            }
                        }
                    }                    
                    sec.listaCampos=campos;
                    sec.sizeSecc=campos.size();
                    secciones.add(sec);
                }
                res.seccionesList=secciones;
                res.status=true;
            }else{
                res.status=false;
                res.msj='No hay secciones asociadas a la plantilla';
            }
        }catch(Exception e){
            res.status=false;
            res.msj=e.getMessage()+', linea:'+e.getLineNumber();
        }
        return res;
    }        
    @AuraEnabled
    public static  Map<String,String>  VerificaEstatusEvaluacionCredito(String idOpp){
        Map<String,string> res=new Map<String,string>();
        Opportunity Opp = [SELECT IsApprovedCreditEval__c FROM Opportunity Where Id =: idOpp];
        
        if (Opp.IsApprovedCreditEval__c != 'Si'){
            ProcessInstance[] pi = [Select ID, Status, TargetObject.Name, 
                    (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                    (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance 
                    Where TargetObjectID =: idOpp AND Status = 'Approved'];
            if(pi.size() != 0){
              //Opp.IsApprovedCreditEval__c = 'Si';
              //update Opp;
            }
         }
                                
        res.put('StatusCreditEval',Opp.IsApprovedCreditEval__c);
        return res;
    }
    
    public static Map<String,campoWP> getCampos(Contrato2__c adv,String camposStr,String camposObligatorios,String camposDesh){
        //System.debug('CamposL::'+camposObligatorios);
        List<String> lFields=camposStr.split(';');
        List<String> lFieldsRequired=camposObligatorios.split(';');
        List<String> lFieldsDisabled=camposDesh.split(';');
        //System.debug('CamposL::'+lFieldsRequired);
        Map<String,campoWP> mapaCampos=new Map<String,campoWP>();
        map<string,SObjectField> fList = schema.getGlobalDescribe().get('Contrato2__c').getDescribe().fields.getMap();
        for(string str: fList.keySet()){
            if(lFields.contains(fList.get(str).getDescribe().getName())){
                mapaCampos.put(String.valueOf(fList.get(str).getDescribe().getName()),getMap(fList.get(str).getDescribe(),adv,lFieldsRequired,lFieldsDisabled));
            }
        }
        return mapaCampos;
    }
    public class plantillaWP{
        @AuraEnabled public Contrato2__c adv {get;set;}
        @AuraEnabled public List<SeccionesWP> seccionesList {get;set;}        
        @AuraEnabled public Map<String,String> dependencias {get;set;}
        @AuraEnabled public boolean status {get;set;}
        @AuraEnabled public String msj {get;set;}
        @AuraEnabled public String query {get;set;}
    }
    
    public class SeccionesWP{
        @AuraEnabled public String nombreSeccion{get;set;}
        //@AuraEnabled public List<String> camposObligatorios{get;set;}
        @AuraEnabled public List<campoWP> listaCampos{get;set;}
        @AuraEnabled public Integer sizeSecc{get;set;}
    }

    public static campoWP getMap(Schema.DescribeFieldResult des,Contrato2__c adv,List<String> lFieldsRequired,List<String> lFieldsDisabled){
        return new campoWP(des,adv,lFieldsRequired,lFieldsDisabled,adv.PartidaPresupuesto__r.Product2.ProductCode,adv.PartidaPresupuesto__r.Product2.IDInterno__c,adv.PartidaPresupuesto__r.Quote.Opportunity.Account.CodigoClienteAS400__c);
    }

    public class campoWP{
        @AuraEnabled public String tipo{get;set;}
        @AuraEnabled public String api{get;set;}
        @AuraEnabled public Object value{get;set;}
        @AuraEnabled public String etiqueta{get;set;}
        @AuraEnabled public List<comboWP> listaValores{get;set;}
        @AuraEnabled public boolean requerido{get;set;}
        @AuraEnabled public boolean deshabilitado{get;set;}
        //@AuraEnabled public boolean ocultar{get;set;}
        public campoWP(Schema.DescribeFieldResult des,Contrato2__c adv,List<String> lFieldsRequired,List<String> lFieldsDisabled,String prodCode,String prodGen,String codGr){
            this.tipo=String.valueOf(des.getType());
            this.api=String.valueOf(des.getName());
            this.etiqueta=String.valueOf(des.getLabel());
            if(String.valueOf(des.getType()).equalsIgnoreCase('PICKLIST')||String.valueOf(des.getType()).equalsIgnoreCase('MULTIPICKLIST')){
                if(this.api=='Modo_Transaccion__c'&&mapProd.containsKey(prodCode)){
                    this.listaValores=mapProd.get(prodCode);
                }else if(this.api=='FrecuenciaFacturacion__c'&&mapProd.containsKey(prodCode)&&prodCode=='31'){
                    this.listaValores=mapProd.get(prodCode);
                }else if(this.api=='Tipo_Maquila__c'&&mapProd.containsKey(prodCode+'-Tipo_Maquila__c')&&prodCode=='31'){
                    this.listaValores=mapProd.get(prodCode+'-Tipo_Maquila__c');
                }else if(prodCode=='33' ){
                    for(String field :  mapProd.KeySet()) {
                        if(prodCode+'-'+this.api == field){
                            this.listaValores=mapProd.get(prodCode+'-'+this.api);
                        }
                    }
                    if(this.listaValores == null || this.listaValores.size() == 0 ){
                        this.listaValores=getValores(des.getPicklistValues(),this.api,prodCode);
                    }
                }else{
                    this.listaValores=getValores(des.getPicklistValues(),this.api,prodCode);
                }
            }
            if(lFieldsRequired.contains(String.valueOf(des.getName()))){
                this.requerido=true;
            }else{
                this.requerido=false;
            }
            if(lFieldsDisabled.contains(String.valueOf(des.getName()))){
                this.deshabilitado=true;
            }else{
                this.deshabilitado=false;
            }
            this.value=adv.get(String.valueOf(des.getName()));
        }
    }
    
    public static List<comboWP> getValores(List<Schema.PicklistEntry> ple,String api,String prodCod){
        List<comboWP> res=new List<comboWP>();
        for( Schema.PicklistEntry pickListVal : ple){
            res.add(new comboWP(pickListVal.getValue(),pickListVal.getLabel()));
        }
        return res;
    }
    
    @AuraEnabled
    public static String guardarInfo(Contrato2__c contrato,String filiales, List<String> establishments,boolean esAfiliado){
        System.debug('INICIO GI');
        system.debug(filiales);
        Savepoint sp = Database.setSavepoint();
        try{
            //Database.upsert(datos,false);
            update contrato;
            Contrato2__c con2=[Select Id,PartidaPresupuesto__r.Quote.Opportunity.OwnerId,PartidaPresupuesto__c from Contrato2__c where Id=:contrato.Id];
            if(con2.PartidaPresupuesto__c!=null){
                try{
                    QuoteLineItem qli=[Select Id,(Select Id from Anexos__r) from QuoteLineItem where Id=:con2.PartidaPresupuesto__c];
                    for(Anexo__c an:qli.Anexos__r){
                        an.IdContrato__c=con2.Id;
                    }
                    update qli.Anexos__r;
                }catch(Exception e){}
            }
            saveEstablishments(establishments, contrato.Id);
            if(!esAfiliado){
                List<ContratoFilial__c> lfil=(List<ContratoFilial__c>)JSON.deserialize(filiales, List<ContratoFilial__c>.class);
                generarFiliales(con2,lfil);
            }else{
                 List<Affiliate__c> lAff=(List<Affiliate__c>)JSON.deserialize(filiales, List<Affiliate__c>.class);
                generarAfiliados(con2,lAff);
            }
            /*Map<String,ContratoFilial__c> setEC=getEntidadesCuenta(contrato.Id);
            String oppOwner=con2.PartidaPresupuesto__r.Quote.Opportunity.OwnerId;//[Select Id,PartidaPresupuesto__r.Quote.Opportunity.OwnerId from Contrato2__c where Id=:contrato.Id].PartidaPresupuesto__r.Quote.Opportunity.OwnerId;
            List<ContratoFilial__c> lisF=new List<ContratoFilial__c>();
            List<ContratoFilial__c> lisDel=new List<ContratoFilial__c>();
            Set<String> idsEC=new Set<String>();
            for(ContratoFilial__c ec : filiales){
                idsEC.add(ec.Entidad_Cuenta__c);
                //if(!setEC.containsKey(ec.Entidad_Cuenta__c)){
                ec.Contrato_2__c=contrato.Id;
                ec.OwnerID=oppOwner;
                    lisF.add(ec);
                //}
            }
            for(String ec : setEC.KeySet()){
                if(!idsEC.contains(ec)){
                   lisDel.add(setEC.get(ec)); 
                }
            }
            if(lisDel!=null&&lisDel.size()>0){
                delete lisDel;
            }
            if(lisF!=null&&lisF.size()>0){
                System.debug('VERRR:'+lisF);
                upsert lisF;
            }*/
            return 'exito';
        }catch(Exception e){
            Database.rollback(sp);
            return e.getMessage();
        }
    }
    
    public static void generarFiliales(Contrato2__c contrato,List<ContratoFilial__c> filiales){
        Map<String,ContratoFilial__c> setEC=getEntidadesCuenta(contrato.Id);
        String oppOwner=contrato.PartidaPresupuesto__r.Quote.Opportunity.OwnerId;//[Select Id,PartidaPresupuesto__r.Quote.Opportunity.OwnerId from Contrato2__c where Id=:contrato.Id].PartidaPresupuesto__r.Quote.Opportunity.OwnerId;
        List<ContratoFilial__c> lisF=new List<ContratoFilial__c>();
        List<ContratoFilial__c> lisDel=new List<ContratoFilial__c>();
        Set<String> idsEC=new Set<String>();
        for(ContratoFilial__c ec : filiales){
            idsEC.add(ec.Entidad_Cuenta__c);
            //if(!setEC.containsKey(ec.Entidad_Cuenta__c)){
            ec.Contrato_2__c=contrato.Id;
            ec.OwnerID=oppOwner;
            lisF.add(ec);
            //}
        }
        for(String ec : setEC.KeySet()){
            if(!idsEC.contains(ec)){
                lisDel.add(setEC.get(ec)); 
            }
        }
        if(lisDel!=null&&lisDel.size()>0){
            delete lisDel;
        }
        if(lisF!=null&&lisF.size()>0){
            System.debug('VERRR:'+lisF);
            upsert lisF;
        }
    }
    public static void generarAfiliados(Contrato2__c contrato,List<Affiliate__c> afiliados){  
        System.debug('INFO::'+contrato.PartidaPresupuesto__r.Quote.Opportunity.OwnerId);
        Map<String,Affiliate__c> setEC=getEntidadesCuentaAfiliados(contrato.Id);
        String oppOwner=contrato.PartidaPresupuesto__r.Quote.Opportunity.OwnerId;
        List<Affiliate__c> lisF=new List<Affiliate__c>();
        List<Affiliate__c> lisDel=new List<Affiliate__c>();
        Set<String> idsEC=new Set<String>();
        for(Affiliate__c ec : afiliados){
            idsEC.add(ec.AccountEntity__c);
            ec.Contract_2__c=contrato.Id;
            ec.OwnerID=oppOwner;
            lisF.add(ec);
        }
        for(String ec : setEC.KeySet()){
            if(!idsEC.contains(ec)){
                lisDel.add(setEC.get(ec)); 
            }
        }
        if(lisDel!=null&&lisDel.size()>0){
            delete lisDel;
        }
        if(lisF!=null&&lisF.size()>0){
            upsert lisF;
        }
    }
    
    @AuraEnabled
    public static String guardarInfoAfiliado(Contrato2__c contrato,List<Affiliate__c> filiales, List<String> establishments){
        System.debug('INICIO GI');
        system.debug(filiales);
        Savepoint sp = Database.setSavepoint();
        try{
            //Database.upsert(datos,false);
            update contrato;
            saveEstablishments(establishments, contrato.Id);
            Map<String,Affiliate__c> setEC=getEntidadesCuentaAfiliados(contrato.Id);
            String oppOwner=[Select Id,PartidaPresupuesto__r.Quote.Opportunity.OwnerId from Contrato2__c where Id=:contrato.Id].PartidaPresupuesto__r.Quote.Opportunity.OwnerId;
            List<Affiliate__c> lisF=new List<Affiliate__c>();
            List<Affiliate__c> lisDel=new List<Affiliate__c>();
            Set<String> idsEC=new Set<String>();
            for(Affiliate__c ec : filiales){
                idsEC.add(ec.AccountEntity__c);
                //if(!setEC.containsKey(ec.Entidad_Cuenta__c)){
                ec.Contract_2__c=contrato.Id;
                ec.OwnerID=oppOwner;
                    lisF.add(ec);
                //}
            }
            for(String ec : setEC.KeySet()){
                if(!idsEC.contains(ec)){
                   lisDel.add(setEC.get(ec)); 
                }
            }
            if(lisDel!=null&&lisDel.size()>0){
                delete lisDel;
            }
            if(lisF!=null&&lisF.size()>0){
                System.debug('VERRR:'+lisF);
                upsert lisF;
            }
            return 'exito';
        }catch(Exception e){
            Database.rollback(sp);
            return e.getMessage();
        }
    }
    
    public static Map<String,Affiliate__c> getEntidadesCuentaAfiliados(String idContrato){
        Map<String,Affiliate__c> res=new Map<String,Affiliate__c>();
        for(Affiliate__c cf : [Select Id,AccountEntity__c,AccountEntity__r.Name,AccountEntity__r.EntidadLegal__r.RazonSocial__c,AccountEntity__r.EntidadLegal__r.RecordType.Name,PlatformAdministrator__c from Affiliate__c where Contract_2__c=:IdContrato]){
            res.put(cf.AccountEntity__c,cf);
        }
        return res;
    }
    
    private static void saveEstablishments(List<String> establishmentsIds,String  IdContrato) {
        Map<String,Establishment__C> relatedEstablishments = new Map<String,Establishment__C> ([SELECT Id,Name,Contract__c FROM Establishment__c WHERE Contract__c =: IdContrato OR Id in: establishmentsIds]);
        For(String currentId : relatedEstablishments.keySet()) {
            if(establishmentsIds.contains(currentId)) {
                relatedEstablishments.get(currentId).Contract__c = IdContrato;
            } else {
                relatedEstablishments.get(currentId).Contract__c = null;
            }
        }
        update relatedEstablishments.values();
    }
    
    public static Map<String,ContratoFilial__c> getEntidadesCuenta(String idContrato){
        Map<String,ContratoFilial__c> res=new Map<String,ContratoFilial__c>();
        for(ContratoFilial__c cf : [Select Id,Entidad_Cuenta__c,Entidad_Cuenta__r.Name,Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c,Entidad_Cuenta__r.EntidadLegal__r.RecordType.Name,PlatformAdministrator__c, Entidad_Cuenta__r.EntidadLegal__r.FEA__c, Entidad_Cuenta__r.EntidadLegal__r.DeedDate__c, Entidad_Cuenta__r.EntidadLegal__r.AccountNumber__c, Entidad_Cuenta__r.EntidadLegal__r.KeyNumber__c, Entidad_Cuenta__r.EntidadLegal__r.Geolocation__c, Entidad_Cuenta__r.EntidadLegal__r.DeedNumber__c, Entidad_Cuenta__r.EntidadLegal__r.PersonType__c from ContratoFilial__c where Contrato_2__c=:IdContrato]){
            res.put(cf.Entidad_Cuenta__c,cf);
        }
        return res;
    }
    
    @AuraEnabled
    public static  boolean  validarDocumento(String idOpp,String prodCod){
        String term='%'+prodCod+'%';
        System.debug('term:'+term);
        PersonalizacionTarjetas__mdt pt=[SELECT Id, Label FROM PersonalizacionTarjetas__mdt WHERE CodigoProductos__c LIKE :term LIMIT 1];
        String term2=pt.Label+'%';
        Integer co=[SELECT count() FROM Attachment WHERE ParentId = :idOpp AND Name LIKE :term2 LIMIT 1];
        if(co>0){
            return true;
        }else{
            return false;
        }
    }
    
    @AuraEnabled
    public static infoWP getInfoQli(String idQli){
        infoWP res = new infoWP();
        res.headerData = [
            Select Id, Product2.IsAffiliate__c, Product2.Family, Quote.Opportunity.StageName, Product2.Name,
                   Product2.ProductLogo__c, Product2.No_genera_contrato__c, Quote.Opportunity.Entidad_Cuenta__c,
                   Quote.Opportunity.Entidad_Cuenta__r.EntidadLegal__c, Quote.OpportunityId,Quote.Opportunity.Familia__c,
                   Quote.Opportunity.Name, Quote.Opportunity.Id, Quote.Opportunity.Account.Id, Quote.Opportunity.Account.Name,
                   Product2.SendToSIGLO__c,
                   ContractingItem__c, PaymentMethod__c, OperatingLine__c, ReleasePeriod__c, WarrantyValue__c, CreditDays__c //CEAM:3375
              from QuoteLineItem
             where Id=:idQli
        ];
        res.etapa=res.headerData.Quote.Opportunity.StageName;
        List<Contrato2__c> lisADV=[Select Id,Name,PlatformAdministrator__c,PartidaPresupuesto__r.Product2.IDInterno__c,PartidaPresupuesto__r.Quote.Comision_por_Servicio__c,PartidaPresupuesto__r.Product2.ProductCode,PartidaPresupuesto__r.Quote.Opportunity.Account.CodigoClienteAS400__c,PartidaPresupuesto__r.Quote.Opportunity.Contacto__c,Contacto__c,FiscalAddress__c,ContractDate__c,DireccionFiscal__c,Domiciliation__c,bill__c,paymentTermPaper__c,electronicPaymentTerm__c,billingEmail__c,stationId__c,Entidad_Cuenta__c,IsPaper__c,CuttingDayMon__c,CuttingDayTue__c,CuttingDayWed__c,CuttingDayThu__c,CuttingDayFri__c,CuttingDays__c,webAccessEmail__c,Producto__c,Observaciones__c,IntraseBranch__c,Chain__c, Entidad_Legal__r.FEA__c, Entidad_Cuenta__r.EntidadLegal__r.DeedDate__c, Entidad_Cuenta__r.EntidadLegal__r.AccountNumber__c, Entidad_Cuenta__r.EntidadLegal__r.KeyNumber__c, Entidad_Cuenta__r.EntidadLegal__r.Geolocation__c, Entidad_Cuenta__r.EntidadLegal__r.DeedNumber__c from Contrato2__c where PartidaPresupuesto__c=:idQli order by CreatedDate DESC limit 1];
        if(lisADV!=null&&lisADV.size()==1){
            res.contrato=lisADV[0];        
        }else{
            Contrato2__c contrato=new Contrato2__c(PartidaPresupuesto__c=res.headerData.Id,Entidad_Cuenta__c=res.headerData.Quote.Opportunity.Entidad_Cuenta__c,Entidad_Legal__c=res.headerData.Quote.Opportunity.Entidad_Cuenta__r.EntidadLegal__c);
            insert contrato;
            Contrato2__c contratoTem=[Select Id,Name,PlatformAdministrator__c,PartidaPresupuesto__r.Product2.IDInterno__c,PartidaPresupuesto__r.Product2.ProductCode,PartidaPresupuesto__r.Quote.Comision_por_Servicio__c,PartidaPresupuesto__r.Quote.Opportunity.Account.CodigoClienteAS400__c,PartidaPresupuesto__r.Quote.Opportunity.Contacto__c,Contacto__c,FiscalAddress__c,ContractDate__c,Domiciliation__c,bill__c,paymentTermPaper__c,electronicPaymentTerm__c,DireccionFiscal__c,billingEmail__c,stationId__c,Entidad_Cuenta__c,IsPaper__c,CuttingDayMon__c,CuttingDayTue__c,CuttingDayWed__c,CuttingDayThu__c,CuttingDayFri__c,CuttingDays__c,webAccessEmail__c,Producto__c,Observaciones__c,IntraseBranch__c,Chain__c, Entidad_Legal__r.FEA__c,Entidad_Cuenta__r.EntidadLegal__r.DeedDate__c, Entidad_Cuenta__r.EntidadLegal__r.AccountNumber__c, Entidad_Cuenta__r.EntidadLegal__r.KeyNumber__c, Entidad_Cuenta__r.EntidadLegal__r.Geolocation__c, Entidad_Cuenta__r.EntidadLegal__r.DeedNumber__c from Contrato2__c where Id=:contrato.Id];
            res.contrato=contratoTem;
        }
        if(res.headerData.Product2.IsAffiliate__c){
            res.filiales=getEntidadesCuentaAfiliados(res.contrato.Id);
        }else{
            res.filiales=getEntidadesCuenta(res.contrato.Id);
        }         
        //res.contrato=[Select Id,Name,Contacto__c,DireccionFiscal__c,Entidad_Cuenta__c from Contrato2__c where PartidaPresupuesto__c=:idQli];        
        List<comboWP> lisVal=new List<comboWP>();
        Set<String> idsEC=new Set<String>();
        String idCuenta=res.headerData.Quote.Opportunity.Account.Id;
        String idOpp=res.headerData.Quote.OpportunityId;
        
        res.metodosPago = [SELECT Id, CLABE__c, Name, AccountHolder__c,StandardiziedBankKey__c, Reference__c, Bank__c, RegistrationStatus__c, Cuenta__c FROM BankAccount__c Where Cuenta__c =: idCuenta];
        res.establecimientos = [SELECT Account__c,Name, Gas_Station_Quantity__c , PetrolPumpQuantity__c,idCRE__c,PostalCode__c,Street__c,City__c,Settlement__c,State__c,Population__c,InternalNumber__c,ExternalNumber__c,Bank__r.Name, Id FROM Establishment__c Where Account__c =: idCuenta and EstablishmentStatus__c!='Generado'];
        res.establecimientosGuardados = new Map<Id,Establishment__c>([SELECT Id,Account__c,Name, Gas_Station_Quantity__c,idCRE__c , PetrolPumpQuantity__c,Contract__c,PostalCode__c,Street__c,City__c,Settlement__c,State__c,Population__c,InternalNumber__c,ExternalNumber__c,Bank__r.Name  FROM Establishment__c Where EstablishmentStatus__c!='Generado' and Contract__c =: res.contrato.id AND Account__c =: idCuenta]).keySet();        
        
        res.contactosCuenta=new List<comboWP>();
        for(Contact cont : [Select Id,Name,Funcion__c from Contact where AccountId=:idCuenta]){
            res.contactosCuenta.add(new comboWP(cont.Id,cont.Name));
        }
        res.funcionesContactos=getFuncionesContactos();
        res.contactosGuardados=new Map<String,OpportunityContactRole__c>();
        for(OpportunityContactRole__c oppCR : [SELECT Id, OpportunityId__c, ContactId__c, Role__c FROM OpportunityContactRole__c where OpportunityId__c=:idOpp]){
            res.contactosGuardados.put(oppCR.Role__c,oppCR);
        }
            
        Map<String,EntidadCuenta__c> mapEntidades=new Map<String,EntidadCuenta__c>();
        for(EntidadCuenta__c ec:[Select Id,Name,NombreEL__c,EntidadLegal__r.RecordType.Name,EntidadLegal__r.RazonSocial__c,EntidadLegal__r.PersonType__c from EntidadCuenta__c where Cuenta__c=:idCuenta and EntidadLegal__r.Estatus__c='Completa']){
            System.debug('IDRF::'+ec.NombreEL__c);
            lisVal.add(new comboWP(ec.Id,ec.NombreEL__c));
            mapEntidades.put(ec.Id, ec);
            idsEC.add(ec.Id);
        }
        res.direcciones=[Select Id,Name,NumeroInterior_Tt__c,Calle_Tt__c,NumeroExterior_Tt__c,Colonia_Tt__c,DelegacionMunicipio_Tt__c,Estado_Tt__c,CodigoPostal_Tt__c  from CatalogoDirecciones__c where EntidadLegal__r.Cuenta__c=:idCuenta or CuentaID__c=:idCuenta];
        Map<String,List<comboWP>> mapRepresentantes=new Map<String,List<comboWP>>();
        List<comboWP> lisValRepresentantes;
        for(ContactoEntidad__c ce:[Select Id,Name,Entidad_Cuenta__c,Entidad_Cuenta__r.NombreEL__c,Contacto__c,Contacto__r.Name from ContactoEntidad__c where Entidad_Cuenta__c IN :idsEC]){
            System.debug('IDRF2::'+ce.Entidad_Cuenta__r.NombreEL__c);
            if(mapRepresentantes.containsKey(ce.Entidad_Cuenta__c)){
                lisValRepresentantes=mapRepresentantes.get(ce.Entidad_Cuenta__c);
                lisValRepresentantes.add(new comboWP(ce.Contacto__c,ce.Contacto__r.Name));
                mapRepresentantes.put(ce.Entidad_Cuenta__c,lisValRepresentantes); 
            }else{
                mapRepresentantes.put(ce.Entidad_Cuenta__c,new List<comboWP>{new comboWP(ce.Contacto__c,ce.Contacto__r.Name)}); 
            }
        }
        res.mapaEC=mapEntidades;
        res.representantes=mapRepresentantes;
        res.entidadesCuenta=lisVal;
        res.IdOpp = IdOpp;
        return res;
    }
    
    @AuraEnabled
    public static infoWP getMetodosPago(String idCuenta){
        infoWP res=new infoWP();
        res.metodosPago = [SELECT Id, CLABE__c, Name, AccountHolder__c,StandardiziedBankKey__c, Reference__c, Bank__c, RegistrationStatus__c, Cuenta__c FROM BankAccount__c Where Cuenta__c =: idCuenta];
        return res;
    }
    
    @AuraEnabled
    public static estabRefresWP getEstablecimientosRefresh(String idCuenta,String contratoId){
        estabRefresWP res=new estabRefresWP();
        try{
            res.establecimientos =[SELECT Account__c,Bank__r.Name,Name, Gas_Station_Quantity__c ,PetrolPumpQuantity__c,idCRE__c,PostalCode__c,Street__c,City__c,Settlement__c,State__c,Population__c,InternalNumber__c,ExternalNumber__c,Id FROM Establishment__c Where Account__c =: idCuenta and EstablishmentStatus__c!='Generado'];
            res.establecimientosGuardados = new Map<String,Establishment__c>([SELECT Id,Account__c,Name,Bank__r.Name, Gas_Station_Quantity__c,idCRE__c , PetrolPumpQuantity__c,Contract__c FROM Establishment__c Where Contract__c =: contratoId and EstablishmentStatus__c!='Generado' AND Account__c =: idCuenta]).keySet();            
        }catch(Exception e){
            System.debug('Error:'+e.getMessage()+', Linea:'+e.getLineNumber());
            return res;
        }
        return res;
    }
    
    public without sharing class estabRefresWP{
        @AuraEnabled public Set<String> establecimientosGuardados{get;set;}
        @AuraEnabled public List<Establishment__c> establecimientos{get;set;}
    }
    
    public without sharing class infoWP{
        @AuraEnabled public Map<String,EntidadCuenta__c> mapaEC {get;set;}
        @AuraEnabled public List<CatalogoDirecciones__c> direcciones {get;set;}
        @AuraEnabled public Contrato2__c contrato {get;set;}
        @AuraEnabled public QuoteLineItem headerData {get;set;}
        @AuraEnabled public List<comboWP> entidadesCuenta {get;set;}
        @AuraEnabled public Map<String,List<comboWP>> representantes {get;set;}
        @AuraEnabled public List<comboWP> contactosCuenta {get;set;}
        @AuraEnabled public Map<String,OpportunityContactRole__c> contactosGuardados {get;set;}
        @AuraEnabled public Set<String> funcionesContactos {get;set;}
        @AuraEnabled public Map<String,sObject> filiales {get;set;}
        
        @AuraEnabled public List<BankAccount__c> metodosPago{get;set;}
        @AuraEnabled public List<Establishment__c> establecimientos{get;set;}
        @AuraEnabled public Set<Id> establecimientosGuardados{get;set;}
        
        @AuraEnabled public String IdOpp{get;set;}
        @AuraEnabled public String etapa{get;set;}
    }
    
    public without sharing class comboWP{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
        public comboWP(String val,String lab){
            this.label=lab;
            this.value=val;
        }
    }
    
    public static Set<String> getFuncionesContactos(){
        Set<String> pickListValuesList= new Set<String>();
        Schema.DescribeFieldResult fieldResult = OpportunityContactRole__c.Role__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(pickListVal.getValue()!='Otro'){
                pickListValuesList.add(pickListVal.getValue());
            }
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static Map<String,String> getInfoSendEmail(String idContrato){
        Map<String,String> res=new Map<String,String>();
        try{
            EmailTemplate et=[SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Envio_del_contrato' LIMIT 1];
            res.put('idTemplate',et.Id);
            Contrato2__c adv=[Select Id,Contacto__r.Email,Contacto__c,PartidaPresupuesto__r.Quote.OpportunityId,PartidaPresupuesto__r.Quote.IdPDFContrato__c from Contrato2__c where Id=:idContrato];
            res.put('email',adv.Contacto__r.Email);
            res.put('idCont',adv.Contacto__c);
            res.put('oppId',adv.PartidaPresupuesto__r.Quote.OpportunityId);
            res.put('pdfId',adv.PartidaPresupuesto__r.Quote.IdPDFContrato__c);
        }catch(Exception e){
            System.debug('Error; '+e.getMessage());            
        }
        return res;
    }
    
    @AuraEnabled
    public static List<comboWP> getGruposPrime(String codigoProducto,String grupoNum){
        List<comboWP> res=new List<comboWP>();
        Map<String,WScredentials__c> mapCredenciales=WScredentials__c.getAll();
        WScredentials__c gcTok=mapCredenciales.get('GRPRIMETOK');
        WScredentials__c gcG=mapCredenciales.get('GRPRIME');
        String token='';
        if(Test.isRunningTest()){
            token='lajiudbiubi';
        }else{
            token=AltaCliente_WS.getToken(gcTok.EndPoint__c, gcTok.ClientId__c, gcTok.ClientSecret__c, gcTok.GrantType__c, gcTok.Scope__c);
        }
         
        GetGruposPrime_WS.responseWP grupos=GetGruposPrime_WS.getGrupos(gcG.EndPoint__c, gcG.ClientId__c, gcG.ClientSecret__c,token, grupoNum, codigoProducto);
        System.debug('RES::'+grupos);
        System.debug('RES2::'+JSON.serialize(grupos));
        if(grupos.Status){
            for(PrimeGroupResponse_WP.primeGroupWP pg: grupos.response.data.group_prime_list){
                res.add(new comboWP(String.valueOf(pg.prime_identifier)+'-'+String.valueOf(pg.client_identifier),pg.prime_name));
            }
        }else{
            
        }
        return res;
    }
}