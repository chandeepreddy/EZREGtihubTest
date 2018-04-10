/*
*@author        Indumathi
*@Version       1.0
*@date          15-03-2016
*description    Test class for EZRE_AccountReportExtnsnCntrllr
*/
@isTest
public class EZRE_AccountReportExtnsnCntrllr_Test
{
   
    ///<OBJECTIVE>
    ///Test Method to test Constructor 
    ///</OBJECTIVE>
    static testMethod void EZRE_AccountReport_Cnstr_Test()
    {
       
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAccount('TestAccount','Active Customer','www.faparentTest.com');
        
        //Insert contact
        Contact objCnt1 = EZRE_DataFactory_Test_Utility.crtCntcWithoutRprtsTo('Test1','Contact',objAcnt.id);
        Contact objCnt2 = EZRE_DataFactory_Test_Utility.createContact('Test2','contact2',objAcnt.id,objCnt1.Id);
        Contact objCnt3 = EZRE_DataFactory_Test_Utility.createContact('Test3','contact3',objAcnt.id,objCnt1.Id);      
       
       
        test.startTest();
            PageReference pageRef = new PageReference('/apex/EZRE_AccountReport');
            pageRef.getParameters().put('id',objAcnt.id);
            System.Test.setCurrentPage(pageref);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAcnt);
            EZRE_AccountReportExtnsnCntrllr objStndrdCntrllr = new EZRE_AccountReportExtnsnCntrllr(sc);           
           
        test.StopTest();
        system.assertNotEquals(null,objAcnt.Id);
        System.assertEquals(objStndrdCntrllr.cntctLst.size(),3);
    }
    
    ///<OBJECTIVE>
    ///Test Method to test Opportunity List Positive scenario 
    ///</OBJECTIVE>
    static testMethod void EZRE_AccountReport_OpportunityList_PositiveTest()
    {       
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAccount('TestAccount','Active Customer','www.faparentTest.com');
        
        //Insert Opportunities
        Opportunity objOpp1 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp1',objAcnt.Id, Date.Today()+5,'Demo - IN');      
        Opportunity objOpp2 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp2',objAcnt.Id, Date.Today()+9,'Diagnostics - IN');
        
        test.startTest();
           PageReference pageRef = new PageReference('/apex/EZRE_AccountReport');
            pageRef.getParameters().put('id',objAcnt.id);
            System.Test.setCurrentPage(pageref);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAcnt);
            EZRE_AccountReportExtnsnCntrllr objStndrdCntrllr = new EZRE_AccountReportExtnsnCntrllr(sc); 
        test.StopTest();

        System.assertEquals(objStndrdCntrllr.oppLst.size(),0);
        
        
    }
    
    
    
    ///<OBJECTIVE>
    ///Test Method to test Opportunity List for negative scenario 
    ///</OBJECTIVE>
    static testMethod void EZRE_AccountReport_OpportunityList_NegativeTest()
    {       
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAccount('TestAccount','Active Customer','www.faparentTest.com');
        
        //Insert Opportunities
        Opportunity objOpp1 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp1',objAcnt.Id, Date.Today()+5,'Qualification');
        Opportunity objOpp2 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp2',objAcnt.Id, Date.Today()+10,'Qualification');
        
        test.startTest();
            PageReference pageRef = new PageReference('/apex/EZRE_AccountReport');
            pageRef.getParameters().put('id',objAcnt.id);
            System.Test.setCurrentPage(pageref);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAcnt);
            EZRE_AccountReportExtnsnCntrllr objStndrdCntrllr = new EZRE_AccountReportExtnsnCntrllr(sc); 
        test.StopTest(); 
        
        System.assertEquals(objStndrdCntrllr.oppLst.size(),2);         
        
    }
    
    ///<OBJECTIVE>
    ///Test Method to test Initiative List
    ///</OBJECTIVE>
    static testMethod void EZRE_AccountReport_IntveLst_Test()
    {   
        //Insert Account
        Account objAcnt1 = EZRE_DataFactory_Test_Utility.createAccount('TestAccount1','Active Customer','www.faparentTest.com');
        
        //Insert Account
        Account objAcnt2 = EZRE_DataFactory_Test_Utility.createAccount('TestAccount2','Active Customer','www.faTest.com');
        
        //Insert Initiatives
        Initiative__c objIntve1 = EZRE_DataFactory_Test_Utility.createInitiative('TestIntve',objAcnt1.Id);
        Initiative__c objIntve2 = EZRE_DataFactory_Test_Utility.createInitiative('TestIntve',objAcnt1.Id);
        Initiative__c objIntve3 = EZRE_DataFactory_Test_Utility.createInitiative('TestIntve',objAcnt2.Id);
        
        test.startTest();
            PageReference pageRef = new PageReference('/apex/EZRE_AccountReport');
            pageRef.getParameters().put('id',objAcnt1.id);
            System.Test.setCurrentPage(pageref);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAcnt1);
            EZRE_AccountReportExtnsnCntrllr objStndrdCntrllr = new EZRE_AccountReportExtnsnCntrllr(sc);             
            
        test.StopTest();
        System.assertEquals(objStndrdCntrllr.initveLst.size(),2 );
        
    }   
    
    ///<OBJECTIVE>
    ///Test Method to test Activity Wrapper List 
    ///</OBJECTIVE>
    static testMethod void EZRE_AccountReport_ActivityList_Test()
    {       
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAccount('TestAccount','Active Customer','www.faparentTest.com');
        
        //Insert contact
        Contact objCnt1 = EZRE_DataFactory_Test_Utility.crtCntcWithoutRprtsTo('Test1','Contact',objAcnt.id);
        Contact objCnt2 = EZRE_DataFactory_Test_Utility.createContact('Test2','contact2',objAcnt.id,objCnt1.Id);
        Contact objCnt3 = EZRE_DataFactory_Test_Utility.createContact('Test3','contact3',objAcnt.id,objCnt1.Id);
       
        //Insert Task
        Task objTsk1 = EZRE_DataFactory_Test_Utility.createTask('TestTask1',objCnt1.id,Date.Today()+4,'Not Started');
        Task objTsk2 = EZRE_DataFactory_Test_Utility.createTask('TestTask2',objCnt2.id,Date.Today()-5,'Completed');
        Task objTsk3 = EZRE_DataFactory_Test_Utility.createTask('TestTask3',objCnt3.id,Date.Today()-40,'In Progress');
        
        //Insert Event
        Event objEvnt1 = EZRE_DataFactory_Test_Utility.createEvent('Call',Date.Today()+4,UserInfo.getUserId(),objCnt1.Id);
        Event objEvnt2 = EZRE_DataFactory_Test_Utility.createEvent('Call',Date.Today()-5,UserInfo.getUserId(),objCnt2.Id);
        Event objEvnt3 = EZRE_DataFactory_Test_Utility.createEvent('Call',Date.Today()-40,UserInfo.getUserId(),objCnt3.Id);
       
        test.startTest();
            PageReference pageRef = new PageReference('/apex/EZRE_AccountReport');
            pageRef.getParameters().put('id',objAcnt.id);
            System.Test.setCurrentPage(pageref);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAcnt);
            EZRE_AccountReportExtnsnCntrllr objStndrdCntrllr = new EZRE_AccountReportExtnsnCntrllr(sc);             
        test.StopTest();
        System.assertEquals(objStndrdCntrllr.lstWrppr.size(),2);
        
    }
    
    ///<OBJECTIVE>
    ///Test Method to test Contact Hierarchy List 
    ///</OBJECTIVE>
    static testMethod void EZRE_AccountReport_ContactHierarchy_Test()
    {       
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAccount('TestAccount','Active Customer','www.faparentTest.com');
        
        //Insert contacts
        //Grand Parent
        Contact objCnt1 = EZRE_DataFactory_Test_Utility.crtCntcWithoutRprtsTo('Test1','Contact',objAcnt.id);
        Contact objCnt2 = EZRE_DataFactory_Test_Utility.crtCntcWithoutRprtsTo('Test2','Contact',objAcnt.id);
        //Parent
        Contact objCnt11 = EZRE_DataFactory_Test_Utility.createContact('Test11','contact11',objAcnt.id,objCnt1.Id);
        Contact objCnt12 = EZRE_DataFactory_Test_Utility.createContact('Test12','contact12',objAcnt.id,objCnt1.Id);
        //Child
        Contact objCnt21 = EZRE_DataFactory_Test_Utility.createContact('Test21','contact21',objAcnt.id,objCnt2.Id);        
        Contact objCnt22 = EZRE_DataFactory_Test_Utility.createContact('Test22','contact22',objAcnt.id,objCnt2.Id);
        
        //GrandChild
        Contact objCnt111 = EZRE_DataFactory_Test_Utility.createContact('Test23','contact23',objAcnt.id,objCnt11.Id);
        Contact objCnt221 = EZRE_DataFactory_Test_Utility.createContact('Test24','contact24',objAcnt.id,objCnt21.Id);       
    
       
        test.startTest();
            PageReference pageRef = new PageReference('/apex/EZRE_AccountReport');
            pageRef.getParameters().put('id',objAcnt.id);
            System.Test.setCurrentPage(pageref);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAcnt);
            EZRE_AccountReportExtnsnCntrllr objStndrdCntrllr = new EZRE_AccountReportExtnsnCntrllr(sc); 
            objStndrdCntrllr.getOrgChart(objAcnt.Id);
            objStndrdCntrllr.getHrchyWrppr();
            
        test.StopTest();
        System.assertEquals(objStndrdCntrllr.lstHrchyWrppr.size(),2);
        
    }
    
    ///<OBJECTIVE>
    ///Test Method to test Export PDF button action
    ///</OBJECTIVE>
    static testMethod void EZRE_AccountReport_ExportPDF_Test()
    {   
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAccount('TestAccount','Active Customer','www.faparentTest.com');
        test.startTest();
            PageReference pageRef = new PageReference('/apex/EZRE_AccountReport');
            pageRef.getParameters().put('id',objAcnt.id);
            System.Test.setCurrentPage(pageref);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAcnt);
            EZRE_AccountReportExtnsnCntrllr objStndrdCntrllr = new EZRE_AccountReportExtnsnCntrllr(sc); 
            objStndrdCntrllr.exportAsPDF();
            
        test.StopTest();
        
    }   
   
}