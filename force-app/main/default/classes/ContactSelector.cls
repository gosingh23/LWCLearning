/**
* This is the selector class for Contact Object
*
* @author gosingh
*/
public with sharing class ContactSelector {
    // CONSTANT DECLARATION
    public static final String CONTACT_UUID = 'ContactUUID';
    public static final String CASE_ID = 'CaseId';

    /**
	 * Prepares a query to get contact details based on Id or UUID.
     * @param idValue Id or UUID of customer
	 * @return query string.
	 */
    private static String getContactDetailsById (String idValue) {
        String query = 'SELECT (SELECT ';
        for(Schema.FieldSetMember f : getProductFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Product_Subscriptions__r), Id, Name, Home_Country__r.Country_Code__c FROM Contact WHERE UUID__c =: idValue OR Id =: idValue';
        
        return query;
    }

    /**
	 * Prepares a query to get contact details based on related case Id.
     * @param idValue realted CaseId of a customer
	 * @return query string.
	 */
    private static String getContactDetailsByCaseId (String idValue) {
        String query = 'SELECT (SELECT ';
        for(Schema.FieldSetMember f : getProductFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Product_Subscriptions__r), Id, Name, Home_Country__r.Country_Code__c FROM Contact WHERE Id IN (SELECT ContactId FROM Case WHERE Id =: idValue)';
        
        return query;
    }

    /**
	 * Queries ContactDetails after preparing query based on input parameters.
     * @param idValue Id, UUID or related CaseId of customer.
     * @param fieldName defines if query should be run based on customerId or caseId
	 * @return customer UUID.
	 */
    public static Contact getContactDetails(String idValue, String fieldName) {
        String query;

        if (String.isBlank(idValue)) {return null;}

        if(fieldName == CONTACT_UUID) {
            query = getContactDetailsById(idValue);
        } else if(fieldName == CASE_ID) {
            query = getContactDetailsByCaseId(idValue);
        } else {
            return null;
        }

        List<Contact> contacts = new List<Contact>();
        try{
            contacts = Database.query(query);
        } catch(Exception e) {
            system.debug('Exception: '+e);
        }
        
        return (contacts.isEmpty() ? null : contacts.get(0));
    }

    /**
	 * Retreives fields from 'Basic' fieldset of Product__c object
	 * @return customer UUID.
	 */
    private static List<Schema.FieldSetMember> getProductFields() {
        return SObjectType.Product__c.FieldSets.Basic.getFields();
    }
}
    