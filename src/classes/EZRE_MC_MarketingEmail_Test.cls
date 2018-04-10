/**
 * @author           Keerthi Chandra
 * @version          1.0 
 * @date             12/05/2015
 * @Status           Developed
 * @description      This test class is for EZRE_MC_MarketingEmail and EZRE_MC_MarketingEmail_Scheduler.
 *
 */
 
@isTest
Private class EZRE_MC_MarketingEmail_Test
{
    /// <OBJECTIVE>
    /// Method is to check whether task is created for single record
    /// </OBJECTIVE> 
   /* public static testMethod void sendMailToContactOwnr_SingleRecord_PositiveTest() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);
        
        //Insert MCCandidatesList record
        MC_Marketing__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'keerthi_c@peludesys.com',true,'keerthi_c@preludesys.com','Keerthi Chnadra');
        
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Keerthi','Chandra','9172904882','SE','keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmail.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmail.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmail.openEmailAddr = new Set<String>();
        (EZRE_MC_MarketingEmail.openEmailAddr).add('keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmail.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'keerthi_c@preludesys.com');
       
        EZRE_MC_MarketingEmail.mapOpenLst = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmail.mapOpenLst ).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmail.openEmailAddr );
        
        EZRE_MC_MarketingEmail.createCallTask(EZRE_MC_MarketingEmail.mapOpenLst );
        
        Test.StartTest();
        EZRE_MC_MarketingEmail.sendMailToContactOwnr();
        
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
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9','A23545','f272fef804',10);
        
        //Insert MCCandidatesList record
        MC_Marketing__c  objCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'keerthi_c@preludesys.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Keerthi','Chandra','9172904882','SE','keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmail.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmail.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmail.openEmailAddr= new Set<String>();
        (EZRE_MC_MarketingEmail.openEmailAddr).add('leela@preludesys.com');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmail.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'leela@preludesys.com');
        
        EZRE_MC_MarketingEmail.mapOpenLst = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmail.mapOpenLst ).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmail.openEmailAddr);
        
        EZRE_MC_MarketingEmail.createCallTask(EZRE_MC_MarketingEmail.mapOpenLst); 
                 
        Test.StartTest();
        EZRE_MC_MarketingEmail.sendMailToContactOwnr();
        
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
    /// Method is to check whether task is created for multiple records
    /// </OBJECTIVE> 
    public static testMethod void sendMailToContactOwnr_MultipleRecords_Test() 
    { 
        List<MC_Marketing__c> lstMcCand = new List<MC_Marketing__c>();
        List<Contact> lstCon = new List<Contact>();
        List<Task> lstTask = new List<Task>();
        List<MC_Marketing__c> lstCanToupdt = new List<MC_Marketing__c>();
        
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9','A23545','f272fef804',10);
        
        //Insert MCCandidatesList record
        MC_Marketing__c  objCndtLst1 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'keerthi_c@preludesys.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        MC_Marketing__c  objCndtLst2 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'sri_c@gmail.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        MC_Marketing__c  objCndtLst3 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'chandra@gmail.com',true,'tstsfdc@gmail.com','Keerthi Chnadra'); 
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
        
        Contact contct = EZRE_DataFactory_Test_Utility.fetchContct(con.Id);
        
        Task taskObj =  EZRE_DataFactory_Test_Utility.createTask(objMCDtl.MC_Campaign_Id__c, contct.id, 'call', 'Normal','The contact has opened the email');
        Task taskObj2 = EZRE_DataFactory_Test_Utility.createTask(objMCDtl.MC_Campaign_Id__c, contct.id, 'call', 'Normal', 'The contact has opened the email');
        lstTask.add(taskObj);
        lstTask.add(taskObj2);
        
        EZRE_MC_MarketingEmail.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmail.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmail.unopendEmailAddr = new Set<String>();
        (EZRE_MC_MarketingEmail.unopendEmailAddr).add('keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmail.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmail.mapUnOpenLst = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmail.mapUnOpenLst).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmail.unopendEmailAddr ); 
        
        EZRE_MC_MarketingEmail.mapContact = new Map<String, List<Contact>>();         
        (EZRE_MC_MarketingEmail.mapContact).put(con.Email, lstCon); 
        
        EZRE_MC_MarketingEmail.mapTask = new Map<String, List<Task>>();         
        (EZRE_MC_MarketingEmail.mapTask).put(objMCDtl.MC_Campaign_Id__c + ' - Call', lstTask); 
        
        
        EZRE_MC_MarketingEmail.createCallTask(EZRE_MC_MarketingEmail.mapUnOpenLst );
        EZRE_MC_MarketingEmail.upsrtMCCndtLst(EZRE_MC_MarketingEmail.mapUnOpenLst );
        EZRE_MC_MarketingEmail.sendEmail(EZRE_MC_MarketingEmail.mapUnOpenLst );
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
                        
        Test.StartTest();
        EZRE_MC_MarketingEmail.sendMailToContactOwnr();
        
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
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);
        
        //Insert MCCandidatesList record
        MC_Marketing__c objCndtLst1 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'keerthi_c@preludesys.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        MC_Marketing__c objCndtLst2 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'sri_c@gmail.com',true,'tstsfdc@gmail.com','Keerthi Chnadra');
        MC_Marketing__c objCndtLst3 = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'chandra@gmail.com',true,'tstsfdc@gmail.com','Keerthi Chnadra'); 
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
        
        EZRE_MC_MarketingEmail.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmail.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmail.bounceEmailAddr = new Set<String>();
        (EZRE_MC_MarketingEmail.bounceEmailAddr).add('sravani@preludesys.com');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmail.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmail.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'sravani@preludesys.com');
        
        EZRE_MC_MarketingEmail.mapBounceLst = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmail.mapBounceLst ).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmail.bounceEmailAddr);
        
        EZRE_MC_MarketingEmail.createCallTask(EZRE_MC_MarketingEmail.mapBounceLst );      
        EZRE_MC_MarketingEmail.upsrtMCCndtLst(EZRE_MC_MarketingEmail.mapBounceLst );
        
        Test.StartTest();
        EZRE_MC_MarketingEmail.sendMailToContactOwnr();
        EZRE_MC_MarketingEmail_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmail_Scheduler();
        String strSchTime = '0 0 0 1 1 ? 2025';
        String strJobId = system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler);
        CronTrigger ct = EZRE_DataFactory_Test_Utility2.fetchCronTriggr(strJobId); 
        Test.stopTest();
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
    } */
}