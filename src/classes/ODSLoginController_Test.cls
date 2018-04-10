/**
 * @author           Gnanaprakasam G
 * @version          1.0 
 * @date             14-Nov-2016
 * @Status           Developed
 * @description      This is the test class for Login Controller.
 */
@isTest
private class ODSLoginController_Test
{
    static testMethod void LoginPageFail_Test()
    {
        ODSLoginController objLogin = new ODSLoginController();
        objLogin.login();
    }
    
    static testMethod void LoginPagePass_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago', 
                    'test123@testmail.com','Customer', true,portalRole.Id);    
                    
        ODSLoginController objLogin = new ODSLoginController();  
        objLogin.username = 'test123@testmail.com';
        objLogin.password = 'Prelude@123';
        objLogin.login();
        objLogin.ForgotPassword();
    }    
   
    static testMethod void NoAccessUser_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago', 
                    'test123@testmail.com','Customer', false,portalRole.Id);    
                    
        ODSLoginController objLogin = new ODSLoginController();  
        objLogin.username = 'test123@testmail.com';
        objLogin.password = 'Prelude@123';
        objLogin.login();
        objLogin.ForgotPassword();
    }  
     

}