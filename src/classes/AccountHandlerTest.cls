@isTest
public class AccountHandlerTest {

    public static testMethod void positivetest(){
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');

       User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('mytest','testuser@testmail.com', 'UTF-8','Indumathi6', 'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'ezre@preludesys.com','Practice Head', true);
user u = new user(lastname = 'test787');
        Account acc = ODS_DataFactory_Test_Utility.InsertAccountforIntroAndKickoffMail('TestAccount',usrObj.id,'Sent',system.today(),10000,'7665233156','Others','ODS Project',True, 'Customer',True,false);
        Contact con = ODS_DataFactory_Test_Utility.InsertContactforcreatechilds('Test','Contact','1: Calling',acc.Id,'Maharaja0393@gmail.com'); 
        acc.Primary_Customer_Contact__c = con.id;
        ODS_Services__c ods = new ODS_Services__c(Name__c = 'Salesforce', Description__c = 'Test salesforce' , Active__c = true);
        insert ods; 
                Test.startTest();
                acc.Primary_Customer_Contact__c = con.id;
                acc.Account_Status__c = 'Customer'; 
                acc.SOW__c = 'Fully Executed';
                acc.CheckIntroDuplicate__c = false;
                acc.isSentIntroductionMail__c = false;
                acc.TriggerKickoffMail__c = false;
        
             //   update acc;
                Test.stopTest();   
      //system.assertEquals(true, acc.isSentIntroductionMail__c);
       // system.assertEquals(true, acc.isSentKickoffMail__c);
    }
    
}