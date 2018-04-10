/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             30-Sept-2016
 * @Status           Developed
 * @description      Test class for CustomIterable  class
 *
 */
 @isTest
 public class  EZRE_MC_CustomIterable_Test 
 {
   /* /// <OBJECTIVE>
    /// Method to test constructor
    /// </OBJECTIVE>    
    public static testmethod void customIterableConstructorTest()
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
        EZRE_MC_CustomIterable obj = new EZRE_MC_CustomIterable();
        obj.sobjs.add(objMrktngCndtLst);
        obj.sobjs.add(objCndtLst);
        
        //System.assertEquals(obj.sobjs.size(),0);
        test.stopTest();
        

    }
    
    /// <OBJECTIVE>
    /// Method to test hasNext functionality
    /// </OBJECTIVE>
    public static testmethod void customIterablehasNextTest()
    {
        //Insert Mailchimp Custom settings for Marketing Campaign
        Mailchimp_Details__c objMCDtl1 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        //Insert Mailchimp Custom settings for Candidate Campaign
        Mailchimp_Details__c objMCDtl2 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c objMrktngCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Marketing Campaign',objMCDtl1.MC_Campaign_Id__c,'email1@peludesys.com',false,'email1@preludesys.com','Keerthi Chnadra');

       
        //Insert MCCandidatesList record
        MCCandidateList__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcCanLst('Test Candidate Campaign',objMCDtl2.MC_Campaign_Id__c,'email2@peludesys.com',false, 'Candidate','email2@preludesys.com','TestContact1');

        
        
        test.startTest();       
        EZRE_MC_CustomIterable obj = new EZRE_MC_CustomIterable();
        obj.sobjs.add(objMrktngCndtLst);
        obj.sobjs.add(objCndtLst);      
        obj.hasNext();  

        test.stopTest();

    }
     
    /// <OBJECTIVE>
    /// Method to test Next functionality
    /// </OBJECTIVE>    
    public static testmethod void customIterableNextTest()
    {
        //Insert Mailchimp Custom settings for Marketing Campaign
        Mailchimp_Details__c objMCDtl1 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        //Insert Mailchimp Custom settings for Candidate Campaign
        Mailchimp_Details__c objMCDtl2 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c objMrktngCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Marketing Campaign',objMCDtl1.MC_Campaign_Id__c,'email1@peludesys.com',false,'email1@preludesys.com','Keerthi Chnadra');

        
        
       //Insert MCCandidatesList record
        MCCandidateList__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcCanLst('Test Candidate Campaign',objMCDtl2.MC_Campaign_Id__c,'email2@peludesys.com',false, 'Candidate','email2@preludesys.com','TestContact1');

        test.startTest();       
        EZRE_MC_CustomIterable obj = new EZRE_MC_CustomIterable(); 
        obj.sobjs.add(objMrktngCndtLst);
        obj.sobjs.add(objCndtLst);          
        obj.Next();      
        test.stopTest();

    }
     
    /// <OBJECTIVE>
    /// Method to test Iterator functionality
    /// </OBJECTIVE>        
    public static testmethod void customIterableiteratorTest()
    {

        //Insert Mailchimp Custom settings for Marketing Campaign
        Mailchimp_Details__c objMCDtl1 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        //Insert Mailchimp Custom settings for Candidate Campaign
        Mailchimp_Details__c objMCDtl2 = EZRE_DataFactory_Test_Utility.createMCSettngforDeletion('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c objMrktngCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Marketing Campaign',objMCDtl1.MC_Campaign_Id__c,'email1@peludesys.com',true,'email1@preludesys.com','Keerthi Chnadra');

        //Insert MCCandidatesList record
        MCCandidateList__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcCanLst('Test Candidate Campaign',objMCDtl2.MC_Campaign_Id__c,'email2@peludesys.com',true, 'Candidate','email2@preludesys.com','TestContact1');

        test.startTest();       
        EZRE_MC_CustomIterable obj = new EZRE_MC_CustomIterable();     
        obj.iterator();
        test.stopTest();

    }
     
    
*/
 }