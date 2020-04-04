@isTest
global class TypeFormCalloutMockHttp implements HttpCalloutMock {
    // Implement this interface method
	global String jsonBody;    
    private static final String formsResponse = '{"id":"Q7dTxN","title":"FORMCONF REGISTRATION FORM 2","fields":[{"id":"JGrpx4odt20t","title":"What is your name? ","ref":"af327bc4-92f2-44b0-880d-61d7f90fb12e","validations":{"required":false},"type":"short_text"},{"id":"C73LSWWt41ci","title":"Rate your satisfaction with Netflix services.","ref":"9e97aaa8-340e-40fd-8bab-57331f3e9136","properties":{"steps":11,"start_at_one":false},"validations":{"required":false},"type":"opinion_scale"},{"id":"rBCqgDmCQta1","title":"Do you like scape rooms?","ref":"2278301f-681e-4d48-afc3-103ab4032146","validations":{"required":false},"type":"yes_no"},{"id":"LcABr6Ca3Xc7","title":"What is your email address?","ref":"2b935caf-13c3-4b0c-9389-bdced863059f","validations":{"required":true},"type":"email"}]}';
    private static final String responses = '{"items": [{"answers": [{"field": {"id": "JGrpx4odt20t","ref": "af327bc4-92f2-44b0-880d-61d7f90fb12e","type": "short_text"},"type": "text", "text": "Vijay"},{"field": {"id": "C73LSWWt41ci","ref": "9e97aaa8-340e-40fd-8bab-57331f3e9136","type": "opinion_scale"},"type": "number", "number": 7 },{"field":{"id":"rBCqgDmCQta1","ref":"2278301f-681e-4d48-afc3-103ab4032146","type":"yes_no"},"type":"boolean","boolean":true},{"field":{"id":"LcABr6Ca3Xc7","ref":"2b935caf-13c3-4b0c-9389-bdced863059f","type":"email"},"type":"email","email":"jigajinnivijay@gmail.com"}]}]}';

    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (req.getEndpoint().contains('responses')){
        	res.setBody(responses);    
        } else
            res.setBody(formsResponse);
        res.setStatusCode(200);
        return res;
    }
}