public with sharing class CaseTriggerHandler {
    
    List<Case> oldRecords {get;set;}
    List<Case> newRecords {get;set;}
    Map<Id, Case> oldMap {get;set;}
    Map<Id, Case> newMap {get;set;}

    public CaseTriggerHandler(List<Case> oldRecords, List<Case> newRecords, Map<Id, Case> oldMap, Map<Id, Case> newMap){
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        CaseHelper.validCase(this.newRecords);
    }

    public void beforeUpdate(){
        CaseHelper.CasePriorityService(this.newRecords);
    }
}