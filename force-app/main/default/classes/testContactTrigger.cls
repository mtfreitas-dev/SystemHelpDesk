@isTest public with sharing class testContactTrigger {

    @isTest static void testcheckEmailExisting(){
        Contact cc = new Contact(
            FirstName = 'Matheus',
            LastName = 'Freitas',
            Email = 'matheus.santos@gmail.com', 
            Phone = '+55939999999'
        );
        insert cc;

        Test.startTest();
          Contact cc2 = new Contact(FirstName = 'Matheus', LastName = 'Freitas', Email = 'matheus.santos@gmail.com', Phone = '+55939999999');
          Database.SaveResult result = Database.insert(cc2, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
    }

    @isTest static void testblockEmailIsBlank(){
        
        Contact cc = new Contact(FirstName = 'Matheus', LastName = 'Santos', Email = 'matheus.santos@gmail.com');
        insert cc;


        Test.startTest();
            cc.Email = '';
            Database.SaveResult result = Database.update(cc, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
    }
}