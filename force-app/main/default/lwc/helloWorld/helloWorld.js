import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {
    @track dynamicGreeting = 'World123';

    greetingCHangeHandler(event){
        this.dynamicGreeting = event.target.value;
    }
}