// Importações básicas do LWC e APIs para manipulação de dados do Salesforce
import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';

// Importações dos campos do objeto Case
import CASE_OBJECT from '@salesforce/schema/Case';
import CASE_SLA__C from '@salesforce/schema/Case.SLA__c';
import CASE_STARTSERVICE__C from '@salesforce/schema/Case.StartService__c';
import CASE_SLARESPONSE__C from '@salesforce/schema/Case.SlaResponse__c';
import CASE_SLAPAUSED__C from '@salesforce/schema/Case.SLAPaused__c';


// Recurso estático (ícone SVG)
import time from '@salesforce/resourceUrl/SLA';

// Método Apex para atualizar casos
import updateCases from '@salesforce/apex/CaseControl.updateCases';

export default class ViewerSla extends LightningElement {

  // URL do ícone SVG
  svgUrl = time;

  // ID do registro do caso (recebido via @api)
  @api recordId;

  // Propriedades auxiliares para armazenar dados e controle de estado
  data;
  error;
  valueSlaR;
  valueSla;
  check;
  pause;
  message;
  messageSLA;

  /**
   * Busca os dados do caso usando getRecord e calcula os valores de SLA com base nos campos.
   * Fetches the case data using getRecord and computes SLA values from fields.
   */
  @wire(getRecord, { recordId: '$recordId', fields: [CASE_SLA__C, CASE_STARTSERVICE__C, CASE_SLARESPONSE__C, CASE_SLAPAUSED__C] })
  wiredCase({ data, error }) {
    if (data) {
      this.data = data;
      this.error = undefined;
      this.valueSlaR = Math.min((getFieldValue(this.data, CASE_SLARESPONSE__C) / 3) * 100, 100);
      this.messageSLAr = 'Time remaining until first appointment ' + getFieldValue(this.data, CASE_SLARESPONSE__C) + ' Hours'
      this.check = getFieldValue(this.data, CASE_STARTSERVICE__C);
      this.pause = getFieldValue(this.data, CASE_SLAPAUSED__C);
      this.valueSla = Math.min((getFieldValue(this.data, CASE_SLA__C) / 12) * 100, 100);
      this.message = 'SLA: ' + getFieldValue(this.data, CASE_SLA__C) + ' Hours remaining';
    } else if (error) {
      this.data = undefined;
      this.error = error;
    }
  }

  // Getters para facilitar o acesso aos campos do objeto Case
  // Getters to simplify access to Case fields
  get sla() { return getFieldValue(this.data, CASE_SLA__C) }
  get startService() { return getFieldValue(this.data, CASE_STARTSERVICE__C) }
  get slaResponse() { return getFieldValue(this.data, CASE_SLARESPONSE__C) }
  get slaPaused() { return getFieldValue(this.data, CASE_SLAPAUSED__C) }
  get slaValue() { return getFieldValue(this.data, CASE_SLA__C) }

  /**
   * Inicia ou cancela o atendimento e atualiza os campos no servidor via Apex.
   * Starts or cancels the service and updates fields via Apex.
   */
  handleStart() {
    if (this.check != true) {
      this.check = true;
    } else if (this.check != false) {
      this.check = false;
    }

    console.log('Check ' + this.check);

    updateCases({ caseId: this.recordId, startService: this.check, pauseSlA: this.pause })
      .then(() => {
        console.log('Update Case');
      })
      .catch(error => {
        console.log('Error updating case ' + error);
      })
  }

  /**
   * Pausa o SLA do atendimento e salva a alteração via Apex.
   * Pauses the SLA and saves the change via Apex.
   */
  pauseSLA() {
    this.pause = true;

    updateCases({ caseId: this.recordId, startService: this.check, pauseSlA: this.pause })
      .then(() => {
        console.log('Update Case');
      })
      .catch(() => {
        console.log('Error updating case');
      })
  }

  /**
   * Retoma o SLA pausado e salva a alteração via Apex.
   * Resumes the paused SLA and saves the change via Apex.
   */
  resumeSLA() {
    this.pause = false;

    updateCases({ caseId: this.recordId, startService: this.check, pauseSlA: this.pause })
      .then(() => {
        console.log('Update Case');
      })
      .catch(() => {
        console.log('Error updating case');
      })
  }
}