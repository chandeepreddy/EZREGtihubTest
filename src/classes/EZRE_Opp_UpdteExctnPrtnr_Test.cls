/*
*@author        Indumathi
*@Version       1.0
*@date          22-03-2016
*description    Test class for EZRE_Opp_UpdteExctnPrtnr trigger
*/
@isTest
public class EZRE_Opp_UpdteExctnPrtnr_Test
{
   
   
    ///<OBJECTIVE>
    ///Test Method to test Opportunity Execution Partner field insertion from Account 
    ///</OBJECTIVE>
    static testMethod void EZRE_Opp_UpdteExctnPrtnr_PositiveTest()
    {       
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAcctwthClntPrtnr('TestAccount','Active Customer',Userinfo.getUserId(),'www.faparentTest.com');
       
        
        
        test.startTest();        
        //Insert Opportunities
        Opportunity objOpp1 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp1',objAcnt.Id, Date.Today()+5,'Demo - IN');      
        Opportunity objOpp2 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp2',objAcnt.Id, Date.Today()+9,'Diagnostics - IN');        
       
        test.StopTest();

        Account acc = [Select Id, Name, Client_Partner__c from Account where Id =: objAcnt.Id];
        Opportunity opp = [Select Id, Name, Execution_Partner__c from Opportunity where Id =: objOpp1.Id];
        
        //System.assertEquals(opp.Execution_Partner__c,acc.Client_Partner__c);
        
        
    }
    
    ///<OBJECTIVE>
    ///Test Method to test Opportunity Execution Partner field insertion from Account 
    ///</OBJECTIVE>
    static testMethod void EZRE_Opp_UpdteExctnPrtnr_NegativeTest()
    {       
        //Insert Account
        Account objAcnt = EZRE_DataFactory_Test_Utility.createAcctwthClntPrtnr('TestAccount','Active Customer',null,'www.faparentTest.com');
       
        
        test.startTest();        
        //Insert Opportunities
        Opportunity objOpp1 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp1',objAcnt.Id, Date.Today()+5,'Demo - IN');      
        Opportunity objOpp2 = EZRE_DataFactory_Test_Utility.createOpp('TestOpp2',objAcnt.Id, Date.Today()+9,'Diagnostics - IN');        
       
        test.StopTest();

        Account acc = EZRE_DataFactory_Test_Utility.fetchAccount(objAcnt.Id);
        Opportunity opp = EZRE_DataFactory_Test_Utility.fetchOpp(objOpp1.Id);
        
        //System.assertEquals(opp.Execution_Partner__c,null);
        
        
    }
    
 }