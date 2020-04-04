@isTest
public with sharing class TypeIntegrationAuraControllerTest {
    @isTest
    public static void getAnswers(){
        Account acc = new Account();
        acc.Name='Test';
        insert acc;
        TypeIntegrationAuraController.getAnswers(acc.Id, '');
        TypeIntegrationAuraController.getAnswers(acc.Id, 'not exists');
    } 
}
