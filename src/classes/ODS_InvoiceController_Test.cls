/**
 * @author          Gnana Prakash
 * @version          1.0 
 * @date             11-Jan-2017
 * @Status           Developed
 * @description      This is the Test class for Invoice controller
 */

@isTest
public class ODS_InvoiceController_Test
{
     /// <OBJECTIVE>
    /// To test the Invoice fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void FetchInvoiceList_PositiveTest()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    portalAccountOwner.Id, True,1000,'95543567654','Others','Others');   
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id,'Others','Others');    
             Invoice__c Invoice = ODS_DataFactory_Test_Utility.InsertInvoice(accountServices.Id,'January',2016,'Comments');
             Date InvoiceStartDate= date.parse('11/01/2016');
             Date InvoiceEndDate = date.parse('11/30/2016');            
             test.startTest();
             ODS_InvoicepageController InvoiceController = new ODS_InvoicepageController();
             InvoiceController.AccountId = account.Id;
             InvoiceController.ServiceId = odsServices.Id;
             InvoiceController.FetchInvoiceList(account.Id,odsServices.Id,'January',2017);
             InvoiceController.FetchInvoiceList(account.Id,odsServices.Id,'',0);
             InvoiceController.GetCustomerByAccountServiceID();
             InvoiceController.getYears();
             test.stopTest();   
            
         }    
    }
    
   
    
     /// <OBJECTIVE>
    /// To test the Invoice fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void FetchInvoiceList_PositiveTest_WithFilterCondition()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    portalAccountOwner.Id, True,1000,'95543567654','Others','Others');      
            
            
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id,'Others','Others');    
             Invoice__c Invoice = ODS_DataFactory_Test_Utility.InsertInvoice(accountServices.Id,'January',2016,'Comments');
             Date InvoiceStartDate= date.parse('11/01/2016');
             Date InvoiceEndDate = date.parse('11/30/2016');
            
             test.startTest();
            ODS_InvoicepageController InvoiceController = new ODS_InvoicepageController();
            InvoiceController.FromDate = '';
            InvoiceController.ToDate = '';
            InvoiceController.AccountId = account.Id;
            InvoiceController.ServiceId = odsServices.Id;
            InvoiceController.FetchInvoiceList(account.Id,odsServices.Id,'January',2017);
            string s = 'test';
            InvoiceController.setSortDirection(s);
            InvoiceController.getSortDirection();
            InvoiceController.sortExpression = 'test';
            InvoiceController.fetchInvoiceListCommnadLink();
             //InvoiceController.FetchInvoiceList(account.Id,odsServices.Id,'','');
             test.stopTest();   
            
         }    
    }
    
    /// <OBJECTIVE>
    /// To test the Delete Invoice 
    /// </OBJECTIVE>
    static testMethod void Delete_PositiveTest()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    portalAccountOwner.Id, True,1000,'95543567654','Others','Others');      
            
            
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id,'Others','Others');    
             Invoice__c Invoice = ODS_DataFactory_Test_Utility.InsertInvoice(accountServices.Id,'January',2016,'Comments');
             Date InvoiceStartDate= date.parse('11/01/2016');
             Date InvoiceEndDate = date.parse('11/30/2016');
             Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Invoice', 'Invoice for the month of june',Invoice.Id); 
            
             test.startTest();
             ODS_InvoicepageController InvoiceController = new ODS_InvoicepageController();
            
             InvoiceController.AccountId = account.Id;
             InvoiceController.ServiceId = odsServices.Id;
             ApexPages.currentPage().getParameters().put('InvoiceId',Invoice.Id);
             
             InvoiceController.DeleteInvoice(); 
             
             test.stopTest(); 
         }    
    }
    /// <OBJECTIVE>
    /// To test the Upload Invoice 
    /// </OBJECTIVE>
    static testMethod void Upload_PositiveTest()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
             Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    portalAccountOwner.Id, True,1000,'95543567654','Others','Others');                  
             ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
             User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);
             date accountServiceStartDate =  Date.today();
             date accountServiceEndDate = accountServiceStartDate.adddays(5);
             Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id,'Others','Others');                              
             test.startTest();
             ODS_InvoicepageController InvoiceController = new ODS_InvoicepageController();
             Invoice__c Invc = new Invoice__c(Month__c = 'January', Year__c = 2016, Comments__c = 'Test Comments');
             InvoiceController.AccountId = account.Id;
             InvoiceController.ServiceId = odsServices.Id;
             InvoiceController.fileName = 'Invoice for the month of june';
             InvoiceController.blobBody = Blob.valueOf('Invoice for the month of June');
             InvoiceController.Invoice =  Invc;
             InvoiceController.UploadInvoice(); 
             test.stopTest(); 
         }    
    }
    
    /// <OBJECTIVE>
    /// To test the GetInvoiceAttachment
    /// </OBJECTIVE>
    static testMethod void GetInvoiceAttachment_PositiveTest()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                    portalAccountOwner.Id, True,1000,'95543567654','Others','Others');      
            
            
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id,'Others','Others');    
             Invoice__c Invoice = ODS_DataFactory_Test_Utility.InsertInvoice(accountServices.Id,'January',2016,'Comments');
             Date InvoiceStartDate= date.parse('11/01/2016');
             Date InvoiceEndDate = date.parse('11/30/2016');
             Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Invoice', 'Invoice for the month of june',Invoice.Id); 
            
             test.startTest();
             //ODS_InvoicepageController InvoiceController = new ODS_InvoicepageController();
            
             ODS_InvoicepageController.GetInvoiceAttachment(Invoice.Id);
             test.stopTest(); 
         }    
    }
    
    /// <OBJECTIVE>
    /// To test the Validate Invoicemethod
    /// </OBJECTIVE>
    static testMethod void ValidateUploadInvoice_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1000,'95543567654', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);
            Contact cont = ODS_DataFactory_Test_Utility.UpdateContactApprover(contact1.Id);
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'JHCSFDC');
            Invoice__c Invoice = ODS_DataFactory_Test_Utility.InsertInvoice(accountServices.Id,'January',2016,'Comments');
            Date InvoiceStartDate= date.parse('11/01/2016');
            Date InvoiceEndDate = date.parse('11/30/2016');
            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Invoice', 'Invoice for the month of june',Invoice.Id); 
            
            test.startTest();
            ODS_InvoicepageController InvoiceController = new ODS_InvoicepageController();
            ODS_InvoicepageController.ValidateUploadInvoice(portalAccount1.Id, odsSrv.Id, Invoice.Id, 'Test File Name');
            test.stopTest(); 
         }    
    }
    
    /// <OBJECTIVE>
    /// To test the Validate Invoicemethod
    /// </OBJECTIVE>
    static testMethod void FetchInvoiceList_PositiveTest2()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                     
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner1.Id, True,1000,'95543567654', 'Others', 'ODS Project');     
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, portalAccount1.Id, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(portalAccount1.id,'Technical Account Manager',portalAccountOwner1.Id,odsSrv.Id);
            Contact cont = ODS_DataFactory_Test_Utility.UpdateContactApprover(contact1.Id);
            date strtDt =  Date.today();
            date endDt = strtDt.adddays(5);
            Date Startdte = date.parse('11/01/2016');
            Date Enddte = date.parse('11/30/2016');
            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(portalAccount1.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', portalAccountOwner1.Id, 'JHCSFDC');
            Invoice__c Invoice = ODS_DataFactory_Test_Utility.InsertInvoice(accountServices.Id,'January',2016,'Comments');
            Date InvoiceStartDate= date.parse('11/01/2016');
            Date InvoiceEndDate = date.parse('11/30/2016');
            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Invoice', 'Invoice for the month of june',Invoice.Id); 
            
            test.startTest();
            ODS_InvoicepageController InvoiceController = new ODS_InvoicepageController();
            InvoiceController.AccountId = portalAccount1.Id;
            InvoiceController.ServiceId = odsSrv.Id;
            InvoiceController.FromDate = '';
            InvoiceController.ToDate = '';
            InvoiceController.GetSearchResults();
            InvoiceController.enableDisablePaginationLinks();
            InvoiceController.showLast();
            InvoiceController.showFirst();
            InvoiceController.showNext();
            InvoiceController.showPrevious();
            test.stopTest(); 
        }            
    }
    
}