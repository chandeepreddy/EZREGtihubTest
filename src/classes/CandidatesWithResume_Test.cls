/*
*@author        Kirankumar
*@Version       1.0
*@date          22-03-2016
*description    Test class for CandidatesWithResume
*/
@isTest
public class CandidatesWithResume_Test
{
    ///<OBJECTIVE>
    ///test method to test constructor
    ///</OBJECTIVE>
    static testMethod void CandidateWithResume_Cnstr_Test()
    {
       //Insert Candidate
        Candidate__c objCand = new Candidate__c();
        objCand.Name = 'Test';
        objCand.Last_Name__c = 'Candidate';
        objCand.Mobile_Phone_No__c = '9099857675';
        objCand.Gender__c ='Male';
        objCand.Category__c = 'Open'; 
        objCand.Current_State__c = 'Chennai';
        objCand.Current_City__c = 'Chennai';
        objCand.Followup_Date__c = Date.today();
        objCand.Email__c = 'Test@gmail.com';
        objCand.Cost__c = 1000;
        objCand.Interview_Contact_Phone__c = 'Mobile Phone';
        objCand.Contract_Type__c = 'W2';
        objCand.Visa_Type__c = 'H1B';
        objCand.Resume_Source__c = 'Dice';
        insert objCand;    
        //Insert Contentversion  
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
            CandidatesWithResume objcandidate = new CandidatesWithResume();
            objcandidate.updatecanddiates();
            Test.stopTest();
            
        }   
        
    }
}