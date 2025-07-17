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

        //Consulta ao objeto Case com os campos necessários e filtro pelo número do chamado
        //Querying Case object with required fields filtered by case number
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
        //Consulta ao caso com os campos de SLA
        //Querying case with SLA-related fields
        Case cc = [SELECT Id, CaseNumber, SlaResponse__c, StartService__c FROM Case WHERE Id = :caseId];

        //Log de depuração para verificação
        //Debug log for verification
        System.debug('Fui acionado e esse é o caso: ' + cc);

        return cc;
    }

    //Método exposto para o LWC que atualiza os campos StartService e SLAPaused do caso
    //AuraEnabled method exposed to LWC that updates StartService and SLAPaused fields of a case
    @AuraEnabled
    public static void updateCases(Id caseId, Boolean startService, Boolean pauseSlA){

        try {
            //Consulta ao caso com os campos a serem atualizados
        //Querying the case with fields to be updated
        Case cc = [SELECT Id, StartService__c, Description, Subject, Urgency__c, SLAPaused__c, ContactId FROM Case WHERE Id = :caseId];

        //Atualização dos campos conforme parâmetros recebidos
        //Updating fields with received parameters
        cc.StartService__c = startService;
        cc.SLAPaused__c = pauseSlA;

        //Bloco try-catch para tratar possíveis erros de DML
        //Try-catch block to handle potential DML errors
            update cc;
        } catch (Exception e) {
            System.debug('Erro ' + e.getMessage());
            throw new AuraHandledException('Error updating case' + e.getMessage());
        }
    }
}