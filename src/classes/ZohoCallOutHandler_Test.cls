@isTest
public class ZohoCallOutHandler_Test {
    public static testMethod void callOutTest(){
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGenerator());
        Account a = new account();
        a.Name = 'TestZoho';
        a.BillingCity = 'Tx';
        a.BillingState = 'AT';
        a.BillingCountry = 'Us';
        a.AnnualRevenue = 1000;
        a.NumberOfEmployees = 50;
        a.Industry = 'Banking';
        a.Phone = '112233';
        a.Website = 'www.test.com';
        a.Lead_Gen_Name__c = 'Others';
        a.If_Others_Please_Specify__c = 'contact';
        insert a;
    }
}