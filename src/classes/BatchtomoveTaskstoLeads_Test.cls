@isTest

Public class BatchtomoveTaskstoLeads_Test
{
    public static testmethod void converttasktoleads()
    {
        // Insert Profile
        Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        /* 
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
            contact Con = EZRE_DataFactory_Test_Utility.createISR2Contact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true);
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            // Insert Task for contact
            */
        	 account a = new account(name = 'test', Source__c = 'Indeed', Force_com_Data_Status_Comments__c = 'test', Force_com_Data_Status__c = 'Updated', Executive_Summary__c = 'test', BillingCountry = 'United States', BillingState = 'DC', BillingPostalCode = '20005', BillingCity = 'Washington', BillingStreet = 'test', Website = 'http://1776.vc', Account_Status__c = 'suspect', Description = 'test', AnnualRevenue = 3456, NumberOfEmployees = 10, Industry = 'Agriculture' );
    insert a;
        contact c = new contact(lastname = 'test', Force_com__c = true, IsContactConvertedtoLead__c = true, isDoNotDelete__c = true, accountid = a.Id, status__c = '4a: Outcome - Not Interested',Lead_Gen_Name__c = 'David');
   insert c;
             Task inserttesttask= EZRE_DataFactory_Test_Utility.createTasktoleads('call',C.id,Date.today().addDays(3),'Not Started',inserttestuser.id,false );
            
            test.startTest();
            BatchtomoveTaskstoLeads obj=new BatchtomoveTaskstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            //system.assertEquals('Prelude',Con.FirstName);
            }
}