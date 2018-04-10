/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestTriggerRequirement {

    static testMethod void myUnitTest() {
    
      //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        
       Requirement__c req=new Requirement__c();
       string createdid=UserInfo.getUserId();    
       system.debug('sample:'+createdid);
       
       //Fetch Lead Recruiter profile
       Profile profileLR = EZRE_DataFactory_Test_Utility.fetchProfile(); 
       //Fetch Lead Recruiter profile
       Profile profileR = EZRE_DataFactory_Test_Utility.fetchProfileRec();    
        //Fetch role
         UserRole  objUserRole = EZRE_DataFactory_Test_Utility.fetchRole();
         
         User usr = [Select id from user where Id =: UserInfo.getUserId()];
         
         //insert user role
         System.runAs(usr)
         {
         UserRole objUserRoleI = EZRE_DataFactory_Test_Utility.createUserRole('TestUserRole',objUserRole.Id);
         
         //Insert User record
         User objUser = EZRE_DataFactory_Test_Utility.createUser('TestUser','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',profileR.Id,'America/Los_Angeles','indhu_r@gmail.com','8143847862');
         User objUser2 = EZRE_DataFactory_Test_Utility.createUser('TestUser','standarduser2@testorg.com','UTF-8','Testing','en_US','en_US',profileR.Id,'America/Los_Angeles','indhu2_r@gmail.com','8143847862');
         
         User objUserMngr = EZRE_DataFactory_Test_Utility.createUserWithM('TstUsrs','kranthi322@gmail.com','UTF-8','Testing','en_US','en_US',profileLR.Id,'America/Los_Angeles','indhu366_r@gmail.com','8143847862',objUser.Id,true);
         User objUserMngr2 = EZRE_DataFactory_Test_Utility.createUserWithMngr('TestUsrs','kranthi@gmail.com','UTF-8','Testing','en_US','en_US',profileR.Id,'America/Los_Angeles','indhu36_r@gmail.com','8143847862',objUser.Id,true,objUserRoleI.Id);
         User objUserUP = EZRE_DataFactory_Test_Utility.createUserWithMngr('TestUser','standarduser1203@testorg.com','UTF-8','Testing','en_US','en_US',profileLR.Id,'America/Los_Angeles','indhu3_r@gmail.com','8143847862',objUser2.Id,true,objUserRoleI.Id); 
       
        User ud = [select u.id from user u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User') and u.ManagerId!=null and u.IsActive= True limit 1 ];  
        system.debug('BRIUD:' + ud);     
      
       User up =[Select u.Id from User u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User') and u.UserRole.ParentRoleId != null and u.IsActive= True and u.ManagerId!=null and u.Id!=:ud.Id limit 1 ];
       system.debug('BRIUP:' + up);
       
        User ud1 = [select u.id from user u where (u.Profile.Name ='Recruiter' or u.Profile.Name ='R Chatter Only User') and u.ManagerId!=null and u.IsActive= True limit 1 ];  
       system.debug('BRIUD:' + ud1);
       
      /* User up1 =[Select u.Id from User u where (u.Profile.Name ='Recruiter' or u.Profile.Name ='R Chatter Only User') and u.UserRole.ParentRoleId != null and u.IsActive= True and u.ManagerId!=null and u.Id!=:ud1.Id limit 1 ];
       system.debug('BRIUP:' + up1);*/

             
        
       Test.startTest();
       RequirementAssignment__c oppa=new RequirementAssignment__c();

       //for(Integer j=0;j<=5; j++)
     
      // {
            req=new requirement__c();

            req.Name='test';  //+j;
            //req.Job_Title__c='test';
            //req.client__c='123greeting';
            req.Duration__c='6';
            req.Max_Cost__c=100.00;
            req.Min_Cost__c=70.00;
            req.Rate__c=150.00;
            req.Est_Start_Date__c=date.today();
            req.Position_Type__c='Direct';
            req.State__c='MI';
            req.Status__c='open';
            req.No_Of_Resumes__c=1;
            req.City__c='tn';
            req.Easy1__c='test';
            req.Unique_1__c='test';
            req.resumes_2__c = 1;
                   
            insert req;
            System.debug('BRIUP1:' + req);  
           
            oppa=new RequirementAssignment__c();
            oppa.Requirement__c=req.Id;
        
          if(ud.Id != null)
          {
                oppa.Lead_Recruiter__c=ud.Id;
                System.Debug('U:'+  oppa.Lead_Recruiter__c);
          } 
          else
          { 
              //oppa.Lead_Recruiter__c='';
              oppa.Recruiter__c =ud1.Id;
              System.Debug('U:'+ oppa.Recruiter__c); 
          } 
          
          //oppa.assignstatus__c = 'true';
              
          System.Debug('BRIAssignedUser : ' + oppa.Lead_Recruiter__c);
          insert oppa;
          }
          req.status__c='Auto Closed';
          update req;
                
          req.status__c='Manually Closed';
          update req;
          
          if(req.Status__c == 'Manually Closed')
                 {
                     req.Resumes_2__c = 0;
                    req.isReopen__c = false;  
                     req.Req_Closed_Date__c= datetime.now();
                }
                
                 if(req.Status__c == 'Auto Closed')
                 {
                     req.isReopen__c = false;  
                     req.Req_Closed_Date__c= datetime.now();
                }

          
          req.opportunity_code__c = 'tes13020401';
          req.Status__c = 'Re-open';
          req.No_Of_Resumes__c= 2;
         
          update req;
        if(req.Status__c == 'Re-open' && req.isReopen__c == false)
                 {
                     req.isReopen__c = true;
                     req.Submitted_Resumes__c = 0;  
                     req.Resumes_2__c = 3;
                }
                
               
   
 //} 
 
 Test.stopTest(); 
 }
 }