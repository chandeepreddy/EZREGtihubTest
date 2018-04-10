/**
 * @author           Kirankumar D
 * @version          1.0 
 * @date             09-Nov-2016
 * @Status           Developing
 * @description      This is the test class for TimeSheetCost Controller
 */

@isTest
public class ODS_TimeSheetCostController_Test
{
    static TestMethod void CheckIfMonthExistInCostTable_UpdateTest()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1300,'9864457854', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'GGFDOTNET');
                             
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            string AcntSrvId = string.valueOf(accSrvc.Id);
            Date dtStart = Date.Parse('11/01/2016');
            //Insert Time Sheet Cost record
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            Time_Sheet_Cost__c insertPrevMthTSC = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,100,PrevMthStrtDate,PrevMthEndDate ,'10','2016');
            
            ODS_TimeSheetCostController objTmStCntlr = new ODS_TimeSheetCostController();
            ODS_TimeSheetCostController.CheckIfMonthExistInCostTable(11,2016,AcntSrvId,300.0,dtStart);
        }
    }
    
    static TestMethod void CheckIfMonthExistInCostTable_InsertTest()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,2000,'9445633522', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'WEDCNET');
                             
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            string AcntSrvId = string.valueOf(accSrvc.Id);
            Date dtStart = Date.Parse('11/01/2016');
            
            ODS_TimeSheetCostController.CheckIfMonthExistInCostTable(10,2016,AcntSrvId,300.0,dtStart);
            ODS_TimeSheetCostController.setStringToDateFormat('10-07-2016');
        }
    }
    
    static TestMethod void populateResourceCount_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,3000,'9554367785', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'WEDCPHP');
                             
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            string AcntSrvId = string.valueOf(accSrvc.Id);
            Date dtStart = Date.Parse('11/01/2016');
            Date WeekStrDte = date.parse('10/03/2016');
            //Insert Time Sheet Cost record
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            
            //Insert TimeSheet record
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('10/03/2016'),date.parse('10/09/2016'));
            
            //Insert TimeSheetDetail record
            Time_Sheet_Details__c inrtTimeShtDtl = ODS_DataFactory_Test_Utility.insertTimesheetdetail(5,ObjTeamMembr.Id,'Test Res',insertTimeSheet.Id,date.parse('10/07/2016'));
            ODS_TimeSheetCostController.populateResourceCount(objTmeShtCst,WeekStrDte,AcntSrvId);
        }
    }
    
    static TestMethod void populateODSHours_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,3500,'9006445332', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'NASFDC');
                             
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Date PrevMthStrtDate = date.parse('10/01/2016');
            Date PrevMthEndDate = date.parse('10/31/2016');
            string AcntSrvId = string.valueOf(accSrvc.Id);
            Date dtStart = Date.Parse('11/01/2016');
            Date WeekStrDte = date.parse('10/03/2016');
            //Insert Time Sheet Cost record
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,Startdte,Enddte,'11','2016');
            
            //Insert TimeSheet record
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,date.parse('10/03/2016'),date.parse('10/09/2016'));
            
            //Insert TimeSheetDetail record
            Time_Sheet_Details__c insrtTimeShtDtl = ODS_DataFactory_Test_Utility.insertTimesheetdetail(5,ObjTeamMembr.Id,'Test Res',insertTimeSheet.Id,date.parse('10/07/2016'));
            ODS_TimeSheetCostController.populateODSHours(objTmeShtCst,WeekStrDte,AcntSrvId);
        }
    }
    
}