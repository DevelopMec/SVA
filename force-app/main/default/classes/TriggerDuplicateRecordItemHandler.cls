public with sharing class TriggerDuplicateRecordItemHandler extends TriggerHandler {

	/**
		* @author: Carlos Álvarez
		* @description: Controlador que actualiza un Lead duplicado, aplicando reglas de asignación, su ejecución es en futuro, por lo tanto, los debug no se pueden visualizar en consola, evitar System.debug
		* @date: 15-02-2017
	*/
	private List<DuplicateRecordItem> newList;
    private Map<Id, DuplicateRecordItem> newMap;
    
    public TriggerDuplicateRecordItemHandler() {
		this.newList = (List<DuplicateRecordItem>) trigger.new;
        this.newMap = (Map<Id, DuplicateRecordItem>) trigger.newMap;
    }

    /**
		* @author: Carlos Álvarez
		* @description: Método que identifica el registro original cuando el tamaño de DuplicateRecordSet.DuplicateRecordItems es 0
		* @date: 22-02-2017
		* @param: 
		* @return void
	*/
	public override void beforeInsert() {
		List<Id> ids = new List<Id>();
		for(DuplicateRecordItem item : newList) {
			ids.add(item.DuplicateRecordSetId);
		}
		List<DuplicateRecordSet> aux = [SELECT Id, (SELECT Id, RecordId, CreatedDate FROM DuplicateRecordItems ORDER BY CreatedDate DESC) FROM DuplicateRecordSet WHERE Id IN: ids];
		for(DuplicateRecordSet drs : aux) {
			Integer counter = 0;
			for(DuplicateRecordItem item : newList) {
				if(drs.DuplicateRecordItems.size() == 0 && drs.Id == item.DuplicateRecordSetId) {
					//Vamos a insertar original
					if (counter == 1) {
						item.Original__c = true;
					}
					counter++;
				}
			}
		}
		
	}

	/**
		* @author: Carlos Álvarez
		* @description: Método que obtiene los Leads duplicados y actualiza con reglas de asignación
		* @date: 15-02-2017
		* @param: 
		* @return void
	*/
	public override void afterInsert() {
		List<Lead> leads = new List<Lead>();
		List<Id> ids = new List<Id>();

		for(List<DuplicateRecordItem> duplicados: [SELECT Id, RecordId, DuplicateRecordSetId, CreatedDate FROM DuplicateRecordItem WHERE Original__c=false AND Id IN: newMap.keySet()]) {
			for(DuplicateRecordItem item : duplicados) {
				//Verificar que el registro de DuplicateRecordItem insertado es de tipo Lead
				if(item.RecordId != null && item.RecordId.getSObjectType() == Schema.Lead.SObjectType) {
					ids.add(item.RecordId);
				}
			}
		}

		//Validar que se encontraron ids de Prospectos duplicados que vienen de HubSpot
		if(ids != null && ids.size() > 0) {
			for(Lead leadAux : [SELECT Id FROM Lead WHERE EstadoHubSpot__c != null AND Id IN: ids]) {
				leads.add(new Lead(Id = leadAux.Id, Duplicados__c = true));
			}
		}

		//Validar que exista regla de asignación y que se encontraron Leads duplicados
		List<AssignmentRule> regla = [SELECT Id, Name FROM AssignmentRule WHERE SobjectType = 'Lead' AND Name= 'AsignacionLeadsSmall' AND Active = true];
		if(regla != null && regla.size() > 0 && leads != null && leads.size() > 0) {
			Database.DMLOptions dmlOpts = new Database.DMLOptions();
			dmlOpts.assignmentRuleHeader.assignmentRuleId = regla[0].Id;
			Database.update(leads, dmlOpts);  
		}
	}
}