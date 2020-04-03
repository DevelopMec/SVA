public without sharing class TriggerLeadHandler extends TriggerHandler{
    private List<Lead> newList;
    private Map<Id, Lead> oldMap;
    private Map<Id, Lead> newMap;
    
    public TriggerLeadHandler() {
        this.newList = (List<Lead>) trigger.new;
        this.oldMap = (Map<Id, Lead>) trigger.oldMap;
        this.newMap = (Map<Id, Lead>) trigger.newMap;
    }
    
    public override void beforeInsert(){
        validacionesBP();
        //validarSemaforos(newList);
        //SeleccionFamilia(newList);
        //validarCompetidor(newList);
        
        // Req 2338 FWY
        Lead_Scoring(false);
    }
    
    public override void beforeUpdate(){
        validacionesBP();
        //SeleccionFamilia(newList);
        //validarCompetidor(newList);
        //validarSemaforos(newList);    
        
        for(List<Lead> prospectolst:[SELECT Id, OwnerId FROM Lead WHERE Id IN :newMap.keySet()]){
            for(Lead obj :prospectolst ) {
                if (newMap.get(obj.Id)!=null && obj.OwnerId != newMap.get(obj.Id).ownerId){
                    newMap.get(obj.Id).TimestampUltimaFechaDeTransferencia__c = System.now();
                }
            }
        }  

        /*
        for(Lead prospecto:newList){
            Lead actualValue = [Select id, ownerId from Lead where id =: prospecto.Id];
            if(actualValue.OwnerId != prospecto.OwnerId){
                DateTime today = DateTime.now();
                prospecto.TimestampUltimaFechaDeTransferencia__c = today;
            }
        }*/
        
        // Req 2338 FWY
        Lead_Scoring(true);
    }

    public override void afterInsert() {
        /*
        *   calvarez: 16 enero de 2017
            Aplica regla de asignación activa
        */
        new ReglasAsignacionLeads(newMap);
        new UTIL_AsignacionLeadReglas().doProcess(newList, newMap);//Comenta calvarez 27 enero de 2017
        
    }
    
    public override void afterUpdate() {
        aprobacionLead(newList);
        mapeoCamposOportunidad( this.newMap, this.oldMap );// 01/06/2018 calvarez@ctconsulting.com.mx  Mapeo de campo Opportunity.Familia__c desde Lead.CategoriaSolucion__c
    }
    
    // Req 2338 FWY
    public void Lead_Scoring(boolean isUpdate){
        Lead_Score__c ls = Lead_Score__c.getOrgDefaults();

        if(ls != null && ls.Status__c != null){
            Map<Id, Id> CampaignIdMap = new Map<Id, Id>();
            if(isUpdate){
                for(CampaignMember cm : [Select Id, CampaignId, LeadId from CampaignMember where LeadId in: newMap.keySet()]){
                    CampaignIdMap.put(cm.LeadId, cm.CampaignId);
                }
            }
        
            for(Lead l : this.newList){
                decimal score_estatico = 0;
                decimal score_bonus = 0;
            
                //Estatus del prospecto
                switch on l.Status {
                    when 'En curso' {
                        score_estatico += ls.Status__c * ls.Status_En_curso__c;
                    }
                    when 'Contactado' {
                        score_estatico += ls.Status__c * ls.Status_Contactado__c;
                    }
                    when 'No contactado' {
                        score_estatico += ls.Status__c * ls.Status_No_contactado__c;
                    }
                    when 'Sin Segmento Definido' {
                        score_estatico += ls.Status__c * ls.Status_Sin_Segmento_Definido__c;
                    }
                    when 'No interesado' {
                        score_estatico += ls.Status__c * ls.Status_No_interesado__c;
                    }
                    when else {
                        System.debug('NA');
                    }
                }
            
                //Tiempo transcurrido desde la fecha de creación
                //Campo formulado independiente
            
                //Familias (nombres)
                if(!string.isBlank(l.CategoriaSolucion__c)){
                    if(l.CategoriaSolucion__c.contains('Despensa') ||
                       l.CategoriaSolucion__c.contains('Combustible') ||
                       l.CategoriaSolucion__c.contains('Empresarial')){
                        score_estatico += ls.Families__c * ls.Families_Despensa_Combustible_Emp__c;
                    }
                    else{
                        score_estatico += ls.Families__c * ls.Families_Otras__c;
                    }
                }
            
                //Familia (cantidad)
                if(!string.isBlank(l.CategoriaSolucion__c)){
                    List<string> fams = l.CategoriaSolucion__c.split(';');
                    switch on fams.size() {
                        when 1 {
                            score_estatico += ls.Family__c * ls.Family_1__c;
                        }
                        when 2 {
                            score_estatico += ls.Family__c * ls.Family_2__c;
                        }
                        when else {
                            score_estatico += ls.Family__c * ls.Family_3__c;
                        }
                    }
                }
            
                //Relacionada a una campaña
                if(CampaignIdMap.containsKey(l.Id)){
                    score_estatico += ls.Campaign__c * ls.Campaign_Yes__c;
                }
                else{
                    score_estatico += ls.Campaign__c * ls.Campaign_No__c;
                }
                
                //Segmento comercial
                switch on l.Segmento__c {
                    when 'Medium-M2', 'Large', 'Key' {
                        score_estatico += ls.Segment__c * ls.Segment_Middle_2_Large_Key__c;
                    }
                    when 'Medium-M1' {
                        score_estatico += ls.Segment__c * ls.Segment_Middle_1__c;
                    }
                    when 'Small-S3' {
                        score_estatico += ls.Segment__c * ls.Segment_S3__c;
                    }
                    when 'Small-S2' {
                        score_estatico += ls.Segment__c * ls.Segment_S2__c;
                    }
                    when 'Small-S1' {
                        score_estatico += ls.Segment__c * ls.Segment_S1__c;
                    }
                    when else {
                        System.debug('NA');
                    }
                }
            
                //Origen
                switch on l.LeadSource {
                    when 'SEO', 'SEA', 'Sitio Web', 'Célula de Citas', 'Recomendado', 'Referenciadores', 'Telefónico' {
                        score_estatico += ls.Origin__c * ls.Origin_SEO_SEA_Web_Citas_Rec_Ref_Tel__c;
                    }
                    when 'Redes sociales', 'Email Marketing' {
                        score_estatico += ls.Origin__c * ls.Origin_Redes_sociales_Email_mkt__c;
                    }
                    when else {
                        score_estatico += ls.Origin__c * ls.Origin_Otros__c;
                    }
                }
            
                //Telefono (2)
                if(!string.isBlank(l.Telefono2__c))
                    score_bonus += ls.Bonus_Telefono2__c;
                
                //Celular
                if(!string.isBlank(l.MobilePhone))
                    score_bonus += ls.Bonus_MobilePhone__c;
                
                //Puesto
                if(!string.isBlank(l.Puesto__c))
                    score_bonus += ls.Bonus_Puesto__c;
                
                //Área de trabajo
                if(!string.isBlank(l.AreaTrabajo__c))
                    score_bonus += ls.Bonus_AreaTrabajo__c;
                
                //Fecha de cumpleaños
                if(l.FechaCumpleanos__c != null)
                    score_bonus += ls.Bonus_FechaCumpleanos__c;
                
                //Sítio Web
                if(!string.isBlank(l.Website))
                    score_bonus += ls.Bonus_Website__c;
                
                //Giro
                if(!string.isBlank(l.Giro__c))
                    score_bonus += ls.Bonus_Giro__c;
                
                //Sub Giro
                if(!string.isBlank(l.Subgiro_PL__c))
                    score_bonus += ls.Bonus_Subgiro_PL__c;
                
                //Número de Vehículos
                if(!string.isBlank(l.N_mero_de_veh_culos__c))
                    score_bonus += ls.Bonus_N_mero_de_veh_culos__c;
                
                //Sector
                if(!string.isBlank(l.Sector__c))
                    score_bonus += ls.Bonus_Sector__c;
                
                l.Static_score__c = score_estatico;
                l.Bonus_score__c = score_bonus;
            }
        }
    }
    
    /*public void validarSemaforos(List<Lead> listLeads){
        Set<String> idOwners=new Set<String>();
        //Set<String> perfilesField=new Set<String>{'Area Metropolitana', 'Ejecutivo Postventa TE', 'Ejecutivo Posventa Area Metropo',
         'Ejecutivo Posventa Region Bajio', 'Ejecutivo Posventa Region Centro', 'Ejecutivo Posventa Region Noroeste',
         'Ejecutivo Posventa Region Norte', 'Ejecutivo Posventa Region Occ', 'Ejecutivo Posventa Region Sureste', 'Ejecutivo Venta TE',
         'Ejecutivo Ventas Area Metropolitana', 'Ejecutivo Ventas Region Bajio', 'Ejecutivo Ventas Region Centro',
         'Ejecutivo Ventas Region Noroeste', 'Ejecutivo Ventas Region Norte', 'Ejecutivo Ventas Region Occ',
         'Ejecutivo Ventas Region Sureste', 'Ejecutivo Ventas Trademarketing', 'Posventa Area Metropolitana', 'Posventa Region Bajio',
         'Posventa Region Gobierno', 'Posventa Region Norte', 'Posventa Region Occidente', 'Posventa Telefonica', 'Region Bajio',
         'Region Centro', 'Region Noroeste', 'Region Norte', 'Region Occidente', 'Region Sureste', 'Ventas Area Metropolitana',
         'Ventas Region Centro', 'Ventas Region Gobierno', 'Ventas Region Norte', 'Ventas Region Occidente'};
        Set<String> perfilesDistant=new Set<String>{'Ejecutivo de Migracion','Ejecutivo Telesales Outbound','Ejecutivo Telesales Inbound'};
        for(Lead l:listLeads){
            idOwners.add(l.OwnerId);
        }
        Map<String,String> mapaRoles=new Map<String,String>();
        for(User u:[Select Id,UserRole.Name from User where Id IN:idOwners]){
            mapaRoles.put(u.Id, u.UserRole.Name);
        }
        
        for(Lead le:listLeads){
            if(Trigger.isUpdate){
                if(le.FechaReasignacion__c==null&&le.CountryCode!='PE'&&le.CountryCode!='CO'&&le.Status!='Calificado'&&
                   le.Status!='No interesado'&&le.Status!='Descartado'&&perfilesDistant.contains(mapaRoles.get(le.OwnerId))&&
                   (le.OwnerId!=oldMap.get(le.Id).OwnerId)){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=10;
                }else if(le.FechaReasignacion__c!=null&&!perfilesDistant.contains(mapaRoles.get(le.OwnerId))&&
                        (le.OwnerId!=oldMap.get(le.Id).OwnerId)){
                    le.FechaReasignacion__c=null;
                    le.NumeroReasignacion__c=null;
                }
            }else if(Trigger.isInsert){
                if(le.FechaReasignacion__c==null&&perfilesDistant.contains(mapaRoles.get(le.OwnerId))){
                    le.FechaReasignacion__c=DateTime.now();
                    le.NumeroReasignacion__c=10;
                }
            }
        }
    }*/
    
    public void aprobacionLead(List<Lead> listProspectos){
        System.debug('VERRRRaprobacionLead');
        List<Lead> leadCambios=new List<Lead>();
        Map<String,String> listRfc=new Map<String,String>();
        Map<String,Lead> listRfcLead=new Map<String,Lead>();
        for(Lead pr : listProspectos){
            if(pr.StatusApprovalBPfleet__c!=oldMap.get(pr.Id).StatusApprovalBPfleet__c&&
               oldMap.get(pr.Id).StatusApprovalBPfleet__c=='En espera de aprobación'&&pr.StatusApprovalBPfleet__c=='Aprobado'){
                leadCambios.add(pr);
                listRfcLead.put(pr.RFC__c, pr);
                listRfc.put(pr.RFC__c,pr.OwnerId);
            }
        }
        if(leadCambios!=null&&leadCambios.size()>0){
            //System.debug('VERRRR1');
            Map<String,String> mapRfc=new Map<String,String>();
            List<Map<String,String>> listaOpps=new List<Map<String,String>>();
            List<AccountShare> listSharAcc=new List<AccountShare>();
            List<AccountShare> listSharAccInsert=new List<AccountShare>();
            Set<String> cuentasList=new Set<String>();
            for(EntidadCuenta__c ec : [Select Id,Cuenta__c,RFCEL__c from EntidadCuenta__c where RFCEL__c IN :listRfc.keySet()]){
                //System.debug('VERRRR2');
                cuentasList.add(ec.Cuenta__c);
                listSharAcc.add(new AccountShare(AccountId=ec.Cuenta__c,UserOrGroupId=listRfc.get(ec.RFCEL__c),AccountAccessLevel='Read',
                ContactAccessLevel='None',CaseAccessLevel='None',OpportunityAccessLevel='None'));
                listaOpps.add(new Map<String,String>{'idCuenta'=>ec.Cuenta__c,'idRfc'=>ec.Id,'idOwner'=>listRfc.get(ec.RFCEL__c),
                'idLead'=>listRfcLead.get(ec.RFCEL__c).Id,'idNotificacion'=>listRfcLead.get(ec.RFCEL__c).IdExecutiveNotification__c,
                'origen'=>listRfcLead.get(ec.RFCEL__c).LeadSource,'subOrigen'=>listRfcLead.get(ec.RFCEL__c).SubOrigen__c,
                'competidor'=>listRfcLead.get(ec.RFCEL__c).Competidor__c});
            }
            Set<String> mapAccSha=new Set<String>();
            for(AccountShare ac : [Select AccountId,UserOrGroupId,AccountAccessLevel,ContactAccessLevel,CaseAccessLevel from AccountShare
             where AccountId IN :cuentasList and UserOrGroupId IN :listRfc.values() and AccountAccessLevel='Read'
              and ContactAccessLevel='None' and CaseAccessLevel='None']){
                //System.debug('VERRRR3');
                Database.LeadConvert lc = new database.LeadConvert();             
                mapAccSha.add(ac.AccountId+'-'+ac.UserOrGroupId+'-'+ac.AccountAccessLevel+'-'+ac.ContactAccessLevel+'-'+ac.CaseAccessLevel);
            }
            for(AccountShare ac : listSharAcc){
                if(!mapAccSha.contains(ac.AccountId+'-'+ac.UserOrGroupId+'-'+ac.AccountAccessLevel+'-'+ac.ContactAccessLevel+'-'+ac.CaseAccessLevel)){
                    //System.debug('VERRRR4');
                    System.debug('ACCCS:::'+ac);
                    listSharAccInsert.add(ac);
                }
            }
            insert listSharAccInsert;
            //try{
                //System.debug('VERRRR5');
                //System.debug('MAP::'+listaOpps);
                List<Opportunity> lOpp=BuscadorBPfleet_CONT.crearOportunidades(listaOpps);
                Map<String,Map<String,String>> mapaInfoUsuarios=new Map<String,Map<String,String>>();
                for(User us : [Select Id,Name,Email from User where Id IN:listRfc.values()]){
                    mapaInfoUsuarios.put(us.Id,new Map<String,String>{'nombre'=>us.Name,'correo'=>us.Email});
                }
                Map<String,Map<String,String>> mapaInfoUsuariosEmailSend=new Map<String,Map<String,String>>();
                for(Opportunity opp : lOpp){
                    mapaInfoUsuariosEmailSend.put(opp.Id, new Map<String,String>{'idCuenta'=>opp.AccountId,
                    'idNotificacion'=>opp.IdExecutiveNotification__c,'idOwner'=>opp.OwnerId,'nombreOpp'=>opp.Name,
                    'nombre'=>mapaInfoUsuarios.get(opp.OwnerId).get('nombre'),'correo'=>mapaInfoUsuarios.get(opp.OwnerId).get('correo')});
                }
                enviarEmails(mapaInfoUsuariosEmailSend);
            /*}catch(Exception e){
                System.debug('Error:: '+e.getMessage()+', Linea: '+e.getLineNumber());
                if(listSharAccInsert!=null&&listSharAccInsert.size()>0){
                    //System.debug('VERRRRDELETE');
                    delete listSharAccInsert;
                }
            }*/
        }
    }
    
    public void enviarEmails(Map<String,Map<String,String>> mapaOppUser){
        Messaging.reserveSingleEmailCapacity(mapaOppUser.size());
        Messaging.SingleEmailMessage[] listEmails=new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate plantilla=[SELECT Id,HtmlValue,Body FROM EmailTemplate where DeveloperName='Solicitud_de_aprobacion_BP'];
        String htmlEmail=plantilla.HtmlValue;
        String textEmail=plantilla.Body;
        List<Task> listNotification=new List<Task>();
        for(String opp : mapaOppUser.keySet()){
            
            Task notif = new Task();
            //notif.Status='Concluida';
            notif.isAlert__c=true;
            //notif.ReminderDateTime=DateTime.now().addMinutes(1);
            notif.WhatId=opp;
            notif.Subject='Nueva oportunidad generada';
            notif.Description='El prospecto ha sido aprobado, se ha generado la oportunidad';
            notif.OwnerId=mapaOppUser.get(opp).get('idOwner');
            listNotification.add(notif);
            Task notif2 = new Task();
            notif2.WhatId=mapaOppUser.get(opp).get('idCuenta');
            notif2.Subject='Colaboración en la cuenta';
            notif2.Description='Se ha aprobado la colaboración en la cuenta al ejecutivo '+mapaOppUser.get(opp).get('nombre');
            notif2.OwnerId=mapaOppUser.get(opp).get('idNotificacion');
            listNotification.add(notif2);
            
            String ownerName=mapaOppUser.get(opp).get('nombre');
            String oppName=mapaOppUser.get(opp).get('nombreOpp');
            htmlEmail=htmlEmail.replaceAll('!NombrePropietario', ownerName);
            htmlEmail=htmlEmail.replaceAll('!Oportunidad', 'Se ha generado la Oportunidad: <a href="'+url.getOrgDomainUrl().toExternalForm()+'/'+opp+'">'+oppName+'</a>');
            
            textEmail=textEmail.replaceAll('!NombrePropietario', ownerName);
            textEmail=textEmail.replaceAll('!Oportunidad', opp);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {mapaOppUser.get(opp).get('correo')}; 
                //String[] ccAddresses = new String[] {'smith@gmail.com'};
                mail.setToAddresses(toAddresses);
            //mail.setCcAddresses(ccAddresses);
            //mail.setReplyTo('support@acme.com');
            mail.setSenderDisplayName('Información aprobaciones');
            mail.setSubject('Prospecto Aprobado');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody(textEmail);
            mail.setHtmlBody(htmlEmail);
            listEmails.add(mail);
        }
        Messaging.sendEmail(listEmails);
        
        if(!Test.isRunningTest())
            insert listNotification;
        
    }
    
    public void validacionesBP(){
        /************************/
        List<Lead> listProsp=new List<Lead>();
        for(Lead pro : newList){
            if(((Trigger.isInsert)||(Trigger.isUpdate&&pro.RFC__c!=oldMap.get(pro.Id).RFC__c)) &&
               pro.StatusApprovalBPfleet__c==null&&pro.RFC__c!=null &&
               pro.RecordTypeId!=null &&
               String.valueOf(pro.RecordTypeId).equalsIgnoreCase(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('BPfleet').getRecordTypeId())||
               (!pro.BPfleetApproval__c) &&
               pro.StatusApprovalBPfleet__c==null &&
               pro.RFC__c!=null &&
               pro.RecordTypeId!=null &&
               String.valueOf(pro.RecordTypeId).equalsIgnoreCase(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('BPfleet').getRecordTypeId())){
                 listProsp.add(pro);
            }
        }
        if(listProsp!=null&&listProsp.size()>0){
            Set<String> setElPro=new Set<String>();
            for(Lead pro : listProsp){
                setElPro.add(pro.RFC__c);
            }
            Map<String,Map<String,String>> mapaEl=new Map<String,Map<String,String>>();
            mapaEl=BuscadorBPfleet_CONT.getStatus(setElPro);
            Map<String,String> mapaStatusInt=mapaEl.get('mapaStatusInt');
            Map<String,String> mapaAprobadores=mapaEl.get('mapaAprobadores');
            for(Lead pros: listProsp){
                if(mapaStatusInt.containsKey(pros.RFC__c)){
                    if(mapaStatusInt.get(pros.RFC__c)=='0'){
                        pros.BPfleetApproval__c=true;
                        if(mapaAprobadores.containsKey(pros.RFC__c)){
                            List<String> datos=mapaAprobadores.get(pros.RFC__c).split('-');
                            pros.Approver__c=datos[1]!=''&&datos[1]!=null ? datos[1] : null;
                            pros.IdExecutiveNotification__c=datos[0]!=''&&datos[0]!=null ? datos[0] : '';
                        }
                    }else if(mapaStatusInt.get(pros.RFC__c)=='1'){
                        pros.BPfleetApproval__c=false;
                        pros.StatusApprovalBPfleet__c=null;
                    }
                }
            }
        }
        /************************/
    }
    

    /*
     *   calvarez: 16 enero de 2017
        Verifica si el Lead fue convertido y tiene ConvertedAccountId
    
    public override void afterUpdate() {
        
        new UTIL_AsignacionLeadReglas().doUpdateAccount(oldMap, newList);//Comenta calvarez 27 enero de 2017
    }
     */
    
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 01/06/2018
        * @param newLeads Map de nuevas instancias de Lead.
        * @param oldLeads Map de anteriores instancias de Lead.
        * @description Mapeo de campo Opportunity.Familia__c desde Lead.CategoriaSolucion__c
        * @return Void.
    **/
    
   /* public void validarCompetidor(List<Lead> prosp){
        List<String> valorCombustible=new List<String>{'Amex','Banamex','Bancomer','Banorte','Banregio','Broxel',
        'Convenio con Gasolinera','Easyvale / Toka','Efectivale','Finutil','GasnGo','Hidrosina','HSBC','Inburgas','Inbursa','Lease Plan',
        'Mega Vale / Suven','No había la prestación','Nómina/Efectivo','No proporcionó información','No tenía proveedor',
        'OCSI / One Card','Orsan','Otro banco','Otro competidor','Otro grupo gasolinero','Oxxo Gas','Pagaflex','Previvale',
        'Recargas Energex','Santander','Scotiabank','Si Vale','Sodexo','Todito Pagos','Valemex'};
        List<String> valorAyudaSocial=new List<String>{'Amex','Banamex','Bancomer','Banorte','Broxel','Easyvale / Toka','Efectivale',
        'HSBC','Inbursa','Mega Vale / Suven','No había la prestación','Nómina/Efectivo','No proporcionó información','No tenía proveedor',
        'One Card','Otro banco','Otro competidor','Santander','Si Vale','Sodexo','Tiendas de autoservicio'};
        List<String> valorComida = new List<String>{'Amex','Banamex','Bancomer','Banorte','Broxel','Easyvale / Toka','Efectivale','HSBC',
        'Inbursa','Mega Vale / Suven','No había la prestación','Nómina/Efectivo','No proporcionó información','No tenía proveedor',
        'One Card','Otro banco','Otro competidor','Santander','Si Vale','Sodexo','Tiendas de autoservicio'};
        List<String> valorDespensa = new List<String>{'Amex','Banamex','Bancomer','Banorte','Broxel','Easyvale / Toka','Efectivale',
        'HSBC','Inbursa','Mega Vale / Suven','No había la prestación','Nómina/Efectivo','No tenía proveedor','One Card','Otro banco',
        'Otro competidor','Santander','Si Vale','Sodexo','Tiendas de autoservicio'};
        List<String> valorIncentivos =  new List<String>{'Amex','Banamex','Bancomer','Banorte','Broxel','Easyvale / Toka','Efectivale',
        'HSBC','Inbursa','Mega Vale / Suven','No había la prestación','Nómina/Efectivo','No tenía proveedor','One Card','Otro banco',
        'Otro competidor','Santander','Si Vale','Sodexo','Tiendas de autoservicio'};
            
            for(Lead comp:prosp){
               
                List<String> guardarList = comp.CategoriaSolucion__c.split(';');
                
                if(guardarList[0]=='Combustible'){
                    if(!valorCombustible.contains(comp.Competidor__c)){
                        comp.addError('El competidor no pertenece a la familia');
                    }
                }else if(guardarList[0] =='Ayuda Social' || guardarList[0] == 'Comida'){
                    if(!valorAyudaSocial.contains(comp.Competidor__c)){
                        comp.addError('El competidor no pertenece a la familia');
                        
                        
                    }
                }
                
                if(guardarList[0] =='Despensa' || guardarList[0] == 'Incentivos'){
                             if(!valorDespensa.contains(comp.Competidor__c)){
                                 comp.addError('El competidor no pertenece a la familia');
                             }
                         }
                
            }
    }
    
    public void SeleccionFamilia(List<Lead> familia){
        list<String> opcionesCombus = new List<String>{'G500 FLEET','Hidrosina','Recomendado Element','Recomendado Hidrosina','Recomendado Servifacil'};
        list<String> opcionesDespe = new List<String>{'Chedrahui','Recomendado Chedrahui','Walmart'};
        list<String> opcionesIncen = new List<String>{'Chedrahui','Recomendado Chedrahui','Walmart'};
         
        for( lead prosp: familia){
            //CategoriaSolucion__c ----> Campo selección múltiple "familias"
            list<String> guardarList = prosp.CategoriaSolucion__c.split(';'); //split separa elementos separados por ';'

            
            
            //list<String> Nodisponible = prosp.CategoriaSolucion__c.split(';');  
            //if(guardarList.size()>=1){ //indica tamaño de la lista (indica que sólo va a igual si es un elemento dentro de esa lista, ya sea combustible, Incentivos, Despensa) 
            System.debug(guardarList);
            
            
                  
            if(guardarList[0]=='Combustible'){  //si es combustible ó incentivos o despensa (El conjunto es 0 porque es el primer valor)
                    
                   if(!opcionesCombus.contains(prosp.Maquilador__c)){
                        prosp.addError('La solución no pertenece a la familia Combustible');
                    }
                   
                    //CategoriaSolucion__c --> Campo "Familias(Lista de selección multiple)"
                    //Maquilador__c ---> Campo "Solucuiones White Label"
                   
            } else if(guardarList[0] == 'Despensa' || guardarList[0] == 'Incentivos'){
                if(!opcionesDespe.contains(prosp.Maquilador__c)){
                    
                    if(guardarList[0]=='Despensa'){
                        prosp.addError('La solución white label no corresponde a la familia Despensa');
                            }else{
                                prosp.addError('La solución white label no corresponde a la familia Incentivos');
                            }
                          
                }   
            }
            
             
        }
        
        
    }*/
    
    public void mapeoCamposOportunidad( Map<Id, Lead> newLeads, Map<Id, Lead> oldLeads ) {

        // System.debug('\n\nmapeoCamposOportunidad newLeads: ' + newLeads );
        // System.debug('oldLeads: ' + oldLeads );
        if( newLeads != null && oldLeads != null ) {
            Set<Id> setIdLead = new Set<Id>();
            for( Lead leadAux : oldLeads.values() ) {
                if( leadAux.IsConverted == false && newLeads.get(leadAux.Id).IsConverted == true ) {
                    setIdLead.add( leadAux.Id );
                }
            }

            if( setIdLead != null && setIdLead.size() > 0 ) {
                System.debug('setIdLead: ' + setIdLead);

                List<Opportunity> listOpportunityUpdate = new List<Opportunity>();
                Set<Id> setIdOpportunity = new Set<Id>();

                Map<Id, Lead> mapLead = new Map<Id, Lead>();
                for(Lead leadAux : [ SELECT Id, CategoriaSolucion__c,Competidor__c, Name, ConvertedOpportunityId FROM Lead WHERE Id IN: setIdLead ] ) {
                    if( leadAux.ConvertedOpportunityId != null ) {
                        setIdOpportunity.add( leadAux.ConvertedOpportunityId );
                        mapLead.put( leadAux.ConvertedOpportunityId, leadAux );
                    }
                }
                if( setIdOpportunity != null && setIdOpportunity.size() > 0 ) {
                    List<Opportunity> listOpportunity = [ SELECT Id, Familia__c FROM Opportunity WHERE Id IN: setIdOpportunity];

                    System.debug('listOpportunity 2 update: ' + listOpportunity + '\n\n');

                    for( Opportunity opp : listOpportunity ) {
                        String familia = mapLead.containsKey( opp.Id ) ? mapLead.get(opp.Id).CategoriaSolucion__c : '';
                        String competidor = mapLead.containsKey( opp.Id ) ? mapLead.get(opp.Id).Competidor__c : '';
                        if( String.isNotBlank( familia ) ) {
                            listOpportunityUpdate.add( new Opportunity( Id = opp.Id, Familia__c = familia.split(';')[0],Competidor__c=competidor));
                        }
                    }

                    if( listOpportunityUpdate != null && listOpportunityUpdate.size() > 0 ) {
                        update listOpportunityUpdate;
                    }
                }
            }
        }
    }
}