/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             05-Oct-2016
 * @Status           Developed
 * @description      This is the class For Invoice Page Controller.
 */
global class ODS_Invoicepagecontroller {

    //Properties for Invoice
    public transient Blob blobBody { get; set; }
    public String filename { get; set; }
    public LIST<Invoice__c> invoiceList{get;set;}
    public Invoice__c Invoice{ get; set; }
    public string FromDate {get;set;}
    public string ToDate {get;set;}
    public string UniqueInvoiceId {get;set;}
    public string Month{get;set;}
    Public Integer Year{get;set;}
    

    public List<SelectOption> InvoiceMonthOptions{get;set;}
    public List<SelectOption> InvoiceYearOptions{get;set;}
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
    public Boolean ShowDisclaimer {get;set;}
    public Boolean ShowUploadInvoice {get;set;}   
    
    public String sortDirection = 'ASC';
    public String sortExp = 'name';
    
     public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    
    public String getSortDirection()
    {
        
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    public ODS_Invoicepagecontroller()
    {
        
        Invoice = new Invoice__c();
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
        if(objUser.PortalUserRole__c == 'Customer')
        { 
            isCustomer = true;
            ShowDisclaimer = false;      
            ShowUploadInvoice = false;
        }
        else
        {  
            isCustomer = false; 
            ShowUploadInvoice = true;
            ShowDisclaimer = true;
        } 
               
    }
	public List<Invoice__c> getInvoiceList() {
        return invoiceList;
   }
    /// <OBJECTIVE>
    /// Fetch Invoice list based on the Account and Service Id
    /// </OBJECTIVE>
    public void FetchInvoiceList(string accountId, string serviceId, string Month, integer Year)
    {          
        system.debug('===========FetchInvoiceList===========');
        string sortFullExp = sortExpression  + ' ' + sortDirection;
       try
       {        
          invoiceList = new List<Invoice__c>();
          invoiceList =  ODS_Data_Utility.FetchInvoice(accountId, serviceId, Month, Year,sortFullExp); 
          
           CurrentPage = 0; 
           PageNumber = 1; 
           ShowPrevious = false;
           if(invoiceList.size()>0)
           {
                TotalRecords = invoiceList.size();  // Total No of records need to display in Grid.      
                system.debug('###TotalRecords:' +TotalRecords);
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
     /// Insert the Invoice details and Attachment
    /// </OBJECTIVE>
     public void UploadInvoice() 
     {     
          try
          {                
            Invoice__c InvoiceId = new Invoice__c();
            system.debug('---InvoiceId passed--------' + Invoice.Invoice_ID__c);
            system.debug('##UniqueInvoiceId :' +UniqueInvoiceId );
            if(Invoice!=null){
               InvoiceId = ODS_Data_Utility.InsertUpdateInvoiceDetailsAttachment(accountId,serviceId,fileName,
                       Invoice.Month__c, Invoice.Year__c, blobBody, Invoice.Comments__c, Invoice.Invoice_ID__c);
               //sendEmail(InvoiceId.Id);              
            }
          }
          catch(Exception ex)
          {
              system.debug(ex);
              //sendEmail('a2GS0000001Xdx6');
              
          }
           //return null;
    }
    
    /// <OBJECTIVE>
    /// Bind year dropdown.
    /// </OBJECTIVE>
    public List<SelectOption> getYears()
    {
        List<SelectOption> yearLst = new List<SelectOption>();
        Integer startYear = Date.today().Year();
        Integer endYear = Date.today().addYears(-3).Year();
        yearLst.add(new SelectOption('Year','Year')); 
        for(integer i = startYear; i >= endYear; i--)
        {
            yearLst.add(new SelectOption(string.ValueOf(i),string.ValueOf(i))); 
        }
        return yearLst;
    }
    
    
    /// <OBJECTIVE>
     /// Delete the Uploaded Invoice
    /// </OBJECTIVE>
    public void DeleteInvoice()
    {
          try
          {
               Invoice__c DeleteInvoiceId = new Invoice__c();
               string InvoiceId = System.currentPageReference().getParameters().get('InvoiceId');
               //sendEmailDelete(InvoiceId);               
               ODS_Data_Utility.DeleteInvoice(InvoiceId);
          }
          catch(Exception ex)
          {
              system.debug(ex);
          }
    }
    
    /// <OBJECTIVE>
    ///  To get the Customer based on Account service Id
    /// </OBJECTIVE>
    public pagereference GetCustomerByAccountServiceID() 
    { 
        try
        {
            ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);     
            FetchInvoicelist(accountId, serviceId, Month, Year);
            GetAccountServices(); 
        }
        catch(Exception ex)
        {
              system.debug(ex);
        }         
        return null;  
    }
    public void GetAccountServices()
    {
        if(AccountId == 'All' || ServiceId == 'All')
        {
            ShowUploadInvoice = false;
            if(PortalRole == 'Customer')
            {
                ShowDisclaimer = false;
            }
            else{
                ShowDisclaimer = true;
            }
        }
        else
        {
            ShowDisclaimer = false;
            if(PortalRole == 'Customer')
            {
                ShowUploadInvoice = false;
            }
            else
            {
                ShowUploadInvoice = true;
            }
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
        system.debug('Inside Next Method');
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
    public void fetchInvoiceListCommnadLink(){
        system.debug('=======TestLinkMtd');
        
        FetchInvoiceList(accountId, serviceId, Month, Year);
    }
    public void GetSearchResults()
    {      
        system.debug('Month'+ Month+'#####Year'+ Year); 
        try
        {
            CurrentPage = 0;
            PageNumber=1;
            //enableDisablePaginationLinks();
            FetchInvoiceList(accountId, serviceId, Month, Year);           
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
    } 
    
    ///<OBJECTIVE>
    /// Method to Validate the File name and Invoice Name already exist or not
    ///</OBJECTIVE> 
    @RemoteAction
    global static string ValidateUploadInvoice(string accountId, string serviceId, string InvoiceId, string fileName) 
    {
        string errorMessage = '';
        try
        {
           //If the Error message returns File then file name already exist. If its Invoice then Invoice Invoice already exist.           
            errorMessage =  ODS_Data_Utility.ValidateInvoice(accountId, serviceId,InvoiceId,fileName); 
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return errorMessage;       
    }
    
    ///<OBJECTIVE>
    /// Method to Invoice and Attachment Details
    ///</OBJECTIVE> 
    @RemoteAction
    global static string GetInvoiceAttachment(string InvoiceId) {
        
        string InvoiceJSON = '';
        system.debug('##InvoiceId:'+ InvoiceId);
        try
        {
            InvoiceJSON =  ODS_Data_Utility.GetInvoiceAttachment(InvoiceId);
            system.debug('###InvoiceJSON :' +InvoiceJSON );            
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return InvoiceJSON;
    }
    
     /// <OBJECTIVE>
    /// Method to send email once the Invoice is Created/updated.
    /// </OBJECTIVE> 
   /* @Future(Callout = true)
    public Static void sendEmail(string InvoiceId)
    {
        List<String> lstToAddress = new List<String>();
        List<String> lstCcAddress = new List<String>();
        string timesheetMailIdLabel = System.Label.ODS_TimesheetMail_Id;
        Set<String> setCcAddress = new Set<String>();        
        Invoice__c Invoice = new Invoice__c();
        //List<Contact> contactList = new List<Contact>();
        List<Contact_Account_Service__c > contactList = new List<Contact_Account_Service__c >();       
        Invoice = [SELECT CreatedDate, CreatedById,CreatedBy.Name,LastModifiedDate, Account_Services__r.Account__c, Account_Services__r.Account__r.ID, Account_Services__r.Account__r.Name,Account_Services__r.ODS_Service_Name__c,Account_Services__r.ODS_Services__c,Account_Services__r.ODS_Services__r.Name, Attachment_Id__c,Comments__c, Month__c,Year__c, Id FROM Invoice__c where id =:InvoiceId ];
        string attachmentId = Invoice.Attachment_Id__c;
        
        contactList =[SELECT ID,AccountId__c,Contact__r.AccountId,Email__c,Name,ODS_Service__c FROM Contact_Account_Service__c WHERE Contact__r.AccountId =: Invoice.Account_Services__r.Account__r.ID AND ODS_Service__c =:Invoice.Account_Services__r.ODS_Services__c AND Is_Approver__c = True];
        //contactList = [SELECT Is_Portal_Access__c,Is_Approver__c,AccountId,Email FROM Contact where Is_Portal_Access__c = TRUE AND Is_Approver__c = TRUE AND AccountId =: Invoice.Account_Services__r.Account__r.ID ];
        for(Contact_Account_Service__c contactMailId:contactList)
        {
            if(contactMailId.Email__c != null)
            {
                lstToAddress.add(contactMailId.Email__c);      
            }
            system.debug('####@@lstToAddress:' +lstToAddress);
        }
        Attachment attachmentToSend = new Attachment(); 
        if(attachmentId !='')
        {
            attachmentToSend = [SELECT id,Name,Body FROM Attachment WHERE id =: attachmentId];
        }
        
        if(timesheetMailIdLabel != null)
        {
            lstCcAddress.add(timesheetMailIdLabel);        
        }
        //List of User Accounts associated
        List<User_Account__c> lstUsrAccnts = new List<User_Account__c>();
        string accntId = Invoice.Account_Services__r.Account__c;
        string serviceId = Invoice.Account_Services__r.ODS_Services__c;
        system.debug('---Service id:'+serviceId );
        lstUsrAccnts = [Select Id, name, User__c,User__r.Email, Account__c, Role_in_Account__c from User_Account__c where Account__c =: accntId AND ODS_Service_Name__c =: serviceId];
        System.debug('lstUsrAccnts------------'+lstUsrAccnts);
        
        List<Account_Services__c> accountServices = new List<Account_Services__c>();
        accountServices = ODS_Data_Utility.GetAccountServiceName(accntId, ServiceId); 
        
        //Get TAM Email Address
        if(accountServices.size() > 0)
        {
            for(Account_Services__c accountServiceData: accountServices)
            {
                setCcAddress.add(accountServiceData.Technical_Account_manager__r.Email);                
            }   
            lstCcAddress.addAll(setCcAddress);   
        }
        
        //get list of Cc address
        if(lstUsrAccnts.size() >0)
        {
            for(User_Account__c objUsrAccnt: lstUsrAccnts)
            {
                setCcAddress.add(objUsrAccnt.User__r.Email); 
            }   
            lstCcAddress.addAll(setCcAddress); 
            system.debug('####@@lstCcAddress:' +lstCcAddress);
        }
        //generate email with the details
        
        // the contents of the attachment from the pdf
        
        Messaging.EmailFileAttachment attachement = new Messaging.EmailFileAttachment();
        attachement.setFileName(attachmentToSend.Name);
        //attachement.setFileName(Invoice.Month__c+','+Invoice.Year__c+'Invoice - '+Invoice.Account_Services__r.Account__r.Name);
        attachement.setInline(false);
        attachement.setContentType('application/pdf'); 
        attachement.Body = attachmentToSend.Body ;
        
        Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
        mail.setToAddresses(lstToAddress);
        mail.setSenderDisplayName('Preludesys - ODS');
        mail.setCcAddresses(lstCcAddress);
        String subject = Invoice.Month__c+' '+Invoice.Year__c +' Invoice Uploaded for '+Invoice.Account_Services__r.Account__r.Name+'-'+Invoice.Account_Services__r.ODS_Service_Name__c +' Service';
        mail.setSubject(subject); 
        string baseURL= URL.getSalesforceBaseUrl().toExternalForm(); 
         //To get the Attachment Id to download link for attachment
        Invoice__c[] InvoiceAttachment = ODS_Data_Utility.GetInvoiceAttachmentId(InvoiceId);      
        String strHtmlBody = '' ;       
        
        strHtmlBody = '<html><head> Hi Team , <br/><br/>  Invoice for the month of '+ Invoice.Month__c+' '+Invoice.Year__c +' has been uploaded in the Portal.'+
                        + '<br/><br/>Please review and contact your technical manager in case of issues.<br/><br/>';
        strHtmlBody += '<a href=' + baseURL + '/servlet/servlet.FileDownload?file=' +InvoiceAttachment[0].Attachment_Id__c +'>Click here to view invoice</a>';  
        strHtmlBody += '</head><br/><br/> Technical Manager: '+ accountServices[0].Technical_Account_manager__r.Name  +'<br/>'+ accountServices[0].Technical_Account_manager__r.Email +'</body></html>';
        strHtmlBody += '</head><br/><br/> Regards, <br/> Preludesys ODS Team.</body></html>';
        mail.setHtmlBody(strHtmlBody);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachement});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    }*/
    
    /// <OBJECTIVE>
    /// Method to send email once the Invoice is Deleted.
    /// </OBJECTIVE> 
    /*public Static void sendEmailDelete(string InvoiceId)
    {
        List<String> lstToAddress = new List<String>();
        List<String> lstCcAddress = new List<String>();
        string timesheetMailIdLabel = System.Label.ODS_TimesheetMail_Id;
        Set<String> setCcAddress = new Set<String>();        
        Invoice__c Invoice = new Invoice__c();
        //List<Contact> contactList = new List<Contact>();
        List<Contact_Account_Service__c > contactList = new List<Contact_Account_Service__c >();       
        Invoice = [SELECT CreatedDate, CreatedById,CreatedBy.Name,LastModifiedDate,Account_Services__r.Account__r.ID,Account_Services__r.ODS_Service_Name__c, Account_Services__r.Account__c,Account_Services__r.Account__r.Name,Account_Services__r.ODS_Services__c,Account_Services__r.ODS_Services__r.Name, Attachment_Id__c,Comments__c, Month__c,Year__c, Id FROM Invoice__c where id =:InvoiceId ];
        string attachmentId = Invoice.Attachment_Id__c;
        contactList =[SELECT ID,AccountId__c,Contact__r.AccountId,Email__c,Name,ODS_Service__c FROM Contact_Account_Service__c WHERE Contact__r.AccountId =: Invoice.Account_Services__r.Account__r.ID AND ODS_Service__c =:Invoice.Account_Services__r.ODS_Services__c AND Is_Approver__c = True];
        //contactList = [SELECT Is_Portal_Access__c,Is_Approver__c,AccountId,Email FROM Contact where Is_Portal_Access__c = TRUE AND Is_Approver__c = TRUE AND AccountId =: Invoice.Account_Services__r.Account__r.ID ];
        for(Contact_Account_Service__c contactMailId:contactList)
        {
            if(contactMailId.Email__c != null)
            {
                lstToAddress.add(contactMailId.Email__c);      
            }
        }
        
        if(timesheetMailIdLabel != null)
        {
            lstCcAddress.add(timesheetMailIdLabel);        
        }
        //List of User Accounts associated
        List<User_Account__c> lstUsrAccnts = new List<User_Account__c>();
        string accntId = Invoice.Account_Services__r.Account__c;
        string serviceId = Invoice.Account_Services__r.ODS_Services__c;

        lstUsrAccnts = [Select Id, name, User__c,User__r.Email, Account__c, Role_in_Account__c from User_Account__c where Account__c =: accntId AND ODS_Service_Name__c =: serviceId];
        
        List<Account_Services__c> accountServices = new List<Account_Services__c>();
        accountServices = ODS_Data_Utility.GetAccountServiceName(accntId, ServiceId); 
        
        //Get TAM Email Address
        if(accountServices.size() > 0)
        {
            for(Account_Services__c accountServiceData: accountServices)
            {
                setCcAddress.add(accountServiceData.Technical_Account_manager__r.Email);                
            }   
            lstCcAddress.addAll(setCcAddress);   
        }

        //get list of Cc address
        if(lstUsrAccnts.size() >0)
        {
            for(User_Account__c objUsrAccnt: lstUsrAccnts)
            {
                setCcAddress.add(objUsrAccnt.User__r.Email); 
            }   
            lstCcAddress.addAll(setCcAddress); 
            system.debug('####@@lstCcAddress:' +lstCcAddress);
        }
        //generate email with the details
        
        Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
        mail.setToAddresses(lstToAddress);
        mail.setSenderDisplayName('Preludesys - ODS');
        mail.setCcAddresses(lstCcAddress);
        String subject = Invoice.Month__c+' '+Invoice.Year__c +' Invoice Deleted for '+Invoice.Account_Services__r.Account__r.Name+'-'+Invoice.Account_Services__r.ODS_Service_Name__c +' Service';
        mail.setSubject(subject); 
            
        String strHtmlBody = '' ;       
        
        strHtmlBody = '<html><head> Hi Team , <br/><br/>  Invoice for the month of '+ Invoice.Month__c+' '+Invoice.Year__c +' is deleted from the Portal.'+
                        + '<br/><br/>Please contact your Technical Manager for any questions.<br/><br/>';
          
        strHtmlBody += '</head><br/><br/> Technical Manager: '+ accountServices[0].Technical_Account_manager__r.Name +'<br/>'+ accountServices[0].Technical_Account_manager__r.Email +'</body></html>';                
        
        strHtmlBody += '</head><br/><br/> Regards, <br/> Preludesys ODS Team.</body></html>';
        mail.setHtmlBody(strHtmlBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    }*/
    
    public PageReference GetValue()
    {
        system.debug('####AccountId:' +AccountId);
        return null;
    }
}