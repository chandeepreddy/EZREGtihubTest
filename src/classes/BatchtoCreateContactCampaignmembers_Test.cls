@isTest

Public class BatchtoCreateContactCampaignmembers_Test
{
    public static testmethod void MoveVMSContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('VMS');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createVMSaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling','Jack');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', VMS__c = true, Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();  
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    
    public static testmethod void MoveForcecomContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ODS Force.com');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createForcecomaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling','Glassdoor','Jack','Updated','test data comments for force com campaign');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', Force_com__c = true, Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    
    public static testmethod void MoveForcecomContactsmultipicklist()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
       List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
       {
            system.runAs(inserttestuserList[0])
          
           {
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ODS Force.com');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createForcecomaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling','Glassdoor','Jack','Updated','test data comments for force com campaign');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', Force_com__c = true, Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            EZRE_BatchToupdateContactCampaigns obj=new EZRE_BatchToupdateContactCampaigns();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
         }   
        }
    }
    
    
    public static testmethod void MoveAWSContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ODS AWS');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createAWSaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling','Glassdoor','Jack','Updated','test data comments for force com campaign');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, ODS_AWS__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
   public static testmethod void MoveDotNetContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ODS DOT NET');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createDotNetaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling','Jack','Updated','test data comments for force com campaign');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    } 
    
    
    
    
    
    
    
     public static testmethod void MoveHolidayCardsContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('Holiday Cards');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, Holiday_Cards__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    public static testmethod void MoveGLIXContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('GLIX');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', GLIX__c = true, Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
 public static testmethod void MoveKPOContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('KPO');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createKPOaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', KPO__c=true, Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    
  /*  public static testmethod void MoveDBITSContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('Texas-DBITS');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createDBITSAccounts('PreludeTestAccount',inserttestuser.id,true);
             
            //Insert contact 
            contact Con = EZRE_DataFactory_Test_Utility.createISR2Contact(null,'test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    } */
    
    public static testmethod void MoveITSACContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('Texas-ITSAC');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createITSACAccounts('PreludeTestAccount',inserttestuser.id,true);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            EZRE_BatchToupdateaccountCampaigns obj=new EZRE_BatchToupdateaccountCampaigns();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    
    
    
 public static testmethod void MoveTurnsliftContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('TurnsLift');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createTurnsliftaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, Turnslift__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
 
    public static testmethod void MoveAnBContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('AnB');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, AnB__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
     public static testmethod void MoveADMContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ADM');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, ADM__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    
    public static testmethod void HourpromotionContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('500 Hour Promotion');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.create500hourpromotionaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling','Jack','test data comments for 500 hour promotion campaign');
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, free500hrs__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
     public static testmethod void MoveDataStaxContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('DataStax');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, DataStax__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
     public static testmethod void MoveLegModContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('LegMod');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, LegMod__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    public static testmethod void MoveMiniFoxContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('Mini – Fox_Masco_WB');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, Mini_FOX_Masco_W_B__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    
     public static testmethod void MoveDISContacts()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
            
             Campaign cam= EZRE_DataFactory_Test_Utility.createcampaignstoleads('DIS');
            
            //Insert Account
             Account inserttestaccount = EZRE_DataFactory_Test_Utility.createCampaignAccounts('PreludeTestAccount',inserttestuser.id);
             
            //Insert contact 
contact con = new contact(accountid = inserttestaccount.id, DIS__c = true, lastname = 'test', Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;             
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoCreateContactCampaignmembers obj=new BatchtoCreateContactCampaignmembers();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals(null,Con.FirstName);
            }
        }
    }
    
    
    
    
    
 }