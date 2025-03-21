public with sharing class ContactTriggerHandler {

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

    public void beforeInsert(){
        ContactHelper.checkEmailExisting(newRecords);
    }

    public void beforeUpdate(){
        ContactHelper.blockEmailIsBlank(newRecords);
    }
}