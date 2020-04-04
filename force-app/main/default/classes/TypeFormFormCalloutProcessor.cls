public with sharing class TypeFormFormCalloutProcessor {
    
    // All the titles in Map by ID 
    public Map<String, fieldsData> fieldsById = new Map<String, fieldsData>(); 
	
    // PRocess all the questions defined in the formId
    public void processCallout(String formId){
        String jsonResponse = TypeFormCallout.getCalloutResponseContents(TypeFormCallout.urlForm+formId); 
        JSONParser parser = JSON.createParser(jsonResponse);
        while (parser.nextToken() != null) {
        	// Start at the array of invoices.
        	if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            	while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                	if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire fieldsData object, including its array of line items.
                        fieldsData data = (fieldsData)parser.readValueAs(fieldsData.class);
                        if (String.isNotBlank(data.id)){
                            fieldsById.put(data.id, data);
                        }
                        	
                	}
            	}
        	}
    	}
        system.debug(fieldsById);
    }
    
    // Question title and id
    public class FieldsData {
        public String id;
        public String title;
        public String type;
    }
}