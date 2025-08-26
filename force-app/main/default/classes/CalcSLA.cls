public with sharing class CalcSLA implements Queueable{


    //Método utilizado para calcular o tempo restante de SLA de cada caso aberto
    //Method used to calculate the remaining SLA time for each open case
    
    public void execute(QueueableContext context) {
        List<Case> caseList = [SELECT Id, Name__c, Email__c, CaseNumber, Surname__c, SlaResponse__c, SLAPaused__c, StartService__c, CreatedDate, DatePause__c, DateUnpause__c, Priority, SLA__c, Status, FinishSla__c FROM Case WHERE Status != 'Closed' AND Status != Null AND SLA__c != Null AND Name__c != Null AND Surname__c != Null AND Email__c != Null];

        
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
            if(c.StartService__c == true){
                if(c.DateUnpause__c != null){
                    Long miliInPause =   c.DateUnpause__c.getTime() - c.DatePause__c.getTime();
                    Decimal timeInPause = Decimal.valueOf(miliInPause) / (1000 * 60 * 60); 
                    Decimal finishTime = diffHoras - timeInPause;

                    c.Sla__c = c.Sla__c - finishTime;
                    c.DateUnpause__c = null;
                    
                } else {
                    c.Sla__c = c.Sla__c - diffHoras;

                    if(c.Sla__c <= 0){
                        c.Sla__c = 0;                
                    }
                }
            }
        }

        update caseList;
    }       
}