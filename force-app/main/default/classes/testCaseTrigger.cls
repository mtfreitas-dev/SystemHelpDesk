@isTest 
public with sharing class testCaseTrigger {
    
    // Testa a validação de casos - deve permitir caso completo e bloquear caso incompleto
    // Tests case validation - should allow complete case and block incomplete case
    @isTest 
    static void testvalidCase(){
        // Cria um caso completo com todos os campos obrigatórios preenchidos
        // Creates a complete case with all required fields filled
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

        // Cria um caso vazio (deve falhar na validação)
        // Creates an empty case (should fail validation)
        Case cc2 = new Case();

        Test.startTest(); 
        Database.SaveResult result = Database.insert(cc, false);
        Database.SaveResult result2 = Database.insert(cc2, false);
        Test.stopTest();

        // Verifica se o caso completo foi inserido com sucesso
        // Verifies if the complete case was inserted successfully
        System.assertEquals(true, result.isSuccess());
        // Verifica se o caso vazio falhou na inserção
        // Verifies if the empty case failed insertion
        System.assertEquals(false, result2.isSuccess());
    }

    // Testa a associação de caso com contato existente através do e-mail
    // Tests case association with existing contact through email
    @isTest 
    static void testValideContact(){
        // Cria um contato para teste
        // Creates a contact for testing
        Contact ct = New Contact(
            FirstName = 'Matheus',
            LastName = 'Freitas',
            Email = 'teste@gmail.com.br'
        );

        insert ct;

        // Cria uma lista de casos com e-mail correspondente ao contato
        // Creates a list of cases with email matching the contact
        List<Case> casos = new List<Case>{
            new Case(Description = 'Teste 01', Subject = 'Teste', Urgency__c = 'Average', Category__c = 'Internet', Type = 'Preventive', Email__c = 'teste@gmail.com.br', 
            Name__c =  'Teste', Surname__c = 'Teste')
        };

        Test.startTest();
        CaseHelper.valideContact(casos);
        Test.stopTest();

        // Verifica se o ContactId foi corretamente associado ao caso
        // Verifies if ContactId was correctly associated to the case
        System.assertEquals(ct.Id, casos[0].ContactId);
    }

    // Testa a criação de um novo contato quando não existe contato com o e-mail fornecido
    // Tests creation of new contact when no contact exists with the provided email
    @isTest
    static void testValideContactNewContact() {
        // Cria caso com e-mail de um contato que não existe ainda
        // Creates case with email of a contact that doesn't exist yet
        List<Case> caseList = new List<Case>{
            new Case(
                Subject = 'Teste 2',
                Email__c = 'novo@email.com',
                Name__c = 'Maria',
                Surname__c = 'Souza',
                SuppliedEmail = 'novo@email.com'
            )
        };

        Test.startTest();
        CaseHelper.valideContact(caseList);
        Test.stopTest();

        // Busca o contato criado automaticamente pelo método valideContact
        // Searches for the contact automatically created by the valideContact method
        Contact c = [SELECT Id, Email FROM Contact WHERE Email = 'novo@email.com' LIMIT 1];

        // Verifica se o ContactId foi corretamente associado ao caso
        // Verifies if ContactId was correctly associated to the case
        System.assertEquals(c.Id, caseList[0].ContactId);
    }

    // Testa caso onde SLA já está preenchido (não deve sofrer alterações)
    // Tests case where SLA is already populated (should not be changed)
    @isTest
    static void testCaseWithSLAPopulated() {
        // Caso com SLA já preenchido (nenhuma mudança deve ocorrer)
        // Case with SLA already populated (no changes should occur)
        Case caseWithSLA = new Case(
            SLA__c = 4,
            Urgency__c = 'High',
            Category__c = 'Backup',
            Type = 'Incident',
            PremiumCustomer__c = true
        );

        List<Case> caseList = new List<Case>{caseWithSLA};
        Test.startTest();
        CaseHelper.CasePriorityService(caseList);
        Test.stopTest();

        // Verifica se valores não foram alterados
        // Verifies if values were not changed
        System.assertEquals(4, caseList[0].SLA__c);
        System.assert(caseList[0].Priority == null);
    }

    // Testa cálculo de prioridade P1 (mais urgente)
    // Tests P1 priority calculation (most urgent)
    @isTest
    static void testCasePriorityP1() {
        // score = 5 (High) + 4 (Backup) + 3 (Incident) + 2.5 (Premium) = 14.5
        Case c = new Case(
            Urgency__c = 'High',
            Category__c = 'Backup',
            Type = 'Incident',
            PremiumCustomer__c = true
        );

        List<Case> cases = new List<Case>{c};
        Test.startTest();
        CaseHelper.CasePriorityService(cases);
        Test.stopTest();

        // Verifica prioridade P1 e SLA de 4 horas
        // Verifies P1 priority and 4-hour SLA
        System.assertEquals('P1', cases[0].Priority);
        System.assertEquals(4, cases[0].SLA__c);
    }

    // Testa cálculo de prioridade P2
    // Tests P2 priority calculation
    @isTest
    static void testCasePriorityP2() {
        // score = 5 (High) + 3 (Email) + 2 (Request) = 10
        Case c = new Case(
            Urgency__c = 'High',
            Category__c = 'Software',
            Type = 'Request',
            PremiumCustomer__c = false
        );

        List<Case> cases = new List<Case>{c};
        Test.startTest();
        CaseHelper.CasePriorityService(cases);
        Test.stopTest();

        // Verifica prioridade P2 e SLA de 6 horas
        // Verifies P2 priority and 6-hour SLA
        System.assertEquals('P2', cases[0].Priority);
        System.assertEquals(6, cases[0].SLA__c);
    }

    // Testa cálculo de prioridade P3
    // Tests P3 priority calculation
    @isTest
    static void testCasePriorityP3() {
        // score = 3 (Average) + 2 (Software) + 2 (Preventive) + 0 = 7
        // Adicionando PremiumCustomer = true (+2.5) = 9.5
        Case c = new Case(
            Urgency__c = 'Average',
            Category__c = 'Hardware',
            Type = 'Deployment'
        );

        List<Case> cases = new List<Case>{c};
        Test.startTest();
        CaseHelper.CasePriorityService(cases);
        Test.stopTest();

        // Verifica prioridade P3 e SLA de 8 horas
        // Verifies P3 priority and 8-hour SLA
        System.assertEquals('P3', cases[0].Priority);
        System.assertEquals(8, cases[0].SLA__c);
    }

    // Testa cálculo de prioridade P4 (menos urgente)
    // Tests P4 priority calculation (least urgent)
    @isTest
    static void testCasePriorityP4() {
        // score = 1 (Low) + 2 (Hardware) = 3
        Case c = new Case(
            Urgency__c = 'Low',
            Category__c = 'Hardware',
            PremiumCustomer__c = false
        );

        List<Case> cases = new List<Case>{c};
        Test.startTest();
        CaseHelper.CasePriorityService(cases);
        Test.stopTest();

        // Verifica prioridade P4 e SLA de 12 horas
        // Verifies P4 priority and 12-hour SLA
        System.assertEquals('P4', cases[0].Priority);
        System.assertEquals(12, cases[0].SLA__c);
    }
}