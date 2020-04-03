public with sharing class TriggerBonificacionEscalonamientoHandler  extends TriggerHandler{
    private Map<Id, BonificacionEscalonamiento__c> newMap;
	private Map<Id, BonificacionEscalonamiento__c> oldMap;
	private List<BonificacionEscalonamiento__c> newList;
	private List<BonificacionEscalonamiento__c> oldList;

	public TriggerBonificacionEscalonamientoHandler() {
		this.newMap = (Map<Id, BonificacionEscalonamiento__c>) trigger.newMap;
		this.oldMap = (Map<Id, BonificacionEscalonamiento__c>) trigger.oldMap;
		this.newList = (List<BonificacionEscalonamiento__c>) trigger.new;
		this.oldList = (List<BonificacionEscalonamiento__c>) trigger.old;
	}
	
	public override void beforeInsert(){
		// OportunidadId+TarifaOportundiad__r.ClaveReferencia__c,
		for(BonificacionEscalonamiento__c bonificacionEscalonamiento: this.newList){
          //	Producto__c producto = [Select NumeroProducto__c from Producto__c where Id =:tarifaOportunidad.Producto__c Limit 1];
            bonificacionEscalonamiento.IdentificadorBonificacionEscalonamiento__c=(String.valueOf(bonificacionEscalonamiento.RecordTypeId))+'-'+(bonificacionEscalonamiento.TarifaOportunidad__C != null ?bonificacionEscalonamiento.TarifaOportunidad__C :'')+'-'+
                (bonificacionEscalonamiento.fechaInicio__c!=null?(String.valueOf(bonificacionEscalonamiento.fechaInicio__c)):(String.valueOf(bonificacionEscalonamiento.ValorPorcentual__c)));
            
        }
		
	}
	
}