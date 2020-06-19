@isTest
private class QuoteTriggerTest {

	@isTest
	static void testQuote() {

		Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true, ProductCode = '222', SendToSIGLO__c = true, IDInterno__c = '29');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Account acc = new Account(Name = 'test');
        insert acc;

        Opportunity oppFisica = new Opportunity(Name = 'oppFisica', StageName = 'Contrato', CloseDate = Date.Today(), Account = acc);
        insert oppFisica;

        Quote quoteFisica = new Quote(Name = 'test', OpportunityId = oppFisica.Id, Pricebook2Id = pricebookId, OperationsInDollars__c = 'Sí', TransactionsEstimatedNumber__c = 7);
        insert quoteFisica;

        quoteFisica.TransactionsEstimatedNumber__c = 2;
        update quoteFisica;


	}

}