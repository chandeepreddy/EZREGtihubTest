@isTest
public class Test_BatchCampiagnstoLeads {
public static testmethod void Batchcampaignstoleads(){
       // Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ODS Force.com');
        account a = new account(name = 'test', Source__c = 'Indeed', Force_com_Data_Status_Comments__c = 'test', Force_com_Data_Status__c = 'Updated', Executive_Summary__c = 'test', BillingCountry = 'United States', BillingState = 'DC', BillingPostalCode = '20005', BillingCity = 'Washington', BillingStreet = 'test', Website = 'http://1776.vc', Account_Status__c = 'suspect', Description = 'test', AnnualRevenue = 3456, NumberOfEmployees = 10, Industry = 'Agriculture' );
    insert a;
        contact c = new contact(lastname = 'test', Force_com__c = true, IsContactConvertedtoLead__c = true, isDoNotDelete__c = true, accountid = a.Id, status__c = '4a: Outcome - Not Interested',Lead_Gen_Name__c = 'David');
   insert c;
        system.debug('@@@@@@'+c);
        campaign cam = new campaign(name = 'test');
        insert cam;
        campaignmember cm = new campaignmember();
        cm.CampaignId = cam.Id;
        cm.Contact_Status__c = c.Status__c;
        cm.Status__c = a.Force_com_Account_Status__c;
        cm.Source__c = a.Source__c;
        cm.ContactId = c.Id;
    	cm.LeadId = c.Lead_Id__c;
        cm.Inside_SalesRep__c = a.Inside_Sales_Rep_del__c;
        cm.Data_Status__c = a.Force_com_Account_Status__c;
        cm.Comments__c = a.Force_com_Data_Status_Comments__c;
        insert cm;
    test.startTest();
            BatchMovingCampaignsunderLeads  obj=new BatchMovingCampaignsunderLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest(); 
           // system.assertEquals('Shahida',Con.If_Others_Please_Specify__c );
    }
}