public without sharing class TriggerOpportunityLineItemHandler extends TriggerHandler {
	
    /*Valor del campo de lista de seleccion Etapa en el Objeto OpportunityLineItem*/
    private static final String IMPLEMENTACION = 'Implementación';
    /*Valor del campo de lista de seleccion StageName en el Objeto OpportunityLineItem*/
    private static final String PERDIDA = 'Perdida';
    /*Valor del campo de lista de seleccion Segmento__c en el Objeto User*/
    private static final String SMALL = 'Small';
    /*Valor del campo de lista de seleccion Segmento__c en el Objeto User*/
    private static final String MLK = 'MLK';
    /*Valor del campo de lista de seleccion Estatus__c en el Objeto WorkOrder*/
    private static final String PREASIGNACION = 'Preasignación';
    /*Valor del campo de lista de seleccion Estatus__c en el Objeto WorkOrder*/
    private static final String PROCESO = 'En Proceso';
    /*Valor del campo de lista de seleccion Estatus__c en el Objeto WorkOrder*/
    private static final String CANCELADA = 'Cancelada';
      
    /*Valor Configuracion PERSONALIZADA*/
    private ID RESPONSABLEPEDIDO;
    /*Valor Configuracion PERSONALIZADA*/
    private ID IMPLEMENTADOR;
    /*Valor Configuracion PERSONALIZADA*/
    private ID CAPACITADOR;
    
    private Map<Id, OpportunityLineItem> newMap;
	private Map<Id, OpportunityLineItem> oldMap;
	private List<OpportunityLineItem> newList;
	private List<OpportunityLineItem> oldList;
    
	public TriggerOpportunityLineItemHandler() {
        
		this.newMap = (Map<Id, OpportunityLineItem>) trigger.newMap;
		this.oldMap = (Map<Id, OpportunityLineItem>) trigger.oldMap;
		this.newList = (List<OpportunityLineItem>) trigger.new;
		this.oldList = (List<OpportunityLineItem>) trigger.old;
        
        /*Set up configuracion Personalizada*/
        List<TriggerOpportunityLineItemHandlerConfig__c> config = [SELECT id, Name, Capacitador__c, Implementador__c, ResponsablePedido__c FROM TriggerOpportunityLineItemHandlerConfig__c LIMIT 1];
        if(config!=null && config.size()>0){
            this.RESPONSABLEPEDIDO = (!String.isEmpty(config[0].ResponsablePedido__c)?Id.valueOf(config[0].ResponsablePedido__c):null);
            this.IMPLEMENTADOR = (!String.isEmpty(config[0].ResponsablePedido__c)?Id.valueOf(config[0].Implementador__c):null);
            this.CAPACITADOR = (!String.isEmpty(config[0].Capacitador__c)?Id.valueOf(config[0].Capacitador__c):null);
        }
    }

	public override void beforeInsert() {
		System.debug('en beforeUpdate TriggerOpportunityLineItemHandler');
		for(OpportunityLineItem oli : newList) {
			System.debug('oli: ' + oli);
		}
	}

    public override void beforeUpdate() {
        actualizaOpportunityLineItem(newList, oldMap);// agrega calvarez 14-03-2017
    }
    
    public override void afterUpdate(){
        etapaImplementacion(this.newMap,this.oldMap);
        etapaPerdida(this.newMap,this.oldMap);
        actualizaOportunidad(newList);
    }
    /* Autor:  Gerardo Elisiel Martínez Cabral 
	 * Objetivo: Cuando Un Producto de oportunidad cambia el campo de Etapa__c "Implementación" Crea una OT relacionado con la OPP
	 * de Orden de Producto
	 * Fecha: 13/01/2017
	*/
    public void  etapaImplementacion (Map<Id, OpportunityLineItem> newMap, Map<Id, OpportunityLineItem> oldMap) {

        System.debug('etapaImplementacion newMap: ' + newMap);
        System.debug('etapaImplementacion oldMap: ' + oldMap);
        
        List <WorkOrder> workOrdersToInsert = new List<WorkOrder>(); 
        Set<Id> setQli = new Set<Id>();   
        Set<Id> setQliBase = new Set<Id>();   
         
		for (List<OpportunityLineItem> oppLineItems : [SELECT Id, Name, Etapa__c, Product2.Name, Product2.Family, Product2.TipoSolucion__c, Opportunity.AccountId, PartidaPresupuesto__c, Opportunity.StageName, Opportunity.Owner.Segmento__c, Opportunity.Owner.Email, OpportunityId, TotalPrice,ProductCode FROM OpportunityLineItem WHERE Id IN: newMap.keySet()] ){

          
            for (OpportunityLineItem oppLineItem: oppLineItems) {
                if(oppLineItem.PartidaPresupuesto__c != null) {
                    setQli.add(oppLineItem.PartidaPresupuesto__c);
                }
                
                /*comenta calvarez 24 mayo 2017 - sólo mostrar OpportunityLineItem sin escalonamientos hijo if (oldMap.get(oppLineItem.Id).Etapa__c != IMPLEMENTACION && oppLineItem.Etapa__c == IMPLEMENTACION && oppLineItem.Opportunity.Owner.Segmento__c == SMALL){
                    
                    WorkOrder order = new WorkOrder();
                    order.Oportunidad__c = oppLineItem.OpportunityId;
                    order.Solucion2__c = oppLineItem.Product2.Name;
                    order.VolumenEmisionMensual2__c = oppLineItem.TotalPrice; 
                    order.Familia2__c = oppLineItem.Product2.Family;
                    order.TipoSolucion2__c = oppLineItem.Product2.TipoSolucion__c;
					order.IDProductoOpp__c  = String.valueOf(oppLineItem.Id);
                    order.AccountId = oppLineItem.Opportunity.AccountId;
                    order.Estatus__c = PREASIGNACION;
                    order.MailEjecutivo__c =oppLineItem.Opportunity.Owner.Email; 
                    order.ResponsablePedido__c = RESPONSABLEPEDIDO;
					order.StartDate = System.now();
                    order.NumProducto__c =oppLineItem.ProductCode;
                   
                    
                    if (IMPLEMENTADOR !=null){
                        order.OwnerId = IMPLEMENTADOR;
                    }
                    
                    workOrdersToInsert.add(order); 
                }else if (oldMap.get(oppLineItem.Id).Etapa__c!=IMPLEMENTACION && oppLineItem.Etapa__c == IMPLEMENTACION && oppLineItem.Opportunity.Owner.Segmento__c == MLK){
                    
                    WorkOrder order = new WorkOrder();
                    order.Oportunidad__c = oppLineItem.OpportunityId;
                    order.Solucion2__c = oppLineItem.Product2.Name;
                    order.VolumenEmisionMensual2__c = oppLineItem.TotalPrice; 
                    order.Familia2__c = oppLineItem.Product2.Family;
                    order.TipoSolucion2__c = oppLineItem.Product2.TipoSolucion__c;
                    order.IDProductoOpp__c  = String.valueOf(oppLineItem.Id);
                    order.AccountId = oppLineItem.Opportunity.AccountId;
                    order.Estatus__c = PROCESO;
                    order.MailEjecutivo__c =oppLineItem.Opportunity.Owner.Email;
                    order.StartDate = System.now();
                    order.NumProducto__c =oppLineItem.ProductCode;
                    
                    if (CAPACITADOR!=null){                    
                        order.OwnerId = CAPACITADOR;
                    }
                    
                    workOrdersToInsert.add(order); 
                }*/
            }
        }
        
        /*if(setQli != null && setQli.size() > 0) {
            for(QuoteLineItem qli : [SELECT Id FROM QuoteLineItem WHERE Escalonamiento__c = null AND Id IN: setQli]) {
                setQliBase.add(qli.Id);
            }
        }
        if(setQliBase != null && setQliBase.size() > 0) {
            for(OpportunityLineItem oppLineItem: [SELECT Id, Name, Etapa__c, Product2.Name, Product2.Family, Product2.TipoSolucion__c, Opportunity.AccountId, PartidaPresupuesto__c, Opportunity.StageName, Opportunity.Owner.Segmento__c, Opportunity.Owner.Email, OpportunityId, TotalPrice,ProductCode FROM OpportunityLineItem WHERE PartidaPresupuesto__c IN: setQliBase]) {
                if(oldMap.containsKey(oppLineItem.Id) && oppLineItem.Opportunity != null && oppLineItem.Opportunity.Owner != null) {
                    if (IMPLEMENTACION != oldMap.get(oppLineItem.Id).Etapa__c && IMPLEMENTACION == oppLineItem.Etapa__c && SMALL == oppLineItem.Opportunity.Owner.Segmento__c){
                    //if (oldMap.get(oppLineItem.Id).Etapa__c != IMPLEMENTACION && oppLineItem.Etapa__c == IMPLEMENTACION && oppLineItem.Opportunity.Owner.Segmento__c == SMALL){
                        
                        // WorkOrder order = new WorkOrder(Oportunidad__c = oppLineItem.OpportunityId, Solucion2__c = oppLineItem.Product2.Name, VolumenEmisionMensual2__c = oppLineItem.TotalPrice, Familia2__c = oppLineItem.Product2.Family, TipoSolucion2__c = oppLineItem.Product2.TipoSolucion__c, IDProductoOpp__c  = String.valueOf(oppLineItem.Id), AccountId = oppLineItem.Opportunity.AccountId, Estatus__c = PREASIGNACION, MailEjecutivo__c =oppLineItem.Opportunity.Owner.Email, ResponsablePedido__c = RESPONSABLEPEDIDO, StartDate = System.now(), NumProducto__c =oppLineItem.ProductCode);
                        WorkOrder order = new WorkOrder();
                        order.Oportunidad__c = oppLineItem.OpportunityId;
                        order.Solucion2__c = oppLineItem.Product2.Name;
                        order.VolumenEmisionMensual2__c = oppLineItem.TotalPrice; 
                        order.Familia2__c = oppLineItem.Product2.Family;
                        order.TipoSolucion2__c = oppLineItem.Product2.TipoSolucion__c;
                        order.IDProductoOpp__c  = String.valueOf(oppLineItem.Id);
                        order.AccountId = oppLineItem.Opportunity.AccountId;
                        order.Estatus__c = PREASIGNACION;
                        order.MailEjecutivo__c =oppLineItem.Opportunity.Owner.Email; 
                        order.ResponsablePedido__c = RESPONSABLEPEDIDO;
                        order.StartDate = System.now();
                        order.NumProducto__c =oppLineItem.ProductCode;

                        if (IMPLEMENTADOR !=null){
                            order.OwnerId = IMPLEMENTADOR;
                        }
                        
                        workOrdersToInsert.add(order); 
                    } else if (IMPLEMENTACION != oldMap.get(oppLineItem.Id).Etapa__c && IMPLEMENTACION == oppLineItem.Etapa__c && MLK == oppLineItem.Opportunity.Owner.Segmento__c){
                    //} else if (oldMap.get(oppLineItem.Id).Etapa__c != IMPLEMENTACION && oppLineItem.Etapa__c == IMPLEMENTACION && oppLineItem.Opportunity.Owner.Segmento__c == MLK){
                        
                        // WorkOrder order = new WorkOrder(Oportunidad__c = oppLineItem.OpportunityId, Solucion2__c = oppLineItem.Product2.Name, VolumenEmisionMensual2__c = oppLineItem.TotalPrice, Familia2__c = oppLineItem.Product2.Family, TipoSolucion2__c = oppLineItem.Product2.TipoSolucion__c, IDProductoOpp__c  = String.valueOf(oppLineItem.Id), AccountId = oppLineItem.Opportunity.AccountId, Estatus__c = PROCESO, MailEjecutivo__c =oppLineItem.Opportunity.Owner.Email, StartDate = System.now(), NumProducto__c =oppLineItem.ProductCode);
                        WorkOrder order = new WorkOrder();
                        order.Oportunidad__c = oppLineItem.OpportunityId;
                        order.Solucion2__c = oppLineItem.Product2.Name;
                        order.VolumenEmisionMensual2__c = oppLineItem.TotalPrice; 
                        order.Familia2__c = oppLineItem.Product2.Family;
                        order.TipoSolucion2__c = oppLineItem.Product2.TipoSolucion__c;
                        order.IDProductoOpp__c  = String.valueOf(oppLineItem.Id);
                        order.AccountId = oppLineItem.Opportunity.AccountId;
                        order.Estatus__c = PROCESO;
                        order.MailEjecutivo__c =oppLineItem.Opportunity.Owner.Email;
                        order.StartDate = System.now();
                        order.NumProducto__c =oppLineItem.ProductCode;
                        if (CAPACITADOR!=null){                    
                            order.OwnerId = CAPACITADOR;
                        }
                        
                        workOrdersToInsert.add(order); 
                    }
                }
            }
        }
        System.debug('WORKORDERS TO INSERT'+workOrdersToInsert);
        insert workOrdersToInsert;*/
    }
    
    /* Autor:  Gerardo Elisiel Martínez Cabral 
	 * Objetivo: Cuando un producto de oportunidad cambia el campo de Etapa__c a "Perdida" actualiza las OT relacionadas con el estatus cancelada
	 * Fecha: 17/01/2017
	*/
    public void etapaPerdida(Map<Id, OpportunityLineItem> newMap,Map<Id, OpportunityLineItem> oldMap){
        List <WorkOrder> workOrdersToUpdate = new List<WorkOrder>();     
		Set<String> oppids = new Set<String>();
        
        for (List<OpportunityLineItem> oppLineItems : [SELECT Etapa__c, OpportunityId FROM OpportunityLineItem WHERE Id IN: newMap.keySet()] ){
            
            for (OpportunityLineItem item:oppLineItems){
                
                if (oldMap.get(item.Id).Etapa__c!=PERDIDA && item.Etapa__c == PERDIDA ){
                    
                    oppids.add(item.Id);
                }                
            }                                                                 
        }
        
        for (List<WorkOrder> lstWorkOrder: [SELECT Estatus__c,Oportunidad__c,IDProductoOpp__c FROM WorkOrder WHERE IDProductoOpp__c IN : oppids]){
            for	(WorkOrder wo: lstWorkOrder){
                
                wo.Estatus__c=CANCELADA;
                workOrdersToUpdate.add(wo);
            }
        }
        System.debug('WORKORDERS LOST: '+workOrdersToUpdate);
        update workOrdersToUpdate;
    }

    /* Autor:  Carlos Álvarez Sánchez
     * Objetivo: La Oportunidad estará 'inactiva' hasta que el total de soluciones que contiene estén en una etapa de Ganada o    Perdida, si alguna solución se encuentra en una etapa diferente la Oportunidad deberá mostrarse como Activa
     * Fecha: 30/01/2017
    */
    public void actualizaOportunidad(List<OpportunityLineItem> newList) {
        Map<Id, Opportunity> idsOpps = new Map<Id, Opportunity>();

        for(List<OpportunityLineItem> listaOLI :[SELECT Id, OpportunityId FROM OpportunityLineItem WHERE Id IN: newMap.keySet()]) {
            for(OpportunityLineItem oli: listaOLI) {
                if(!idsOpps.containsKey(oli.OpportunityId)) {
                    idsOpps.put(oli.OpportunityId, new Opportunity(Id = oli.OpportunityId));
                }
            }
        }
        
        for(List<Opportunity> lista: [SELECT Id, StageName, (SELECT Id, Name FROM Quotes), (SELECT Id, Etapa__c FROM OpportunityLineItems) FROM Opportunity WHERE Id IN: idsOpps.keySet()]) {
            for(Opportunity opp: lista) {
                /*if(idsOpps.containsKey(opp.Id)) {
                    if(opp.Quotes.size() == 0) {
                        idsOpps.get(opp.Id).StageName = 'Inactiva';
                    } else if(opp.OpportunityLineItems.size() > 0) {
                        Boolean cerrada = false;
                        Integer numCot = opp.OpportunityLineItems.size();
                        Integer cerradosGanados = 0;
                        for(OpportunityLineItem oli: opp.OpportunityLineItems) {
                            //if(oli.Etapa__c == 'Ganada' || oli.Etapa__c == 'Perdida' && !cerrada) {
                            if(oli.Etapa__c == 'Ganada' || oli.Etapa__c == 'Perdida') {
                                //cerrada = true;
                                cerradosGanados++;
                            }
                        }

                        // idsOpps.get(opp.Id).StageName = cerradosGanados == numCot ? 'Cerrada' : 'Activa';
                    }
                }*/
            }
        }
        System.debug('\n\n opps to update: ' + idsOpps + '\n\n');
        if(idsOpps != null && idsOpps.values().size() >0) {
            // Database.update(idsOpps.values());
        }
    }


    /**
        *@author: calvarez
        *@description: Actualiza campo TimestampImplementacion__c de OpportunityLineItem
        *@created: 14-03-2017
    */
    public void actualizaOpportunityLineItem(List<OpportunityLineItem> newList, Map<Id, OpportunityLineItem> oldMap) {
        for (OpportunityLineItem oppLineItem: newMap.values()) {
            if (oldMap.get(oppLineItem.Id).Etapa__c != IMPLEMENTACION && oppLineItem.Etapa__c == IMPLEMENTACION) {
                oppLineItem.TimestampImplementacion__c = System.now();
            }
        }
    }
    
}