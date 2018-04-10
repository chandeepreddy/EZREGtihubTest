/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             14-Oct-2016
 * @Status           Developed
 * @description      This is the test class for ODS Status Report Controller Class.
 */
 
@isTest 
public class ODS_StatusReportController_Test
{
    
    ///<OBJECTIVE>
    ///Test method to test controller method with Portal Account Owner
    ///</OBJECTIVE>
    public static testmethod void Constructor_PortalOwner()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,2000,'9432466765', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'WEDCSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
           
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.Id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            PageReference pageRef = Page.StatusReport;
            
            Test.setCurrentPage(pageRef);
            ODS_StatusReportController objCntrllr = new ODS_StatusReportController(); 
            string strAcntId = string.valueof(accObj.Id);
            string strServId = string.valueof(odsSrv.Id);
            objCntrllr.AccountId = strAcntId;
            objCntrllr.serviceId = strServId;
            objCntrllr.GetAllAccounts();
            objCntrllr.GetAllServices();
            objCntrllr.GetAccountPicklistValues();
            objCntrllr.getLoggedUserPortalAccess();
            objCntrllr.getLoggedUserPortalRole();
            objCntrllr.FormatStringToDate('10-08-2016');
            objCntrllr.GetServicePicklistValues();
            ODS_StatusReportController.GetStatusPicklistValues();
            objCntrllr.GetStatusReportByAccountServiceID();
        }
    }

    ///<OBJECTIVE>
    ///Test method to perform Search
    ///</OBJECTIVE>
    public static testmethod void StatusReport_PaginationMethods()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1400,'9443655765', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'ODSJAVA');

            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');

            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.Id,System.Today(),'Completed Development', 'Testing to be started', 'None','Saved');
            Status_Report__c objSR2 = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.Id,System.Today(),'Completed Development', 'Testing to be started', 'None','Saved');

            string StatusRptId = string.valueof(objSR.Id);
            PageReference pageRef = Page.StatusReport;
            Test.setCurrentPage(pageRef);
            ODS_StatusReportController objCntrllr = new ODS_StatusReportController();
            objCntrllr.CurrenSRId = StatusRptId;

            objCntrllr.InvokeToDateMethod();   
            objCntrllr.GetStatusReport();
 
            objCntrllr.pageSize = 1;
            objCntrllr.showPrevious();  
            objCntrllr.showNext();
            objCntrllr.showFirst(); 
            objCntrllr.showLast();
            objCntrllr.enableDisablePaginationLinks();         
        }
    
    }
    
    public static testMethod void EditStatusReport_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9885443543',
                                'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'WEDCNET');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            
            PageReference pageRef = Page.StatusReport;
            pageRef.getParameters().put('editSRId', objSR.Id);
            Test.setCurrentPage(pageRef);
            
            ODS_StatusReportController objCntrllr = new ODS_StatusReportController();
            objCntrllr.editStatusReport();     
        }                   
    }
    
    public static testMethod void DeleteStatusReport_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,2000,'8775543565', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id );

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'PCJAVA');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            
            PageReference pageRef = Page.StatusReport;
            pageRef.getParameters().put('deleteSRId', objSR.Id);
            Test.setCurrentPage(pageRef);
            
            ODS_StatusReportController objCntrllr = new ODS_StatusReportController();
            objCntrllr.deleteStatusReport();     
        }                   
    }
    
    public static testMethod void AddStatusReport_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,3000,'8644521780', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'PCSQL');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');

            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');          
            PageReference pageRef = Page.StatusReport;            
            Test.setCurrentPage(pageRef);
            
            ODS_StatusReportController objCntrllr = new ODS_StatusReportController();
            objCntrllr.AddStatusReport();     
        }                   
    }

    ///<OBJECTIVE>
    ///Test method to test search functionality
    ///</OBJECTIVE>
    public static testmethod void SearchStatusReport_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,2000,'9077654134', 'Others', 'ODS Project'); 
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(accObj.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);

            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'ODSSFDC');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, accObj.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');

            Status_Report__c objSR = ODS_DataFactory_Test_Utility.InsertSR(accSrvc.Id,System.Today(),'Completed Development', 'Testing to be started', 'None','Submitted');
            PageReference pageRef = Page.StatusReport;
            Test.setCurrentPage(pageRef);
            ODS_StatusReportController objCntrllr = new ODS_StatusReportController(); 
            objCntrllr.WorkNextDayParam = 'Development';
            objCntrllr.IssuesConcernsParam = 'Testing';
            objCntrllr.srWorkDay = 'None';

            objCntrllr.GetAllAccounts();
            objCntrllr.GetAllServices();
            objCntrllr.GetAccountPicklistValues();

            objCntrllr.accountId = accObj.Id;
            objCntrllr.serviceId = odsSrv.Id;
            objCntrllr.SetRelatedService();
            objCntrllr.SearchAppliedRecords();
            
        }
    
    }
}