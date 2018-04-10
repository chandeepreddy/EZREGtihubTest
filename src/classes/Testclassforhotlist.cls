@isTest
private class Testclassforhotlist
 {  
    ///OBJECTIVE
    /// Test Method for Hot List Class.
    ///OBJECTIVE
    static testmethod void HotList_Test() 
    {      
        Candidate__c objCand = new Candidate__c();        
        objCand.Name = 'test';
        objCand.Last_name__c = 'testone';
        objCand.Current_city__c = 'chennai';
        objCand.Current_state__c = 'Maine';
        objCand.Gender__c = 'Male';
        objCand.Employer_Name__c = 'TestEmploye';
        objCand.Email__c = 'test@gmail.com';
        objCand.interview_contact_phone__c = 'Mobile Phone';
        objCand.Contract_type__c = 'w2';
        objCand.visa_type__c = 'H1 B';
        objCand.cost__c = 100;
        objCand.mobile_phone_no__c = '9890043500';
        objCand.employer_contact_email__c = 'test@gmail.com';
        objCand.Employer_Contact_Name_Name__c = 'TestEmp';
        objCand.Employer_Mobile_No__c = '9988009876';                                
        objCand.bench__c = true;
        objCand.Relocation__c = 'test';
        objCand.Availability__c = 'testone';
        objCand.Skills__c = 'asp.net,c#,java';
        insert objCand;   
        
        EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Hotlist Report'];
        
        EZRE_HotListUsers__c objHotList = new EZRE_HotListUsers__c();
        objHotList.Name = 'HotListReportMail';
        objHotList.HotList_CCUsers__c = 'test@testmail.com';
        objHotList.HotList_toUsers__c = 'indhu@testmail.com';        
        insert objHotList;        
        
        Test.startTest();
        HotListClass objHotListCls = new HotListClass();             
        Test.stopTest();
    
    }
}