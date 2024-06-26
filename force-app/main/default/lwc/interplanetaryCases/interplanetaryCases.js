import { LightningElement, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getCases from '@salesforce/apex/CaseController.getCases';

const COLUMNS = [
    { label: 'Subject', fieldName: 'Subject' },
    { label: 'Status', fieldName: 'Status' },
    { label: 'Contact Email', fieldName: 'ContactEmail', type: 'email' },
    {
        label: 'Related Contact',
        fieldName: 'ContactId',
        type: 'url',
        typeAttributes: { label: { fieldName: 'ContactName' }, target: '_blank' },
        cellAttributes: { iconName: 'action:preview' }
    }
];

export default class InterplanetaryCases extends LightningElement {
    @track cases;
    @track error;
    columns = COLUMNS;

    @wire(getCases)
    wiredCases(result) {
        if (result.data) {
            this.cases = result.data.map(caseRecord => {
                let contactUrl = `/lightning/r/Contact/${caseRecord.ContactId}/view`;
                return {...caseRecord, ContactId: contactUrl };
            });
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.cases = undefined;
        }
    }

    connectedCallback() {
        this.refreshData();
    }

    refreshData() {
        refreshApex(this.cases);
    }
}