@isTest
public class NotificarModificacionImplementacion_TEST {
	@isTest(SeeAllData=true)
    public static void metodo1(){
        Opportunity opp=[Select Id from Opportunity where StageName='Implementación' limit 1];
        /*Account acc=new Account();
        acc.Name='test';
        insert acc;              
        
        Opportunity opp=new Opportunity();
        opp.AccountId=acc.Id;
        opp.Name='test';
        opp.CloseDate=Date.today();
        opp.StageName='Cotización';
        insert opp;
        
        Quote q=new Quote();
        q.OpportunityId=opp.Id;
        q.Name='test';
        insert q;
        
        QuoteLineItem qli=new QuoteLineItem();
        qli.CantidadTarjetas__c=2;
        qli.QuoteId=q.Id;
        insert qli;
        
        WorkOrder wo=new WorkOrder();
        wo.Oportunidad__c=opp.Id;
        insert wo;*/
        List<Opportunity> lo=new List<Opportunity>{opp};
        NotificarModificacionImplementacion.notificarCambio(lo);
    }
}