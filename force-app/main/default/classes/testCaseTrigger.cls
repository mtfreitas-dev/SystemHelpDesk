@isTest public with sharing class testCaseTrigger {
    
    @isTest static void testvalidCase(){

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

        Case cc2 = new Case();

        Test.startTest(); 
        Database.SaveResult result = Database.insert(cc, false);
        Database.SaveResult result2 = Database.insert(cc2, false);
        Test.stopTest();

        System.assertEquals(true, result.isSuccess());
        System.assertEquals(false, result2.isSuccess());
    }

    @isTest static void testValideContact(){
        Contact ct = New Contact(
            FirstName = 'Matheus',
            LastName = 'Freitas',
            Email = 'teste@gmail.com.br'
        );

        insert ct;

        List<Case> casos = new List<Case>{
            new Case(Description = 'Teste 01', Subject = 'Teste', Urgency__c = 'Average', Category__c = 'Internet', Type = 'Preventive', Email__c = 'teste@gmail.com.br', 
            Name__c =  'Teste', Surname__c = 'Teste')
        };

        Test.startTest();
        CaseHelper.valideContact(casos);
        Test.stopTest();

        System.assertEquals(ct.Id, casos[0].ContactId);
    }

     @isTest
    static void testValideContactNewContact() {
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

        Contact c = [SELECT Id, Email FROM Contact WHERE Email = 'novo@email.com' LIMIT 1];

        System.assertEquals(c.Id, caseList[0].ContactId);
    }

        @isTest
    static void testCaseWithSLAPopulated() {
        // Caso com SLA já preenchido (nenhuma mudança deve ocorrer)
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
        System.assertEquals(4, caseList[0].SLA__c);
        System.assert(caseList[0].Priority == null);
    }

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

        System.assertEquals('P1', cases[0].Priority);
        System.assertEquals(4, cases[0].SLA__c);
    }

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

        System.assertEquals('P2', cases[0].Priority);
        System.assertEquals(6, cases[0].SLA__c);
    }

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

        System.assertEquals('P3', cases[0].Priority);
        System.assertEquals(8, cases[0].SLA__c);
    }

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

        System.assertEquals('P4', cases[0].Priority);
        System.assertEquals(12, cases[0].SLA__c);
    }
}