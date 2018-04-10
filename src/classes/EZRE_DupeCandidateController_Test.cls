/**
 * @author           Shahida
 * @version          1.0 
 * @date             18/02/2016
 * @Status           Developed
 * @description      Test class to Duplicate Candidates funtionality
 *
 */
 @isTest
public class EZRE_DupeCandidateController_Test
{
    //<OBJECTIVE>
    //Test method to test duplicate candidates funtionaity
    static testmethod void DuplicateCandidatesTest()
    {
        //Insert Candidate
        /*Candidate__c objCand = new Candidate__c();        
        objCand.Name = 'TestCandidateName';
        objCand.Last_name__c = 'TestCandidateLastName';
        objCand.Current_city__c = 'Irvine';
        objCand.Current_state__c = 'Arizona';
        objCand.Gender__c = 'Male';
        objCand.Employer_Name__c = 'Test Employee';
        objCand.Email__c = 'testtestfirstuser@testOrg.com';
        objCand.interview_contact_phone__c = 'Mobile Phone';
        objCand.Contract_type__c = 'Corp to Corp';
        objCand.visa_type__c = 'H1 B';
        objCand.cost__c = 100;
        objCand.mobile_phone_no__c = '9123456789';
        objCand.employer_contact_email__c = 'test@testmail.com';
        objCand.Employer_Contact_Name_Name__c = 'Test Contact Name';
        objCand.Employer_Mobile_No__c = '9443322110'; 
        objCand.Employer_Work_Phone_No__c = '9011223344';              
        objCand.Followup_Date__c = date.today();              
        objCand.Skills__c = 'Test Skill'; 
        insert objCand;*/
            //Insert Candidate
      Candidate__c objCandt=EZRE_DataFactory_Test_Utl.CreateCandidate('TestCandidateName','TestCandidateLastName','Irvine','Arizona','Male','Test Employee',
                                                    'testtest@testOrg.com','Mobile Phone','Corp to Corp','H1 B',
                                                     100,'9123456789','test@testmail.com','Test Contact Name',
                                                    '9443322110','9011223344', date.today(),'Test Skill');                    
                                   
        test.StartTest();                                              
        PageReference pageRef = page.EZRE_DuplicateCandidateDownloadPage;
        system.Test.setCurrentPage(pageRef);        
        EZRE_DuplicateCandidateDwnLoadController objCandidate= new EZRE_DuplicateCandidateDwnLoadController();  
        objCandidate.exportDuplicateCandidates();    
        test.StopTest();
        
    }

}