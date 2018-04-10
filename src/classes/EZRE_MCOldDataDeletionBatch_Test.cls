/**
 * @author           Indumathi.V    
 * @version          1.0 
 * @date             30-Sept-2016
 * @Status           Developed
 * @description      Test class for EZRE_MCOldDataDeletionBatch and EZRE_MC_MarketingEmailTask_Scheduler.
 *
 */
 
@isTest
Private class EZRE_MCOldDataDeletionBatch_Test
{
    /*
    /// <OBJECTIVE>
    /// Test method to check delete functionality
    /// </OBJECTIVE> 
    public static testMethod void executetest() 
    { 
        //Insert Mailchimp Custom settings for Marketing Campaign
        Mailchimp_Details__c objMCDtl1 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        //Insert Mailchimp Custom settings for Candidate Campaign
        Mailchimp_Details__c objMCDtl2 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c objMrktngCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Marketing Campaign',objMCDtl1.MC_Campaign_Id__c,'email1@peludesys.com',true,'email1@preludesys.com','Keerthi Chnadra');
        
        //Insert MCCandidatesList record
        MCCandidateList__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcCanLst('Test Candidate Campaign',objMCDtl2.MC_Campaign_Id__c,'email2@peludesys.com',false, 'Candidate','email2@preludesys.com','TestContact1');
        
        test.startTest();
        EZRE_MCOldDataDeletionBatch objMCDltnBtch = new EZRE_MCOldDataDeletionBatch();
        database.executeBatch(objMCDltnBtch,200);
        List<sobject> lst = new List<sobject>();
        
        objMCDltnBtch.execute(null,lst );
        test.stopTest();
    
    }
*/
}