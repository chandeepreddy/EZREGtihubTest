/**
 * @author           Indhu
 * @version          1.0 
 * @date             30-Jan-2015
 * @Status           Developed
 * @description      Test class for EZRE_ContentVersionTrigClass class which includes test scenarios.
 *
 */
@isTest
public class EZRE_ContentVersionTrigClass_Test
{ 
    ///OBJECTIVE
    /// Test Method for updateCandtContent method which includes positive test scenarios.
    ///OBJECTIVE
    static testMethod void updateCandtContent_Test()
    {        
        Candidate__c objCand = new Candidate__c();        
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
        insert objCand;
        
        ContentWorkspace objCntntWrkspc = [SELECT id FROM ContentWorkspace LIMIT 1];   
        if(objCntntWrkspc != NULL)
        {    
            Test.startTest();            
            
            ContentVersion objContentVersion = new ContentVersion();                  
            objContentVersion.FirstPublishLocationId = objCntntWrkspc.id;                   
            objContentVersion.VersionData = Blob.valueOf('Data'); 
            objContentVersion.Candidate_ID__c =objCand.id; 
            objContentVersion.PathOnclient = 'http://www.google.com';
            objContentVersion.Title = 'Salesforce';              
            insert objContentVersion;  
            
            EZRE_ContentVersionTrigClass.updateCandtContent(objContentVersion.id);
            
            Test.stopTest();
            system.assertEquals(objCand.Resume_Attach__c, null);
        }          
    }
    
    static testMethod void ContentVersionTrigger_Test()
    {        
        Candidate__c objCand = new Candidate__c();        
        objCand.Name = 'TestCandidateName';
        objCand.Last_name__c = 'TestCandidateLastName';
        objCand.Current_city__c = 'Irvine';
        objCand.Current_state__c = 'Arizona';
        objCand.Gender__c = 'Male';
        objCand.Employer_Name__c = 'Test Employee';
        objCand.Email__c = 'testtestseconduser@testOrg.com';
        objCand.interview_contact_phone__c = 'Mobile Phone';
        objCand.Contract_type__c = 'Corp to Corp';
        objCand.visa_type__c = 'H1 B';
        objCand.cost__c = 100;
        objCand.mobile_phone_no__c = '5566447788';
        objCand.employer_contact_email__c = 'test@testmail.com';
        objCand.Employer_Contact_Name_Name__c = 'Test Contact Name';
        objCand.Employer_Mobile_No__c = '9443322110'; 
        objCand.Employer_Work_Phone_No__c = '9011223344';              
        objCand.Followup_Date__c = date.today();              
        objCand.Skills__c = 'Test Skill'; 
        insert objCand;

        ContentVersion objContentVersion = new ContentVersion();  
        objContentVersion.VersionData = Blob.valueOf('Data');
        objContentVersion.PathOnclient = 'http://www.google.com';
        objContentVersion.Title = 'Salesforce';              
        insert objContentVersion; 
        
        ContentWorkspace objCntntWrkspc = [SELECT id FROM ContentWorkspace LIMIT 1];     
        ContentVersion ContentVersion = [select ContentDocumentId from ContentVersion 
                                                where id =:objContentVersion.id LIMIT 1];
        
        ContentWorkspaceDoc objCntWrkspcDoc = new ContentWorkspaceDoc();
        objCntWrkspcDoc.ContentWorkspaceId = objCntntWrkspc.id;
        objCntWrkspcDoc.ContentDocumentId = ContentVersion.ContentDocumentId;
        insert objCntWrkspcDoc;
        
        ContentVersion.Candidate_ID__c = objCand.id;
        update ContentVersion;
    }
}