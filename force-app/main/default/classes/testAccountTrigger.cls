@isTest 
public with sharing class testAccountTrigger {

    // Testa a validação de CNPJ duplicado no trigger de Conta
    // Tests duplicate CNPJ validation in the Account trigger
    @isTest 
    static void testvalidateRegistaredCnpj(){
        // Cria duas contas com o mesmo CNPJ (deve permitir a primeira e bloquear a segunda)
        // Creates two accounts with the same CNPJ (should allow the first and block the second)
        Account cc = new Account(Name = 'AdvanTI', CNPJ__C = '56993890000134');
        Account cc2 = new Account(Name = 'Advanti2', CNPJ__C = '56993890000134');

        Test.startTest();
        Database.SaveResult result = Database.insert(cc, false);
        Database.SaveResult result2 = Database.insert(cc2, false);
        Test.stopTest();

        // Verifica se a primeira conta foi inserida com sucesso
        // Verifies if the first account was inserted successfully
        System.assertEquals(true, result.isSuccess());
        // Verifica se a segunda conta falhou na inserção (CNPJ duplicado)
        // Verifies if the second account failed insertion (duplicate CNPJ)
        System.assertEquals(false, result2.isSuccess());
    }

    // Testa a validação de formato de CNPJ (deve bloquear CNPJs inválidos)
    // Tests CNPJ format validation (should block invalid CNPJs)
    @isTest 
    static void testisValidCNPJ(){
        Test.startTest();
        // CNPJ com formato válido mas dígitos verificadores inválidos
        // CNPJ with valid format but invalid check digits
        Account cc = new Account(Name = 'AdvanTI', CNPJ__c = '04252011000199');
        
        // CNPJ com formato inválido (menos de 14 dígitos)
        // CNPJ with invalid format (less than 14 digits)
        Account cc2 = new Account(Name = 'Testando ', CNPJ__c =  '23456789012');

        Database.SaveResult result = Database.insert(cc, false);
        Database.SaveResult result2 = Database.insert(cc2, false);
        Test.stopTest();
        
        // Verifica se ambas as inserções falharam devido a CNPJ inválido
        // Verifies if both insertions failed due to invalid CNPJ
        System.assertEquals(false, result.isSuccess(), 'A conta não deveria ter sido criada');
        System.assertEquals(false, result2.isSuccess(), 'A conta não deveria ter sido criada');
    }
}