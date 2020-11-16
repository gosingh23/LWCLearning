import { LightningElement, api } from 'lwc';
import getCustomerInfo from "@salesforce/apex/CustomerController.getCustomerInfo";

export default class CustomerInfo extends LightningElement {
    @api recordId;
    @api customer={
        "products": [
            {
                "attributes": {
                    "type": "Product__c",
                    "url": "\/services\/data\/v50.0\/sobjects\/Product__c\/a014K000009Z2k8QAC"
                },
                "Contact__c": "0034K000004aiYkQAI",
                "Id": "a014K000009Z2k8QAC",
                "Charge_Type__c": "Percentage",
                "Charge__c": "2.5",
                "Product__c": "01t4K000000WmmqQAC",
                "Product_Name__c": "Sample",
                "Product_Family__c": "Standard",
                "Name": "PS-00000001"
            }
        ],
        "homeCountry": "UK"
    }

    connectedCallback(){
        getCustomerInfo({recordId : this.recordId})
            .then(result => {
                console.log('result: '+result);
                if (result) {
                    console.log('customer: '+this.customer);
                    this.customer = JSON.parse(result);
                }
            })
            .catch(error => {
                console.error("Error while fetching customer details" + error);
            });
    }

}