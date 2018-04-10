@isTest
public class test_opportunity_SendEmail{
    public static testMethod void testSendEmail() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'testUser', Email='standarduser@testorg.com', 
                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='testduser@testorg.com');
        
        System.runAs(u) { 
        Account accObj = new Account(Name = 'Test Account',AnnualRevenue=567,Phone='9677273086',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',Industry='Technology',NumberofEmployees=100);
        insert accObj;
               
        Opportunity oppObj1 = new Opportunity(Name = 'Test Opportunity', 
                                AccountId = accObj.Id, 
                                CloseDate = System.Today(), 
                                StageName = 'Closed Won', 
                                Project_Title__c = 'Title',
                                Total_Project_Value__c = 100,
                                Team_Size__c = '10 members',
                                Project_Duration__c = '10 months',
                                Technologies_Used__c = 'SFDC',
                                Project_Description__c = 'Description',
                                How_did_we_win__c = 'Win',
                                Competition__c = 'Competition data',
                                Special_Notes__c = 'Notes',
                                Sales_Contact__c = u.Id,
                                Technical_Contact__c = u.Id);
        Opportunity oppObj2 = new Opportunity(Name = 'Test Opportunity', 
                                AccountId = accObj.Id, 
                                CloseDate = System.Today(), 
                                StageName = 'Closed Lost');
         
         insert oppObj1;                        
         insert oppObj2;
         
         oppObj2.StageName = 'Closed Won';
         oppObj2.Project_Title__c = 'Title';
         oppObj2.Total_Project_Value__c = 100;
         oppObj2.Team_Size__c = '10 members';
         oppObj2.Project_Duration__c = '10 months';
         oppObj2.Technologies_Used__c = 'SFDC';
         oppObj2.Project_Description__c = 'Description';
         oppObj2.How_did_we_win__c = 'Win';
         oppObj2.Competition__c = 'Competition data';
         oppObj2.Special_Notes__c = 'Notes';
         oppObj2.Sales_Contact__c = u.Id;
         oppObj2.Technical_Contact__c = u.Id;
         
         update oppObj2;

        }
    }
}