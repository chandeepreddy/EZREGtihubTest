@isTest
private class TestFollowUpDate 
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
            can.email__c='test@gmail.com';
            can.interview_contact_phone__c='Mobile Phone';
            can.contract_type__c='w2';
            can.visa_type__c='H1 B';
            can.cost__c =100;
            can.mobile_phone_no__c='9890043500';
            can.employer_contact_email__c='test@gmail.com';
            can.Employer_Contact_Name_Name__c='tt';
            can.Employer_Mobile_No__c='9988009876';

            insert can;
          
    Note n = new Note();
    
    can.Notes__c = 'test notes';
    can.Followup_Date__c = System.now().date();
    update can;
    
    n.ParentId = can.Id;
    n.Title = can.Notes__c;
    n.Body = can.Notes__c;   
    insert n; 
    
    System.assertEquals(n.ParentId, can.id);
    
    
 }
 }