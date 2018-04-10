/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             16-Oct-2016
 * @Status           Developing
 * @description      This is the test class for viewTimesheet controller.
 */
 
@isTest 
public class ODS_ViewTimesheetController_Test
{
    static testMethod void Constructor_Test()
    {
       //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);    

        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9866857745', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'WEDCNET');
            
           Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            
            test.startTest();
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController();  
            viewTimshtontrlr.AccountId = accObj.Id; 
            viewTimshtontrlr.ServiceId = odsSrv.Id; 
            viewTimshtontrlr.GetTimeSheet();
            viewTimshtontrlr.GetSearchResults();
            viewTimshtontrlr.GetLoggedUserAccountService();
            viewTimshtontrlr.SetRelatedService();
            viewTimshtontrlr.GetAccountServices();
            viewTimshtontrlr.GetTimesheetByAccountServiceID();
            viewTimshtontrlr.GetAccountPicklistValues();
            viewTimshtontrlr.GetStatusPicklistValues();
            viewTimshtontrlr.InvokeToDateMethod();
            viewTimshtontrlr.GetTimeSheetIdFromAction();
            //viewTimshtontrlr.showPrevious();
            //viewTimshtontrlr.showNext();
            //viewTimshtontrlr.showFirst();
            //viewTimshtontrlr.showLast();
            viewTimshtontrlr.GetAllAccounts();     
            viewTimshtontrlr.GetAllServices();
            viewTimshtontrlr.InvokeFromDateMethod(); 
            viewTimshtontrlr.FormatStringToDate('11-09-2016');
            
            test.stopTest();
        }                   
    }
    
    static testMethod void PortalCustomer_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1500,'9866857745', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'SFDC');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));

            test.startTest();
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController();            
            test.stopTest();
        }
    }
    
   static testMethod void SearchResults_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1500,'9866857745', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'SQL');
           
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
            
            test.startTest();
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
            viewTimshtontrlr.AccountId = portalAccount1.Id;
            viewTimshtontrlr.ServiceId = odsSrv.Id;
            viewTimshtontrlr.TimesheetStatus = 'Submitted';
            viewTimshtontrlr.GetTimeSheet();
            viewTimshtontrlr.GetSearchResults();
            test.stopTest();
        }
    }
    
    static testMethod void AddTimesheet_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1500,'9866857745', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'DOTNET');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));

            test.startTest();
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
            viewTimshtontrlr.AccountServiceID = accSrvc.Id;            
            viewTimshtontrlr.AddTimesheet();
            test.stopTest();
        }
    }
    
    static testMethod void GetTimesheet_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);  
        User portalAccountOwner2 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','TestAccount',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test1234@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                        portalAccountOwner1.Id, True,1500,'9866857745','Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);            
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'JAVA');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,strtDt,endDt,string.valueOf(strtDt.Month()),string.valueOf(strtDt.Year()));
            test.startTest();
            
            Timesheet__c objTmeSht = new Timesheet__c (Name = 'Test1',Time_Sheet_Cost__c = objTmeShtCst.Id,Approver_Name__c = portalAccountOwner1.Id,Approver_Email__c = 'TestApprvEmail@gmail.com',Comments__c = 'Test', Status_Date__c = aprveDt, Week_Start_Date__c = strtDt, Week_End_Date__c=endDt, Account_Services__c=accSrvc.Id,Status__c = 'Approved');
            insert objTmeSht;
            User_Account__c objUsrPht = new User_Account__c(Account__c=portalAccount1.Id,Role_in_Account__c='Technical Account Manager',User__c=portalAccountOwner2.Id);
            insert objUsrPht;
            string strTimeSheetId = string.valueof(objTmeSht.Id);
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
            viewTimshtontrlr.TimesheetComments = 'Test Comment';   
            viewTimshtontrlr.CurrenTimesheetId = strTimeSheetId ; 
            viewTimshtontrlr.FromDate = strtDt.format();
            viewTimshtontrlr.ToDate = endDt.format();
            viewTimshtontrlr.GetTimesheet();
            test.stopTest();
        }
    }
    
    static TestMethod void GetTimeSheetDetails_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        { 
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccount('TestAccount',
                                    'California', True,2000,'9433578865', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'DOTNET' );
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,strtDt,endDt,string.valueOf(strtDt.Month()),string.valueOf(strtDt.Year()));
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,strtDt,endDt);
          
            system.RunAs(user1){
                PageReference pageRef = Page.ViewTimesheet;
                Test.setCurrentPage(pageRef);
                ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
                viewTimshtontrlr.TimesheetComments = 'Test Comment';   
                viewTimshtontrlr.CurrenTimesheetId = insertTimeSheet.id; 
                viewTimshtontrlr.FromDate = strtDt.format();
                viewTimshtontrlr.ToDate = endDt.format();
                viewTimshtontrlr.GetStatusPicklistValues();
                viewTimshtontrlr.GetLoggedUserAccountService();
                viewTimshtontrlr.GetAccountServices();
                viewTimshtontrlr.GetTimesheet();
            }
        }
    }
    
    static testMethod void ApproveTimesheet_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);  
        User portalAccountOwner2 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','TestAccount',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test1234@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1500,'9866857745', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'SQL');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');

            test.startTest();
            Date dtStatus = date.parse('11/10/2016');
            Date WeekStartdt= date.parse('11/07/2016');
            Date WeekEndDt = date.parse('11/13/2016');
            Timesheet__c objTmeSht = new Timesheet__c (Name = 'Test1',Time_Sheet_Cost__c = objTmeShtCst.Id,Approver_Name__c = portalAccountOwner1.Id,Approver_Email__c = 'TestApprvEmail@gmail.com',Comments__c = 'Test', Status_Date__c = dtStatus, Week_Start_Date__c = WeekStartdt, Week_End_Date__c=WeekEndDt, Account_Services__c=accSrvc.Id,Status__c = 'Approved');
            insert objTmeSht;
            User_Account__c objUsrPht = new User_Account__c(Account__c=portalAccount1.Id,Role_in_Account__c='Technical Account Manager',User__c=portalAccountOwner2.Id);
            insert objUsrPht;
            string strTimeSheetId = string.valueof(objTmeSht.Id);
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
            viewTimshtontrlr.TimesheetComments = 'Test Comment';   
            viewTimshtontrlr.CurrenTimesheetId = strTimeSheetId ; 
            viewTimshtontrlr.ApproveTimesheet();
            test.stopTest();
        }
    }
    
    static testMethod void RejectTimesheet_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);  
        User portalAccountOwner2 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','TestAccount',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test1234@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1500,'9866857745', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'SQL');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');

            test.startTest();
            Date dtStatus = date.parse('11/10/2016');
            Date WeekStartdt= date.parse('11/07/2016');
            Date WeekEndDt = date.parse('11/13/2016');
            Timesheet__c objTmeSht = new Timesheet__c (Name = 'Test1',Time_Sheet_Cost__c = objTmeShtCst.Id,Approver_Name__c = portalAccountOwner1.Id,Approver_Email__c = 'TestApprvEmail@gmail.com',Comments__c = 'Test', Status_Date__c = dtStatus, Week_Start_Date__c = WeekStartdt, Week_End_Date__c=WeekEndDt, Account_Services__c=accSrvc.Id,Status__c = 'Approved');
            insert objTmeSht;
            User_Account__c objUsrPht = new User_Account__c(Account__c=portalAccount1.Id,Role_in_Account__c='Technical Account Manager',User__c=portalAccountOwner2.Id);
            insert objUsrPht;
            string strTimeSheetId = string.valueof(objTmeSht.Id);
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
            viewTimshtontrlr.TimesheetComments = 'Test Comment';   
            viewTimshtontrlr.CurrenTimesheetId = strTimeSheetId ;
            viewTimshtontrlr.RejectTimesheet();
            test.stopTest();
        }
    }
    
    static testMethod void ViewTimesheet_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                    
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                        portalAccountOwner1.Id, True,1500,'9866857745', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'WEDC');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
            
            test.startTest();
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
            viewTimshtontrlr.CurrenTimesheetId = insertTimeSheet.Id;   
            viewTimshtontrlr.ViewTimesheet();
            test.stopTest();
        }
    }
    
    static testMethod void DeleteTimesheet_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                        portalAccountOwner1.Id, True,1500,'9866857745', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'GGF');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));

            test.startTest();
            PageReference pageRef = Page.ViewTimesheet;
            Test.setCurrentPage(pageRef);
            ODS_ViewTimesheetController viewTimshtontrlr = new ODS_ViewTimesheetController(); 
            viewTimshtontrlr.CurrenTimesheetId = insertTimeSheet.Id;            
            viewTimshtontrlr.DeleteTimesheet();
            test.stopTest();
        }
    }
}