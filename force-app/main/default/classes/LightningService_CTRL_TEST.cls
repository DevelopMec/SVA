@IsTest public class LightningService_CTRL_TEST {

	@isTest
	static void executeQuery() {

		LightningService_CTRL.executeQuery('SELECT Id, Name FROM Quote');

		LightningService_CTRL.describeSObjects(new String[]{'Account', 'Contact'});

		LightningService_CTRL.upsertObject('Contact', '[{"LastName": "Test"}]');

		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		LightningService_CTRL.saveAttachment( opp.Id, 'Test data', 'fileName', 'application/pdf', '');
	}

}