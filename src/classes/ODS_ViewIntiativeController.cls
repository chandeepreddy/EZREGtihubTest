global class ODS_ViewIntiativeController 
{
    global integer tableSize {get;set;}
    public Boolean isCustomer { get; set; }
    public string TimesheetStatus{get;set;}
    public string FromDate {get;set;}
    public string ToDate {get;set;}
    public string AccountName {get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public string ServiceName{get;set;}
    public string AccountServiceID {get;set;} 
    public List<Initiatives__c> intiativesheetList {get;set;}
    public boolean IsApprover {get;set;}
    public boolean IsInitiativeApprover {get;set;}
    public string ApproverName {get;set;}
    public string CurrenInitiativeId {get;set;}
    public string CurrenTimesheetId {get;set;}
    public string TimesheetComments {get;set;}
    public string InitiativeComments {get;set;}
    public string DeleteTimeShtId {get;set;}
    public string DeleteInitiativeId {get;set;}
    public Boolean ShowAddTimesheet {get;set;}
    public Boolean ShowDisclaimer {get;set;}
    public string PortalUserRole {get;set;}
    public Boolean IsPortalApprover {get;set;}
    public string CurrentUserName {get;set;}
    public Boolean isMyAccShow{get;set;}
    public string SelectedAccountId{get;set;}
    public string SelectedServiceID{get;set;}
    public string HeaderData {get;set;}
    public string  UrlValue {get;set;}
    public string  URL {get;set;}

    public Time_Sheet_Cost__c objTimesheetCost;
    public  Time_Sheet_Cost__c  objTimesheetCostforNextMonth;
    public List<Contact_Account_Service__c> ContctAccService {get;set;}
    public List<Contact_Account_Service__c> InitiativeContctAccService {get;set;}
    public string ActionType{get;set;}
    
    public string WaitingforApprovalAccountId {get;set;}
    public string WaitingforApprovalServiceId {get;set;}
    
    public ODS_ViewIntiativeController() 
    {
        string URLStatus = System.CurrentPageReference().getparameters().get('TimesheetStatus'); 
        system.debug('===URLStatus==='+URLStatus);
        if(URLStatus != null){
            TimesheetStatus= 'submitted';
        }
        else{
            TimesheetStatus= 'All';
        }  
        currentUserName = UserInfo.getName(); 
        
        HeaderData = ApexPages.currentPage().getHeaders().get('Host');
        UrlValue =Apexpages.currentPage().getUrl();
        URL ='https://' + headerdata+ urlvalue;
                
        // GetTimesheet();
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());   
        PortalUserRole = objUser.PortalUserRole__c;
        IsPortalApprover = false;
        if(objUser.PortalUserRole__c == 'Customer')
        { 
            isCustomer= true;            
            ShowAddTimesheet = false;
            ShowDisclaimer = false;
        }else{
            isCustomer= false;
            ShowAddTimesheet = true;
            ShowDisclaimer = true;
            
        } 
        
        
    }
    
    public void GetSearchResults()
    {
        system.debug('##From Date:' +FromDate);
        //CurrentPage = 0;
        //PageNumber=1;
        // enableDisablePaginationLinks();
        GetTimesheet();
        
    }
    
    public void GetLoggedUserAccountService()
    {
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        PortalUserRole = objUser.PortalUserRole__c;
        //IsPortalApprover = objUser.Contact.Is_Approver__c;
        if(PortalUserRole == 'Customer')
        {   
            List<Contact> cnt = new List<Contact>();
            cnt = ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId);
            if(cnt.size() > 0){
                AccountId = cnt[0].AccountId;
            }
            else{
                AccountId = 'All';
            }
            List<Account_Services__c> accService = new List<Account_Services__c>();
            accService = ODS_Data_Utility.fetchAccServcesByAcc(AccountId);
            if(accService.size() > 0){
                ServiceId = accService[0].ODS_Services__c;
            }
            else{
                ServiceId = 'All';
            }
            
        }
        else
        {
            AccountId = 'All';
            ServiceId = 'All';
        }
    }
    
    public void SetRelatedService()
    {
        if(AccountId == 'All')
        {
            ServiceId = 'All';
        }
        else
        {
            ServiceId = 'All';
        }
    }
    
    public void GetAccountServices()
    {
        
        if(AccountId == 'All' || ServiceId == 'All')
        {
            ShowAddTimesheet = false;
            if(PortalUserRole == 'Customer')
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
            if(PortalUserRole == 'Customer')
            {
                ShowAddTimesheet = false;
            }
            else
            {
                ShowAddTimesheet = true;
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
    public PageReference GetTimesheetByAccountServiceID() {
        ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);
        GetAccountServices();          
        GetTimesheet();
        
        
        return null;
    }
    Public void GetTimesheet()
    {
        system.debug('@@@ GetTimesheet');        
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());   
        PortalUserRole = objUser.PortalUserRole__c;
        
        IsPortalApprover = false;
        if(objUser.ContactId!= null)
        {        
            system.debug('###ServiceId for contact account inside get timesheet: ' +ServiceId);
            ContctAccService  = new List<Contact_Account_Service__c>();
            ContctAccService = ODS_Data_Utility.fetchContactAccountService(objUser.ContactId, ServiceId);
            system.debug('@@@@@@ContctAccService:'+ContctAccService );        
            if(ContctAccService.size() > 0){
                IsPortalApprover = ContctAccService[0].Is_Approver__c;
               
            }
            else{
                IsPortalApprover = False;
            }
            
            InitiativeContctAccService  = new List<Contact_Account_Service__c>();
            InitiativeContctAccService  = ODS_Data_Utility.fetchInitiativeContactAccountService(objUser.ContactId, ServiceId);
            if(InitiativeContctAccService.size() > 0 ){
                IsInitiativeApprover = InitiativeContctAccService[0].Is_initiate_approver__c;
            }
            else{
               IsInitiativeApprover = False;
            }
        }
        
        Set<String> allAccountIds = new Set<string>();
        Set<String> allServiceIds = new Set<string>();
        
        system.debug('timesheetaccount'+AccountId);
        
        string Query;
        String fieldQuery = 'id,name,Account_Service__c,Account_Service__r.ODS_Service_Name__c,Account_Service__r.ODS_Account_Name__c,Estimated_hours__c, LastModifiedDate,Status__c,Utilization__c';
        string whereQuery = 'WHERE ';
        whereQuery = (whereQuery).removeEnd('AND');
            system.debug('@@@@ whereQuery: ' + whereQuery );
        
        system.debug('insidetimesheet'+AccountId);
        system.debug('insidetimesheet'+ServiceId );
        try
        {
                   
            System.debug('Fromdate'+Fromdate+'Todate'+Todate);
            Date dt;
            System.debug('TimesheetStatus'+TimesheetStatus);
            String FromDt;
            String ToDt;
                        
            List<ID> AccountServiceID = new List<ID>();
            
            if( AccountId.startsWith('001') && ServiceId.startsWith('a2') )
            {
                   List<Account_Services__c> AccountService = [select id from Account_Services__c where Account__c =: AccountId and  ODS_Services__c =:ServiceId];
                   for(Account_Services__c ASId : [select id from Account_Services__c where Account__c =: AccountId and  ODS_Services__c =:ServiceId])
                   {
                             AccountServiceID.add(ASId.id);
                   }
                   //String AccountServiceID = string.valueOf( AccountService[0].id );
                   whereQuery += 'Account_Service__c in :AccountServiceID AND' ; 
                   System.debug('whereQuery'+whereQuery);     
                                     
                   
                   
                           if(TimesheetStatus != 'All')
                           {
                                         whereQuery +=  ' Status__c =: TimesheetStatus' ;
                           }else
                           {                      
                                         whereQuery += '  Status__c != : TimesheetStatus  '; 
                           }
                                   
            }
            
           
            else if(AccountId.startsWith('001') && !ServiceId.startsWith('a2'))
            {
                     for(Account_Services__c ASId : [select id from Account_Services__c where Account__c =: AccountId])
                     {
                                    AccountServiceID.add(ASId.id);
                     }
                     whereQuery += 'Account_Service__c in :AccountServiceID AND' ; 
                     
                    
                           if(TimesheetStatus != 'All')
                           {
                                         whereQuery +=  ' Status__c =: TimesheetStatus' ;
                           }else
                           {                       
                                         whereQuery += ' Status__c != : TimesheetStatus  '; 
                                         
                           }
                    
            }
            else if(!AccountId.startsWith('001') && ServiceId.startsWith('a2'))
            {
                  for(Account_Services__c ASId : [select id from Account_Services__c where  ODS_Services__c =:ServiceId])
                  {
                           AccountServiceID.add(ASId.id);
                  }
                  whereQuery += 'Account_Service__c in :AccountServiceID AND' ;   
                  
                  
                           if(TimesheetStatus != 'All')
                           {
                                         whereQuery +=  ' Status__c =: TimesheetStatus' ;
                           }else
                           {                       
                                         whereQuery += ' Status__c != : TimesheetStatus  '; 
                                        
                           }
                  
            }
            else 
            {
                
                           if(TimesheetStatus != 'All')
                           {
                                         whereQuery +=  ' Status__c =: TimesheetStatus' ;
                           }else
                           {                      
                                         whereQuery += ' Status__c != : TimesheetStatus  '; 
                                         
                           }
                 
                             
            }
            if(PortalUserRole == 'Customer')
            {
                 string Status1 = 'Saved';   
                    
                  Query = 'SELECT ' + fieldQuery + ' FROM Initiatives__c ' + whereQuery + ' and Status__c != : Status1 ' ;
            }
            else{  
                  Query = 'SELECT ' + fieldQuery + ' FROM Initiatives__c ' + whereQuery + ' ORDER BY LastModifiedDate  DESC';
                  
            }
            system.debug('@@@@ Query:' + Query);
            intiativesheetList = Database.query(Query);  
            system.debug('@@@@@@@ intiativesheetList:' +intiativesheetList);  
                     
        }
        
        catch(Exception e)
        {
            System.debug('Invalid date!!');
        }
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
    
    public PageReference AddInitiative()
    {
        PageReference pgRef = new PageReference('/apex/InitiativePage?AccServiceId='+AccountServiceID);
        pgRef.setRedirect(true);
        return pgRef;
    }
        
    
    public PageReference ApproveInitiative()
    {
         Initiatives__c initiative = new Initiatives__c(id=CurrenInitiativeId);
         initiative.Status__c = 'Initiative Approved';
         if(InitiativeComments != null)
             initiative.Comments__c = InitiativeComments.trim();
         initiative.Approver_Name__c = UserInfo.GetUserID();
         initiative.Approved_Date__c = Date.Today();
         update initiative;
         
         String InitiativeUrl = System.Label.ODS_SalesforceURL;
         String url = InitiativeUrl+'/apex/InitiativePage?CurrenInitiativeId='+CurrenInitiativeId+'&AccServiceId='+AccountServiceID;
         Initiatives__c init = [select Client_side_Contact__r.Name, Status__c  from Initiatives__c where id =: CurrenInitiativeId];
         ODS_InitiativeController.sendEmailInitiative(CurrenInitiativeId, AccountServiceID, init.Status__c, init.Client_side_Contact__r.Name,url); 
         return null;
    }
    
    public PageReference RejectInitiative()
    {
           Initiatives__c initiative = new Initiatives__c(id=CurrenInitiativeId);
           initiative.Status__c = 'Re-evaluate';
           if(InitiativeComments != null)
               initiative.Comments__c = InitiativeComments.trim();
           initiative.Approver_Name__c = UserInfo.GetUserID();
           initiative.Approved_Date__c = Date.Today();
           update initiative;
           String InitiativeUrl = System.Label.ODS_SalesforceURL;
           String url = InitiativeUrl+'/apex/InitiativePage?CurrenInitiativeId='+CurrenInitiativeId+'&AccServiceId='+AccountServiceID;
           Initiatives__c init = [select Client_side_Contact__r.Name, Status__c  from Initiatives__c where id =: CurrenInitiativeId];
           ODS_InitiativeController.sendEmailInitiative(CurrenInitiativeId, AccountServiceID, init.Status__c, init.Client_side_Contact__r.Name,url); 
           return null;
    }
         
    public PageReference ViewInitiative()
    {
         Initiatives__c initiativeRecById = ODS_Data_Utility.FetchInitiativeByID(CurrenInitiativeId);
         
                
         AccountServiceID = initiativeRecById.Account_Service__c;
         String initiativeStats = initiativeRecById.Status__c;
         System.debug('@@@@@@@@CurrenInitiativeId in View Initiative Method'+CurrenInitiativeId);
         PageReference pgRef = new PageReference('/apex/InitiativePage?CurrenInitiativeId=' +initiativeRecById.id + '&AccServiceId='+AccountServiceID+ '&Status='+initiativeStats);

      
         pgRef.setRedirect(true);
         return pgRef;
    }
    
    
    
    public PageReference DeleteInitiative()
    {
        System.debug('##DeleteInitiativeId'+DeleteInitiativeId);
        Initiatives__c initiativedelete = new Initiatives__c(id=DeleteInitiativeId);
        if(initiativedelete != null){
             delete initiativedelete;
        }
        GetTimesheet();
        return null;
    }
    
    
    public Date FormatStringToDate(string dateString)
    {
        string[] dateArr = dateString.split('-');
        return date.Parse(dateArr[1]+'/'+dateArr[0]+'/'+dateArr[2]);
    }
    
    public List<SelectOption> GetAccountPicklistValues()
    {
        List<SelectOption> lstSlctOptn = new list<SelectOption>(); 
        ODS_Common_Utility objUtility = new ODS_Common_Utility();
        lstSlctOptn = objUtility.getCustomersByLoggedInUser();
        return lstSlctOptn;  
    }
    
    
    /// <OBJECTIVE>
    /// Fetch the Status values dynamically and returns.
    /// </OBJECTIVE>
    public List<SelectOption> GetStatusPicklistValues()
    {
        List<SelectOption> lstSlctOptn = new list<SelectOption>();        
        Schema.sObjectType objType = Initiatives__c.getSObjectType();         
        Schema.DescribeSObjectResult objDscrb = objType.getDescribe(); 
        map<String, Schema.SObjectField> mapFld = objDscrb.fields.getMap(); 
        List<Schema.PicklistEntry> lstPckLstVls = mapFld.get('status__c').getDescribe().getPickListValues();        
        lstSlctOptn.add(new SelectOption('All', 'All'));            
        
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());         
        
        if(objUser.PortalUserRole__c == 'Customer')
        {
            for (Schema.PicklistEntry picklistVal : lstPckLstVls)
            { 
                if(picklistVal.getLabel() != 'Saved'){
                    lstSlctOptn.add(new SelectOption(picklistVal.getLabel(), picklistVal.getValue())); 
                }
            }
        }
        else
        {
            for (Schema.PicklistEntry picklistVal : lstPckLstVls)
            { 
                lstSlctOptn.add(new SelectOption(picklistVal.getLabel(), picklistVal.getValue())); 
            }
        }
        return lstSlctOptn;        
    } 
    
    public PageReference InvokeFromDateMethod()
    {
        system.debug('##From Date:' +FromDate);
        return null;
    }
    
    public PageReference InvokeToDateMethod()
    {
        system.debug('##ToDate:' +ToDate);
        return null;
    }
    
    public PageReference GetTimeSheetIdFromAction()
    {
        system.debug('##CurrenInitiativeId:' +CurrenInitiativeId);    
        system.debug('##ActionType:'+ActionType);    
        system.debug('###AccountServiceID:' +AccountServiceID);
        
        /*Initiatives__c initiative = new Initiatives__c(id=CurrenInitiativeId);
        if(ActionType == 'Approve'){
            initiative.Status__c  = 'Initiative Approved';
        }
        else if(ActionType == 'Reject'){
            initiative.Status__c  = 'Re-evaluate';
            initiative.Revised_Approved__c = true;
        }
        initiative.Approver_Name__c = UserInfo.GetUserID();
        initiative.Approved_Date__c = Date.Today();        
        Update initiative;
                   
        
        if(ActionType == 'Approve'){
            ODS_InitiativeController.sendEmailInitiative(CurrenInitiativeId, AccountServiceID, init.Status__c, init.Client_side_Contact__r.Name,url); 
        }
        else if(ActionType == 'Reject'){
            
            ODS_InitiativeController.sendEmailInitiative(CurrenInitiativeId, AccountServiceID, init.Status__c, init.Client_side_Contact__r.Name,url); 
        }
        ODS_InitiativeController.sendEmailInitiative(CurrenInitiativeId, AccountServiceID, init.Status__c, init.Client_side_Contact__r.Name,URL); */
        return null;
    }
         
   }