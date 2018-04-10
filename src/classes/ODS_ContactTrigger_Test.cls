/**
 * @author           Gnanaprakasam G
 * @version          1.0 
 * @date             13-Oct-2016
 * @Status           Developed
 * @description      This is the test class for Contact trigger
 */
@isTest
private class ODS_ContactTrigger_Test
{   
    static testMethod void ContactPortalAccess_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Customer', true,portalRole.Id);                
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                portalAccountOwner1.Id, True, 1000,'8995533256', 'Others', 'ODS Project');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContactWithApprover('Test','McTesty', True, portalAccount1.Id,False, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            contact1.IS_Portal_Access__c = False;
            contact1.FirstName = 'updatedFName';
            contact1.LastName = 'updatedLName';
            update contact1;
        }
    }
    
    static testMethod void ContactPortalAccess_NegativeTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Customer', true,portalRole.Id); 
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                portalAccountOwner1.Id, True, 1000, '9903342561', 'Others', 'ODS Project');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContactWithApprover('Test','McTesty', False, portalAccount1.Id,False, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            contact1.IS_Portal_Access__c = True;
            contact1.IS_Approver__c = True;
            update contact1;
        }
    }
}