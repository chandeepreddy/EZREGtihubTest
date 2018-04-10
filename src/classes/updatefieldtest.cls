/*
 * @author           Aarthy
 * @version          1.0 
 * @date             1/30/2018
 * @description      Unit test for updatefield trigger.
 */  

@isTest
private class updatefieldtest
{
    static testMethod void display_Test()
    {   
       
     
       //Insert Requirement record
       Requirement__c req = EZRE_DataFactory_Test_Utility2.createReqrmnt('SampathReq','.net','6',2,100,200,200,'Hourly',
                                                                         'open','Contract','CA','CA',date.today(),false,'java');
          
        Requirement__c [] req1 = EZRE_DataFactory_Test_Utility2.fetchReqWOpp(); 
        UpdateRequirementCode.display(req1);
        Requirement__c reqr = EZRE_DataFactory_Test_Utility2.fetchRequirRec();
        reqr.won__c = true;
        Requirement__c updtReq  = EZRE_DataFactory_Test_Utility2.updateReq(reqr);
        system.assertEquals(updtReq.won__c,true);
         
        //Fetch Lead Recruiter profile
         Profile profile = EZRE_DataFactory_Test_Utility.fetchProfile(); 
         
         //Fetch role
         UserRole  objUserRole = EZRE_DataFactory_Test_Utility.fetchRole();
         
         User usr = EZRE_DataFactory_Test_Utility2.fetchCurrntUsr();
         
         //insert user role
         System.runAs(usr)
         {
         UserRole objUserRoleI = EZRE_DataFactory_Test_Utility.createUserRole('TestUserRole',objUserRole.Id);
         
         //Insert User record
         User objUser = EZRE_DataFactory_Test_Utility.createUser('TestUser','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',profile.Id,'America/Los_Angeles','indhu_r@gmail.com','8143847862');
         User objUser2 = EZRE_DataFactory_Test_Utility.createUser('TestUser','standarduser2@testorg.com','UTF-8','Testing','en_US','en_US',profile.Id,'America/Los_Angeles','indhu2_r@gmail.com','8143847862');
         
         User objUserMngr = EZRE_DataFactory_Test_Utility.createUserWithMngr('TestUsrs','kranthi@gmail.com','UTF-8','Testing','en_US','en_US',profile.Id,'America/Los_Angeles','indhu36_r@gmail.com','8143847862',objUser.Id,true,objUserRoleI.Id);
         User objUserUP = EZRE_DataFactory_Test_Utility.createUserWithMngr('TestUser','standarduser1203@testorg.com','UTF-8','Testing','en_US','en_US',profile.Id,'America/Los_Angeles','indhu3_r@gmail.com','8143847862',objUser2.Id,true,objUserRoleI.Id);          
         
        //Fetch users
         User ud = [select u.id from user u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User') and u.ManagerId!=null and u.IsActive = True limit 1 ];  
         User up = [Select u.Id from User u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User') and u.UserRole.ParentRoleId != null and u.IsActive= True and u.ManagerId!=null and u.Id!=:ud.Id limit 1 ];       
         
         RequirementAssignment__c assignReq = EZRE_DataFactory_Test_Utility2.createReqAss(req.Id,up.Id);
           
         RequirementAssignment__c ra = EZRE_DataFactory_Test_Utility2.fetchAssReq();
         RequirementAssignment__c updtdRcrd =[Select Id from RequirementAssignment__c where Id  =: ra.Id ];      
         updtdRcrd.Lead_Recruiter__c =ra.Lead_Recruiter__c;
         updtdRcrd.Recruiter__c = ra.Recruiter__c;
         updtdRcrd.won__c ='yes';       
         RequirementAssignment__c updtAssgnReq  = EZRE_DataFactory_Test_Utility2.updateAsgn(updtdRcrd); 
         System.assertEquals(updtAssgnReq.won__c,'yes');
        }
    }
}