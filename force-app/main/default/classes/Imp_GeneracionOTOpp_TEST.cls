@IsTest
public class Imp_GeneracionOTOpp_TEST {

    @isTest
    public static void method1(){
        Map<String, Object>  data = (Map<String, Object> )createQuoteLineItem();
        
        Opportunity opp = (Opportunity)data.get('Opportunity');
        Quote cotizacion = (Quote)data.get('Quote');
        QuoteLineItem partida = (QuoteLineItem)data.get('QuoteLineItem');
        Product2 producto = (Product2)data.get('Product2');
        
        opp.SyncedQuoteId = cotizacion.Id;
        opp.CodigoClienteAS400__c = 'As400';
        opp.StageName = 'Implementación';
        
        //producto.ProductCode = '60D';
        //update producto;
            
        partida.Escalonamiento1__c = false;
        partida.CantidadTarjetas__c = 10;
        update partida;
        
        Attachment attOpp = new Attachment (parentId = opp.Id, Name = 'Contrato o Propuesta firmados', Body = Blob.valueOf('Blah Blah'));
        insert attOpp;
        
        Contrato2__c contratoOpp = new Contrato2__c(PartidaPresupuesto__c = partida.Id, CodigoAs400__C = '11-11-12345-123');
        insert contratoOpp;
        
        Test.startTest();
        	update opp;
        	System.debug(opp);
        Test.stopTest();
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
        
        Product2 p2 = new Product2(Name = 'Product2 - Test', IsActive = true, ProductCode = '60D');
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