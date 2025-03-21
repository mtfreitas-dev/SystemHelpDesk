public with sharing class CalcSLA implements Queueable{

    public void execute(QueueableContext context) {

        List<Case> caseList = [SELECT Id, CreatedDate, Priority, SLA__c, Status, FinishSla__c FROM Case WHERE Status != null AND SLA__c != null];

        System.debug('CaseList ' + caseList);
        
        for(Case c : caseList){
            Decimal sla = c.SLA__c;
            System.debug('ANTIGO SLA >>> ' + c.SLA__c);
            
            DateTime dateNow = DateTime.now();
            DateTime dateCreated = c.CreatedDate;
            
            Long sub = dateNow.getTime() - dateCreated.getTime();
            Long diff = sub / (1000 * 60);
            Integer min = Integer.valueOf(diff);
            Decimal hours = Decimal.valueOf(min / 60);
            c.SLA__c = c.SLA__c - hours;

            if(c.SLA__c > 0){
                Decimal porcentagemTotal = (c.SLA__C / 100) * 100;
                

                If

        }

    }
}

/*

List<Case> caseList = [SELECT Id, CreatedDate, Priority, SLA__c, Status, FinishSla__c FROM Case WHERE Status != null AND SLA__c != null];

System.debug('CaseList ' + caseList);

for(Case c : caseList){
    Decimal sla = c.SLA__c;
    
    DateTime now = DateTime.now();
    DateTime now2 = c.CreatedDate;
    
    Long sum = now.getTime() - now2.getTime();
    Long diff = sum / (1000 * 60);
    Integer test = Integer.valueOf(diff);
    Decimal horasdescontadas = Decimal.valueOf(test / 60);
    
    System.debug('DIFF >>>>>>>' + diff);
    System.debug('NOW >>>>>>>>>>>' + now);
    System.debug('TEST >>>>>>>>>>> ' + now2.addMinutes(test));
    System.debug('HORAS >>>>> ' + horasdescontadas);
    System.debug('CREATETED >>>>>>>> ' + now2);
}

*/