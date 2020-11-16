/**
* This is the apex controller for the CustomerInfo LWC
*
* @author gosingh
*/
public without sharing class CustomerController {
    /**
	 * primary method to return customer details the LWC component
	 * @param  recordId Case Id
	 * @return JSON formatted customer info.
	 */
    @AuraEnabled
    public static String getCustomerInfo (String recordId) {
        if(recordId == null || recordId == '') {
            return null;
        }

        Contact aContact = ContactSelector.getContactDetails(recordId, ContactSelector.CASE_ID);
        ContactInformationHandler.CustomerDetails cd = ContactInformationHandler.returnContactDetails(aContact);
        
        return prepareResponse(cd);
    }

    /**
	 * Formats the contact info to a JSON
	 * @param  cd customer details
	 * @return JSON formatted customer info.
	 */
    private static String prepareResponse(ContactInformationHandler.CustomerDetails cd) {
        String response = '';
        try {
            response = (String.valueOf(JSON.serialize(cd)));
        } catch(Exception e) {
            System.debug('Error: '+e);
            response = null;
        }

        return response;
    }
}
