/**
 * @author           Kirankumar
 * @version          1.0 
 * @date             09-11-2016
 * @Status           Developed
 * @description      Test class for DuplicateUserPhotoTrigger and Controller
 */
@isTest
public class ODS_DuplicateUserPhotoTrigger_Test
{
    //Insert a new User Photo record
    static TestMethod void InsertUserPhoto_Test()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
         //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
                    
        User_Photo__c UsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto('TestUser',usrObj.Id);
     }
     
     //Update a User Photo record
     static TestMethod void UpdateUserPhoto_Test()
     {
         //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
         //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test12@testmail.com','Practice Head', true);
        User userObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser2@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
                    
        User_Photo__c UsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto('TestUser',usrObj.Id);
        
        User_Photo__c UserPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto('TestUsr',userObj.Id);
        
        try
        {
            User_Photo__c updtUsrPht = ODS_DataFactory_Test_Utility.updateUsrPhoto(UserPhoto.Id,usrObj.Id);
        }
        catch(Exception E)
        {
            Boolean expectedExceptionThrown = e.getMessage().Contains('TestLastName is already exist')?true:false;
        }
     }
}