import { LightningElement, track } from 'lwc';

export default class BmiCalculator extends LightningElement {
    cardTitle = "BMI Calculator";
    weight;
    height;
    /** bmi should be reactive property
    * @track bmi;
    * with spring '20 update all properties are reactive. @track is not required for primitive properties.
    */
    bmi;

    /** Using an object to calculate 
     * Non-primitive datatypes should be marked as track property to make them reactive
    */
    @track bmiData = {
        dWeight : 0,
        dHeight : 0,
        dResult : 0
    }

    onWeightChange(event){
        this.bmiData.dWeight = parseFloat(event.target.value);
        this.weight = parseFloat(event.target.value);
    }

    onHeightChange(event){
        this.bmiData.dHeight = parseFloat(event.target.value);
        this.height = parseFloat(event.target.value);
    }

    calculateBMI(){
        try {
            this.bmi = this.weight*10000/(this.height*this.height);
            //this.bmiData.dResult = this.bmiData.dWeight*10000/(this.bmiData.dHeight*this.bmiData.dHeight);
        } catch(error) {
            this.bmi = "Error: "+error;
        }
    }

    get bmiValue(){
        try{
            this.bmiData.dResult = this.bmiData.dWeight*10000/(this.bmiData.dHeight*this.bmiData.dHeight);
        } catch(error) {
            this.bmi = "Error: "+error;
        }

        return `Your BMI is : ${this.bmiData.dResult}`;
    }

}