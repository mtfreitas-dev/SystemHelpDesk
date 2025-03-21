public with sharing class ContactHelper {

    public static void checkEmailExisting(List<Contact> contactList){

        List<String> emailList = new List<String>();
        for(Contact cc : contactList){
            emailList.add(cc.Email);
            if(cc.Email == null || cc.Email == ''){
                cc.addError('Por favor, insira um endereço de e-mail');
            }
        }

        List<Contact> existingContactList = [SELECT Id, Email FROM Contact WHERE Email IN : emailList];

        for(Contact cc : contactList){
            if(existingContactList.size() > 0){
                for(Contact cont : existingContactList){
                    if(cc.Email == cont.Email){
                        cc.addError('E-mail já cadastrado, favor utilizar o contato já existente');
                    }
                }
            }
        }
    }

    public static void blockEmailIsBlank(List<Contact> contactList){
        for(Contact cc : contactList){
            if(cc.Email == '' || cc.Email == null){
                cc.addError('Não é permitido deixar este campo sem ser preenchido');
            }
        }
    }
}