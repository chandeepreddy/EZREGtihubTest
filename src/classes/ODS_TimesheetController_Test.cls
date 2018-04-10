@isTest
public class ODS_TimesheetController_Test
{
    static TestMethod void Constructor_Test()
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
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'JHCSFDC');
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
            
            string strAcntId = string.valueOf(portalAccount1.Id);
            string strSrvId = string.valueOf(odsSrv.Id);
            string strTimeSheetId = string.valueof(insertTimeSheet.Id);
            
            ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
            objTmeShtCntlr.CurrenTimesheetId = insertTimeSheet.id;
            objTmeShtCntlr.AccountId = portalAccount1.id;
            objTmeShtCntlr.ServiceId = odsSrv.id;
            objTmeShtCntlr.GetTimesheetDetails(strTimeSheetId);
            objTmeShtCntlr.AssignPassedAccountService();
            ODS_TimesheetController.GetAccountPicklistValues();
            objTmeShtCntlr.GetLoggedUserAccountService();
            objTmeShtCntlr.GetAccountServiceChanges();
            objTmeShtCntlr.redirectToTimeSheet();

            objTmeShtCntlr.CurrentAccServiceId = accSrvc.Id;
            objTmeShtCntlr.objTimesheetCost = objTmeShtCst ;
            objTmeShtCntlr.UpdateODSHoursAndResCountInCost(insertTimeSheet);
            objTmeShtCntlr.DeleteExistingTimesheetDetail(strTimeSheetId );
        }
    }
    
    static TestMethod void GetTimeSheetDetails_Test()
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
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'PCPHP');

            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
            string strTimeSheetId = string.valueof(insertTimeSheet.Id);
            ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
            objTmeShtCntlr.CurrenTimesheetId = insertTimeSheet.id;
            objTmeShtCntlr.GetTimesheetDetails(strTimeSheetId);
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
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'ODSSFDC');

            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
            PageReference pageRef = Page.TimesheetPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id',insertTimeSheet.id);
            ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
            ApexPages.currentPage().getParameters().put('Status','Submitted');
            ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
        }
    }
    
    static TestMethod void GetTimeSheetDetails_NegativeTest()
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
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'JHCSFDC');

            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName', objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
          
            system.RunAs(user1){
                PageReference pageRef = Page.TimesheetPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id',insertTimeSheet.id);
                ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
                ApexPages.currentPage().getParameters().put('Status','Submitted');
                ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
                objTmeShtCntlr.GetTimesheetDetails(insertTimeSheet.id);
            }
        }
    }
    
    static TestMethod void GetLoggedUserAccountService_PositiveTest()
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
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'PCSFDC');

            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
          
            system.RunAs(user1){
                PageReference pageRef = Page.TimesheetPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id',insertTimeSheet.id);
                ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
                ApexPages.currentPage().getParameters().put('Status','Submitted');
                ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
                objTmeShtCntlr.GetTimesheetDetails(insertTimeSheet.id);                
                objTmeShtCntlr.GetLoggedUserAccountService();
            }
        }
    }
    
    static TestMethod void SetRelatedService_PositiveTest()
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
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'ODSNET');

            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
          
            system.RunAs(user1){
                PageReference pageRef = Page.TimesheetPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id',insertTimeSheet.id);
                ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
                ApexPages.currentPage().getParameters().put('Status','Submitted');
                ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
                objTmeShtCntlr.GetTimesheetDetails(insertTimeSheet.id);                
                objTmeShtCntlr.GetLoggedUserAccountService();
                objTmeShtCntlr.SetRelatedService();
            }
        }
    }
    
    static TestMethod void ApproveTimesheet_Test()
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
                            portalAccountOwner1.Id, True,1000,'95543567654','Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            //Insert Project Team Member
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Arun',portalAccount1.Id,odsSrv.Id);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'PCSQL');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            
            test.startTest();            
            Date dtStatus = date.parse('11/10/2016');
            Date WeekStartdt= date.parse('11/07/2016');
            Date WeekEndDt = date.parse('11/13/2016');
            Timesheet__c objTmeSht = new Timesheet__c (Name = 'Test1',Time_Sheet_Cost__c = objTmeShtCst.Id,Approver_Name__c = portalAccountOwner1.Id,Approver_Email__c = 'TestApprvEmail@gmail.com',Comments__c = 'Test', Status_Date__c = dtStatus, Week_Start_Date__c = WeekStartdt, Week_End_Date__c=WeekEndDt, Account_Services__c=accSrvc.Id,Status__c = 'Approved');
            insert objTmeSht;
            User_Account__c objUsrPht = new User_Account__c(Account__c=portalAccount1.Id,Role_in_Account__c='Technical Account Manager',User__c=portalAccountOwner2.Id);
            insert objUsrPht;
            
            string strPrjtTeaMbId = string.valueOf(ObjTeamMembr.Id);
            string strTimeSheetId = string.valueof(objTmeSht.Id);
            PageReference pageRef = Page.TimesheetPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id',strTimeSheetId);
            ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
            ApexPages.currentPage().getParameters().put('Status','Submitted');
            ApexPages.currentPage().getParameters().put('WeekStart', strtDt.format());
            ApexPages.currentPage().getParameters().put('WeekEnd', endDt.format());
            string JSONValue = '{"WeekStartDate":"' + strtDt.format() +'","WeekEndDate":"' + endDt.format() +'","Status":"Submitted","TimesheetDtls":[{"RowNo":1,"TaskName":"test","ResourceName":"Arun","TDate":"11/7/2016","Hrs":"2","ResourceId":"'+strPrjtTeaMbId+'"},{"RowNo":1,"TaskName":"test","ResourceName":"test","TDate":"11/8/2016","Hrs":"8","ResourceId":"'+strPrjtTeaMbId+'"}],"TotalHours":10}';
            ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
            objTmeShtCntlr.PassedTimesheetJSON = JSONValue ;
            objTmeShtCntlr.ApproveTimesheet();      
        }
    }
    
    static TestMethod void RejectTimesheet_Test()
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
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'PCNET');
            
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
            PageReference pageRef = Page.TimesheetPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id',strTimeSheetId);
            ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
            ApexPages.currentPage().getParameters().put('Status','Submitted');
            ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
            objTmeShtCntlr.RejectTimesheet();            
        }
    }
    
    static TestMethod void SaveTimesheet_Test()
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
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Arun',portalAccount1.Id,odsSrv.Id);

            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            string strPrjtTeaMbId = string.valueOf(ObjTeamMembr.Id);
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'ODSDOTNET');
           
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
        
            system.RunAs(user1){
                PageReference pageRef = Page.TimesheetPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id',insertTimeSheet.id);
                ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
                ApexPages.currentPage().getParameters().put('Status','Submitted');
                ApexPages.currentPage().getParameters().put('WeekStart', strtDt.format());
                ApexPages.currentPage().getParameters().put('WeekEnd', endDt.format());
                string JSONValue = '{"WeekStartDate":"' + strtDt.format() +'","WeekEndDate":"' + endDt.format() +'","Status":"Saved","TimesheetDtls":[{"RowNo":1,"TaskName":"test","ResourceName":"Arun","TDate":"11/7/2016","Hrs":"2","ResourceId":"'+strPrjtTeaMbId+'"},{"RowNo":1,"TaskName":"test","ResourceName":"test","TDate":"11/8/2016","Hrs":"8","ResourceId":"'+strPrjtTeaMbId+'"}],"TotalHours":10}';
                ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
                objTmeShtCntlr.PassedTimesheetJSON = JSONValue ;
                objTmeShtCntlr.SaveTimesheet();
                objTmeShtCntlr.exportAsPDF();
                objTmeShtCntlr.exportAsExcel();
            }
        }
    }
    
    static TestMethod void SaveTimesheetWithInitiative_Test()
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
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Arun',portalAccount1.Id,odsSrv.Id);

            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);

            string strPrjtTeaMbId = string.valueOf(ObjTeamMembr.Id);
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'ODSDOTNET');
            Initiatives__c initiative = ODS_DataFactory_Test_Utility.insertIntiatives('Test Initiative', accSrvc.Id, 'Initiative Approved');
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
        
            system.RunAs(user1){
                PageReference pageRef = Page.TimesheetPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id',insertTimeSheet.id);
                ApexPages.currentPage().getParameters().put('AccServiceId',accSrvc.id);
                ApexPages.currentPage().getParameters().put('Status','Submitted');
                ApexPages.currentPage().getParameters().put('WeekStart', strtDt.format());
                ApexPages.currentPage().getParameters().put('WeekEnd', endDt.format());
                string JSONValue = '{"WeekStartDate":"' + strtDt.format() +'","WeekEndDate":"' + endDt.format() +'","Status":"Saved","TimesheetDtls":[{"RowNo":1,"TaskName":"test","ResourceName":"Arun","TDate":"11/7/2016","Hrs":"2","IntiativeId" : "'+initiative.Id+'", "IntiativeName": "Test Initiative","ResourceId":"'+strPrjtTeaMbId+'"},{"RowNo":1,"TaskName":"test","ResourceName":"test","TDate":"11/8/2016","Hrs":"8","ResourceId":"'+strPrjtTeaMbId+'"}],"TotalHours":10}';
                ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
                objTmeShtCntlr.PassedTimesheetJSON = JSONValue ;
                objTmeShtCntlr.SaveTimesheet();
                
            }
        }
    }
        
    static TestMethod void GetWeeklyTimesheet_Test()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8', 'Indumathi',
                    'en_US', 'en_US', profile1.Id, 'America/Chicago', System.now().millisecond() + 
                    'test123@testmail.com', 'Technical Account Manager', true, portalRole.Id);                     
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
            date aprveDt = strtDt.adddays(6);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'ODSSQL');
           
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('11/07/2016'),date.parse('11/13/2016'));
            string WeekSrtDt = '11/07/2016';
            string WeekEdDt = '11/13/2016';
            ODS_TimesheetController objTmeShtCntlr = new ODS_TimesheetController();
            objTmeShtCntlr.CurrenTimesheetId = insertTimeSheet.id;
            objTmeShtCntlr.PassedWeekFromDate = WeekSrtDt;
            objTmeShtCntlr.PassedWeekToDate = WeekEdDt;
            objTmeShtCntlr.CurrentAccServiceId = WeekEdDt;
            objTmeShtCntlr.GetWeeklyTimesheet();
            objTmeShtCntlr.GetTimesheetByAccountServiceID();
            
        }
    }   
    
}