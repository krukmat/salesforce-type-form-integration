public with sharing class TypeIntegrationBatchHelper {
    
	// Map of account by email
    public static Map<String, Account> getAccounts(Set<String> emails){
        List<Account> existentAccounts = [SELECT Id, Email__c, (select Form__c, Question__c FROM QuestionsAndAnswers__r), number_of_questions__c FROM Account WHERE Email__c in :emails];
        Map<String, Account> accountByEmail = new Map<String, Account>();
        for (Account acc: existentAccounts){
            accountByEmail.put(acc.Email__c, acc);
        }
        return accountByEmail;
    }
   
    public static QuestionAndAnswers__c createQuestionAndAnswer(Map<String,String> formId, Id accId, TypeFormResponseCalloutProcessor.AnswerData typeFormAnswer, Map<String, TypeFormFormCalloutProcessor.fieldsData> questionsMap){
        // Verification of exitence of Question
        String questionId = typeFormAnswer.fields.Id;
        // question should exist
        if (questionsMap.containsKey(questionId)){
            
        	String question = questionsMap.get(questionId).title;
            String response = typeFormAnswer.value;
            String formName = formId.get(typeFormAnswer.formId);
        	return new QuestionAndAnswers__c(Account__c=accId, Form__c=formName, Question__c=question, Answer__c =response);
        }
        return null;
    }
}