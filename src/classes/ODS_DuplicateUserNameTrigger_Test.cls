/**
 * @author           Kirankumar
 * @version          1.0 
 * @date             09-11-2016
 * @Status           Developed
 * @description      Test class for DuplicateUserNameTrigger and Controller
 */
@isTest
public class ODS_DuplicateUserNameTrigger_Test
{
    //Insert new User Account Record
    static TestMethod void InsertNewUserAccount_Test()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
         //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
        system.runAs(usrObj)
            {
                Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1000,'9443858764', 'Others', 'ODS Project'); 
                ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('SFDC','Test Ods Service',true);

                User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.ID);
    
            }
    }
    
    //Update a User Account Record
    static TestMethod void UpdateUserAccount_Test()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
                    
        User usrObjt = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
        system.runAs(usrObj)
            {
                Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9404433444', 'Others', 'ODS Project'); 
                
                ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('SFDC','Test Ods Service',true);

                User_Account__c InsertUsrAcnt = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObjt.Id,odsSrv.Id);
                User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
                User_Account__c UsrAcnt = new User_Account__c();
                UsrAcnt.Id =  InsertUsrAcnt.Id;
                UsrAcnt.User__c = usrObj.id;
                update UsrAcnt;
            }
    }
}