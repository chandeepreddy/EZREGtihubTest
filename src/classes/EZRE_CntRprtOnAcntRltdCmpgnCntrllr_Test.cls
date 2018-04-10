/**
 * @author           Shahida
 * @version          1.0 
 * @date             28/09/2015
 * @Status           Developed
 * @description      Test class to test contact report functionality.
 *
 */
 @isTest
 public class EZRE_CntRprtOnAcntRltdCmpgnCntrllr_Test
 {
      ///<OBJECTIVE>
     //Method to test contacts report for ODS AWS campaign 
     ///</OBJECTIVE>
     static testmethod void oDSAWSCntctsRprt_Test()
     {
         //Insert force.com account
         Account account1 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert ODS.Net account
         Account account2 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,false,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert Contact record with Title Insurance checked    
        contact contact1 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName1','testCntctLName1',account1.Id,
                                                                  '9685742356','testTitle1','test@gmail.com',false,
                                                                  '3: Meeting Set',false,'3: Meeting Set',
                                                                  true,'3: Meeting Set','Bhaskaran Thangaraj');
                                                                  
        
        //Insert Contact record with ODS AWS checked                                          
        contact contact2 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName2','testCntctLName2',account2.Id,
                                                              '9685742356','testTitle1','test@gmail.com',false,
                                                              '3: Meeting Set',true,'3: Meeting Set',
                                                              false,'3: Meeting Set','Bhaskaran Thangaraj');     

         //Insert Account Related Campaign with campaign 'ODS AWS'
         Account_Related_Campaign__c  accntRltdCmgn1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','ODS AWS','Updated','Bhaskaran Thangaraj');
         
         //Insert Account Related Campaign with campaign 'Title Insurance'
         Account_Related_Campaign__c  accntRltdCmgn2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','Title Insurance','Updated','Sen Poulami');
     
         Test.startTest();
         EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr contactReportobj=new EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr();
         contactReportobj.getCampaigns();
         contactReportobj.getrepNames();
         contactReportobj.selectedRep='Bhaskaran Thangaraj';
         contactReportobj.selectedCampaign='ODS AWS';
         contactReportobj.mandatoryCheck();
         Test.stopTest();
         
        
     }
      ///<OBJECTIVE>
     //Method to test contacts report for title insurance campaign 
     ///</OBJECTIVE>
     static testmethod void TtlInsurncCntctsRprt_Test()
     {
         //Insert force.com account
         Account account1 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert ODS.Net account
         Account account2 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,false,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert Contact record with Title Insurance checked    
        contact contact1 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName1','testCntctLName1',account1.Id,
                                                                  '9685742356','testTitle1','test@gmail.com',false,
                                                                  '3: Meeting Set',true,'3: Meeting Set',
                                                                  false,'3: Meeting Set','Bhaskaran Thangaraj');
                                                                  
        
        //Insert Contact record with ODS AWS checked                                          
        contact contact2 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName2','testCntctLName2',account2.Id,
                                                              '9685742356','testTitle1','test@gmail.com',false,
                                                              '3: Meeting Set',false,'3: Meeting Set',
                                                              true,'3: Meeting Set','Bhaskaran Thangaraj');     

         //Insert Account Related Campaign with campaign 'ODS AWS'
         Account_Related_Campaign__c  accntRltdCmgn1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','ODS AWS','Updated','Bhaskaran Thangaraj');
         
         //Insert Account Related Campaign with campaign 'Title Insurance'
         Account_Related_Campaign__c  accntRltdCmgn2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','Title Insurance','Updated','Sen Poulami');
     
         Test.startTest();
         EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr contactReportobj=new EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr();
         contactReportobj.getCampaigns();
         contactReportobj.getrepNames();
         contactReportobj.selectedRep='Bhaskaran Thangaraj';
         contactReportobj.selectedCampaign='Title Insurance';
         contactReportobj.mandatoryCheck();
         Test.stopTest();
         
     
     }
      ///<OBJECTIVE>
     //Method to test Campaign mandatory check 
     ///</OBJECTIVE>
      static testmethod void cammpaignMandatoryCheck_Test()
     {
         //Insert force.com account
         Account account1 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert ODS.Net account
         Account account2 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,false,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert Contact record with Title Insurance checked    
        contact contact1 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName1','testCntctLName1',account1.Id,
                                                                  '9685742356','testTitle1','test@gmail.com',false,
                                                                  '3: Meeting Set',true,'3: Meeting Set',
                                                                  false,'3: Meeting Set','Bhaskaran Thangaraj');
                                                                  
        
        //Insert Contact record with ODS AWS checked                                          
        contact contact2 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName2','testCntctLName2',account2.Id,
                                                              '9685742356','testTitle1','test@gmail.com',false,
                                                              '3: Meeting Set',false,'3: Meeting Set',
                                                              true,'3: Meeting Set','Bhaskaran Thangaraj');     

         //Insert Account Related Campaign with campaign 'ODS AWS'
         Account_Related_Campaign__c  accntRltdCmgn1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','ODS AWS','Updated','Bhaskaran Thangaraj');
         
         //Insert Account Related Campaign with campaign 'Title Insurance'
         Account_Related_Campaign__c  accntRltdCmgn2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','Title Insurance','Updated','Sen Poulami');
     
         Test.startTest();
         EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr contactReportobj=new EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr();
         contactReportobj.getCampaigns();
         contactReportobj.getrepNames();
         contactReportobj.selectedRep='None';
         contactReportobj.selectedCampaign='Title Insurance';
         contactReportobj.mandatoryCheck();
         Test.stopTest();
         
        System.assertEquals(0,contactReportobj.contactsListToShow.size());
     }
     ///<OBJECTIVE>
     //Method to test repName mandatory check 
     ///</OBJECTIVE>
      static testmethod void repNameMandatoryCheck_Test()
     {
         //Insert force.com account
         Account account1 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert ODS.Net account
         Account account2 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,false,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert Contact record with Title Insurance checked    
        contact contact1 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName1','testCntctLName1',account1.Id,
                                                                  '9685742356','testTitle1','test@gmail.com',false,
                                                                  '3: Meeting Set',true,'3: Meeting Set',
                                                                  false,'3: Meeting Set','Bhaskaran Thangaraj');
                                                                  
        
        //Insert Contact record with ODS AWS checked                                          
        contact contact2 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName2','testCntctLName2',account2.Id,
                                                              '9685742356','testTitle1','test@gmail.com',false,
                                                              '3: Meeting Set',false,'3: Meeting Set',
                                                              true,'3: Meeting Set','Bhaskaran Thangaraj');     

         //Insert Account Related Campaign with campaign 'ODS AWS'
         Account_Related_Campaign__c  accntRltdCmgn1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','ODS AWS','Updated','Bhaskaran Thangaraj');
         
         //Insert Account Related Campaign with campaign 'Title Insurance'
         Account_Related_Campaign__c  accntRltdCmgn2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','Title Insurance','Updated','Sen Poulami');
     
         Test.startTest();
         EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr contactReportobj=new EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr();
         contactReportobj.getCampaigns();
         contactReportobj.getrepNames();
         contactReportobj.selectedRep='Bhaskaran Thangaraj';
         contactReportobj.selectedCampaign='None';
         contactReportobj.mandatoryCheck();
         Test.stopTest();
         
        System.assertEquals(0,contactReportobj.contactsListToShow.size());
     }
     ///<OBJECTIVE>
     ///Method to test export excle functionality.
     ///</OBJECTIVE>
      static testmethod void exportExcelCheck_Test()
     {
         //Insert force.com account
         Account account1 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,true,'Bhaskaran Thangaraj','1: Calling',false,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert ODS.Net account
         Account account2 = EZRE_DataFactory_Test_Utl.createAccnt('Boingo',100,false,'Bhaskaran Thangaraj','1: Calling',true,'Sen Poulami','1: Calling','www.yahoo.com', 'Suspect');
        
        //Insert Contact record with Title Insurance checked    
        contact contact1 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName1','testCntctLName1',account1.Id,
                                                                  '9685742356','testTitle1','test@gmail.com',false,
                                                                  '3: Meeting Set',true,'3: Meeting Set',
                                                                  false,'3: Meeting Set','Bhaskaran Thangaraj');
                                                                  
        
        //Insert Contact record with ODS AWS checked                                          
        contact contact2 = EZRE_DataFactory_Test_Utl.createContact('testCntctFName2','testCntctLName2',account2.Id,
                                                              '9685742356','testTitle1','test@gmail.com',false,
                                                              '3: Meeting Set',false,'3: Meeting Set',
                                                              true,'3: Meeting Set','Bhaskaran Thangaraj');     

         //Insert Account Related Campaign with campaign 'ODS AWS'
         Account_Related_Campaign__c  accntRltdCmgn1=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','ODS AWS','Updated','Bhaskaran Thangaraj');
         
         //Insert Account Related Campaign with campaign 'Title Insurance'
         Account_Related_Campaign__c  accntRltdCmgn2=EZRE_DataFactory_Test_Utl.createAccntRltdCmpgn(account1.Id,'1: Calling','Title Insurance','Updated','Sen Poulami');
     
         Test.startTest();
         EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr contactReportobj=new EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr();
         contactReportobj.getCampaigns();
         contactReportobj.getrepNames();
         contactReportobj.selectedRep='Bhaskaran Thangaraj';
         contactReportobj.selectedCampaign='Title Insurance';
         contactReportobj.mandatoryCheck();
         contactReportobj.exportReport();
         Test.stopTest();
       
     }
 }