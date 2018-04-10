/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             06-Oct-2016
 * @Status           Developed
 * @description      This is the class to list the Invoice Controller.
 */
global class ODS_InvoiceController
{
    public string AccountId {get;set;}
    public string ServiceID {get;set;}
    public date FromDate {get;set;}
    public date ToDate {get;set;}
    public List<Invoice__c> InvoiceList {get;set;}
    
    //Properties for pagination
    public Integer PageSize {get;set;}
    public Integer CurrentPage {get;set;}
    public Boolean ShowPrevious {get;set;}
    public Boolean ShowNext {get;set;}
    public String CurrentPageInfo {get;set;}
    public Integer TotalRecords;
    public Integer PageNumber;

    public ODS_InvoiceController()
    {
        CurrentPage = 0; 
        PageSize = integer.valueof(System.Label.PageSize); // No of rows per page
        PageNumber = 1; 
        ShowPrevious = false; 
        GetSearchResults();
    }
    
    public void GetCustomerByAccountServiceID()
    {
    }
    
    public void GetSearchResults()
    {
        system.debug('##From Date:' +FromDate);
        InvoiceList = new List<Invoice__c>();
        InvoiceList = [Select Id, Month__c, Year__c from Invoice__c];
        TotalRecords = InvoiceList.size();
        if(TotalRecords > PageSize)
                ShowNext = true;
        else
            ShowNext = false;       
        CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
    }
    
    public PageReference GetInvoiceByAccountServiceID()
    {
        
          ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);
          //GetAccountServices();        
          return null;
    }
    
    public void EditInvoice()
    {
    }
    
    public void DeleteInvoice()
    {
    }
    
    public void AddInvoice()
    {
    }
    
    public void ResetInvoice()
    {
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
}