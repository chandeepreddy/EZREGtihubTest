/**
 * @author           Manoj Kumar S
 * @version          1.0 
 * @date             09-Jan-2017
 * @Status           Developed
 * @description      This is the Test class for document controller
 */

@isTest
public class ODS_DocumentController_Test
{
    /// <OBJECTIVE>
    /// To test the Documents fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void FetchDocumentsList_PositiveTest()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');      
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
            Date documentStartDate = date.parse('11/01/2016');
            Date documentEndtDate = date.parse('11/30/2016');

          
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id, 'Others', 'ODS Project');    
             Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
            
             test.startTest();
             ODS_DocumentController documentController = new ODS_DocumentController();
             documentController.AccountId = account.Id;
             documentController.ServiceId = odsServices.Id;
             documentController.FetchDocumentsList(account.Id, odsServices.Id, string.valueof(documentStartDate ),string.valueof(documentEndtDate), '', '');
             documentController.FetchDocumentsList(account.Id, odsServices.Id,'','', '', '');
             test.stopTest();   
            
         }    
    }
    
     /// <OBJECTIVE>
    /// To test the Documents fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void FetchDocumentsList_PositiveTest1()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');      
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
            Date documentStartDate = date.parse('11/01/2016');
            Date documentEndtDate = date.parse('11/30/2016');

            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager', portalAccountOwner.Id, odsServices.Id);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id, 'Others', 'ODS Project');    
             Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
            
             test.startTest();
             ODS_DocumentController documentController = new ODS_DocumentController();
             documentController.AccountId = account.Id;
             documentController.ServiceId = odsServices.Id;
             
             documentController.FromDate = '';
             documentController.ToDate = '';
             documentController.DocumentName  ='';
             documentController.DocumentType = '';
             documentController.GetCustomerByAccountServiceID();
             //documentController.FetchDocumentsList(account.Id, odsServices.Id,'','', '', '');
             test.stopTest();   
            
         }    
    }
    
     /// <OBJECTIVE>
    /// To test the Document delete
    /// </OBJECTIVE>
    static testMethod void DeleteDocument_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');
             
            Contact contact = ODS_DataFactory_Test_Utility.InsertContactEmail('Test','McTesty', True, account.Id, true, 'Others', 'ODS Project'); 
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            Contact_Account_Service__c InsertContactAccountService = new Contact_Account_Service__c ();
            
            InsertContactAccountService  = ODS_DataFactory_Test_Utility.InsertContactAccountService(contact.Id,account.Id,odsServices.ID,True,True,True);   

            
            
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccntEmail(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id, true);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                             
            Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
    
            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Design', 'Design Document Content',documents.Id);     
            
            test.startTest();
            
            ODS_DocumentController documentController = new ODS_DocumentController();            
            //Test.setCurrentPage('Documents');   
            documentController.AccountId = account.Id;
            documentController.ServiceId = odsServices.Id;
            ApexPages.currentPage().getParameters().put('DocumentId', documents.Id);            
            documentController.DeleteDocument();
            test.stopTest();               
         }
    }
    
    /// <OBJECTIVE>
    /// To test the Document delete
    /// </OBJECTIVE>
    static testMethod void UploadDocument_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');
            
            Contact contact = ODS_DataFactory_Test_Utility.InsertContactEmail('Test','McTesty', True, account.Id, true, 'Others', 'ODS Project');    
            
            
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            Contact_Account_Service__c InsertContactAccountService = new Contact_Account_Service__c ();
            
            InsertContactAccountService  = ODS_DataFactory_Test_Utility.InsertContactAccountService(contact.Id,account.Id,odsServices.ID,True,True,True);   

            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccntEmail(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id, true);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                             
            Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
            

            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Design', 'Design Document Content',documents.Id);     
            
            //documents = ODS_DataFactory_Test_Utility.UpdateAttachment(attachment.Id, documents.Id);
            
            test.startTest();
            
            ODS_DocumentController documentController = new ODS_DocumentController();            
            //Test.setCurrentPage('Documents');   
            documentController.AccountId = account.Id;
            documentController.ServiceId = odsServices.Id;
               
            documentController.Documents =  documents;
            documentController.UploadDocument();
            test.stopTest();               
         }
    }
    
    /// <OBJECTIVE>
    /// To test the Documents fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void CheckValidUserDocumentDelete_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
                        User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                             
            Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
    
            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Design', 'Design Document Content',documents.Id);     
            
            test.startTest();
            ODS_DocumentController.CheckValidUserDocumentDelete(documents.Id, documents.CreatedById);
            test.stopTest();  
        }
    }
    
    /// <OBJECTIVE>
    /// To test the Documents fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void GetDocumentAttachment_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
                        User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                             
            Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
    
            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Design', 'Design Document Content',documents.Id);     
            
            //documents = ODS_DataFactory_Test_Utility.UpdateAttachment(attachment.Id, documents.Id);
            
            test.startTest();
            ODS_DocumentController.GetDocumentAttachment(documents.Id,account.Id, odsServices.Id);
            test.stopTest();  
        }
    }
    
     /// <OBJECTIVE>
    /// To test the Validate documents method
    /// </OBJECTIVE>
    static testMethod void ValidateUploadDocument_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
                        User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGFPHP');
                             
            Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
    
            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Design', 'Design Document Content',documents.Id);     
            
            //documents = ODS_DataFactory_Test_Utility.UpdateAttachment(attachment.Id, documents.Id);
            
            test.startTest();
            ODS_DocumentController.ValidateUploadDocument(documents.Name, account.Id, odsServices.Id, 'Es', documents.Id);
            test.stopTest();  
        }
    }
    
      /// <OBJECTIVE>
    /// To test the Documents fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void FetchDocumentsList_PositiveTest2()
    {
        
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                                                'en_US','en_US',profile.Id,'America/Chicago',System.now().millisecond() + 
                                                'test123@testmail.com','Technical Account Manager', true,portalRole.Id);                                     
        System.runAs (portalAccountOwner) 
        {                      
            Account account = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                            portalAccountOwner.Id, True,1000,'95543567654', 'Others', 'ODS Project');      
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
            Date documentStartDate = date.parse('11/01/2016');
            Date documentEndtDate = date.parse('11/30/2016');

            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccnt(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGFSQL');
                                   
             Contact contact = ODS_DataFactory_Test_Utility.InsertContact('Test','McTesty', True, account.Id, 'Others', 'ODS Project');    
             Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
            
             test.startTest();
             ODS_DocumentController documentController = new ODS_DocumentController();
             documentController.AccountId = account.Id;
             documentController.ServiceId = odsServices.Id;
             
             documentController.FromDate = '';
             documentController.ToDate = '';
             documentController.DocumentName  = '';
             documentController.DocumentType = '';
             
             documentController.GetSearchResults();
             //documentController.enableDisablePaginationLinks();
             //documentController.showLast();
             //documentController.showFirst();
             //documentController.showNext();
             //documentController.showPrevious();

             test.stopTest();   
         }    
    }
    
    static testMethod void Documentmail_PositiveTest()
    {
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        Profile profile1 = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        User portalAccountOwner1 = ODS_DataFactory_Test_Utility.InsertUserWithRole('indu','testuser@testmail.com','UTF-8','Indumathi',
                    'en_US','en_US',profile1.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Customer', true,portalRole.Id);                
        System.runAs (portalAccountOwner1) 
        {       
            Account portalAccount1 = ODS_DataFactory_Test_Utility.InsertAccountWithOwner('TestAccount',
                                portalAccountOwner1.Id, True, 1000,'8995533256', 'Others', 'ODS Project');
            
            Contact contact1 = ODS_DataFactory_Test_Utility.InsertContactWithApprover('Test','McTesty', True, portalAccount1.Id,False, 'Others', 'ODS Project');
            Profile portalProfile = ODS_DataFactory_Test_Utility.GetProfileName('Customer Community');
            User user1 = ODS_DataFactory_Test_Utility.InsertUserWithContact('test123', 'test12345@test.com', 'UTF-8','McTesty',
                            'en_US','en_US', portalProfile.Id, 'America/Los_Angeles', System.now().millisecond() + 
                            'test12345@test.com', contact1.Id,'Customer');
            contact1.IS_Portal_Access__c = False;
            contact1.FirstName = 'updatedFName';
            contact1.LastName = 'updatedLName';
            update contact1;
            ODS_Services__c odsServices = ODS_DataFactory_Test_Utility.insertODSServices('DotNet','test',true);
            Contact_Account_Service__c InsertContactAccountService = new Contact_Account_Service__c ();
            
            InsertContactAccountService  = ODS_DataFactory_Test_Utility.InsertContactAccountService(contact1.Id,portalAccount1.Id,odsServices.ID,True,True,True);
            InsertContactAccountService.Contact__c = contact1.Id;
            InsertContactAccountService.ODS_Service__c  = odsServices.ID;
            InsertContactAccountService.Is_Approver__c = False;
            InsertContactAccountService.Status_Report_Required__c = True;
            InsertContactAccountService.IsDocMailRequired__c = False;
        //    update InsertContactAccountService;
    }
    
 }     
    

}