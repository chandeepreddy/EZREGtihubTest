/**
 * @author           Shahida
 * @version          1.0 
 * @date             27/11/2015
 * @Status           Developed
 * @description      Test class for opportunity email report 
 *
 */
 @isTest
 public class EZRE_OppEmail_Report_Test
 {
 
    ///<OBJECTIVE>
    ///Method to get Opportunities with no activities in the report
    //Method to test opportunity Activity report scheduler method
    //Method to test Opportunity report email method
    ///</OBJECTIVE>
    
    public static testMethod void EZRE_CallScheduleMethod_Test() 
    { 
       
        //insert Account 
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
         
         //Get profile named "Administrator"
        Profile TestProfile=[select id from profile where Name='Administrator'];
        
         //insert user
        User objTestUser= EZRE_OppRprt_DataFactory_Test_Utility.createUser('Alias1','usernametest1@testuserorg.com','UTF-8','TestUser1','en_US', 
                                                                          'en_US', TestProfile.Id,'America/Los_Angeles','usernametest1@testuserorg.com');
       
       
        EZRE_OppEmail_Report objOppEmailRep = new EZRE_OppEmail_Report();
        
        System.runAs(objTestUser)
        {
             //Opportunity inserted by TestUser1        
              Opportunity objOpp1 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('testOpp1',acc.Id,'Qualification');
              Opportunity objOpp2= EZRE_OppRprt_DataFactory_Test_Utility.createOpp('testOpp2',acc.Id,'Qualification');
          
             //Insert Task with activity date past due and status is not completed
             Task objTsk1 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Call',objOpp1.Id,UserInfo.getUserId(),Date.Today()-3, 'Not Started' );
             
            // Insert Task with activity date past due and status is completed
             Task objTsk2 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Send Email',objOpp2.Id,UserInfo.getUserId(),Date.Today()-4, 'In Progress' );
             
             //Insert Event
              Event objEvnt1 = EZRE_OppRprt_DataFactory_Test_Utility.createEvent('Call',objOpp1.Id,UserInfo.getUserId(),Date.Today()-3);  
              
              //Insert Event
              Event objEvnt2 = EZRE_OppRprt_DataFactory_Test_Utility.createEvent('Call',objOpp2.Id,UserInfo.getUserId(),Date.Today()+3);  
    
        }
        
         Test.startTest();       
         objOppEmailRep.lstOpenTasks= EZRE_OppActReport_DataUtility.getOpenTaskList();
         objOppEmailRep.lstOpenEvnts= EZRE_OppActReport_DataUtility.getOpenEventsList();            
         objOppEmailRep.callScheduleMethod();             
         Test.stopTest();
         
         
         
    }
 
       
 }