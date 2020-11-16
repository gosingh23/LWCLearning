import { LightningElement, track } from 'lwc';

export default class ConditionalRenderingExample extends LightningElement {
    @track displayDiv = false;
    @track cityList = ['Mumbai', 'London', 'Berlin', 'Chicago'];

    showDivHandler(event){
        this.displayDiv = event.target.checked;
    }
}