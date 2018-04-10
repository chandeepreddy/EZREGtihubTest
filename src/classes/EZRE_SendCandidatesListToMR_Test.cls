/**
 * @author            Shahida K
 * @version           1.0 
 * @date              05/02/2016
 * @Status            Developed
 * @description       This is a Test class for Candidates waiting for MR approval email class.
 *
 */
@istest
public class EZRE_SendCandidatesListToMR_Test
{
 
    ///<OBJECTIVE>
    ///Method to get test candidtes waiting for MR approval email sending functionality
    ///</OBJECTIVE>
    
    public static testMethod void SendCandidatesListToMR_Positive_Test() 
    { 
        //Insert Requirement
        Requirement__c objReqmt = EZRE_DataFactory_Test_Utility1.CreateRqmt('Test Reqmt Name','20',200,
                                                    250,400,'Open','Contract','AZ','Technical',5,'Irvine','Test Easy1',
                                                    'Test Unique1','Test Skill Set','Test Recruiter Feedback');  
    
        //Insert Candidate
        Candidate__c objCand=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');
                                
        //Fetch ContentWorkspace                                                     
        List<ContentWorkspace> lstLibrary = EZRE_DataFactory_Test_Utility.fetchContent();
                                                  
        if(lstLibrary != NULL && !lstLibrary.isEmpty())
        {
            //Insert ContentVersion record
            ContentVersion contentVersionObj = EZRE_DataFactory_Test_Utility1.CreateContentVersion(lstLibrary[0].id,objCand.Id,
                                                   Blob.valueOf('Data'),'http://www.google.com','Salesforce');
        }
        //Insert Candidate Mapping with status given as approved by recruiter and waiting for MR approval
        Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utility1.InsertCandMapng('LR Approved','test','test by lr','test by MR',
                                          'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
                                          'Approved','','07/07/2015','07/07/2015','Yes','Yes','Yes',
                                          'Yes','Yes','Yes','TestComments',Date.Today()-1,objReqmt.Id,objCand.Id);    
        EZRE_SendCandidatesListToMR objCandt=new EZRE_SendCandidatesListToMR();
        //In this scenario we get candidate mapping record to send mail.Because record inserted in candidate mapping with status is 'LR Approved'
        objCandt.SendCandidatesListToMR();

    }
    public static testMethod void SendCandidatesListToMR_Negative_Test() 
    { 
        //Insert Requirement
        Requirement__c objReqmt = EZRE_DataFactory_Test_Utility1.CreateRqmt('Test Reqmt Name','20',200,
                                                    250,400,'Open','Contract','AZ','Technical',5,'Irvine','Test Easy1',
                                                    'Test Unique1','Test Skill Set','Test Recruiter Feedback');  
    
        //Insert Candidate
        Candidate__c objCand=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');
                                
        //Fetch ContentWorkspace                                                     
        List<ContentWorkspace> lstLibrary = EZRE_DataFactory_Test_Utility.fetchContent();
                                                 
        if(lstLibrary != NULL && !lstLibrary.isEmpty())
        {
            //Insert ContentVersion record
            ContentVersion contentVersionObj = EZRE_DataFactory_Test_Utility1.CreateContentVersion(lstLibrary[0].id,objCand.Id,
                                                   Blob.valueOf('Data'),'http://www.google.com','Salesforce');
        }
        //Insert Candidate Mapping with status given as rejected by recruiter 
        Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utility1.InsertCandMapng('LR Approved','test','test by lr','test by MR',
                                          'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
                                          'Rejected','','07/07/2015','07/07/2015','Yes','Yes','Yes',
                                          'Yes','Yes','Yes','TestComments',Date.Today()-1,objReqmt.Id,objCand.Id);    
        EZRE_SendCandidatesListToMR objCandt=new EZRE_SendCandidatesListToMR();
        //In this scenario no records returned because candidate mapping record status is 'rejected'.
        objCandt.SendCandidatesListToMR();

    }
    
}