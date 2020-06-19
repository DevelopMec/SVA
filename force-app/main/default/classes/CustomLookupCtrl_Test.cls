/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @creation	25/03/2020 	Coverage to class CustomLookupCtrl.
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public without sharing class CustomLookupCtrl_Test {
    
    @testSetup static void setup() {
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Ventas' LIMIT 1];
        List<User> testUsers = new List<User>();
        User u = new User(FirstName = 'LookUpUser1' , LastName = 'last', Email = 'usertestadmin@amamama.com', Username = 'usertestadmin@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        User u2 = new User(FirstName = 'LookUpUser2', LastName = 'last2', Email = 'usertestadmin2@amamama.com', Username = 'usertestadmin2@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias2', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        testUsers.add(u);
        testUsers.add(u2);
        insert testUsers;
    }

    @isTest
    static void fetchLookupValuesTest() {
        User userToRun = [SELECT Id FROM User WHERE Alias = 'alias2'];
        System.runAs(userToRun){
            Test.startTest();
            	List<sObject> searchedUsers = CustomLookupCtrl.fetchLookupValues('LookUpUser', 'User');
            Test.stopTest();
            System.debug(searchedUsers);
            System.assert(searchedUsers.size() == 2 ,'The class return the two users inserted in the test class.');
        }
    }
    
    @isTest
    static void fetchLookupValuesForEconomicActivity() {
        User userToRun = [SELECT Id FROM User WHERE Alias = 'alias2'];
        System.runAs(userToRun){
            Test.startTest();
            	List<sObject> searchedUsers = CustomLookupCtrl.fetchLookupValues('ABARROTES', 'EconomicActivity__c');
            Test.stopTest();
            System.debug(searchedUsers);
            System.assert(searchedUsers.isEmpty(),'The class return an empty list because we did not insert EconomicActivity__c records in the test class.');
        }
    }
}