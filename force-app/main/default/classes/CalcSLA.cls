public with sharing class CalcSLA implements Queueable{


    //Método utilizado para calcular o tempo restante de SLA de cada caso aberto
    //Method used to calculate the remaining SLA time for each open case
    
    public void execute(QueueableContext context) {
        List<Case> caseList = [SELECT Id, CreatedDate, Priority, SLA__c, Status, FinishSla__c FROM Case WHERE Status != 'Closed' AND Status != Null AND SLA__c != Null];
        System.debug('CaseList ' + caseList);
        
        for(Case c : caseList){
            DateTime dateNow  = System.now();
            Long diffMillis = dateNow.getTime() - c.CreatedDate.getTime(); // Diferença em milissegundos
            Decimal diffHoras = diffMillis / (1000 * 60 * 60); // Converte para horas

            if(diffHoras <= 0){
                c.SLA__c = diffHoras;
            }
            else{
                c.SLA__c = 0;
            }
        }
        update caseList;
    }
}