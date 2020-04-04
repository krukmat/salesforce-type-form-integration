public with sharing class TypeFormIntegrationBatch implements Schedulable, Database.Batchable<sObject>, Database.AllowsCallouts{
   
   private static final String defaultAccountName = [SELECT Default_account_name__c FROM TypeForm_Settings__mdt][0].Default_account_name__c;
   private Account defaultAccount = [SELECT Id, Name FROM Account WHERE Name = :defaultAccountName]; 
   
    public List<TypeForm_Forms__mdt> start(Database.BatchableContext BC){
      return [SELECT Form_Id__c, DeveloperName FROM TypeForm_Forms__mdt];
   }
    
   public void execute(Database.BatchableContext BC, List<TypeForm_Forms__mdt> scope){
       List<QuestionAndAnswers__c> questionsAndAnswers = new List<QuestionAndAnswers__c>(); 
	   TypeFormFormCalloutProcessor questions = new TypeFormFormCalloutProcessor();
       TypeFormResponseCalloutProcessor answers = new TypeFormResponseCalloutProcessor();
       Map<String, String> FormId = new Map<String, String>(); 
       for (TypeForm_Forms__mdt form: scope){
       		// Search for questions
       		formId.put(form.Form_Id__c, form.DeveloperName); 
			questions.processCallout(form.Form_Id__c);
       		// Search for answers
			answers.processCallout(form.Form_Id__c, defaultAccountName);
       }
       // Emails by account. Map creation based on that key
       Map<String, Account> accountsFound = TypeIntegrationBatchHelper.getAccounts(answers.emailAccounts);
       // Question and Answer creation collected in the integration 
       for (String emailAccount: answers.answersProcessed.keySet()){
           // QuestionAndAnswers__c creation
           List<TypeFormResponseCalloutProcessor.AnswerData> answersFromAccount = answers.answersProcessed.get(emailAccount);
           // Account Id assignation
           Id accountId = defaultAccount.Id;
           if (accountsFound.containsKey(emailAccount)){
           	   accountId = accountsFound.get(emailAccount).Id;         
           }
           // Insertion of all question in list
           for (TypeFormResponseCalloutProcessor.AnswerData answerFromAccount: answersFromAccount){
	           QuestionAndAnswers__c qa = TypeIntegrationBatchHelper.createQuestionAndAnswer(formId, accountId, answerFromAccount, questions.fieldsById);
               if (qa != null)
               	questionsAndAnswers.add(qa);           
           }
           
       }
       // Database insertion
       insert questionsAndAnswers;
       

   }

   public void finish(Database.BatchableContext BC){
   }
   
    
   public void execute(SchedulableContext SC) {
      Database.executeBatch(new TypeFormIntegrationBatch(), 1); 
   }
}