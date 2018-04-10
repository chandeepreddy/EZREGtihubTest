/*
 * @author           Soumya
 * @version          1.0 
 * @date             11/11/2014
 * @description      Test Class for classes: LinkedInIntegrationCntrl & EZRE_AssignRequirementCntrl
 */  

@isTest
Private class EZRE_LinkedInIntegration_Test 
{
    public Static LinkedInDetails__c linkedInCustSet;
    public Static PageReference pageRef;
    public Static Cookie tknCookie, rqmntCookie, hostCookie, actionCookie;
    public Static EZRE_LinkedInIntegrationCntrl integCtrl = new EZRE_LinkedInIntegrationCntrl();
    public Static Profile prof;
    public Static User usr;
    public Static Requirement__c rqmnt;
    public Static RequirementAssignment__c reqAssgn;
    
    //Create Test data
    public Static testMethod void createTestData()
    {
         //Fetch Lead Recruiter profile
        prof = EZRE_DataFactory_Test_Utility.fetchProfile(); 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        
        usr = EZRE_DataFactory_Test_Utility.createUser('Usr2','emailLinkedIn@testorg.com','UTF-8','Testing','en_US','en_US',prof.Id,
                                'America/Los_Angeles','emailLinkedIn@gmail.com','1243847862');
                                
        rqmnt = EZRE_DataFactory_Test_Utility.createReq('Test Requirement3','20',200,250,400,'Open','Contract','DC','In-Person',20,'Hyderabad',
                                                                   date.today(),'c','c','c');
                                                                   
        reqAssgn = EZRE_DataFactory_Test_Utility.createAssignmentReq(rqmnt.Id,usr.Id);
        System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    
    //Test Class for LinkedIn Integration class: Access Token is valid
    public static testMethod void createTestDatawithAccsTkn()
    {
        linkedInCustSet = new LinkedInDetails__c();
        linkedInCustSet.Name = 'Recruiting App';
        linkedInCustSet.AccessToken__c = 'testToken';
        linkedInCustSet.API_Key__c = 'testClientId';
        linkedInCustSet.API_Secret__c = 'testClientSecret';
        linkedInCustSet.ValidTo__c = System.today().addDays(10);
        insert linkedInCustSet;
        
        rqmnt = EZRE_DataFactory_Test_Utility.createReq('Test Requirement1','20',200,250,400,'Open','Contract','DC','In-Person',20,'Hyderabad',
                                                                date.today(),'c','c','c');
        
        pageRef = Page.EZRE_LinkedInIntegrationPg;
        pageRef.getParameters().put('id',rqmnt.Id);      
        System.assertEquals(rqmnt.Name,'Test Requirement1');  
    }
    
    //Test Class for LinkedIn Integration class: Access Token is expired
    public static testMethod void createTestDataWOAccsTkn()
    {
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        linkedInCustSet = new LinkedInDetails__c();
        linkedInCustSet.Name = 'Recruiting App';
        linkedInCustSet.API_Key__c = 'testClientId';
        linkedInCustSet.API_Secret__c = 'testClientSecret';
        insert linkedInCustSet;
        
        createTestData();
        
        pageRef = Page.EZRE_LinkedInIntegrationPg;
        pageRef.getParameters().put('id',rqmnt.Id);
        
        rqmntCookie = new Cookie('rqmntId',rqmnt.Id,null,-1,false);
        hostCookie = new Cookie('hostURL','https:\\cs16.salesforce.com',null,-1,false);
        actionCookie = new Cookie('btnAction','Save',null,-1,false);
        tknCookie = new Cookie('strToken','testAccessToken',null,-1,false);
        System.assertEquals(objMCDtl.Name,'MCAccount');     
    }
    
    //Test Class for LinkedIn Integration class
    public static testMethod void linkedInPostWithAccessTkn() 
    { 
        createTestDatawithAccsTkn();
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
       
        Test.setCurrentPage(pageRef);
        tknCookie = new Cookie('strToken','testAccessToken',null,-1,false);
        pageRef.setCookies(new Cookie[]{tknCookie});
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        Test.startTest();                        
            integCtrl.Authorize();
        Test.stopTest();
        System.assertEquals(objMCDtl.Name,'MCAccount');
    } 
    
    //Test Class for LinkedIn Integration class: URL contains CODE
    public static testMethod void linkedInPostURLWithCode() 
    { 
        createTestDataWOAccsTkn();
        
        Test.setCurrentPage(pageRef);
        PageReference pageRefGetCode = Page.EZRE_LinkedInIntegrationPg;
        pageRefGetCode.getParameters().put('code','testCode');
        pageRefGetCode.getParameters().put('state','testState');
        
        pageRefGetCode.setCookies(new Cookie[]{rqmntCookie});
        pageRefGetCode.setCookies(new Cookie[]{hostCookie});
        pageRefGetCode.setCookies(new Cookie[]{actionCookie});
        pageRefGetCode.setCookies(new Cookie[]{tknCookie});
                
        Test.setCurrentPage(pageRefGetCode);
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        Test.startTest();                        
            integCtrl.Authorize();
        Test.stopTest();
    } 
    
    //Test Class for LinkedIn Integration class: URL contains ID
    public static testMethod void linkedInPostURLWithId() 
    { 
        
        createTestDataWOAccsTkn();
        
        Test.setCurrentPage(pageRef);
        
        pageRef.setCookies(new Cookie[]{rqmntCookie});
        pageRef.setCookies(new Cookie[]{hostCookie});
        pageRef.setCookies(new Cookie[]{actionCookie});
        pageRef.setCookies(new Cookie[]{tknCookie});
                
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        Test.startTest();                        
            integCtrl.Authorize();           
        Test.stopTest();
    }
    
    //Test Class for EZRE_AssignRequirementCntrl: Requirement with single Assignment
    public Static testMethod void singleAsgmnt_Test()
    {
        
        Test.StartTest();
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
            createTestData();
        
            Test.setCurrentPage(Page.EZRE_AssignRequirementPage);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(reqAssgn);
            EZRE_AssignRequirementCntrl asgReqCntrl = new EZRE_AssignRequirementCntrl(stdController);
            asgReqCntrl.save();
            asgReqCntrl.SaveAndNew();
            asgReqCntrl.Cancel();
        Test.StopTest();             
        
        System.assertEquals('Test Requirement3', rqmnt.Name);
        System.assertEquals('20',rqmnt.Duration__c);
        System.assertEquals(200 ,rqmnt.Min_Cost__c);
        System.assertEquals(250 ,rqmnt.Max_Cost__c);
        System.assertEquals(400 ,rqmnt.Rate__c);
        System.assertEquals('Open', rqmnt.Status__c);
        System.assertEquals('Contract', rqmnt.Position_Type__c);
        System.assertEquals('DC',rqmnt.State__c);
        System.assertEquals('In-Person',rqmnt.Interview_Type__c);
        System.assertEquals(20 ,rqmnt.No_Of_Resumes__c);
        System.assertEquals('Hyderabad',rqmnt.City__c);
        System.assertEquals(date.today(),rqmnt.Est_Start_Date__c);
        System.assertEquals('c',rqmnt.Easy1__c);
        System.assertEquals('c',rqmnt.Unique_1__c);
        System.assertEquals('c',rqmnt.Skill_Set__c);
    }
    
    //Test Class for EZRE_AssignRequirementCntrl: Requirement with multiple Assignments
    public Static testMethod void multipleAsgmnt_Test()
    {
        Test.StartTest();
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
            createTestData();
            RequirementAssignment__c reqAssgn2 = EZRE_DataFactory_Test_Utility.createAssignmentReq(rqmnt.Id,usr.Id);
            Test.setCurrentPage(Page.EZRE_AssignRequirementPage);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(reqAssgn);
            EZRE_AssignRequirementCntrl asgReqCntrl = new EZRE_AssignRequirementCntrl(stdController);
            asgReqCntrl.save();
            asgReqCntrl.SaveAndNew();
            asgReqCntrl.Cancel();
        Test.StopTest();
        System.assertEquals(objMCDtl.Name,'MCAccount');
    }
}