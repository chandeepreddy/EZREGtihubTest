/**
 * @author           Gangadhar
 * @version          1.0 
 * @date             28/03/2016
 * @Status           Developed
 * @description      Test class to test functionlity of EZRE_InsideSalesDailyWorkAllocation.
 *
 */
 @isTest
 public class EZRE_InsideSalesDailyWorkAllocation_Test
 {
    ///<OBJECTIVE> 
     //Method to test ISR work allocation class functionality with SelectedFilter value as 'None'
     ///<OBJECTIVE> 
     public static testmethod void WorkAllocation_Positive_Test()
     {
          profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
          user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                      'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                      '9988776655',True,'Force.com');
                                                        
        system.runAs(usr)
        {
           //Call list allocation custom Setting Insert                                              
           Call_List_Allocation__c  objCallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');                                            
          
           //Insert account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
            
            //Insert account 
            Account acc1 =EZRE_DataFactory_Test_Utl.createAccnt('testaccount','www.abc.com');
           
           
            //Insert work allocation 
            Work_Allocation__c wrkAllc=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
            //Insert work allocation 
            Work_Allocation__c wrkAll=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            Test.startTest();
            
            EZRE_InsideSalesDailyWorkAllocation obj = new EZRE_InsideSalesDailyWorkAllocation();
            obj.SelectedFilter = 'None';
            obj.filterAccounts();
            obj.exportToExcel();
            
            Test.stopTest();
            system.assertEquals(obj.acctsLst.size(),0);
       }
 
     }
     ///<OBJECTIVE> 
     //Method to test ISR work allocation class functionality with filter condition values SelectedFilter as 'true' and SelectedRepName as 'None'
     ///<OBJECTIVE> 
     public static testmethod void WorkAllocation_Negative_Test()
     {
           profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
           user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                    'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                        '9988776655',True,'Force.com');
            system.runAs(usr)
        {
           //Call list allocation custom Setting Insert                                              
            Call_List_Allocation__c  objCallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');
           
           //Insert account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
            
            //Insert account 
            Account acc1 =EZRE_DataFactory_Test_Utl.createAccnt('testaccount','www.abc.com');
           
            //Insert work allocation 
            Work_Allocation__c wrkAllc=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
            //Insert work allocation 
            Work_Allocation__c wrkAll=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
            Test.startTest();
            
            EZRE_InsideSalesDailyWorkAllocation obj = new EZRE_InsideSalesDailyWorkAllocation();
            obj.SelectedFilter = 'true';
            obj.SelectedRepName = 'None';
            obj.filterAccounts();
            obj.exportToExcel();
            
            Test.stopTest();
            
            system.assertEquals(obj.acctsLst.size(),0);
       }
 
     }
     ///<OBJECTIVE> 
     //Method to test ISR work allocation Excel class functionality with filter condition values SelectedFilter as 'true' and SelectedRepName as 'None'
     ///<OBJECTIVE> 
     public static testmethod void WorkAllocationtoExcel_Positive_Test()
     {
           //Insert account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
            
            //Insert account 
            Account acc1 =EZRE_DataFactory_Test_Utl.createAccnt('testaccount','www.abc.com');
           
          
            //Insert work allocation 
            Work_Allocation__c wrkAllc=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
            //Insert work allocation 
            Work_Allocation__c wrkAll=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
             System.currentPageReference().getParameters().put('Filter','None');
             
             System.currentPageReference().getParameters().put('RepName','Sen Poulami');
             
            Test.startTest();
            
            EZRE_InsideSalesDailyWorkAllocationExcel obj = new EZRE_InsideSalesDailyWorkAllocationExcel();
            obj.UserCampaign='shahida';
            obj.SelectedFilter='true';
            
            obj.ContactListforRepExcel();
              Test.stopTest();
            system.assertEquals(obj.acctsLst.size(),0);      
     }
     ///<OBJECTIVE> 
     //Method to test ISR work allocation Excel class functionality with filter condition SelectedTimeZone as 'CST'
     ///<OBJECTIVE> 
      public static testmethod void WorkAllocationtoExcel_Negative_Test()
     {
           //Insert account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
            
            //Insert account 
            Account acc1 =EZRE_DataFactory_Test_Utl.createAccnt('testaccount','www.abc.com');
           
          
            //Insert work allocation 
            Work_Allocation__c wrkAllc=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
            //Insert work allocation 
            Work_Allocation__c wrkAll=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
             System.currentPageReference().getParameters().put('Filter','None');
             
             System.currentPageReference().getParameters().put('RepName','Sen Poulami');
             Test.startTest();
             
            EZRE_InsideSalesDailyWorkAllocationExcel obj = new EZRE_InsideSalesDailyWorkAllocationExcel();
            obj.SelectedRepName='None';
            obj.SelectedTimeZone='CST';
            obj.UserCampaign='shahida';
            obj.SelectedFilter='true';
            
            obj.ContactListforRepExcel();
           Test.stopTest();
            system.assertEquals(obj.acctsLst.size(),0);      
     }
      ///<OBJECTIVE> 
     //Method to test ISR work allocation Excel class functionality with filter condition SelectedTimeZone as 'CST'
     ///<OBJECTIVE> 
     public static testmethod void WorkAllocationtoExcelWithoutTimeZone_Test()
     {
           //Insert account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
            
            //Insert account 
            Account acc1 =EZRE_DataFactory_Test_Utl.createAccnt('testaccount','www.abc.com');
           
          
            //Insert work allocation 
            Work_Allocation__c wrkAllc=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
            //Insert work allocation 
            Work_Allocation__c wrkAll=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',acc.Id,true);
            
             System.currentPageReference().getParameters().put('Filter','None');
             
             System.currentPageReference().getParameters().put('RepName','Sen Poulami');
             
              Test.startTest();
              
            EZRE_InsideSalesDailyWorkAllocationExcel obj = new EZRE_InsideSalesDailyWorkAllocationExcel();

            obj.SelectedRepName='None';         
            obj.UserCampaign='shahida';
            obj.SelectedFilter='true';
            obj.SelectedTimeZone='null';
            obj.ContactListforRepExcel();
            Test.stopTest();
            System.assertEquals(obj.acctsLst.size(),0);      
     }
 }