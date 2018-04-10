/**
 * @author           Indumathi
 * @version          1.0 
 * @date             19/11/2015
 * @Status           Developed
 * @description      Test class for EZRE_OppAndActivities_Report class
 *
 */
 
@isTest
public class EZRE_OppAndActivities_Report_Test
{

    ///<OBJECTIVE>
    ///Method to get Opportunities with no activities in the report
    ///</OBJECTIVE>
    public static testMethod void EZRE_OppWithNoActivities_Test() 
    { 
       
         //Insert account
         Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
         
         //Insert Opportunity         
         Opportunity opp = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp1',acc.Id,'Needs Analysis'); 
         Opportunity opp1 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp2',acc.Id,'Qualification');
         Opportunity opp2 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp3',acc.Id,'Closed Transferred');         
         
         
         Test.startTest();
         EZRE_OppAndActivities_Report obj = new EZRE_OppAndActivities_Report();
         Test.stopTest();
         System.assertEquals((obj.lstOppWthoutActvts).size(),2);
        
        
    }
    
    ///<OBJECTIVE>
    ///Method to get Opportunities with no activities in the report
    ///</OBJECTIVE>
    public static testMethod void EZRE_OppWithPastDueActivities_Test() 
    { 
       
         //Insert account
         Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
         
         //Insert Opportunity         
         Opportunity opp = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp1',acc.Id,'Needs Analysis'); 
         Opportunity opp1 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp2',acc.Id,'Qualification');
         Opportunity opp2 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp3',acc.Id,'Qualification');     
        Opportunity opp3 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp4',acc.Id,'Qualification');   
        Opportunity opp4 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp5',acc.Id,'Resume Submitted');   
        Opportunity opp5 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp6',acc.Id,'Qualification');               
         
         //Insert Task with activity date past due and status is not completed
         Task objTsk = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Call',opp1.Id,UserInfo.getUserId(),Date.Today()-1, 'Not Started' );
         
         //Insert Task with activity date past due and status is completed
         Task objTsk1 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Send Email',opp2.Id,UserInfo.getUserId(),Date.Today()-2, 'Completed' );   
        
        //Insert Task with activity date past due and status is completed
         Task objTsk2 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Send Email',opp3.Id,UserInfo.getUserId(),Date.Today()-4, 'Completed' );            
        
        
        //Insert Event with past due date
         Event objEvnt = EZRE_OppRprt_DataFactory_Test_Utility.createEvent('Call',opp3.Id,UserInfo.getUserId(),Date.Today()-4); 
        //Insert Event with past due date
         Event objEvnt1 = EZRE_OppRprt_DataFactory_Test_Utility.createEvent('Call',opp3.Id,UserInfo.getUserId(),Date.Today()-10);        
       
          //Insert open activities
         Task objTsk3 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Send Email',opp4.Id,UserInfo.getUserId(),Date.Today()+4, 'Not Started' );            
        
         Task objTsk4 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Send Email',opp5.Id,UserInfo.getUserId(),Date.Today()+4, 'In Progress' );  
         Event objEvnt2 = EZRE_OppRprt_DataFactory_Test_Utility.createEvent('Call',opp5.Id,UserInfo.getUserId(),Date.Today()+10);        
         
         
         Test.startTest();
         EZRE_OppAndActivities_Report obj = new EZRE_OppAndActivities_Report();
         Test.stopTest();
         System.assertEquals((obj.lstOppWthoutActvts).size(),4);
        
        
    }
    
    ///<OBJECTIVE>
    ///Method to get Opportunities with no activities in the report
    ///</OBJECTIVE>
    public static testMethod void EZRE_OppWithOpenActivities_Test() 
    { 
       
         //Insert account
         Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
         
         //Insert Opportunity         
         //Opportunity opp = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp1',acc.Id,'Needs Analysis'); 
        Opportunity opp1 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp2',acc.Id,'Qualification');
        Opportunity opp2 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp3',acc.Id,'Qualification'); 
        Opportunity opp3 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('Opp4',acc.Id,'Resume Submitted');           
         
         //Insert Task with activity date past due and status is not completed
         Task objTsk = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Call',opp1.Id,UserInfo.getUserId(),Date.Today()+3, 'Not Started' );
         
        // Insert Task with activity date past due and status is completed
         Task objTsk1 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Send Email',opp2.Id,UserInfo.getUserId(),Date.Today()+4, 'In Progress' ); 
 
        //Insert Event
         Event objEvnt = EZRE_OppRprt_DataFactory_Test_Utility.createEvent('Call',opp3.Id,UserInfo.getUserId(),Date.Today()+3);      
       
         
         Test.startTest();
         EZRE_OppAndActivities_Report obj = new EZRE_OppAndActivities_Report();
         Test.stopTest();
         System.assertEquals((obj.lstOppWthoutActvts).size(),0);
        
        
    }
    ///<OBJECTIVE>
    ///Method to get Opportunities with no activities in the report
    ///</OBJECTIVE>
    
    public static testmethod void EZRE_OppownerCount_Test()
    {
         //Insert account
         Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
         
         //Get profile named "Administrator"
        Profile TestProfile=[select id from profile where Name='Administrator'];
        
         //insert user
        User TestUser1= EZRE_OppRprt_DataFactory_Test_Utility.createUser('Alias1','usernametest1@testuserorg.com','UTF-8','TestUser1','en_US', 
       'en_US', TestProfile.Id,'America/Los_Angeles','usernametest1@testuserorg.com');
       
          //insert user
        User TestUser2=EZRE_OppRprt_DataFactory_Test_Utility.createUser('Alias2','usernametest2@testorg.com','UTF-8','TestUser2','en_US', 
          'en_US',TestProfile.Id,'America/Los_Angeles','usernametest2@testuserorg.com');
        
       
        System.runAs(TestUser1)
        {
        //Opportunity inserted by TestUser1        
          Opportunity oppRecord1 = EZRE_OppRprt_DataFactory_Test_Utility.createOpp('testOpp1',acc.Id,'Qualification');
          Opportunity oppRecord2= EZRE_OppRprt_DataFactory_Test_Utility.createOpp('testOpp2',acc.Id,'Qualification');
          
         //Insert Task with activity date past due and status is not completed
         Task objTsk = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Call',oppRecord1.Id,UserInfo.getUserId(),Date.Today()-3, 'Not Started' );
         
        // Insert Task with activity date past due and status is completed
         Task objTsk1 = EZRE_OppRprt_DataFactory_Test_Utility.createTask('Send Email',oppRecord2.Id,UserInfo.getUserId(),Date.Today()-4, 'In Progress' ); 
                   
        }
        
        System.runAs(TestUser2)
        {
          //Opportunity inserted by TestUser2
           Opportunity oppRecord3= EZRE_OppRprt_DataFactory_Test_Utility.createOpp('testOpp2',acc.Id,'Qualification');
              
        //Insert Event
         Event objEvnt = EZRE_OppRprt_DataFactory_Test_Utility.createEvent('Call',oppRecord3.Id,UserInfo.getUserId(),Date.Today()-3);  
            
        }
            
            
         Test.startTest();
         EZRE_OppAndActivities_Report objOppReport = new EZRE_OppAndActivities_Report();             
         Test.stopTest();
         
        System.assertEquals((objOppReport.lstWrapperAggregateResult).size(),2);
        System.assertEquals((objOppReport.lstWrapperAggregateResult[0].strOwnerName),'TestUser1');
        System.assertEquals((objOppReport.lstWrapperAggregateResult[0].intOwnerCount),2);
        System.assertEquals((objOppReport.lstWrapperAggregateResult[1].strOwnerName),'TestUser2');
        System.assertEquals((objOppReport.lstWrapperAggregateResult[1].intOwnerCount),1);
    }
    
    
    
}