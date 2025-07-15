@isTest public with sharing class testScheduableSlaUpdate {

    @isTest static void testIsQueueableTrue(){
        Test.startTest();
        String cronExp = '0 0 0 15 10 ? 2025';
        String jobId = System.schedule('Test Schedule', cronExp, new scheduableSlaUpdate());
        Test.stopTest();
        CronTrigger[] cronTrigger = [SELECT Id, CronExpression, State FROM CronTrigger WHERE Id = :jobId];
        System.Assert.areEqual(cronTrigger[0].CronExpression, cronExp);
    }
}