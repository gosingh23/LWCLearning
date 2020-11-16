/**
* This is the handler class to contain helper methods for contact information processing
*
* @author gosingh
*/
public class ContactInformationHandler {
     /**
	 * converts the contact details into the structure defined in 'CustomerDetails' class
	 * @param  aContact contact details
	 * @return Formatted customer info.
	 */
    public static CustomerDetails returnContactDetails(Contact aContact) { 
        if (aContact == null){
            return null;
        }
        
        List<Product__c> products = new List<Product__c>();
        
        for (Product__c p : aContact.Product_Subscriptions__r){
            products.add(p);
        }
        CustomerDetails cd = new CustomerDetails(aContact.Home_Country__r.Country_Code__c, products);
        
        return cd;
    }
    
    /**
    * This is an inner class to define the response structure of contact information
    *
    * @author gosingh
    */
    public class CustomerDetails {
        @testVisible String homeCountry;
        @testVisible List<Product__c> products;
        
        public CustomerDetails (String homeCountry, List<Product__c> products) {
            this.homeCountry = homeCountry;
            this.products = new List<Product__c>(products);
        }
    }
}