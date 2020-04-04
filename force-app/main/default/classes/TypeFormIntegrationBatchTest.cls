@isTest
private class TypeFormIntegrationBatchTest {
    @testSetup static void setupTest(){
        
        Account dummy = new Account();
        dummy.Name = 'unlinked answers';
        insert dummy;
    }
    @isTest static void testBatchOnlyDummy() {
        Test.setMock(HttpCalloutMock.class, new TypeFormCalloutMockHttp());
        // Set mock callout class 
        Account dummy = [SELECT Id FROM Account WHERE Name = 'unlinked answers'];
        
        Test.startTest();
        	Database.executeBatch(new TypeFormIntegrationBatch(), 2);
        Test.stopTest();
        List<QuestionAndAnswers__c> qAndA = [SELECT Id FROM QuestionAndAnswers__c WHERE Account__c = :dummy.Id];
        system.assertEquals(4, qAndA.size());
    }
    
    @isTest static void testBatchOneAccountAndDummy() {
        Test.setMock(HttpCalloutMock.class, new TypeFormCalloutMockHttp());
        // Set mock callout class 
        Account dummy = [SELECT Id FROM Account WHERE Name = 'unlinked answers'];
        
        Account noDummy = new Account();
        noDummy.Name = 'jigajinnivijay@gmail.com';
        noDummy.Email__c = 'jigajinnivijay@gmail.com';
        insert noDummy;
        Test.startTest();
        	Database.executeBatch(new TypeFormIntegrationBatch(), 2);
        Test.stopTest();
        List<QuestionAndAnswers__c> qAndA = [SELECT Id FROM QuestionAndAnswers__c WHERE Account__c = :dummy.Id];
        system.assertEquals(0, qAndA.size());
        qAndA = [SELECT Id FROM QuestionAndAnswers__c WHERE Account__c = :noDummy.Id];
        system.assertEquals(4, qAndA.size());
    }
}