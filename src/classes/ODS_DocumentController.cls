/**
 * @author           Manoj Kumar S
 * @version          1.0 
 * @date             03-Jan-2017
 * @Status           Developed
 * @description      This is the class to Add/Modify/Delete the documents
 */
global class ODS_DocumentController {

    //Properties for Document
    public transient Blob blobBody { get; set; }
    public String filename { get; set; }
    public LIST<Documents__c> DocumentsList{get;set;}
    public Documents__c Documents{ get; set; }
    public string FromDate {get;set;}
    public string ToDate {get;set;}
    public string DocumentName {get;set;}
    public string DocumentType {get;set;}
    public string UniqueDocumentId {get;set;}
    public Boolean ShowDisclaimer {get;set;}
    public Boolean ShowUploadDocument {get;set;} 

    public List<SelectOption> DocumentTypeOptions{get;set;} //Document Type Picklist values
    public string AccountServiceID {get;set;}
    
    //Properties for Header Components
    public string AccountId {get;set;}
    public string ServiceId {get;set;}    
    public string CurrentUserName {get;set;}
    public string CurrentUserId {get;set;}
    public string PortalRole{get;set;}
    public string ContactId{get;set;}
    public Boolean IsCustomer{get;set;}
    public Boolean IsCustomerGrid{get;set;}
    
    //Properties for pagination
    public Integer PageSize {get;set;}
    public Integer CurrentPage {get;set;}
    public Boolean ShowPrevious {get;set;}
    public Boolean ShowNext {get;set;}
    public String CurrentPageInfo {get;set;}
    public Integer TotalRecords;
    public Integer PageNumber; 
        
    public ODS_DocumentController()
    {
        Documents = new Documents__c();
        CurrentUserName = UserInfo.getName();
        CurrentUserId = UserInfo.getUserId();
        CurrentUserId = UserInfo.getUserId();
        CurrentPage = 0; 
        PageSize = integer.valueof(System.Label.PageSize); // No. of rows per page
        PageNumber = 1; 
        ShowPrevious = false; 
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        PortalRole = objUser.PortalUserRole__c;
        ContactId = objUser.contactId;     
        
        //Bind the Document Type Values
        DocumentTypeOptions = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Documents__c.Document_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                
        for( Schema.PicklistEntry f : ple)
        {
              DocumentTypeOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        if(objUser.PortalUserRole__c == 'Customer')
        { 
            isCustomer = true;
            ShowDisclaimer = false;      
            ShowUploadDocument = true;
        }
        else
        {  
            isCustomer = false; 
            ShowUploadDocument = true;
            ShowDisclaimer = true;
        }
    }
    
    public void GetAccountServices()
    {
        if(AccountId == 'All' || ServiceId == 'All')
        {
            ShowUploadDocument = false;
            ShowDisclaimer = true;
        }
        else
        {
            ShowDisclaimer = false;
            ShowUploadDocument = true;
            
            List<Account_Services__c > accServList = new List<Account_Services__c >();
            accServList = ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
            if(accServList.size() > 0){
                AccountServiceID = accServList[0].Id;
            }
            else{
                AccountServiceID = '';
            }
        }
    }
    
    /// <OBJECTIVE>
    /// Fetch Document list based on the Account and Service Id
    /// </OBJECTIVE>
    public void FetchDocumentsList(string accountId, string serviceId, string fromDate, string toDate, string documentName, string documentType)
    {          
       try
       {        
           DocumentsList =  ODS_Data_Utility.FetchDocuments(accountId, serviceId, fromDate, toDate, documentName, documentType);     
      
           CurrentPage = 0; 
           PageNumber = 1; 
           ShowPrevious = false;
           if(DocumentsList.size()>0)
           {
                TotalRecords = DocumentsList.size();  // Total No of records need to display in Grid.      
                if(TotalRecords > PageSize)
                    ShowNext = true;
                else
                    ShowNext = false;       
                CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
            }
        }
        catch(Exception ex)
        {
            system.debug('Error' + ex);
        }
    }
    
     /// <OBJECTIVE>
     /// Insert the Document details and Attachment
     /// </OBJECTIVE>
     public void UploadDocument() 
     {     
          try
          {                
            if(Documents!=null){
               
               //If document Id is empty then add new record into Documents object else it will update the record based on document Id
               
               string documentId = ODS_Data_Utility.InsertUpdateDocumentDetailsAttachment(AccountId, ServiceId, Documents.Document_Type__c,Documents.Name,Documents.Project_Name__c, 
                                           Documents.SprintNumber__c, blobBody, filename, Documents.DocumentId__c,'',''); 
            
               //To get the Base URL to send email when document is added or modified
               string baseURL= URL.getSalesforceBaseUrl().toExternalForm();                              
               
               //To get the Account and Service name to send email with account and service name
               Account_Services__c[] accountServices = ODS_Data_Utility.GetAccountServiceName(AccountId, ServiceId); 
               
               //To get the Attachment Id to download link for attachment
               Documents__c[] documentAttachment = ODS_Data_Utility.GetAttachmentId(documentId);

               string downloadURL =  baseURL + '/servlet/servlet.FileDownload?file='+ documentAttachment[0].Attachment_Id__c;   
                   
               User_Account__c[] userAccount = ODS_Data_Utility.GetTechnicalAccountManager(AccountId);

               //Email body content will be changed based on the Insert/Update the document.                          
               if(Documents.DocumentId__c == '' || Documents.DocumentId__c == null)
               {
                   //Send Email whenever document is modified    
                   string htmlContent = '<html><head> Hi Team, <br/><br/> ';
                         htmlContent += 'A new document (Document type: '+  Documents.Document_Type__c +') is now uploaded  in the portal.';                         
                         htmlContent += '<br/><br/> Portal Link: <a href= '+ downloadURL +'>Click here to Download</a>';
                         htmlContent += '<br/><br/> Please review and contact your technical manager in case of issues. ';
                         htmlContent += '<br/><br/>Technical Manager: '+ accountServices[0].Technical_Account_manager__r.Name; 
                         htmlContent += '<br/>'+ accountServices[0].Technical_Account_manager__r.Email;
                         htmlContent += '</head><br/><br/> Regards, <br/>PreludeSys ODS Team.</body></html>';

                   string subject = 'New Document Uploaded for '+ accountServices[0].Account__r.Name + ' - ' + accountServices[0].ODS_Service_Name__c;      
                   //SendEmail(subject, htmlContent, AccountId, ServiceId);      
               }
               else
               {    
                   //Send Email whenever document is modified    
                   string htmlContent = '<html><head> Hi Team, <br/><br/> ';
                         htmlContent += 'An existing document (Document type: '+  Documents.Document_Type__c +') is now uploaded in the portal.';                         
                         htmlContent += '<br/><br/> Portal Link: <a href= '+ downloadURL +'>Click here to Download</a>';
                         htmlContent += '<br/><br/> Please review and contact your technical manager in case of issues. ';
                         htmlContent += '<br/><br/>Technical Manager: '+ accountServices[0].Technical_Account_manager__r.Name; 
                         htmlContent += '<br/>'+ accountServices[0].Technical_Account_manager__r.Email;
                         htmlContent += '</head><br/><br/> Regards, <br/>ODS Team.</body></html>';

                   string subject = 'Document Modified for '+ accountServices[0].Account__r.Name + ' - ' +accountServices[0].ODS_Service_Name__c;      
                   //SendEmail(subject, htmlContent, AccountId, ServiceId);   
               }                            
            }
          }
          catch(Exception ex)
          {
              system.debug(ex);
          }
    }
    
    
    /// <OBJECTIVE>
     /// Delete the Uploaded Document
    /// </OBJECTIVE>
    public void DeleteDocument()
    {
          try
          {
               string documentId = System.currentPageReference().getParameters().get('DocumentId');              
               Documents__c[] documents = ODS_Data_Utility.GetDocumentDetails(documentId);
               
               ODS_Data_Utility.DeleteDocument(documentId);
               
               //To get the Account and Service name to send email with account and service name
               Account_Services__c[] accountServices = ODS_Data_Utility.GetAccountServiceName(AccountId, ServiceId); 
               
               User_Account__c[] userAccount = ODS_Data_Utility.GetTechnicalAccountManager(AccountId);

               //Send Email whenever document is modified    
               string htmlContent = '<html><head> Hi Team, <br/><br/> ';
                         htmlContent += 'An existing document (Document type: '+ documents[0].Document_Type__c +' and document name: '+ documents[0].Name +') is deleted from the portal.';                         
                         htmlContent += '<br/><br/> Please contact your technical manager in case of issues. ';
                         htmlContent += '<br/><br/>Technical Manager: '+ accountServices[0].Technical_Account_manager__r.Name; 
                         htmlContent += '<br/>'+ accountServices[0].Technical_Account_manager__r.Email;
                         htmlContent += '</head><br/><br/> Regards, <br/>ODS Team.</body></html>';

               string subject = 'Document deleted for '+ accountServices[0].Account__r.Name + ' - ' + accountServices[0].ODS_Service_Name__c;      
               //SendEmail(subject, htmlContent, AccountId, ServiceId);  
          }
          catch(Exception ex)
          {
              system.debug(ex);
          }
    }
    
    /// <OBJECTIVE>
    ///  To get the Customer based on Account service Id
    /// </OBJECTIVE>
    public void GetCustomerByAccountServiceID() 
    {        
        try
        {
            ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);        
            FetchDocumentsList(AccountId, ServiceId,FromDate, ToDate, DocumentName, DocumentType);
            GetAccountServices();
        }
        catch(Exception ex)
        {
              system.debug(ex);
        }           
    }  
    
    /// <OBJECTIVE>
    ///  Enable disable showPrevious button.
    /// </OBJECTIVE>
    public void showPrevious()
    {
        CurrentPage = CurrentPage- PageSize;
        PageNumber--;
        enableDisablePaginationLinks();     
    }
    /// <OBJECTIVE>
    /// Enable disable showNext button
    /// </OBJECTIVE>
    public void showNext()
    {
        CurrentPage = CurrentPage + PageSize;
        PageNumber++;
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable showFirst button
    /// </OBJECTIVE>
    public void showFirst()
    {
        CurrentPage = 0;
        PageNumber = 1;
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable showLast button
    /// </OBJECTIVE>
    public void showLast()
    {
        CurrentPage = (Math.mod(TotalRecords, PageSize) == 0) ? TotalRecords - PageSize : (TotalRecords / PageSize) * PageSize;
        PageNumber = (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable pagination links
    /// </OBJECTIVE>
    public void enableDisablePaginationLinks()
    {
        if(CurrentPage == 0)
            ShowPrevious = false;
        else    
            ShowPrevious = true; 
        if((TotalRecords - PageSize) <= CurrentPage)
            ShowNext = false;
        else
            ShowNext = true;
        CurrentPageInfo = 'Showing Page ' + PageNumber +   ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
    }  
    
    ///<OBJECTIVE>
    /// Method to get search results
    ///</OBJECTIVE>   
    public void GetSearchResults()
    {      
        try
        {
            CurrentPage = 0;
            PageNumber=1;
            //enableDisablePaginationLinks();
            FetchDocumentsList(AccountId, ServiceId, FromDate, ToDate, DocumentName ,DocumentType);           
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
    } 
    
    ///<OBJECTIVE>
    /// Method to Validate the File name and Document Name already exist or not
    ///</OBJECTIVE> 
    @RemoteAction
    global static string ValidateUploadDocument(string documentName, string accountId, string serviceId, string fileName, string documentId) 
    {        
        string errorMessage = '';
        try
        {
            //If the Error message returns File then file name already exist. If its Document then document document already exist.
            errorMessage =  ODS_Data_Utility.ValidateDocument(documentName, accountId, serviceId, fileName, documentId);
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return errorMessage;       
    }
    
    ///<OBJECTIVE>
    /// Method to Document and Attachment Details. Document and Attachment JSON results is concat with delimeter $$##
    ///</OBJECTIVE> 
    @RemoteAction
    global static string GetDocumentAttachment(string documentId, string AccountId, string ServiceId ) {
        
        string documentAttachmentJSON = '';
        try
        {
            documentAttachmentJSON =  ODS_Data_Utility.GetDocumentAttachment(documentId,AccountId,ServiceId );            
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return documentAttachmentJSON;
    }
    
     ///<OBJECTIVE>
    /// To Check whether Document Created by and Current User is Same or not
    ///</OBJECTIVE> 
    @RemoteAction
    global static string CheckValidUserDocumentDelete(string documentId, string createdById) {
        
        string IsDeletionAllowed = '';
        try
        {
            if(UserInfo.getUserId() == createdById)
            {
                IsDeletionAllowed = 'true';
            }
            else
            {
                 IsDeletionAllowed = 'false';
            }
            
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return IsDeletionAllowed;
    }
    
     /// <OBJECTIVE>
    /// Method to send email 
    /// </OBJECTIVE>
    //@Future(Callout = true)
   /* public Static void SendEmail(string subject, string htmlBody, string accountId, string ServiceId)
    {
        List<String> toAddress = new List<String>();
        //List<String> ccAddress = new List<String>();
        Set<String> toEmailAddress = new Set<String>();

        //List of User Accounts associated
        List<User_Account__c> userAccounts = new List<User_Account__c>();
        userAccounts = ODS_Data_Utility.GetUserAccountEmailIds(accountId, ServiceId);      
        
        //List of Contacts associated
        List<Contact_Account_Service__c> contacts = new List<Contact_Account_Service__c>();
        contacts = ODS_Data_Utility.GetContactEmailIds(accountId,ServiceId);
        system.debug('@@@@contacts+'+contacts);

        List<Account_Services__c> accountServices = new List<Account_Services__c>();
        accountServices = ODS_Data_Utility.GetAccountServiceName(AccountId, ServiceId); 
        
        //Get TAM Email Address
        if(accountServices.size() > 0)
        {
            for(Account_Services__c accountServiceData: accountServices)
            {
                toEmailAddress.add(accountServiceData.Technical_Account_manager__r.Email);                
            }   
            toAddress.addAll(toEmailAddress);   
        }
        //Get list of User Accounts
        if(userAccounts.size() > 0)
        {
            for(User_Account__c userAccountData: userAccounts)
            {
                toEmailAddress.add(userAccountData.User__r.Email);                
            }   
            toAddress.addAll(toEmailAddress);  
        }
        //Get list of Contacts
        if(contacts.size() > 0)
        {
            for(Contact_Account_Service__c contactsData: contacts)
            {
                toEmailAddress.add(contactsData.Email__c);                
            }   
            toAddress.addAll(toEmailAddress);  
        }        
        if(toAddress.size() > 0)
        {
           
            Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();        
            mail.setToAddresses(toAddress);
            mail.setSenderDisplayName('Preludesys - ODS');
            mail.setSubject(subject);  
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });              
       }          
    }*/    
}