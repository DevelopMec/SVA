/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @change	13/03/2020 Add opp validaction activation or deactivation with OpportunityAndThreatValidation__mdt.
* @change	19/03/2020 creaPostADV method functionality moved to 'Estatus de la Oportundiad' process builder.
* @change	-/03/2020 Add validateRFCSolcionAssignment method [Freeway 2900].
* @change	27/03/2020 Add validateBU method [Freeway 2901].
* @change   30/03/2020 Add ownerBUValidation method [Freeway 2901].
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public without sharing class TriggerOpportunityHandler  extends TriggerHandler{
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    private List<Opportunity> newList;
    private List<Opportunity> oldList;
    public Boolean hasCreatedOT = false;
    
    private List<Opportunity> lisFECGlob;
    private List<QuoteLineItem> lisQliGlob;
    
    public TriggerOpportunityHandler() {
        this.newMap = (Map<Id, Opportunity>) trigger.newMap;
        this.oldMap = (Map<Id, Opportunity>) trigger.oldMap;
        this.newList = (List<Opportunity>) trigger.new;
        this.oldList = (List<Opportunity>) trigger.old; 
        
        lisFECGlob=new List<Opportunity>();
        if(trigger.isUpdate){
            for(Opportunity oportunidad: this.newList){
                if(oportunidad.CloseDate!=this.oldMap.get(oportunidad.Id).closeDate&&oportunidad.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta nueva').getRecordTypeId()){
                    lisFECGlob.add(oportunidad);                
                }
            }
        }
        lisQliGlob=new List<QuoteLineItem>();
        if(lisQliGlob!=null&&lisQliGlob.size()>0){
            lisQliGlob=[Select id,Escalonamiento__c ,Quote.OpportunityId,ServiceDate from QuoteLineItem where Quote.OpportunityId IN :lisFECGlob and Quote.IsSyncing=true];
        }
    }
    
    public override void beforeUpdate() {
        ownerBUValidation(newList, oldMap);
        validacionesBP();
        validarCambiosCampos(newList,oldMap);
        tipificarOportunidad();
        validarActualizacionFechaEC();
        
        guardaUltimoPorcentaje();//Aceptable
        modificarOpotunidad();//Aceptable
        validarCamposOpp(this.newList);//jarellano 14 febrero 2018

        verificaEnviodeCSV( this.newList, this.oldMap, this.newMap ); // calvarez 21 de mayo de 2018
        //verificaEnviodeXML( this.newList, this.oldMap,  this.newMap ); // calvarez 21 de mayo de 2018
        
        List<OpportunityAndThreatValidation__mdt> threatValidation = [SELECT isActive__c FROM OpportunityAndThreatValidation__mdt WHERE DeveloperName = 'Opportunity'];
        if ((!threatValidation.isEmpty() && threatValidation[0].isActive__c == true) || Test.isRunningTest()) {
        	ValidateOpportunityWithRFC(this.newList, this.oldMap); //req 2331 FRWY
        }
        validateRFCSolcionAssignment(newList, oldMap);
    }
    
    public override void beforeInsert(){
        asignarCamposIniciales(newList);
        //validarSemaforos(newList);
        validacionesBP();
        validateBU(newList);
        List<OpportunityAndThreatValidation__mdt> threatValidation = [SELECT isActive__c FROM OpportunityAndThreatValidation__mdt WHERE DeveloperName = 'Opportunity'];
        if ((!threatValidation.isEmpty() && threatValidation[0].isActive__c == true) || Test.isRunningTest()) {
            ValidatepadlockOpportunity(newList); //Valida duplicados de op solo incrementos- cambio FWY 2331 HU
        }
        validateRFCSolcionAssignment(newList, null);
    }
    
    public override void afterUpdate() {
        crearOTImplementacion(this.newList, this.oldMap );
        oppPerdidaOTCancelada(this.newList, this.oldMap );
        validarActualizacionFechaEC();
    }
    
    public void asignarCamposIniciales(List<Opportunity> listOpps){
        for(Opportunity opp: listOpps){
            opp.TimestampCotizacion__c=DateTime.now();
        }            
    }
    public void validarCambiosCampos(List<Opportunity> listOpps,Map<Id, Opportunity> oldMapSec){
        for(Opportunity opp: listOpps){
            if(opp.StageName!=oldMapSec.get(opp.Id).StageName&&opp.StageName=='Cotización'){
                opp.TimestampCotizacion__c=DateTime.now();
            }
        }
    }
    //Req 2331 FWY  
    private static void ValidateOpportunityWithRFC(List<Opportunity> opp, Map<Id, Opportunity> oldMap)
    {
        //validar duplicado           
        List<Opportunity> x = [
            Select AccountId, Entidad_Cuenta__c, StageName, Familia__c, Producto_cotizacion__c, Modify_opportunity__c
              from Opportunity
             where StageName Not In ('Ganada', 'Perdida', 'Planeada')
               and Modify_opportunity__c = true
        ];
          
        for(Opportunity op:opp){
            Opportunity oldOpp = oldMap.get(op.Id);
                      
            //ya fue ingresado pero se cambia el producto  
            if(oldOpp.Entidad_Cuenta__c  != op.Entidad_Cuenta__c){
                for(Opportunity opx : x){
                    if(op.AccountId == opx.AccountId && op.Familia__c == opx.Familia__c && op.Producto_cotizacion__c == opx.Producto_cotizacion__c && op.Entidad_Cuenta__c == opx.Entidad_Cuenta__c){
                        op.AddError ('“Ya existe una oportunidad abierta para ese mismo RFC Solución”');
                    }
                }
            }
        }
    }
    
    //Req 2331 FWY  
    public static void ValidatepadlockOpportunity(List<Opportunity> opp){
        //Obtener recortypes 
        Id incrementoRrcdt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Upselling (Incremento)').getRecordTypeId();
        
        List<Opportunity> o = [
            Select AccountId, Entidad_Cuenta__c, StageName, Familia__c, Producto_cotizacion__c 
              from Opportunity
             where StageName Not In ('Ganada', 'Perdida')
               and RecordTypeId =: incrementoRrcdt
        ];
        
        for(Opportunity op : opp){
            if(op.Entidad_Cuenta__c != null && op.StageName == 'Planeada' && op.RecordTypeId == incrementoRrcdt){
                for(Opportunity opItem : o){
                    if(op.AccountId == opItem.AccountId && op.Familia__c == opItem.Familia__c && op.Entidad_Cuenta__c == opItem.Entidad_Cuenta__c){
                        op.AddError ('“Ya existe una oportunidad abierta para ese mismo RFC Solución”');
                    }
                }
            }
        }
    }

    public static boolean ValidateOpDuplicadedIncremento(Opportunity op)
    {
        boolean result=false;
        List<Opportunity> o=new List<Opportunity>();
        o=[Select Entidad_Cuenta__c,StageName,Familia__c,Producto_cotizacion__c 
                      from Opportunity
                      where AccountId=:op.AccountId 
                      and StageName=:op.StageName
                      and Entidad_Cuenta__c =: op.Entidad_Cuenta__c
                      and Familia__c =: op.Familia__c
                      //and Producto_cotizacion__c =: op.Producto_cotizacion__c
                     and RecordTypeId =: op.RecordTypeId];
        system.debug('result encontrados  '+o.size());
        
         for(Opportunity opp:o){
             if(opp.StageName != 'Ganada' || opp.StageName != 'Perdida')
                if(o.size()>0)
                {
                   result=true; 
                }
        
         }
        system.debug('result duplicate '+result);
        return result;
    }

    /*public static boolean ValidateOpDuplicaded(Opportunity op)
    {
        boolean result=false;
        List<Opportunity> o=new List<Opportunity>();
        o=[Select Entidad_Cuenta__c,StageName,Familia__c,Producto_cotizacion__c 
                      from Opportunity
                      where AccountId=:op.AccountId 
                      and StageName=:op.StageName
                      and Entidad_Cuenta__c =: op.Entidad_Cuenta__c
                      and Familia__c =: op.Familia__c
                      and Producto_cotizacion__c =: op.Producto_cotizacion__c
                     and RecordTypeId =: op.RecordTypeId];
        system.debug('result encontrados  '+o.size());
        
        for(Opportunity opp:o){
            if(opp.StageName != 'Ganada' || opp.StageName != 'Perdida')
               if(o.size()>0)
                {
                   result=true; 
               }
        }  
        
        
        system.debug('result duplicate '+result);
        return result;
    }    */

    public void tipificarOportunidad(){
        Set<String> idOpps=new Set<String>();
        List<Opportunity> listOpsRfc=new List<Opportunity>();
        Set<String> entidadesCuenta=new Set<String>();
        for(Opportunity opp : this.newList){
            if(opp.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('VentaNueva').getRecordTypeId()){
                idOpps.add(opp.Id);
                if(opp.Entidad_Cuenta__c!=null){
                    listOpsRfc.add(opp);
                    entidadesCuenta.add(opp.Entidad_Cuenta__c);
                }
            }
        }
        Map<String,List<ContratoFilial__c>> mapaFilial=new Map<String,List<ContratoFilial__c>>();
        if(listOpsRfc!=null&&listOpsRfc.size()>0){
            for(ContratoFilial__c ec:[Select Id,CodigoAS400__c,Entidad_Cuenta__c,Producto__r.Family,Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId from ContratoFilial__c where Entidad_Cuenta__c IN :entidadesCuenta]){
                if(!mapaFilial.containsKey(ec.Entidad_Cuenta__c)){
                    mapaFilial.put(ec.Entidad_Cuenta__c,new List<ContratoFilial__c>{ec});
                }else{
                    List<ContratoFilial__c> tem=mapaFilial.get(ec.Entidad_Cuenta__c);
                    tem.add(ec);
                    mapaFilial.put(ec.Entidad_Cuenta__c,tem);
                }
            }
        }
        Map<String,String> mapaPedido=new Map<String,String>();
        for(Contrato2__c adv:[Select Id,Frecuencia_de_Pedido__c,PartidaPresupuesto__r.Quote.OpportunityId from Contrato2__c where PartidaPresupuesto__r.Quote.OpportunityId IN :idOpps and PartidaPresupuesto__r.Quote.IsSyncing=true]){
            if(!mapaPedido.containsKey(adv.PartidaPresupuesto__r.Quote.OpportunityId)){
                mapaPedido.put(adv.PartidaPresupuesto__r.Quote.OpportunityId, adv.Frecuencia_de_Pedido__c);
            }
        }
        
        for(Opportunity opp : this.newList){
            if(opp.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('VentaNueva').getRecordTypeId()&&(opp.StageName=='Cotización'||opp.StageName=='Contrato')){
                if(opp.campaniaRelacionada_FText__c!=null&&opp.campaniaRelacionada_FText__c.containsIgnoreCase('Navideños')){
                    opp.TipoVenta__c='Navideños';
                }else if(opp.VentaTradeMarketing_PL__c=='SI'){
                    opp.TipoVenta__c='Trademarketing';
                }else if(mapaPedido.containsKey(opp.Id)&&mapaPedido.get(opp.Id)=='Unico'){
                    opp.TipoVenta__c='Pedido Unico';
                }else if(opp.Entidad_Cuenta__c!=null&&((mapaFilial.containsKey(opp.Entidad_Cuenta__c)&&mapaFilial.get(opp.Entidad_Cuenta__c).size()==0)||!mapaFilial.containsKey(opp.Entidad_Cuenta__c))){
                    opp.TipoVenta__c='Simple';
                }else if(opp.Entidad_Cuenta__c!=null&&mapaFilial.containsKey(opp.Entidad_Cuenta__c)&&esCruzada(mapaFilial.get(opp.Entidad_Cuenta__c),opp.Familia__c,opp.Id)){
                    opp.TipoVenta__c='Cruzada';
                }else if(opp.Entidad_Cuenta__c!=null&&mapaFilial.containsKey(opp.Entidad_Cuenta__c)&&esUpselling(mapaFilial.get(opp.Entidad_Cuenta__c),opp.Familia__c,opp.Id)){
                    opp.TipoVenta__c='Upselling';
                }else{
                    opp.TipoVenta__c='Indefinido';
                }
            }else if(opp.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Incremento').getRecordTypeId()){
                if(opp.campaniaRelacionada_FText__c!=null&&opp.campaniaRelacionada_FText__c.containsIgnoreCase('Navideños')){
                    opp.TipoVenta__c='Navideños';
                }else{
                    opp.TipoVenta__c='Upselling';
                }
            }
        }
    }
    
    public boolean esCruzada(List<ContratoFilial__c> listSub,String familia,String idOp){
        boolean res=true;
        for(ContratoFilial__c cf : listSub){
            System.debug('VALIDA:'+cf.CodigoAS400__c);
            System.debug('VALIDA2:'+cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId);
            if(cf.Producto__r.Family==familia&&cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId!=idOp){
                res=false;
            }
        }
        return res;
    }
    public boolean esUpselling(List<ContratoFilial__c> listSub,String familia,String idOp){
        boolean res=false;
        for(ContratoFilial__c cf : listSub){
            if(cf.Producto__r.Family==familia&&cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId!=idOp){
                res=true;
            }
        }
        return res;
    }
    
    /*public void validarSemaforos(List<Opportunity> listOpps){
        Set<String> idOwners=new Set<String>();
        //Set<String> perfilesDistantCS=new Set<String>{'Ejecutivo Cross Sales'};
        //Set<String> perfilesField=new Set<String>{'Area Metropolitana', 'Ejecutivo Postventa TE', 'Ejecutivo Posventa Area Metropo', 'Ejecutivo Posventa Region Bajio', 'Ejecutivo Posventa Region Centro', 'Ejecutivo Posventa Region Noroeste', 'Ejecutivo Posventa Region Norte', 'Ejecutivo Posventa Region Occ', 'Ejecutivo Posventa Region Sureste', 'Ejecutivo Venta TE', 'Ejecutivo Ventas Area Metropolitana', 'Ejecutivo Ventas Region Bajio', 'Ejecutivo Ventas Region Centro', 'Ejecutivo Ventas Region Noroeste', 'Ejecutivo Ventas Region Norte', 'Ejecutivo Ventas Region Occ', 'Ejecutivo Ventas Region Sureste', 'Ejecutivo Ventas Trademarketing', 'Posventa Area Metropolitana', 'Posventa Region Bajio', 'Posventa Region Gobierno', 'Posventa Region Norte', 'Posventa Region Occidente', 'Posventa Telefonica', 'Region Bajio', 'Region Centro', 'Region Noroeste', 'Region Norte', 'Region Occidente', 'Region Sureste', 'Ventas Area Metropolitana', 'Ventas Region Centro', 'Ventas Region Gobierno', 'Ventas Region Norte', 'Ventas Region Occidente'};
        Set<String> perfilesDistant=new Set<String>{'Ejecutivo de Migracion','Ejecutivo Telesales Outbound','Ejecutivo Telesales Inbound'};
                for(Opportunity l:listOpps){
                    idOwners.add(l.OwnerId);
                }
        Map<String,String> mapaRoles=new Map<String,String>();
        for(User u:[Select Id,UserRole.Name from User where Id IN:idOwners]){
            mapaRoles.put(u.Id, u.UserRole.Name);
        }
        
        for(Opportunity le:listOpps){
            if(Trigger.isUpdate){                
                /if(le.FechaReasignacion__c==null&&perfilesField.contains(mapaRoles.get(le.OwnerId))&&(le.OwnerId!=oldMap.get(le.Id).OwnerId)){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=1;
                }else /
                if(le.FechaReasignacion__c==null&&perfilesDistant.contains(mapaRoles.get(le.OwnerId))&&(le.OwnerId!=oldMap.get(le.Id).OwnerId)){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=10;
                }else if(le.FechaReasignacion__c!=null&&!perfilesDistant.contains(mapaRoles.get(le.OwnerId))&&(le.OwnerId!=oldMap.get(le.Id).OwnerId)){
                    le.FechaReasignacion__c=null;
                    le.NumeroReasignacion__c=null;
                }
                /else if(((le.NumeroReasignacion__c!=null&&le.NumeroReasignacion__c<20)||(le.NumeroReasignacion__c==null))&&perfilesDistantCS.contains(mapaRoles.get(le.OwnerId))&&(le.OwnerId!=oldMap.get(le.Id).OwnerId)){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=20;
                }/
            }else if(Trigger.isInsert){
                /if(le.FechaReasignacion__c==null&&perfilesField.contains(mapaRoles.get(le.OwnerId))){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=1;
                }else /
                if(le.FechaReasignacion__c==null&&perfilesDistant.contains(mapaRoles.get(le.OwnerId))){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=10;
                }/else if(le.FechaReasignacion__c==null&&perfilesDistantCS.contains(mapaRoles.get(le.OwnerId))){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=20;
                }/
            }
        }
    }*/
    
    public void validacionesBP(){
        /************************/
        
        List<Opportunity> listOpps=new List<Opportunity>();
        for(Opportunity opp : newList){
            if((Trigger.isInsert&&opp.StatusApprovalBPfleet__c==null&&opp.Entidad_Cuenta__c!=null&&opp.RecordTypeId!=null&&String.valueOf(opp.RecordTypeId).equalsIgnoreCase(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('BPfleet').getRecordTypeId()))||(Trigger.isUpdate&&opp.StatusApprovalBPfleet__c==null&&opp.Entidad_Cuenta__c!=oldMap.get(opp.Id).Entidad_Cuenta__c&&opp.RecordTypeId!=null&&String.valueOf(opp.RecordTypeId).equalsIgnoreCase(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('BPfleet').getRecordTypeId()))){
                listOpps.add(opp);
            }
        }
        if(listOpps!=null&&listOpps.size()>0){
            Set<String> idsEC=new Set<String>();
            for(Opportunity opp : listOpps){
                idsEC.add(opp.Entidad_Cuenta__c);
            }
            Map<String,String> mapaRfc=new Map<String,String>();
            Set<String> setRfc=new set<String>();
            for(EntidadCuenta__c ec : [Select Id,RFCEL__c from EntidadCuenta__c where Id IN:idsEC]){
                mapaRfc.put(ec.Id, ec.RFCEL__c);
                setRfc.add(ec.RFCEL__c);
            }
            Map<String,Map<String,String>> mapaEl=new Map<String,Map<String,String>>();
            mapaEl=BuscadorBPfleet_CONT.getStatus(setRfc);
            Map<String,String> mapaStatusInt=mapaEl.get('mapaStatusInt');
            Map<String,String> mapaAprobadores=mapaEl.get('mapaAprobadores');
            for(Opportunity opp: listOpps){
                if(mapaStatusInt.containsKey(mapaRfc.get(opp.Entidad_Cuenta__c))){
                    if(mapaStatusInt.get(mapaRfc.get(opp.Entidad_Cuenta__c))=='0'){
                        opp.BPfleetApproval__c=true;                        
                        if(mapaAprobadores.containsKey(mapaRfc.get(opp.Entidad_Cuenta__c))){
                            List<String> datos=mapaAprobadores.get(mapaRfc.get(opp.Entidad_Cuenta__c)).split('-');
                            opp.Approver__c=datos[0]!=''&&datos[1]!=null ? datos[1] : null;
                            opp.IdExecutiveNotification__c=datos[0]!=''&&datos[0]!=null ? datos[0] : '';
                        }
                    }else if(mapaStatusInt.get(mapaRfc.get(opp.Entidad_Cuenta__c))=='1'){
                        opp.BPfleetApproval__c=false;
                        opp.StatusApprovalBPfleet__c=null;
                    } 
                }else if(opp.Entidad_Cuenta__c==null){
                    opp.BPfleetApproval__c=false;
                    opp.StatusApprovalBPfleet__c=null;
                } 
            }
        }
        
        Set<String> idsEC=new Set<String>();
        for(Opportunity opp : newList){
            idsEC.add(opp.Entidad_Cuenta__c);
        }
        Map<String,String> mapaRfc=new Map<String,String>();
        for(EntidadCuenta__c ec : [Select Id,RFCEL__c from EntidadCuenta__c where Id IN:idsEC]){
            mapaRfc.put(ec.Id, ec.RFCEL__c);
        }
        Set<String> setElOpp=new Set<String>();
        Map<String,validacionBpWP> setOwnerBP=new Map<String,validacionBpWP>();
        for(Opportunity opp : [Select Id,Owner.Profile.Name,Entidad_Cuenta__r.RFCEL__c from Opportunity where Id IN :trigger.New]){
            if((Trigger.isInsert&&opp.Entidad_Cuenta__c!=null)||(Trigger.isUpdate&&opp.Entidad_Cuenta__c!=newMap.get(opp.Id).Entidad_Cuenta__c)){
                validacionBpWP tem=new validacionBpWP();
                tem.perfil=opp.Owner.Profile.Name;
                tem.rfc=mapaRfc.get(newMap.get(opp.Id).Entidad_Cuenta__c);
                setOwnerBP.put(opp.Id,tem);
            }
        }
        Map<String,Map<String,String>> mapaEl=new Map<String,Map<String,String>>();
        for(Opportunity oportunidad: this.newList){
            if(setOwnerBP.containsKey(oportunidad.Id)&&setOwnerBP.get(oportunidad.Id).perfil=='BPfleet Sales'){
                if(setOwnerBP.get(oportunidad.Id).rfc!=null){
                    setElOpp.add(setOwnerBP.get(oportunidad.Id).rfc);   
                }                
            }
        }
        if(setElOpp!=null&&setElOpp.size()>0){
            mapaEl=BuscadorBPfleet_CONT.getStatus(setElOpp);
            Map<String,String> mapaStatusInt=mapaEl.get('mapaStatusInt');
            Map<String,String> mapaAprobadores=mapaEl.get('mapaAprobadores');
            for(Opportunity oportunidad: this.newList){
                if(oportunidad.Entidad_Cuenta__c!=null&&mapaStatusInt.containsKey(setOwnerBP.get(oportunidad.Id).rfc)){
                    if(mapaStatusInt.get(setOwnerBP.get(oportunidad.Id).rfc)=='0'){
                        oportunidad.BPfleetApproval__c=true;
                        if(mapaAprobadores.containsKey(setOwnerBP.get(oportunidad.Id).rfc)){
                            List<String> datos=mapaAprobadores.get(setOwnerBP.get(oportunidad.Id).rfc).split('-');
                            oportunidad.Approver__c=datos[1]!=''&&datos[1]!=null ? datos[1] : null;
                            oportunidad.IdExecutiveNotification__c=datos[0]!=''&&datos[0]!=null ? datos[0] : '';
                        }
                    }
                }
            }
        }
        /************************/
    }

    public class validacionBpWP{
        public String perfil{get;set;}
        public String rfc{get;set;}
    }
    
    public void validarActualizacionFechaEC(){
        List<Opportunity> lisFEC=lisFECGlob;        
        if(lisFEC.size()>0){
            Map<String,QuoteLineItem> mapaEscalonamientos=new Map<String,QuoteLineItem>();
            Map<String,List<QuoteLineItem>> mapaQli=new Map<String,List<QuoteLineItem>>();
            for(QuoteLineItem qli:lisQliGlob){
                List<QuoteLineItem> lq;
                if(qli.Escalonamiento__c==null){
                    mapaEscalonamientos.put(qli.Quote.OpportunityId,qli);
                }
                if(!mapaQli.containsKey(qli.Quote.OpportunityId)){
                    lq=new List<QuoteLineItem>();
                    lq.add(qli);
                    mapaQli.put(qli.Quote.OpportunityId,lq);
                }else{
                    lq=mapaQli.get(qli.Quote.OpportunityId);
                    System.debug('VER::'+lq);
                    lq.add(qli);
                    mapaQli.put(qli.Quote.OpportunityId,lq);
                }
            }
            if(trigger.isBefore&&trigger.isUpdate){
                for(Opportunity op: lisFEC){
                    if((op.StageName=='Perdida'||op.StageName=='Ganada')&&op.StageName==oldMap.get(op.Id).StageName){
                        op.addError('No se puede modificar la fecha estimada de compra o el volumen de emision cuando la Oportunidad está cerrada');
                    }else{
                        if(mapaQli.containsKey(op.Id)){
                            for(QuoteLineItem qli:mapaQli.get(op.Id)){
                                if(mapaQli.get(op.Id).size()>1&&op.closeDate==qli.ServiceDate&&qli.Escalonamiento__c!=null){
                                    op.addError('La fecha estimada de compra ya pertenece a un escalonamiento:'+qli.Id);
                                }
                                if(mapaQli.get(op.Id).size()>1&&qli.Escalonamiento__c!=null&&op.CloseDate>qli.ServiceDate){
                                    op.addError('La fecha estimada de compra no puede ser mayor a '+qli.ServiceDate);
                                }                            
                            }
                        }
                    }
                }
            }
            if(trigger.isAfter&&trigger.isUpdate){
                List<QuoteLineItem> listQLIup=new List<QuoteLineItem>();
                for(QuoteLineItem qli: mapaEscalonamientos.values()){
                    if(qli.ServiceDate!=newMap.get(qli.Quote.OpportunityId).closeDate){
                        qli.ServiceDate=newMap.get(qli.Quote.OpportunityId).closeDate;
                        listQLIup.add(qli); 
                    }
                }
                //System.debug('VERQLI::'+JSON.serialize(mapaEscalonamientos.values()));
                if(listQLIup!=null&&listQLIup.size()>0){
                   update listQLIup; 
                }
                //update mapaEscalonamientos.values();
            }
        }
    }
    
    public void guardaUltimoPorcentaje(){
        for(Opportunity oportunidad: this.newList){
            if(oportunidad.isClosed && oportunidad.StageName == 'Perdida'){
                oportunidad.PorcentajeProbabilidadPerdida__c = oportunidad.Probability;
            }
        }
    }
    
    public void modificarOpotunidad() {
        Negocio__c negocio = Negocio__c.getInstance();
        Boolean modifica = negocio.ModificarOportunidadCerrada__c;
        for(Opportunity oportunidad: this.newList){
            if((oportunidad.isClosed || oportunidad.isWon ) && (oportunidad.StageName == 'Perdida' || oportunidad.StageName == 'Ganada') && !modifica){
                oportunidad.addError('No puede modificar la oportunidad en esta etapa');
            }
        }
    }

    /*calvarez - Agregar campos personalizados a productos de la oportunidad 18 enero 2017*/
    /*public void actualizaCantidadTarjetas(List<Opportunity> opps) {
        Map<Id, Opportunity> oppUpdate = new Map<Id, Opportunity>();
        Set<Id> qliPrincipal = new Set<Id>();
        Set<Id> idsQuotes = new Set<Id>();
        for(Opportunity opp: opps) {
            if(opp.SyncedQuoteId != null && oldMap.get(opp.Id).SyncedQuoteId != opp.SyncedQuoteId && !oppUpdate.containsKey(opp.SyncedQuoteId)) {
                oppUpdate.put(opp.SyncedQuoteId, new Opportunity(Id = opp.Id, CantidadTarjetas__c = 0));
            }
            if(opp.SyncedQuoteId != null) {
                idsQuotes.add(opp.SyncedQuoteId);
            }
        }

        if(oppUpdate != null && oppUpdate.keySet().size() > 0) {
            List<QuoteLineItem> quotesl = [SELECT Id, CantidadTarjetas__c, Quote.OpportunityId, Etapa__c FROM QuoteLineItem WHERE Escalonamiento1__c = false AND QuoteId IN: oppUpdate.keySet()];
            Map<Id, Integer> counters = new Map<Id, Integer>();

            for(QuoteLineItem qli: quotesl) {
                if(oppUpdate.containsKey(qli.QuoteId)) {
                    oppUpdate.get(qli.QuoteId).CantidadTarjetas__c += qli.CantidadTarjetas__c;
                }   
            }
            for(Opportunity opp: oppUpdate.values()) {
                if(newMap != null && newMap.containsKey(opp.Id)) {
                    newMap.get(opp.Id).CantidadTarjetas__c = opp.CantidadTarjetas__c;
                }
            }

        }
        if(idsQuotes != null && idsQuotes.size() > 0) {
            for(QuoteLineItem qli : [SELECT Id FROM QuoteLineItem WHERE Escalonamiento__c = null AND QuoteId IN: idsQuotes]) {
                qliPrincipal.add(qli.Id);
            }
        }

        //agrega: calvarez: 23 feb 2017: Actualizar estatus de Oportunidad
        for(List<Opportunity> lista: [SELECT Id, StageName, (SELECT Id, Name FROM Quotes), (SELECT Id, Etapa__c, ServiceDate, PartidaPresupuesto__c FROM OpportunityLineItems ORDER BY ServiceDate DESC) FROM Opportunity WHERE Id IN: newMap.keySet()]) {
            for(Opportunity opp: lista) {
                if(newMap.containsKey(opp.Id)) {
                    if(opp.Quotes.size() == 0) {
                        // comenta calvarez 21 11 2017 => Monoroducto newMap.get(opp.Id).StageName = 'Inactiva';
                    } else if(opp.OpportunityLineItems.size() > 0) {

                        //newMap.get(opp.Id).CloseDate = opp.OpportunityLineItems[0].ServiceDate;

                        //Integer numCot = opp.OpportunityLineItems.size();
                        Integer numCot = 0;
                        Integer cerradosGanados = 0;
                        //No contar los escalonamientos hijo
                        for(OpportunityLineItem oli: opp.OpportunityLineItems) {
                            if(qliPrincipal.contains((Id)oli.PartidaPresupuesto__c)) {
                                numCot++;
                                if(oli.Etapa__c == 'Ganada' || oli.Etapa__c == 'Perdida') {
                                    cerradosGanados++;
                                }
                            }
                            // if(oli.Etapa__c == 'Ganada' || oli.Etapa__c == 'Perdida') {
                            //     cerradosGanados++;
                            // }
                        }
                        // comenta calvarez 21 11 2017 => Monoroducto newMap.get(opp.Id).StageName = numCot > 0 && cerradosGanados == numCot ? 'Cerrada' : 'Activa';
                    }
                }
            }
        }
    }*/
    
    private void validarDirEntrega(List<Opportunity> newList){
        //DVM Para validar que tenga una dirección de entrega asociada
        //Arma un mapa con las oportunidades que pasan a ADV
            Map<Id,Opportunity> oppsAltaCliente = new Map<Id,Opportunity>();
            for(Opportunity opp : newList){ if( opp.StageName == 'Alta de cliente' ){ oppsAltaCliente.put(opp.Id, opp); } }
            
            if(oppsAltaCliente.size() > 0){
                //Arma un Mapa de contratos identificados por el ID de OPP
                List<Contrato2__c> contratosRel = new List<Contrato2__c>([SELECT Id,EtapaContrato__c, DireccionesAuxiliares__c, PartidaPresupuesto__r.Quote.OpportunityId FROM Contrato2__c WHERE PartidaPresupuesto__r.Quote.OpportunityId = :oppsAltaCliente.keySet()]);
                Map<Id,Contrato2__c> mapContratos = new Map<Id,Contrato2__c>();
                for(Contrato2__c contrato : contratosRel){ mapContratos.put(contrato.PartidaPresupuesto__r.Quote.OpportunityId, contrato); }
                
                //Arma un mapa de objeto intermedio de direcciones identificados por el ID de la opp
                Set<Contrato_Direccion__c> dirEntregaRel = new Set<Contrato_Direccion__c>([SELECT Id, ContratoId__r.PartidaPresupuesto__r.Quote.OpportunityId FROM Contrato_Direccion__c WHERE ContratoId__r.PartidaPresupuesto__r.Quote.OpportunityId =: oppsAltaCliente.keySet()]);
                Map<Id,Contrato_Direccion__c> mapDirEntrega = new Map<Id,Contrato_Direccion__c>();
                for(Contrato_Direccion__c dirEntrega : dirEntregaRel){ mapDirEntrega.put(dirEntrega.ContratoId__r.PartidaPresupuesto__r.Quote.OpportunityId, dirEntrega);}    
                
                for(Opportunity oppADV : oppsAltaCliente.Values()){
                    System.debug('========');
                    //System.debug('mapDirEntrega  ' + mapDirEntrega.containsKey(oppADV.Id));
                    //System.debug('mapContratos  ' + mapContratos.get(oppADV.Id).DireccionesAuxiliares__c);
                    if(mapContratos.containsKey(oppADV.Id) && mapContratos.get(oppADV.Id).EtapaContrato__c != 'Finalizado'){
                        oppADV.addError('Necesita Finalizar el contrato para poder pasar a ADV');
                    }
                    if(!mapDirEntrega.containsKey(oppADV.Id) && mapContratos.containsKey(oppADV.Id) && mapContratos.get(oppADV.Id).DireccionesAuxiliares__c == false ){
                        oppADV.addError('Necesita agregar una Dirección de Entrega para poder pasar a ADV');
                    }
                }
            }
        }
    
    /*corrección de codificación Rodolfo Ricardo Sánchez 15-Mayo-18*/
    public void validarCamposOpp(List<Opportunity> newList){
        
        List<Id> oppIdList = new List<Id>();
        List<Id> oppIdListContrato = new List<Id>();
        List<Opportunity> oppFilterList = new List<Opportunity>();
        //Map<Id,User> subsidiaryUsersMap = new Map<Id,User>([Select Id,ProfileId FROM User Where ProfileId in:[Select Id From Profile Where Name = :system.label.subsidiary]]);
        //Obtengo Id's de las oportunidades entrantes
        for(Opportunity opp : newList){
            if( opp.StageName == 'Alta de cliente' ) {
                oppIdList.add(opp.Id);
            }else if( opp.StageName == 'Contrato' ) {
                oppIdListContrato.add(opp.Id);
            }
        }
        
        validarDirEntrega(newList);
                
        System.debug('oppIdList:'+oppIdList);
        
        /* old version Attachment @calvarez 9/08/2018  //Obtengo los Attachments de dichas oportunidades
        List<Attachment> attList = [SELECT Name, Id, ParentId FROM Attachment WHERE ParentId IN: oppIdList];
        Map<String,List<Attachment>> mapOppAttch = new Map<String,List<Attachment>>();

        //Se crea un mapa en el cual se asignaran unicamente las Oportunidades que tengan Attachments
        for( Attachment at : attList ) {
            if( oppIdList.indexOf(at.ParentId) != -1 ) {
                Integer index = oppIdList.indexOf(at.ParentId);
                String oppId = oppIdList.get(index);
                if( !mapOppAttch.containsKey(oppId) ) {
                    mapOppAttch.put(oppId, new List<Attachment>());
                    mapOppAttch.get(oppId).add(at);
                } else {
                    mapOppAttch.get(oppId).add(at);
                }
            }
        }*/

        //Obtengo los Attachments de dichas oportunidades
        Map<String, List<ContentDocumentLink>> mapOppAttch = new Map<String, List<ContentDocumentLink>>();

        if(oppIdList != null && oppIdList.size() > 0 ) {
            List<ContentDocumentLink> attList = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: oppIdList];

            //Se crea un mapa en el cual se asignaran unicamente las Oportunidades que tengan Attachments
            for( ContentDocumentLink at : attList ) {
                if( oppIdList.indexOf(at.LinkedEntityId) != -1 ) {
                    Integer index = oppIdList.indexOf(at.LinkedEntityId);
                    String oppId = oppIdList.get(index);
                    if( !mapOppAttch.containsKey(oppId) ) {
                        mapOppAttch.put(oppId, new List<ContentDocumentLink>());
                        mapOppAttch.get(oppId).add(at);

                    } else {
                        mapOppAttch.get(oppId).add(at);
                    }
                }
            }
        }

        /*************/    
        Set<String> oppSinMetodoPago=new Set<String>();
        if(oppIdListContrato!=null&&oppIdListContrato.size()>0){
            List<Quote> lstQuoteContrato = [SELECT Id, OpportunityId, (SELECT Id,FormaPago__c FROM QuoteLineItems WHERE Escalonamiento__c = null limit 1) FROM Quote WHERE OpportunityId IN: oppIdListContrato AND IsSyncing = true ];
            for( Quote q : lstQuoteContrato ) {
                for(QuoteLineItem qli:q.QuoteLineItems){
                    if(qli.FormaPago__c==null&&!oppSinMetodoPago.contains(q.OpportunityId)){
                        oppSinMetodoPago.add(q.OpportunityId);
                    }
                }
            }
        }
        /************/
        
        for( Opportunity opp : newList ) {
           if( opp.StageName.startsWithIgnoreCase('Alta de cliente') ) {
                if( !mapOppAttch.containsKey(opp.id) ) {
                    opp.addError('No puede cambiar la etapa de la oportunidad debido a que debe adjuntar los documentos correspondientes');
                }
           }else if(opp.StageName == 'Contrato'){// && !subsidiaryUsersMap.containsKey(opp.OwnerId) 
               if(oppSinMetodoPago.contains(opp.Id)){
                   opp.addError('Debe agregar un metodo de pago en la cotización para poder pasar a Contrato');
               }
           }
        }   

        //Valida Si existe en el mapa Oportunidades Con Attachments
        if( mapOppAttch.size() > 0 ) {
            System.debug('mapOppAttch:'+mapOppAttch);
            //Filtrar unicamente las oportunidades con Attachments
            for( Opportunity oppF : newList ) {
                if( mapOppAttch.containsKey(oppF.Id) ) {
                    oppFilterList.add(oppF);
                }
            }

            System.debug('oppFilterList:'+oppFilterList);
            //Se buscan los contratos asociados a Las Oportunidades con Attachments
            List<Contrato2__c> lstContrato = [SELECT Id, AsignacionContrato__c,PartidaPresupuesto__c,PartidaPresupuesto__r.Product2.Name, PartidaPresupuesto__r.Product2.ProductCode,PartidaPresupuesto__r.Quote.Opportunity.Id from Contrato2__c WHERE PartidaPresupuesto__r.Quote.Opportunity.Id IN: mapOppAttch.keySet() ];
            Map<String,List<Contrato2__c>> mapOppContract = new Map<String,List<Contrato2__c>>();

            //Se filtran los contrantos que pertenezcan a dichas oportunidades
            for( Contrato2__c lC : lstContrato ) {
                if( oppIdList.indexOf(lC.PartidaPresupuesto__r.Quote.Opportunity.Id) != -1 ) {
                    Integer index2 = oppIdList.indexOf(lC.PartidaPresupuesto__r.Quote.Opportunity.Id);
                    String oppId2 = oppIdList.get(index2);
                    if( !mapOppContract.containsKey(oppId2) ) {
                        mapOppContract.put(oppId2, new List<Contrato2__c>());
                        mapOppContract.get(oppId2).add(lC);
                    } else {
                        mapOppContract.get(oppId2).add(lC);
                    }
                }
            }

            System.debug('mapOppContract:' + mapOppContract);

            //Se Obtienen los QuoteLineItems de la Cotizacion Sincronizada de Las Oportunidades Con Contratos
            //DYAMPI
            List<Quote> lstQuote =new List<Quote>();
            if(oppIdList!=null&&oppIdList.size()>0){
                lstQuote=[SELECT Id, OpportunityId, (SELECT Id,Product2.ProductCode FROM QuoteLineItems WHERE Escalonamiento__c = null) FROM Quote WHERE OpportunityId IN: oppIdList AND IsSyncing = true ];
            }
            Map<String,String> mapOppQLI = new Map<String,String>();
            //Se filtra Oportunidad con su QuoteLineItem principal
            for( Quote q : lstQuote ) {
                if( !mapOppQLI.containsKey(q.OpportunityId) ) {
                    //System.debug('ProductCode:'+q.QuoteLineItems[0].Product2.ProductCode);
                    Integer index3 = oppIdList.indexOf(q.OpportunityId);
                    String oppId3 = oppIdList.get(index3);
                    if( !mapOppQLI.containsKey(oppId3) ) {
                        mapOppQLI.put(oppId3, q.QuoteLineItems[0].Id);
                    }
                }
            }
            System.debug('lstQuote:'+lstQuote);
            System.debug('mapOppQLI:'+mapOppQLI);

            //Se crea un Mapa  , en el cual se comparan los contratos de la Oportunidad con el QuoteLineItem principal y así conocer el contrato principal de dicha oportunidad.
            Map<String,Contrato2__c> mapOppContractQLI = new Map<String,Contrato2__c>();
            Set<String> oppSet = new Set<String>();
            oppSet = mapOppQLI.keySet();

            for( String oppoID : oppSet ) {
                if( mapOppContract.containsKey(oppoID) ) {
                    for( Contrato2__c contOpp : mapOppContract.get(oppoID) ) {
                        if( contOpp.PartidaPresupuesto__c == mapOppQLI.get(oppoID) ) {
                            if( !mapOppContractQLI.containsKey(oppoID) ) {
                                mapOppContractQLI.put(oppoID, contOpp);
                            }                               
                        }
                    }
                }
            }

            System.debug('mapOppContractQLI:'+mapOppContractQLI);
            //User usuarioTrue = 
            //User usuarioFalse = 
            //Se recorren las Oportunidades Filtradas
            List<Contrato2__c> listaContratos = new List<Contrato2__c>();
			//List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
            for( Opportunity opp : oppFilterList ) {
                try {
                    if( opp.StageName == 'Alta de cliente' ) {
                        Boolean isContratofirmado = false;
                        Boolean isIdDelCliente = false;
                        Boolean isRegistroPatronal = false;
                        
                        /* old version Attachment 9/08/2018 @ calvarez for( Attachment att : mapOppAttch.get(opp.Id) ) {
                            System.debug('Attachment:'+att.Name);
                            if( att.Name.indexOf('Contrato o Propuesta firmados') != -1 ) {
                                isContratofirmado = true;

                            } else if(att.Name.indexOf('Id. de Cliente') != -1 ) {
                                isIdDelCliente = true;
                                
                            } else if( att.Name.indexOf('Registro Patronal') != -1 ) {
                                isRegistroPatronal = true;                                    
                            }
                        }*/

                        for( ContentDocumentLink att : mapOppAttch.get(opp.Id) ) {
                            // System.debug('Attachment:'+att.Name);
                            if( att.ContentDocument != null && String.isNotBlank(att.ContentDocument.Title) ) {
                                if( att.ContentDocument.Title.indexOf('Contrato o Propuesta firmados') != -1 ) {
                                    isContratofirmado = true;

                                } else if( att.ContentDocument.Title.indexOf('Id. de Cliente') != -1 ) {
                                    isIdDelCliente = true;
                                    
                                } else if( att.ContentDocument.Title.indexOf('Registro Patronal') != -1 ) {
                                    isRegistroPatronal = true;                                    
                                }
                            }
                        }

                        if( opp.Producto_cotizacion__c != null && !(opp.Producto_cotizacion__c.startsWithIgnoreCase('32') || opp.Producto_cotizacion__c.startsWithIgnoreCase('12')) ) {
                            isRegistroPatronal = true;
                        }

                        if( isRegistroPatronal ) {
                            if( isIdDelCliente ) {
                                if( isContratofirmado ) {
                                    if( mapOppContractQLI.get(opp.Id) != null ) {  
                                        Contrato2__c contrato = mapOppContractQLI.get(opp.Id);
                                        System.debug('Contrato a checar:'+contrato);
                                        if( String.isNotEmpty(contrato.AsignacionContrato__c) ) {
                                            //falta validar productos OPAM
                                            User usuarioADV;
                                            if( contrato.PartidaPresupuesto__r.Product2.ProductCode == '60-M' || contrato.PartidaPresupuesto__r.Product2.ProductCode == '60-P' || contrato.PartidaPresupuesto__r.Product2.ProductCode == '60-D' || contrato.PartidaPresupuesto__r.Product2.ProductCode == '52-C' || contrato.PartidaPresupuesto__r.Product2.ProductCode == '62-C' || contrato.PartidaPresupuesto__r.Product2.ProductCode == '69-C' ) {
                                                //System.debug('usuarioTrue:'+usuarioTrue);
                                                usuarioADV = getEjecutioADVTRUE('Ejecutivo_de_Administracion_de_Ventas', 'Clientes OPAM', 'ADV_OPAM');
                                            } else {
                                                //System.debug('usuarioFalse:'+usuarioFalse);
                                                usuarioADV = getEjecutioADVTRUE('Ejecutivo_de_Administracion_de_Ventas', 'Clientes Edenred', 'ADV_Edenred'); //Original manda a llamar al método comentado getEjecutioADVFALSE;
    
                                            }
    
                                            if( usuarioADV != null ) {
                                                Contrato2__c contratoAux = new Contrato2__c();
    
                                                if( String.isEmpty(opp.IdEjecutivoADV__c) || String.isEmpty(opp.EjecutivoADV__c ) ) {
                                                    //for(User usr : lstUser){
                                                    //  if(opp.)
                                                    //}
                                                    System.debug('opp.IdEjecutivoADV__c:'+opp.IdEjecutivoADV__c);
                                                    System.debug('opp.EjecutivoADV__c:'+opp.EjecutivoADV__c);
                                                    System.debug('usuarioADV.Id:'+usuarioADV.Id);
                                                    System.debug('usuarioADV.Name:'+usuarioADV.Name);
                                                    opp.IdEjecutivoADV__c = usuarioADV.Id;
                                                    contrato.Ejecutivo_ADV__c = usuarioADV.Id;

                                                    contratoAux.Ejecutivo_ADV__c = usuarioADV.Id;
                                                    contratoAux.Id = contrato.Id;

                                                    //contrato.OwnerId = usuarioADV.Id; //DVM: Si quisieran que se asigne el owner al ejecutivo ADV entonces descomenten esta linea
                                                    opp.EjecutivoADV__c = usuarioADV.Name;
                                                }
                                                
                                                System.debug('NOEmpty opp.NumeroAltaCliente__c:'+opp.NumeroAltaCliente__c);
                                                if( String.isEmpty(opp.NumeroAltaCliente__c) ) {
                                                    System.debug('Empty opp.NumeroAltaCliente__c:'+opp.NumeroAltaCliente__c);
                                                    System.debug('contrato.AsignacionContrato__c:'+contrato.AsignacionContrato__c);
                                                    opp.NumeroAltaCliente__c = contrato.AsignacionContrato__c;
                                                }
                                                if( String.isEmpty(String.valueOf(opp.FechaInicioADV__c)) ) {
                                                    opp.FechaInicioADV__c = system.now();
                                                }
                                                if( opp.Estatus__c != 'Cerrada' ) {                        
                                                    opp.Estatus__c = 'Iniciada';
                                                    // update contrato;
                                                    if( contratoAux.Id != null ) {
                                                        listaContratos.add(contratoAux);
                                                    }
                                                    
                                                    //DYAMPI
                                                    opp.FechaUltimaActividad__c=DateTime.now();
                                                    /*if(opp.StageName == 'Alta de cliente'&&opp.StageName!=oldMap.get(opp.Id).StageName){
                                                        batchInputs.add(creaPostADV(contrato, opp));
                                                    }*/
                                                }
                                            } else {
                                                opp.addError('No puede cambiar la etapa de la oportunidad por que no se encuentran usuarios con el perfil Administración de Ventas');
                                            }
                                        } else {
                                            opp.addError('No puede cambiar la etapa de la oportunidad por que el contarto no tiene un numero de asignacion ADV');
                                 
                                        }
                                    } else {
                                        opp.addError('No puede cambiar la etapa de la oportunidad por que no tiene un contrato asociado');
                           
                                    }
                                } else {
                                    opp.addError('No puede cambiar la etapa de la oportunidad por que no tiene un Contrato Finalizado Firmado');
                                }
                            } else {
                                opp.addError('No puede cambiar la etapa de la oportunidad por que no tiene un Id. del Cliente');
                            }
                        } else {
                            opp.addError('No puede cambiar la etapa de la oportunidad por que no ha adjuntado el Registro Patronal');
                        }
                    }
                } catch( Exception e ) {
                    opp.addError('Error al cambiar oportunidad a Alta Cliente: ' + e + e.getLineNumber());
                }
            }

            if( listaContratos != null && listaContratos.size() > 0 ) {
                update listaContratos;
            }
            /*if( batchInputs != null && batchInputs.size() > 0 ) {
                System.debug('CHATTERPOSTS:'+batchInputs.size());
				ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
            }*/
        }
                           
    }  
    
    public User getEjecutioADVTRUE( String role, String filtroAsignacion, String contador){
        List<User> asignarAlEjecutivo = [SELECT ID, Name FROM User WHERE UserRole.DeveloperName = :role AND FiltroAsignacion_MSPL__c INCLUDES (:filtroAsignacion) AND IsActive = true ORDER BY CreatedDate ASC];
        
        ContadorRegistros_CS__c contadorRegistro = ContadorRegistros_CS__c.getValues(contador);
        Decimal auxiliar = contadorRegistro.NumeroRegistro__c;
        
        auxiliar += 1;
        
        contadorRegistro.NumeroRegistro__c = auxiliar;
        update contadorRegistro;
        return asignarAlEjecutivo.get(Math.mod(auxiliar.intValue() , asignarAlEjecutivo.size()));
    }
    
    /*public User getEjecutioADVTRUE(){

        List<User> usuarios = [SELECT Id,Name From User WHERE Name = 'Juan Oswaldo Espinoza Rivas'];

        if(usuarios != null && usuarios.size() > 0){

            return usuarios[0];

        }else{

            return null;

        }       
    }*/

    /*public User getEjecutioADVFALSE(){

        List<User> lstUser = [SELECT Id, Profile.Name, Name FROM User WHERE Profile.Name ='Ejecutivo de ADV' AND IsActive = true ];
        List<Opportunity> lstOpportunity = [SELECT Id,Name,IdEjecutivoADV__c,EjecutivoADV__c FROM Opportunity WHERE StageName = 'Alta de cliente' ];
        
        System.debug('getEjecutioADVFALSE lstUser:'+lstUser);

        if(lstUser != null && lstUser.size() > 0){

            for(User usr : lstUser){

                Boolean userAssign = false;

                for(Opportunity opp: lstOpportunity){

                    if(opp.IdEjecutivoADV__c == usr.Id){

                        userAssign = true;

                    }
                }

                if(userAssign == false){
                    System.debug('userAssign == false: '+usr);
                    return usr;

                }   
            }

            Decimal random = math.random() * lstUser.size()-1;
            return lstUser.get(random.intValue());

        }else{

            User usuario = new User();
            return usuario;

        }
    }*/
    
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 15/03/2018
        * @description Método que verifica si la oportunidad cambió de x StageName a 'Alta de cliente', si cumple, sevgeneran los CSV´s correspondientes y se envían por email
    */
    public void verificaEnviodeCSV( List<Opportunity> opps, Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap ) {
        // ermx-notificacionescrm@edenred.com, edher.arizmendi@edenred.com,Edher.BARRETO@edenred.com
        if( opps != null && opps.size() > 0 && oldMap != null ) {
            Set<Id> setIdsOpp = new Set<Id>();
            Negocio__c negocio = Negocio__c.getOrgDefaults();
            Set<String> setCodigos = new Set<String>();
            if( negocio != null && negocio.PantallaIntermediaCodigos__c != null ) {
                for( String codigo: negocio.PantallaIntermediaCodigos__c.split(',')) {
                    setCodigos.add(codigo);
                }
            }


            for( Opportunity opp: opps ) {
                // Verificar que la oportunidad está cambiando a StageName = 'Alta de cliente'
                if( oldMap.containsKey(opp.Id) && opp.StageName != null && opp.StageName == 'Alta de cliente' && oldMap.get(opp.Id).StageName != 'Alta de cliente' ) {
                //if( opp.Id == '0065B000009un7UQAQ' ) {
                    setIdsOpp.add( opp.Id );
                }
            }

            if( setIdsOpp != null && setIdsOpp.size() > 0 ) {
                Set<Id> setIdsQuote = new Set<Id>();
                List<Opportunity> listOppSynced = [ SELECT Id, SyncedQuoteId FROM Opportunity WHERE Id IN: setIdsOpp AND SyncedQuoteId != null AND EnvioCSVOPAM__c = false ];
                for( Opportunity opp: listOppSynced ){
                    setIdsQuote.add( opp.SyncedQuoteId );
                }

                if( setIdsQuote != null && setIdsQuote.size() > 0 ) {
                    // Obtener los Productos de la Oportunidad
                    Map<Id, Id> mapIdsOppQli = new Map<Id, Id>();
                    List<QuoteLineItem> listQlis = [ SELECT Id, Product2Id, Product2.ProductCode, Quote.OpportunityId FROM QuoteLineItem WHERE Escalonamiento__c = null AND QuoteId IN: setIdsQuote ];
                    for( QuoteLineItem qli : listQlis ) {
                        if( qli.Product2.ProductCode != null && setCodigos.contains(qli.Product2.ProductCode) ) {
                            mapIdsOppQli.put(qli.Quote.OpportunityId, qli.Id);
                        }
                    }

                    if( mapIdsOppQli != null && mapIdsOppQli.values().size() > 0 ) {
                       
                        List<Opportunity> listOpp2Update = new List<Opportunity>();
                        // System.debug('mapIdsOppQli: ' + mapIdsOppQli);
                        for( Id idOpp : mapIdsOppQli.keySet() ) {
                            new GenerarCSVSController(idOpp, mapIdsOppQli.get(idOpp)).GenerarArchivos();                       
                            newMap.get(idOpp).EnvioCSVOPAM__c = true;                         
                            newMap.get(idOpp).IdCuentaOPAM__c = String.valueOf(negocio.IdCuentaOPAM__c).replace('.0','');
                            newMap.get(idOpp).IdOportunidadOPAMNegocio__c =String.valueOf(negocio.IdOportunidadOPAM__c).replace('.0','');
                            negocio.IdCuentaOPAM__c = negocio.IdCuentaOPAM__c + 1;
                            negocio.IdOportunidadOPAM__c = negocio.IdOportunidadOPAM__c + 1;
                        }

                        update negocio;
                        System.debug('Después de actualizar de nuevo');
                    }


                }
            }
        }
    }

    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 15/03/2018
        * @description Método que verifica si la oportunidad cambió de x StageName a 'Alta de cliente', si cumple, se genera el XML y se envía por email
    */
   /* public void verificaEnviodeXML( List<Opportunity> opps, Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap ) {

        Set<Id> setIdsOpp = new Set<Id>();
        for( Opportunity opp: opps ) {
            // Verificar que la oportunidad está cambiando a StageName = 'Alta de cliente'
            if( oldMap.containsKey(opp.Id) && opp.StageName != null && opp.StageName == 'Alta de cliente' && oldMap.get(opp.Id).StageName != 'Alta de cliente' ) {
            // if( opp.Id == '0065B000009yJh6QAE' ) {
                setIdsOpp.add( opp.Id );
            }
        }

        if( setIdsOpp != null && setIdsOpp.size() > 0 ) {
            Set<Id> setIdsQuote = new Set<Id>();
            Set<Id> setIdsQuoteLineItem = new Set<Id>();
            List<Opportunity> listOppSynced = [ SELECT Id, SyncedQuoteId FROM Opportunity WHERE Id IN: setIdsOpp AND SyncedQuoteId != null AND EnvioXMLTC30__c = false ];
            for( Opportunity opp: listOppSynced ){
                setIdsQuote.add( opp.SyncedQuoteId );
            }

            List<QuoteLineItem> listQlis = [ SELECT Id, Product2Id, Product2.ProductCode, Quote.OpportunityId FROM QuoteLineItem WHERE Escalonamiento__c = null AND QuoteId IN: setIdsQuote AND Product2.ProductCode = '30' ];
            for( QuoteLineItem qli : listQlis ) {
                setIdsQuoteLineItem.add( qli.Id );
            }

            List<Contrato2__c> listContratos = [SELECT Id, PartidaPresupuesto__c, PartidaPresupuesto__r.Quote.OpportunityId FROM Contrato2__c WHERE PartidaPresupuesto__c =: setIdsQuoteLineItem];
            if( listContratos.size() > 0 ) {
                for( Contrato2__c cont: listContratos ) {
                    GenerarXMLController ctrlXML = new GenerarXMLController( cont.PartidaPresupuesto__r.Quote.OpportunityId, cont.Id );
                }
                List<Opportunity> listOpps = new List<Opportunity>();
                for( Id idOpp : setIdsOpp ) {
                    // listOpps.add( new Opportunity (Id = idOpp, EnvioXMLTC30__c = true));
                    newMap.get(idOpp).EnvioXMLTC30__c = true;
                }
                // update listOpps;
            }

        }
    }*/

    /**
        * @author sreyna@ctconsulting.com.mx
        * @date 04/04/2018
        * @description Método que verifica si la oportunidad cambió de x StageName a 'Implementación' y de ser así crea las Ordenes de trabajo correspondientes.
    */
    public void crearOTImplementacion( List<Opportunity> opps, Map<Id, Opportunity> oldMap ) {
        //Inicialización de un set de Id para almacenar las oportunidades que cambiaron de etapa a Implementación y que se crearán OTs
        Set<Id> oppsId = new Set<Id>();
        Set<Id> oppsIdValidado = new Set<Id>();
        Set<Id> syncedQuotes = new Set<Id>();
        Set<Id> qlitems = new Set<Id>();
        Set<Id> idsContrato = new Set<Id>();
        Set<Id> idsProducto2 = new Set<Id>();
        
        //Creación de la lista de OTs a guardar al final del analisis
        List<WorkOrder> ordenesTrabajo = new List<WorkOrder>();
        Map<Id,Product2> productosQLI = new Map<Id,Product2>();
        
        //Loop para verificar de la lista de Opp entrante
        for(Opportunity opp: opps ) {
            if(oldMap.containsKey(opp.Id) && opp.StageName != null && opp.StageName == 'Implementación' && oldMap.get(opp.Id).StageName != 'Implementación' ){
                oppsId.add(opp.Id);
            }
        }

        if(oppsId!=null&&oppsId.size()>0){
            // INICIO Obtener Id de Attachment de Personalización de tarjetas
            // Map<String, String> mapCodigoProducto = new Map<String, String>();
            Map<String, String> mapCodigoPersonaliza = new Map<String, String>();
            Map<Id, String> mapOppLabel = new Map<Id, String>();
            Map<Id, Id> mapOppAttach = new Map<Id, Id>();
            for( PersonalizacionTarjetas__mdt pt : [ SELECT Id, Label, CodigoProductos__c FROM PersonalizacionTarjetas__mdt ]) {
                if( pt.CodigoProductos__c != null ) {
                    for( String codigo : pt.CodigoProductos__c.split(',') ) {
                        mapCodigoPersonaliza.put(codigo, pt.Label);
                    }
                }
            }
            for( Opportunity opp: [SELECT Id, Codigo_Producto_cotizacion__c FROM Opportunity WHERE Id IN: oppsId ]) {
                // mapCodigoProducto.put(opp.Id, opp.Codigo_Producto_cotizacion__c );
                if( mapCodigoPersonaliza.containsKey(opp.Codigo_Producto_cotizacion__c) ) {
                    mapOppLabel.put(opp.Id, mapCodigoPersonaliza.get(opp.Codigo_Producto_cotizacion__c));
                }
            }
            
            // Nota: Personalización de tarjetas aún está en Attachment 9/08/2018 @calvarez
            for( Attachment att: [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN: oppsId ] ) {
                if( String.isNotBlank(att.Name) && mapOppLabel.containsKey(att.ParentId) && att.Name.toLowerCase().contains(mapOppLabel.get(att.ParentId).toLowerCase())  ) {
                    mapOppAttach.put(att.ParentId, att.Id);
                }
            }
            
            // System.debug('\n\nmapCodigoPersonaliza: ' + mapCodigoPersonaliza);
            // System.debug('mapOppLabel: ' + mapOppLabel);
            // System.debug('mapOppAttach: ' + mapOppAttach + '\n\n');
            
            // FIN Obtener Id de Attachment de Personalización de tarjetas
            //Lista que contiene lar ordenes de trabajo relacionadas a las opp entrantes
            List<WorkOrder> ordenesOpp = [Select Id ,Oportunidad__c from WorkOrder where Oportunidad__c in : oppsId];
            
            //Loop para verificar de la lista de Opp entrante cuales de ellas cambiaron de etapa y asignarlas al set de Ids
            for(Opportunity opp: opps ) {
                
                
                // Verificar que la oportunidad está cambiando a StageName = 'Implementación'
                if(oldMap.containsKey(opp.Id) && opp.StageName != null && opp.StageName == 'Implementación' && oldMap.get(opp.Id).StageName != 'Implementación' ) {
                    Boolean flagOpp = false;
                    for(WorkOrder wop : ordenesOpp){
                        if(wop.Oportunidad__c == opp.Id){
                            flagOpp = true;
                        }
                    }
                    if(flagOpp == false){
                        oppsIdValidado.add(opp.Id);
                    }
                }
            }
            
            if(oppsIdValidado.size() > 0){
                
                //Loop para obtener los Id de las cotizaciones sincronizadas y en base a estás obtener las partidas relacionadas
                for(Opportunity oportunidad : [Select SyncedQuoteId from Opportunity where Id in: oppsIdValidado]){
                    System.debug(oportunidad.SyncedQuoteId);
                    syncedQuotes.add(oportunidad.SyncedQuoteId);
                }
                
                //Loop para obtener los Id de las partidas de las cotizaciones sincronizadas y en base a estás obtener los contratos y código AS400
                for(QuoteLineItem qli :  [Select Id, Product2Id  from QuoteLineItem where QuoteId in: syncedQuotes]){
                    System.debug(qli);
                    qlitems.add(qli.Id);
                    idsProducto2.add(qli.Product2Id);
                }
                
                //Se obtiene la información de los productos2 para poder determinar el estatus y otras reglas de los productos
                for(Product2 prod2 : [SELECT Id, ProductCode, OT_Pedidos_Small__c, OT_Estatus_Pedido_Fondos__c FROM Product2 Where Id in: idsProducto2]){
                    System.debug(prod2);
                    if(!productosQLI.containsKey(prod2.Id)){
                        productosQLI.put(prod2.Id, prod2);
                    }
                }
                
                List<String> productosWOrder = new List<String>();
                /*Map<String,String> oppProductoWO = new Map<String,String>();*/
                Map<Id,String> oppProducto = new Map<Id,String>();
                
                //Se instancian las OT principales y se agregan a la lista de OTs a guardar, se agrega el Id de Contrato a un set de Ids para la posterior busqueda de filiales
                for(Contrato2__c contratos : [Select Id, Name,TipoPedidoTarjetas__c, Entidad_Legal__c, CodigoAs400__c, PartidaPresupuesto__r.Quote.OpportunityId,Personalizacion_de_Tarjetas__c, PartidaPresupuesto__r.Quote.Opportunity.AccountId, PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c,PartidaPresupuesto__r.Product2Id,PartidaPresupuesto__r.Product2.ProductCode from Contrato2__c where PartidaPresupuesto__c in: qlitems]){
                    if(contratos.CodigoAs400__c != null && contratos.PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c != '1' && contratos.PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c != '3' && contratos.PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c != '9'){
                        WorkOrder ot = new WorkOrder();
                        ot.FechaInicio__c = System.today();
                        ot.StartDate = System.today();
                        ot.OT_Principal__c = true;
                        
                        
                        //Se valida el campo OT_Estatus_Pedido_Fondos__c para determinar si la OT requiere pasar por la etapa de Pedido de tarjetas y capacitación o si se va directo a Pedido
                        if(productosQLI.get(contratos.PartidaPresupuesto__r.Product2Id).OT_Estatus_Pedido_Fondos__c == true){
                            ot.Estatus__c = 'Pedido';
                        }else{
                            ot.Estatus__c = 'Pedido de tarjetas';
                        }
                        ot.TipoPedidoTarjetas__c=contratos.TipoPedidoTarjetas__c;
                        ot.IDProductoOpp__c = contratos.PartidaPresupuesto__r.Product2Id;
                        ot.Oportunidad__c = contratos.PartidaPresupuesto__r.Quote.OpportunityId;
                        ot.AccountId = contratos.PartidaPresupuesto__r.Quote.Opportunity.AccountId;
                        ot.Entidad_Legal__c = contratos.Entidad_Legal__c;
                        //Se agrega el rastreo del nombre de la relación
                        ot.NombreEL__c = contratos.Name;
                        ot.Codigo_AS400__c = contratos.CodigoAs400__c;
                        ot.Personalizacion_de_tarjetas__c = contratos.Personalizacion_de_Tarjetas__c;
                        ot.LayoutPersonalizacionTarjetas__c = '';
                        
                        if(ot.Personalizacion_de_tarjetas__c == true){
                            // System.debug('mapOppAttach: ' + mapOppAttach + ' ot: ' + ot);
                            ot.LayoutPersonalizacionTarjetas__c = Test.isRunningTest() ? '' : (mapOppAttach.isEmpty() ? '' : (mapOppAttach.containsKey(ot.Oportunidad__c) ? mapOppAttach.get(ot.Oportunidad__c) : ''));
                                /*oppProductoWO.put(ot.NombreEL__c,contratos.PartidaPresupuesto__r.Product2.ProductCode);*/
                                oppProducto.put(ot.Oportunidad__c,contratos.PartidaPresupuesto__r.Product2.ProductCode);
                            
                            
                            if(productosWOrder.size() == 0){
                                productosWOrder.add(contratos.PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c);
                            }
                            
                        }
                        ordenesTrabajo.add(ot);
                        idsContrato.add(contratos.Id);
                    }
                }
                
                //Mapa de asignación de OTs y COntratosFilial
                Map<Id,WorkOrder> mapaOTFilial = new Map<Id,WorkOrder>();
                
                //Se buscan los filiales para generar para estos una OT de acuerdo a los contratos encontrados
                for(ContratoFilial__c contratosFilial : [SELECT Id,Entidad_Cuenta__r.EntidadLegal__c , Name, Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.AccountId,Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c   ,Contrato_2__r.Personalizacion_de_Tarjetas__c, Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId, Contrato_2__r.PartidaPresupuesto__r.Product2Id,Contrato_2__r.PartidaPresupuesto__r.Product2.ProductCode, CodigoAS400__c FROM ContratoFilial__c where isPrime__c=false AND Contrato_2__c in: idsContrato]){
                    if(contratosFilial.CodigoAs400__c != null){
                        WorkOrder ot = new WorkOrder();
                        ot.FechaInicio__c = System.today();
                        ot.StartDate = System.today();
                        ot.OT_Principal__c = false;
                        ot.Entidad_Legal__c=contratosFilial.Entidad_Cuenta__r.EntidadLegal__c;
                        //Se valida el campo OT_Estatus_Pedido_Fondos__c para determinar si la OT requiere pasar por la etapa de Pedido de tarjetas y capacitación o si se va directo a Pedido
                        if(productosQLI.get(contratosFilial.Contrato_2__r.PartidaPresupuesto__r.Product2Id).OT_Estatus_Pedido_Fondos__c == true){
                            ot.Estatus__c = 'Pedido';
                        }else{
                            ot.Estatus__c = 'Pedido de tarjetas';
                        }
                        ot.IDProductoOpp__c = contratosFilial.Contrato_2__r.PartidaPresupuesto__r.Product2Id;
                        ot.Oportunidad__c = contratosFilial.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId;
                        ot.AccountId = contratosFilial.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.AccountId;
                        //Se agrega el nombre del contrato filial
                        ot.NombreEL__c = contratosFilial.Name;
                        ot.Codigo_AS400__c = contratosFilial.CodigoAs400__c;
                        ot.Personalizacion_de_Tarjetas__c = contratosFilial.Contrato_2__r.Personalizacion_de_Tarjetas__c;
                        ot.LayoutPersonalizacionTarjetas__c = '';
                        
                        if(ot.Personalizacion_de_tarjetas__c == true){
                            /*oppProductoWO.put(ot.NombreEL__c,contratosFilial.Contrato_2__r.PartidaPresupuesto__r.Product2.ProductCode);*/
                            ot.LayoutPersonalizacionTarjetas__c = Test.isRunningTest() ? '' : (mapOppAttach.containsKey(ot.Oportunidad__c) ? mapOppAttach.get(ot.Oportunidad__c) : '');
                                oppProducto.put(ot.Oportunidad__c,contratosFilial.Contrato_2__r.PartidaPresupuesto__r.Product2.ProductCode);
                            
                            if(productosWOrder.size() == 0){
                                productosWOrder.add(contratosFilial.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c);
                            }
                        }
                        ordenesTrabajo.add(ot);
                        mapaOTFilial.put(contratosFilial.Id, ot);
                    }
                }
                
                
                Map<String,String> mapPersonalizacionTarjetas = new Map<String,String>();
                
                
                if(ordenesTrabajo.size()>0){
                    System.debug(ordenesTrabajo);
                    
                    
                    
                    //        if(productosWOrder.size() > 0){
                    
                    //         List<PersonalizacionTarjetas__mdt> pT = [SELECT Id, Label,CodigoProductos__c FROM PersonalizacionTarjetas__mdt];
                    
                    //         if(pT.size() > 0){
                    
                    //             for(PersonalizacionTarjetas__mdt perT : pT){
                    //                 List<String> codigos = perT.CodigoProductos__c.split(',');
                    //                 for(String codigo : codigos){
                    //                     mapPersonalizacionTarjetas.put(codigo,perT.Label);
                    //                 }
                    //             }
                    //         }
                    
                    //         System.debug('mapPersonalizacionTarjetas:'+mapPersonalizacionTarjetas);
                    
                    
                    //         Set<String> codigoOpp = new Set<String>(); 
                    
                    //         for(Opportunity opp: opps ) {
                    //             String codigo = oppProducto.get(opp.Id);
                    
                    // codigoOpp.add(mapPersonalizacionTarjetas.get(codigo));       
                    //   }
                    
                    //   System.debug('codigoOpp:'+codigoOpp);
                    
                    
                    //         for(Attachment atta :[SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN: oppsId AND Name IN: codigoOpp]){
                    //             System.debug('Attachments :'+atta);
                    //             for(WorkOrder wO : ordenesTrabajo){
                    //                 if(wO.Oportunidad__c == atta.ParentId ){
                    //                     System.debug('Entro if LayoutPersonalizacionTarjetas__c:'+atta.Id);
                    //                     wO.LayoutPersonalizacionTarjetas__c = '../servlet/servlet.FileDownload?file='+atta.Id;
                    //                 }
                    //             }
                    //         }
                    
                    //        }
                    if(!Test.isRunningTest()) {
                        insert ordenesTrabajo;
                    }
                }
                
                List<ContratoFilial__c> updateContratoOt = new List<ContratoFilial__c>();
                for(Id idCFilial : mapaOTFilial.keySet()){
                    ContratoFilial__c conOt = new ContratoFilial__c();
                    conOt.Id=idCFilial;
                    conOt.Orden_de_trabajo__c = mapaOTFilial.get(idCFilial).Id;
                    updateContratoOt.add(conOt);
                }
                
                //Actualización de contratos filiales con relacion a la OT
                If(updateContratoOt.size()>0){
                    System.debug(updateContratoOt);
                    update updateContratoOt;
                }
                
            }
        }
    }

    public void oppPerdidaOTCancelada(List<Opportunity> opps, Map<Id, Opportunity> oldMap){
        //Inicialización de un set de Id para almacenar las oportunidades que cambiaron de etapa Perdidas
        Set<Id> oppPerdidads = new Set<Id>();

        System.debug('Opportunidas:'+opps);

        if(opps.size() > 0){

            //Loop para verificar de la lista de Opp entrante cuales de ellas cambiaron de etapa y asignarlas al set de Ids
            for(Opportunity opp : opps ) {
                // Verificar que la oportunidad está cambiando a StageName = 'Implementación'
                if(opp.isClosed && opp.StageName == 'Perdida' ) {
                    oppPerdidads.add(opp.Id);
                }
            }

            System.debug('oppPerdidads:'+oppPerdidads);
            
            //DYAMPI
            if(oppPerdidads.size()>0){
                //Lista que contiene lar ordenes de trabajo relacionadas a las opp entrantes
                List<WorkOrder> ordenesOpp = [Select Id ,Oportunidad__c,Estatus__c,Motivo_del_estatus__c from WorkOrder where Oportunidad__c in : oppPerdidads AND Estatus__c != 'Concluida'];                              
                
                System.debug('OrdenesOpp:'+ordenesOpp);
                
                //Se asigna el estatus Cancelada a la WO
                if(ordenesOpp.size() > 0){
                    for(WorkOrder wO : ordenesOpp){
                        wO.Estatus__c = 'Cancelada';
                        wO.Motivo_del_estatus__c = 'Otros';
                    }
                    
                    //Se actualizan las WO
                    try{
                        
                        System.debug('WO estatus:'+ordenesOpp);
                        update ordenesOpp;                  
                        
                    }catch(Exception e){
                        System.debug('Exception Cause oppPerdidaOTCancelada status: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
                    }
                }
            }
        }
    }

   //Edenred
	// 12/03/2020 Freway 2324. Method creaTareaADV is replaced by creaPostADV.
    /*public ConnectApi.BatchInput creaPostADV( Contrato2__c contrato, Opportunity opp ) {
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        mentionSegmentInput.id = opp.IdEjecutivoADV__c;
        messageBodyInput.messageSegments.add(mentionSegmentInput);
        
        textSegmentInput.text = ' Se te ha asignado un Folio para Alta de Cliente: '+ opp.NumeroAltaCliente__c + '. Esta publicación esta relacionada a la oportunidad que se le ha asignado, favor de revisarla para el proceso de Alta de cliente.';
        messageBodyInput.messageSegments.add(textSegmentInput);
        
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = contrato.Id;
        
        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
        return batchInput;*/
        //DYAMPI
        /*return new Task(isAlert__c=true,Subject='Se te ha asignado un Folio para Alta de Cliente: '+ opp.NumeroAltaCliente__c ,OwnerId=opp.IdEjecutivoADV__c,
		WhatId=contrato.Id,Description='Esta tarea esta relacionada a la oportunidad que se le ha asignado, favor de revisarla para el proceso de Alta de cliente',
		Priority='Normal',Status='No iniciada',ActivityDate= system.today());*/
    //}
    
    //Validate if the RFC-Solution has already an executive assigned. 
    public static void validateRFCSolcionAssignment(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        List<Opportunity> oppsToValidate = new List<Opportunity> ();
        Set<Id> oppsAccIds = new Set<Id>();
        if (oldMap == null) {
            //Is insert.
            for(Opportunity opp: newList){
                if (opp.Entidad_Cuenta__c != null && opp.Familia__c != null) {
                    oppsToValidate.add(opp);
                    oppsAccIds.add(opp.AccountId);
                }
            }
        } else {
            //Is update.
            for(Opportunity opp: newList){
                if (opp.Entidad_Cuenta__c != null && opp.Familia__c != null && ((opp.Entidad_Cuenta__c != oldMap.get(opp.Id).Entidad_Cuenta__c) || (opp.Familia__c != oldMap.get(opp.Id).Familia__c)) ) {
                    oppsToValidate.add(opp);
                    oppsAccIds.add(opp.AccountId);
                }
            }
        }
        if (!oppsToValidate.isEmpty()) {
            List<ContratoFilial__c> contratosActivos = [SELECT Entidad_Cuenta__c, Entidad_Cuenta__r.Cuenta__c, Producto__r.Family, Owner.Name, OwnerId FROM ContratoFilial__c
                                                        WHERE Entidad_Cuenta__r.Cuenta__c IN: oppsAccIds AND Producto__r.Family != null
                                                        AND RFC__c != null AND isActive__c = true AND Owner.UserRole.DeveloperName != 'Ejecutivo_Trademarketing'
                                                        AND Producto__r.ProductCode != '30-B' AND OwnerId !=: UserInfo.getUserId()];
            Map<String, ContratoFilial__c> contratosMap = new Map<String, ContratoFilial__c>();
            for(ContratoFilial__c contrato: contratosActivos){
                String solucion = contrato.Producto__r.Family;
                if(solucion == 'Despensa' || solucion == 'Ticket Restaurante' || solucion == 'Regalo' || solucion == 'Vestimenta' || solucion == 'Ayuda social') {
                    solucion = 'Benefits';
                }
                contratosMap.put(contrato.Entidad_Cuenta__r.Cuenta__c + '-' + contrato.Entidad_Cuenta__c + '-' + solucion , contrato);
            }
            for (Opportunity oppToValidate: oppsToValidate) {
                String solucionAmenaza = oppToValidate.Familia__c;
                if(solucionAmenaza == 'Despensa' || solucionAmenaza == 'Ticket Restaurante' || solucionAmenaza == 'Regalo' || solucionAmenaza == 'Vestimenta' || solucionAmenaza == 'Ayuda Social') {
                    solucionAmenaza = 'Benefits';
                }
                if (contratosMap.containsKey(oppToValidate.AccountId + '-' + oppToValidate.Entidad_Cuenta__c + '-' + solucionAmenaza)) {
                    oppToValidate.addError('Ya existe un ejecutivo asignado para ese RFC en esa solución.');
                }
            }                
        }
    }    
    /* 
    public void getContacto(List<Opportunity> newList){
        set<Id> cuentas = new set<Id>();
        for(Opportunity opp : newList){
            if(!cuentas.contains(opp.AccountId))
                cuentas.add(opp.AccountId);
        }

        List<Contact> contactosList=[SELECT Id,AccountId FROM Contact Where AccountId=:cuentas];
        for(Contact contacto : contactosList){
            for(Opportunity opp : newList){
                if(opp.AccountId==contacto.AccountId){
                    opp.Contacto__c=contacto.Id;
                }
            }
        }
    }*/
    
/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Created	27/03/2020 	Description: Check if there is an excecutive already assigned to the business unit related
						to the solution added to the opp record, if so, show a message and avoid the record
						creation. If tue user create an opp related to an other business unit solution, the opp is 
						related to the 'Apadrinados' campaign.
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void validateBU(List<Opportunity> newList){
        List<Opportunity> oppsToValidate = new List<Opportunity> ();
        Set<Id> threatsAccIds = new Set<Id>();
        Set<String> oppsSolutions = new Set<String>();
        for(Opportunity opp: newList){
            if (opp.Familia__c != null && opp.AccountId != null) {
                oppsToValidate.add(opp);
                threatsAccIds.add(opp.AccountId);
                String solution = opp.Familia__c;
                if (solution == 'Ayuda Social') {
                    solution = 'Ayuda social';
                }
                oppsSolutions.add(solution);
            }
        }
        //If there are threats to validate
        if (!oppsToValidate.isEmpty()) {
            Map<String, String> solutionAndBUSolutions = new Map<String,String>();
            List<Opportunity> oppsToBeInserted = oppsToValidate;
            List<String> allAllowedSolutions = new List<String>();
            for (String solution : oppsSolutions) {
                List<Roles_BusinessUnits_Solutions__mdt> bUSolutions = [Select AllowedSolutions__c
                                                                        FROM Roles_BusinessUnits_Solutions__mdt
                                                                        WHERE BusinessUnit__c != 'Multiproducto' AND AllowedSolutions__c LIKE : '%'+solution+'%' LIMIT 1];
                if (!bUSolutions.isEmpty()) {
                    for (String allowedSolution : bUSolutions[0].AllowedSolutions__c.split(',')) {
                    	//Filling a map with the threat solution as the key and the string containing all allowed solutions for the business unit for that solution.
                        solutionAndBUSolutions.put(allowedSolution,bUSolutions[0].AllowedSolutions__c);
                        //Get in a list all allowed solutions for the business units related to the incoming threats solutions.
                        allAllowedSolutions.add(allowedSolution);
                    }
                }
            }

            //Select contratos filiales related to the accs in the incoming threats and with a solution containing in the business unit solutions related to the threat solution.
            List<ContratoFilial__c> contratosActivos = [SELECT Entidad_Cuenta__r.Cuenta__c, Producto__r.Family FROM ContratoFilial__c
                                                        WHERE Entidad_Cuenta__r.Cuenta__c IN: threatsAccIds
                                                        AND Producto__r.Family != null
                                                        AND Producto__r.Family IN: allAllowedSolutions
                                                        AND isActive__c = true AND OwnerId !=: UserInfo.getUserId()];
            if (!contratosActivos.isEmpty()) {
                Map<String, List<ContratoFilial__c>> allSolutionsWhithContracts = new Map<String, List<ContratoFilial__c>>();
                for (ContratoFilial__c contrato : contratosActivos) {
                    //Filling a map with a string with the acc and all allowed solutions for a BU and as value, the list of contratos filiales with a solution containing in the key.
                    if (allSolutionsWhithContracts.containsKey(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family))) {
                        //If the allSolutionsWhithContracts contains the key(acc-allAllowedSolutions) that contains the comtrato filial solution, only add the contrato to the existing value list. 
                        List<ContratoFilial__c> accContracts = allSolutionsWhithContracts.get(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family));
                        accContracts.add(contrato);
                        allSolutionsWhithContracts.put(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family), accContracts);
                    } else {
                        //If the allSolutionsWhithContracts does not contain the key(acc-allAllowedSolutions) that contains the comtrato filial solution, add the key and initialize the value list with the contrato. 
                        allSolutionsWhithContracts.put(contrato.Entidad_Cuenta__r.Cuenta__c+'-'+solutionAndBUSolutions.get(contrato.Producto__r.Family), new List<ContratoFilial__c> { contrato });
                    }                                      
                }
                for (Opportunity newOpp : oppsToValidate) {
                    String solution = newOpp.Familia__c;
                    if (solution == 'Ayuda Social') {
                        solution = 'Ayuda social';
                    }
                    //If acc Id and allowed solutions for that business unit is already a key in the map, add the error.
                    if(allSolutionsWhithContracts.containsKey(newOpp.AccountId+'-'+solutionAndBUSolutions.get(solution))) {
                        newOpp.addError('Este grupo ya tiene asignado un ejecutivo para la Unidad de negocio seleccionada.');
                    } else {
                        //If the opp has an error, is removed from the opps to be inserted.
                    	oppsToBeInserted.remove(oppsToBeInserted.indexOf(newOpp));
                    }
                }
            }
            if (!oppsToBeInserted.isEmpty()) {
                List<User> userRoleName = [SELECT UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];
                if (!userRoleName.IsEmpty() && userRoleName[0].UserRole.Name != 'Ejecutivo Multiproducto Region Noroeste' && userRoleName[0].UserRole.Name != 'Ejecutivo Multiproducto Region Sureste' && userRoleName[0].UserRole.Name != 'Ejecutivo Ventas Gobierno' && userRoleName[0].UserRole.Name != 'Ejecutivo Region Gobierno' ) {
                    List<Roles_BusinessUnits_Solutions__mdt> bUSolutions = [Select AllowedSolutions__c
                                                                            FROM Roles_BusinessUnits_Solutions__mdt
                                                                            WHERE MasterLabel =: userRoleName[0].UserRole.Name];
                    if (!bUSolutions.isEmpty()) {
                        List<String> solutionsList = bUSolutions[0].AllowedSolutions__c.split(',');
                        for (Opportunity oppToBeInserted : oppsToBeInserted) {
                            String solution = oppToBeInserted.Familia__c;
                            if (solution == 'Ayuda Social') {
                                solution = 'Ayuda social';
                            }
                            //Determine if the opp will be added to the 'Apadrinados' campaign.
                            if (!solutionsList.contains(solution)) {
                                oppToBeInserted.CampaignId = System.Label.ApadrinadosCampaignId;
                                oppToBeInserted.OwnerChangeRequired__c = true;   
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Created	30/03/2020 	Description: If the opp needs an owner change, validate if the new owner is from the correct
						business unit based on the opp solution. 
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void ownerBUValidation(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        List<Opportunity> oppsToValidate = new List<Opportunity>();
        Set<String> oppSolutions = new Set<String>();
        Set<String> ownersIds = new Set<String>();
        for(Opportunity opp: newList){
            if (opp.OwnerChangeRequired__c  == true && opp.Familia__c != null && (opp.OwnerId != oldMap.get(opp.Id).OwnerId) && (opp.StageName == oldMap.get(opp.Id).StageName)) {
                oppsToValidate.add(opp);
                oppSolutions.add(opp.Familia__c);
                ownersIds.add(opp.OwnerId);
            }
        }
        if (!oppsToValidate.isEmpty()) {
            Map<String, List<String>> solutionAndRoles = new Map<String, List<String>>();
            Map<Id, User> ownersRoles = new Map<ID, User>([SELECT Id, UserRole.Name FROM User WHERE Id IN: ownersIds]);
            for(String solution: oppSolutions){
                if (solution == 'Ayuda Social') {
                    solution = 'Ayuda social';
                }
                List<Roles_BusinessUnits_Solutions__mdt> bUSolutions = [Select MasterLabel, AllowedSolutions__c
                                                                        FROM Roles_BusinessUnits_Solutions__mdt
                                                                        WHERE AllowedSolutions__c LIKE : '%'+solution+'%'];
                if (!bUSolutions.isEmpty()) {
                    for (Roles_BusinessUnits_Solutions__mdt bUConfig: bUSolutions) {
                        if (solutionAndRoles.containsKey(solution)) {
                            //If the allSolutionsWhithContracts contains the key(acc-allAllowedSolutions) that contains the comtrato filial solution, only add the contrato to the existing value list. 
                            List<String> roles = solutionAndRoles.get(solution);
                            roles.add(bUConfig.MasterLabel);
                            solutionAndRoles.put(solution, roles);
                        } else {
                            //If the allSolutionsWhithContracts does not contain the key(acc-allAllowedSolutions) that contains the comtrato filial solution, add the key and initialize the value list with the contrato. 
                            solutionAndRoles.put(solution, new List<String> { bUConfig.MasterLabel });
                        }  
                    }
                }
            }
            for (Opportunity opp: oppsToValidate) {
                String solution = opp.Familia__c;
                if (solution == 'Ayuda Social') {
                    solution = 'Ayuda social';
                }
                if (solutionAndRoles.containsKey(solution) && ownersRoles.containsKey(opp.OwnerId) && !solutionAndRoles.get(solution).contains(ownersRoles.get(opp.OwnerId).UserRole.Name)) {
                    opp.addError('El ejecutivo asignado no corresponde a la business unit relacionada a la solución asociada a la oportunidad.');
                } else {
                    opp.OwnerChangeRequired__c = false;
                }
                
            }
        }
    }
    
}