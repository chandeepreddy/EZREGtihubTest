/**
 * @author           Gangadhar R
 * @version          1.0 
 * @date             03-Jun-2017
 * @Status           Developed
 * @description      This is the Test class for TrashPage controller
 */

@isTest
public class ODS_TrashPageController_Test
{
    /// <OBJECTIVE>
    /// To test the Documents fetch with filter conditions
    /// </OBJECTIVE>
    static testMethod void FetchRestoreDocumentsList_PositiveTest()
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
             Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id,true);
            
             test.startTest();
             ODS_TrashPageController trashController = new ODS_TrashPageController();
             trashController.AccountId = account.Id;
             trashController.ServiceId = odsServices.Id;
             trashController.DocumentId = documents.Id;
             trashController.RestoreDeletedDocument();
             test.stopTest();   
          }  
            
    }
    
     /// <OBJECTIVE>
    /// To test the Documents fetch with Is Delete conditions
    /// </OBJECTIVE>
    static testMethod void FetchDeletedDocumentsList_PositiveTest()
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
             Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id,true);
            
             test.startTest();
             ODS_TrashPageController trashController = new ODS_TrashPageController();
             trashController.AccountId = account.Id;
             trashController.ServiceId = odsServices.Id;
             
             trashController.GetDeletedDocuments();
            
             trashController.RedirectToDocumentsUpload();
             test.stopTest();   
          } 
     }    
     
     /// <OBJECTIVE>
    /// To test the Documents fetch with Is Delete conditions
    /// </OBJECTIVE>
    static testMethod void DeleteSelectedDocument_PositiveTest()
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
             Documents__c documents = ODS_DataFactory_Test_Utility.InsertDocuments('Estimation','SRS',4,'ODS Customer Portal',account.id,account.id, odsServices.id,true);
            
             test.startTest();
             ODS_TrashPageController trashController = new ODS_TrashPageController();
             trashController.AccountId = account.Id;
             trashController.ServiceId = odsServices.Id;
             trashController.DocumentId = documents.Id;
             
             trashController.DeleteTrashDocument();
             trashController.showPrevious();
             trashController.showNext();
              trashController.showFirst();
              trashController.showLast();
             test.stopTest();   
          } 
     }  

}