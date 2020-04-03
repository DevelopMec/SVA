public class EscalonamientosOportunidad_CONT {
	@AuraEnabled
    public static List<QuoteLineItem> getDatos(String recordId){
        List<QuoteLineItem> res=[Select id,UnitPrice,ServiceDate,Escalonamiento__c,Quote.OpportunityId,Quote.Opportunity.StageName,Quote.Opportunity.CloseDate from QuoteLineItem where Quote.OpportunityId=:recordId and Quote.IsSyncing=true order by CreatedDate ASC];
        if(res.size()==1){
            res[0].ServiceDate=res[0].Quote.Opportunity.CloseDate;
        }
        return res;
    }
    
    @AuraEnabled
    public static void guardarDatos(String info,String comentarios){
        List<QuoteLineItem> listUpdate=(List<QuoteLineItem>)JSON.deserialize(info, List<QuoteLineItem>.class);
        QuoteLineItem tem=new QuoteLineItem();
        for(QuoteLineItem qli:listUpdate){
            if(qli.Escalonamiento__c==null){
                tem=qli;
            }
        }
        Opportunity opp=new Opportunity();
        opp.Id=tem.Quote.OpportunityId;
        opp.ComentariosEtapaImplementacion__c=comentarios;
        opp.CloseDate=tem.ServiceDate;
        update listUpdate;
        update opp;
    }
}