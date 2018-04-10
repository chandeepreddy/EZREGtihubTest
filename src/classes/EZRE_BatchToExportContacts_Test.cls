/**
 * @author           Shahida
 * @version          1.0 
 * @date             18/12/2015
 * @Status           Developed
 * @description      Test class to export contacts batch class
 *
 */
 @isTest
 public class EZRE_BatchToExportContacts_Test
 {
    //<OBJECTIVE>
    //Test method to test export funtionaity
     static testmethod void exportContactsTest()
     {
       //create contact
     Contact objCon=new Contact();
     objCon=EZRE_DataFactory_Test_Utl.createContact('TestFirstName','TestLastName','9636963696','Test Tilte','mytestmail@gmail.com','1: Calling');    
     EZRE_BatchToExportContacts objExpCont=new EZRE_BatchToExportContacts();    
     database.executeBatch(objExpCont);
    
     }
 
 
 
 
 }