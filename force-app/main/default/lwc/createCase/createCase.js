import { LightningElement } from 'lwc';
import ticket from '@salesforce/resourceUrl/newTicket';

export default class CreateCase extends LightningElement {

    svgUrl = ticket;
    create = null;

    /**
     * Manipula o sucesso do envio do formulário, limpando os campos, ocultando o formulário e exibindo um alerta.
     * Handles successful form submission: resets fields, hides the form, and shows an alert.
     */
    handleSuccess() {
        const fieldsInput = this.template.querySelectorAll('lightning-input-field');

        if (fieldsInput) {
            fieldsInput.forEach(field => {
                field.reset();
            });
            this.create = null;
            window.alert('Caso criado com sucesso!');
        }
    }

    /**
     * Ativa a exibição do formulário de criação de chamado.
     * Enables the display of the ticket creation form.
     */
    handleCreate() {
        this.create = true;
    }

    cancel(){
        this.create = false;
    }
}