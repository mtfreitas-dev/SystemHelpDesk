@isTest 
public with sharing class testContactTrigger {

    // Testa a validação de e-mail duplicado no trigger de Contato
    // Tests the duplicate email validation in the Contact trigger
    @isTest 
    static void testcheckEmailExisting(){
        // Cria um primeiro contato com e-mail específico
        // Creates a first contact with specific email
        Contact cc = new Contact(
            FirstName = 'Matheus',
            LastName = 'Freitas',
            Email = 'matheus.santos@gmail.com', 
            Phone = '+55939999999'
        );
        insert cc;

        Test.startTest();
          // Tenta criar um segundo contato com o mesmo e-mail (deve falhar)
          // Attempts to create a second contact with the same email (should fail)
          Contact cc2 = new Contact(FirstName = 'Matheus', LastName = 'Freitas', Email = 'matheus.santos@gmail.com', Phone = '+55939999999');
          Database.SaveResult result = Database.insert(cc2, false);
        Test.stopTest();

        // Verifica se a inserção falhou como esperado
        // Verifies if the insertion failed as expected
        System.assertEquals(false, result.isSuccess());
    }

    // Testa a validação que impede que e-mail seja atualizado para vazio
    // Tests the validation that prevents email from being updated to empty
    @isTest 
    static void testblockEmailIsBlank(){
        // Cria um contato com e-mail válido
        // Creates a contact with valid email
        Contact cc = new Contact(FirstName = 'Matheus', LastName = 'Santos', Email = 'matheus.santos@gmail.com');
        insert cc;

        Test.startTest();
            // Tenta atualizar o e-mail para vazio (deve falhar)
            // Attempts to update email to empty (should fail)
            cc.Email = '';
            Database.SaveResult result = Database.update(cc, false);
        Test.stopTest();

        // Verifica se a atualização falhou como esperado
        // Verifies if the update failed as expected
        System.assertEquals(false, result.isSuccess());
    }
}