/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             27/06/2016
 * @Status           Developed
 * @description      This test class is for EZRE_MC_MarketingEmailTask and EZRE_MC_MarketingEmailTask_Scheduler.
 *
 */
 
@isTest
Private class EZRE_MC_MarketingEmailTask_Test
{
    /// <OBJECTIVE>
    /// Method is to check whether task is created for single record
    /// </OBJECTIVE> 
  /*  public static testMethod void sendMailToContactOwnr_SingleRecord_PositiveTest() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MC Marketing','TestAPIKey','us9', 'A23545','f272fef804',10);
        
        //Insert MCCandidatesList record
        MC_Marketing__c objCndtLst = EZRE_DataFactory_Test_Utility.createMcConLst('Test Campaign',objMCDtl.MC_Campaign_Id__c,'keerthi_c@peludesys.com',true,'keerthi_c@preludesys.com','Keerthi Chnadra');
        //Insert account
        Account acc = EZRE_DataFactory_Test_Utility.createAcc('Test Account');
        
        //Insert Contact
        Contact con = EZRE_DataFactory_Test_Utility.createCon('Keerthi','Chandra','9172904882','SE','keerthi_c@preludesys.com');
        
        List<Task> lstTask = new List<Task>();
        Contact contct = EZRE_DataFactory_Test_Utility.fetchContct(con.Id);
        
        Task taskObj =  EZRE_DataFactory_Test_Utility.createTask(objMCDtl.MC_Campaign_Id__c, contct.id, 'call', 'Normal','The contact has opened the email');
        Task taskObj2 = EZRE_DataFactory_Test_Utility.createTask(objMCDtl.MC_Campaign_Id__c, contct.id, 'call', 'Normal', 'The contact has opened the email');
        lstTask.add(taskObj);
        lstTask.add(taskObj2);
        
        EZRE_MC_MarketingEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmailTask.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmailTask.unopendEmailAddr = new Set<String>();
        (EZRE_MC_MarketingEmailTask.unopendEmailAddr).add('keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'keerthi_c@preludesys.com');
       
        EZRE_MC_MarketingEmailTask.mapUnOpenLst = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmailTask.mapUnOpenLst ).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmailTask.unopendEmailAddr);
        
        EZRE_MC_MarketingEmail.mapTask = new Map<String, List<Task>>();         
        (EZRE_MC_MarketingEmail.mapTask).put(objMCDtl.MC_Campaign_Id__c + ' - Call', lstTask); 
        
        EZRE_MC_MarketingEmailTask.sendEmailTask(EZRE_MC_MarketingEmailTask.mapUnOpenLst );
        
        Test.StartTest();
        EZRE_MC_MarketingEmailTask.createSendEmailTask();
        
        MC_Marketing__c updtCan = EZRE_DataFactory_Test_Utility.fetchMcContctlst(objCndtLst.Id);

        EZRE_MC_MarketingEmailTask_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmailTask_Scheduler();
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
        
        EZRE_MC_MarketingEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmailTask.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmailTask.unopendEmailAddr = new Set<String>();
        (EZRE_MC_MarketingEmailTask.unopendEmailAddr ).add('leela@preludesys.com');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'leela@preludesys.com');
        
        EZRE_MC_MarketingEmailTask.mapUnOpenLst = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmailTask.mapUnOpenLst ).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmailTask.unopendEmailAddr );
        
        EZRE_MC_MarketingEmailTask.sendEmailTask(EZRE_MC_MarketingEmailTask.mapUnOpenLst ); 
                 
        Test.StartTest();
        EZRE_MC_MarketingEmailTask.createSendEmailTask();
        
        EZRE_MC_MarketingEmailTask_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmailTask_Scheduler();
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
        
        EZRE_MC_MarketingEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmailTask.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmailTask.unopendEmailAddr = new Set<String>();
        (EZRE_MC_MarketingEmailTask.unopendEmailAddr).add('keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'keerthi_c@preludesys.com');
        
        EZRE_MC_MarketingEmailTask.mapUnOpenLst = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmailTask.mapUnOpenLst ).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmailTask.unopendEmailAddr ); 
        
        EZRE_MC_MarketingEmailTask.mapContact = new Map<String, List<Contact>>();         
        (EZRE_MC_MarketingEmailTask.mapContact).put(con.Email, lstCon); 
        
        EZRE_MC_MarketingEmailTask.mapTask = new Map<String, List<Task>>();         
        (EZRE_MC_MarketingEmailTask.mapTask).put(objMCDtl.MC_Campaign_Id__c + ' - Call', lstTask); 
        
        
        EZRE_MC_MarketingEmailTask.sendEmailTask(EZRE_MC_MarketingEmailTask.mapUnOpenLst );
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());                
        
        Test.StartTest();
        EZRE_MC_MarketingEmailTask.createSendEmailTask();
        
        EZRE_MC_MarketingEmailTask_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmailTask_Scheduler();
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
        
        EZRE_MC_MarketingEmailTask.setCmpgnId = new Set<String>();           
        (EZRE_MC_MarketingEmailTask.setCmpgnId).add(objMCDtl.MC_Campaign_Id__c);
        
        EZRE_MC_MarketingEmailTask.unopendEmailAddr = new Set<String>();
        (EZRE_MC_MarketingEmailTask.unopendEmailAddr).add('sravani@preludesys.com');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdNme = new Map<String, String>();            
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdNme).put(objMCDtl.MC_Campaign_Id__c, 'Test Campaign');
        
        EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml = new Map<String, String>();         
        (EZRE_MC_MarketingEmailTask.mapCmpgnIdFrmEml).put(objMCDtl.MC_Campaign_Id__c, 'sravani@preludesys.com');
        
        EZRE_MC_MarketingEmailTask.mapUnOpenLst  = new Map<String, Set<String>>();         
        (EZRE_MC_MarketingEmailTask.mapUnOpenLst ).put(objMCDtl.MC_Campaign_Id__c, EZRE_MC_MarketingEmailTask.unopendEmailAddr );
        
        EZRE_MC_MarketingEmailTask.sendEmailTask(EZRE_MC_MarketingEmailTask.mapUnOpenLst );      
        
        Test.StartTest();
        EZRE_MC_MarketingEmailTask.createSendEmailTask();
        EZRE_MC_MarketingEmailTask_Scheduler objCndtEmailScheduler = new EZRE_MC_MarketingEmailTask_Scheduler();
        String strSchTime = '0 0 0 1 1 ? 2025';
        String strJobId = system.schedule('Test Scheduler', strSchTime, objCndtEmailScheduler);
        CronTrigger ct = EZRE_DataFactory_Test_Utility2.fetchCronTriggr(strJobId); 
        Test.stopTest();
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
    }*/
}