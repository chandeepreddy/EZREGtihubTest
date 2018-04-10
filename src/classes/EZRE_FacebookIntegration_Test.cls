/*
 * @author           Baskar
 * @version          1.0 
 * @date             01/12/2014
 * @description      Test Class for class for PostOnFacebookWall
 */  
@isTest
private class EZRE_FacebookIntegration_Test 
{
    public Static FacebookDetails__c fbCustSet;
    public Static PageReference pageRef;
    public Static Cookie tknCookie, rqmntCookie, actionCookie,hostCookie;
    public Static PostOnFacebookWall postOnFB=new PostOnFacebookWall();
    public Static Profile prof;
    public Static User usr;
    public Static Requirement__c rqmnt;
    public Static RequirementAssignment__c reqAssgn;
    public Static Boolean isHavingCode=false; 
    
    //Create Lead Recruiter Profile and a test user
    private Static  void createTestUser(string uid, string emailId)
    {   
         //Fetch Lead Recruiter profile
        prof = EZRE_DataFactory_Test_Utility.fetchProfile();
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10); 
        
        usr = EZRE_DataFactory_Test_Utility.createUser(uid,emailid,'UTF-8','Testing','en_US','en_US',prof.Id,
                                'America/Los_Angeles',emailId,'1243847862');
        System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    
    //Create Test Requirement and RequirementAssignment.
    private Static  void createTestData(string uid, string emailId)
    {
         createTestUser(uid,emailId);
         //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        rqmnt = EZRE_DataFactory_Test_Utility.createReq('Test Requirement3','20',200,250,400,'Open','Contract','DC','In-Person',20,'Hyderabad',
                                                                   date.today(),'c','c','c');
                                                                   
        reqAssgn = EZRE_DataFactory_Test_Utility.createAssignmentReq(rqmnt.Id,usr.Id);
        System.assertEquals(rqmnt.Name,'Test Requirement3');
                 
    }
    
    // Post to Facebook with available  Acccess Token and Save function.
    public static testMethod void PostToFBWithAccessToken_Save()
    {
        setCustSetting('FacebookAPP','testToken', 'testClientId','testClientSecret');
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        createTestData('usr2','linkinFB2@gmail.com');
        postToFB('Save');
        System.assertEquals(rqmnt.Id,postOnFB.rqmntId);
    }
    
    // Post to Facebook with available  Acccess Token and SaveNew function.
    public static testMethod void PostToFBWithAccessToken_SaveNew()
    {
        setCustSetting('FacebookAPP','testToken', 'testClientId','testClientSecret');
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        createTestData('usr9','linkinFB9@gmail.com');
        postToFB('SaveNew');
        System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    // Post to Facebook without Acccess Token and Save function.
    public static testMethod void PostToFBWithoutAccessToken()
    {
        setCustSetting('FacebookAPP','', 'testClientId','testClientSecret');
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        createTestData('usr3','linkinFB3@gmail.com');
        postToFB('Save');
        System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    
    //Test Class for FB Integration class: URL contains CODE
    public static testMethod void PostToFBWithCode_Save() 
    { 
        System.debug('inside PostToFBWithCode : Before setting Hving Code?##'+ isHavingCode);
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        isHavingCode=true;
        System.debug('inside PostToFBWithCode : After setting Hving Code?##'+ isHavingCode);
        setCustSetting('FacebookAPP','', 'testClientId','testClientSecret');
        createTestData('usr4','linkinFB4@gmail.com');
        postToFB('Save');
        System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    
    // Post to Facebook without Acccess Token and SaveNew function.
    public static testMethod void PostToFBWithCode_SaveNew() 
    {
        isHavingCode=true;
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        setCustSetting('FacebookAPP','', 'testClientId','testClientSecret');
        createTestData('usr5','linkinFB5@gmail.com');
        postToFB('SaveNew');
        System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    
    //Test the  Get Facebook Token functionality
    public static testMethod void GetFBToken()
    {
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        setCustSetting('FacebookAPP','testToken', 'testClientId','testClientSecret');
        createTestData('usr6','linkinFB6@gmail.com');
        string sUri='https://graph.facebook.com/me/accounts?access_token=testToken';
         System.RunAs(usr)
        {
            Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
            Test.startTest(); 
                postOnFB.getPageToken(sUri,fbCustSet);
            Test.stopTest();
        }
       System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    
    //Post on the Facebook wall with Requirement Id.
    public static testMethod void PostToFB_OnWall()
    {
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
        setCustSetting('FacebookAPP','testToken', 'testClientId','testClientSecret');
        createTestData('usr7','linkinFB7@gmail.com');
         System.RunAs(usr)
        {
            Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
            Test.startTest(); 
                PostOnFacebookWall.postOnFBWall(rqmnt.Id);
            Test.stopTest();
        }
       System.assertEquals(objMCDtl.Name,'MCAccount');
    }
    
    //Post the data to Facebook
    public static   void postToFB(string action)
    {
         //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10);
         System.Debug('User obj##'+usr);
         if (usr == null)
             createTestUser('usr8','linkinFB8@gmail.com');
         System.RunAs(usr)
        {
            pageRef=Page.Facebook_Login; 
            Test.setCurrentPage(pageRef);
            String sUrl = 'https://'+System.URL.getSalesforceBaseUrl().getHost();
            
            system.debug('baseurl##'+   sUrl);
            ApexPages.currentPage().getHeaders().put('Host', sUrl);
            system.debug('host##'+ ApexPages.currentPage().getHeaders().get('Host'));
            rqmntCookie = new Cookie('rqmntId',rqmnt.Id,null,-1,false);
            pageRef.setCookies(new Cookie[]{rqmntCookie});
            tknCookie = new Cookie('strToken',fbCustSet.AccessToken__c,null,-1,false);
            pageRef.setCookies(new Cookie[]{tknCookie});
            hostCookie = new Cookie('hostURL','https:\\cs16.salesforce.com',null,-1,false);
            actionCookie = new Cookie('btnAction',action,null,-1,false);
            pageRef.setCookies(new Cookie[]{actionCookie});
            pageRef.setCookies(new Cookie[]{hostCookie});
            
            System.debug('Hving Code?##'+ isHavingCode);
            if(isHavingCode)
            {
                 pageRef.getParameters().put('code','testCode');
                 pageRef.getParameters().put('state','testState');
                 isHavingCode=false;
            }
            else
            {
                pageRef.getParameters().put('id',rqmnt.Id);
                postOnFB.rqmntId=rqmnt.Id;
            }
            Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
            Test.startTest(); 
                PostOnFacebookWall.FBAppDtls=fbCustSet;
                PostOnFacebookWall.objRqrmnt=rqmnt;
                PostOnFacebookWall.objRqrmntAssgnmnt=reqAssgn;
                
                postOnFB.Authorize();
            Test.stopTest();
        }
       System.assertEquals(objMCDtl.Name,'MCAccount');
    }

    //To set the Facebook Custom setting values.
    private static void setCustSetting(string name,string accToken, string clientId,string clientSecret)
    {
        
            fbCustSet=new FacebookDetails__c();
            fbCustSet.Name= name;
            fbCustSet.AccessToken__c= accToken;
            fbCustSet.ClientID__c = clientId;
            fbCustSet.ClientSecret__c = clientSecret;
            fbCustSet.ValidTo__c=System.today().addDays(10);
            insert fbCustSet;
            System.assertEquals(fbCustSet.Name,'FacebookAPP');
        
    }
}