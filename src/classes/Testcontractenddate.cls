@isTest
private class Testcontractenddate
{
static testMethod void myTestdisplay()
{   
    Candidate__c can=new Candidate__c();

            can.Name='test';
            can.last_name__c='testone';
            can.current_city__c='chennai';
            can.current_state__c='Maine';
            can.gender__c='Male';
            can.Employer_Name__c='ttt';
            can.email__c='testtestthirduser@testOrg.com';
            can.interview_contact_phone__c='Mobile Phone';
            can.contract_type__c='w2';
            can.visa_type__c='H1 B';
            can.cost__c =100;
            can.mobile_phone_no__c='9890043500';
            can.employer_contact_email__c='test@gmail.com';
            can.Employer_Contact_Name_Name__c='tt';
            can.Employer_Mobile_No__c='9988009876';

            insert can;
             
    Candidate_mapping__c cm = new candidate_mapping__c();
    
   
    
    requirement__c rc1 = new requirement__c();
    rc1.Name='SampathReq1';
    //rc1.Job_Title__c='.net1';
    rc1.Duration__c='6';
    rc1.No_Of_Resumes__c=2;
    rc1.Min_Cost__c=100;
    rc1.Max_Cost__c=200;
    rc1.Rate__c=200;
    rc1.Rate_Basis__c='Hourly';
    rc1.Status__c='open';
    rc1.Position_Type__c='Contract';
    rc1.State__c='CA';
    rc1.City__c='CA';
    rc1.Est_Start_Date__c=date.today(); 
    insert rc1;
    
    cm.candidate__c = can.id;
    cm.lr_status__c ='approved';
    cm.mr_status__c ='approved';
    cm.Employer_s_Authorization__c = 'test';
    cm.requirement__c = rc1.id;
   
    insert cm;
    
     can.contract_end_date__c = date.today();
     can.email__c='testtestfouthuser@testOrg.com';
     can.mobile_phone_no__c='9042508058';
     
    update can;
    
    candidate_mapping__c cm1 = [select id,candidate__c, requirement__c,status1__c from candidate_mapping__c where id=: cm.id];
     
     cm1.contract_end_date__c =date.today();
     update cm1;
     
    System.assertEquals(cm1.candidate__c, can.id);
 }
 }