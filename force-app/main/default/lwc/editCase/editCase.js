import { LightningElement } from 'lwc';
import pencil from '@salesforce/resourceUrl/pencil';
import getCasesInfo from '@salesforce/apex/CaseControl.getCasesInfo';


export default class EditCase extends LightningElement {
    svgUrl = pencil;
    caseNumber;
    cases;
    ticketNumber;
    formKey = 0;
    edit;
    controller;
    id;

    handleInputChange() {
        this.ticketNumber = this.template.querySelector('lightning-input').value;
        console.log('Valor final ' + this.ticketNumber);
    }

    handleSearch() {
        console.log('Executando......');
        if (this.ticketNumber != '') {
            getCasesInfo({ numberTicket: this.ticketNumber })
                .then(result => {
                    this.cases = result;
                    this.formKey++;
                    this.id = this.cases?.[0]?.Id;
                    this.controller = true;
                })
                .catch(error => {
                    console.log('Erro:', error.body?.message || error.message);
                    this.cases = null;
                    window.alert('Erro: ' + (error.body?.message || 'Erro inesperado.'));
                    this.controller = false;
                });
        }
    }

    handleSubmit(event) {

        event.preventDefault();

        // Referencie os campos usando data-id
        const subject = this.template.querySelector('[data-id="subject"]');
        const status = this.template.querySelector('[data-id="status"]');
        const description = this.template.querySelector('[data-id="description"]');
        const urgency = this.template.querySelector('[data-id="urgency"]');
        const email = this.template.querySelector('[data-id="email"]');

        const allValid = [subject, status, description, urgency, email].every(field => field.reportValidity());

        if (allValid) {
            const fields = event.detail.fields;
            this.template.querySelector('lightning-record-edit-form').submit(fields);
            window.alert('Caso atualizado com sucesso!');
            
        } else {
            // Se houver campos inválidos, exibe mensagens e não envia
            window.alert('Por favor, preencha todos os campos obrigatórios corretamente.');
        }
    }

    handleSuccess() {
        console.log('Caso atualizado com sucesso!');
        this.edit = false;
        this.cases = null
        this.controller = null;
    }

    handleEditOn() {
        this.edit = true;
        this.controller = false

    }

    canceledEdition() {
        this.controller = true;
        this.edit = false;
    }

    newSearch() {
        this.controller = false;
        this.edit = false;
        this.cases = null;
        this.ticketNumber = null;
    }

    getIdCase() {
        return this.cases?.[0]?.Id;
    }

}