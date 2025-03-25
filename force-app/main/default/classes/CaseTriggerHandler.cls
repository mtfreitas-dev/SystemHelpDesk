public with sharing class CaseTriggerHandler {
    

    //Armazena os valores que serão manipulados
    //Stores the values ​​that will be manipulated

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

    //Este método aciona outras funções quando a trigger na condição before insert é acionada
    //This method triggers other functions when the trigger in the before insert condition is fired

    public void beforeInsert(){
        CaseHelper.validCase(this.newRecords);
    }

    //Este método aciona outras funções quando a trigger na condição before update é acionada
    //This method triggers other functions when the trigger in the before update condition is fired

    public void beforeUpdate(){
       if(System.isQueueable()){
            System.debug('Executado por Apex Job');
        }
        else{
            CaseHelper.CasePriorityService(this.newRecords);
        }
    }
}