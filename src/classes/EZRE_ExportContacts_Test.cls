/**
 * @author           Shahida
 * @version          1.0 
 * @date             22/12/2015
 * @Status           Developed
 * @description      Test class to Export Contacts funtionality
 *
 */
 @isTest
 public class EZRE_ExportContacts_Test
 {
    //<OBJECTIVE>
    //Test method to test export funtionaity
     static testmethod void ExportContactsTest()
     {
      //insert account
      Account acc=new Account();         
      acc=EZRE_DataFactory_Test_Utl.createAccnt('TestAccount','www.testsite.com');
      //create contact
      Contact objCon=new Contact();
      objCon=EZRE_DataFactory_Test_Utl.createContact('TestFirstName','TestLastName',acc.Id,
                                                      '9636963696','Test Tiltle',
                                                      'mytestmail@gmail.com',true,
                                                      '1: Calling'
                                                      ,false,'1: Calling',
                                                       false,'1: Calling','test');
      datetime lastExportedDate= datetime.newInstance(2018, 03, 15);    
      EZRE_ExportContactsDate__c objExCon=EZRE_DataFactory_Test_Utl.insertExportContactsDate('TestName',lastExportedDate);     
      EZRE_ExportContactController objExpCont=new EZRE_ExportContactController();      
      objExpCont.getContacts();
    
     }
 }