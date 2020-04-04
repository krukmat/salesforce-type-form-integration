public with sharing class TypeFormCallout {
  public static final String urlForm = 'https://api.typeform.com/forms/';
  // personal token stored in MDT	
  private static final String personalToken = [SELECT Personal_token__c  FROM TypeForm_Settings__mdt][0].Personal_token__c;  
  private static final String header = 'Bearer '+personalToken;  
  // Pass in the endpoint to be used using the string url
  public static String getCalloutResponseContents(String url) {

    // Instantiate a new http object
    Http h = new Http();

     // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', header);  
    req.setHeader('Content-Type','application/json');
    req.setHeader('accept','application/json');
    req.setEndpoint(url);
    req.setMethod('GET');

    // Send the request, and return a response
    HttpResponse res = h.send(req);
    return res.getBody();
  }
}