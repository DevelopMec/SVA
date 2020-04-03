public class OpenContract {
    
    @AuraEnabled 
    public static QuoteLineItem  getQuoteItemId(String idOportunidad){
       Quote cotizacion= [SELECT ID  FROM Quote WHERE OpportunityId=:idOportunidad and IsSyncing=true LIMIT 1  ];
       QuoteLineItem Cotizaciones=[SELECT Id,Product2.ProductCode,Product2.IDInterno__c,Quote.Opportunity.StageName   FROM QuoteLineItem WHERE QuoteId=:cotizacion.id and Escalonamiento__c=null LIMIT 1];         
       return Cotizaciones;
    }

}