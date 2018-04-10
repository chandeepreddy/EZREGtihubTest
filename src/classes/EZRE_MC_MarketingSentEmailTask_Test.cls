/**
 * @author           Kirankumar D
 * @version          1.0 
 * @date             24/06/2016
 * @Status           Developed
 * @description      This test class is for EZRE_MC_MarketingSentEmailTask and EZRE_MC_MarketingEmail_Scheduler.
 *
 */
 
@isTest
Private class EZRE_MC_MarketingSentEmailTask_Test
{
    /// <OBJECTIVE>
    /// Method is to check whether task is created for single record
    /// </OBJECTIVE> 
   /* public static testMethod void sendMailToContactOwnr_SingleRecord_PositiveTest() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c MCDtls = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'keerthi_c@peludesys.com',true,'keerthi_c@preludesys.com','Keerthi Chnadra');
        
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Kiran','Kumar','9172904882','SE','kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingSendEmailTask.setCmpgnId).add(MCDtls.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme).put(MCDtls.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml).put(MCDtls.MC_Campaign_Id__c, 'kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt= new Map<String, Set<String>>(); 
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt).put(MCDtls.MC_Campaign_Id__c, EZRE_MC_MarketingSendEmailTask.sentEmlAdr);
        
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        
        Test.StartTest();
        
        EZRE_MC_MarketingSendEmailTask.sendMailToContactOwnr();
        MC_Marketing__c updtCan = EZRE_DataFactory_Test_Utility.fetchMcContctlst(objCndtLst.Id);
        Contact contct = EZRE_DataFactory_Test_Utility.fetchContct(con.Id);
        EZRE_MC_MarketingEmail_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmail_Scheduler();
        String strSchTime = '0 0 0 1 1 ? 2025';
        String strJobId = system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler); 
        CronTrigger ct = EZRE_DataFactory_Test_Utility2.fetchCronTriggr(strJobId);
        
        Test.stopTest();
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
    }
    
   /// <OBJECTIVE>
   /// Method is to check the negative scenario for single record
   /// </OBJECTIVE> 
    public static testMethod void sendMailToContactOwnr_SingleRecord_NegativeTest() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c MCDtls = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9','A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c  objCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'keerthi_c@preludesys.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Kiran','Kumar','9172904882','SE','Kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingSendEmailTask.setCmpgnId).add(MCDtls.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingSendEmailTask.sentEmlAdr = new Set<String>();
        (EZRE_MC_MarketingSendEmailTask.sentEmlAdr).add('leela@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme).put(MCDtls.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml).put(MCDtls.MC_Campaign_Id__c, 'leela@preludesys.com');
        
         EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt= new Map<String, Set<String>>(); 
         (EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt).put(MCDtls.MC_Campaign_Id__c, EZRE_MC_MarketingSendEmailTask.sentEmlAdr);
         
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        
        Test.StartTest();
        
        EZRE_MC_MarketingSendEmailTask.sendMailToContactOwnr();
        EZRE_MC_MarketingEmail_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmail_Scheduler();
        String strSchTime = '0 0 0 1 1 ? 2025';
        String strJobId = system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler); 
        CronTrigger ct = EZRE_DataFactory_Test_Utility2.fetchCronTriggr(strJobId);
        
        Test.stopTest();
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        
    }
    
    /// <OBJECTIVE>
    /// Method is to check whether task are created
    /// </OBJECTIVE> 
    public static testMethod void createTask_Test()
    {
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c MCDtls = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        
        //Insert MCCandidatesList record
        MC_Marketing__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'keerthi_c@peludesys.com',true,'keerthi_c@preludesys.com','Keerthi Chnadra');
        system.debug('*******************objCndtLst'+objCndtLst);
        
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Kiran','Kumar','9172904882','SE','kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingSendEmailTask.setCmpgnId).add(MCDtls.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingSendEmailTask.sentEmlAdr = new Set<String>();
        (EZRE_MC_MarketingSendEmailTask.sentEmlAdr).add('kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme).put(MCDtls.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml).put(MCDtls.MC_Campaign_Id__c, 'kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt= new Map<String, Set<String>>(); 
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt).put(MCDtls.MC_Campaign_Id__c, EZRE_MC_MarketingSendEmailTask.sentEmlAdr);
        
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        
        Test.StartTest();
        
        EZRE_MC_MarketingSendEmailTask.sendMailToContactOwnr();
        EZRE_MC_MarketingSendEmailTask.createEmailTask(EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt);
        MC_Marketing__c updtCan = EZRE_DataFactory_Test_Utility.fetchMcContctlst(objCndtLst.Id);
        Contact contct = EZRE_DataFactory_Test_Utility.fetchContct(con.Id);
        EZRE_MC_MarketingEmail_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmail_Scheduler();
        String strSchTime = '0 0 0 1 1 ? 2025';
        String strJobId = system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler); 
        CronTrigger ct = EZRE_DataFactory_Test_Utility2.fetchCronTriggr(strJobId);
        
        Test.stopTest();
        
     }
    
    /// <OBJECTIVE>
    /// Method is to check whether task is created for multiple records
    /// </OBJECTIVE>    
    public static testMethod void sendMailToContactOwnr_MultipleRecords_PositiveTest() 
    { 
        List<MC_Marketing__c> lstMcCand = new List<MC_Marketing__c>();
        List<Contact> lstCon = new List<Contact>();
        List<MC_Marketing__c> lstCanToupdt = new List<MC_Marketing__c>();
        
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c MCDtls = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9','A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c  objCndtLst1 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'Kirankumar_d@preludesys.com',true,'tstsfdc@gmail.com','Kiran Kumar');
        MC_Marketing__c  objCndtLst2 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'sri_c@gmail.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        MC_Marketing__c  objCndtLst3 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'KiranVD@gmail.com',true,'tstsfdc@gmail.com','Kiran'); 
        lstMcCand.add(objCndtLst1);
        lstMcCand.add(objCndtLst2);
        lstMcCand.add(objCndtLst3);
        
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Kiran','Kumar','9172904882','SE','Kirankumar_d@preludesys.com');
        Contact con2 = EZRE_DataFactory_Test_Utility.createCon('Sri','Chandra','9172904882','SE','sri_c@gmail.com');
        Contact con3 = EZRE_DataFactory_Test_Utility.createCon('Keerthi','Chandra','9172904882','SE','chandra@gmail.com');
        lstCon.add(con);
        lstCon.add(con2);
        lstCon.add(con3);
        
        EZRE_MC_MarketingSendEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingSendEmailTask.setCmpgnId).add(MCDtls.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingSendEmailTask.sentEmlAdr = new Set<String>();
        (EZRE_MC_MarketingSendEmailTask.sentEmlAdr).add('Kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme).put(MCDtls.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml).put(MCDtls.MC_Campaign_Id__c, 'Kirankumar_d@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt= new Map<String, Set<String>>(); 
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt).put(MCDtls.MC_Campaign_Id__c, EZRE_MC_MarketingSendEmailTask.sentEmlAdr);
        
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
                       
        Test.StartTest();
        
        EZRE_MC_MarketingSendEmailTask.sendMailToContactOwnr();
        EZRE_MC_MarketingEmail_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmail_Scheduler();
        String strSchTime = '0 0 0 1 1 ? 2025';
        String strJobId = system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler); 
        CronTrigger ct = EZRE_DataFactory_Test_Utility2.fetchCronTriggr(strJobId);
        
        Test.stopTest();
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
    }
    
    /// <OBJECTIVE>
    /// Method is to check the negative scenario for multiple record
    /// </OBJECTIVE> 
    public static testMethod void sendMailToContactOwnr_MultipleRecords_NegativeTest() 
    { 
        List<MC_Marketing__c> lstMcCand = new List<MC_Marketing__c>();
        List<Contact> lstCon = new List<Contact>();
        List<MC_Marketing__c> lstCanToupdt = new List<MC_Marketing__c>();
        
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c MCDtls = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);

        //Insert MCCandidatesList record
        MC_Marketing__c objCndtLst1 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'keerthi_c@preludesys.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        MC_Marketing__c objCndtLst2 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'sri_c@gmail.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        MC_Marketing__c objCndtLst3 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',MCDtls.MC_Campaign_Id__c,'chandra@gmail.com',true,'tstsfdc@gmail.com','Keerthi Chnadra'); 
        lstMcCand.add(objCndtLst1);
        lstMcCand.add(objCndtLst2);
        lstMcCand.add(objCndtLst3);
        
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Keerthi','Chandra','9172904882','SE','keerthi_c@preludesys.com');
        Contact con2 = EZRE_DataFactory_Test_Utility.createCon('Keerthi','Chandra','9172904882','SE','sri_c@gmail.com');
        Contact con3 = EZRE_DataFactory_Test_Utility.createCon('Keerthi','Chandra','9172904882','SE','chandra@gmail.com');
        lstCon.add(con);
        lstCon.add(con2);
        lstCon.add(con3);
        
        EZRE_MC_MarketingSendEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingSendEmailTask.setCmpgnId).add(MCDtls.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingSendEmailTask.sentEmlAdr = new Set<String>();
        (EZRE_MC_MarketingSendEmailTask.sentEmlAdr).add('sravani@preludesys.com');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdNme).put(MCDtls.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnIdFrmEml).put(MCDtls.MC_Campaign_Id__c, 'sravani@preludesys.com');
         
        EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt= new Map<String, Set<String>>(); 
        (EZRE_MC_MarketingSendEmailTask.mapCmpgnCndt).put(MCDtls.MC_Campaign_Id__c, EZRE_MC_MarketingSendEmailTask.sentEmlAdr);
        
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
                       
        Test.StartTest();
        
        EZRE_MC_MarketingSendEmailTask.sendMailToContactOwnr();
        EZRE_MC_MarketingEmail_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmail_Scheduler();
        String strSchTime = '0 45 23 1 1 ? 2025';
        String strJobId = system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler);
        CronTrigger ct = EZRE_DataFactory_Test_Utility2.fetchCronTriggr(strJobId); 
        
        Test.stopTest();
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2025-01-01 23:45:00', String.valueOf(ct.NextFireTime));
    }*/
}