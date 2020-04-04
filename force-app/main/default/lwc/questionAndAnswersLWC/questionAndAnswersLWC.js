import { LightningElement, wire, track, api } from 'lwc';
import getAnswers from '@salesforce/apex/TypeIntegrationAuraController.getAnswers';
import {refreshApex} from '@salesforce/apex';

const COLS = [
    { label: 'Question__c', fieldName: 'Question__c'},
    { label: 'Answer__c', fieldName: 'Answer__c'},
    { label: 'Form__c', fieldName: 'Form__c' }
];
export default class questionAndAnswersLWC extends LightningElement {

    @api recordId;
    @track error;
    @track columns = COLS;

    sVal = '';
 
    // update sVal var when input field value change
    updateSeachKey(event) {
        this.sVal = event.target.value;
    }

    @wire(getAnswers, { recordId: '$recordId', searchText: '$sVal'})
    questionsAndAnswers;

}