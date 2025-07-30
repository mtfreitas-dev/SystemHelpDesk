@isTest(SeeAllData=true)
public with sharing class testeCalcSla {

    @isTest
    static void testExecuteMethod(){

        // Caso 1: StartService = false (deve afetar SlaResponse__c)
        Case c1 = new Case(
            Description = 'Teste',
            Subject = 'Teste',
            Urgency__c = 'Average',
            Category__c = 'Internet',
            Type = 'Preventive',
            Email__c = 'teste@gmail.com.br',
            Name__c =  'Teste',
            Surname__c = 'Teste'
        );

        // Caso 2: StartService = true, com DateUnpause__c definido (deve afetar SLA__c)
        Case c2 = new Case(
            Description = 'Teste 2',
            Subject = 'Teste 2',
            Urgency__c = 'Average',
            Category__c = 'Internet',
            Type = 'Preventive',
            Email__c = 'teste@gmail.com.br',
            Name__c =  'Teste',
            Surname__c = 'Teste',
            DatePause__c = Datetime.now().addHours(-1),
            DateUnpause__c = Datetime.now,
            StartService__c = true
        );

        /*Case c3 = new Case(
            Description = 'Teste 2',
            Subject = 'Teste 2',
            Urgency__c = 'Average',
            Category__c = 'Internet',
            Type = 'Preventive',
            Email__c = 'teste@gmail.com.br',
            Name__c =  'Teste',
            Surname__c = 'Teste',
            DateUnpause__c = null,
            StartService__c = true
        );*/

        Case c4 = [SELECT Id, SLA__c From Case WHERE SLA__c = 0 LIMIT 1];

        insert c1;
        insert c2;
        //insert c3;

        Set<Id> idSet = new Set<Id>{c1.Id, c2.Id, c4.Id};

        Test.startTest();
        CalcSLA job = new CalcSLA();
        System.enqueueJob(job);
        Test.stopTest();

        // Verifique se os casos foram atualizados
        List<Case> updatedCases = [
            SELECT Id, SlaResponse__c, SLA__c, StartService__c, DateUnpause__c
            FROM Case WHERE Id IN: idSet
        ];

        for(Case C : updatedCases){
            if(c.Id == c2.Id){
                System.assertEquals(null, c.DateUnpause__c);
            }
        }

        System.assertEquals(3, updatedCases.size());
    }
}