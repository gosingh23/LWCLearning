@istest()
private class WS_CustomerAPI_Test {
    @IsTest
    static void test_getCustomerInfo_validUUID() {
        CustomerController_Test.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        WS_CustomerAPI apiClass = new WS_CustomerAPI();
        req.requestURI = '/services/apexrest/customer?customerUUID=UT123';
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            WS_CustomerAPI.getCustomerInfo();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    }

    @IsTest
    static void test_getCustomerInfo_invalidUUID() {
        CustomerController_Test.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        WS_CustomerAPI apiClass = new WS_CustomerAPI();
        req.requestURI = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/customer?customerUUID=random';
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            WS_CustomerAPI.getCustomerInfo();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    }

    @IsTest
    static void test_getCustomerInfo_noUUID() {
        CustomerController_Test.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        WS_CustomerAPI apiClass = new WS_CustomerAPI();
        req.requestURI = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/customer';
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            WS_CustomerAPI.getCustomerInfo();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    }
}