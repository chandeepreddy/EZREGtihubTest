trigger amountApprovalSubmits on Approval__c (after insert, after update)
{
    for (Approval__c a : trigger.new) 
    {
        // create the new approval request to submit
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(a.id);
        // submit the approval request for processing
        Approval.ProcessResult result = Approval.process(app);

    }

}