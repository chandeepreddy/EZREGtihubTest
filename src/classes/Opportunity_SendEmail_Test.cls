/*
 * @author           Soumya
 * @version          1.0 
 * @date             10/10/2014
 * @description      Unit test for opportunity_SendEmails and opportunity_SendEmailCntrl.
 */  
@isTest
public class Opportunity_SendEmail_Test{
    public static testMethod void sendEmail() 
    {  
        //Fetch System admin profile
        Profile p = EZRE_DataFactory_Test_Utility2.fetchProfileSysAdmn(); 
        //Insert User record
        User objUser = EZRE_DataFactory_Test_Utility.createUser('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',
                                                            p.Id,'America/Los_Angeles','indhu_r@gmail.com','8143847962');

        System.runAs(objUser) 
        { 
            test.StartTest();
            //Insert Account
            Account accObj = EZRE_DataFactory_Test_Utility2.createAcc('Test Account');
                   
            //Insert Opportunity
            Opportunity oppObj1 = EZRE_DataFactory_Test_Utility2.createOpp('Test Opportunity',accObj.Id,System.Today(),'Closed Won', 
                                                                            'Title',100,'10 members','10 months','SFDC',
                                                                            'Description','Win','Competition data','Notes',
                                                                            objUser.Id,objUser.Id);
                                                                            
            Opportunity oppObj2 = EZRE_DataFactory_Test_Utility2.createOpp('Test Opportity',accObj.Id,System.Today(),'Closed lost', 
                                                                            'Title',102,'10 members','10 months','SFDC',
                                                                            'Description','Win','Competition data','Notes',
                                                                            objUser.Id,objUser.Id);

            Opportunity oppObj2U = EZRE_DataFactory_Test_Utility2.updatOpp(oppObj2.Id,'Test Opportunity',accObj.Id,System.Today(),'Closed Won',
                                                                            'Title',100,'10 members','10 months','SFDC',
                                                                            'Description','Win','Competition data','Notes',
                                                                            objUser.Id,objUser.Id);
            test.StopTest();
            //Asserts
            System.assertEquals(oppObj2.Id,oppObj2U.Id);
            System.assertEquals(oppObj2U.Technical_Contact__c,objUser.Id);
        }
    }
}