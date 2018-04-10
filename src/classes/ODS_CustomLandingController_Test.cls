/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             29-Sep-2016
 * @Status           Developed
 * @description      An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@isTest
private class ODS_CustomLandingController_Test
{
        
    static testMethod void LandingPage_PositiveTestWithEngagementType()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1000,'95543567654', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            
                             
        
        ODS_SessionData__c objSessiondata = new ODS_SessionData__c();
        objSessiondata.Name = 'Test';
        objSessiondata .Account_Id__c = portalAccount1.Id;
        objSessiondata .Current_user_Id__c = portalAccountOwner1.id;
        objSessiondata .Service_Id__c = odsSrv.id;
        insert objSessiondata ;
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServicesWithEngagementType(objSessiondata.Account_Id__c ,strtDt, endDt,
                             150.0, objSessiondata.Service_Id__c, 1000, 'Monthly', objSessiondata.Current_user_Id__c, 'JHCSFDC','ODS');
        
            
        ODS_CustomLandingController landingCntlr = new ODS_CustomLandingController();                       
        landingCntlr.PageRedirect();
        ODS_DashboardRedirect Redirect = new ODS_DashboardRedirect();
        Redirect.RedirectDashboardPage();
            
        }
    }
    
    static testMethod void LandingPage_AllCustomerAndService()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1000,'95543567654', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            /*User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');*/
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            
                             
        
        ODS_SessionData__c objSessiondata = new ODS_SessionData__c();
        objSessiondata.Name = 'Test';
        objSessiondata.Account_Id__c = 'All';
        objSessiondata.Current_user_Id__c = portalAccountOwner1.id;
        objSessiondata.Service_Id__c = 'All';
        insert objSessiondata ;
        
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServicesWithEngagementType(portalAccount1.Id,strtDt, endDt,
                             150.0, odsSrv.Id, 1000, 'Monthly', objSessiondata.Current_user_Id__c, 'JHCSFDC','ODS');
            
        ODS_CustomLandingController landingCntlr = new ODS_CustomLandingController();                       
        landingCntlr.PageRedirect();
        ODS_DashboardRedirect Redirect = new ODS_DashboardRedirect();
        Redirect.RedirectDashboardPage();
            
        }
    }
    
    static testMethod void LandingPage_ForCustomerAndService()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1000,'95543567654', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
           
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            
                             
        
        ODS_SessionData__c objSessiondata = new ODS_SessionData__c();
        objSessiondata.Name = 'Test';
        objSessiondata.Account_Id__c = 'All';
        objSessiondata.Current_user_Id__c = portalAccountOwner1.id;
        objSessiondata.Service_Id__c = 'All';
        insert objSessiondata ;
        
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServicesWithEngagementType(portalAccount1.Id,strtDt, endDt,
                             150.0, odsSrv.Id, 1000, 'Monthly', objSessiondata.Current_user_Id__c, 'JHCSFDC','ODS');
            
        ODS_CustomLandingController landingCntlr = new ODS_CustomLandingController();                       
        landingCntlr.PageRedirect();
        ODS_DashboardRedirect Redirect = new ODS_DashboardRedirect();
        Redirect.RedirectDashboardPage();
            
        }
    }
    
    /*static testMethod void LandingPage_OtherServices()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1000,'95543567654', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
           
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
       
        ODS_SessionData__c objSessiondata = new ODS_SessionData__c();
        objSessiondata.Name = 'Test';
        objSessiondata.Account_Id__c = 'All';
        objSessiondata.Current_user_Id__c = portalAccountOwner1.id;
        objSessiondata.Service_Id__c = 'All';
        insert objSessiondata ;    
                             
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServicesWithEngagementType(portalAccount1.Id,strtDt, endDt,
                             150.0, odsSrv.Id, 1000, 'Monthly', objSessiondata.Current_user_Id__c, 'JHCSFDC','ODS');
            
        ODS_Data_Utility.getuser(contact1.Id);
            
        }
    }*/

}