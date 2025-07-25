import { LightningElement } from 'lwc';

export default class TesteBarradeProgresso extends LightningElement {
    percent = 80; // como número, não string

    renderedCallback() {
        if (this.percent != null) {
            const bar = this.template.querySelector('.slds-progress-bar__value');
            if (bar) {
                bar.style.width = `${this.percent}%`;
            }
        }
    }
}