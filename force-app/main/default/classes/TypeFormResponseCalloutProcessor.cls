public with sharing class TypeFormResponseCalloutProcessor {
    private static final String pageSize = String.valueOf([SELECT Page_size__c  FROM TypeForm_Settings__mdt][0].Page_size__c); 
	@testVisible private static final String baseUrlForm = TypeFormCallout.urlForm + ':form_id/responses?page_size='+pageSize;
    public Map<String, List<AnswerData>> answersProcessed = new Map<String, List<AnswerData>>(); 
    public Set<String> emailAccounts = new Set<String>();
	

    public ResponseFieldsData setMetadata(String id, String ref, String type){
        ResponseFieldsData metadata = new ResponseFieldsData();
        metadata.id = id;
        metadata.ref = ref;
        metadata.type = type;
        return metadata;
    }
    public void processCallout(String formId, String dummyAccount){
        //try{
            answersProcessed.put(dummyAccount, new List<AnswerData>());
            String urlForm = baseUrlForm.replace(':form_id', formId);
            String jsonResponse = TypeFormCallout.getCalloutResponseContents(urlForm); 
            Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
            List<Object> allItems = (List<Object>)response.get('items');
        	// Iteration from Items array
            for (Object item: allItems){
                Map<String, Object> answers = (Map<String, Object>) item;
                // Iteration from answers array
                List<Object> answersList = (List<Object>) answers.get('answers');
                // by default the account will be the dummy
                String currentEmail = dummyAccount;
                // temporary list to save the answers before define which is the correct email 
                List<AnswerData> currentAnswers = new List<AnswerData>();
                // For each answer create the answer to insert
                for (Object answer: answersList){
                    Map<String, Object> answerDetail = (Map<String, Object>) answer;
                    Map<String, Object> field = (Map<String, Object>) answerDetail.get('field');
                    String id = (String)field.get('id');
                    String ref = (String) field.get('ref');
                    String type = (String)field.get('type');
                    ResponseFieldsData md = setMetadata(id, ref, type);
                    String answerType = (String)answerDetail.get('type');
                    String value = String.valueOf(answerDetail.get(answerType));
                    AnswerData answerData = new AnswerData();
                    answerData.type = answerType;
                    answerData.value = value;
                    answerData.fields = md;
                    answerData.formId = formId;
                    // the email is the key for all the answers defined
                    if (answerType == 'email'){
                        if (String.isNotBlank(value)){
                            currentEmail = value;
                            emailAccounts.add(value);
                            if (!answersProcessed.containsKey(value)){
                                answersProcessed.put(value, new List<AnswerData>());
                            }
                        } 
                    }
                    currentAnswers.add(answerData);
                }
                // the questions are associated by account email (or dummy account)
                answersProcessed.put(currentEmail, currentAnswers);
            }
            system.debug(answersProcessed);
            
        /*} catch (Exception exc){
            system.debug(exc);
        }*/
    }
    
    public class ResponseFieldsData {
        public String id;
        public String ref;
        public String type;
    }
    
    public class AnswerData{
        public String type;
        public ResponseFieldsData fields;
        public String value;
        public String formId;
    }
}