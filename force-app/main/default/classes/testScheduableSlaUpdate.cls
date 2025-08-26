@isTest 
public with sharing class testScheduableSlaUpdate {

    // Testa o agendamento da classe scheduableSlaUpdate verificando se o job é criado com a expressão cron correta
    // Tests the scheduling of the scheduableSlaUpdate class by verifying if the job is created with the correct cron expression
    @isTest 
    static void testIsQueueableTrue(){
        // Configura a expressão cron para teste - 15 de outubro de 2025, meia-noite
        // Setup cron expression for test - October 15, 2025, midnight
        String cronExp = '0 0 0 15 10 ? 2025';
        
        Test.startTest();
        
        // Agenda o job usando a expressão cron definida
        // Schedules the job using the defined cron expression
        String jobId = System.schedule('Test Schedule', cronExp, new scheduableSlaUpdate());
        
        Test.stopTest();
        
        // Recupera o trigger cron criado para verificação
        // Retrieves the created cron trigger for verification
        CronTrigger[] cronTrigger = [SELECT Id, CronExpression, State FROM CronTrigger WHERE Id = :jobId];
        
        // Verifica se a expressão cron configurada está correta
        // Verifies if the configured cron expression is correct
        System.Assert.areEqual(cronExp, cronTrigger[0].CronExpression);
    }
}