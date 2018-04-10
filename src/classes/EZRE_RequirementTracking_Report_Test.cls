/*
 * @author           Gangadhar R
 * @version          1.0 
 * @date             03/03/2016
 * @Modified By      Shahida K on 06.05.2016 
 * @description      Test class for EZRE_RequirementTracking_Report
 */  
@IsTest
public class EZRE_RequirementTracking_Report_Test
{
     /// <OBJECTIVE>
    /// Method is to Test the RunReport Method.
    /// </OBJECTIVE> 
   public static testmethod void  runReportPositive_Test()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt = EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
        RequirementAssignment__c objAssReq =EZRE_DataFactory_Test_Utl.createAssgnReq(objReqmt.Id); 
        //Insert Candidate
         Candidate__c objCand=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
        //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','Yes','Yes','TestComments',Date.Today()-1,objReqmt.Id,objCand.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());
                                                                     
        EZRE_RequirementTracking_Report insideRepobj = new EZRE_RequirementTracking_Report();
        insideRepobj.dtFromDate= Date.newInstance(2016 , 02 ,20);
        insideRepobj.dtToDate = date.Today().addDays(1);
        datetime dtFromDateTime= datetime.newInstance(insideRepobj.dtFromDate.year(),insideRepobj.dtFromDate.month(),insideRepobj.dtFromDate.day());
        datetime dtToDateTime = datetime.newInstance( insideRepobj.dtToDate.year(),insideRepobj.dtToDate.month(),insideRepobj.dtToDate.day());
        insideRepobj.strFilterValue = 'CreatedDate';
        insideRepobj.RunReport();
        insideRepobj.getFilterValues();
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);        
        test.stopTest();
        
   } 
      /// <OBJECTIVE>
    /// Method is to Test the RunReport Method.
    /// </OBJECTIVE> 
   public static testmethod void  runReportOwner_Test()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt1 = EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
                                                                              
        RequirementAssignment__c objAssReq =EZRE_DataFactory_Test_Utl.createAssgnReq(objReqmt1.Id);   
        //Insert Candidate
         Candidate__c objCand1=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
        //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','Yes','No','TestComments',Date.Today()-1,objReqmt1.Id,objCand1.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());
        
        EZRE_RequirementTracking_Report insideRepobj = new EZRE_RequirementTracking_Report();
        insideRepobj.dtFromDate= Date.newInstance(2016 , 02 ,20);
        insideRepobj.dtToDate = date.Today().addDays(1);
        datetime dtFromDateTime= datetime.newInstance(insideRepobj.dtFromDate.year(),insideRepobj.dtFromDate.month(),insideRepobj.dtFromDate.day());
        datetime dtToDateTime = datetime.newInstance( insideRepobj.dtToDate.year(),insideRepobj.dtToDate.month(),insideRepobj.dtToDate.day());
        insideRepobj.strFilterValue = 'Owner.name';
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.RunReport();    
        test.stopTest();
        
   } 
    /// <OBJECTIVE>
    /// Method is to Test the RunReport Method.
    /// </OBJECTIVE> 
   public static testmethod void  runReportPostiveTodate_Test()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt2 = EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
        RequirementAssignment__c objAssReq = EZRE_DataFactory_Test_Utl.createAssgnReq(objReqmt2.Id);  
        //Insert Candidate
         Candidate__c objCand2=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
        //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','No','No','TestComments',Date.Today()-1,objReqmt2.Id,objCand2.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());
        
        EZRE_RequirementTracking_Report insideRepobj = new EZRE_RequirementTracking_Report();
        insideRepobj.dtFromDate= Date.newInstance(2016,02,20);
        insideRepobj.dtToDate = date.Today();
        insideRepobj.strFilterValue = 'Name';
        datetime dtFromDateTime= datetime.newInstance(insideRepobj.dtFromDate.year(),insideRepobj.dtFromDate.month(),insideRepobj.dtFromDate.day());
        datetime dtToDateTime = datetime.newInstance( insideRepobj.dtToDate.year(),insideRepobj.dtToDate.month(),insideRepobj.dtToDate.day());
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.RunReport();
        insideRepobj.ExportAsCSV();     
        insideRepobj.hideTable();
        Test.StopTest();
        
   }
    /// <OBJECTIVE>
    /// Method is to Test the RunReport Method.
    /// </OBJECTIVE> 
   public static testmethod void  runReportOrderStatus_Test()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt3 = EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
         RequirementAssignment__c objAssReq =       EZRE_DataFactory_Test_Utl.createAssgnReq(objReqmt3.Id);   
        //Insert Candidate
         Candidate__c objCand3=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
        //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','yes','No','TestComments',Date.Today()-1,objReqmt3.Id,objCand3.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());
        EZRE_RequirementTracking_Report insideRepobj = new EZRE_RequirementTracking_Report();
        insideRepobj.dtFromDate= Date.newInstance(2016 , 02 ,20);
        insideRepobj.dtToDate = date.Today();
        datetime dtFromDateTime= datetime.newInstance(insideRepobj.dtFromDate.year(),insideRepobj.dtFromDate.month(),insideRepobj.dtFromDate.day());
        datetime dtToDateTime = datetime.newInstance( insideRepobj.dtToDate.year(),insideRepobj.dtToDate.month(),insideRepobj.dtToDate.day());
        insideRepobj.strFilterValue = 'Status__c';
        insideRepobj.RunReport();
        insideRepobj.ExportAsCSV();
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.hideTable();
        Test.StopTest();
        
        
   }  
   /// <OBJECTIVE>
    /// Method is to Test the RunReport Method.
    /// </OBJECTIVE> 
   public static testmethod void  runReportCSVTodate_Test()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt4 = EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
        RequirementAssignment__c objAssReq =EZRE_DataFactory_Test_Utl.createAssgnReq(objReqmt4.Id);   
        //Insert Candidate
         Candidate__c objCand4=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
        //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','No','No','TestComments',Date.Today()-1,objReqmt4.Id,objCand4.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());
        
        PageReference pageRef = Page.EZRE_RequirementStatusReportAsCSV;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('FromDate', string.valueof(Date.Today().addDays(-1)));
        ApexPages.currentPage().getParameters().put('ToDate', string.valueof(Date.Today()));
        ApexPages.currentPage().getParameters().put('Filter', 'Name');
        Date fromDate=Date.Today().addDays(-1);
        Date toDate=Date.Today();
        
        EZRE_RequirementTracking_ReportAsCSV insideRepobj = new EZRE_RequirementTracking_ReportAsCSV();
        datetime dtFromDateTime= datetime.newInstance(fromDate.year(),fromDate.month(),fromDate.day());
        datetime dtToDateTime = datetime.newInstance(toDate.year(),toDate.month(),toDate.day());
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.RunReport();
        Test.StopTest();
    
   } 
   /// <OBJECTIVE>
    /// Method is to Test the RunReport Method.
    /// </OBJECTIVE> 
   public static testmethod void  runReportCSVOwner_Test()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt5= EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
       RequirementAssignment__c objAssReq =EZRE_DataFactory_Test_Utl.createAssgnReq(objReqmt5.Id);   
        //Insert Candidate
         Candidate__c objCand5=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
        //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','yes','yes','TestComments',Date.Today()-1,objReqmt5.Id,objCand5.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());    
        
       PageReference pageRef = Page.EZRE_RequirementStatusReportAsCSV;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('FromDate', string.valueof(Date.Today().addDays(-5)));
        ApexPages.currentPage().getParameters().put('ToDate', string.valueof(Date.Today().addDays(-2)));
        ApexPages.currentPage().getParameters().put('Filter', 'Owner.name');
        EZRE_RequirementTracking_ReportAsCSV insideRepobj = new EZRE_RequirementTracking_ReportAsCSV();
        Date fromDate=Date.Today().addDays(-1);
        Date toDate=Date.Today();
        insideRepobj.RunReport();
        datetime dtFromDateTime= datetime.newInstance(fromDate.year(),fromDate.month(),fromDate.day());
        datetime dtToDateTime = datetime.newInstance(toDate.year(),toDate.month(),toDate.day());
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        Test.StopTest();
        
   } 
    /// <OBJECTIVE>
    /// Method is to Test the RunReport Method.
    /// </OBJECTIVE> 
   public static testmethod void  runReportCSVCreatedDate_Test()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt6= EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
       RequirementAssignment__c objAssReq =       EZRE_DataFactory_Test_Utl.createAssgnReq(objReqmt6.Id);   
       //Insert Candidate
         Candidate__c objCand6=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
        //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap = EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','yes','No','TestComments',Date.Today()-1,objReqmt6.Id,objCand6.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());    
       PageReference pageRef = Page.EZRE_RequirementStatusReportAsCSV;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('FromDate', string.valueof(Date.Today().addDays(-1)));
        ApexPages.currentPage().getParameters().put('ToDate', string.valueof(Date.Today()));
        ApexPages.currentPage().getParameters().put('Filter', 'status__c');
        EZRE_RequirementTracking_ReportAsCSV insideRepobj = new EZRE_RequirementTracking_ReportAsCSV();
        Date fromDate=Date.Today().addDays(-1);
        Date toDate=Date.Today();
        insideRepobj.RunReport();
        datetime dtFromDateTime= datetime.newInstance(fromDate.year(),fromDate.month(),fromDate.day());
        datetime dtToDateTime = datetime.newInstance(toDate.year(),toDate.month(),toDate.day());
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        Test.StopTest();
        
   }
      /// <OBJECTIVE>
    /// Method is to Test the MR approval Count functionality
    /// </OBJECTIVE> 
   public static testmethod void  unitTestforMrApporovalCount()
   {
        date dtStatusUpdatedate = system.today().addDays(-50);
        Test.StartTest();
        Requirement__c objReqmt6= EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');
                                                                              
        //fetch recruiter profile  
        Profile recruiterProfile=EZRE_DataFactory_Test_Utility.fetchProfileRec();   
        
        //Insert recruiter User
        User recruiter = EZRE_DataFactory_Test_Utility.createUser('Usr','testingUsr123@testorg.com','UTF-8',
                        'Usr','en_US','en_US',recruiterProfile.Id,
                        'America/Los_Angeles','TestingUsr123@testemail.com','1243847862');
                                    
        //Insert Requirement assignment                                                                   
        RequirementAssignment__c objAssReq =EZRE_DataFactory_Test_Utl.assgnReqToRecruiter(objReqmt6.Id,recruiter.Id);   
        
        //Insert Candidate
         Candidate__c objCand6=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');  
         //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap1= EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Approved','Approved','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','yes','No','TestComments',Date.Today()-1,objReqmt6.Id,objCand6.Id,Datetime.Now(),Datetime.Now(),Datetime.Now()); 
         //Insert Candidate Mapping                                               
         Candidate_Mapping__c objCandMap2= EZRE_DataFactory_Test_Utl.InsertCandidateMappingng('Applied','test','test by lr','test by MR',
        'testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
        'Approved','Approved','07/07/2015','07/07/2015','Yes','Yes','Yes',
        'Yes','yes','No','TestComments',Date.Today()-1,objReqmt6.Id,objCand6.Id,Datetime.Now(),Datetime.Now(),Datetime.Now());       
        
        EZRE_RequirementTracking_Report insideRepobj = new EZRE_RequirementTracking_Report();
        insideRepobj.dtFromDate= Date.newInstance(2016 , 02 ,20);
        insideRepobj.dtToDate = date.Today().addDays(1);
        datetime dtFromDateTime= datetime.newInstance(insideRepobj.dtFromDate.year(),insideRepobj.dtFromDate.month(),insideRepobj.dtFromDate.day());
        datetime dtToDateTime = datetime.newInstance( insideRepobj.dtToDate.year(),insideRepobj.dtToDate.month(),insideRepobj.dtToDate.day());
        insideRepobj.strFilterValue = 'CreatedDate';
        insideRepobj.RunReport();
        insideRepobj.getFilterValues();
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);
        insideRepobj.getCndMpngForResumeStatus(dtFromDateTime,dtToDateTime);        
        test.stopTest();
       
   }  
}