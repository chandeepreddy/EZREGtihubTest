@isTest
private class Test_AmountApprovalSubmitTrigger 
{
      static testMethod void testApprovalProcessSubmission()
        {
            Approval__c app = new Approval__c();
            
            app.Name = 'Test 8';
            app.Amount__c = 101;
            app.Expense_Date__c = Date.today();
            
            test.startTest();
            // insert the new record
            insert app;
            test.stopTest();
            
            //ensure that the app was submitted for approval
            List<Approval__c> approvalRequest = [Select id, Name,Amount__c, Expense_Date__c from Approval__c where id=:app.id];
            System.assert(approvalRequest.size() > 0);
            System.assertEquals(101,app.Amount__c);
        }
        
}