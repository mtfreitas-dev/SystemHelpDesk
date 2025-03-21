public with sharing class AccountTriggerHandler {
    

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

    public void beforeInsert(){
        AccountHelper.isValidCNPJ(newRecords);
        AccountHelper.validateRegistaredCnpj(newRecords);
    }
}