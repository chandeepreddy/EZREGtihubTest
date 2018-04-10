/**
 * @author           Kirankumar
 * @version          1.0 
 * @date             02-May-2017
 * @Status           Developed
 * @description      Test class for EZRE_AssignCampaignWorkAllocation Trigger
 *
 */
@isTest
public class EZRE_AssignCampaignWorkAllocation_Test
{
    public static testMethod void insertForceDotComWrkAllocation_Test()
    {
    
         //Insert account
         Account acc = EZRE_DataFactory_Test_Utl.createAccnt('ABC',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com','Suspect');
        
        //Insert Contact
        Contact contact=EZRE_DataFactory_Test_Utl.createcontact('test','test1@test.com','1:Calling',acc.id,true,false,'2d: Call later');
        
        test.startTest();
        Work_Allocation__c wrkAlction = new Work_Allocation__c();
        wrkAlction.Name = 'Sen Poulami';
        wrkAlction.Contact__c = contact.Id;
        insert wrkAlction;
        test.stopTest();
        system.assertEquals(wrkAlction.Name,'Sen Poulami');
    }
    
    public static testMethod void insertODSAWSWrkAllocation_Test()
    {
    
         //Insert account
         Account acc = EZRE_DataFactory_Test_Utl.createAccnt('ABC',100,false,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com','Suspect');
        
        //Insert Contact
        Contact contact=EZRE_DataFactory_Test_Utl.createcontact('test','test1@test.com','1:Calling',acc.id,false,true,'2d: Call later');
        
        test.startTest();
        Work_Allocation__c wrkAlction = new Work_Allocation__c();
        wrkAlction.Name = 'Sen Poulami';
        wrkAlction.Contact__c = contact.Id;
        insert wrkAlction;
        test.stopTest();
        system.assertEquals(wrkAlction.Name,'Sen Poulami');
    }
}