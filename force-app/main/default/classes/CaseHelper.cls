public with sharing class CaseHelper {

    //Validção se campos chaves estão devidamente preenchidos
    public static void validCase(List<Case> caseList) {        
        for(Case c : caseList){
            if(c.Description == null || c.Description == '' && c.Subject == null || c.Subject == '' && c.Urgency__c == null || c.Urgency__c == ''  && c.ContactEmail == null || c.ContactEmail =='' || c.SuppliedEmail == null || c.SuppliedEmail == ''){
                 c.addError('Please add a description, contact and title to the case');
            }
            else{
                c.Status = 'New';
            }
        }

        System.debug('Realizada a validação de caso');
        CasePriorityService(caseList);
        ValideContact(caseList);
        
    }

    //Valida se os contatos que foram informados existem baseado no e-mail, caso não exista aciona o método createnewContact para criar um novo contato
    public static void ValideContact(List<Case> caseList){

        List<String> emailList = new List<String>();

        for(Case cc : caseList){
            if(cc.SuppliedEmail != null || cc.SuppliedName != ''){
                System.debug('cc.SuppliedEmail ' + cc.SuppliedEmail);
                emailList.add(cc.SuppliedEmail);
            }
        }

        List<Contact> existingContactList = [SELECT Id, Email FROM Contact WHERE Email IN : emailList];

        if(existingContactList.size() > 0){
            for(Case cc :caseList){
                for(Contact cont : existingContactList){
                    if(cc.SuppliedEmail == cont.Email){
                        cc.ContactId = cont.Id;            
                    }
                }
            }
        }

        if(existingContactList.size() <= 0){
            List<Contact> contactList = createNewContact(caseList);

            for(Case cc : caseList){
                for(Contact cont : contactList){
                    if(cc.SuppliedEmail == cont.Email){
                        cc.ContactId = cont.Id;
                    }
                }
            }
        }
        System.debug('O campo contact id foi atualizado');
    }

    //Realiza a criação de novos contatos
    public static List<Contact> createNewContact(List<Case> caseList){
        List<Contact> contactList = new List<Contact>();

        for(Case cc : caseList){
            Contact contact = new Contact(FirstName = cc.SuppliedName, LastName = ' - Forms', Email= cc.SuppliedEmail, Phone = cc.SuppliedPhone);
                cc.ContactId = contact.Id;
                contactList.add(contact);
                System.debug('Criado novo contato');
        }

        insert contactList;
        return contactList;
    }
    

    //Define a prioridade do caso beseado em parametros preenchidos
    public static void CasePriorityService(List<Case> caseList) {
        for (Case cc : caseList) {

            Decimal score = 0;

            Map<String, Decimal> urgencyScores = new Map<String, Decimal>{
                'High' => 5, 'Average' => 3, 'Low' => 1
            };

            Map<String, Decimal> categoryMap = new Map<String, Decimal>{
                'Backup' => 4, 'Email' => 3, 'User Management' => 3, 'Internet' => 4, 'Software' => 2, 'Hardware' => 2
            };

            Map<String, Decimal> typeMap = new Map<String, Decimal>{
                'Incident' => 3, 'Request' => 2, 'Problem' => 3, 'Preventive' => 2, 'Deployment' => 2
            };

            if(cc.Urgency__c != null){
                score += urgencyScores.get(cc.Urgency__c);
            }

            if(cc.Type != null){
                score += typeMap.get(cc.Type);
            }

            if(cc.Category__c != null){
                score += categoryMap.get(cc.Category__c);
            }
            if(cc.PremiumCustomer__c){
                score += 2.5;
            }

            if (score >= 10) {
                cc.Priority = 'P1';
                cc.SLA__c = 4;
            } else if (score > 9) {
                cc.Priority = 'P2';
                cc.SLA__c = 6;
            } else if (score > 7) {
                cc.Priority = 'P3';
                cc.SLA__c = 8;
            } else {
                cc.Priority = 'P4';
                cc.SLA__c = 12;
            }

            System.debug('SCORE >>>>> ' + score);
            System.debug('CASE PRIORITY && CASE SLA>>>>>' + cc.Priority + cc.SLA__c);
        }

        System.debug('List of case ' + caseList);
        System.debug('REALIZADA ATUALIZAÇÃO DA PRIORIDADE');
    }

    /*Para realizar o calculo do SLA, o campo SLA vai apenas armazenar o valor de tempo, o calculo será realizado baseado no tempo de inicio e o tempo atual, sendo executado um queuble a cada 15 minutos para esse caluclo
    Vamos ter 4 campos que armazela valores 
    hroa inicial 
    hora de pausa
    sla
    e hora final*/
}