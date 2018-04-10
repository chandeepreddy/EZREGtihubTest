/**
 * @author           Gangadhar
 * @version          1.0 
 * @date             28/03/2016
 * @Status           Developed
 * @description      Test class to test functionlity of EZRE_ActivityContactUpdate trigger.
 *
 */
 @isTest
 public class EZRE_ActivityContactUpdate_Test
 {
     public static testmethod void activityContactUpdat_Test()
     {
           //Insert account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
            
            //Insert account 
            Account acc1 =EZRE_DataFactory_Test_Utl.createAccnt('testaccount','www.abc.com');
           
            //Insert contact 
            contact Con =EZRE_DataFactory_Test_Utl.createSfdcContact('TestContact',acc.Id,true,'1a: Calling');
                       
            //Insert contact
            contact Con1 = EZRE_DataFactory_Test_Utl.createSfdcContact('TestNewContact',acc1.Id,true,'1a: Calling');
            //Insert work allocation 
            Work_Allocation__c wrkAllc=EZRE_DataFactory_Test_Utl.createWorkalloc('testWorkAlloc',acc.Id,false);
            
            //Insert work allocation 
            Work_Allocation__c wrkAll=EZRE_DataFactory_Test_Utl.createWorkalloc('testWorkAlloc',acc.Id,false);
            
            //Insert Task 
            Task act = EZRE_DataFactory_Test_Utl.createTasks('Connect(new)',Con.id,'testSTatus','testPriority',Date.Today());
            Work_Allocation__c wrkAllct =EZRE_DataFactory_Test_Utl.fetchWorkAllocation(wrkAllc.Id);
         
       
 
     }
    
 }