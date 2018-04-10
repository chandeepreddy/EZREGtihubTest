@isTest
private class testclass
{
    static testmethod void testclassmethod()
    {
      
        CustomAccountLookupController acc = new CustomAccountLookupController();
        Account a = new account();
        Candidate__c c = new candidate__c();
        //acc.CustomAccountLookupController();
        acc.search();
        //acc.runSearch();
        acc.saveAccount();    
    }
}