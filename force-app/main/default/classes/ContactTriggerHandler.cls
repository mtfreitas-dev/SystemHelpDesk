public with sharing class ContactTriggerHandler {


    //Armazena os valores que serão manipulados
    //Stores the values ​​that will be manipulated

    List<Contact> oldRecords {get;set;}
    List<Contact> newRecords {get;set;}
    Map<Id, Contact> oldMap {get;set;}
    Map<Id, Contact> newMap {get;set;}

    public ContactTriggerHandler(List<Contact> oldRecords, List<Contact> newRecords, Map<Id, Contact> oldMap, Map<Id, Contact> newMap){

        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }


    //Este método aciona outras funções quando a trigger na condição before insert é acionada
    //This method triggers other functions when the trigger in the before insert condition is fired

    public void beforeInsert(){
        ContactHelper.checkEmailExisting(newRecords);
        ContactHelper.blockEmailIsBlank(newRecords);
    }

     //Este método aciona outras funções quando a trigger na condição before update é acionada
    //This method triggers other functions when the trigger in the before update condition is fired

    public void beforeUpdate(){
        ContactHelper.blockEmailIsBlank(newRecords);
    }
}