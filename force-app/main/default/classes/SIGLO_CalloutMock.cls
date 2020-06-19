global class SIGLO_CalloutMock implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest request) {
      // Create a fake response
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      response.setBody('{"test": ["test test"]}');
      response.setStatusCode(200);
      return response; 
  }
    
}