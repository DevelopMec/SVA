@isTest
public without sharing class SIGLO_CalloutTest {

    @isTest 
    static void testSIGLO_DailyCallout() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SIGLOCalloutTest');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        HttpResponse result = SIGLO_DailyCallout.postCallout('Test');
               
    }

  }