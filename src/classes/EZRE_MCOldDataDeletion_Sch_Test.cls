/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             30-Sept-2016
 * @Status           Developed
 * @description      Test class for EZRE_MCOldDataDeletion_Sch scheduler class
 *
 */
 @isTest
 public class  EZRE_MCOldDataDeletion_Sch_Test 
 {
     /*public static testmethod void testScheduler()
     {
        //Insert Mailchimp Custom settings for Marketing Campaign
        Mailchimp_Details__c objMCDtl1 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        //Insert Mailchimp Custom settings for Candidate Campaign
        Mailchimp_Details__c objMCDtl2 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c objMrktngCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Marketing Campaign',objMCDtl1.MC_Campaign_Id__c,'email1@peludesys.com',true,'email1@preludesys.com','Keerthi Chnadra');
        
        //Insert MCCandidatesList record
        MCCandidateList__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcCanLst('Test Candidate Campaign',objMCDtl2.MC_Campaign_Id__c,'email2@peludesys.com',false, 'Candidate','email2@preludesys.com','TestContact1');
        
       
           EZRE_MCOldDataDeletion_Sch  schedulerObj = new EZRE_MCOldDataDeletion_Sch();      
           String strSch = '0 0 22 * * ?';
           test.startTest();
           String strjobId = system.schedule('Test schedule', strSch,schedulerObj); 
           test.stopTest();
           CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
           //System.assertEquals(strSch, ct.CronExpression); 

     }
     
       */

 }