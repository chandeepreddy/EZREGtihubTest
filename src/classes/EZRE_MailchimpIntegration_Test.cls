/*
 * @author           Indumathi
 * @version          1.0 
 * @date             12/09/2014
 * @description      Unit test for EZRE_MailchimpIntegration.
 * @Modified By      Shahida M 
 * @Modified Date    1/03/2017  
 * @description      Added MCMemberSubscription custom Setting record insertion logic for member subscription.
                     When new custom record have been created for membersubscription.
 */  

@isTest
Private class EZRE_MailchimpIntegration_Test 
{
    /*
    public static testMethod void sendReqmtMail_Test() 
    { 

         

        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        
         //MCMemberSubscription custom Setting record insertion
         Mailchimp_Details__c objMCListSubscriptionApiDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCMemberSubscription','TestAPIKey','us9', 'C48756', 'A23545', 10);
        
         //Insert Mailchimp Custom setting for list
         MailchimpListDetails__c  listDetailsObj=EZRE_DataFactory_Test_Utility.createMCList('MCListContactInfo','TestCompany','TestAddress','TestCity','TestState','256352','TestCounty','JobAlert','TestFromName','test@test.com');
        
         //create JSON Wrapper
        EZRE_MailChimpIntegration.JSONWrapper obj = new EZRE_MailChimpIntegration.JSONWrapper(); 
        
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

            //Fetch Lead Recruiter profile
            Profile profile = EZRE_DataFactory_Test_Utility.fetchProfile(); 
         

            //Insert User record
            User objUser = EZRE_DataFactory_Test_Utility.createUser('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',profile.Id,'America/Los_Angeles','indhu_r@gmail.com','8143847962');

            //Insert Assign Requirement record     
            RequirementAssignment__c reqAssgn = EZRE_DataFactory_Test_Utility.createAssignmentReq(req.Id,objUser.Id);   
            test.starttest();
            Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
            test.stoptest();
            
            
            
            
        }
        
        System.assertEquals('Salesforce', req.Name);
        //System.assertEquals(2,EZRE_MailchimpIntegration.setSFDCCandidates.size()); 
    }*/

}