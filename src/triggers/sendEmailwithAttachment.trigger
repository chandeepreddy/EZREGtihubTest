trigger sendEmailwithAttachment on Candidate_Mapping__c (after insert , after update) 
{  
 if( Trigger.isInsert || Trigger.isUpdate)
 {
    for(Candidate_Mapping__c ac :Trigger.new)
    {        
       system.debug('Testing:'+ac.Status1__c);  
            
        //if(ac.MR_Status__c == 'Approved' && ac.MR_Status1__c != 'None'  )
        if(ac.MR_Status__c == 'Approved' ) 
        {  
        System.Debug('Cand Map ID:' +ac.id);      
        String CandID, ReqmtID;          
        //ac.MR_Status1__c  = 'None' ;     
    
    List<Candidate_Mapping__c> AssgnCand = new List<Candidate_Mapping__c>();  
    AssgnCand = [Select Candidate__c, Requirement__c from Candidate_Mapping__c where id=:ac.id];
    for(Candidate_Mapping__c  acan: AssgnCand)
    {
         CandID  = acan.Candidate__c;
         system.debug('candID:' + CandID);
         ReqmtID = acan.Requirement__c;
         system.debug('ReqmtID:' + ReqmtID);
   
    }
        
         
    User user = [Select Id from User where Email =: ac.Req_Owner_Email__c limit 1];
    System.Debug('UserID: ' + user.id);
    
    EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Candidate Approval Email with link EZRE'];    
    System.Debug('EmailTemplate Id: ' + et.id);
    System.Debug('et : ' + et);

    Candidate__c Candt = [Select Id, Name, Availability__c, Interview_Contact_Phone__c, Location__c, Email__c, Available_Time__c, Home_Phone_No__c, Mobile_Phone_No__c, Work_Phone_No__c, Face_To_Face__c, Current_City__c, Cost__c, Communication_Rating__c, Contract_Type__c, CreatedDate, LastModifiedDate,Candidate_Full_Name__c from Candidate__c where Id =: CandID];
    Requirement__c Reqmt = [Select Name, Opportunity_Code__c, State__c, City__c from Requirement__c where id =: ReqmtID];

    String subject = et.Subject;
    System.Debug('Subject:' + et.Subject);
    
    subject = subject.replace('{!Requirement__c.Name}', Reqmt.Name);
    System.Debug('Reqmt Name:' + Reqmt.Name);
    subject = subject.replace('{!Requirement__c.Opportunity_Code__c}', Reqmt.Opportunity_Code__c);
    System.Debug('Reqmt Opportunity:' + Reqmt.Opportunity_Code__c);
    subject = subject.replace('{!Requirement__c.State__c}', Reqmt.State__c);
    System.Debug('Reqmt State:' + Reqmt.State__c);
    subject = subject.replace('{!Requirement__c.City__c}', Reqmt.City__c);
    System.Debug('Reqmt City:' + Reqmt.City__c);
    subject = subject.replace('{!Candidate__c.Candidate_Full_Name__c}', Candt.Candidate_Full_Name__c);
    System.Debug('Candt Name:' + Candt.Candidate_Full_Name__c);
    
    String htmlBody = et.HtmlValue;
    if(Candt.Candidate_Full_Name__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Candidate_Full_Name__c}', Candt.Candidate_Full_Name__c);
    System.Debug('Candt Name:' + Candt.Candidate_Full_Name__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Candidate_Full_Name__c}', ' ');
    }
    if(Candt.Interview_Contact_Phone__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Interview_Contact_Phone__c}', Candt.Interview_Contact_Phone__c);
    System.Debug('Candt Contact:' + Candt.Interview_Contact_Phone__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Interview_Contact_Phone__c}', ' ');
    }
    if(Candt.Email__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Email__c}', Candt.Email__c);
    System.Debug('Candt Email:' + Candt.Email__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Email__c}', ' ');
    }
    if(Candt.Available_Time__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Available_Time__c}', Candt.Available_Time__c);
    System.Debug('Candt Available:' + Candt.Available_Time__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Available_Time__c}', ' ');
    }
    if(Candt.Home_Phone_No__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Home_Phone_No__c}', Candt.Home_Phone_No__c);
    System.Debug('Candt HomePhone:' + Candt.Home_Phone_No__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Home_Phone_No__c}', ' ');
    }
    if(Candt.Mobile_Phone_No__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Mobile_Phone_No__c}', Candt.Mobile_Phone_No__c);
    System.Debug('Candt Mobile:' + Candt.Mobile_Phone_No__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Mobile_Phone_No__c}', ' ');
    }
    if(Candt.Work_Phone_No__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Work_Phone_No__c}', Candt.Work_Phone_No__c);
    System.Debug('Candt WorkPhone:' + Candt.Work_Phone_No__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Work_Phone_No__c}', ' ');
    }
    if(Candt.Face_To_Face__c == True)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Face_To_Face__c}', 'Yes');
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Face_To_Face__c}', 'No');
    }
    if(Candt.Location__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Location__c}', Candt.Location__c);
    System.Debug('Candt City:' + Candt.Location__c);
    }
    else
    { 
    htmlBody = htmlBody.replace('{!Candidate__c.Location__c}', ' ');
    }    
    if(Candt.Availability__c != null)
    {  
    htmlBody = htmlBody.replace('{!Candidate__c.Availability__c}', Candt.Availability__c);
    System.Debug('Candt Availability:' + Candt.Availability__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Availability__c}', ' ');
    } 
    if(String.ValueOf(Candt.Cost__c) != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Cost__c}', String.ValueOf(Candt.Cost__c));
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Cost__c}', ' ');
    }
    if(Candt.Communication_Rating__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Communication_Rating__c}', Candt.Communication_Rating__c);
    System.Debug('Communication Rating:' + Candt.Communication_Rating__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Communication_Rating__c}', ' ');
    }
    if(Candt.Contract_Type__c != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Contract_Type__c}', Candt.Contract_Type__c);
    System.Debug('Contract Type:' + Candt.Contract_Type__c);
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Contract_Type__c}', ' ');
    }
    if(String.ValueOf(Candt.CreatedDate) != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.CreatedDate}', String.ValueOf(Candt.CreatedDate));
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.CreatedDate}', ' ');
    }
    if(String.ValueOf(Candt.LastModifiedDate) != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.LastModifiedDate}', String.ValueOf(Candt.LastModifiedDate));
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.LastModifiedDate}', ' ');
    }
    if(Candt.Id != null)
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Id}', Candt.Id);
    System.Debug('Candt Id:' + Candt.Id);  
    }
    else
    {
    htmlBody = htmlBody.replace('{!Candidate__c.Id}', ' ');
    }
    System.Debug('HtmlBody:' + htmlBody);  

    String plainBody = et.Body;
    if(Candt.Name != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Candidate_Full_Name__c}', Candt.Candidate_Full_Name__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Candidate_Full_Name__c}', ' ');
    }
    if(Candt.Interview_Contact_Phone__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Interview_Contact_Phone__c}', Candt.Interview_Contact_Phone__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Interview_Contact_Phone__c}', ' ');
    }
    if(Candt.Email__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Email__c}', Candt.Email__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Email__c}', ' ');
    }
    if(Candt.Available_Time__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Available_Time__c}', Candt.Available_Time__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Available_Time__c}', ' ');
    }
    if(Candt.Home_Phone_No__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Home_Phone_No__c}', Candt.Home_Phone_No__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Home_Phone_No__c}', ' ');
    }
    if(Candt.Mobile_Phone_No__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Mobile_Phone_No__c}', Candt.Mobile_Phone_No__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Mobile_Phone_No__c}', ' ');
    }
    if(Candt.Work_Phone_No__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Work_Phone_No__c}', Candt.Work_Phone_No__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Work_Phone_No__c}', ' ');
    }
    if(Candt.Face_To_Face__c == True)
    {
    plainBody = plainBody.replace('{!Candidate__c.Face_To_Face__c}', 'Yes');
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Face_To_Face__c}', 'No');
    }
    if(Candt.Location__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Location__c}', Candt.Location__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Location__c}', ' ');
    }
    if(Candt.Availability__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Availability__c}', Candt.Availability__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Availability__c}', ' ');
    }
    if(String.ValueOf(Candt.Cost__c) != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Cost__c}', String.ValueOf(Candt.Cost__c));
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Cost__c}', ' ');

    }
    if(Candt.Communication_Rating__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Communication_Rating__c}', Candt.Communication_Rating__c);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Communication_Rating__c}', ' ');
    }
    if(Candt.Contract_Type__c != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Contract_Type__c}', Candt.Contract_Type__c);
    }   
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Contract_Type__c}', ' ');
    }
    if(String.ValueOf(Candt.CreatedDate) != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.CreatedDate}', String.ValueOf(Candt.CreatedDate));
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.CreatedDate}', ' ');
    }
    if(String.ValueOf(Candt.LastModifiedDate) != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.LastModifiedDate}', String.ValueOF(Candt.LastModifiedDate));
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.LastModifiedDate}', ' ');
    }
    if(Candt.Id != null)
    {
    plainBody = plainBody.replace('{!Candidate__c.Id}', Candt.Id);
    }
    else
    {
    plainBody = plainBody.replace('{!Candidate__c.Id}', ' ');
    }
    System.Debug('Plain Body:' + plainBody);
    
    
   // string a = ac.Req_Owner_Email__c + ',' +ac.R_email_id__c + ',' + ac.LR_Email__c;
   
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses;
    if(ac.Req_Owner_Email__c != null && ac.LR_Email__c != null  && ac.R_email_id__c !=null )
    {
     toAddresses = new String[]{ac.Req_Owner_Email__c , ac.R_email_id__c, ac.LR_Email__c}; //, ac.CreatedBy.Email, ac.R_email_id__c,ac.LR_Email__c,ac.R_Email__c 
     system.debug('toaddress:' + toAddresses );
    }
    else if(ac.Req_Owner_Email__c != null && ac.LR_Email__c != null && toAddresses == null)
    {
     toAddresses = new String[]{ac.Req_Owner_Email__c, ac.LR_Email__c};
     system.debug('toaddress1:' + toAddresses );
    }
    else if(ac.Req_Owner_Email__c!=null && toAddresses == null)
    {
     toAddresses = new String[]{ac.Req_Owner_Email__c};
     system.debug('toaddress2:' + toAddresses );
    }
    
    System.Debug('ToAddress:' +toAddresses);
    
    mail.setToAddresses(toAddresses);
    //mail.setTemplateId(et.id);
    
    String[] bccaddress = new String[]{'abinaya_s@preludesys.com','joseph_e@preludesys.com'};
    mail.setBccAddresses(bccaddress);
    
    mail.setSenderDisplayName('Support');
    
    mail.setBccSender(false);
    mail.saveAsActivity = false;
    
    
    mail.setTargetObjectId(user.id);
    
    mail.setSubject(subject);
    mail.setPlainTextBody(plainBody);
    mail.setHtmlBody(htmlBody);
 
    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
    Blob attachBody;
    String fileName;
    List<ContentVersion> cont = new List<ContentVersion>(); 
    cont = [select ContentDocumentId, Candidate_ID__c, VersionData, FileType, OwnerId, Title  from ContentVersion where Candidate_ID__c=:CandID];
    System.Debug('versiondata' + cont);
    
    for(ContentVersion contents : cont)
    {
    attachBody = contents.VersionData;
    if(contents.FileType == 'WORD')
    {
         fileName = contents.Title+ '.' + 'doc';
    }
    else if(contents.FileType == 'WORD_X')
    {
         fileName = contents.Title+ '.' + 'docx';
    }
    else 
    {
    fileName = contents.Title+ '.' + contents.FileType;
    }
    }
    System.Debug('FileName: ' + fileName);
    efa.setFileName(fileName);
    efa.Body=attachBody;
    System.Debug('attachBody' + attachBody);

            
    //efa.setInline(false);
    fileAttachments.add(efa);    
    mail.setFileAttachments(fileAttachments);
    System.Debug('mail :' + mail);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
  
           
   }       
   
      
         
   }   
          
 } 
}