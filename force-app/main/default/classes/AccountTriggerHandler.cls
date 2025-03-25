public with sharing class AccountTriggerHandler {
    

    //Armazena os valores que serão manipulados
    //Stores the values ​​that will be manipulated

    List<Account> oldRecords{get;set;}
    List<Account> newRecords{get;set;}
    Map<Id, Account> oldMap{get;set;}
    Map<Id, Account> newMap{get;set;}

    public AccountTriggerHandler(List<Account> oldRecords, List<Account> newRecords, Map<Id, Account> oldMap, Map<Id, Account> newMap){
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    //Este método aciona outras funções quando a trigger na condição before insert é acionada
    //This method triggers other functions when the trigger in the before insert condition is fired
    
    public void beforeInsert(){
        AccountHelper.isValidCNPJ(newRecords);
        AccountHelper.validateRegistaredCnpj(newRecords);
    }
}