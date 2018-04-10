/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             19/07/2016
 * @Status           Developed
 * @description      Test class is for EZRE_MCEmailToAssignmentOwner
 *
 */
 
@isTest
public class EZRE_MCEmailToAssignmentOwner_Test
{
    
  /*  ///<OBJECTIVE>
    ///Method to test getMCCmpngLstCount method with positive flow 
    ///</OBJECTIVE>
   public static testMethod void testgetMCCmpngLstCount_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
        
        test.starttest();
        EZRE_MCEmailToAssignmentOwner.getMCCmpngLstCount();
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        test.stoptest();     
    }
    
    ///<OBJECTIVE>
    ///Method to test getMCCmpngLst method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testgetMCCmpngLst_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
       
        test.starttest();
        EZRE_MCEmailToAssignmentOwner.getMCCmpngLst();
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        test.stoptest();     
    }
    
    ///<OBJECTIVE>
    ///Method to test getEmailActivity method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testgetEmailActivity_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
         Set<String> setCmpgnId = new Set<String>();
        setCmpgnId.add(objMCDtl.MC_Campaign_Id__c);
        test.starttest();
        EZRE_MCEmailToAssignmentOwner.getMCCmpngLst();
        EZRE_MCEmailToAssignmentOwner.getEmailActivity(setCmpgnId);
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        test.stoptest();     
    }
    
    ///<OBJECTIVE>
    ///Method to test getMCCandUnsubscribesList method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testgetMCCandUnsubscribesList_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
        
        test.starttest();
        EZRE_MCEmailToAssignmentOwner.getMCCandUnsubscribesList(objMCDtl.MC_Campaign_Id__c);
        Test.setMock(HttpCalloutMock.class, new EZRE_MockHttpResponseGenerator());
        test.stoptest();     
    }
    
    ///<OBJECTIVE>
    ///Method to test senEmailtoAssgnmntOwnr method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testsenEmailtoAssgnmntOwnr_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
        test.starttest();
        EZRE_MCEmailToAssignmentOwner.getMCCandUnsubscribesList(objMCDtl.MC_Campaign_Id__c);
        test.stopTest();
    }
    
    ///<OBJECTIVE>
    ///Method to test upsrtMCCndtLst method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testupsrtMCCndtLst_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
        
       
        //Generate mapOpenLst;
        Set<String> setEmlAddrsss = new Set<String>();
        setEmlAddrsss.add('email1@gmail.com');
          
        (EZRE_MCEmailToAssignmentOwner.mapOpenLst).put(objMCDtl.MC_Campaign_Id__c, setEmlAddrsss);
        test.starttest();
            EZRE_MCEmailToAssignmentOwner.getMCCmpngLst();
            EZRE_MCEmailToAssignmentOwner.upsrtMCCndtLst(EZRE_MCEmailToAssignmentOwner.mapOpenLst);
        test.stopTest();
    }
    
    ///<OBJECTIVE>
    ///Method to test sendEmail method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testsendEmail_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', '234ded12ee','f272fef804');
        
        //Generate mapOpenLst;
        Set<String> setEmlAddrsss = new Set<String>();
        setEmlAddrsss.add('email1@gmail.com');
        (EZRE_MCEmailToAssignmentOwner.mapOpenLst).put('234ded12ee', setEmlAddrsss);
        
        MCCandidateList__c objCndtLst1 = new MCCandidateList__c();
        objCndtLst1.Campaign_Name__c = 'Need Salesforce Developer';
        //objCndtLst1.Campaign_Id__c = objMCDtl.MC_Campaign_Id__c;
        objCndtLst1.Campaign_Id__c = '234ded12ee';
        objCndtLst1.From_email__c = 'test@gmail.com';
        objCndtLst1.MC_List_Type__c = 'Candidate Campaign';
        objCndtLst1.Candidate_Email__c = 'email1@gmail.com';
        objCndtLst1.IsNew__c = true;
        insert objCndtLst1;
        System.debug('objCndtLst1 in test class---------'+objCndtLst1); 
        test.starttest();
            EZRE_MCEmailToAssignmentOwner.getMCCmpngLst();
            EZRE_MCEmailToAssignmentOwner.sendEmail(EZRE_MCEmailToAssignmentOwner.mapOpenLst);
        test.stopTest();
    }
    
    ///<OBJECTIVE>
    ///Method to test updateBouncedCand method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testupdateBouncedCand_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
        
        //Create Candidate
        Candidate__c can = EZRE_DataFactory_Test_Utility.createCan('TestCandidate','testing','chennai','Maine','Male','testEmployee',
                                                                            'email1@gmail.com','Mobile Phone','Corp to Corp','H1 B',100,'9176904882',
                                                                            'email1@gmail.com','TestContact','8143847962','jyothi','(326) 044-6881',
                                                                             date.today(),'c','TestLoc','TestAvail',date.today()); 
        can.Email_Status__c = 'Active';
        update can;     
        (EZRE_MCEmailToAssignmentOwner.bounceEmailAddr) = new set<String>();
        (EZRE_MCEmailToAssignmentOwner.bounceEmailAddr).add('email1@gmail.com');
        
        test.starttest();        
            EZRE_MCEmailToAssignmentOwner.updateBouncedCand();
        test.stopTest();
    }
    
    ///<OBJECTIVE>
    ///Method to test updateUnsubCand method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testupdateUnsubCand_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
        
        //Create Candidate
        Candidate__c can = EZRE_DataFactory_Test_Utility.createCan('TestCandidate','testing','chennai','Maine','Male','testEmployee',
                                                                            'email1@gmail.com','Mobile Phone','Corp to Corp','H1 B',100,'9176904882',
                                                                            'email1@gmail.com','TestContact','8143847962','jyothi','(326) 044-6881',
                                                                             date.today(),'c','TestLoc','TestAvail',date.today()); 
        can.Email_Status__c = 'Active';
        update can;     
        (EZRE_MCEmailToAssignmentOwner.setEmlAddrss) = new set<String>();
        (EZRE_MCEmailToAssignmentOwner.setEmlAddrss).add('email1@gmail.com');
        
        test.starttest();        
            EZRE_MCEmailToAssignmentOwner.updateUnsubCand();
        test.stopTest();
    }
    
    ///<OBJECTIVE>
    ///Method to test sendMailToAssgnmntOwnr method with positive flow 
    ///</OBJECTIVE>
    public static testMethod void testsendMailToAssgnmntOwnr_Positive() 
    { 
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSetting('MCAccount','fda7477ace37fce','us9', 'A23545','f272fef804');
    
        test.starttest();        
            EZRE_MCEmailToAssignmentOwner.sendMailToAssgnmntOwnr();
        test.stopTest();
    }*/
}