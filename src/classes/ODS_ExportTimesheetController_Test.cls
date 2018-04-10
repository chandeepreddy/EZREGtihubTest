@isTest
public class ODS_ExportTimesheetController_Test
{

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
                            portalAccountOwner1.Id, True,2000,'9433578865', 'Others', 'ODS Project');     
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
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'PCJAVA');

            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,strtDt,endDt,string.valueOf(strtDt.Month()),string.valueOf(strtDt.Year()));
                Timesheet__c insertTimeSheet = ODS_DataFactory_Test_Utility.insertTimesheetWithCost('testName',accSrvc.id,aprveDt,
                                   portalAccountOwner1.id,'TestComments','submitted',system.today(),strtDt,endDt,objTmeShtCst.Id);
          
            system.RunAs(user1){
                PageReference pageRef = Page.ODS_ExportTimesheet;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Weekfromdate',strtDt.format());
                ApexPages.currentPage().getParameters().put('Weektodate',endDt.format());
                ApexPages.currentPage().getParameters().put('Accountservice',accSrvc.Id);
                ODS_ExportTimesheetController ExptTmeSht = new ODS_ExportTimesheetController();

                ExptTmeSht.CurrenTimesheetId = insertTimeSheet.Id;
                ExptTmeSht.GetTimesheetDetails(insertTimeSheet.Id);                
            }
        }
    }
    
     static TestMethod void GetTimesheet_NegativeTest()
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
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'JHCSQL');
           
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,strtDt,endDt,string.valueOf(strtDt.Month()),string.valueOf(strtDt.Year()));
                Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,strtDt,endDt);
          
            system.RunAs(user1){
                PageReference pageRef = Page.ODS_ExportTimesheet;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Weekfromdate',strtDt.format());
                ApexPages.currentPage().getParameters().put('Weektodate',endDt.format());
                ApexPages.currentPage().getParameters().put('Accountservice',accSrvc.Id);
                ODS_ExportTimesheetController ExptTmeSht = new ODS_ExportTimesheetController();
                
                ExptTmeSht.CurrenTimesheetId = insertTimeSheet.Id;
                ExptTmeSht.GetWeeklyTimesheet();                
            }
        }
    }
    
    static TestMethod void BuildTimesheeHtml_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,2500,'9674677432', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',portalAccount1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'HSJAVA');

            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,strtDt,endDt,string.valueOf(strtDt.Month()),string.valueOf(strtDt.Year()));
            Timesheet__c insertTimeSheet = ODS_DataFactory_Test_Utility.insertTimesheetWithCost('testName',accSrvc.id,aprveDt, portalAccountOwner1.id,'TestComments','submitted',system.today(),strtDt,endDt,objTmeShtCst.Id);
            List<Time_Sheet_Details__c> timeShtDetailList = new List<Time_Sheet_Details__c>();
            Time_Sheet_Details__c timeshtDtls1 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.Id,'Test User', insertTimeSheet.Id, strtDt);
            timeShtDetailList.add(timeshtDtls1);
            Time_Sheet_Details__c timeshtDtls2 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.Id,'Test User', insertTimeSheet.Id, strtDt.addDays(1));
            timeShtDetailList.add(timeshtDtls2);
            system.RunAs(user1){
                PageReference pageRef = Page.ODS_ExportTimesheet;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Weekfromdate',strtDt.format());
                ApexPages.currentPage().getParameters().put('Weektodate',endDt.format());
                ApexPages.currentPage().getParameters().put('Accountservice',accSrvc.Id);
                ODS_ExportTimesheetController ExptTmeSht = new ODS_ExportTimesheetController();
                
                ExptTmeSht.CurrenTimesheetId = insertTimeSheet.Id;
                ExptTmeSht.GetWeeklyTimesheet();     
                ExptTmeSht.BuildTimesheeHtml(timeShtDetailList,insertTimeSheet.Id,strtDt);
            }
        }
    }
    
    static TestMethod void BuildTimesheeHtml_NegativeTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,3000,'9564345632', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',portalAccount1.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            date aprveDt = strtDt.adddays(6);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'HSSQL');
            
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,strtDt,endDt,string.valueOf(strtDt.Month()),string.valueOf(strtDt.Year()));
            Timesheet__c insertTimeSheet = ODS_DataFactory_Test_Utility.insertTimesheetWithCost('testName',accSrvc.id,aprveDt,
                               portalAccountOwner1.id,'TestComments','submitted',system.today(),strtDt,endDt,objTmeShtCst.Id);
            List<Time_Sheet_Details__c> timeShtDetailList = new List<Time_Sheet_Details__c>();
            Time_Sheet_Details__c timeshtDtls1 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.Id,'Test User', insertTimeSheet.Id, strtDt.addDays(2));
            timeShtDetailList.add(timeshtDtls1);
            Time_Sheet_Details__c timeshtDtls2 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.Id,'Test User', insertTimeSheet.Id, strtDt.addDays(3));
            timeShtDetailList.add(timeshtDtls2);
            Time_Sheet_Details__c timeshtDtls3 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.Id,'Test User', insertTimeSheet.Id, strtDt.addDays(4));
            timeShtDetailList.add(timeshtDtls3);
            Time_Sheet_Details__c timeshtDtls4 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.Id,'Test User', insertTimeSheet.Id, strtDt.addDays(5));
            timeShtDetailList.add(timeshtDtls4);
            Time_Sheet_Details__c timeshtDtls5 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.Id,'Test User', insertTimeSheet.Id, strtDt.addDays(6));
            timeShtDetailList.add(timeshtDtls5);
            system.RunAs(user1){
                PageReference pageRef = Page.ODS_ExportTimesheet;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Weekfromdate',strtDt.format());
                ApexPages.currentPage().getParameters().put('Weektodate',endDt.format());
                ApexPages.currentPage().getParameters().put('Accountservice',accSrvc.Id);
                ODS_ExportTimesheetController ExptTmeSht = new ODS_ExportTimesheetController();
                
                ExptTmeSht.CurrenTimesheetId = insertTimeSheet.Id;
                ExptTmeSht.GetWeeklyTimesheet();     
                ExptTmeSht.BuildTimesheeHtml(timeShtDetailList,insertTimeSheet.Id,strtDt);
            }
        }
    }
}