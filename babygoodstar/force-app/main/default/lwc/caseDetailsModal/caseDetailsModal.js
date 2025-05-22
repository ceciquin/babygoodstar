import { LightningElement, api, wire } from 'lwc';
import getCaseWithAccessCode from '@salesforce/apex/CaseController.getCaseWithAccessCode';
//import callExternalService from '@salesforce/apex/CaseController.callExternalService';

export default class CaseDetailsModal extends LightningElement {
    @api caseId;
    caseRecord;
    isOpen = false;

    @wire(getCaseWithAccessCode, { caseId: '$caseId' })
    wiredCase({ error, data }) {
        if (data) {
            this.caseRecord = data;
            this.isOpen = true;
        } else if (error) {
            // Handle error
            this.isOpen = false;
        }
    }

    closeModal() {
        this.isOpen = false;
    }

    // callExternalService() {
    //     callExternalService({ caseId: this.caseId })
    //         .then(result => {
    //             // Handle success
    //         })
    //         .catch(error => {
    //             // Handle error
    //         });
    // }
}