public without sharing class UTIL_AsignacionLeadReglas {

	public void doProcess(List<Lead> leads, Map<Id, Lead> newMap) {
		if(leads != null) {
			List<Lead> reglas = new List<Lead>();
			for(Lead lead_aux : [SELECT Id, EstadoHubSpot__c FROM Lead WHERE Id IN:newMap.keySet()]) {
				if(lead_aux.EstadoHubSpot__c != null) {
					reglas.add(lead_aux);
				}
			}
			//Asignar por regla de asignación
			List<AssignmentRule> regla = [SELECT Id, Name FROM AssignmentRule WHERE SobjectType = 'Lead' AND Name= 'AsignacionLeadsSmall' AND Active = true];
			if(regla != null && regla.size() > 0 && reglas.size() > 0) {
				Database.DMLOptions dmlOpts = new Database.DMLOptions();
				dmlOpts.assignmentRuleHeader.assignmentRuleId = regla[0].Id;
				Database.update(reglas, dmlOpts);  
			}
		}
	}
	/*
	public void doUpdateAccount(Map<Id, Lead> oldMap, List<Lead> leads) {
		if(oldMap != null && leads != null) {
			Map<Id, Account> accounts = new Map<Id, Account>();
			for(Lead aux : leads) {
				if(oldMap.containsKey(aux.Id) && String.isBlank(String.valueOf(oldMap.get(aux.Id).ConvertedAccountId)) && String.isNotBlank(String.valueOf(aux.ConvertedAccountId)) && !accounts.containsKey(aux.ConvertedAccountId)) {
					//accounts.put(aux.ConvertedAccountId, new Account(Id = aux.ConvertedAccountId, AccountSource = aux.LeadSource, SubOrigen__c = aux.SubOrigen__c));
					accounts.put(aux.ConvertedAccountId, new Account(Id = aux.ConvertedAccountId, Description = aux.Description));
				}
			}
			if(accounts.size() > 0) {
				update accounts.values();
			}
		}
	}
	*/
}