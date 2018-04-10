/**
 * @author           Soumya
 * @version          1.0 
 * @date             28/11/2014
 * @Status           Developed
 * @description      This is test class for EZRE_BatchSendMailToPdngCand & EZRE_SchedulerPdngCand
 *                   
*/
@isTest
private class EZRE_SendMailToPndgCand_Test{

    static testMethod void EZRE_SendMailToPndgCand_Test()
    {
        Profile prof = EZRE_DataFactory_Test_Utility.fetchProfileRec();
        User usr = EZRE_DataFactory_Test_Utility.createUser('Usr','testingUsr123@testorg.com','UTF-8',
                        'Usr','en_US','en_US',prof.Id,
                                    'America/Los_Angeles','TestingUsr123@testemail.com','1243847862');
        
        System.runAs(usr)
        {
            Requirement__c rqmnt = EZRE_DataFactory_Test_Utility.createReq('Test Requirement3','20',200,250,400,'Open','Contract','DC','In-Person',20,'Hyderabad',
                                                                            date.today(),'c','c','c'); 
            
            
            Candidate__c cand = EZRE_DataFactory_Test_Utility.createCan('TestCandidate','testing','chennai','Maine','Male','testEmployee1',
                                                                                 'test@gmail.com','Mobile Phone','Corp to Corp','H1 B',100,'9176904882',
                                                                                 'test@gmail.com','TestContact','8143847962','jyothi','(326) 044-6881',date.today(),'c');
            Candidate_Mapping__c candAsgmnt = new Candidate_Mapping__c(Manager_Email_ID__c='email3@email.com', Candidate__c = cand.id, Requirement__c = rqmnt.Id, status1__c = 'Applied', Employer_s_Authorization__c = 'test', LR_Comments__c = 'test by lr', MR_Comments__c = 'test by MR', Requirement_Owner_Email__c = 'testOwner@preludesys.com');
            insert candAsgmnt;
            Candidate_Mapping__c insertedCandAsgnmt=[SELECT ID,CREATEDBYID,Added_User__c FROM Candidate_Mapping__c WHERE ID =: candAsgmnt.Id];    
            Test.startTest();
                String CRON_EXP = '0 0 0 1 1 ? 2025';  
                String jobId = System.schedule('testScheduledApex', CRON_EXP, new EZRE_SchedulerPdngCand() );

                CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
            Test.stopTest();
        }
    }
}