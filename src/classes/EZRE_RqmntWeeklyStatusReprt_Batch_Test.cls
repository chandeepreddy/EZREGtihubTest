/**
 * @author           Shahida
 * @version          1.0 
 * @date             21/03/2016
 * @Status           Developed
 * @description     Test functionality of resumes submitted count based on requirement Type in Requirement. 
 *
 */
 @isTest
 public class EZRE_RqmntWeeklyStatusReprt_Batch_Test
 {
     public static testmethod void RqmntWlyStRprtPositive_Test()
     {
          date dtStatusUpdatedate=Date.Today();   
          //Insert Requirement with Type as'Test Type'  
          Requirement__c Reqmt = EZRE_DataFactory_Test_Utl.CreateRqrmnt('.NET Developer','2 months' ,200.00,
                                                                           400.00, 600.00, 'Open', '',
                                                                          'Tamilnadu','tech',2 , 'chennai',
                                                                          'skillset', 'testUnique','testSkillSet', 
                                                                          'testFeebback',true,dtStatusUpdatedate ,
                                                                          'testJobCategory','FTE'); 
           //Insert Requirement with Type as'Test Type'                                                                
          Requirement__c RqmtRec = EZRE_DataFactory_Test_Utl.CreateRqrmnt('.NET Developer','2 months' ,200.00,
                                                                           400.00, 600.00, 'Open', '',
                                                                          'Tamilnadu','tech',2 , 'chennai',
                                                                          'skillset', 'testUnique','testSkillSet', 
                                                                          'testFeebback',true,dtStatusUpdatedate ,
                                                                          'testJobCategory','FTE');
                                                          
           //Insert Candidate
           Candidate__c objCand=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
                                                                                                
         //Insert candidate mapping(attach resume) to requiement                                                                       
          Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
         'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
         'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
         'Yes','Yes','Yes','TestComments',Date.Today()-1,RqmtRec.Id,objCand.Id,Datetime.Now(),Datetime.Now(),Datetime.Now()); 
        
           Test.startTest();                               
          EZRE_RequirementWeeklyStatusReprt_Batch reqDlyStsRprt=new EZRE_RequirementWeeklyStatusReprt_Batch();               
           Database.executeBatch(reqDlyStsRprt, 400);         
           Test.stopTest();    
          
         
     }
     
 
 
 
 }