/**
 * @author           Manoj,Krishnakumari,Gangadhar,Nandhini
 * @version          1.0 
 * @date             23-May-2017
 * @Status           In Development
 * @description      
 */
global class ODS_DocumentUploadController{

    public string CurrentUserName {get;set;}
    public string CurrentUserId {get;set;}
    public string PortalRole{get;set;}
    public string ContactId{get;set;}
    public Boolean IsCustomer{get;set;}
    public Boolean IsCustomerGrid{get;set;}
    public Boolean ShowDisclaimer {get;set;}
    
    //Properties for pagination
    public Integer PageSize {get;set;}
    public Integer CurrentPage {get;set;}
    public Boolean ShowPrevious {get;set;}
    public Boolean ShowNext {get;set;}
    public String CurrentPageInfo {get;set;}
    public Integer TotalRecords;
    public Integer PageNumber;  
    public String FolderName {get; set;} 
    
    
     //Properties for Upload Document
    public Documents__c DocumentsUpload{ get; set; }
    public String filename { get; set; }
    public transient Blob blobBody { get; set; }
    public List<SelectOption> DocumentTypeOptions{get;set;}
    public static List<SelectOption> FolderNameslst {get;set;}
    
    
    //Properties for AccountServiceId
    public User objUser {get;set;}
    public String AccountId {get;set;}
    public String ServiceId {get;set;}
    public String AccountServiceID {get;set;} 
    
    public String UploadedDocument { get; set; }
    public List<Documents__c> Documents { get; set; }
    public List<Folder__c> Folders { get; set; }
    public List<Documents__c> RecordsList { get; set; }
    
    public Boolean ShowFolder { get; set;}
    public Boolean ShowDocument { get; set;}
    public Boolean ShowSearchPanel { get; set;}
    
    public String SelectedFolderID {get ; set;}
    public String SelectedFolderName {get ; set;}
    
    public string FromDate {get;set;}
    public string ToDate {get;set;}
    public string FolderOrDocumentName {get;set;}
    public Folder__c Folder { get; set; }
    public string FolderId {get;set;}
    
    public string DocumentSuffix { get; set; }
    
    public Boolean IsSearch {get;set;}
    public string viewStatus {get;set;}
    
    public String sortDirection = 'ASC';
    public String sortExp = 'name';
    public String sortDirection1 = 'ASC';
    public String sortExp1 = 'name';
    
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
    public String sortExpression1
    {
        get
        {
            return sortExp1;
        }
        set
        {
            
            if (value == sortExp1)
                sortDirection1 = (sortDirection1 == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection1 = 'ASC';
            sortExp1 = value;
        }
    }
    public String getSortDirection()
    {
        
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    public String getSortDirection1()
    {
        
        if (sortExpression1 == null || sortExpression1 == '')
            return 'ASC';
        else
            return sortDirection1;
    }
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    public void setSortDirection1(String value)
    {  
        sortDirection1 = value;
    }

    
    public ODS_DocumentUploadController()
    {
        system.debug('@@@viewStatus '+viewStatus );
        system.debug('@@@^^^AcntId'+AccountId);
        system.debug('@@@^^^SrvId'+ServiceId);
        
        CurrentUserName = UserInfo.getName();
        CurrentUserId = UserInfo.getUserId();
        CurrentUserId = UserInfo.getUserId();
        
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        PortalRole = objUser.PortalUserRole__c;
        ContactId = objUser.contactId;  
        
         if(objUser.PortalUserRole__c == 'Customer')
        { 
            isCustomer = true;
            ShowDisclaimer = false;      
        }
        else
        {  
            isCustomer = false; 
            ShowDisclaimer = true;
        }   
    
        //To hide the search panel 
        ShowSearchPanel= false;
        IsSearch = false;
        RecordsList = new List<documents__C>();
        
        FetchFolders();
        FetchDocuments();
        
        Folder  = new Folder__c(); 
        DocumentsUpload = new  Documents__c();
        //Bind Picklist Values
        DocumentTypeOptions = new List<SelectOption>();
        FolderNameslst  = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Documents__c.Document_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry f : ple)
        {
              DocumentTypeOptions.add(new SelectOption(f.getLabel(), f.getValue()));
              //FolderNameslst.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        
            List<Folder__c > FolderNames = [SELECT Id,Name from Folder__c Where Account_Services__c =: 'a0CS0000006ujfm'];
        
        
        for(Folder__c foldr : FolderNames)
        {
            system.debug('----foldr.Name ----'+ foldr.Name );
           //FolderNameslst.add(new SelectOption(foldr.Id,foldr.Name));

        }  
        
        
    }
    /// <OBJECTIVE>
    /// To fetch the documents
    /// </OBJECTIVE>
    public void FetchDocuments(){
        system.debug('=======FetchDocuments==========');
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        string sortFullExp1 = sortExpression1  + ' ' + sortDirection1;
        CurrentPage = 0; 
        PageSize = integer.valueof(System.Label.PageSize); // No. of rows per page
        PageNumber = 1; 
        ShowPrevious = false;
        
        //Documents = ODS_Data_Utility.FetchDocuments(AccountId,ServiceId,SelectedFolderID);
        Documents = ODS_Data_Utility.GetDocuments(AccountId,ServiceId,SelectedFolderID, FromDate, ToDate, FolderOrDocumentName,sortFullExp1);
        
        Set<Id> folderIds = new Set<Id>();
        if(IsSearch==true){
            List<Folder__c> allFolders = ODS_Data_Utility.FetchFolders(AccountId,ServiceId,null, null, null,sortFullExp);
            for(Folder__c folder : allFolders){
                folderIds.add(folder.Id);
            }
            IsSearch= false;
        }
        if(folderIds!=null&&!folderIds.isEmpty()){
            Documents.addAll(ODS_Data_Utility.GetDocuments(AccountId,ServiceId,folderIds, FromDate, ToDate, FolderOrDocumentName));   
            folderIds = new Set<Id>();
        }
        RecordsList = ODS_Data_Utility.FetchDeletedDocuments(AccountId, ServiceId, sortFullExp);
        
        system.debug('----RecordsList '+AccountId+'----' +  ServiceId+'---' + RecordsList.size());
        system.debug('====Documents===='+Documents);
        if(Documents.size()>0)
        {
            system.debug('====Documents===='+Documents);
            TotalRecords = Documents.size();  // Total No of records need to display in Grid.      
            if(TotalRecords > PageSize)
                ShowNext = true;
            else
                ShowNext = false;       
            CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
        }
        //return Documents;
    }
     /// <OBJECTIVE>
    /// To fetch the folders
    /// </OBJECTIVE>
    public void FetchFolders(){
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        //Folders = ODS_Data_Utility.FetchFolders(AccountId,ServiceId);
        Folders = ODS_Data_Utility.FetchFolders(AccountId,ServiceId,FromDate, ToDate, FolderOrDocumentName,sortFullExp);
    } 
    
    /// <OBJECTIVE>
    /// To validate folder Name
    /// </OBJECTIVE>
    @RemoteAction
    global static string ValidateFolderName(string folderName,string accountId, string serviceId)
    {
        system.debug('====Folder===='+folderName);
        string errorMessage='';
        string accountServiceId;
        List<Account_Services__c > accServiceList = new List<Account_Services__c >();
        accServiceList =ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        system.debug('----accServList ----'+ accServiceList );
        if(accServiceList.size() > 0)
            {
                accountServiceId= accServiceList [0].Id;
            }
            else
            {
                accountServiceId= '';
            }
        try
        {            
            errorMessage =  ODS_Data_Utility.ValidateFolder(folderName,accountServiceId);
        } 
        
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return errorMessage;       
    }    
    
     /// <OBJECTIVE>
    /// To insert folders
    /// </OBJECTIVE>
    public void CreateFolder()
    {
        GetAccountServices(); 
        Folder.Account_Services__c = AccountServiceID;
        system.debug('------Folder---' + Folder);
        ODS_Data_Utility.AddNewFolder(Folder);
        Folder  = new Folder__c(); 

    }
    
     /// <OBJECTIVE>
    /// Method to Validate the File name and Document Name already exist or not
     /// <OBJECTIVE> 
    @RemoteAction
    global static string ValidateUploadDocument(string documentName, string accountId, string serviceId, string fileName, string documentId) 
    {        
        
        string errorMessage = '';
        string accountServiceId;
        List<Account_Services__c > accServiceList = new List<Account_Services__c >();
        accServiceList =ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        system.debug('----accServList ----'+ accServiceList );
        if(accServiceList.size() > 0)
            {
                accountServiceId= accServiceList [0].Id;
            }
            else
            {
                accountServiceId= '';
            }
        try
        {
            
            errorMessage =  ODS_Data_Utility.ValidateDocument(documentName, accountId, accountServiceId, fileName, documentId);
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return errorMessage;       
    }   
    
     /// <OBJECTIVE>
    /// Insert document Details and attachment
     /// <OBJECTIVE>
    public void UploadDocument()
    {
        system.debug('------AccountServiceID---- '+ DocumentsUpload.AccountServiceId__c);
        system.debug('@@@FOlderId@@@ '+ FolderId);
             
        string[] splitAccountServiceId = DocumentsUpload.AccountServiceId__c.Split(',');

        List<Account_Services__c > accServList = new List<Account_Services__c >();
        accServList = ODS_Data_Utility.fetchAccServcesByServiceAccount(splitAccountServiceId[0], splitAccountServiceId[1]);
        
        system.debug('----accServList ----'+ accServList );
        if(accServList.size() > 0)
        {
            AccountServiceID = accServList[0].Id;
        }
        else
        {
            AccountServiceID = '';
        }
        
         ODS_Data_Utility.InsertUpdateDocumentDetailsAttachment(splitAccountServiceId[0], AccountServiceID, DocumentsUpload.Document_Type__c,DocumentsUpload.Name,DocumentsUpload.Project_Name__c, 
                                           DocumentsUpload.SprintNumber__c, blobBody, filename, DocumentsUpload.DocumentId__c, FolderId ,DocumentsUpload.File_Extension__c );
                                           
     }
     
     /// <OBJECTIVE>
    /// Method to Document and Attachment Details. Document and Attachment JSON results is concat with delimeter $$##
    /// <OBJECTIVE>
    @RemoteAction
    global static string GetDocumentAttachment(string documentId,string AccountId,string ServiceId) {
        
        system.debug('^^^Doc Controller');
        system.debug('^^^AccountId'+AccountId);
        system.debug('^^^ServiceId'+ServiceId);
        string documentAttachmentJSON = '';
        try
        {
            documentAttachmentJSON =  ODS_Data_Utility.GetDocumentAttachment(documentId,AccountId,ServiceId);            
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return documentAttachmentJSON;
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
    
    public PageReference GetStatusReportByAccountServiceID() 
    {
        SelectedFolderID = ''; 
        SelectedFolderName='';
        GetAccountServices();    
        FetchFolders();
        FetchDocuments();
        ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);        
        system.debug('%%%'+AccountId);
        
        /*List<Folder__c> FolderNames = new List<Folder__c>();
        FolderNameslst  = new List<SelectOption>();
        List<Account_Services__c > accServiceList = new List<Account_Services__c >();
        accServiceList =ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        system.debug('^---accServList^----'+ accServiceList );
        if(accServiceList.size() > 0)
        {
            accountServiceId= accServiceList [0].Id;
            FolderNames = [SELECT Id,Name from Folder__c Where Account_Services__c =: accountServiceId];
        }
        else
        {
            accountServiceId= '';
        }
        system.debug('^^^FolderNames'+FolderNames);
        
        for(Folder__c foldr : FolderNames)
        {
            system.debug('----foldr.Name ----'+ foldr.Name );
           FolderNameslst.add(new SelectOption(foldr.Name,foldr.Id));

        }*/  
        
        return null;
    }
    
     /// <OBJECTIVE>
    /// Method to get current account service
    /// <OBJECTIVE>
    public String GetAccountServices()
    {
        List<Account_Services__c > accServList = new List<Account_Services__c >();
        accServList = ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        system.debug('----accServList ----'+ accServList );
        if(accServList.size() > 0)
        {
            AccountServiceID = accServList[0].Id;
        }
        else
        {
            AccountServiceID = '';
        }
       
        DocumentSuffix = ODS_Data_Utility.GetAccountServiceDetails(AccountServiceID);
         return AccountServiceID;
    }
    
     /// <OBJECTIVE> 
    /// To Check whether Document Created by and Current User is Same or not
    /// <OBJECTIVE>
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
     /// Delete the Uploaded Document
    /// </OBJECTIVE>
    public void DeleteDocument()
    {        
        string documentId = System.currentPageReference().getParameters().get('DocumentId');              
        Documents__c[] documents = ODS_Data_Utility.GetDocumentDetails(documentId);             
        ODS_Data_Utility.DeleteDocument(documentId);
    }
    //Search functionality
    public void GetSearchResults()
    {  
        try
        {
            CurrentPage = 0;
            PageNumber=1;
            SelectedFolderID='';
            SelectedFolderName='';
            //IsSearch = True;
            FetchFolders();
            FetchDocuments();
           
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
    } 
    /// <OBJECTIVE>
    /// Delete the Uploaded Document
    /// </OBJECTIVE>
    public void ShowOrHideSearchPanel()
    {     
        system.debug('=======ShowSearchPanel===='+ShowSearchPanel);
        if(ShowSearchPanel){
            ShowSearchPanel = false;
            FromDate='';
            ToDate='';
            FolderOrDocumentName='';
        }
        else{
            ShowSearchPanel = true;
        }
        SelectedFolderID='';
        FetchDocuments();
        FetchFolders();
        system.debug('=======ShowSearchPanel===='+ShowSearchPanel);
    }
     ///<OBJECTIVE>
    /// Method to redirect to document page.
    ///</OBJECTIVE>
    public PageReference RedirectToTrash()
    {
        PageReference objPgRfrnce = new PageReference('/apex/ODS_TrashPage');
        objPgRfrnce.setRedirect(true);      
        return objPgRfrnce;
            
    }  
    
    /// <OBJECTIVE>
    /// Method to Validate the File name and Document Name already exist or not
     /// <OBJECTIVE> 
    @RemoteAction
    global static string ValidateDragAndDropDocument(string documentName, string accountId, string serviceId) 
    {        
        string errorMessage = '';
        string accountServiceId;
        List<Account_Services__c > accServiceList = new List<Account_Services__c >();
        accServiceList =ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        system.debug('----accServList ----'+ accServiceList );
        if(accServiceList.size() > 0)
            {
                accountServiceId= accServiceList [0].Id;
            }
            else
            {
                accountServiceId= '';
            }
        try
        {
            
           errorMessage =  ODS_Data_Utility.ValidateDocument(documentName, accountId, accountServiceId);
        }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return errorMessage;       
    } 
    /// <OBJECTIVE>
    /// Method to Validate the Attachment Name already exist or not
     /// <OBJECTIVE> 
    @RemoteAction
    global static string ValidateAttachmentName(string attachmentName){
        
        List<Attachment> attachments = ODS_Data_Utility.FetchAttachments(attachmentName);
        
        if(attachments!=null && !attachments.isEmpty())
            return 'true';
        else
            return 'false';            
    }
    
     @RemoteAction
    global static string GetFolders(string AccountId,string ServiceId)
    {
        system.debug('^^^AcntId'+AccountId);
        system.debug('^^^SrvId'+ServiceId);
        
        string accountServiceId;

        List<Folder__c> FolderNames = new List<Folder__c>();
        List<Account_Services__c > accServiceList = new List<Account_Services__c >();
        accServiceList =ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        system.debug('----accServList ----'+ accServiceList );
        
        if(accServiceList.size() > 0)
        {
            accountServiceId= accServiceList [0].Id;
            FolderNames = [SELECT Id,Name from Folder__c Where Account_Services__c =: accountServiceId Order By Name];
        }
        else
        {
            accountServiceId= '';
        }
        
         
        string folderName = Json.serialize(FolderNames);
        return folderName ;
        
    }
}