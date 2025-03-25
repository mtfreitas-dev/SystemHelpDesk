public with sharing class ContactHelper {

    //Verifica se o e-mail associado ao contato já está cadastrado no banco de dados 
    //Check that the email associated with the contact is already registered in the database

    public static void checkEmailExisting(List<Contact> contactList){
        List<String> emailList = new List<String>();

        for(Contact cc : contactList){
            emailList.add(cc.Email);
        }

        List<Contact> existingContactList = [SELECT Id, Email FROM Contact WHERE Email IN : emailList];

        for(Contact cc : contactList){
            if(existingContactList.size() > 0){
                for(Contact cont : existingContactList){
                    if(cc.Email == cont.Email){
                        cc.addError('Email already registered, please use your existing contact');
                    }
                }
            }
        }
    }


    //Bloqueio de atualização caso o campo Email não esteja preenchido
    //Prevent update if the Email field is not filled
    
    public static void blockEmailIsBlank(List<Contact> contactList){
        for(Contact cc : contactList){
            if(cc.Email == '' || cc.Email == null){
                cc.addError('Please fill in the Email field');
            }
        }
    }
}