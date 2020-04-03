public without sharing class BuscadorBPfleet_CONT {
    @AuraEnabled
    public static String getRecordTypeBP(String objeto,String nombreApi){
        return [Select Id from RecordType where SobjectType=:objeto and DeveloperName=:nombreApi and IsActive =true].Id;
    }
	@AuraEnabled
    public static infoEnLegWP getDatosBuscar(String rfcBuscar,String nombreEmpresa){
        infoEnLegWP response=new infoEnLegWP();
        List<EntidadCuenta__c> listEl=new List<EntidadCuenta__c>();
        String cadenaBuscar='';
        if(rfcBuscar!=null&&rfcBuscar!=''){
            cadenaBuscar=' RFCEL__c=\''+rfcBuscar+'\'';
        }
        if(nombreEmpresa!=null&&nombreEmpresa!=''){
            if(cadenaBuscar==''){
                cadenaBuscar=' Cuenta__r.Name LIKE \'%'+nombreEmpresa+'%\'';
            }else{
                cadenaBuscar=cadenaBuscar+' or Cuenta__r.Name LIKE \'%'+nombreEmpresa+'%\'';
            }
        }
        Set<String> idEL=new Set<String>();
        for(EntidadCuenta__c el : Database.query('Select Id,Cuenta__r.RecordType.DeveloperName,RFCEL__c,Name,Cuenta__r.Name from EntidadCuenta__c where ('+cadenaBuscar+') limit 20000')){
            if(el.Cuenta__r.RecordType.DeveloperName!='BPfleet'){
                idEL.add(el.RFCEL__c);
            }
            listEl.add(el);
        }
        response.listaEl=listEl;
        Map<String,Map<String,String>> mapGlob=getStatus(idEl);
        response.mapaStatus=mapGlob.get('mapaStatus');
        response.mapaStatusInt=mapGlob.get('mapaStatusInt');
        return response;
    }
    
    public static Map<String,String> generateMap(String msj,String tipo,String titulo){
        Map<String,String> resp=new Map<String,String>();
        resp.put('msj',msj);
        resp.put('tipo',tipo);
        resp.put('titulo',titulo);
        return resp;
    }
    @AuraEnabled
    public static Map<String,String> crearColaboracion(String rfc){
        Map<String,String> response=new Map<String,String>();
        AccountShare colAcc;
        try{            
            EntidadCuenta__c ec =[Select Id,RFCEL__c,Name,Cuenta__c from EntidadCuenta__c where RFCEL__c =:rfc];
            if([Select count() from AccountShare where AccountId=:ec.Cuenta__c and UserOrGroupId=:UserInfo.getUserId() and AccountAccessLevel='Read' and ContactAccessLevel='None' and CaseAccessLevel='None']>0){
                return generateMap('Ya tienes colaboración en la cuenta','warning','Información');
            }
            colAcc=new AccountShare(AccountId=ec.Cuenta__c,UserOrGroupId=UserInfo.getUserId(),AccountAccessLevel='Read',ContactAccessLevel='None',CaseAccessLevel='None',OpportunityAccessLevel='None');
            insert colAcc;
            
            List<Map<String,String>> listOpp=new List<Map<String,String>>();
            listOpp.add(new Map<String,String>{'idCuenta'=>ec.Cuenta__c,'idRfc'=>ec.Id,'idOwner'=>UserInfo.getUserId()});
            List<Opportunity> lOpp=crearOportunidades(listOpp);
            String idOpp=lOpp!=null&&lOpp.size()==1 ? lOpp[0].Id : '';
            response=generateMap('Se le ha dado colaboracion a la cuenta','success','Exito!');
            if(idOpp!=''){
                response.put('idOpp',idOpp);    
            }
            return response;
        }catch(Exception e){
            System.debug('ERROR:'+e.getMessage()+', linea:'+e.getLineNumber());
            if(colAcc!=null&&colAcc.Id!=null){
                delete colAcc;
            }
           return generateMap(e.getMessage(),'error','Error');
        }
    }
    
    public static List<Opportunity> crearOportunidades(List<Map<String,String>> listaOpps){
        System.debug('LOP::'+listaOpps);
        String idRecordType=getRecordTypeBP('Opportunity','BPfleet');
        List<String> lisElIds=new List<String>();
        List<EntidadLegal__c> lisEL=new List<EntidadLegal__c>();
        for(Map<String,String> opp : listaOpps){
            lisElIds.add(opp.get('idRfc'));
        }
        Set<String> idsTem=new Set<String>();
        for(EntidadCuenta__c ec : [Select Id,EntidadLegal__c,EntidadLegal__r.Estatus__c from EntidadCuenta__c where Id IN:lisElIds and EntidadLegal__r.Estatus__c!='Completa']){
            EntidadLegal__c tem=new EntidadLegal__c(Id=ec.EntidadLegal__c);
            tem.Estatus__c='Completa';
            if(!idsTem.contains(tem.Id)){
                idsTem.add(tem.Id);
                lisEL.add(tem);
            }
        }
        update lisEL;
        
        List<Opportunity> listOppsInsert=new List<Opportunity>();
        for(Map<String,String> opp : listaOpps){
            System.debug('MAP2::'+opp);
            listOppsInsert.add(new Opportunity(IdExecutiveNotification__c=opp.get('idNotificacion'),LeadBP__c=opp.get('idLead'),StatusApprovalBPfleet__c='Aprobado',Name='BP',RecordTypeId=idRecordType,AccountId=opp.get('idCuenta'),OwnerId=opp.get('idOwner'),LeadSource=opp.get('origen'),SubOrigen__c=opp.get('subOrigen'),Competidor__c=opp.get('competidor'),Entidad_Cuenta__c=opp.get('idRfc'),CloseDate=Date.today().addMonths(1),StageName='Cotización'));
        }
        Insert listOppsInsert;
        
        for(EntidadLegal__c el : lisEL){
            el.Estatus__c='Incompleta';
        }
        update lisEL;
        
        return listOppsInsert;
    }
    public static Map<String,Map<String,String>> getStatus(Set<String> listRfc){
        Map<String,String> mapAprobadoresSegmento=new Map<String,String>();
        GeneralCatalog__c ca=[Select Id,ApproverBPSmall__c,ApproverBPCorporate__c from GeneralCatalog__c where ApproverBPSmall__c!=null and ApproverBPCorporate__c!=null limit 1];
        mapAprobadoresSegmento.put('small', ca.ApproverBPSmall__c);
        mapAprobadoresSegmento.put('corporate', ca.ApproverBPCorporate__c);
        Set<String> valoresSmall=new Set<String>{'Small-S1','Small-S2','Small-S3'};
            Set<String> valoresCorporate=new Set<String>{'Key','Medium-M1','Medium-M2','Large'};
        Map<String,Map<String,String>> mapResp=new Map<String,Map<String,String>>();
        Map<String,String> mapaCf=new Map<String,String>();
        Map<String,String> mapaStatusInt=new Map<String,String>();
        Map<String,String> mapaAprobadores=new Map<String,String>();
		for(ContratoFilial__c cf : [Select Id,Contrato_2__c, Contrato_2__r.PartidaPresupuesto__c,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.OwnerId,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.ManagerId,Name,Entidad_Cuenta__r.RFCEL__c,Entidad_Cuenta__r.Cuenta__r.Segmento3__c from ContratoFilial__c where Entidad_Cuenta__r.RFCEL__c IN :listRfc and Producto__r.IDInterno__c='30' and Producto__r.ProductCode!='30-B']){
            if(!mapaCf.containsKey(cf.Entidad_Cuenta__r.RFCEL__c)){
                System.debug('Econtro filial::'+cf.Id);
                mapaCf.put(cf.Entidad_Cuenta__r.RFCEL__c,'La empresa es cliente de Ticket Car');
                mapaStatusInt.put(cf.Entidad_Cuenta__r.RFCEL__c,'0');
                if(cf.Contrato_2__c!=null&&cf.Contrato_2__r.PartidaPresupuesto__c!=null&&cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.ManagerId!=null){
                    mapaAprobadores.put(cf.Entidad_Cuenta__r.RFCEL__c,cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.OwnerId+'-'+cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.ManagerId);
                }else if(valoresSmall.contains(cf.Entidad_Cuenta__r.Cuenta__r.Segmento3__c)){
                    mapaAprobadores.put(cf.Entidad_Cuenta__r.RFCEL__c,mapAprobadoresSegmento.get('small')+'-'+mapAprobadoresSegmento.get('small'));
                }else{
                    mapaAprobadores.put(cf.Entidad_Cuenta__r.RFCEL__c,mapAprobadoresSegmento.get('corporate')+'-'+mapAprobadoresSegmento.get('corporate'));
                }
            }
        }
        
        for(Opportunity opp : [Select Id,Name,OwnerId,StageName,Owner.ManagerId,Entidad_Cuenta__r.RFCEL__c from Opportunity where Entidad_Cuenta__r.RFCEL__c IN :listRfc and RecordType.DeveloperName!='BPfleet' and Familia__c='Combustible']){
            if(!mapaCf.containsKey(opp.Entidad_Cuenta__r.RFCEL__c)){
                System.debug('Econtro Opp::'+Opp.Id);
                //mapaCf.put(opp.Entidad_Cuenta__r.RFCEL__c,'El RFC tiene una oportunidad en Eforce en etapa '+opp.StageName);
                mapaCf.put(opp.Entidad_Cuenta__r.RFCEL__c,'La empresa existe y tiene una oportunidad de Ticket Car');                
                mapaStatusInt.put(opp.Entidad_Cuenta__r.RFCEL__c,'0');
                mapaAprobadores.put(opp.Entidad_Cuenta__r.RFCEL__c,opp.OwnerId+'-'+opp.Owner.ManagerId);
                System.debug('Econtro Opp2::'+mapaAprobadores);
            }/*else{
                String e=mapaCf.get(opp.Entidad_Cuenta__r.RFCEL__c);
                mapaCf.put(opp.Entidad_Cuenta__r.RFCEL__c,e+',\n La empresa existe y tiene una oportunidad de Ticket Car');
            }*/
        }
        
        
        for(ContratoFilial__c cf : [Select Id,Contrato_2__c, Contrato_2__r.PartidaPresupuesto__c,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.OwnerId,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.ManagerId,Name,Entidad_Cuenta__r.RFCEL__c,Entidad_Cuenta__r.Cuenta__r.Segmento3__c from ContratoFilial__c where Entidad_Cuenta__r.RFCEL__c IN :listRfc and Producto__r.ProductCode!='30-B']){
            if(!mapaCf.containsKey(cf.Entidad_Cuenta__r.RFCEL__c)){
                System.debug('Econtro filial::'+cf.Id);
                mapaCf.put(cf.Entidad_Cuenta__r.RFCEL__c,'La empresa existe como cliente y compra otros productos de Edenred');
                mapaStatusInt.put(cf.Entidad_Cuenta__r.RFCEL__c,'0');
                if(cf.Contrato_2__c!=null&&cf.Contrato_2__r.PartidaPresupuesto__c!=null&&cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.ManagerId!=null){
                    mapaAprobadores.put(cf.Entidad_Cuenta__r.RFCEL__c,cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.OwnerId+'-'+cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.ManagerId);
                }else if(valoresSmall.contains(cf.Entidad_Cuenta__r.Cuenta__r.Segmento3__c)){
                    mapaAprobadores.put(cf.Entidad_Cuenta__r.RFCEL__c,mapAprobadoresSegmento.get('small')+'-'+mapAprobadoresSegmento.get('small'));
                }else{
                    mapaAprobadores.put(cf.Entidad_Cuenta__r.RFCEL__c,mapAprobadoresSegmento.get('corporate')+'-'+mapAprobadoresSegmento.get('corporate'));
                }
            }/*else{
                String e=mapaCf.get(cf.Entidad_Cuenta__r.RFCEL__c);
                mapaCf.put(cf.Entidad_Cuenta__r.RFCEL__c,e+',\n La empresa existe como cliente y compra otros productos de Edenred');
            }*/
        }
        
        
        for(Opportunity opp : [Select Id,Name,OwnerId,StageName,Owner.ManagerId,Entidad_Cuenta__r.RFCEL__c from Opportunity where Entidad_Cuenta__r.RFCEL__c IN :listRfc and RecordType.DeveloperName!='BPfleet' and Familia__c!='Combustible']){
            if(!mapaCf.containsKey(opp.Entidad_Cuenta__r.RFCEL__c)){
                System.debug('Econtro Opp::'+Opp.Id);
                //mapaCf.put(opp.Entidad_Cuenta__r.RFCEL__c,'El RFC tiene una oportunidad en Eforce en etapa '+opp.StageName);
                mapaCf.put(opp.Entidad_Cuenta__r.RFCEL__c,'La empresa existe como Oportunidad y compra otros productos de Edenred');                
                mapaStatusInt.put(opp.Entidad_Cuenta__r.RFCEL__c,'0');
                mapaAprobadores.put(opp.Entidad_Cuenta__r.RFCEL__c,opp.OwnerId+'-'+opp.Owner.ManagerId);
            }/*else{
                String e=mapaCf.get(opp.Entidad_Cuenta__r.RFCEL__c);
                mapaCf.put(opp.Entidad_Cuenta__r.RFCEL__c,e+',\n La empresa existe como Oportunidad y compra otros productos de Edenred');
            }*/
        }
        
        for(EntidadCuenta__c idEl : [Select Id,RFCEL__c,Cuenta__r.Segmento3__c from EntidadCuenta__c where RFCEL__c IN:listRfc and Cuenta__r.RecordType.DeveloperName!='BPfleet']){
            if(!mapaCf.containsKey(idEl.RFCEL__c)){
                mapaCf.put(idEl.RFCEL__c,'El RFC no es cliente y no cuenta con Oportunidad');
                mapaStatusInt.put(idEl.RFCEL__c,'0');
                if(valoresSmall.contains(idEl.Cuenta__r.Segmento3__c)){
                    mapaAprobadores.put(idEl.RFCEL__c,mapAprobadoresSegmento.get('small')+'-'+mapAprobadoresSegmento.get('small'));
                }else{
                    mapaAprobadores.put(idEl.RFCEL__c,mapAprobadoresSegmento.get('corporate')+'-'+mapAprobadoresSegmento.get('corporate'));
                }
            }            
        }
        
        for(String idEl : listRfc){
            if(!mapaCf.containsKey(idEl)){
                mapaCf.put(idEl,'El RFC no es cliente y no cuenta con Oportunidad');
                mapaStatusInt.put(idEl,'1');
            }
        }
        mapResp.put('mapaStatus', mapaCf);
        mapResp.put('mapaStatusInt', mapaStatusInt);
        mapResp.put('mapaAprobadores', mapaAprobadores);
        System.debug('MAPP::'+mapaAprobadores);
        return mapResp;
    }
    public without sharing class infoEnLegWP{
        @AuraEnabled public List<EntidadCuenta__c> listaEl{get;set;}
        @AuraEnabled public Map<String,String> mapaStatus{get;set;}
        @AuraEnabled public Map<String,String> mapaStatusInt{get;set;}
    }
}