/**
 * @author           Kirankumar D
 * @version          1.0 
 * @date             04-Nov-2016
 * @Status           Developing
 * @description      This is the test class for Dashboard
 * @Modified by      Kalaiselvi R - Covered Rally Integration part
 */
 
@isTest 
public class ODS_DashboardController_Test
{
    /// <OBJECTIVE>
    /// Test dashboard functionality such as cost saving, TAM and Chart with positive flow.
    /// </OBJECTIVE>  
    public static testMethod void CostSaving_PositiveTest()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);    

        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9844578473', 'Others', 'ODS Project'); 
            //User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',usrObj.Id );
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);

            
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'GGFSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            
            //Insert Time Sheet Cost record
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Time_Sheet_Cost__c insertPrevMthTSC = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,100,PrevMthStrtDate,PrevMthEndDate ,'10','2016');
            
            //Insert TimeSheet record
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',insertPrevMthTSC.Id,date.parse('10/03/2016'),date.parse('10/09/2016'));
            
            //Insert TimeSheetDetail record
            Time_Sheet_Details__c inrtTimeShtDtl = ODS_DataFactory_Test_Utility.insertTimesheetdetail(5,ObjTeamMembr.Id,'Test Res',insertTimeSheet.Id,date.parse('10/07/2016'));
            
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = accObj.Id;
            objDhbrd.ServiceId = odsSrv.Id; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboard();
            objDhbrd.insertQueries();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            objDhbrd.RemoveTrailingZeros(55.00);
            objDhbrd.formatCurrency(1000000);
            Test.stopTest();
            //system.assertEquals(1,insertPrevMthTSC.Resource_Count__c);

         }                   
    }
    
    public static testMethod void CostSavingAll_PositiveTest(){
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);    

        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9844578473', 'Others', 'ODS Project'); 
            //User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',usrObj.Id );
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);

            
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'GGFSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            
            //Insert Time Sheet Cost record
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Time_Sheet_Cost__c insertPrevMthTSC = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,100,PrevMthStrtDate,PrevMthEndDate ,'10','2016');
            
            //Insert TimeSheet record
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',insertPrevMthTSC.Id,date.parse('10/03/2016'),date.parse('10/09/2016'));
            
            //Insert TimeSheetDetail record
            Time_Sheet_Details__c inrtTimeShtDtl = ODS_DataFactory_Test_Utility.insertTimesheetdetail(5,ObjTeamMembr.Id,'Test Res',insertTimeSheet.Id,date.parse('10/07/2016'));
            
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = 'All';
            objDhbrd.ServiceId = 'All'; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboardAll();
            objDhbrd.insertQueries();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            objDhbrd.RemoveTrailingZeros(55.00);
            objDhbrd.formatCurrency(1000000);
            Test.stopTest();
            //system.assertEquals(1,insertPrevMthTSC.Resource_Count__c);

         } 
     }
     public static testMethod void CostSavingAllAccounts_PositiveTest(){
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);    

        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9844578473', 'Others', 'ODS Project'); 
            //User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',usrObj.Id );
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);

            
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'GGFSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            
            //Insert Time Sheet Cost record
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Time_Sheet_Cost__c insertPrevMthTSC = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,100,PrevMthStrtDate,PrevMthEndDate ,'10','2016');
            
            //Insert TimeSheet record
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',insertPrevMthTSC.Id,date.parse('10/03/2016'),date.parse('10/09/2016'));
            
            //Insert TimeSheetDetail record
            Time_Sheet_Details__c inrtTimeShtDtl = ODS_DataFactory_Test_Utility.insertTimesheetdetail(5,ObjTeamMembr.Id,'Test Res',insertTimeSheet.Id,date.parse('10/07/2016'));
            
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = 'All';
            objDhbrd.ServiceId = odsSrv.Id; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboardAll();
            objDhbrd.insertQueries();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            objDhbrd.RemoveTrailingZeros(55.00);
            objDhbrd.formatCurrency(1000000);
            Test.stopTest();
            //system.assertEquals(1,insertPrevMthTSC.Resource_Count__c);

         } 
    }
    
    public static testMethod void CostSavingAllServices_PositiveTest(){
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);    

        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9844578473', 'Others', 'ODS Project'); 
            //User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',usrObj.Id );
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);

            
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'GGFSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            
            //Insert Time Sheet Cost record
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Time_Sheet_Cost__c insertPrevMthTSC = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,100,PrevMthStrtDate,PrevMthEndDate ,'10','2016');
            
            //Insert TimeSheet record
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',insertPrevMthTSC.Id,date.parse('10/03/2016'),date.parse('10/09/2016'));
            
            //Insert TimeSheetDetail record
            Time_Sheet_Details__c inrtTimeShtDtl = ODS_DataFactory_Test_Utility.insertTimesheetdetail(5,ObjTeamMembr.Id,'Test Res',insertTimeSheet.Id,date.parse('10/07/2016'));
            
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = accObj.Id;
            objDhbrd.ServiceId = 'All'; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboardAll();
            objDhbrd.insertQueries();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            objDhbrd.RemoveTrailingZeros(55.00);
            objDhbrd.formatCurrency(1000000);
            Test.stopTest();
            //system.assertEquals(1,insertPrevMthTSC.Resource_Count__c);

         } 
    }
    /// <OBJECTIVE>
    /// Test dashboard functionality such as cost saving, TAM and Chart with negative flow.
    /// </OBJECTIVE>  
    public static testMethod void CostSaving_NegativeTest()
    {
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
        //Insert User Photo
        User_Photo__c objUsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto(usrObj.Id);
        //Insert Attachment for User Photo
        ODS_DataFactory_Test_Utility.insertAttachment('Unit Test user Attachment', objUsrPhoto.Id);  
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = portalAccount1.Id;
            objDhbrd.ServiceId = odsSrv.Id; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboard();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            Test.stopTest();
         }  
    }
    
    public static testMethod void CostSavingAll_NegativeTest(){
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
        //Insert User Photo
        User_Photo__c objUsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto(usrObj.Id);
        //Insert Attachment for User Photo
        ODS_DataFactory_Test_Utility.insertAttachment('Unit Test user Attachment', objUsrPhoto.Id);  
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = 'All';
            objDhbrd.ServiceId = 'All'; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboardAll();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            Test.stopTest();
        }  
    }
    
    public static testMethod void CostSavingAllAccounts_NegativeTest(){
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
        //Insert User Photo
        User_Photo__c objUsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto(usrObj.Id);
        //Insert Attachment for User Photo
        ODS_DataFactory_Test_Utility.insertAttachment('Unit Test user Attachment', objUsrPhoto.Id);  
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = 'All';
            objDhbrd.ServiceId = odsSrv.Id; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboardAll();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            Test.stopTest();
        }  
    }
    
    public static testMethod void CostSavingAllServices_NegativeTest(){
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
        //Insert User Photo
        User_Photo__c objUsrPhoto = ODS_DataFactory_Test_Utility.insertUsrPhoto(usrObj.Id);
        //Insert Attachment for User Photo
        ODS_DataFactory_Test_Utility.insertAttachment('Unit Test user Attachment', objUsrPhoto.Id);  
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = portalAccount1.Id;
            objDhbrd.ServiceId = 'All'; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboardAll();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            Test.stopTest();
        }  
    }
    /// <OBJECTIVE>
    /// Test fetching sprint details with positive flow.
    /// </OBJECTIVE>  
    public static testMethod void fetchRallyDetails_PositiveTest()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true); 
        
        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9844578375', 'Others', 'ODS Project'); 
            //User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',usrObj.Id );
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServiceWithRallyDetails(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id,'indhu_r@preludesys.com', 'Prelude@123', 'GGFSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = accObj.Id;
            objDhbrd.ServiceId = odsSrv.Id; 
            objDhbrd.GetDashboardByAccountServiceID();
            objDhbrd.GetDashboard();
            objDhbrd.insertQueries();
            objDhbrd.getMonths();
            objDhbrd.getYears();
            objDhbrd.getPhoto();
            objDhbrd.LoadTimeSheetHrsPanel();
            objDhbrd.LoadTimeSheetAmountPanel();
            ODS_DashboardController.setformattedMonthDate('0', '2016');
            ODS_DashboardController.GetInprogressUserStories(objDhbrd.AccountId, objDhbrd.ServiceId);
            ODS_DashboardController.GetRallyRelatedDetails(objDhbrd.AccountId, objDhbrd.ServiceId, '1', '2017');            
            Test.stopTest();
         }  
    }
    
    public static testMethod void GetDashboardByAccountServiceID_Test()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true); 
        
        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9844578375', 'Others', 'ODS Project'); 
            //User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',usrObj.Id );
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            Test.startTest();
            ODS_DashboardController objDhbrd = new ODS_DashboardController();
            objDhbrd.AccountId = '';
            objDhbrd.ServiceId = '';
            objDhbrd.GetDashboardByAccountServiceID();
            Test.stopTest();
        }
    }
    
    public static testMethod void dataUtilityMethods()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true); 
        
        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9844578375', 'Others', 'ODS Project'); 
            //User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',usrObj.Id );
            
            
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServiceWithRallyDetails(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id,'indhu_r@preludesys.com', 'Prelude@123', 'GGFSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            /*User usrObjt = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');*/
            
            
            //ODS_Data_Utility.getuser(contact1.Id);
            ODS_Data_Utility.fetchUserById(usrObj.Id);
        }
        
        
        
    }
    
    public static testMethod void GetJiraAverageSprintGap()
    {
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
          
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController.GetAverageSprintGap(portalAccount1.Id,odsSrv.Id);
            Test.stopTest();
         }  
    }  
    
    public static testMethod void GetJiraLifeTimeUS()
    {
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
         
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController.GetLifeTimeUS(portalAccount1.Id,odsSrv.Id);
            Test.stopTest();
         }  
    }  
    
    public static testMethod void GetMonthlyCompletedAndInProgressUS()
    {
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
       
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController.GetMonthlyCompletedUserStories(portalAccount1.Id,odsSrv.Id,'8','2017');
            ODS_DashboardController.GetSelectedMonthInProgressUS(portalAccount1.Id,odsSrv.Id,'8','2017');
            ODS_DashboardController.GetTotalCompletedUSWithDate(portalAccount1.Id,odsSrv.Id,'8','2017');
            ODS_JIRAIntegration.InvokeJiraApi('gnanaprakasam_g@preludesys.com','Prelude@123','https://preludesysindia.atlassian.net/rest/agile/1.0/board/4/sprint');
            Test.stopTest();
         }  
    }   
    
    public static testMethod void GetJiraTotalCompletedUS()
    {
        Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    UserInfo.getUserId(), True,1500,'9553477685', 'Others', 'ODS Project');     
        Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, 
                            portalAccount1.Id, 'Others', 'ODS Project');
        Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                        'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                        'test12345@test.com', contact1.Id,'Customer');
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert user
        User usrObj1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true);  
        
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',
                                                    usrObj1.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                         150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__C,  'GGFSFDC');
       
        System.runAs (usrObj) 
        {       
            Test.startTest();
            ODS_DashboardController.GetTotalCompletedUSWithDate(portalAccount1.Id,odsSrv.Id,'8','2017');
            Test.stopTest();
         }  
    }   
}