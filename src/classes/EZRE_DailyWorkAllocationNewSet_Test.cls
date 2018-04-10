/**
 * @author           Gangadhar
 * @version          1.0 
 * @date             28/03/2016
 * @Status           Developed
 * @description      Test class to test functionality of EZRE_InsideSalesDailyWorkAllocation.
 * @Modified By      Shahida K 
 */
 @isTest
 public class EZRE_DailyWorkAllocationNewSet_Test
 {   
     ///<OBJECTIVE> 
     //Method to test existing work allocation object record deletion functionality.
     ///<OBJECTIVE>
     public static testmethod void workAllocation_Delete_Test()
     {
 
         //Insert account
          Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
          
          //Insert Work Allocation
           Work_Allocation__c objWorkAlloc = EZRE_DataFactory_Test_Utl.createWorkalloc('Florence Prem', acc.id, false);
           
          Test.StartTest();
          
          EZRE_DailyWorkAllocationNewSet dailyWorkAllocation = new EZRE_DailyWorkAllocationNewSet();
          dailyWorkAllocation.execute();
          
           Test.stopTest();
           LIST<Work_Allocation__c> wrkAllcLst = EZRE_DataFactory_Test_Utl.fetchWorkAlloc();
           //system.assertEquals(0, wrkAllcLst.size()); 
     } 
     ///<OBJECTIVE> 
     //Method to test ISR work allocation for ODS AWS Account Related Campaigns.
     ///<OBJECTIVE>
     public static testmethod void odsAWAWorkAllocation_Positive_Test()
     {
            Test.StartTest();
          
          //Call list allocation custom Setting Insert                                              
           Call_List_Allocation__c  objCallListAllocForce = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com', 'Bhaskaran');   
           Call_List_Allocation__c  objCallListAllocDotNet = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS AWS','Florence Prem'); 
           Call_List_Allocation__c  objCallListAllocKPO = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS .Net','Rajasekar'); 
                     
           //Insert Account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
            
            //Insert Account Related Campaign matched custom setting RepName.
            Account_Related_Campaign__c  accntRltdCmgn=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(acc.Id,'1: Calling','ODS AWS',
                                                                                                      'Updated','Florence Prem');
            EZRE_DailyWorkAllocationNewSet dailyWorkAllocation = new EZRE_DailyWorkAllocationNewSet();
            dailyWorkAllocation.execute();
            
            LIST<Work_Allocation__c> wrkAllcLst = EZRE_DataFactory_Test_Utl.fetchWorkAlloc();
           
           // system.assertEquals(1, wrkAllcLst.size());
            Test.StopTest();
           
     }
      ///<OBJECTIVE> 
     //Method to test ISR work allocation for ODS AWS Account Related Campaigns.
     ///<OBJECTIVE>
     public static testmethod void odsAWAWorkAllocation_Negative_Test()
     {
       
            Test.StartTest();
          
          //Call list allocation custom Setting Insert                                              
           Call_List_Allocation__c  objCallListAllocForce = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com', 'Bhaskaran');   
           Call_List_Allocation__c  objCallListAllocDotNet = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS AWS','Florence Prem'); 
           Call_List_Allocation__c  objCallListAllocKPO = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS .Net','Rajasekar'); 
           
           
           //Insert Account
            Account acc1 = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
            
            //Insert Account
            Account acc2 = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.test.com', 'Suspect'); 
     
            //Insert Account Related Campaign matched custom setting RepName.
            Account_Related_Campaign__c  accntRltdCmgn1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(acc1.Id,'1: Calling','ODS AWS',
                                                                                                      'Updated','Florence Prem');
                                                                                                      
              //Insert Account Related Campaign matched custom setting RepName.
            Account_Related_Campaign__c  accntRltdCmgn2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(acc2.Id,'1: Calling','ODS AWS',
                                                                                                       'Updated','Florence Prem');
             //Insert Account
            Account acc3= EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.testWebSite.com', 'Suspect'); 
     
            //Insert Account Related Campaign matched custom setting RepName.
            Account_Related_Campaign__c  accntRltdCmgn3=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(acc3.Id,'1: Calling','ODS AWS',
                                                                                                      'Updated','Florence Prem');
                                                                                     
            EZRE_DailyWorkAllocationNewSet dailyWorkAllocation = new EZRE_DailyWorkAllocationNewSet();
            dailyWorkAllocation.execute();
            
            LIST<Work_Allocation__c> wrkAllcLst = EZRE_DataFactory_Test_Utl.fetchWorkAlloc();
            //system.assertEquals(1, wrkAllcLst.size());
            Test.StopTest();
           
 }
     ///<OBJECTIVE> 
     //Method to test ISR work allocation functionality with force.com campaign account records
     ///<OBJECTIVE>
     public static testmethod void AccntCmpgnWrkAllctn_FrcDtCmCmpgn_Test()
     {
        
            Test.StartTest();
          
          //Call list allocation custom Setting Insert                                              
           Call_List_Allocation__c  objCallListAllocForce = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com', 'Bhaskaran Thangaraj');   
           Call_List_Allocation__c  objCallListAllocDotNet = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS AWS','Florence Prem'); 
           Call_List_Allocation__c  objCallListAllocKPO = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS .Net','Sen Poulami'); 

           //Insert Account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
 
            EZRE_DailyWorkAllocationNewSet dailyWorkAllocation = new EZRE_DailyWorkAllocationNewSet();
            dailyWorkAllocation.execute();
            
            LIST<Work_Allocation__c> wrkAllcLst = EZRE_DataFactory_Test_Utl.fetchWorkAlloc();
            //system.assertEquals(1, wrkAllcLst.size());
            Test.StopTest();
           
     }
     ///<OBJECTIVE> 
     //Method to test ISR work allocation functionality with ODS .Net campaign account records
     ///<OBJECTIVE>
     public static testmethod void AccntCmpgnWrkAllctn_OdsDtNtCmpgn_Test()
     {
        
            Test.StartTest();
          //Call list allocation custom Setting Insert                                              
           Call_List_Allocation__c  objCallListAllocForce = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com', 'Thangaraj');   
           Call_List_Allocation__c  objCallListAllocDotNet = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS AWS','Florence Prem'); 
           Call_List_Allocation__c  objCallListAllocKPO = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS .Net','Sen Poulami'); 

           //Insert Account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
 
            EZRE_DailyWorkAllocationNewSet dailyWorkAllocation = new EZRE_DailyWorkAllocationNewSet();
            dailyWorkAllocation.execute();
    
            LIST<Work_Allocation__c> wrkAllcLst = EZRE_DataFactory_Test_Utl.fetchWorkAlloc();
            //system.assertEquals(1, wrkAllcLst.size());   
            
            Test.StopTest();
            
     }
         ///<OBJECTIVE> 
     //Method to test ISR work allocation functionality with force.com account records more than Data limit in custom setting
     ///<OBJECTIVE>
     public static testmethod void AccntCmpgnWrkAllctn_Negative_Test()
     {
            Test.StartTest();
          
          //Call list allocation custom Setting Insert                                              
           Call_List_Allocation__c  objCallListAllocForce = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com', 'Bhaskaran Thangaraj');   
           Call_List_Allocation__c  objCallListAllocDotNet = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS AWS','Florence Prem'); 
           Call_List_Allocation__c  objCallListAllocKPO = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('ODS .Net','Sen Poulami'); 
           
           //Insert Account
            Account acc1 = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
             
            //Insert Account
            Account acc2 = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.testWebSite1.com', 'Suspect'); 
            
            //Insert Account
            Account acc3 = EZRE_DataFactory_Test_Utl.createAccnt('test',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.testWebSite2.com', 'Suspect'); 
             
            EZRE_DailyWorkAllocationNewSet dailyWorkAllocation = new EZRE_DailyWorkAllocationNewSet();
            dailyWorkAllocation.execute();
            LIST<Work_Allocation__c> wrkAllcLst = EZRE_DataFactory_Test_Utl.fetchWorkAlloc();
            
            Test.StopTest();
            //system.assertEquals(1, wrkAllcLst.size());
           
           
          
     }

     
 }