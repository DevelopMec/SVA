@IsTest
private class CON_OppDocChecklist_TEST {
	
	@IsTest
    static void saveAttachmentTest() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
        Id idAttach = CON_OppDocChecklist_CTRL.saveAttachment(opp.Id, 'attachmentName', 'attachmentBody', 'ActaConstitutivaCliente__c');
	}
	
	@IsTest
    static void deleteAttachmentTest() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity2();
		Attachment attach = TestDataFactory_TEST.createAttachment(opp.Id);
		Id idAttach = CON_OppDocChecklist_CTRL.deleteAttachment(attach.Id, opp.Id, 'ActaConstitutivaCliente__c');
	}
	
	@IsTest
    static void updateAttachmentTest() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		Attachment attach = TestDataFactory_TEST.createAttachment(opp.Id);
		CON_OppDocChecklist_CTRL.updateAttachment(attach.Id, 'attachmentBody');
	}
	
	@IsTest
    static void getOppAttachmentsTest() {
        Opportunity opp = TestDataFactory_TEST.createOpportunity();
		List<ContentDocumentLink> listAttach = CON_OppDocChecklist_CTRL.getOppAttachments(opp.Id);
	}
	
	@IsTest(seeAllData=true)
    static void getDocsByTypePersonTest() {
		Map<String, Object> mapDtp = CON_OppDocChecklist_CTRL.getDocsByTypePerson();
	}
	
	// Using a valid Opportunity Id
	@IsTest(seeAllData=true)
	static void getEmployerRegistrationDataTest1() {
        Opportunity opp = TestDataFactory_TEST.createOpportunity();
		Map<String, Object> mapErd = (Map<String, Object>)CON_OppDocChecklist_CTRL.getEmployerRegistrationData(opp.Id);
	}
	
	// Using an invalid Id
	@IsTest(seeAllData=true)
	static void getEmployerRegistrationDataTest2() {
		try {
			Map<String, Object> mapErd = (Map<String, Object>)CON_OppDocChecklist_CTRL.getEmployerRegistrationData(null);
		} catch(System.Exception e) {}
	}
	
	@IsTest
    static void getRelatedAccountInformationTest() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		Opportunity oppRai = (Opportunity)CON_OppDocChecklist_CTRL.getRelatedAccountInformation(opp.Id);
	}
	
	@IsTest
    static void getContactLegalRepresentativeTest() {
        Opportunity opp = TestDataFactory_TEST.createOpportunity();
		List<Opportunity> listOpp = (List<Opportunity>)CON_OppDocChecklist_CTRL.getContactLegalRepresentative(opp.Id);
	}
    
    @IsTest
    static void updateDocAndOppTest() {
        Opportunity oppTestRecord = TestDataFactory_TEST.createOpportunity();
        ContentVersion cvTestRecord = new ContentVersion(Title = 'Content Version Title', PathOnClient = 'Content Version Title.pdf', VersionData = Blob.toPdf('Version Data'));
        insert cvTestRecord;
        ContentDocument cdTestRecord = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cvTestRecord.Id LIMIT 1];
        Map<String, Object> mapTestResults = (Map<String, Object>)CON_OppDocChecklist_CTRL.updateDocAndOpp(cdTestRecord.Id, 'Content Document Title', oppTestRecord.Id, 'AdjuntoA__c');
        System.assertEquals(0, ((Database.Error[])mapTestResults.get('errors')).size());
        System.assertNotEquals('', ((Id)mapTestResults.get('id')));
        System.assertEquals(true, ((Boolean)mapTestResults.get('isSuccess')));
    }
    
    @IsTest
    static void deleteDocUpdateOppTest() {
        Opportunity oppTestRecord = TestDataFactory_TEST.createOpportunity();
        ContentVersion cvTestRecord = new ContentVersion(Title = 'Content Version Title', PathOnClient = 'Content Version Title.pdf', VersionData = Blob.toPdf('Version Data'));
        insert cvTestRecord;
        ContentDocument cdTestRecord = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cvTestRecord.Id LIMIT 1];
        Map<String, Object> mapTestResults = (Map<String, Object>)CON_OppDocChecklist_CTRL.deleteDocUpdateOpp(cdTestRecord.Id, oppTestRecord.Id, 'AdjuntoA__c');
        System.assertEquals(0, ((Database.Error[])mapTestResults.get('errors')).size());
        System.assertNotEquals('', ((Id)mapTestResults.get('id')));
        System.assertEquals(true, ((Boolean)mapTestResults.get('isSuccess')));
    }
}