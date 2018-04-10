/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             09-Nov-2016
 * @Status           In Development
 * @description      This is the test class for Header Controller
 */
 
@isTest 
public class ODS_HeaderController_Test
{
    /// <OBJECTIVE>
    /// Test positive scenario if the page name is Dashboard
    /// </OBJECTIVE>
    static TestMethod void upsertSession_PositiveTest()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
 
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //fetch system Customer community
        Profile communityProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer community');
        
         //Insert user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
                                            
        //Insert Account
        Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9343256654', 'Others', 'ODS Project'); 
       
        //Insert Contact
        Contact objContact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id,
                            'Others', 'ODS Project');
      
        Attachment objAttach = ODS_DataFactory_Test_Utility.insertAttachment('Unit Test Con Attachment',objContact.Id);
        //Insert User Photo
        User_Photo__c objUsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto(usrObj.Id);
        ODS_DataFactory_Test_Utility.insertAttachment('Unit Test user Attachment', objUsrPhoto.Id);            
        system.runas(usrObj)
        {
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            test.startTest();
            PageReference pageRef = Page.Dashboard;
            test.setCurrentPage(pageRef);
            ODS_HeaderController objHdr =  new ODS_HeaderController();   
            objHdr.GetLoggedUserAccountService();
            objHdr.getServiceDropdownValues();
            objHdr.GetAccountPicklistValues();
            objHdr.SetRelatedService();
            objHdr.AccountId = accObj.Id;
            objHdr.ServiceId = odsSrv.Id;
            objHdr.getuserPhoto(); 
            test.stopTest();
            
        }        
    }
    /// <OBJECTIVE>
    /// Test positive scenario if the page name is Not Dashboard
    /// </OBJECTIVE>
    static TestMethod void upsertSession_NegativeTest()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
 
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
        //Insert Account
        Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,3000,'9234433454', 'Others', 'ODS Project'); 
        //Insert Contact
        Contact objContact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id,
                                        'Others', 'ODS Project');
        Attachment objAttach = ODS_DataFactory_Test_Utility.insertAttachment('Unit Test Con Attachment',objContact.Id);
        //Insert User Photo
        User_Photo__c objUsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto(usrObj.Id);
        ODS_DataFactory_Test_Utility.insertAttachment('Unit Test user Attachment', objUsrPhoto.Id);            
        system.runas(usrObj)
        {
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            test.startTest();
            PageReference pageRef = Page.customer;
            test.setCurrentPage(pageRef);
            ODS_HeaderController objHdr =  new ODS_HeaderController();
            objHdr.GetLoggedUserAccountService();
            objHdr.getServiceDropdownValues();
            objHdr.GetAccountPicklistValues();
            objHdr.AccountId = 'All';
            objHdr.ServiceId = 'All';
            objHdr.getuserPhoto(); 
            objHdr.getPhoto(); 
            test.stopTest();
        }   
    }
     static testMethod void customers_PositiveTest()
    {      
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            UserInfo.getUserId(), True,3000,'9678554553', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
        Attachment objAttach = ODS_DataFactory_Test_Utility.insertAttachment('Unit Test Con Attachment',contact1.Id);
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
         
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true); 
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        //Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         //150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C, 'JHCNET');
        Account_Services__c accSrvc1 = ODS_DataFactory_Test_Utility.insertAccountServicesWithEngagementType(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C, 'JHCNET','ODS');                 
        System.runAs (user1 ) 
        {                 
            test.startTest();
            PageReference pageRef = Page.Customer;
            Test.setCurrentPage(pageRef);
            ODS_HeaderController objHdr =  new ODS_HeaderController();
            objHdr.GetLoggedUserAccountService();
            objHdr.getServiceDropdownValues();
            objHdr.GetAccountPicklistValues();
            objHdr.AccountId = 'All';
            objHdr.ServiceId = 'All';
            objHdr.getCustomerPhoto(); 
            ODS_HeaderController.RedirectDashboardPage(portalAccount1.Id,odsSrv.Id);
            test.stopTest();
        }                   
    }
    
    
    static testMethod void EngtType_SOWTest()
    {      
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            UserInfo.getUserId(), True,3000,'9678554553', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
        Attachment objAttach = ODS_DataFactory_Test_Utility.insertAttachment('Unit Test Con Attachment',contact1.Id);
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
         
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true); 
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        //Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         //150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C, 'JHCNET');
        Account_Services__c accSrvc1 = ODS_DataFactory_Test_Utility.insertAccountServicesWithEngagementType(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C, 'JHCNET','SOW');                 
        System.runAs (user1 ) 
        {                 
            test.startTest();
            PageReference pageRef = Page.Customer;
            Test.setCurrentPage(pageRef);
            ODS_HeaderController objHdr =  new ODS_HeaderController();
            objHdr.GetLoggedUserAccountService();
            objHdr.getServiceDropdownValues();
            objHdr.GetAccountPicklistValues();
            objHdr.AccountId = 'All';
            objHdr.ServiceId = 'All';
            objHdr.getCustomerPhoto(); 
            ODS_HeaderController.RedirectDashboardPage(portalAccount1.Id,odsSrv.Id);
            test.stopTest();
        }                   
    }
}