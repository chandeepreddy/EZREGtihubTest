/**
 * @author           Gnanaprakasam G
 * @version          1.0 
 * @date             13-Oct-2016
 * @Status           Developed
 * @description      This is the test class for Contact trigger
 */
@isTest
private class ODS_ContactAccountServiceTrigger_Test
{   
    static testMethod void ContactAccountService_PositiveTest()
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
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('Salesforce','test',true);
            Contact_Account_Service__c InsertContactAccountService = new Contact_Account_Service__c ();
            
            InsertContactAccountService  = ODS_DataFactory_Test_Utility.InsertContactAccountService(contact1.Id,portalAccount1.ID,odsServices.ID,True,False,True);
            InsertContactAccountService.Contact__c = contact1.Id;
            InsertContactAccountService.ODS_Service__c  = odsServices.ID;
            InsertContactAccountService.Account__c = portalAccount1.ID;
            
            InsertContactAccountService.Status_Report_Required__c = True;
            InsertContactAccountService.IsDocMailRequired__c = False;
            InsertContactAccountService.Is_Approver__c = True;
           // update InsertContactAccountService;  
    }
    
 }   
}