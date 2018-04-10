/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             14-Oct-2016
 * @Status           Developed
 * @description      This is the test class for AddStatusReportcontroller.
 */
 
@isTest 
public class ODS_AddStatusReportController_Test
{
    static testMethod void statusReport_PositiveTest()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True, 1000, '8996554389', 'Others', 'ODS Project'); 

            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id );
            Date SRdt = Date.parse('12/19/2016');
            Date SRdte = Date.parse('12/18/2016');
            
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'DYSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,SRdt,'Completed Development', 'Testing to be started', 'None','Submitted');
                        
            Status_Report__c objSRT = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,SRdte ,'Development In Progress', 'Testing to be started', 'None','Saved');
            

            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            
            test.StartTest();  
                                    
            PageReference pageRef = Page.AddStatusReport;
            pageRef.getParameters().put('accntId', accObj.Id);
            pageRef.getParameters().put('srvcId', odsSrv.Id);
            pageRef.getParameters().put('srId', objSR.Id);
            Test.setCurrentPage(pageRef);
            
            ODS_AddStatusReportController addStatusContrlr = new ODS_AddStatusReportController();
            addStatusContrlr.GetAllAccounts();
            addStatusContrlr.GetAllServices();
            ODS_AddStatusReportController.GetAccountPicklistValues();
            addStatusContrlr.GetServicePicklistValues();
            ODS_AddStatusReportController.GetStatusPicklistValues();
            addStatusContrlr.FormatStringToDate('10-09-2016');
            addStatusContrlr.saveStatusReport();
            addStatusContrlr.SetRelatedService();
            addStatusContrlr.submitStatusReport();
            addStatusContrlr.cancelStatusReport();   
            addStatusContrlr.redirectToStatusPage();
            addStatusContrlr.redirectToTimeSheet();
            addStatusContrlr.fetchStatusReportByDate();
            addStatusContrlr.fetchCustomDateSR();
            test.stopTest();
            system.assertequals(objSRT.Account_Services__c,accSrvc.id);
        }                   
        
    }
    
    static testMethod void SubmitSR_Test()
    {
       //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US', 'en_US', SAProfile.Id, 'America/Chicago', System.now().millisecond() + 
                    'test123@testmail.com', 'Practice Head', true);    

        System.runAs (usrObj) 
        {       
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1000,'8996554389', 'Others', 'ODS Project'); 

            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id );
            
            Date SRdt = Date.parse('12/19/2016');
            Date SRdte = Date.parse('12/18/2016');
            
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'SFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');

            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('batman','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US', 'en_US', SAProfile.Id, 'America/Chicago', System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true); 
            
            test.StartTest();  
            PageReference pageRef = Page.AddStatusReport;
            pageRef.getParameters().put('accntId', accObj.Id);
            pageRef.getParameters().put('srvcId', odsSrv.Id);

            Test.setCurrentPage(pageRef);
            
            ODS_AddStatusReportController addStatusContrlr = new ODS_AddStatusReportController();
            addStatusContrlr.isMyAccShow = true;
            addStatusContrlr.Errormsg = 'Test Error';
            addStatusContrlr.AccountServiceID = accSrvc.Id;
            addStatusContrlr.WorkDayParam1 = 'Development Completed';
            addStatusContrlr.WorkNextDayParam1 = 'Testing';
            addStatusContrlr.WorkDayParam1 = 'No Issue';
            addStatusContrlr.submitStatusReport();
            addStatusContrlr.fetchCustomDateSR();
            addStatusContrlr.saveStatusReport();
            test.stopTest();
              system.assertequals(accSrvc.Account__c,accObj.id);

                     }                   
        
    }
    
 
}