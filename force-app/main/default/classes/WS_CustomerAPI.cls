/**
* This is the RestAPI gateway for Customer info related integrations
*
* @author gosingh
*/
@RestResource(urlMapping='/customer/*')
global with sharing class WS_CustomerAPI {
    /**
	 * Method to handle GET requests
	 * @return RestResponse
	 */
    @HttpGet
    global static void getCustomerInfo () {

        String contactUUID = '';
        RestRequest restReq = RestContext.request;
        // Reading parametrs from URL        
        contactUUID = getCustomerUuidFromParameters(restReq);
        
        if(contactUUID == null || contactUUID == '') {
            RestResponse restResponse = prepareResponse(null);
        }

        Contact aContact = ContactSelector.getContactDetails(contactUUID, ContactSelector.CONTACT_UUID);
        ContactInformationHandler.CustomerDetails cd = ContactInformationHandler.returnContactDetails(aContact);
        
        RestResponse restResponse = prepareResponse(cd);
    }

    /**
	 * Method to parse request parameters. This currently returns a string but can be extended to returna a map.
	 * @return customer UUID.
	 */
    private static String getCustomerUuidFromParameters(RestRequest restReq) {
        return restReq.params.get('customerUUID');
    }
    
    /**
	 * Formats the customer details into a JSON object
	 * @return RestResponse
	 */
    private static RestResponse prepareResponse(ContactInformationHandler.CustomerDetails cd) {
        RestResponse restRes = RestContext.response;
        restRes.addHeader('Content-Type', 'application/json');
        //String responseBody;
        try {
            if(cd != null){
                restRes = setResponse(String.valueOf(JSON.serialize(cd)), 200);
            } else {
                restRes = setResponse('Customer not found', 200);
            }
        } catch(Exception e) {
            restRes = setResponse('Salesforce Internal Error', 500);
        }

        return restRes;
    }

    private static RestResponse setResponse(String responseBody, Integer statusCode) {
        RestResponse restResponse = RestContext.response;
        restResponse.addHeader('Content-Type', 'application/json');
        restResponse.responseBody = Blob.valueOf(responseBody);
        restResponse.statusCode = statusCode;

        return restResponse;
    }
}