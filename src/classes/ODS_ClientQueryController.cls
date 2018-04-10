/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             07-Nov-2016
 * @Status           Developed
 * @description      This is a class for ODS_ClientQuery Page. 
 */
Public class ODS_ClientQueryController
{
    public string currentUserName {get;set;}
    public List<ClientQueries__c> queryLst {get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public string fromDate {get;set;}
    public string toDate {get;set;}
    public String buildQuery {get;set;}
    public String selectQuery {get;set;}
    public String whereQuery {get;set;}
    
    
    //Properties for pagination
    public Integer PageSize {get;set;}
    public Integer CurrentPage {get;set;}
    public Boolean ShowPrevious {get;set;}
    public Boolean ShowNext {get;set;}
    public String CurrentPageInfo {get;set;}
    public Integer TotalRecords;
    public Integer PageNumber; 
    
    /// <OBJECTIVE>
    /// Constructor.
    /// </OBJECTIVE>
    Public ODS_ClientQueryController()
    {
        currentUserName = UserInfo.getName();
        CurrentPage = 0; 
        PageSize = integer.valueof(System.Label.PageSize); // No. of rows per page
        PageNumber = 1; 
        ShowPrevious = false; 
        getQueriesByUserId();

    }
    public Set<string> GetAllAccounts()
    {
        Set<string> accountIdSet = new Set<string>();
        ODS_Common_Utility obj = new ODS_Common_Utility();
        String[] AccounIDs = obj.getAllAccountIDByLoggedInUser();
        for( String AccID: AccounIDs )
        {
            accountIdSet.add(AccID);
        }
        return accountIdSet;
    }
    
    public Set<string> GetAllServices()
    {
        Set<string> serviceIdSet = new Set<string>();
        for(ODS_Services__c odsService: ODS_Data_Utility.GetAllServices())
        {
            serviceIdSet.add(odsService.Id);
        }
        return serviceIdSet;
    }
    
    public void GetCustomerByAccountServiceID()
    {
      ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);
      getQueriesByUserId();
      
    }
    /// <OBJECTIVE>
    /// Get client queries by using user Id.
    /// </OBJECTIVE>
    public void GetQueriesByUserId()
    {
        Set<String> allAccountIds = new Set<string>();
        Set<String> allServiceIds = new Set<string>();
        queryLst = new List<ClientQueries__c>();
        CurrentPage = 0; 
        PageNumber = 1; 
        ShowPrevious = false;
        buildQuery = '';
        whereQuery ='';
        selectQuery = '';

        selectQuery = 'SELECT Account_Name__c, Account_Name__r.Name, Queries__c, Query_Date__c, Service_Name__c, Service_Name__r.Name__c FROM ClientQueries__c ';
        whereQuery = 'WHERE ';
        try{
            if(AccountId == 'All')
            {
                allAccountIds = GetAllAccounts();
                whereQuery += 'Account_Name__c IN: allAccountIds AND ';
            }
            else
            {
                whereQuery += 'Account_Name__c =: AccountId AND ';
            }
            if(ServiceId == 'All')
            {
                allServiceIds = GetAllServices();
                whereQuery += 'Service_Name__c IN: allServiceIds AND ';
            }  
            else
            {
                whereQuery += 'Service_Name__c =: ServiceId AND ';
            }
            if(fromDate != null && fromDate != '')
            {
                date frmDate = date.Parse(FromDate);
                whereQuery += 'Query_Date__c >=: frmDate AND ';
            }
            if(toDate != null && toDate != '')
            {
                date toDt = date.Parse(toDate);
                whereQuery += 'Query_Date__c <=: toDt AND ';
            }
    
            whereQuery = (whereQuery.trim()).removeEnd('AND');
            whereQuery = (whereQuery.trim()).removeEnd('WHERE');    
                
            buildQuery = selectQuery +whereQuery;     
            queryLst = database.query(buildQuery );
            if(queryLst.size()>0)
            {
                TotalRecords = queryLst.size();  // Total No of records need to display in Grid.      
                if(TotalRecords > PageSize)
                    ShowNext = true;
                else
                    ShowNext = false;       
                CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
            }
        }
        catch(Exception e){
            System.debug('Invalid date!!');
        }
    }
     
    /// <OBJECTIVE>
    ///  Enable disable showPrevious button.
    /// </OBJECTIVE>
    public void ShowPrevious()
    {
        CurrentPage = CurrentPage- PageSize;
        PageNumber--;
        enableDisablePaginationLinks();     
    }
    /// <OBJECTIVE>
    /// Enable disable showNext button
    /// </OBJECTIVE>
    public void ShowNext()
    {
        CurrentPage = CurrentPage + PageSize;
        PageNumber++;
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable showFirst button
    /// </OBJECTIVE>
    public void ShowFirst()
    {
        CurrentPage = 0;
        PageNumber = 1;
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable showLast button
    /// </OBJECTIVE>
    public void ShowLast()
    {
        CurrentPage = (Math.mod(TotalRecords, PageSize) == 0) ? TotalRecords - PageSize : (TotalRecords / PageSize) * PageSize;
        PageNumber = (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable pagination links
    /// </OBJECTIVE>
    public void EnableDisablePaginationLinks()
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