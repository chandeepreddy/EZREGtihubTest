@isTest
 public class EZRE_ContactDailyCallListAllocation_Test
 {   
     ///<OBJECTIVE> 
     //Method to test forcedotcom campaign records 
     ///<OBJECTIVE>
     public static testmethod void forceDotcom_Test()
     {
      
      //Insert Account Call List Allocation 
      Account_Call_List_Allocation__c accountCallListAllocation=EZRE_DataFactory_Test_Utl.createaccountcallListAlloc('Force.com',10000,'Force_com__c','Sen Poulami','1: Calling',10,'Inside_SalesRep__c','Force_com_Account_Status__c','Mobile Correct','1: Calling','Status__c');
     
      //Insert account
      Account acc = EZRE_DataFactory_Test_Utl.createAccnt('ABC',10000,true,'Sen Poulami','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com','Suspect');
        
      //Insert Contact
      Contact contact=EZRE_DataFactory_Test_Utl.createcontact('test','test1@test.com','1: Calling',acc.id,true,false,'1: Calling');
          
      //Insert Contact
      Contact contact1=EZRE_DataFactory_Test_Utl.createcontact('test1','test2@test.com','1: Calling',acc.id,true,false,'1: Calling');
         
       
      Test.StartTest();
      
      EZRE_ContactDailyCallListAllocation dailyCallListAllocation = new EZRE_ContactDailyCallListAllocation();
      dailyCallListAllocation.execute();

      Test.stopTest();
      system.assertEquals(acc.force_com__c ,true);
         
     }
     
     ///<OBJECTIVE> 
     //Method to test ODS AWS campaign records 
     ///<OBJECTIVE>
     public static testmethod void ODSAWSCampaign_test()
     {
      
      //Insert Account Call List Allocation 
      Account_Call_List_Allocation__c accountCallListAllocation=EZRE_DataFactory_Test_Utl.createaccountcallListAlloc('ODS AWS',10000,'ODS_AWS__c','Sen Poulami','1: Calling',10,'ODS_AWS_Inside_SalesRep__c','ODS_AWS_Account_Status__c','Mobile Correct','1: Calling','ODS_AWS_Status__c');
     
      //Insert account
      Account acc = EZRE_DataFactory_Test_Utl.createAccnt('ABC',10000,false,'Sen Poulami','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com','Suspect');
        
      //Insert Contact
      Contact contact=EZRE_DataFactory_Test_Utl.createcontact('test','test1@test.com','1: Calling',acc.id,false,true,'1: Calling');
          
      //Insert Contact
      Contact contact1=EZRE_DataFactory_Test_Utl.createcontact('test1','test2@test.com','1: Calling',acc.id,false,true,'1: Calling');
         
       
      Test.StartTest();
      
      EZRE_ContactDailyCallListAllocation dailyCallListAllocation = new EZRE_ContactDailyCallListAllocation();
      dailyCallListAllocation.execute();

      Test.stopTest();
         
     }
    
     
}