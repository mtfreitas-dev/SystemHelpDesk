@isTest(SeeAllData=true) public with sharing class testCaseControl {
    @isTest static void testgetCasesInfo(){
        Case cc = [SELECT CaseNumber FROM Case LIMIT 1];
        List<Case> result = CaseControl.getCasesInfo(cc.CaseNumber);
       System.assertEquals(1, result.size());
    }

    @isTest static void testErrorGetCasesInfo(){
        Test.startTest();
        try{
            CaseControl.getCasesInfo(null);
        } catch(AuraHandledException ex){
            System.assertEquals('Script-thrown exception', ex.getMessage());
        }
        Test.stopTest();
    }

    @isTest static void testGetCaseToviewerSla(){
        Case c = [SELECT Id, CaseNumber, Subject, Status, Description, Urgency__c, ContactId FROM Case LIMIT 1];
        Case result = CaseControl.getCaseToviewerSla(c.Id);
        System.assertEquals(c.Id, result.Id);
    }

    @isTest static void testeUpdateCases(){
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
        CaseControl.updateCases(cc.Id, true, true);
        Test.stopTest();

        Case updateCase = [SELECT Id, StartService__c, SLAPaused__c FROM Case WHERE Id = :cc.Id];

        System.assertEquals(true, updateCase.StartService__c);
        System.assertEquals(true, updateCase.SLAPaused__c);
    }

    @isTest static void testUpdateCasesWithErrors(){        
        // Força uma falha de DML usando um mock
        Test.startTest();
        try {
            // Simula uma falha de DML durante a atualização
            CaseControl.updateCases('001000000000000', true, false);
        } catch (AuraHandledException ex) {

            // Verifica se a exceção foi lançada corretamente
            System.assertEquals('Script-thrown exception', ex.getMessage());
            }
        Test.stopTest();
    }
}
