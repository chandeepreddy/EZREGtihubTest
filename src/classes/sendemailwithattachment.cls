public with sharing class sendemailwithattachment
{
public void sendemail( string id)
{

    string manageremail;
    string lremail;
    string remail;
    string mrstatus;
    string mrstatus1;
    String subject;
    String htmlBody;
    String plainBody;
    String UserRoleId;//{get; set;};
    
    UserRoleId =UserInfo.getUserRoleId();
    System.Debug('UserRoleId =' + UserRoleId);

    Userrole rr = [select Name from Userrole where id = :UserRoleId limit 1];
    System.Debug('Cand Map ID:' +id);     
    String CandID, ReqmtID;          
 
    //List<Candidate_Mapping__c> AssgnCand = new List<Candidate_Mapping__c>();  
    Candidate_Mapping__c acan = [Select Candidate__c, Requirement__c,Manager_Email_ID__c,LR_Email__c,R_email__c,MR_Email__c,MR_Status__c,MR_Status1__c from Candidate_Mapping__c where id=:id limit 1];
   // for(Candidate_Mapping__c  acan: AssgnCand)
        //{
            CandID  = acan.Candidate__c;
            system.debug('candID:' + CandID);
            ReqmtID = acan.Requirement__c;
            system.debug('ReqmtID:' + ReqmtID);
            manageremail = acan.Manager_Email_ID__c;
            system.debug('manageremail :' + manageremail );
            lremail = acan.LR_Email__c;
            system.debug('lremail :' + lremail );
            remail = acan.R_email__c;
            system.debug('remail :' + remail );
            mrstatus = acan.MR_Status__c;
            mrstatus1 = acan.MR_Status1__c;
       // }
        
     //System.Debug('acan.Manager_Email_ID__c  :' +acan.Manager_Email_ID__c);
    //User user = [Select Id from User where Email = :manageremail limit 1];  // cm.Req_Owner_Email__c limit 1];
   // System.Debug('UserID: ' + user.id);
    List<EmailTemplate> et1 = new List<EmailTemplate>();
    et1 = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name like 'Candidate Approval Email with link EZRE' limit 1];    
    //System.Debug('EmailTemplate Id: ' + et1.id);
    System.Debug('et1 : ' + et1);

    Candidate__c Candt = [Select Id, Name, Availability__c, Interview_Contact_Phone__c, Location__c, Email__c, Available_Time__c, Home_Phone_No__c, Mobile_Phone_No__c, Work_Phone_No__c, Face_To_Face__c, Current_City__c, Cost__c, Communication_Rating__c, Contract_Type__c, CreatedDate, LastModifiedDate,Candidate_Full_Name__c from Candidate__c where Id =: CandID];
    Requirement__c Reqmt = [Select Name, Opportunity_Code__c, State__c, City__c from Requirement__c where id =:ReqmtID limit 1];

    for(EmailTemplate et : et1)
    {
       subject = et.Subject;
       System.Debug('Subject:' + et.Subject);
       htmlBody = et.HtmlValue;
       plainBody = et.Body;
    }
       
    
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

    OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'ezre@preludesys.com' limit 1];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setOrgWideEmailAddressId(owea.Id); 
    String[] toAddresses;
    if(manageremail!= null && lremail!= null  && remail!=null)
    {  
        system.debug('manageremail:' +manageremail);
        system.debug('lremail:' +lremail);
        system.debug('remail:' +remail);
        if((manageremail == lremail) || (lremail == remail))
            {
                toAddresses = new String[]{manageremail,remail};
                system.debug('toAddresses123' + toAddresses);
            }
        else
            {
                toAddresses = new String[]{manageremail,remail ,lremail }; //, ac.CreatedBy.Email, ac.R_email_id__c,ac.LR_Email__c,ac.R_Email__c 
                system.debug('toaddress:' + toAddresses );
            }
    }
    else if(manageremail!= null && lremail!= null && toAddresses == null)
    {
        toAddresses = new String[]{manageremail, lremail};
        system.debug('toaddress1:' + toAddresses );
    }
    else if(manageremail!=null && toAddresses == null)
    {
        toAddresses = new String[]{manageremail};
        system.debug('toaddress2:' + toAddresses );
    } 
    System.Debug('ToAddress:' +toAddresses); 
    mail.setToAddresses(toAddresses);
    //mail.setTemplateId(et.id);
    
    //String[] bccaddress = new String[]{'abinaya_s@preludesys.com'};
   // mail.setBccAddresses(bccaddress);
    
    //mail.setSenderDisplayName('Support');
    
    mail.setBccSender(false);
    mail.saveAsActivity = false;

    //mail.setTargetObjectId(user.id);
    
    mail.setSubject(subject);
    mail.setPlainTextBody(plainBody);
    mail.setHtmlBody(htmlBody);
 
    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
    Blob attachBody;
    String fileName;
    List<ContentVersion> cont = new List<ContentVersion>(); 
    cont = [select ContentDocumentId, Candidate_ID__c, VersionData, FileType, OwnerId, Title  from ContentVersion where Candidate_ID__c=:CandID limit 1];
    System.Debug('versiondata' + cont);
    if(!cont.IsEmpty())
    {
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
            
             efa.setFileName(fileName);
            efa.Body=attachBody;
            System.Debug('attachBody' + attachBody);
           
            //efa.setInline(false);
            fileAttachments.add(efa);    
            mail.setFileAttachments(fileAttachments);
        }
    }
    System.Debug('FileName: ' + fileName);
   
    System.Debug('mail :' + mail);
    if((rr.Name == 'Vice President' || rr.Name == 'Business Development Manager' || rr.Name =='Management Representative' || rr.Name =='Business Development Executive') && mrstatus1 == 'Approved')
        {  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
    
        }           
}
   
}