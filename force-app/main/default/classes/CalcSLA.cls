public with sharing class CalcSLA implements Queueable{


    //Método utilizado para calcular o tempo restante de SLA de cada caso aberto
    //Method used to calculate the remaining SLA time for each open case
    
    public void execute(QueueableContext context) {
        List<Case> caseList = [SELECT Id, Name__c, Email__c, CaseNumber, Surname__c, SlaResponse__c, SLAPaused__c, StartService__c, CreatedDate, DatePause__c, DateUnpause__c, Priority, SLA__c, Status, FinishSla__c FROM Case WHERE Status != 'Closed' AND Status != Null AND SLA__c != Null AND Name__c != Null AND Surname__c != Null AND Email__c != Null];

        System.debug('CaseList ' + caseList);
        
        for(Case c : caseList){
            
            Long diffMillis =   System.now().getTime() - c.CreatedDate.getTime(); // Diferença em milissegundos
            Decimal diffHoras = Decimal.valueOf(diffMillis) / (1000 * 60 * 60); // Converte para horas


            //Calcular o SLA Response 
            if(c.StartService__c == false){
                c.SlaResponse__c = c.SlaResponse__c - diffHoras;
                
                if(c.SlaResponse__c <= 0){
                    c.SlaResponse__c = 0;                
                }
            }

            //Calcular SLA
            if (c.StartService__c == true) {
                if (c.SLAPaused__c == false) {
                    if (c.DatePause__c != null) {
                        Long diffMillisPausa = System.now().getTime() - c.DatePause__c.getTime();
                        Decimal diffHorasPausa = Decimal.valueOf(diffMillisPausa) / (1000 * 60 * 60);
                        c.SLA__c += diffHorasPausa;
                        c.DateUnpause__c = System.now();
                    }
                    c.SLA__c -= diffHoras;
                    System.debug('SLA FINAL ' + c.SLA__c);
                } else {
                    System.debug('Chamado pausado: ' + c.CaseNumber);
                }
            }
        }

        update caseList;
    }
        
}