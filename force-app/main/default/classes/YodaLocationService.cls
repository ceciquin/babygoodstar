public class YodaLocationService {

    @AuraEnabled(cacheable=true)
    public static String getRequestYodaLocation(String accessCode) {
        // Initialize an HTTP request object
        HttpRequest req = new HttpRequest();
        // Set the endpoint using Named Credential 'YodaAPI' and include the accessCode in the path
        req.setEndpoint('callout:YodaAPI/request-yoda-location/' + EncodingUtil.urlEncode(accessCode, 'UTF-8'));
        req.setMethod('GET');
        // Set headers if required, for example, Content-Type
        req.setHeader('Content-Type', 'application/json');

        // Initialize the HTTP object to send the request
        Http http = new Http();
        try {
            // Send the request and receive the response
            HttpResponse res = http.send(req);
            // Check if the response status is 200 OK
            if (res.getStatusCode() == 200) {
                // Return the response body if the call was successful
                return res.getBody();
            } else {
                // Log and return error information if the call was not successful
                System.debug('Error in getRequestYodaLocation: ' + res.getBody());
                return null; // Or handle errors as appropriate
            }
        } catch (Exception e) {
            // Handle any exceptions that occur during the API call
            System.debug('Exception in getRequestYodaLocation: ' + e.getMessage());
            return null; // Or handle exceptions as appropriate
        }
    }
}