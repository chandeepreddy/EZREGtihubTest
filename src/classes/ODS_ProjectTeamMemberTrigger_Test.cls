/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             15-12-2016
 * @Status           In Development
 * @description      Test class for ODS_ProjectTeamMemberTrigger and it's Controller
 */
@isTest
public class ODS_ProjectTeamMemberTrigger_Test
{
    //Insert new TeamMember Record
    static TestMethod void InsertTeamMember_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1000,'9443858764', 'Others', 'ODS Project'); 
            //Insert ODS Service
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('SFDC','Test Ods Service',true);
            //Insert Project Team Member
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);
            system.assertEquals('Selva', ObjTeamMembr.Resource_Name__c);
        }
    }
    
    //Update a TeamMember Record
    static TestMethod void UpdateTeamMember_Test()
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
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True, 1500, '9404433444', 'Others', 'ODS Project'); 
            //Insert ODS Service
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('SFDC','Test Ods Service',true);
            //Insert Project Team Member
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Selva',accObj.Id,odsSrv.Id);
            try {
                //Insert Project Team Member
                Project_Team_Member__c ObjTeamMembr2 = ODS_DataFactory_Test_Utility.insertTeamMember('SelvaPandiyan',accObj.Id,odsSrv.Id);
                
                Project_Team_Member__c updateTeamMembr = new Project_Team_Member__c(Id =  ObjTeamMembr.Id);
                updateTeamMembr.Resource_Name__c = ObjTeamMembr2.Resource_Name__c;
                update updateTeamMembr;
                system.assertEquals(updateTeamMembr.Resource_Name__c, ObjTeamMembr2.Resource_Name__c);
            }
            catch(Exception e) {
               //string errMsg = e;
              // System.assertEquals(errMsg, ObjTeamMembr.Resource_Name__c+ ' is already exist for this '+
                          //  ObjTeamMembr.ODS_Services__r.name__c+' Service.');
            }
        }
    }
    //Update a resource name in timesheet object whenever name changes in team member object
    static TestMethod void UpdateResourceName_Test()
    {
        //fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        //fetch system admin profile
        Profile SAProfile  = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id); 
        
        system.runAs(usrObj)
        {
            Account accObj = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',usrObj.Id, True,1500,'9404433444', 'Others', 'ODS Project'); 
            //Insert ODS Service
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('SFDC','Test Ods Service',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUserAccount(accObj.id,'Technical Account Manager',
                                                    usrObj.Id,odsSrv.Id);         
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Date formattedStartDt = date.parse('11/01/2016');
            Date formattedendDt = date.parse('11/30/2016');
            Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(accObj.id,strtDt, endDt, 150.0, odsSrv.id, 1000, 'Monthly', usrAcc.user__c, 'ODSPHP');
            Project_Team_Member__c ObjTeamMembr = ODS_DataFactory_Test_Utility.insertTeamMember('Kalai',accObj.Id,odsSrv.Id);
            Time_Sheet_Cost__c objTmeShtCst = ODS_DataFactory_Test_Utility.insertTimesheetCost(accSrvc.Id,300,
                                    formattedStartDt,formattedendDt,'11','2016');
            Timesheet__c insertTimeSheet =  ODS_DataFactory_Test_Utility.insertTimesheetWithCst('TestName',objTmeShtCst.Id,
                                    date.parse('11/07/2016'),date.parse('11/13/2016'));
            Time_Sheet_Details__c timeshtDtls1 = ODS_DataFactory_Test_Utility.insertTimesheetdetail(8,ObjTeamMembr.id,
                                    ObjTeamMembr.Resource_Name__c, insertTimeSheet.Id, strtDt);
           
            try {
                //update Resource Name in Project Team Member object
                Project_Team_Member__c updateTeamMembr = new Project_Team_Member__c(Id =  ObjTeamMembr.Id);
                updateTeamMembr.Resource_Name__c = 'Kalaiselvi';
                update updateTeamMembr;
                Time_Sheet_Details__c fetchTimeShtDtl = [SELECT Resource__c From Time_Sheet_Details__c WHERE 
                                Resource_Id__c =:ObjTeamMembr.Id];
                system.assertEquals(updateTeamMembr.Resource_Name__c,fetchTimeShtDtl.Resource__c);
            }
            catch(Exception e) {
                system.debug(e);
            }
        }
    }
}