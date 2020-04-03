public class CreditEvaluation {
/*
     @AuraEnabled
    public static Map<String,String> getDatos(string idOportunidad){
        Map<String,string> res=new Map<String,string>();
        FOR (Opportunity opp : [SELECT Account.Name, Producto_cotizacion__c, Account.CodigoClienteAS400__c, Account.Sector__c, IsApprovedCreditEval__c FROM Opportunity WHERE Id =: idOportunidad]){
        	res.put('NombreCliente',opp.Account.Name);
            res.put('Producto',opp.Producto_cotizacion__c);
            res.put('NumCliente',opp.Account.CodigoClienteAS400__c);
            res.put('Sector',opp.Account.Sector__c);
             res.put('ProcesoAprobacion',opp.IsApprovedCreditEval__c);
        }
        
        FOR (Contrato2__c contrato : [SELECT Id, Periodo_Liberacion__c, Linea_Operativa__c, Dias_credito__c, Porcentaje_Comision__c, Garantia_Negociando__c FROM Contrato2__c WHERE PartidaPresupuesto__r.Quote.Opportunity.Id =:  idOportunidad LIMIT 1]){
           res.put('LineaOperativa',contrato.Linea_Operativa__c);
            res.put('FrecuenciaFacturacion',contrato.Periodo_Liberacion__c);
            res.put('DiasCredito',string.valueOf(contrato.Dias_credito__c));
            res.put('PorcComision',string.valueOf(contrato.Porcentaje_Comision__c));
            res.put('GarantiaNegociando',string.valueOf(contrato.Garantia_Negociando__c));
        }
        
        return res;
    }
   
    @AuraEnabled
    public static void GuardarDatos(string idOportunidad, string periodoLiberacion, decimal lineaOperativa, decimal diasCredito, decimal PorcComision, string garantiaNegociando, boolean Aprobar){
        Contrato2__c contrato = [SELECT Id FROM Contrato2__c WHERE PartidaPresupuesto__r.Quote.Opportunity.Id =:  idOportunidad LIMIT 1];
        
        if (contrato != null){
        	contrato.Periodo_Liberacion__c = periodoLiberacion;
            contrato.Linea_Operativa__c = string.valueOf(lineaOperativa);
            contrato.Dias_credito__c = diasCredito;
            contrato.Porcentaje_Comision__c = PorcComision;
            contrato.Garantia_Negociando__c = garantiaNegociando;
            update contrato;
        }
        
        if (Aprobar){
            Opportunity Opp = [SELECT 	IsApprovedCreditEval__c FROM Opportunity Where Id =: idOportunidad];
            Opp.IsApprovedCreditEval__c = 'En Proceso';
            update Opp;
        }
        
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> getOppAttachments(Id oppId) {
		List<ContentDocumentLink> oppAttachments = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :oppId];		
        return oppAttachments;
	}
    
    @AuraEnabled
	public static Object updateDocAndOpp(Id documentId, String newTitle, Id oppId, String oppFieldName) {
		ContentDocument doc = [SELECT Id, Title FROM ContentDocument WHERE Id = :documentId];
		doc.Title = newTitle;
		Database.SaveResult updateResult = Database.update(doc);
		Map<String, Object> mapUpdateResult = new Map<String, Object>();
		mapUpdateResult.put('errors', updateResult.getErrors());
		mapUpdateResult.put('id', updateResult.getId());
		mapUpdateResult.put('isSuccess', updateResult.isSuccess());
		return mapUpdateResult;
	}
    
    @AuraEnabled
	public static Object deleteDocUpdateOpp(Id oldDocId, Id oppId) {
		Database.DeleteResult deleteResult = Database.delete(oldDocId);
		Map<String, Object> mapDeleteResult = new Map<String, Object>();
		mapDeleteResult.put('errors', deleteResult.getErrors());
		mapDeleteResult.put('id', deleteResult.getId());
		mapDeleteResult.put('isSuccess', deleteResult.isSuccess());
		return mapDeleteResult;
	}*/
}