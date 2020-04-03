public class ListaAs400_CONT {
	@AuraEnabled
    public static List<ContratoFilial__c> getDatos(String recordId){
        List<ContratoFilial__c> res=[Select CodigoAS400__c, Entidad_Cuenta__r.EntidadLegal__r.Name,Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c from ContratoFilial__c where Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId=:recordId];
        return res;
    }
}