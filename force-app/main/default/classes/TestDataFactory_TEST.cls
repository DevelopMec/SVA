@isTest
public class TestDataFactory_TEST {
	
    public static Event createEvent() {
        Opportunity opp = new Opportunity(Name = 'Opportunity - Test', StageName = 'Cotizacion', CloseDate = System.today().addMonths(1));
		Upsert opp;
		Event e = new Event();
		e.DurationInMinutes = 60;
        e.WhatId=opp.Id;
		e.ActivityDateTime = DateTime.now();
		insert e;
		return e;
    }
	
    public static Opportunity createOpportunity() {
		Opportunity opp = new Opportunity(Name = 'Opportunity - Test', StageName = 'Cotizacion', CloseDate = System.today().addMonths(1));
		Upsert opp;
		return opp;
	}

	  public static Opportunity createOpportunity2() {
		Opportunity opp = new Opportunity(Name = 'Opportunity - 3', StageName = 'Cotizacion', CloseDate = System.today().addMonths(2));
		Upsert opp;
		return opp;
	}
	
    public static Contact createContact() {
		Contact con = new Contact(LastName = 'Contact - Test');
		insert con;
		return con;
	}
	
	public static Account createAccount() {
		Account acc = new Account(Name = 'Account - Test', NumeroEmpleados__c = '1-25');
        insert acc;
        return acc;
	}
	
	public static Attachment createAttachment(Id parentId) {
		Attachment attach = new Attachment(ParentId = parentId, Name = 'Attachment - Test', Body = Blob.valueOf(''));
		insert attach;
		return attach;
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
	
	public static QuoteDocument createQuoteDocument(Id quoId, String attachmentBody) {
		// ContentVersion cv = new ContentVersion(title = 'ContentVersion - Test', PathOnClient = 'ContentVersion - Test.pdf');
		// insert cv;
        // cv.VersionData = Blob.valueOf('/services/data/v42.0/sobjects/ContentVersion/' + cv.Id + '/VersionData');
        // update cv;
		// QuoteDocument qd = new QuoteDocument(QuoteId = quoId, Document = attachBody, ContentVersionDocumentId = cv.Id);
		QuoteDocument qd = new QuoteDocument(QuoteId = quoId, Document = Blob.toPdf(attachmentBody));
		insert qd;
		return qd;
	}
}