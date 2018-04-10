/**
 * @author           Shahida k
 * @version          1.0 
 * @date             31.08.2016
 * @Status           Developed
 * @description      Test class to updateAssReqWon trigger functionality.
 * @modifiedBy       Shahida K
 * @modifiedDate     01/18/2017
 * @description      isFutureUpdate flag check to avoid recusive trigger call when  EZRE_SendReqmtAssignMailTrigger is fired.

 */
@isTest
public class updateAssReqWon_Test
{
   ///OBJECTIVE
   /// Method to test FTE requirements change tracking functionality of 'updateAssReqWon' trigger
   ///OBJECTIVE
   public static testmethod void updateFteRequirement_Positive_Test()
   {
   
        date dtStatusUpdatedate = system.today().addDays(1);
        EZRE_RecursionCheckforTrigger.isFutureUpdate=false;
        Test.StartTest();
        
        //Insert Requirement with Type as'FTE'  
        Requirement__c Rqrmnt= EZRE_DataFactory_Test_Utl.CreateRqrmnt('.NET Developer','2 months' ,200.00,
                                                                       400.00, 600.00, 'Open', '',
                                                                      'Tamilnadu','tech',2 , 'chennai',
                                                                      'skillset', 'testUnique','testSkillSet', 
                                                                      'testFeebback',true,dtStatusUpdatedate ,
                                                                      'testJobCategory','FTE'); 
       //Update FTE Requirement  
       Rqrmnt.status__c='Manually Closed';  
       Rqrmnt.Skill_Level__c='Expert';                                                                              
       Requirement__c updtRqrmnt=EZRE_DataFactory_Test_Utility.updateReq(Rqrmnt);       
       Integer emailSent = Limits.getEmailInvocations();                                   
       Test.StopTest();
       system.assertEquals(emailSent ,1);                                                                          
   
   
   }
   ///OBJECTIVE
   /// Method to test 'updateAssReqWon' trigger functionality with Requirement Type as None
   ///OBJECTIVE
   public static testmethod void updateFteRequirement_Negative_Test()
   {
   
        date dtStatusUpdatedate = system.today().addDays(1);
        EZRE_RecursionCheckforTrigger.isFutureUpdate=false;
        Test.StartTest();
       //Insert Requirement without Type value
        Requirement__c Rqrmnt= EZRE_DataFactory_Test_Utl.CreateRqrmnt('.NET Developer','2 months' ,200.00,
                                                                       400.00, 600.00, 'Open', '',
                                                                      'Tamilnadu','tech',2 , 'chennai',
                                                                       'skillset', 'testUnique','testSkillSet', 
                                                                      'testRecruiterFeedBack',true,dtStatusUpdatedate ,
                                                                      'testJobCategory','None');   
       //Update Requirement                                                                     
       Rqrmnt.status__c='Manually Closed';  
       Rqrmnt.Recruiter_Feedback__c='';                                                                            
       Requirement__c updtRqrmnt=EZRE_DataFactory_Test_Utility.updateReq(Rqrmnt);  
       Integer emailSent = Limits.getEmailInvocations();   
                                     
       Test.StopTest();
       system.assertEquals(emailSent ,0);                                                                            
   
   
   }

}