/**
 * @author           
 * @version          1.0 
 * @date             26-May-2017
 * @description      Test class for ODS_DocumentUploadController
 */
 @isTest
 public class ODS_DocumentUploadController_Test
 {
    public static testmethod void Constructor_Test()
    {
    date strtDt =  Date.today();
    Account acc = ODS_DataFactory_Test_Utility.insertAccount('Test Account', 'Test City', False,2000,'9433578865','Others', 'ODS Project');
    Documents__c document = ODS_DataFactory_Test_Utility.InsertDocumentDate('Estimation',4,strtDt,acc .id);
    System.assertEquals('Estimation',document.Name);
    test.StartTest();
    ODS_DocumentUploadController documentuploadcontroller= new ODS_DocumentUploadController();
    test.StopTest();
    }
    
    
    public static testmethod void ValidateFolderName_Test()
    {
    Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
    User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('Prels','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'sample123@testmail.com','Practice Head', true); 
    System.runAs (usrObj)
    {                    
    Account acc = ODS_DataFactory_Test_Utility.insertAccount('First Account', 'Test City', False,2000,'9433578865','Others', 'ODS Project');
    ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('Python','test',true);
    User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(acc.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
    date strtDt =  Date.today();
    date endDt = strtDt.adddays(5);
    Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(acc.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'DSSFDC');
    Folder__c folder=ODS_DataFactory_Test_Utility.InsertFolder('Test',accSrvc.Id);
    System.assertEquals('Test',folder.Name);
    test.StartTest();
    ODS_DocumentUploadController.ValidateFolderName('Test',acc.Id,odsSrv.Id );
    test.StopTest();
    
    string acntId = string.valueof(acc.Id);
    string srvId = string.valueof(odsSrv.Id);
    string fldrId = string.valueof(folder.Id);
    string strtDt1 = string.valueof(strtDt);
    string endDt1 = string.valueof(endDt);
    
    
    //ODS_Data_Utility.GetDocuments(acntId ,srvId ,fldrId ,strtDt1 ,endDt1 ,'Test');
    }
    }
   
    public static testmethod void Pagination_Test()
    {
   
    
    test.StartTest();
    ODS_DocumentUploadController documentuploadcontroller= new ODS_DocumentUploadController();
    documentuploadcontroller.CurrentPage=1;
    documentuploadcontroller.PageSize = 2;
    documentuploadcontroller.TotalRecords=3;
    documentuploadcontroller.showPrevious();
    documentuploadcontroller.showNext();
    documentuploadcontroller.showLast();
    documentuploadcontroller.showFirst();
    test.StopTest();
    }
    
  
    
    public static testmethod void GetAccountServices_Test()
    {
    Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
    User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('Prels','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'sample123@testmail.com','Practice Head', true); 
    System.runAs (usrObj)
    {                    
    Account acc = ODS_DataFactory_Test_Utility.insertAccount('First Account', 'Test City', False,2000,'9433578865','Others', 'ODS Project');
    ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('Python','test',true);
    User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(acc.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
    date strtDt =  Date.today();
    date endDt = strtDt.adddays(5);
    Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(acc.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'DSSFDC');
    Folder__c folder=ODS_DataFactory_Test_Utility.InsertFolder('Test',accSrvc.Id);
    System.assertEquals('Test',folder.Name);
    test.StartTest();
    ODS_DocumentUploadController documentuploadcontroller= new ODS_DocumentUploadController();
    documentuploadcontroller.GetAccountServices();
    test.StopTest();
    }
    }
    
   public static testmethod void CreateFolder_Test()
    {
    Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
    User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('Prels','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'sample123@testmail.com','Practice Head', true); 
    System.runAs (usrObj)
    {                    
    Account acc = ODS_DataFactory_Test_Utility.insertAccount('First Account', 'Test City', False,2000,'9433578865','Others', 'ODS Project');
    ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('Python','test',true);
    User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(acc.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
    date strtDt =  Date.today();
    date endDt = strtDt.adddays(5);
    Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(acc.id,strtDt, endDt,
                             150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'DSSFDC');
    Folder__c folder=ODS_DataFactory_Test_Utility.InsertFolder('Test',accSrvc.id);
    //System.assertEquals('Test',folder.Name);
    test.StartTest();
    ODS_DocumentUploadController documentuploadcontroller= new ODS_DocumentUploadController();
    documentuploadcontroller.AccountId = acc.Id;
    documentuploadcontroller.ServiceId = odsSrv.Id;
    documentuploadcontroller.CreateFolder();
    
    
    test.StopTest();
    }
    } 
    
    public static testMethod void FetchDocuments_Test()
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
             ODS_DocumentUploadController documentUploadController = new ODS_DocumentUploadController(); 
             documentUploadController.FetchDocuments();
             test.stopTest();  
         }   
 }
 
Public static testMethod void ValidateUploadDocument_Test()
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
            
           
            
            test.startTest();
            ODS_DocumentUploadController.ValidateUploadDocument(documents.Name, account.Id, odsServices.Id, 'Es', documents.Id);
            test.stopTest();  
        }
    }
    
    
      public static testMethod void GetDocumentAttachment_Test()
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
            ODS_DocumentUploadController.GetDocumentAttachment(documents.Id,account.Id,odsServices.Id);
            test.stopTest();  
        }
    }
    
    Public static testMethod void CheckValidUserDocumentDelete_Test()
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
            ODS_DocumentUploadController.CheckValidUserDocumentDelete(documents.Id, documents.CreatedById);
            test.stopTest();  
        }
    }
    
    static testMethod void DeleteDocument_Test()
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
            
            //InsertContactAccountService  = ODS_DataFactory_Test_Utility.InsertContactAccountService(contact.Id,odsServices.ID,True,True,True);   

            
            
            date accountServiceStartDate =  Date.today();
            date accountServiceEndDate = accountServiceStartDate.adddays(5);
            User_Account__c userAccount = ODS_DataFactory_Test_Utility.insertUsrAccntEmail(account.id,'Technical Account Manager',portalAccountOwner.Id,odsServices.Id, true);

            Account_Services__c accountServices = ODS_DataFactory_Test_Utility.insertAccountServices(account.id,accountServiceStartDate, accountServiceEndDate,
                             150.0, odsServices.id, 1000, 'Monthly', portalAccountOwner.Id, 'GGF');
                             
            Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id);
    
            Attachment attachment =  ODS_DataFactory_Test_Utility.InsertAttachment('Design', 'Design Document Content',documents.Id);     
            
            test.startTest();
            
            ODS_DocumentUploadController documentUploadController = new ODS_DocumentUploadController();            
              
            documentUploadController.AccountId = account.Id;
            documentUploadController.ServiceId = odsServices.Id;
            ApexPages.currentPage().getParameters().put('DocumentId', documents.Id);            
            documentUploadController.DeleteDocument();
            test.stopTest();               
         }
    }
    
     public static testmethod void GetSearchResults_Test()
    {
    
    test.StartTest();
    ODS_DocumentUploadController documentuploadcontroller= new ODS_DocumentUploadController();
    documentuploadcontroller.CurrentPage=1;
    documentuploadcontroller.PageNumber = 2;
    documentuploadcontroller.SelectedFolderName='Test';
    documentuploadcontroller.SelectedFolderId='Sample';
    documentuploadcontroller.ShowSearchPanel=true;
    //documentuploadcontroller.GetStatusReportByAccountServiceID();
    documentuploadcontroller.GetSearchResults();
    documentuploadcontroller.ShowOrHideSearchPanel();
        string s = 'test';
        string s1 = 'test';
        documentuploadcontroller.setSortDirection(s);
        documentuploadcontroller.getSortDirection();
        documentuploadcontroller.setSortDirection1(s);
        documentuploadcontroller.getSortDirection1();
		documentuploadcontroller.sortExpression = 'test';
		documentuploadcontroller.sortExpression1 = 'teest';

    
    test.StopTest();
    }
    
    public static testmethod void GetStatus_Test()
    {
    
    test.StartTest();
    ODS_DocumentUploadController documentuploadcontroller= new ODS_DocumentUploadController();
     documentuploadcontroller.GetStatusReportByAccountServiceID();
     documentuploadcontroller.RedirectToTrash();
      test.StopTest();
     }
     
     Public static testMethod void ValidateDragAndDropDocument_Test()
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
            
           
            
            test.startTest();
            ODS_DocumentUploadController.ValidateDragAndDropDocument(documents.Name, account.Id, odsServices.Id);
            ODS_DocumentUploadController.ValidateAttachmentName('Design');
            test.stopTest();  
        }
    }
    
   
 }