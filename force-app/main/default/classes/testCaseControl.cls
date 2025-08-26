@isTest(SeeAllData=true) 
public with sharing class testCaseControl {
    
    // Testa o método getCasesInfo com um número de caso existente
    // Tests getCasesInfo method with an existing case number
    @isTest 
    static void testgetCasesInfo(){
        // Busca um caso existente na base de dados (SeeAllData=true)
        // Retrieves an existing case from database (SeeAllData=true)
        Case cc = [SELECT CaseNumber FROM Case LIMIT 1];
        
        // Chama o método sendo testado com o número do caso real
        // Calls the method under test with the real case number
        List<Case> result = CaseControl.getCasesInfo(cc.CaseNumber);
       
        // Verifica se retornou exatamente um caso
        // Verifies if exactly one case was returned
        System.assertEquals(1, result.size());
    }

    // Testa o tratamento de erro quando número do caso é nulo
    // Tests error handling when case number is null
    @isTest 
    static void testErrorGetCasesInfo(){
        Test.startTest();
        try{
            // Tenta chamar o método com parâmetro nulo (deve lançar exceção)
            // Attempts to call method with null parameter (should throw exception)
            CaseControl.getCasesInfo(null);
        } catch(AuraHandledException ex){
            // Verifica se a exceção esperada foi lançada
            // Verifies if the expected exception was thrown
            System.assertEquals('Script-thrown exception', ex.getMessage());
        }
        Test.stopTest();
    }

    // Testa o método getCaseToviewerSla com ID de caso válido
    // Tests getCaseToviewerSla method with valid case ID
    @isTest 
    static void testGetCaseToviewerSla(){
        // Busca um caso existente na base de dados
        // Retrieves an existing case from database
        Case c = [SELECT Id, CaseNumber, Subject, Status, Description, Urgency__c, ContactId FROM Case LIMIT 1];
        
        // Chama o método sendo testado
        // Calls the method under test
        Case result = CaseControl.getCaseToviewerSla(c.Id);
        
        // Verifica se o caso retornado é o mesmo que foi solicitado
        // Verifies if the returned case is the same as requested
        System.assertEquals(c.Id, result.Id);
    }

    // Testa a atualização bem-sucedida dos campos StartService e SLAPaused
    // Tests successful update of StartService and SLAPaused fields
    @isTest 
    static void testeUpdateCases(){
        // Cria um novo caso para teste
        // Creates a new case for testing
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
        // Chama o método de atualização com valores true para ambos os campos
        // Calls the update method with true values for both fields
        CaseControl.updateCases(cc.Id, true, true);
        Test.stopTest();

        // Busca o caso atualizado para verificação
        // Retrieves the updated case for verification
        Case updateCase = [SELECT Id, StartService__c, SLAPaused__c FROM Case WHERE Id = :cc.Id];

        // Verifica se os campos foram atualizados corretamente
        // Verifies if fields were updated correctly
        System.assertEquals(true, updateCase.StartService__c);
        System.assertEquals(true, updateCase.SLAPaused__c);
    }

    // Testa o tratamento de erro durante atualização com ID inválido
    // Tests error handling during update with invalid ID
    @isTest 
    static void testUpdateCasesWithErrors(){        
        Test.startTest();
        try {
            // Tenta atualizar com ID inválido (deve lançar exceção)
            // Attempts update with invalid ID (should throw exception)
            CaseControl.updateCases('001000000000000', true, false);
        } catch (AuraHandledException ex) {
            // Verifica se a exceção foi lançada corretamente
            // Verifies if the exception was thrown correctly
            System.assertEquals('Script-thrown exception', ex.getMessage());
        }
        Test.stopTest();
    }
}