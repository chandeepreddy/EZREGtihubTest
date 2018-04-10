/**
*@author        Shahida K
*@version       1.0
*@createdDate   16/03/2016
*@status        developed
*@description   Test class to test meeting set date update functionality
*/
@isTest
public class EZRE_MeetingSetDate_Test
{
     ///<OBJECTIVE>
     ///Method to test that when contact inserted with status '3: Meeting Set' meeting set date value.
     ///</OBJECTIVE>
     static testmethod void MeetingSetDateUpdate_AfterInsertPositive_Test()
     {
         //Insert contact with status '3: Meeting Set'
         Contact contactRec=EZRE_DataFactory_Test_Utl.createContact('testFirstName','testLastName','9999999999','testTitle','testEmail@test.com','3: Meeting Set');
         system.assertEquals(contactRec.Meeting_Set_Date__c,contactRec.LastmodifiedDate);
     
     }
     ///<OBJECTIVE>
     ///Method to test that when contact inserted with status other than '3: Meeting Set' meeting set date value.
     ///</OBJECTIVE>
     static testmethod void MeetingSetDateUpdate_AfterInsertNegative_Test()
     {
         //Insert contact with status other than '3: Meeting Set'
         Contact contactRec=EZRE_DataFactory_Test_Utl.createContact('testFirstName','testLastName','9999999999','testTitle','testEmail@test.com','testStatus');
         system.assertEquals(contactRec.Meeting_Set_Date__c,null);
     
     }
     ///<OBJECTIVE>
     ///Method to test that when contact Updating with status '3: Meeting Set' meeting set date value.
     ///</OBJECTIVE>
     static testmethod void MeetingSetDateUpdate_AfterUpdatePositive_Test()
     {
        //Insert contact with status 'calling'
        Contact contactRec=EZRE_DataFactory_Test_Utl.createContact('testFirstName','testLastName','9999999999','testTitle','testEmail@test.com','calling');
        //Update contact with '3: Meeting Set'
        Contact contactRecord=EZRE_DataFactory_Test_Utl.updateContact(contactRec.Id,'3: Meeting Set');  
        system.assertEquals(contactRecord.Meeting_Set_Date__c,contactRecord.LastmodifiedDate);
     }
     ///<OBJECTIVE>
     ///Method to test that when contact Updating with status other than '3: Meeting Set' meeting set date value.
     ///</OBJECTIVE>
     static testmethod void MeetingSetDateUpdate_AfterUpdateNegative_Test()
     {
     
        //Insert contact with status 'calling'
        Contact contactRec=EZRE_DataFactory_Test_Utl.createContact('testFirstName','testLastName','9999999999','testTitle','testEmail@test.com','calling');
        //Update contact with status other than '3: Meeting Set'
        Contact contactRecord=EZRE_DataFactory_Test_Utl.updateContact(contactRec.Id,'teststatus');  
        system.assertEquals(contactRecord.Meeting_Set_Date__c,null);
     }
 
 
}