/**
 * @author           
 * @version          1.0 
 * @date             23-May-2017
 * @Status           Developed
 * @description      Class for creating New Folder
 */
 global class ODS_TrashPageController{

    public List<Documents__c> RecordsList { get; set; }
    
    //Properties for pagination
    public Integer PageSize {get;set;}
    public Integer CurrentPage {get;set;}
    public Boolean ShowPrevious {get;set;}
    public Boolean ShowNext {get;set;}
    //public Boolean ShowCurrentPageInfo {get;set;}
    public String CurrentPageInfo {get;set;}
    public Integer TotalRecords;
    public Integer PageNumber;

     public string AccountId {get;set;}
     public string ServiceId {get;set;}
     public string DocumentId{get;set;}
     
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

    
    public ODS_TrashPageController()
    {
         CurrentPage = 0; 
          //PageNumber = 1; 
            TotalRecords =0;
            PageSize = integer.valueof(System.Label.PageSize);
         RecordsList = new List<documents__C>();
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
            system.debug('@@@TotalRecords,pagesize,CurrentPage'+TotalRecords+PageSize+CurrentPage); 
        if((TotalRecords - PageSize) <= CurrentPage)
            ShowNext = false;
        else
            ShowNext = true;
        CurrentPageInfo = 'Showing Page ' + PageNumber +   ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
    } 
     ///<OBJECTIVE>
    /// Method to get IsDeleted Documents moved to trash.
    ///</OBJECTIVE>
    public void GetDeletedDocuments()
    {
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        try
        {   
            ODS_Common_Utility.upsertSessionData(AccountId, ServiceId);
            CurrentPage = 0; 
            PageSize = integer.valueof(System.Label.PageSize); // No. of rows per page
            PageNumber = 1; 
            TotalRecords =0;
            ShowPrevious = false; 
            //ShowCurrentPageInfo = true;
            RecordsList = ODS_Data_Utility.FetchDeletedDocuments(accountId, serviceId, sortFullExp); 
            
            if(RecordsList.size()>0)
            {
                TotalRecords = RecordsList.size();  // Total No of records need to display in Grid.      
                if(TotalRecords > PageSize){
                    ShowNext = true;
                }
                else{
                    ShowNext = false; 
                    //ShowCurrentPageInfo = false;  
                }    
                CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
            }     
            
                    
  
        }
         catch(Exception ex)
         {
             system.debug('ex.Message get Deleted Documents'+ex.getMessage());
         } 
    }
        
     ///<OBJECTIVE>
    /// Method to get current account service
    ///</OBJECTIVE>
    public void RestoreDeletedDocument()
    {
        try
        {
            DocumentId = apexpages.currentpage().getparameters().get('SelectedDocumentId');
            system.debug('@@'+DocumentId);
            ODS_Data_Utility.RestoreDocument(DocumentId);
            enableDisablePaginationLinks();
         }
         catch(DmlException ex)
         {
             system.debug('ex.Message Restore Delete'+ex.getMessage());
         }
    }
     ///<OBJECTIVE>
    /// Method to permenant delete documents
    ///</OBJECTIVE>
    public void DeleteTrashDocument()
    {
       try
        {
            //DocumentId = apexpages.currentpage().getparameters().get('SelectedDocumentId');
            system.debug('@@@@@'+DocumentId);
            ODS_Data_Utility.DeleteTrashDocument(DocumentId);
            GetDeletedDocuments();
            enableDisablePaginationLinks();
         }
         catch(DmlException ex)
         {
             system.debug('ex.Message trash Delete'+ex.getMessage());
         }
    }  
    ///<OBJECTIVE>
    /// Method to redirect to document page.
    ///</OBJECTIVE>
    public PageReference RedirectToDocumentsUpload()
    {
        
        PageReference objPgRfrnce = new PageReference('/apex/Documents');
        objPgRfrnce.setRedirect(true);      
        return objPgRfrnce;
            
    }  

}