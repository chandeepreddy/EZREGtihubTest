/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             10-Nov-2016
 * @Status           Developed
 * @description      This is the test class for AccountService trigger
 */
 
@isTest 
public class ODS_AccountServiceController_Test
{
    /// <OBJECTIVE>
    /// Test insertion of Account Service
    /// </OBJECTIVE>
    static TestMethod void insertAccountService_PositiveTest()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
 
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
 
         //Insert user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US', SAProfile.Id, 'America/Chicago', System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
                    
        //Insert Account
        Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount', usrObj.Id, True, 1000, '9887533678', 'Others', 'ODS Project'); 
        
         //Insert ODS Service
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        //Insert User Account

        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id, 'Technical Account Manager', usrObj.Id, odsSrv.Id);

        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
                         
        system.runas(usrObj)
        {
            test.startTest();
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__c, 'GGFSFDC');                 
            test.stopTest();  
        }        
    }
    /// <OBJECTIVE>
    /// Test insertion of Account Service
    /// </OBJECTIVE>
    static TestMethod void updateAccountService_PositiveTest()
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
        Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1000,'9887533678', 'Others', 'ODS Project'); 
        
        //Insert ODS Service
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('Dot Net','test',true);
        
        //Insert ODS Service
        ODS_Services__c odsSrv2 = ODS_DataFactory_Test_Utility.insertODSServices('Java','test',true);
        
        //Insert User Account
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

        //Insert User Account
        User_Account__c usrAcc2 = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv2.Id);
        
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
                         
        system.runas(usrObj)
        {
            test.startTest();
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__c, 'GGFSFDC');
             
            Account_Services__c updateAccSrvc = new  Account_Services__c(id=accSrvc.Id);
            updateAccSrvc.ODS_Services__c = odsSrv2.Id;
            update updateAccSrvc;
            test.stopTest();  
        }        
    }
    /// <OBJECTIVE>
    /// Test insertion of Account Service without User
    /// </OBJECTIVE>
    static TestMethod void insertAcntSrvceWithoutUser_PositiveTest()
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
        Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1000,'9887533678', 
                            'Others', 'ODS Project'); 
        
        //Insert ODS Service
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('Dot Net','test',true);
       
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
                         
        system.runas(usrObj)
        {
            try
            {
                test.startTest();
                Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                                 150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'ODSSFDC');
            }
            catch(Exception e)
            {
            Boolean expectedExceptionThrown =  e.getMessage().contains('The User and Service is not associated with this account,'
                            + ' Please add them in the User accounts') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
            } 
            test.stopTest();  
        }        
    }
}