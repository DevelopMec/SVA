@isTest
public class TriggerHandlerContrato2_TEST {
    @isTest
    static void getContratoTest2() {
        Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)createQuoteLineItem();
        QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
        Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=true,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2;
        c2.TipoPago__c='Prepago';
        update c2;
        Contrato2__c c2f = new Contrato2__c(PartidaPresupuesto__c = qli.Id,ManejaAutoconsumo_Checkbox__c=false,CuotaMensual_Currency__c=1,CuotaLitros_Currency__c=2);
        insert c2f;
        c2f.TipoPago__c='Pospago';
        update c2f;
    }
    public static Object createQuoteLineItem() {
        Map<String, Object> mapOppQuoP2PeQli = new Map<String, Object>();
        Opportunity opp = new Opportunity(Name = 'Opportunity - 1', StageName = 'Cotizacion', CloseDate = System.today().addMonths(1));
        insert opp;
        mapOppQuoP2PeQli.put('Opportunity', opp);
        Id p2Id = Test.getStandardPricebookId();
        Quote quo = new Quote(Name = 'Quote - Test', OpportunityId = opp.Id, Pricebook2Id = p2Id);
        insert quo;
        mapOppQuoP2PeQli.put('Quote', quo);
        
        Product2 p2 = new Product2(Name = 'Product2 - Test', IsActive = true, ProductCode = '30-TC4');
        insert p2;
        mapOppQuoP2PeQli.put('Product2', p2);
        
        PricebookEntry pe = new PricebookEntry(UnitPrice = 1000.00, Pricebook2Id = p2Id, Product2Id = p2.Id, UseStandardPrice = false, IsActive = true);
        insert pe;
        mapOppQuoP2PeQli.put('PricebookEntry', pe);
        
        QuoteLineItem qli = new QuoteLineItem(PricebookEntryId = pe.Id, Quantity = 1, UnitPrice = 1000.00, Product2Id = p2.Id, QuoteId = quo.Id);
        insert qli;
        mapOppQuoP2PeQli.put('QuoteLineItem', qli);
        return mapOppQuoP2PeQli;
    }
}