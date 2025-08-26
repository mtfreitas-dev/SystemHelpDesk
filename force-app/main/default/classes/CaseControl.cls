public with sharing class CaseControl {

    //Método exposto para o LWC que retorna a lista de casos com base no número do chamado informado
    //AuraEnabled method exposed to LWC that returns a list of cases based on the given case number
    @AuraEnabled
    public static List<Case> getCasesInfo(String numberTicket) {
        
        //Validação para garantir que o número do chamado não esteja vazio
        //Validation to ensure the ticket number is not empty
        if (String.isBlank(numberTicket)) {
            throw new AuraHandledException('O número do chamado não pode estar vazio.');
        }

        List<Case> caseList = [
            SELECT Id, CaseNumber, Subject, Status, Description, Urgency__c, ContactId 
            FROM Case 
            WHERE CaseNumber = :numberTicket
        ];

        return caseList;
    }

    //Método exposto para o LWC que retorna informações de SLA do caso selecionado
    //AuraEnabled method exposed to LWC that returns SLA-related information for the selected case
    @AuraEnabled
    public static Case getCaseToviewerSla(Id caseId){
        return [SELECT Id, CaseNumber, SlaResponse__c, StartService__c FROM Case WHERE Id = :caseId];        
    }

    //Método exposto para o LWC que atualiza os campos StartService e SLAPaused do caso
    //AuraEnabled method exposed to LWC that updates StartService and SLAPaused fields of a case
    @AuraEnabled
    public static void updateCases(Id caseId, Boolean startService, Boolean pauseSlA){

        try {
            Case cc = [SELECT Id, StartService__c, Description, Subject, Urgency__c, SLAPaused__c, ContactId FROM Case WHERE Id = :caseId];
            cc.StartService__c = startService;
            cc.SLAPaused__c = pauseSlA;
            update cc;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating case' + e.getMessage());
        }
    }
}