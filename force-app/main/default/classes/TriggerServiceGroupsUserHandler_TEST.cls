@isTest
public class TriggerServiceGroupsUserHandler_TEST {
    @testSetup
    public static void setup(){
        ServiceGroups__c sg=new ServiceGroups__c();
        sg.Name='test';
        insert sg;
        ServiceGroups__c sg2=new ServiceGroups__c();
        sg2.Name='test2';
        insert sg2;
        User u=[Select Id from User limit 1];
        ServiceGroupsUser__c sgu=new ServiceGroupsUser__c();       
        sgu.ServiceGroup__c=sg.Id;
        sgu.User__c=u.Id;
        insert sgu;
    }
    @isTest
    public static void testTriggerServiceGroups(){
        ServiceGroupsUser__c sgu=[Select Id from ServiceGroupsUser__c limit 1];
        ServiceGroups__c sg=[Select Id from ServiceGroups__c where Name='test2'];
        sgu.ServiceGroup__c=sg.Id;
        update sgu;
        delete sgu;
    }
}