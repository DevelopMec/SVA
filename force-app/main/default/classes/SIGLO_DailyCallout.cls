public class SIGLO_DailyCallout {
    
    public static HttpResponse postCallout(String JSONBody) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('test');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSONBody);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        return response;
    }        
}