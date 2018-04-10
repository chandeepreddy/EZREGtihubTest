@isTest
private class TestCandidatestarted
{
      static testMethod void myTestdisplay()
          {
                Candidate_Mapping__c cm = new Candidate_Mapping__c();

                Candidate__c cc1=new Candidate__c();
                        
                cc1.Name='test';
                cc1.Last_name__c='testthree';
                cc1.Current_city__c='chennai';
                cc1.Current_state__c='Maine';
                cc1.Gender__c='Male';
                cc1.Employer_Name__c='ttt';
                cc1.Email__c='testfifthuser@testpreludeOrg.com';
                cc1.interview_contact_phone__c='Mobile Phone';
                cc1.Contract_type__c='Corp to Corp';
                cc1.visa_type__c='H1 B';
                cc1.cost__c =100;
                cc1.mobile_phone_no__c='9443322110';
                cc1.employer_contact_email__c='test@gmail.com';
                cc1.Employer_Contact_Name_Name__c='tt';
                cc1.Employer_Mobile_No__c='9988009876';       
                cc1.Employer_Name__c = 'jos'; 
                cc1.Employer_Work_Phone_No__c = '(425) 264-6771';              
                cc1.Followup_Date__c =date.today();              
                    
             System.test.startTest();
                insert cc1;          
                cm.Candidate__c=cc1.id;
                system.debug('candid:'+cc1.id);
            
                Requirement__c rc1=new Requirement__c();
            
                rc1.Name='SampathReq1';
                //rc1.Job_Title__c='.net1';
                //rc1.Client__c ='abc company';
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
                cm.Requirement__c=rc1.id;
                system.debug('candid:'+cc1.id);  

                cm.Employer_s_Authorization__c = 'test';
                cm.status1__c = 'Applied';  
                cm.LR_Comments__c = 'test by lr';
                cm.MR_Comments__c = 'test by MR'; 
                cm.Requirement_Owner_Email__c = 'testOwner@preludesys.com';
                cm.Manager_Email_ID__c = 'testOwner1@preludesys.com';
                cm.LR_Status__c = 'Approved'; 
                cm.MR_Status__c = 'Approved'; 
                cm.LR_Status_Date__c = string.valueOf(date.today());              
                cm.Submitted_to_Client__c = 'Yes'; 
                cm.Interview_Scheduled__c = 'Yes'; 
                cm.Interview_Accepted__c = 'Yes'; 
                cm.Client_Interviewed__c = 'Yes'; 
                cm.Client_Offered__c = 'Yes'; 
                cm.Comments__c = '';  
                cm.MR_Status1__c = 'Approved' ;

                User user = [Select Id from User limit 1] ; //where Email= 'gopalmr140313@gmail.com'];
             
                EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Candidate Approval Email with link EZRE'];            
                List<ContentVersion> contentList = new List<ContentVersion>();
           

                ContentWorkspace library = [SELECT id FROM ContentWorkspace LIMIT 1];
                System.Debug('library.id:'+ library.id);    

                ContentVersion contentVersionObj = new ContentVersion();          
  
                contentVersionObj.title = 'Google';//contentVersionObj.Enablement_Area__c = 'Acct Mgmt';       
                contentVersionObj.FirstPublishLocationId = library.id;       
                contentVersionObj.Candidate_Id__c = cc1.Id; 
                contentVersionObj.VersionData = Blob.valueOf('Ayangar') ; 
                contentVersionObj.PathOnclient = 'http://www.google.com';
                contentVersionObj.Title ='Management Approach';  
           
                insert contentVersionObj;     
                System.Debug('ContentVersionObj:'+ contentVersionObj);
           
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Sasikumar.Word');
                efa.setBody(Blob.ValueOf(et.Body));    
                System.Debug('efa:' +efa);    
                String[] toAddresses = new string[]{'dummy@yahoo.com'};
             mail.setTargetObjectId(user.Id);
                mail.setToAddresses(toAddresses);            

             //   mail.setSenderDisplayName('Charan Tej');
    
                mail.setTemplateId(et.Id);          
         
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                mail.saveAsActivity = false;
                // Sends the email
                Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
               //     
//System.test.startTest();                         
                insert cm;

                Candidate_Mapping__c coa1 = [Select Id,Status1__c, LR_Status__c, MR_Status__c from Candidate_Mapping__c where Candidate__c =: cc1.Id and Requirement__c  =: rc1.id limit 1];      

                coa1.Candidate_started__c = 'Yes'; 
                coa1.Status1__c = 'Candidate started';

                update coa1;

                rc1.won__c = true;

                update rc1;


                cc1.Placed__c = true;

                cc1.Star_candidate__c = true;
                cc1.Email__c ='testsixthuser@testpreludeOrg.com';
                cc1.mobile_phone_no__c = '9705703456';
                update cc1;
                 System.test.stopTest();

          }
}