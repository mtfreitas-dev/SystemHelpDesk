@isTest
public class testQueueableAtualizaSLA {
    @IsTest
    static void executeTest(){

         Case cc = New Case(
            Description = 'Teste',
            Subject = 'Teste',
            Urgency__c = 'Average',
            Category__c = 'Internet',
            Type = 'Preventive',
            Email__c = 'teste@gmail.com.br',
            Name__c =  'Teste',
            Surname__c = 'Teste'
        );

        insert cc;

        Test.startTest();
            System.enqueueJob(new CalcSLA());
        Test.stopTest();

        Case updated = [SELECT Id, SLA__c FROM Case WHERE Id = :cc.Id];
        System.assertNotEquals(10, updated.SLA__c);
    }
}