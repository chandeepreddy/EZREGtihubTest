@isTest

Public class BatchtoConvertContactstoLeads_Test
{
    public static testmethod void convertForcecomcontactstoleads()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR','testuser@testmail.com','UTF-8','ISR', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
            contact Con = EZRE_DataFactory_Test_Utility.createForcecomContactonly('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,false,true,false);
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            // Insert Task for contact
            //Task inserttesttask= EZRE_DataFactory_Test_Utility.createTask('call',Con.id,12//2017);
            
            test.startTest();
            BatchtoConvertContactstoLeads  obj=new BatchtoConvertContactstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest(); 
            system.assertEquals('Shahida',Con.If_Others_Please_Specify__c );
            }
        }
    }
    
   public static testmethod void convertAWScontactstoleads()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR','testuser@testmail.com','UTF-8','ISR', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
            contact Con = EZRE_DataFactory_Test_Utility.createAWSContactonly('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,false,false,true);
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            // Insert Task for contact
            //Task inserttesttask= EZRE_DataFactory_Test_Utility.createTask('call',Con.id,12//2017);
            
            test.startTest();
            BatchtoConvertContactstoLeads  obj=new BatchtoConvertContactstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest(); 
            system.assertEquals('Shahida',Con.If_Others_Please_Specify__c );
            }
        }
    }
    
     public static testmethod void convertBothcontactstoleads()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR','testuser@testmail.com','UTF-8','ISR', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
            contact Con = EZRE_DataFactory_Test_Utility.createbothContacts('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,false,true,true);
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            // Insert Task for contact
            //Task inserttesttask= EZRE_DataFactory_Test_Utility.createTask('call',Con.id,12//2017);
            
            test.startTest();
            BatchtoConvertContactstoLeads  obj=new BatchtoConvertContactstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest(); 
            system.assertEquals('Shahida',Con.If_Others_Please_Specify__c );
            }
        }
    }
    
    public static testmethod void Batchcontactstoleads(){
        
        account a = new account(name = 'test', Executive_Summary__c = 'test', Force_com_Data_Status__c = 'Updated', BillingCountry = 'United States', BillingState = 'DC', BillingPostalCode = '20005', BillingCity = 'Washington', BillingStreet = 'test', Website = 'http://1776.vc', Account_Status__c = 'suspect', Description = 'test', AnnualRevenue = 3456, NumberOfEmployees = 10, Industry = 'Agriculture' );
    insert a;
        contact c = new contact(lastname = 'test', IsContactConvertedtoLead__c = false, isDoNotDelete__c = false, Force_com__c = true, accountid = a.Id, status__c = '4a: Outcome - Not Interested',Lead_Gen_Name__c = 'David');
   insert c;
        lead l = new lead();
        l.Status = c.Status__c;
        l.LastName = 'test';
        l.Company = 'IT';
        l.Lead_Gen_Name__c = 'David';
        insert l;
    test.startTest();
            BatchtoConvertContactstoLeads  obj=new BatchtoConvertContactstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest(); 
           // system.assertEquals('Shahida',Con.If_Others_Please_Specify__c );
    }

    
    
    
 }