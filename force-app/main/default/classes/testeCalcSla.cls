public with sharing class testeCalcSla {

    @isTest
    static void testExecuteMethod() {

        // Criar registros de teste com todos os campos necessários
        List<Case> caseList = new List<Case>();

        // Caso 1: StartService = false (deve afetar SlaResponse__c)
        caseList.add(new Case(
            Name__c = 'João',
            Surname__c = 'Silva',
            Email__c = 'joao.silva@email.com',
            Priority = 'Alta',
            Status = 'Em Andamento',
            CreatedDate = System.now().addHours(-2),
            StartService__c = false,
            SlaResponse__c = 4,
            SLA__c = 10
        ));

        // Caso 2: StartService = true, com DateUnpause__c definido (deve afetar SLA__c)
        caseList.add(new Case(
            Name__c = 'Maria',
            Surname__c = 'Oliveira',
            Email__c = 'maria.oliveira@email.com',
            Priority = 'Média',
            Status = 'Aberto',
            CreatedDate = System.now().addHours(-4),
            StartService__c = true,
            SlaResponse__c = 5,
            SLA__c = 12,
            DateUnpause__c = System.now().addHours(-1)
        ));

        insert caseList;
        
        Test.startTest();
        CalcSLA job = new CalcSLA();
        System.enqueueJob(job);
        Test.stopTest();

        // Verifique se os casos foram atualizados
        List<Case> updatedCases = [
            SELECT Id, SlaResponse__c, SLA__c, StartService__c, DateUnpause__c
            FROM Case
        ];

        System.assertEquals(2, updatedCases.size());

        for (Case c : updatedCases) {
            if (!c.StartService__c) {
                System.assert(c.SlaResponse__c <= 4);
            } else {
                // No caso de DateUnpause__c, o campo deveria ter sido limpo
                System.assertEquals(null, c.DateUnpause__c);
            }
        }
    }
}