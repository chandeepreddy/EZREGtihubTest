/**
 * @author           Shahida K
 * @version          1.0 
 * @date             11/15/2016
 * @Status           Developed
 * @description      Test class for EZRE_MC_MultiListCampaign_Schedule scheduler class
 *
 */
 @isTest
 public class  EZRE_MailChimp_SendCampaign_Schdlr_Test
 {
    /* ///OBJECTIVE
     ///Test method to test scheduler funtionality.
     ///OBJECTIVE
     public static testmethod void testScheduler()
     {
           //Insert Mailchimp Custom settings for Marketing Campaign
           Mailchimp_Details__c objMCDtl1 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MCAccount','TestAPIKey','us9', 'A23545','f272fef804',10);
           EZRE_MailChimp_SendCampaign_Schedule schedulerObj = new EZRE_MailChimp_SendCampaign_Schedule();      
           String strSch = '0 0 22 * * ?';
           test.startTest();
           String strjobId = system.schedule('Test schedule', strSch,schedulerObj); 
           test.stopTest();
           CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
           System.assertEquals(strSch, ct.CronExpression); 


     }*/

 }