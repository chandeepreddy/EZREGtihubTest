/**
 * @author           Krishnaveni A
 * @date             05/08/2017
 * @Status           Developed
 */
@isTest
 Public class EZRE_ContactActivityDateUpdate_Test
 {
    
 ///<OBJECTIVE> 
 //Method to insert Task
 ///<OBJECTIVE>
  
    public static testmethod void ContactTaskInsert_Test()
     {
            
            profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
            user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                              'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                              '9988776655',True,'Force.com');
                                                             
           system.runAs(usr)
           {
             //Insert account
             Account account = EZRE_DataFactory_Test_Utl.createAccnt('ABC',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com','Suspect');
             
             // Insert Contact
             Contact contact=EZRE_DataFactory_Test_Utl.createSfdcContact('test LastName',account .id,true,'1: Calling');
           
             // Insert Work Allocation
             Work_Allocation__c workallocation=EZRE_DataFactory_Test_Utl.createWorkalloc('Test work',account .id,true);  
           
             // Insert Task
             Task task=EZRE_Data_Utility.createTask('Subject',account.id,contact.id,'Completed','High');
             system.assertEquals(task.Status,'Completed');
              
           }
    }
    
     public static testmethod void AccountTaskInsert_Test()
     {
        
            profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
            user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                              'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                              '9988776655',True,'Force.com');
                                                            
            system.runAs(usr)
            {
               //Insert account
               Account account1 = EZRE_DataFactory_Test_Utl.createAccnt('ABC',100,true,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com','Suspect');
                    
               // Insert Task
               Task task1=EZRE_Data_Utility.createAccountTask('Subject',account1.id,'Completed','High');
               system.assertEquals(task1.Subject,'Subject');
            }
      }
     public static testmethod void InsertTaskUnderLead_Test()
     {
        
            profile profile = EZRE_DataFactory_Test_Utl.getParticularProfile('System Administrator');
            user usr =  EZRE_DataFactory_Test_Utl.CreateUserWithCampaign('TUsr','testemail@testmail.com','UTF-8','Poulami', 'Sen','en_US',
                                                                              'en_US',profile.Id,'America/Los_Angeles','username123@testmail.com',
                                                                              '9988776655',True,'Force.com');
                                                            
            system.runAs(usr)
            {
               //Insert lead
               Lead leadRecord = EZRE_DataFactory_Test_Utl.insertLead('Jhon','Harm','Calling','Prelude');
                    
               // Insert Task
               Task task=EZRE_DataFactory_Test_Utl.createTask('Subject',leadRecord.Id,'Not Started','High');      
               system.assertEquals(task.Subject,'Subject');
            }
      }
      //Method to test sentiment score is updated based on comments 
      public static testmethod void Task_Test() {
       // Insert Task
       Task objTask = EZRE_DataFactory_Test_Utl.createTask('ODS Call 1', 'I Like Algorithmia');      
       system.assertEquals(objTask.Subject,'ODS Call 1');
       // Update Task
       Task objTask2 = new Task(Id = objTask.id);
       objTask2.Description = 'I dont like Algorithmia';
       update objTask2;     
       system.assertEquals(objTask2.Description,'I dont like Algorithmia');
    }
    
 }