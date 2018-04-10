@isTest

Public class BatchtomoveCampaignstoLeads_Test
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
            contact Con = EZRE_DataFactory_Test_Utility.createVMSContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createForcecomContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createForcecomContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            EZRE_BatchToupdateContactCampaigns obj=new EZRE_BatchToupdateContactCampaigns();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createAWSContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createDotNetContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createholidaycardsContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createGLIXContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createKPOContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createISR2Contact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createISR2Contact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            EZRE_BatchToupdateaccountCampaigns obj=new EZRE_BatchToupdateaccountCampaigns();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createTurnsliftContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createAnBContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createADMContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createHourPromotionContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createDataStaxContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createLegModContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createMiniFoxMascoWBContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true,'1: Calling','Jack');
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
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
            contact Con = EZRE_DataFactory_Test_Utility.createDISContact('Prelude','test1@gmail.com','Test Contact',inserttestaccount.Id,inserttestaccount.Name,true,true);
            
            system.debug('test++'+inserttestuser.FirstName+' '+inserttestuser.LastName+' '+inserttestuser.Name);
            system.debug('test=='+con.IsContactConvertedtoLead__c+' '+inserttestaccount.OwnerId+' '+inserttestaccount.Owner.Name);
            
            test.startTest();
            BatchtoMoveCampaignstoLeads obj=new BatchtoMoveCampaignstoLeads();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Prelude',Con.FirstName);
            }
        }
    }
    
    
    
    
    
 }