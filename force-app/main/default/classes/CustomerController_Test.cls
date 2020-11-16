@isTest()
public class CustomerController_Test {
    static Country__c testCountry;
    static Product2 sampleProduct;
    static Contact testContact;
    static Case testCase;
    static Product__c subscription;

    public static void makeData() {
        testCountry = new Country__c(Name = 'United Kingdom',
                                        Country_Code__c = 'UK',
                                        Currency_ISO_Code__c = 'GBP'
                                    );
        sampleProduct = new Product2(StockKeepingUnit = 'UT01TEST',
                                        Name = 'Sample',
                                        Family = 'Standard'
                                    );
        insert testCountry;
        insert sampleProduct;

        testContact = new Contact(FirstName = 'Unit',
                                    LastName = 'TestContact',
                                    Email = 'unit@test.ex.co.ut',
                                    Home_Country__c = testCountry.Id,
                                    UUID__c = 'UT123'
                                );

        insert testContact;

        subscription = new Product__c ( Contact__c = testContact.Id,
                                        Product__c = sampleProduct.Id
                                    );
        
        insert subscription;
    }

    @IsTest
    static void test_getCustomerInfo_validCaseId() {
        makeData();

        testCase = new Case (ContactId = testContact.Id,
                            Status = 'New',
                            Subject = 'UnitTest');
        insert testCase;

        Test.startTest();
            String response = CustomerController.getCustomerInfo(testCase.Id);
        Test.stopTest();

        ContactInformationHandler.CustomerDetails customerDetail = (ContactInformationHandler.CustomerDetails)JSON.deserialize(response, ContactInformationHandler.CustomerDetails.class);
        System.assertEquals('UK', customerDetail.homeCountry);
        System.assertEquals('Sample', customerDetail.products[0].Product_Name__c);
    }

    @IsTest
    static void test_getCustomerInfo_inValidCaseId() {
        makeData();

        Test.startTest();
            String response = CustomerController.getCustomerInfo(testCountry.Id);
        Test.stopTest();
        system.debug(response);
        ContactInformationHandler.CustomerDetails customerDetail = (ContactInformationHandler.CustomerDetails)JSON.deserialize(response, ContactInformationHandler.CustomerDetails.class);
        system.debug(customerDetail);
        System.assertEquals(null, customerDetail);
        
    }

    @IsTest
    static void test_getCustomerInfo_nullCaseId() {
        makeData();
        Test.startTest();
            String response =  CustomerController.getCustomerInfo(null);
        Test.stopTest();

        System.assertEquals(null, response);
        
    }
}
