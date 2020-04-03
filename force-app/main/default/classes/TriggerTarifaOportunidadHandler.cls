public with sharing class TriggerTarifaOportunidadHandler  extends TriggerHandler{
    private Map<Id, TarifaOportunidad__c> newMap;
	private Map<Id, TarifaOportunidad__c> oldMap;
	private List<TarifaOportunidad__c> newList;
	private List<TarifaOportunidad__c> oldList;

	public TriggerTarifaOportunidadHandler() {
		this.newMap = (Map<Id, TarifaOportunidad__c>) trigger.newMap;
		this.oldMap = (Map<Id, TarifaOportunidad__c>) trigger.oldMap;
		this.newList = (List<TarifaOportunidad__c>) trigger.new;
		this.oldList = (List<TarifaOportunidad__c>) trigger.old;
	}
	
	public override void beforeInsert(){
		// OportunidadId+TarifaOportundiad__r.ClaveReferencia__c,
		for(TarifaOportunidad__c tarifaOportunidad: this.newList){
          	Producto__c producto = [Select NumeroProducto__c from Producto__c where Id =:tarifaOportunidad.Producto__c Limit 1];
            tarifaOportunidad.IdentificadorTarifaOportunidad__c=(tarifaOportunidad.Oportunidad__c != null ?tarifaOportunidad.Oportunidad__c :'')+'-'+(tarifaOportunidad.ClaveReferencia__c!=null?tarifaOportunidad.ClaveReferencia__c:'').trim()+'-'+(producto.NumeroProducto__c!=null?String.valueOf(producto.NumeroProducto__c):'').trim();
            
        }
		
	}
	
}