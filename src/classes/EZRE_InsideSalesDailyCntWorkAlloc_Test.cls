/**
 * @author           Krishnaveni 
 * @version          1.0 
 * @date             28/04/2017
 * @Status           Developed
 * @description      Test class to test functionlity of EZRE_InsideSalesDailyCntWorkAllocation.
 *
 */
 @isTest
     public class EZRE_InsideSalesDailyCntWorkAlloc_Test
         {
            ///<OBJECTIVE> 
             //Method to test 
             ///<OBJECTIVE> 
     public static testmethod void WorkAllocation_PositiveTest1()
         {
              profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
              user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                          'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                          '9988776655',True,'Force.com');
                                                        
              system.runAs(usr)
                {
                   //Call list allocation custom Setting Insert                                              
                   Call_List_Allocation__c  CallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');                                            
                  
                   //Account Call list allocation custom Setting Insert                                              
                   Account_Call_List_Allocation__c AccCallListalloction= EZRE_DataFactory_Test_Utl.createAccCallListAlloc('Force.com');                                            
                  
                  //Contact Call list allocation custom Setting Insert                                              
                  Contact_Call_List_Allocation__c ContCallListalloction= EZRE_DataFactory_Test_Utl.createContCallListAlloc('Force.com');  
                  
                  //Insert account
                    Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                    
                  //Insert work allocation 
                        Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                        Test.startTest();
                        EZRE_InsideSalesDailycntWorkAllocation cntworkallocation = new EZRE_InsideSalesDailycntWorkAllocation ();
                        cntworkallocation .SelectedRepName= 'Shahida'; 
                        cntworkallocation .SelectedTimeZone= 'CST';
                        cntworkallocation .SelectedFilter = 'true';
                        cntworkallocation .filterAccounts();
                        //cntworkallocation .exportToExcel();
                        
                        
                        
                        Test.stopTest();
                        System.assertEquals(cntworkallocation .acctsLst.size(),0);  
                        
                            
                  
               }
         
         }
     
             ///<OBJECTIVE> 
             //Method to test 
             ///<OBJECTIVE> 
                 public static testmethod void WorkAllocation_PositiveTest2()
                     {
                          profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
                          user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                                      'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                                      '9988776655',True,'Force.com');
                                                                        
                          system.runAs(usr)
                            {
                               //Call list allocation custom Setting Insert                                              
                               Call_List_Allocation__c  CallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');                                            
                              
                              //Account Call list allocation custom Setting Insert                                              
                               Account_Call_List_Allocation__c AccCallListalloction= EZRE_DataFactory_Test_Utl.createAccCallListAlloc('Force.com');                                            
                              
                              //Contact Call list allocation custom Setting Insert                                              
                              Contact_Call_List_Allocation__c ContCallListalloction= EZRE_DataFactory_Test_Utl.createContCallListAlloc('Force.com');  
                              
                              //Insert account
                                Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                                
                             //Insert work allocation 
                                Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                                Test.startTest();
                                EZRE_InsideSalesDailycntWorkAllocation cntworkallocation = new EZRE_InsideSalesDailycntWorkAllocation ();
                                cntworkallocation .SelectedTimeZone= 'CST';
                                cntworkallocation .SelectedFilter='true';
                                cntworkallocation .filterAccounts();
                                //cntworkallocation .exportToExcel();
                                
            
                                Test.stopTest();
                                System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                              
                           }
                     
                     }
           
            ///<OBJECTIVE> 
            //Method to test 
            ///<OBJECTIVE> 
                 public static testmethod void WorkAllocation_PositiveTest3()
                     {
                          profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
                          user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                                      'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                                      '9988776655',True,'Force.com');
                                                                            
                          system.runAs(usr)
                            {
                               //Call list allocation custom Setting Insert                                              
                               Call_List_Allocation__c  CallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');                                            
                              
                               //Account Call list allocation custom Setting Insert                                              
                               Account_Call_List_Allocation__c AccCallListalloction= EZRE_DataFactory_Test_Utl.createAccCallListAlloc('Force.com');  
                              
                               //Contact Call list allocation custom Setting Insert                                              
                               Contact_Call_List_Allocation__c ContCallListalloction= EZRE_DataFactory_Test_Utl.createContCallListAlloc('Force.com');  
                              
                               //Insert account
                               Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                              
                               //Insert work allocation 
                                Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                                Test.startTest();
                                EZRE_InsideSalesDailycntWorkAllocation cntworkallocation = new EZRE_InsideSalesDailycntWorkAllocation ();
                                cntworkallocation .SelectedFilter = 'true';
                                cntworkallocation .filterAccounts();
                                //cntworkallocation .exportToExcel();
                                
                                            
                                Test.stopTest();
                                System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                              
                           }
                     
                         }
              ///<OBJECTIVE> 
             //Method to test 
             ///<OBJECTIVE> 
                 public static testmethod void WorkAllocation_NegativeTest()
                     {
                          profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
                          user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                                      'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                                      '9988776655',True,'Force.com');
                                                                        
                          system.runAs(usr)
                            {
                               //Call list allocation custom Setting Insert                                              
                               Call_List_Allocation__c  CallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');                                            
                              
                               //Account Call list allocation custom Setting Insert                                              
                               Account_Call_List_Allocation__c AccCallListalloction= EZRE_DataFactory_Test_Utl.createAccCallListAlloc('Force.com');  
                              
                               //Contact Call list allocation custom Setting Insert                                              
                               Contact_Call_List_Allocation__c ContCallListalloction= EZRE_DataFactory_Test_Utl.createContCallListAlloc('Force.com');  
                              
                               //Insert account
                                Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                                
                               //Insert work allocation 
                                Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                                Test.startTest();
                                EZRE_InsideSalesDailycntWorkAllocation cntworkallocation = new EZRE_InsideSalesDailycntWorkAllocation ();
                                cntworkallocation .SelectedRepName='None';
                                cntworkallocation .SelectedTimeZone='null';
                                cntworkallocation .SelectedFilter ='Called';
                                cntworkallocation .filterAccounts();
                                //cntworkallocation .exportToExcel();
                                Test.stopTest();
                                System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                              
                            }
                     
                     }
                 
             ///<OBJECTIVE> 
             //Method to test 
             ///<OBJECTIVE> 
                 public static testmethod void SelectedTimeZoneNone_Test()
                     {
                          profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
                          user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                                      'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                                      '9988776655',True,'Force.com');
                                                                        
                          system.runAs(usr)
                            {
                               //Call list allocation custom Setting Insert                                              
                               Call_List_Allocation__c  CallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');                                            
                              
                               //Account Call list allocation custom Setting Insert                                              
                               Account_Call_List_Allocation__c AccCallListalloction= EZRE_DataFactory_Test_Utl.createAccCallListAlloc('Force.com');  
                              
                               //Contact Call list allocation custom Setting Insert                                              
                               Contact_Call_List_Allocation__c ContCallListalloction= EZRE_DataFactory_Test_Utl.createContCallListAlloc('Force.com');  
                              
                               //Insert account
                                Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                                
                               //Insert work allocation 
                               Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                               Test.startTest();
                               EZRE_InsideSalesDailycntWorkAllocation cntworkallocation = new EZRE_InsideSalesDailycntWorkAllocation ();
                               cntworkallocation .SelectedTimeZone='null';
                               cntworkallocation .SelectedFilter = 'true';
                               cntworkallocation .filterAccounts();
                               //cntworkallocation .exportToExcel();
                               Test.stopTest();
                               System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                              
                           }
             
                     }
                 
              ///<OBJECTIVE> 
             //Method to test 
             ///<OBJECTIVE> 
                 public static testmethod void SelectedRepNameNone_Test()
                     {
                          profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
                          user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                                      'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                                      '9988776655',True,'Force.com');
                                                                        
                          system.runAs(usr)
                            {
                               //Call list allocation custom Setting Insert                                              
                               Call_List_Allocation__c  CallListAllocation = EZRE_DataFactory_Test_Utl.createCallListAllocSettings('Force.com','Sen Poulami,Bhaskaran Thangaraj');                                            
                              
                               //Account Call list allocation custom Setting Insert                                              
                               Account_Call_List_Allocation__c AccCallListalloction= EZRE_DataFactory_Test_Utl.createAccCallListAlloc('Force.com');  
                              
                               //Contact Call list allocation custom Setting Insert                                              
                               Contact_Call_List_Allocation__c ContCallListalloction= EZRE_DataFactory_Test_Utl.createContCallListAlloc('Force.com');  
                              
                               //Insert account
                                Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                                
                                //Insert work allocation 
                                Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                                
                                Test.startTest();
                                EZRE_InsideSalesDailycntWorkAllocation cntworkallocation = new EZRE_InsideSalesDailycntWorkAllocation ();
                                cntworkallocation .SelectedRepName='None';
                                cntworkallocation .SelectedFilter = 'true';
                                cntworkallocation .SelectedTimeZone='CST';
                                cntworkallocation .filterAccounts();
                                //cntworkallocation .exportToExcel();
                                Test.stopTest();
                                System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                              
                           }
                     
                    }
       
       
              ///<OBJECTIVE> 
             //Method to test 
             ///<OBJECTIVE> 
                 public static testmethod void UserCampaign_Test()
                 
                    {                                      
                      
                       //Insert account
                        Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                        
                       
                        //Insert work allocation 
                        Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                        
                        System.currentPageReference().getParameters().put('Filter','None');
                        System.currentPageReference().getParameters().put('RepName','Sen Poulami');
                        
                        Test.startTest();
                        EZRE_InsideSalesDailyWorkAllocationExcel cntworkallocation = new EZRE_InsideSalesDailyWorkAllocationExcel();
                        cntworkallocation.UserCampaign='shahida';
                        cntworkallocation.SelectedFilter='true';
                        cntworkallocation .SelectedTimeZone='null';
                        cntworkallocation.ContactListforRepExcel();
                        Test.stopTest();
                        System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                      
                   }
         ///<OBJECTIVE> 
         //Method to test 
         ///<OBJECTIVE> 
             public static testmethod void SelectedFilter_Test()
               {  
                   
                   //Insert account
                    Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                    
                    //Insert work allocation 
                    Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                    
                    System.currentPageReference().getParameters().put('Filter','None');
                    System.currentPageReference().getParameters().put('RepName','Sen Poulami');
                    
                    Test.startTest();
                    EZRE_InsideSalesDailyWorkAllocationExcel cntworkallocation = new EZRE_InsideSalesDailyWorkAllocationExcel();
                    cntworkallocation .SelectedRepName='None';
                    cntworkallocation .SelectedTimeZone='CST';
                    cntworkallocation .UserCampaign='shahida';
                    cntworkallocation .SelectedFilter='true';
                    cntworkallocation .ContactListforRepExcel();
                    Test.stopTest();
                    System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                  
               }
             
         ///<OBJECTIVE> 
          //Method to test 
          ///<OBJECTIVE> 
             public static testmethod void UserCampaignandTimeZonenull_Test()
                 {  
                   
                   //Insert account
                   Account account = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
                    
                   //Insert work allocation 
                    Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Sen Poulami',account .Id,true);
                    
                    System.currentPageReference().getParameters().put('Filter','None');
                    System.currentPageReference().getParameters().put('RepName','Sen Poulami');
                    
                    Test.startTest();
                    EZRE_InsideSalesDailyWorkAllocationExcel cntworkallocation = new EZRE_InsideSalesDailyWorkAllocationExcel();
                    cntworkallocation .SelectedRepName='None';         
                    cntworkallocation .UserCampaign='shahida';
                    cntworkallocation .SelectedFilter='true';
                    cntworkallocation .SelectedTimeZone= null;
                    cntworkallocation .ContactListforRepExcel();
                    Test.stopTest();
                    System.assertEquals(cntworkallocation .acctsLst.size(),0);      
                  
               }
             
         }