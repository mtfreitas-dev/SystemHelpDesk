public with sharing class AccountHelper {
    
    public static void validateRegistaredCnpj(List<Account> newRecords){

        List<String> cnpjList = new List<String>();

        for(Account acc : newRecords){
            cnpjList.add(acc.CNPJ__c);
        }

        for(Account acc : [SELECT Id, CNPJ__c FROM Account WHERE CNPJ__c IN : cnpjList]){
            for(Account accNew : newRecords){
                if(acc.CNPJ__c == accNew.CNPJ__c){
                    accNew.addError('CNPJ já cadastrado');
                }
            }
        }
    }

    public static void isValidCNPJ(List<Account> newRecods){

        List<String> cnpjList = new List<String>();

        for(Account acc : newRecods){
            if(acc.CNPJ__c == null || acc.CNPJ__c.length() != 14){
            }
            else{
                cnpjList.add(acc.CNPJ__c);
                String cnpj = acc.CNPJ__c;
                Integer[] weight1 = new Integer[]{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
                Integer [] weight2 = new Integer[]{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
                Integer sum = 0;
                Integer sum2 = 0;

                for(Integer i = 0; i < 12; i++){
                    sum += Integer.valueOf(cnpj.substring(i, i+1)) * weight1[i];
                    if(i == 11){
                        Integer rest = Math.mod(sum, 11);
                            
                        if(rest < 2) rest = 0; else rest = 11 - rest;
                        if(rest == 10) rest = 1; if(rest == 11) rest = 0;
                        if(rest != Integer.valueOf(cnpj.substring(12, 13))){
                            acc.addError('CNPJ Inválido');
                        }
                    }
                }
                
                for(Integer y = 0; y < 13; y++ ){
                    sum2 += Integer.valueOf(cnpj.substring(y, y + 1)) * weight2[y];
                    if(y == 12){
                        Integer rest = Math.mod(sum2, 11);
                        if(rest < 2) rest = 0; else rest = 11 - rest;
                        if(rest == 10) rest = 1; if(rest == 11) rest = 0;
                        if(rest != Integer.valueOf(cnpj.substring(13, 14))){
                            System.debug('REST >>>>>> ' + rest);
                            acc.addError('CNPJ Inválido');
                        }
                    }
                }
            }
        }
    }
}