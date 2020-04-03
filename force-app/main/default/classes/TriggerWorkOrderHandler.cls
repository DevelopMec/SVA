public without sharing class TriggerWorkOrderHandler extends TriggerHandler {
    private Map<Id, WorkOrder> newMap;
    private Map<Id, WorkOrder> oldMap;
    private List<WorkOrder> newList;
    private List<WorkOrder> oldList;
    public TriggerWorkOrderHandler() {        
        this.newMap = (Map<Id, WorkOrder>) trigger.newMap;
        this.oldMap = (Map<Id, WorkOrder>) trigger.oldMap;
        this.newList = (List<WorkOrder>) trigger.new;
        this.oldList = (List<WorkOrder>) trigger.old;
    }
    public override void afterUpdate(){
        verificaOTsConcluidas(this.newMap);
    }
    public override void beforeInsert(){Set<String> idsOpps=new Set<String>();
        for(WorkOrder wo : newList){
            idsOpps.add(wo.Oportunidad__c);
        }
        Map<String,Opportunity> mapOpps=AsignacionesOT.getUsersOpps(idsOpps);
        new AsignacionesOT(newList,mapOpps,'insert');   
    }
    
    public override void beforeUpdate(){
        if(RecursiveTriggerHandler.isFirstTime){
            RecursiveTriggerHandler.isFirstTime = false;
            List<WorkOrder> listWO=new List<WorkOrder>();
            Set<String> idsOpps=new Set<String>();
            for(WorkOrder wo : newList){
                idsOpps.add(wo.Oportunidad__c);
            }
            Map<String,Opportunity> mapOpps=AsignacionesOT.getUsersOpps(idsOpps);
            for(WorkOrder wo : newList){                
                if(oldMap.get(wo.Id).Estatus__c == 'Pedido de tarjetas' && wo.Estatus__c == 'Capacitación' && mapOpps.containsKey(wo.Oportunidad__c) && mapOpps.get(wo.Oportunidad__c).Owner.Segmento__c=='Small'   &&  (mapOpps.get(wo.Oportunidad__c).Familia__c   == 'Combustible' || mapOpps.get(wo.Oportunidad__c).Familia__c == 'Empresarial') ){
                    listWO.add(wo);
                }
            }
            
            new AsignacionesOT(listWO,mapOpps,'capacitacion');
        }
    }
    /**
		* @author sreyna@ctconsulting.com.mx
		* @date 04/04/2018
		* @param newList de OTs 
		* @description Método para verificar si todas las OT's de una oportunidad son concluidas, entonces actualizar la Opp a Ganada
	*/
  	public void verificaOTsConcluidas(Map<Id, WorkOrder> newMap){
        System.debug('**********************ENTRA verificaOTsConcluidas');
        //Set de Ids de Oportunidades relacionadas a las OT's
        Set<Id> oppsOT = new Set<Id>();
        for(WorkOrder ot : [Select Id, Estatus__c, Oportunidad__c from WorkOrder where Id in: newMap.keySet()]){
            if(ot.Estatus__c =='Concluida'){
                oppsOT.add(ot.Oportunidad__c);
            }
        }
        
        System.debug('*****************oppsOT:'+oppsOT);
        if(oppsOT.size() > 0){
            //Consulta las OT's relacionadas a las Oportunidades que se encontraron previamente
            Map<Id,List<WorkOrder>> mapOppOTs = new Map<Id,List<WorkOrder>>();
            Set<Id> otsFilial = new Set<Id>();
            Set<Id> otsValidaFilial = new Set<Id>();
            for(WorkOrder ot : [Select Id, Estatus__c, Oportunidad__c, Ot_Principal__c from WorkOrder where Oportunidad__c in: oppsOT]){
                if(ot.OT_Principal__c && ot.Estatus__c != 'Cancelada'){
                	if(mapOppOTs.containsKey(ot.Oportunidad__c)){
                        mapOppOTs.get(ot.Oportunidad__c).add(ot);
                    }else{
                        List<WorkOrder> otsList = new List<WorkOrder>();
                        otsList.add(ot);
                        mapOppOTs.put(ot.Oportunidad__c, otsList);
                    }
                }
                else{
                    otsFilial.add(ot.Id);
                }
            }
            
            System.debug('********************mapOppOTs:'+mapOppOTs);
            System.debug('********************otsFilial:'+otsFilial);

            if(otsFilial.size() > 0){

                //Se busca la relación OT-Contrato para identificar las Ot's validas
                for(ContratoFilial__c contratosF : [Select Id, Orden_de_trabajo__c from ContratoFilial__c where Orden_de_trabajo__c in: otsFilial]){
                    otsValidaFilial.add(contratosF.Orden_de_trabajo__c);
                }
				
                System.debug('***********************otsValidaFilial:'+otsValidaFilial);
                
                if(otsValidaFilial.size() > 0){
                
                    for(WorkOrder ot : [Select Id, Estatus__c, Oportunidad__c, Ot_Principal__c from WorkOrder where Id in: otsValidaFilial]){
                    	if(mapOppOTs.containsKey(ot.Oportunidad__c)){
                            mapOppOTs.get(ot.Oportunidad__c).add(ot);
                        }else{
                            List<WorkOrder> otsList = new List<WorkOrder>();
                            otsList.add(ot);
                            mapOppOTs.put(ot.Oportunidad__c, otsList);
                        }
                    }
                   
                    
                }
            }

            if(mapOppOTs.size() > 0){

                System.debug('********************+mapOppOTs:'+mapOppOTs);
                    
                //Se Verifica que todas las Ot's relacionadas esten concluidas de no ser el caso, se excluye la opp y no se actualiza a Ganada
                List<Opportunity> oppsToUpdate = new List<Opportunity>();
                for(Id opp: mapOppOTs.keySet()){
                    Boolean flagEstatusConcluida = true;
                    Boolean hasOTPrincipalConcluida = false;
                    for(WorkOrder ot : mapOppOTs.get(opp)){
                        if(ot.Estatus__c != 'Concluida'){
                            flagEstatusConcluida = false;
                        }
                        if(ot.Estatus__c == 'Concluida' && ot.OT_Principal__c ==true){
                            hasOTPrincipalConcluida = true;
                        }
                    }
                    
                    System.debug('**********************flagEstatusConcluida:'+flagEstatusConcluida);
                    System.debug('**********************hasOTPrincipalConcluida:'+hasOTPrincipalConcluida);
                    
                    if(flagEstatusConcluida && hasOTPrincipalConcluida){
                        Opportunity oppGanada = new Opportunity();
                        oppGanada.Id = opp;
                        oppGanada.StageName = 'Ganada';
                        oppsToUpdate.add(oppGanada);
                    }
                }
                
                if(oppsToUpdate.size()>0){
                    System.debug('*********************oppsToUpdate:'+oppsToUpdate);
                    update oppsToUpdate;
                }

            }
        }
    }
}