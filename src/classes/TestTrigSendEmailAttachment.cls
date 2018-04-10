@isTest
private class TestTrigSendEmailAttachment
 {  
  
    static testMethod void myUnitTest()
    {      
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);

        Requirement__c rc1= EZRE_DataFactory_Test_Utility1.CreateRqmt('Test Reqmt Name','20',200,
                                        250,400,'Open','Contract','AZ','Technical',5,'Irvine','Test Easy1',
                                        'Test Unique1','Test Skill Set','Test Recruiter Feedback');
        system.test.startTest();
        Candidate__c c = EZRE_DataFactory_Test_Utility1.CreateCand('TestCandidateName','TestCandidateLastName',
                                                    'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                                    'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                                    '9443322110','Test Emp Name','9011223344','Test Skill',true,'10.00 am to 12.00 pm');
       
        Profile ObjProfileR = EZRE_DataFactory_Test_Utility.fetchProfileRec();
        Profile ObjProfileLR = EZRE_DataFactory_Test_Utility.fetchProfile();
        //Insert User record
        User objUser = EZRE_DataFactory_Test_Utility.createUser('TestUser','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',ObjProfileR.Id,'America/Los_Angeles','indhu_r@gmail.com','8143847862');
        User objUser2 = EZRE_DataFactory_Test_Utility.createUser('TestUsr2','standarduser@cc.com','UTF-8','Testing','en_US','en_US',ObjProfileLR.Id,'America/Los_Angeles','indhu2_r@gmail.com','8143847862');        

        User lr = [Select u.Id from User u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User')  and u.IsActive=true limit 1];

        User r = [Select u1.Id from User u1 where (u1.Profile.Name ='Recruiter' or u1.Profile.Name ='R Chatter Only User')  and u1.IsActive=true limit 1];

        RequirementAssignment__c req1 = EZRE_DataFactory_Test_Utility1.CreateAssignRequirement(rc1.id,lr.id,r.id);
        User user = [Select Id from User limit 1];

        EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Candidate Approval Email with link EZRE'];            
        List<ContentVersion> contentList = new List<ContentVersion>();


        ContentWorkspace library = EZRE_DataFactory_Test_Utility1.GetContentVersion();
        
        ContentVersion contentVersionObj = EZRE_DataFactory_Test_Utility1.CreateContentVersion(library.id,c.Id,
                                                Blob.valueOf('Ayangar'),'http://www.google.com','Management Approach');          
            
      

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Sasikumar.Word');
        efa.setBody(Blob.ValueOf(et.Body));    
        String[] toAddresses = new string[]{'dummy@yahoo.com'};      
        mail.setToAddresses(toAddresses);                  
        OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'ezre@preludesys.com' limit 1];

        mail.setOrgWideEmailAddressId(owea.Id);   
        mail.setTemplateId(et.Id);                       
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        mail.saveAsActivity = false;            
        Candidate_Mapping__c co =  EZRE_DataFactory_Test_Utility1.CreateCandidateMapng(rc1.id,c.Id,'Approved','Approved',
                                    'Approved','Yes','test by lr','test by Mr','Approved');
        
                
        system.test.stopTest();  
        sendemailwithattachment se = new sendemailwithattachment();
        se.sendemail(co.id);  


   }     
 }