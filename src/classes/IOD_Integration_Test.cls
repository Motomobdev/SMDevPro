@isTest(SeeAllData=true)
public class IOD_Integration_Test{

    public static testMethod void testCall() {
    
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        IOD_Integration.runjob('ebd005@motorola.com','tt0mred#1','SF to NPI GPPD Product SF ID','DSS');

        IOD_Integration ii = new IOD_Integration();
        ii.init();
    }
}