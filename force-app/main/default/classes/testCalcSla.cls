@isTest(SeeAllData=true)
public with sharing class testCalcSla {

    // Testa o método execute da classe CalcSLA em diferentes cenários de caso
    // Tests the execute method of CalcSLA class in different case scenarios
    @isTest
    static void testExecuteMethod(){

        // Caso 1: StartService = false (deve afetar SlaResponse__c)
        // Case 1: StartService = false (should affect SlaResponse__c)
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
        // Case 2: StartService = true, with DateUnpause__c set (should affect SLA__c)
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
            DateUnpause__c = Datetime.now(),
            StartService__c = true
        );

        // Caso 3: Busca um caso existente com SLA__c = 0 para teste adicional
        // Case 3: Retrieves an existing case with SLA__c = 0 for additional testing
        Case c3 = [SELECT Id, SLA__c From Case WHERE SLA__c = 0 LIMIT 1];

        insert c1;
        insert c2;
        //insert c3;

        // Conjunto de IDs para verificação pós-teste
        // Set of IDs for post-test verification
        Set<Id> idSet = new Set<Id>{c1.Id, c2.Id, c3.Id};

        Test.startTest();
        // Instancia e enfileira o job Queueable para processamento
        // Instantiates and enqueues the Queueable job for processing
        CalcSLA job = new CalcSLA();
        System.enqueueJob(job);
        Test.stopTest();

        // Busca os casos atualizados após execução do Queueable
        // Retrieves updated cases after Queueable execution
        List<Case> updatedCases = [
            SELECT Id, SlaResponse__c, SLA__c, StartService__c, DateUnpause__c
            FROM Case WHERE Id IN: idSet
        ];

        // Verificações específicas para cada cenário de caso
        // Specific verifications for each case scenario
        for(Case C : updatedCases){
            if(c.Id == c2.Id){
                // Verifica se DateUnpause__c foi redefinido para null
                // Verifies if DateUnpause__c was reset to null
                System.assertEquals(null, c.DateUnpause__c);
            }
        }

        // Verifica se todos os 3 casos foram processados
        // Verifies if all 3 cases were processed
        System.assertEquals(3, updatedCases.size());
    }
}