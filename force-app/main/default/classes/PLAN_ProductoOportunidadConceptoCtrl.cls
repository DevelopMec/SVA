public without sharing class PLAN_ProductoOportunidadConceptoCtrl {

	public List<ProductoConcepto__c> productos {
		get {
			if(productos == null && String.isNotBlank(oli.PartidaPresupuesto__c)) {
				productos = [SELECT Id, Concepto__r.TipoCargo__c, Concepto__r.Name, Bonificacion__c, PrecioLista__c, PrecioFinal__c FROM ProductoConcepto__c WHERE PartidaPresupuesto__c =: oli.PartidaPresupuesto__c];
			}
			return productos;
		}

		private set;
	}

	public OpportunityLineItem oli {get; set;}

	public PLAN_ProductoOportunidadConceptoCtrl(ApexPages.StandardController ctrl) {
		oli = (OpportunityLineItem) ctrl.getRecord();
		if(oli != null && oli.Id != null) {
			oli = [SELECT Id, PartidaPresupuesto__c FROM OpportunityLineItem WHERE Id =: oli.Id];
		}
	}
}