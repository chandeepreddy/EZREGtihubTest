@isTest
public class EZRE_FeedbackUpdateTrigger_Test
{ 
    
    //**************************************Requirement Controller**********************************************    
    ///OBJECTIVE
    /// Test Method for Requirement controller contructor method which includes positive test scenarios.
    ///OBJECTIVE
    static testMethod void ReqmtCtrlrConstructor_Test() 
    { 
        //Creating test data for Requirement
        Requirement__c objReqmt = EZRE_DataFactory_Test_Utility1.CreateRqmt('Test Reqmt Name','20',200,
                                        250,400,'Open','Contract','AZ','Technical',5,'Irvine','Test Easy1',
                                        'Test Unique1','Test Skill Set','Test Recruiter Feedback');
    }
}