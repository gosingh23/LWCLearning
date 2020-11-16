import { LightningElement, track } from 'lwc';

export default class SimpleCalculator extends LightningElement {
    @track currentResult;
    @track previousResults = [];
    @track showOldResults = false;

    firstNum;
    secondNum;

    numberChangeHandler(event){
        const inputBoxName = event.target.name;
        if(inputBoxName === 'firstNumber'){
            this.firstNum = event.target.value;
        } else if(inputBoxName === 'secondNumber'){
            this.secondNum = event.target.value;
        }
    }

    toggleShowResult(event){
        this.showOldResults = event.target.checked;
    }

    findSum(event){
        const firstN = parseInt(this.firstNum);
        const secondN = parseInt(this.secondNum);

        this.currentResult = 'Result of '+firstN+' + '+secondN+' is '+(firstN+secondN);
        // using template literals
        this.currentResult = `Result of ${firstN} + ${secondN} is ${firstN+secondN}`;
        this.previousResults.push(this.currentResult);
    }

    findDifference(event){
        const firstN = parseInt(this.firstNum);
        const secondN = parseInt(this.secondNum);

        this.currentResult = 'Result of '+firstN+' - '+secondN+' is '+(firstN-secondN);
        // using template literals
        this.currentResult = `Result of ${firstN} - ${secondN} is ${firstN-secondN}`;
        this.previousResults.push(this.currentResult);
    }

    findProduct(event){
        const firstN = parseInt(this.firstNum);
        const secondN = parseInt(this.secondNum);

        this.currentResult = 'Result of '+firstN+' x '+secondN+' is '+(firstN*secondN);
        // using template literals
        this.currentResult = `Result of ${firstN} x ${secondN} is ${firstN*secondN}`;
        this.previousResults.push(this.currentResult);
    }

    findQuotient(event){
        const firstN = parseInt(this.firstNum);
        const secondN = parseInt(this.secondNum);

        this.currentResult = 'Result of '+firstN+' / '+secondN+' is '+(firstN/secondN);
        // using template literals
        this.currentResult = `Result of ${firstN} / ${secondN} is ${firstN/secondN}`;
        this.previousResults.push(this.currentResult);
    }
}