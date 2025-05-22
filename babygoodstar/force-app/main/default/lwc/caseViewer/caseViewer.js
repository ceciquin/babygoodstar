import { LightningElement, api } from 'lwc';
import makeExternalRequest from '@salesforce/apex/YodaLocationService.getRequestYodaLocation';

export default class CaseViewer extends LightningElement {
    @api ca;

    handleInterplanetaryScan() {
        const planetAccessCode = this.ca.Planet__r.Access_Code__c;

        // Call Apex method to make external system request
        makeExternalRequest({ accessCode: planetAccessCode })
            .then(result => {
                // Handle success
            })
            .catch(error => {
                // Handle error
            });
    }
}
