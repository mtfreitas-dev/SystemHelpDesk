@isTest public with sharing class testAccountTrigger {

    @isTest static void testvalidateRegistaredCnpj(){
        Account cc = new Account(Name = 'AdvanTI', CNPJ__C = '56993890000134');
        Account cc2 = new Account(Name = 'Advanti2', CNPJ__C = '56993890000134');

        Test.startTest();
        Database.SaveResult result = Database.insert(cc, false);
        Database.SaveResult result2 = Database.insert(cc2, false);
        Test.stopTest();

        System.assertEquals(true, result.isSuccess());
        System.assertEquals(false, result2.isSuccess());
    }

    @isTest static void testisValidCNPJ(){
        
        Test.startTest();
        Account cc = new Account(Name = 'AdvanTI', CNPJ__c = '04252011000199');
        Account cc2 = new Account(Name = 'Testando ', CNPJ__c =  '23456789012');

        Database.SaveResult result = Database.insert(cc, false);
        Database.SaveResult result2 = Database.insert(cc2, false);

        Test.stopTest();
        
        System.assertEquals(false, result.isSuccess(), 'A conta não deveria ter sido criada');
        System.assertEquals(false, result2.isSuccess(), 'A conta não deveria ter sido criada');
    }
}