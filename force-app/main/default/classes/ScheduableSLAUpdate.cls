public with sharing class ScheduableSLAUpdate implements Schedulable{
    //Método utilizado para realizar o agendamento da execução da classse para atualização do tempo de resposta dos casos abertos
    //Method used to schedule the execution of the class to update the response time of open cases
    
    public void execute(SchedulableContext sc){
        CalcSLA queueableJob = new CalcSLA();
        System.enqueueJob(queueableJob);
    }
}