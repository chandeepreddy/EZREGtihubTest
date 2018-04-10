/*
* @Modified By      Shahida M 
* @Modified Date    1/03/2017  
* @description      Added MCMemberSubscription custom Setting record insertion logic for member subscription.
                     When new custom record have been created for membersubscription.
**/                     


@isTest
Private class EZRE_sendCndtEmailScheduler_Test 
{
   /* public static testMethod void Scheduler_Test() 
    { 
         //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        
         //Insert Mailchimp Custom setting for list
         MailchimpListDetails__c  listDetailsObj=EZRE_DataFactory_Test_Utility.createMCList('MCListContactInfo','TestCompany','TestAddress','TestCity','TestState','256352','TestCounty','JobAlert','TestFromName','test@test.com');
         
          //MCMemberSubscription custom Setting record insertion
         Mailchimp_Details__c objMCListSubscriptionApiDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCMemberSubscription','TestAPIKey','us9', 'C48756', 'A23545', 10);
         
         //create JSON Wrapper
        //EZRE_MailChimpIntegration.JSONWrapper obj = new EZRE_MailChimpIntegration.JSONWrapper(); 
        
        //Insert requirement record
        Requirement__c req = EZRE_DataFactory_Test_Utility.createReqWthCtgr('Salesforce','20',200,250,400,'Open','Contract','DC','In-Person',20,'Hyderabad',
                                               date.today(),'c','c','c','Active');
        //Insert Candidate record
        Candidate__c can = EZRE_DataFactory_Test_Utility.createActCan('TestCandidate','testing','chennai','Maine','Male','testEmployee',
                                                     'test@gmail.com','Mobile Phone','Corp to Corp','H1 B',100,'9176904882',
                                                     'test@gmail.com','TestContact','8143847962','jyothi','(326) 044-6881',date.today(),'c', 'Open', 'Active');

        //Fetch library data.
        List<ContentWorkspace> lstLibrary = EZRE_DataFactory_Test_Utility.fetchContent();

        if(lstLibrary != NULL && !lstLibrary.isEmpty())
        {
            //Insert ContentVersion record
            ContentVersion contentVersionObj = EZRE_DataFactory_Test_Utility.createContVer(lstLibrary[0].id,can.Id,Blob.valueOf('Data'),'http://www.google.com','Salesforce');

            System.assertEquals(req.Name,contentVersionObj.Title);

            Id [] fixedSearchResults= new Id[4];
            fixedSearchResults[0] = can.Id;
            fixedSearchResults[1] = req.Id;
            fixedSearchResults[2] = lstLibrary[0].Id;
            fixedSearchResults[3] = contentVersionObj.Id;
            Test.setFixedSearchResults(fixedSearchResults); 
        }
        //Fetch Lead Recruiter profile
        Profile profile = EZRE_DataFactory_Test_Utility.fetchProfile(); 
        
        
        //Insert User record
        User objUser = EZRE_DataFactory_Test_Utility.createUser('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',profile.Id,'America/Los_Angeles','indhu_r@gmail.com','8143847962');
        
        //Insert Assign Requirement record     
        RequirementAssignment__c reqAssgn = EZRE_DataFactory_Test_Utility.createAssignmentReq(req.Id,objUser.Id);   
        
        
        MCCandidateList__c objCndtLst1 = new MCCandidateList__c();
        objCndtLst1.Campaign_Name__c = 'Test Campaign';
        objCndtLst1.Campaign_Id__c = objMCDtl.Campaign_Id__c;
        objCndtLst1.From_email__c = 'test@gmail.com';
        objCndtLst1.Candidate_Email__c = 'testCndt@gmail.com';
        objCndtLst1.IsNew__c = true;
        insert objCndtLst1;
        
        MCCandidateList__c objCndtLst2 = new MCCandidateList__c();
        objCndtLst2.Campaign_Name__c = 'Test Campaign';
        objCndtLst2.Campaign_Id__c = objMCDtl.Campaign_Id__c;
        objCndtLst2.From_email__c = 'test@gmail.com';
        objCndtLst2.Candidate_Email__c = 'testCndt@gmail.com';
        objCndtLst2.IsNew__c = true;
        insert objCndtLst2;
        
        EZRE_MCEmailToAssignmentOwner.setCmpgnId = new Set<String>();           
        (EZRE_MCEmailToAssignmentOwner.setCmpgnId).add(objMCDtl.Campaign_Id__c);
        
        EZRE_MCEmailToAssignmentOwner.setEmlAddrss = new Set<String>();
        (EZRE_MCEmailToAssignmentOwner.setEmlAddrss).add('test@gmail.com');
        
        EZRE_MCEmailToAssignmentOwner.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MCEmailToAssignmentOwner.mapCmpgnIdNme).put(objMCDtl.Campaign_Id__c, 'Test Campaign');
        
        EZRE_MCEmailToAssignmentOwner.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MCEmailToAssignmentOwner.mapCmpgnIdFrmEml).put(objMCDtl.Campaign_Id__c, 'test@gmail.com');
        //SingleRequestMock mockResponse =new SingleRequestMock('http://api.example.com/accounts','[{"LastName": "Test Last Name"}]',null);
        //Test.setMock(HttpCalloutMock.class,mockResponse);
        
        
        
        EZRE_MCEmailToAssignmentOwner.sendMailToAssgnmntOwnr();
        
        Test.StartTest();
        sendCndtEmailScheduler objCndtEmailScheduler = new sendCndtEmailScheduler ();
        String strSchTime = '0 0 23 * * ?'; 
        system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler); 
        Test.stopTest();
    }*/
}