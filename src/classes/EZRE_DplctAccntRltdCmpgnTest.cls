/**
 * @author           Shahida K
 * @version          1.0 
 * @date             28-Jun-2015
 * @Status           Developed
 * @description     Test class to test EZRE_DplctAccntRltdCmpgn trigger functionality.
 *                   
 */
 @isTest
public class EZRE_DplctAccntRltdCmpgnTest
{
    ///<OBJECTIVE>
    ///Method to throws error messge when Account Related campign record inserted with duplicate value in campaign field 
    ///</OBJECTIVE>
    static testmethod void  restrictDuplicateCampaign_InsertPositive()
    {
         //Insert Account Record
          Account accountObj=EZRE_DataFactory_Test_Utl.createAccnt('TestAccount','TestWebSite.com');
        
        Test.startTest();
         try
            {
               //Insert Account Related Campaign Records
                Account_Related_Campaign__c  AccntRltdCmpgnObj1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(accountObj.Id,'1: Calling','ODS AWS','','');
                Account_Related_Campaign__c  AccntRltdCmpgnObj2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(accountObj.Id,'2b: Connected - More Info','ODS AWS','','');
                
            }
            catch(Exception ex)
            {                
                System.Assert(ex.getMessage().contains('Duplicate Campaign:'));
            }
         Test.stopTest();
 
    }
     ///<OBJECTIVE>
     ///Method to test Account Related campign record insertion  without duplicate in campaign field
    ///</OBJECTIVE>
    static testmethod void  restrictDuplicateCampaign_InsertNegative()
    {
           //Insert Account Records 
           Account accountObj1=EZRE_DataFactory_Test_Utl.createAccnt('TestAccount1','TestWebSite.com');
           Account accountObj2=EZRE_DataFactory_Test_Utl.createAccnt('TestAccount2','TestWebSite.com');
        
        Test.startTest();
                //Insert Account Related Campaign Records
                Account_Related_Campaign__c  AccntRltdCmpgnObj1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(accountObj1.Id,'1: Calling','ODS AWS','','');
                Account_Related_Campaign__c  AccntRltdCmpgnObj2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(accountObj1.Id,'1: Calling','','','');
                            
         Test.stopTest();
          list<Account_Related_Campaign__c>   AccntRltdCmpgnLst=[select id,Campaign__c from Account_Related_Campaign__c where account__c=:accountObj1.Id];
          system.AssertNotEquals(AccntRltdCmpgnLst[0].Campaign__c,AccntRltdCmpgnLst[1].Campaign__c);
 
    }
    ///<OBJECTIVE>
    ///Method to throws error messge when Account Related campign record update with duplicate value in campaign field 
    ///</OBJECTIVE>
    static testmethod void  restrictDuplicateCampaign_UpdatePositive()
    {
         //Insert Account Record
          Account accountObj=EZRE_DataFactory_Test_Utl.createAccnt('TestAccount','TestWebSite.com');
        
        Test.startTest();
        try
         {
               //Insert Account Related Campaign Records
                Account_Related_Campaign__c  AccntRltdCmpgnObj1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(accountObj.Id,'1: Calling','ODS AWS','','');
                
                 Account_Related_Campaign__c  AccntRltdCmpgnObj2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(accountObj.Id,'1: Calling','Title Insurance','','');
                
                
                list<Account_Related_Campaign__c>   AccntRltdCmpgnLst=[select id,Campaign__c from Account_Related_Campaign__c where id=:AccntRltdCmpgnObj1.Id];
                
                Account_Related_Campaign__c AccntRltdCmpgnObj3=new Account_Related_Campaign__c();
                AccntRltdCmpgnObj3.Id=AccntRltdCmpgnLst[0].Id;
                AccntRltdCmpgnObj3.Campaign__c='Title Insurance';
                update AccntRltdCmpgnObj3;
                
           }
            catch(Exception ex)
           {                
               System.Assert(ex.getMessage().contains('Duplicate Campaign:'));
           }
         Test.stopTest();
 
    }
    ///<OBJECTIVE>
     ///Method to test Account Related campign record update without duplicate in campaign field
    ///</OBJECTIVE>
    static testmethod void  restrictDuplicateCampaign_UpdateNegative()
    {
           //Insert Account Records 
           Account accountObj1=EZRE_DataFactory_Test_Utl.createAccnt('TestAccount1','TestWebSite.com');
           Account accountObj2=EZRE_DataFactory_Test_Utl.createAccnt('TestAccount2','TestWebSite.com');
        
        Test.startTest();
                //Insert Account Related Campaign Records
                Account_Related_Campaign__c  AccntRltdCmpgnObj1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(accountObj1.Id,'1: Calling','ODS AWS','','');
                
                 Account_Related_Campaign__c   AccntRltdCmpgnObj2=new Account_Related_Campaign__c();
                AccntRltdCmpgnObj2.Id=AccntRltdCmpgnObj1.Id;
                AccntRltdCmpgnObj2.Campaign__c='Title Insurance';
                update AccntRltdCmpgnObj2;
                            
         Test.stopTest();
          list<Account_Related_Campaign__c>   AccntRltdCmpgnLst=[select id,Campaign__c from Account_Related_Campaign__c where account__c=:accountObj1.Id];
          system.AssertNotEquals(AccntRltdCmpgnLst[0].Campaign__c,'ODS AWS');
 
    }
    
}