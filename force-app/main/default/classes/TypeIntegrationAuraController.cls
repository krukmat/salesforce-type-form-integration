public with sharing class TypeIntegrationAuraController {
        @AuraEnabled(cacheable=true)
        public static List<QuestionAndAnswers__c> getAnswers(Id recordId, String searchText) {
            string sTempSearchKey = '%' + searchText + '%';
            if (String.isBlank(searchText))
                return [
                    SELECT Question__c, Answer__c,Form__c
                    FROM QuestionAndAnswers__c
                    WHERE Account__c = :recordId
                    WITH SECURITY_ENFORCED
                ];
            else {
                return [
                    SELECT Question__c, Answer__c,Form__c
                    FROM QuestionAndAnswers__c
                    WHERE Account__c = :recordId AND (Answer__c LIKE :sTempSearchKey OR Question__c LIKE :sTempSearchKey)
                    WITH SECURITY_ENFORCED
                ];

            }
        }
}
