/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             14-Oct-2016
 * @Status           Developed
 * @description      This is the test class for customer controller.
 */
 
@isTest 
public class ODS_CustomerController_Test
{
    static testMethod void internalUsersAsPH_PositiveTest()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('indu','testuser@testmail.com', 'UTF-8','Indumathi', 'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);    
        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1000,'7665233156', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            ODS_Services__c odsSrv2 = ODS_DataFactory_Test_Utility.insertODSServices('Java','test',true);
            
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id, odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__c, 'JHCSFDC');

            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            test.startTest();
            PageReference pageRef = Page.Customer;
            Test.setCurrentPage(pageRef);
            ODS_CustomerController custContrlr = new ODS_CustomerController(); 
            custContrlr.AccountId = 'All';
            custContrlr.ServiceId = 'All';
            custContrlr.fetchCustomersList();
            custContrlr.fetchSearchCustomersList();
            custContrlr.getCustomerServices();
            custContrlr.pageSize = 1;
           
            custContrlr.showPrevious();
            custContrlr.showNext();
            custContrlr.showFirst();
            custContrlr.showLast();
            custContrlr.enableDisablePaginationLinks();
            custContrlr.fetchSearchCustomersList();
            test.stopTest();
        }                   
    }
    static testMethod void internalUsersAsTAM_PositiveTest()
    {
       //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user 
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName', 'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 'test123@testmail.com','Technical Account Manager', true); 
        
        //Insert another internal user 
        User usrObj2 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestName', 'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 'test345@testmail.com','Account Manager', true);   

        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,2000,'9552366876', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            User_Account__c usrAcc2 = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Account Manager',usrObj2.Id,odsSrv.Id );
            
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__c, 'ODSJAVA');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            
            test.startTest();
            PageReference pageRef = Page.Customer;
            Test.setCurrentPage(pageRef);
            ODS_CustomerController custContrlr = new ODS_CustomerController();
            custContrlr.AccountId = accObj.id;
            custContrlr.ServiceId = odsSrv.id;
            custContrlr.slctdCustService = odsSrv.id;
            pageRef.getParameters().put('slctdCustId', accObj.Id);
            pageRef.getParameters().put('custSrvce', odsSrv.Id);
            custContrlr.displayCustomerDetails(accObj.id,odsSrv.id);
            test.stopTest();
        }                   
    }
    static testMethod void customers_PositiveTest()
    {      
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty', 'en_US',
            'en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 'test12345@test.com', contact1.Id, 'Customer');
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName', 'en_US',
                    'en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 'test123@testmail.com','Practice Head', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager', usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id, strtDt, endDt, 150.0, 
                                odsSrv.id, 1000, 'Monthly', usrAcc.user__C, 'ODSPHP');
        System.runAs (user1 ) 
        {                 
            test.startTest();
            PageReference pageRef = Page.Customer;
            Test.setCurrentPage(pageRef);
            ODS_CustomerController custContrlr = new ODS_CustomerController();
            custContrlr.AccountId = portalAccount1.id;
            custContrlr.ServiceId = odsSrv.id;
            custContrlr.GetCustomerByAccountServiceID();
            custContrlr.getCustomerServices();
            custContrlr.fetchServiceById();
           
            test.stopTest();
        }                   
    }
}