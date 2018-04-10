@isTest(seealldata=true)
private class TestTriggerStatusUpdate
 {   
  static testMethod void myUnitTest()
   {   
        Candidate_Mapping__c coa =new Candidate_Mapping__c();            
            coa.status1__c = 'Applied';
            coa.Employer_s_Authorization__c = 'test';  
            coa.LR_Comments__c = 'test by lr';
            coa.MR_Comments__c = 'test by MR'; 
            coa.Requirement_Owner_Email__c = 'testOwner1@preludesys.com';
            coa.Manager_Email_ID__c = 'testOwner1@preludesys.com';          
            coa.R_Comments__c = '';                      
            coa.LR_Status__c = 'Rejected'; 
            coa.MR_Status__c = 'Rejected'; 
            coa.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
            coa.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
            //coa.Req_Owner_Email__c ='testOwner1@preludesys.com';
            // coa.status1__c = 'Rejected';
           //coa.Manager_Email_ID__c = ac.Req_Owner_Email__c;   
            
            Candidate__c cc1=new Candidate__c();                        
            cc1.Name='test';
            cc1.Last_name__c='testone';
            cc1.Current_city__c='chennai';
            cc1.Current_state__c='Maine';
            cc1.Gender__c='Male';
            cc1.Employer_Name__c='ttt';
            cc1.Email__c='testOwnertestuser@preludeorg.com';
            cc1.interview_contact_phone__c='Mobile Phone';
            cc1.Contract_type__c='Corp to Corp';
            cc1.visa_type__c='H1 B';
            cc1.cost__c =100;
            cc1.mobile_phone_no__c='9912202474';
            cc1.employer_contact_email__c='test@gmail.com';
            cc1.Employer_Contact_Name_Name__c='tt';
            cc1.Employer_Mobile_No__c='9988009876';       
            cc1.Employer_Name__c = 'jos'; 
            cc1.Employer_Work_Phone_No__c = '(425) 264-6771';   
            cc1.Followup_Date__c =date.today();  
            insert cc1;          
            coa.Candidate__c=cc1.id;
            system.debug('candid:'+cc1.id);
            
            Requirement__c rc1=new Requirement__c();            
            rc1.Name='SampathReq';
            //rc1.Job_Title__c='.net';
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
            rc1.won__c = true;
            //rc1.won_text__c ='yes';            
            insert rc1;
            coa.Requirement__c=rc1.id;    
             
            
         insert coa;                   
         
   }
   static testMethod void myUnitTest1()
   {  
         
         Candidate_Mapping__c coa =new Candidate_Mapping__c();            
           // coa.status1__c = 'Applied';
            coa.Employer_s_Authorization__c = 'test';  
            coa.LR_Comments__c = 'test by lr';
            coa.MR_Comments__c = 'test by MR'; 
            coa.Requirement_Owner_Email__c = 'testOwner@preludesys.com';
            coa.Manager_Email_ID__c = 'testOwner@preludesys.com';          
            coa.R_Comments__c = '';                      
            coa.LR_Status__c = 'Approved'; 
            coa.MR_Status__c = 'Approved'; 
            coa.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            coa.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            coa.Submitted_to_Client__c = 'Yes'; 
            coa.Submitted_to_Client_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
            coa.Interview_Scheduled__c = 'Yes'; 
            coa.Interview_Scheduled_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');   
            coa.Interview_Accepted__c = 'Yes'; 
            coa.Interview_Accepted_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');       
            coa.Client_Interviewed__c = 'Yes'; 
            coa.Client_Interview_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');   
           //coa.status1__c = 'Client Interviewed';                               
            coa.Client_Offered__c = 'Yes';
            coa.Client_Offer_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');    
            coa.status1__c = 'Client Offered';    
            coa.Candidate_started__c = 'Yes'; 
            coa.Comments__c = '';  
            coa.MR_Status1__c = 'Approved' ;  
            coa.started_date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');     
           

 Candidate__c cc1=new Candidate__c();                        
            cc1.Name='test';
            cc1.Last_name__c='testone';
            cc1.Current_city__c='chennai';
            cc1.Current_state__c='Maine';
            cc1.Gender__c='Male';
            cc1.Employer_Name__c='ttt';
            cc1.Email__c='testOwner.testuser2@preludeorg.com';
            cc1.interview_contact_phone__c='Mobile Phone';
            cc1.Contract_type__c='Corp to Corp';
            cc1.visa_type__c='H1 B';
            cc1.cost__c =100;
            cc1.mobile_phone_no__c='9886034542';
            cc1.employer_contact_email__c='test@gmail.com';
            cc1.Employer_Contact_Name_Name__c='tt';
            cc1.Employer_Mobile_No__c='9988009876';       
            cc1.Employer_Name__c = 'jos'; 
            cc1.Employer_Work_Phone_No__c = '(425) 264-6771';   
            cc1.Followup_Date__c =date.today();  
            insert cc1;          
            coa.Candidate__c=cc1.id;
            system.debug('candid:'+cc1.id);
            
            Requirement__c rc1=new Requirement__c();            
            rc1.Name='SampathReq';
            //rc1.Job_Title__c='.net';
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
            rc1.won__c = true;
            //rc1.won_text__c ='yes';            
            insert rc1;
            coa.Requirement__c=rc1.id;
 

             User user = [Select Id from User limit 1] ; //where Email= 'gopalmr140313@gmail.com'];
             
           EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Candidate Approval Email with link EZRE'];            
           List<ContentVersion> contentList = new List<ContentVersion>();
           

           ContentWorkspace library = [SELECT id FROM ContentWorkspace LIMIT 1];
            System.Debug('library.id:'+ library.id);    
           /* contentList = [Select Id, ContentDocumentId,VersionData from ContentVersion where FirstPublishLocationId = :library.id];
           Blob strVersionData;
           for(ContentVersion cversion :contentList)
           {
               strVersionData = cversion.VersionData;
                          System.Debug('strVersionData:'+ strVersionData); 
           } */
           ContentVersion contentVersionObj = new ContentVersion();          
           //contentVersionObj.ContentURL = 'http://www.google.com';    
           contentVersionObj.title = 'Google';//contentVersionObj.Enablement_Area__c = 'Acct Mgmt';       
           contentVersionObj.FirstPublishLocationId = library.id;       
           contentVersionObj.Candidate_Id__c = cc1.Id; 
           contentVersionObj.VersionData = Blob.valueOf('Ayangar') ; 
           contentVersionObj.PathOnclient = 'http://www.google.com';
           contentVersionObj.Title ='Management Approach';  
          // contentVersionObj.ContentDocumentId = cv1.ContentDocumentId;  
             
           insert contentVersionObj;     
           System.Debug('ContentVersionObj:'+ contentVersionObj);
           
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
           efa.setFileName('Sasikumar.Word');
           efa.setBody(Blob.ValueOf(et.Body));
           //efa.setBody(Blob.valueOf('Ayangar')); 
           //efa.setContentType('.word'); //         
           System.Debug('efa:' +efa);    
           String[] toAddresses = new string[]{'dummy@yahoo.com'};
           mail.setTargetObjectId(user.Id);
           mail.setToAddresses(toAddresses);            
           //mail.setplaintextBody('plainbody');             
           
           mail.setSenderDisplayName('Charan Tej');
    
           mail.setTemplateId(et.Id);          
          // mail.setWhatId(c.Id);             
           mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
           mail.saveAsActivity = false;
                // Sends the email
           Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
           //                  
    
            
            insert coa;
            
            Candidate_Mapping__c coa1 = [Select Id,Status1__c, LR_Status__c, MR_Status__c, MR_Status1__c from Candidate_Mapping__c where Candidate__c =: cc1.Id and Requirement__c =: rc1.id limit 1];             
            coa1.Status1__c = 'Candidate started';
        //   coa.LR_Status__c = 'Approved'; 
        //    coa.MR_Status__c = 'Rejected';
           //coa1.Status1__c = 'LR Rejected';
            update coa1;                   
         
       
          
   }     
   
   
   static testMethod void myUnitTest2()
   {  
         
         Candidate_Mapping__c coa =new Candidate_Mapping__c();            
           // coa.status1__c = 'Applied';
            coa.Employer_s_Authorization__c = 'test1';  
            coa.LR_Comments__c = 'test1 by lr';
            coa.MR_Comments__c = 'test1 by MR'; 
            coa.Requirement_Owner_Email__c = 'testOwner11@preludesys.com';
            coa.Manager_Email_ID__c = 'testOwner11@preludesys.com';          
            coa.R_Comments__c = '';                      
            coa.LR_Status__c = 'Approved'; 
            coa.MR_Status__c = 'Approved'; 
            coa.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            coa.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            coa.Submitted_to_Client__c = 'No'; 
            coa.Submitted_to_Client_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
            coa.Interview_Scheduled__c = 'No'; 
            coa.Interview_Scheduled_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');   
            coa.Interview_Accepted__c = 'No'; 
            coa.Interview_Accepted_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');       
            coa.Client_Interviewed__c = 'No'; 
            coa.Client_Interview_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');   
           //coa.status1__c = 'Client Interviewed';                               
            coa.Client_Offered__c = 'No';
            coa.Client_Offer_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');    
            //coa.status1__c = 'Client Offered';    
            coa.Candidate_started__c = 'No'; 
            coa.Comments__c = '';  
            coa.MR_Status1__c = 'Approved' ;  
            coa.started_date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');     
           

 Candidate__c cc1=new Candidate__c();                        
            cc1.Name='test';
            cc1.Last_name__c='testone';
            cc1.Current_city__c='chennai';
            cc1.Current_state__c='Maine';
            cc1.Gender__c='Male';
            cc1.Employer_Name__c='ttt';
            cc1.Email__c='testOwner.testuser2@preludeorg.com';
            cc1.interview_contact_phone__c='Mobile Phone';
            cc1.Contract_type__c='Corp to Corp';
            cc1.visa_type__c='H1 B';
            cc1.cost__c =100;
            cc1.mobile_phone_no__c='9840432423';
            cc1.employer_contact_email__c='test@gmail.com';
            cc1.Employer_Contact_Name_Name__c='tt';
            cc1.Employer_Mobile_No__c='9988009876';       
            cc1.Employer_Name__c = 'jos'; 
            cc1.Employer_Work_Phone_No__c = '(425) 264-6771';   
            cc1.Followup_Date__c =date.today();  
            insert cc1;          
            coa.Candidate__c=cc1.id;
            system.debug('candid:'+cc1.id);
            
            Requirement__c rc1=new Requirement__c();            
            rc1.Name='SampathReq';
            //rc1.Job_Title__c='.net';
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
            rc1.won__c = true;
            //rc1.won_text__c ='yes';            
            insert rc1;
            coa.Requirement__c=rc1.id;
 

             User user = [Select Id from User limit 1] ; //where Email= 'gopalmr140313@gmail.com'];
             
           EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Candidate Approval Email with link EZRE'];            
           List<ContentVersion> contentList = new List<ContentVersion>();
           

           ContentWorkspace library = [SELECT id FROM ContentWorkspace LIMIT 1];
            System.Debug('library.id:'+ library.id);    
           /* contentList = [Select Id, ContentDocumentId,VersionData from ContentVersion where FirstPublishLocationId = :library.id];
           Blob strVersionData;
           for(ContentVersion cversion :contentList)
           {
               strVersionData = cversion.VersionData;
                          System.Debug('strVersionData:'+ strVersionData); 
           } */
           ContentVersion contentVersionObj = new ContentVersion();          
           //contentVersionObj.ContentURL = 'http://www.google.com';    
           contentVersionObj.title = 'Google';//contentVersionObj.Enablement_Area__c = 'Acct Mgmt';       
           contentVersionObj.FirstPublishLocationId = library.id;       
           contentVersionObj.Candidate_Id__c = cc1.Id; 
           contentVersionObj.VersionData = Blob.valueOf('Ayangar') ; 
           contentVersionObj.PathOnclient = 'http://www.google.com';
           contentVersionObj.Title ='Management Approach';  
          // contentVersionObj.ContentDocumentId = cv1.ContentDocumentId;  
             
           insert contentVersionObj;     
           System.Debug('ContentVersionObj:'+ contentVersionObj);
           
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
           efa.setFileName('Sasikumar.Word');
           efa.setBody(Blob.ValueOf(et.Body));
           //efa.setBody(Blob.valueOf('Ayangar')); 
           //efa.setContentType('.word'); //         
           System.Debug('efa:' +efa);    
           String[] toAddresses = new string[]{'dummy@yahoo.com'};
           mail.setTargetObjectId(user.Id);
           mail.setToAddresses(toAddresses);            
           //mail.setplaintextBody('plainbody');             
           
           mail.setSenderDisplayName('Charan Tej');
    
           mail.setTemplateId(et.Id);          
          // mail.setWhatId(c.Id);             
           mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
           mail.saveAsActivity = false;
                // Sends the email
           Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
           //                  
    
            
            insert coa;
            
            Candidate_Mapping__c coa1 = [Select Id,Status1__c, LR_Status__c, MR_Status__c, MR_Status1__c from Candidate_Mapping__c where Candidate__c =: cc1.Id and Requirement__c =: rc1.id limit 1];             
            coa1.Status1__c = 'Candidate did not start';
        //   coa.LR_Status__c = 'Approved'; 
        //    coa.MR_Status__c = 'Rejected';
           //coa1.Status1__c = 'LR Rejected';
            update coa1;                   
         
       
          
   }     
 }