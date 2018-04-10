/**
* @author           Gnana Prakash
* @version          1.0 
* @date             03-OCT-2016
* @Status           Developed
* @description      This is the controller class for View Timesheet Page
*
*/

global class ODS_ViewTimesheetController
{
    global integer tableSize {get;set;}
    public Boolean isCustomer { get; set; }
    public string TimesheetStatus {get;set;}
    public string FromDate {get;set;}
    public string ToDate {get;set;}
    public string AccountName {get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public string ServiceName{get;set;}
    public string AccountServiceID {get;set;} 
    public List<Timesheet__c> timesheetList {get;set;}
    public boolean IsApprover {get;set;}
    public string ApproverName {get;set;}
    public string CurrenTimesheetId {get;set;}
    public string TimesheetComments {get;set;}
    public string DeleteTimeShtId {get;set;}
    public Boolean ShowAddTimesheet {get;set;}
    public Boolean ShowDisclaimer {get;set;}
    public string PortalUserRole {get;set;}
    public Boolean IsPortalApprover {get;set;}
    public string CurrentUserName {get;set;}
    //public Integer PageSize {get;set;}
    //public Integer CurrentPage {get;set;}
    //public Boolean ShowPrevious {get;set;}
   // public Boolean ShowNext {get;set;}
    //public String CurrentPageInfo {get;set;}
   // public Integer TotalRecords;
    //public Integer PageNumber;
    public Boolean isMyAccShow{get;set;}
    public string SelectedAccountId{get;set;}
    public string SelectedServiceID{get;set;}
    //public static string timsheetid {get;set;}
    public Time_Sheet_Cost__c objTimesheetCost;
    public  Time_Sheet_Cost__c  objTimesheetCostforNextMonth;
    public List<Contact_Account_Service__c> ContctAccService {get;set;}
    
    public string WaitingforApprovalAccountId {get;set;}
    public string WaitingforApprovalServiceId {get;set;}
    
    //Public string status {get;set;}   
    public ODS_ViewTimesheetController() 
    {
        string URLStatus = System.CurrentPageReference().getparameters().get('TimesheetStatus'); 
        if(URLStatus != null){
            TimesheetStatus = 'submitted';
        }
        else{
            TimesheetStatus = 'All';
        }
        IsApprover = False;
        //CurrentPage = 0; 
        // PageSize =  integer.valueof(System.Label.PageSize); // No of rows per page
        //PageNumber = 1; 
        //ShowPrevious = false; 
        currentUserName = UserInfo.getName(); 
        
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
        }
        
        //timesheetList = new List<Timesheet__c>();
        Set<String> allAccountIds = new Set<string>();
        Set<String> allServiceIds = new Set<string>();
        
        system.debug('timesheetaccount'+AccountId);
        //CurrentPage = 0; 
        //PageNumber = 1; 
        //ShowPrevious = false; 
        string Query;
        String fieldQuery = 'id, Name, Account_Services__c,Account_Services__r.Account__c,Account_Services__r.Account__r.name,Account_Services__r.ODS_Services__c,Account_Services__r.ODS_Services__r.Name__c,LastModifiedDate'
            + ',Approver_Name__c,Status__c,Status_Date__c,Week_End_Date__c,Week_Start_Date__c,Approved_Date__c,Total_Hours__c';
        string whereQuery = 'WHERE ';
        
        system.debug('insidetimesheet'+AccountId);
        system.debug('insidetimesheet'+ServiceId );
        try
        {
            if(AccountId == 'All'){
                AccountName = 'All';
                IsApprover = False;
                allAccountIds = GetAllAccounts();            
                whereQuery += 'Account_Services__r.Account__c IN: allAccountIds AND '; 
            }
            else
            {
                system.debug('@@@ inside Account else');
                IsApprover = True;
                List<Contact_Account_Service__c> con = new List<Contact_Account_Service__c>();
                con = ODS_Data_Utility.GetAccServiceApproverName(AccountId,ServiceId);
                if(con.size() > 0){
                    ApproverName = con[0].Contact__r.Name;
                }
                else{
                    ApproverName = '';
                }
                List<Account> acc = new List<Account>();
                acc = ODS_Data_Utility.GetAccountNameById(AccountId);
                if(acc.size() > 0){
                    AccountName = acc[0].Name;
                }
                else{
                    AccountName = '';
                }
                whereQuery += 'Account_Services__r.Account__c =: AccountId AND ';
                system.debug('@@@ waitingforApproval AccountId: '+AccountId );
            }
            if(ServiceId == 'All'){
                ServiceName = 'All';
                IsApprover = False;
                allServiceIds = GetAllServices();
                whereQuery += 'Account_Services__r.ODS_Services__c IN: allServiceIds AND '; 
            }
            else
            {
                system.debug('@@@ inside service else');
                IsApprover = True;
                List<ODS_Services__c> ods = new List<ODS_Services__c>();
                ods = ODS_Data_Utility.GetServiceNameById(ServiceId);
                if(ods.size() > 0){
                    ServiceName = ods[0].Name__c;
                }
                else{
                    ServiceName = '';
                }
                whereQuery += 'Account_Services__r.ODS_Services__c =: ServiceId AND  '; 
                system.debug('@@@ waitingforApproval ServiceId: '+ServiceId );
            }
            
            if(FromDate !=null && FromDate != ''){
                date frmDate = date.Parse(FromDate);
                system.debug('###frmDate :'+frmDate); 
                date WeekStartDate = frmDate.toStartOfWeek().addDays(1); // As timesheet as saved from weekstart and end date. this code is to check the week start date of the from date.Week start date starts with sunday, hence added 1 to make it as monday.
                system.debug('###WeekStartDate:'+WeekStartDate); 
                whereQuery += 'Week_Start_Date__c >=: WeekStartDate AND '; 
            }  
            
            if(ToDate != null && ToDate != ''){
                date ToDt = date.Parse(ToDate);
                date WeekEndDate = ToDt ;
                if(ToDt != ToDt.toStartOfWeek()){
                    WeekEndDate = ToDt.toStartOfWeek().addDays(7);
                }
                whereQuery += 'Week_End_Date__c <=: WeekEndDate  AND '; 
            }
            
            if(PortalUserRole == 'Customer')
            {
                if(TimesheetStatus == 'All'){
                    string TimesheetStatus1 = 'Saved';   
                    whereQuery += 'Status__c != : TimesheetStatus1 AND ';
                    system.debug('######$$$$$TimesheetStatus :'+TimesheetStatus);
                    system.debug('######$$$$$whereQuery :'+whereQuery);
                    
                }
                else{
                    whereQuery += 'Status__c =: TimesheetStatus AND '; 
                    system.debug('######$$$$$Else:'+whereQuery);
                }            
            }
            else
            {
                system.debug('@@@@ Not customer' );
                if(TimesheetStatus != 'All'){
                    system.debug('@@@@ Not customer if loop not all' );
                    whereQuery += 'Status__c =: TimesheetStatus AND '; 
                }
            }
            date today = Date.today();
            date Currentdt = date.parse(string.valueOf(today.Month()) + '/' + string.valueOf(today.day()) + '/' + string.valueOf(today.Year()));
            //date Currentdt = date.Parse(string.valueof(today));
            date CurrentWeekEndDate = Currentdt;
            if(Currentdt != Currentdt.toStartOfWeek()){
                CurrentWeekEndDate = Currentdt.toStartOfWeek().addDays(7);
            }
            system.debug('@@@@ CurrentWeekEndDate:' + CurrentWeekEndDate);
            whereQuery += 'Week_End_Date__c <=: CurrentWeekEndDate  AND '; 
            
            whereQuery = (whereQuery.trim()).removeEnd('AND');
            system.debug('@@@@ whereQuery: ' + whereQuery );
            Query = 'SELECT ' + fieldQuery + ' FROM Timesheet__c ' + whereQuery + 'ORDER BY Week_End_Date__c DESC';
            system.debug('@@@@ Query:' + Query);
            timesheetList = Database.query(Query); 
            system.debug('@@@@@@@ timesheetList:' +timesheetList);               
           // TotalRecords = timesheetList.size();  // Total No of records need to display in Grid.
            //PageSize = integer.valueof(System.Label.PageSize); // No of rows per page
           // if(TotalRecords > 10)
            //    ShowNext = true;
           // else
              //  ShowNext = false;       
            //CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ?TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
           // CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, 10) == 0 ?TotalRecords/10 : (TotalRecords/10) + 1);
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
    
    public PageReference AddTimesheet()
    {
        PageReference pgRef = new PageReference('/apex/TimesheetPage?AccServiceId='+AccountServiceID);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public PageReference ApproveTimesheet()
    {
        system.debug('###ApproveTimesheetId:' +CurrenTimesheetId);
        TimeSheet__c timeSht = new Timesheet__c(id=CurrenTimesheetId); 
        timeSht.Status__c = 'Approved';
        timeSht.Comments__c = TimesheetComments.trim();
        timeSht.Approver_Name__c = UserInfo.GetUserID();
        timesht.Approved_Date__c = Date.Today();
        Update timeSht;
        system.debug('**timeSht'+timeSht);
        
        TimeSheet__c  timesheetobj =   ODS_Data_Utility.FetchTimesheetById(CurrenTimesheetId);
        
        AccountServiceID = timesheetobj.Account_Services__c;
        Account_Services__c objAcntSrv = [SELECT ID,ODS_Hourly_Rate_Amount__c from Account_Services__c  WHERE ID =: AccountServiceID];
        SaveTimesheetCost(timesheetobj.Week_Start_Date__c,timesheetobj.Week_End_Date__c,AccountServiceID,objAcntSrv.ODS_Hourly_Rate_Amount__c);
        UpdateODSHoursAndResCountInCost(timesheetobj, AccountServiceID);
        sendEmail(CurrenTimesheetId);
        
        return null;
    }
    
    public PageReference RejectTimesheet()
    {
        system.debug('###RejectTimesheetId:' +CurrenTimesheetId);
        system.debug('###TimesheetComments:' +TimesheetComments);
        TimeSheet__c timeSht = new Timesheet__c(id=CurrenTimesheetId);
        timeSht.Status__c = 'Rejected';
        // if(timeSht.Comments__c!= null){
        // system.debug('###IFFFFTimesheetComments:' +TimesheetComments);
        timeSht.Comments__c = TimesheetComments.trim();
        //  }        
        timeSht.Approver_Name__c = UserInfo.GetUserID();
        timesht.Approved_Date__c = Date.Today();
        Update timeSht;
        
        TimeSheet__c  timesheetobj =   ODS_Data_Utility.FetchTimesheetById(CurrenTimesheetId);
        
        AccountServiceID = timesheetobj.Account_Services__c;
        Account_Services__c objAcntSrv = [SELECT ID,ODS_Hourly_Rate_Amount__c from Account_Services__c  WHERE ID =: AccountServiceID];
        SaveTimesheetCost(timesheetobj.Week_Start_Date__c,timesheetobj.Week_End_Date__c,AccountServiceID,objAcntSrv.ODS_Hourly_Rate_Amount__c);
        UpdateODSHoursAndResCountInCost(timesheetobj, AccountServiceID);
        
        sendEmail(CurrenTimesheetId);
        return null;
    }
    public boolean SaveTimesheetCost(Date WeekStartDate, Date WeekEndDate, string CurrentAccServiceId, Decimal HourlyRate ){
        
        boolean Result = false;
        Integer startWeekmonth =WeekStartDate.month();
        Integer EndWeekmonth = WeekEndDate.month();
        
        Integer YearOfWeekstartDate = WeekStartDate.year();
        Integer YearOfWeekEndDate = WeekEndDate.year();
        
        objTimesheetCostforNextMonth = new Time_Sheet_Cost__c();
        if(startWeekmonth == EndWeekmonth)
        {
            objTimesheetCost = ODS_TimeSheetCostController.CheckIfMonthExistInCostTable(startWeekmonth,YearOfWeekstartDate,CurrentAccServiceId,HourlyRate ,WeekStartDate);
        }
        else
        {
            objTimesheetCost = ODS_TimeSheetCostController.CheckIfMonthExistInCostTable(startWeekmonth,YearOfWeekstartDate,CurrentAccServiceId,HourlyRate ,WeekStartDate);
            objTimesheetCostforNextMonth = ODS_TimeSheetCostController.CheckIfMonthExistInCostTable(EndWeekmonth,YearOfWeekEndDate ,CurrentAccServiceId,HourlyRate,WeekEndDate);
        }
        return Result;
        
    }
    
    public void UpdateODSHoursAndResCountInCost(Timesheet__c objtimeSheet, string CurrentAccServiceId){
        
        Integer startWeekmonth = objtimeSheet.Week_Start_Date__c.month();
        Integer EndWeekmonth =  objtimeSheet.Week_End_Date__c.month();
        Integer YearOfWeekstartDate =  objtimeSheet.Week_Start_Date__c.year();
        Integer YearOfWeekEndDate =  objtimeSheet.Week_End_Date__c.year();
        if(startWeekmonth == EndWeekmonth)
        {
            ODS_TimeSheetCostController.populateODSHours(objTimesheetCost,objtimeSheet.Week_Start_Date__c,CurrentAccServiceId);
            ODS_TimeSheetCostController.populateResourceCount(objTimesheetCost,objtimeSheet.Week_Start_Date__c,CurrentAccServiceId);
            ODS_TimeSheetCostController.populateRegularHours(objTimesheetCost,objtimeSheet.Week_Start_Date__c,CurrentAccServiceId);
        }
        else{
            ODS_TimeSheetCostController.populateODSHours(objTimesheetCost,objtimeSheet.Week_Start_Date__c,CurrentAccServiceId);
            ODS_TimeSheetCostController.populateResourceCount(objTimesheetCost,objtimeSheet.Week_Start_Date__c,CurrentAccServiceId);
            ODS_TimeSheetCostController.populateRegularHours(objTimesheetCost,objtimeSheet.Week_Start_Date__c,CurrentAccServiceId);  
            
            ODS_TimeSheetCostController.populateODSHours(objTimesheetCostforNextMonth,objtimeSheet.Week_End_Date__c,CurrentAccServiceId);
            ODS_TimeSheetCostController.populateResourceCount(objTimesheetCostforNextMonth,objtimeSheet.Week_End_Date__c,CurrentAccServiceId);
            ODS_TimeSheetCostController.populateRegularHours(objTimesheetCostforNextMonth,objtimeSheet.Week_End_Date__c,CurrentAccServiceId);
        }
    }
    public PageReference ViewTimesheet()
    {
        TimeSheet__c timesheetRecById = ODS_Data_Utility.FetchTimesheetById(CurrenTimesheetId);
        system.debug('@@@@ timesheetRecById: '+timesheetRecById);
        AccountServiceID = timesheetRecById.Account_Services__c;
        string timeshtStats = timesheetRecById.Status__c;
        string weekStart = string.valueOf(timesheetRecById.Week_Start_Date__c);
        
        PageReference pgRef = new PageReference('/apex/TimesheetPage?id=' +CurrenTimesheetId + '&AccServiceId='+AccountServiceID+'&Status='+timeshtStats+'&WeekStart='+weekStart);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public PageReference DeleteTimesheet()
    {
        //string TimeSheetId = Apexpages.currentPage().getParameters().get('DeleteTimeShtId');
        system.debug('##DeleteTimesheetId:'+CurrenTimesheetId);
        TimeSheet__c timeSht = new Timesheet__c(id=CurrenTimesheetId);
        delete timeSht;
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
        Schema.sObjectType objType = Timesheet__c.getSObjectType();         
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
        system.debug('##CurrenTimesheetId:' +CurrenTimesheetId);        
        return null;
    }
    
    //Pagination Methods
   /* public void showPrevious()
    {
        CurrentPage = CurrentPage- PageSize;
        PageNumber--;
        enableDisablePaginationLinks();     
    }
    // Enable disable showNext button.
    public void showNext()
    {
        CurrentPage = CurrentPage + PageSize;
        PageNumber++;
        enableDisablePaginationLinks();
    }
    // Enable disable showFirst button.
    public void showFirst()
    {
        CurrentPage = 0;
        PageNumber = 1;
        enableDisablePaginationLinks();
    }
    // Enable disable showLast button.
    public void showLast()
    {
        CurrentPage = (Math.mod(TotalRecords, PageSize) == 0) ? TotalRecords - PageSize : (TotalRecords / PageSize) * PageSize;
        PageNumber = (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
        enableDisablePaginationLinks();
    }
    public void enableDisablePaginationLinks()
    {
        if(CurrentPage == 0)
        {
            ShowPrevious = false;
        }
        else    
        {
            ShowPrevious = true;
        }   
        if((TotalRecords - PageSize) <= CurrentPage)
        {
            ShowNext = false;
        }
        else
        {
            ShowNext = true;
        }
        CurrentPageInfo = 'Showing Page ' + PageNumber +   ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
    } */
    
    
    
    
    
    /// <OBJECTIVE>
    /// Method to send email once the record is submitted.
    /// </OBJECTIVE>
    @Future(Callout = true)
    public Static void sendEmail(string timsheetid)
    {
        List<String> lstToAddress = new List<String>();
        List<String> lstCcAddress = new List<String>();
        Set<String> setToAddress = new Set<String>();
        string timesheetMailIdLabel = System.Label.ODS_TimesheetMail_Id;        
        Timesheet__c  tsTosendEmail = new Timesheet__c();
        system.debug('####@@timsheetid:' +timsheetid);
        tsTosendEmail = [Select Id, Name, Approver_Name__c,Approver_Email__c, Comments__c,Approver_Name__r.Name,Status_Date__c,Week_Start_Date__c,Week_End_Date__c,Account_Services__c,Account_Services__r.Account__c, Account_Services__r.Account__r.name, Account_Services__r.ODS_Service_Name__c, Account_Services__r.Technical_Account_manager__r.Name, Status__c from Timesheet__c where Id=: timsheetid];
        System.debug('tsTosendEmail------------'+tsTosendEmail.Account_Services__c);
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        
        System.debug('lstCcAddress------------'+lstCcAddress);
        String accntId = tsTosendEmail.Account_Services__r.Account__c;
        
        Date StartDate = tsTosendEmail.Week_Start_Date__c; 
        String FromDate = DateTime.newInstance(StartDate.year(),StartDate.month(),StartDate.day()).format('MM/dd/yyyy');       
        
        Date EndDate = tsTosendEmail.Week_End_Date__c;
        String ToDate= DateTime.newInstance(EndDate.year(),EndDate.month(),EndDate.day()).format('MM/dd/yyyy');
               
        String[] bccAddress = new List<String>();      
        String AccSerId= tsTosendEmail.Account_Services__c;
        string timshtCmts = '';
        if(tsTosendEmail.Comments__c != null && tsTosendEmail.Comments__c != ''){
               timshtCmts = tsTosendEmail.Comments__c;
        }
        System.debug('accntId------------'+accntId);
        
        //List of User Accounts associated
        List<User_Account__c> lstUsrAccnts = new List<User_Account__c>();
        lstUsrAccnts = [Select Id, name, User__c,User__r.Email, Account__c, Role_in_Account__c from User_Account__c where Account__c =: accntId];
        System.debug('lstUsrAccnts------------'+lstUsrAccnts);

        
        if(objUser.PortalUserRole__c == 'Customer') {
                if(tsTosendEmail.Approver_Email__c != null){
                         lstCcAddress.add(tsTosendEmail.Approver_Email__c);
                }
                if(timesheetMailIdLabel != null){
                         lstCcAddress.add(timesheetMailIdLabel);           
                } 
                                                     
               //get list of Cc address
               if(lstUsrAccnts.size() >0)
               {
                     for(User_Account__c objUsrAccnt: lstUsrAccnts)
                     {
                          if(objUsrAccnt.User__r.Email != null){
                              setToAddress.add(objUsrAccnt.User__r.Email);
                          }
                     }
                     if(setToAddress.size() > 0){                    
                             lstToAddress.addAll(setToAddress);   
                     }                           
               }
        }
        if(objUser.PortalUserRole__c == 'Technical Account Manager' ||  objUser.PortalUserRole__c == 'Practice Head'){
               if(lstUsrAccnts.size() >0)
               {
                     for(User_Account__c objUsrAccnt: lstUsrAccnts)
                     {
                             if(objUsrAccnt.User__r.Email != null){
                                 setToAddress.add(objUsrAccnt.User__r.Email);
                             }
                     } 
                     if(setToAddress.size() > 0){                    
                             lstToAddress.addAll(setToAddress);     
                     }                   
               }    
        } 
        
        String split_emailswithcomma = System.Label.ODS_InitiativeBCC;
        if(split_emailswithcomma != null){
                  List<String> splitted_emails = split_emailswithcomma.split(',');                                        
                  if(splitted_emails.size() > 0  ){   
                           for(String  email : splitted_emails){
                                   bccAddress.add(email);
                           }
                  }
                  else { bccAddress.add(split_emailswithcomma); }
        }

        //generate email with the details
        //PageReference pdf = Page.Test_Page;
        PageReference pdf = Page.ODS_ExportTimesheet;
        
        pdf.getParameters().put('Weekfromdate',FromDate);
        System.debug('@@@@@@@@FromDate------------'+FromDate);
        pdf.getParameters().put('Weektodate',ToDate);
        System.debug('@@@ToDate------------'+ToDate);
        pdf.getParameters().put('Accountservice',AccSerId);
        System.debug('@@@@@@@@@AccSerId------------'+AccSerId);
        
        // the contents of the attachment from the pdf
        Blob body;
        
        try {
            
            // returns the output of the page as a PDF
            body = pdf.getContent();
            System.debug('@@@@@@@@@body ------------'+body );
            
            // need to pass unit test -- current bug  
        } catch (VisualforceException e) {
            body = Blob.valueOf('Weekly Timesheet');
        }        
        
        string formattedStartDate = (tsTosendEmail.Week_Start_Date__c).format().replace('/','-');
        string formattedEndDate = (tsTosendEmail.Week_End_Date__c).format().replace('/','-');
        Messaging.EmailFileAttachment attachement = new Messaging.EmailFileAttachment();
        attachement.setContentType('appliction/pdf');
        attachement.setFileName(tsTosendEmail.Account_Services__r.Account__r.name+ ' - '+tsTosendEmail.Account_Services__r.ODS_Service_Name__c+ ' from ' +formattedStartDate + ' to ' +formattedEndDate+'.pdf');
        attachement.setInline(false);
        pdf.setRedirect(true);
        attachement.Body = body;
        
        Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
        
        if(lstToAddress.size() > 0){
                mail.setToAddresses(lstToAddress);
        }
        mail.setSenderDisplayName('DEMANDBLUE - ODS');
        if(lstCcAddress.size() > 0){
                mail.setCcAddresses(lstCcAddress);
        }
        if(bccAddress.size() > 0){
              mail.setBccAddresses(bccAddress);
        }

        String subject = 'Timesheet Report for: ' +tsTosendEmail.Account_Services__r.Account__r.name+ ' - '+tsTosendEmail.Account_Services__r.ODS_Service_Name__c+ ' from ' + (tsTosendEmail.Week_Start_Date__c).format() + ' to ' +(tsTosendEmail.Week_End_Date__c).format() + ' - ' +tsTosendEmail.Status__c;
        mail.setSubject(subject);
        
        String strHtmlBody = '' ;        
        strHtmlBody = '<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2">  Hi '
            + tsTosendEmail.Account_Services__r.Technical_Account_manager__r.Name+', <br/><br/>The timesheet for '+ (tsTosendEmail.Week_Start_Date__c).format() + ' through ' +(tsTosendEmail.Week_End_Date__c).format() +' has been '+ tsTosendEmail.Status__c
            + '.<br/><br/>';
        if(timshtCmts!=''){
            strHtmlBody += 'Comments : '+timshtCmts +' <br/><br/>';
        }
                strHtmlBody += '<table style="border:none; width:624px; border-collapse: collapse;"><tbody><tr><td style="border-top:2px solid #000; padding-bottom:15px;"></td></tr><tr><td><p style="margin:0px; color:#000;">Thanks,</p></td></tr><tr><td><p style="margin:0px; color:#000;">'+tsTosendEmail.Approver_Name__r.Name+'</p></td></tr><tr><td><table><tbody><tr><td valign="top" width="283" style="width:285px; margin:0; padding:25px;vertical-align:top; background-color:#07080A;"><a href="https://www.demandblue.com/" target="_blank"><img src="https://www.demandblue.com/image-assets/signature/demandblue-logo-signature.jpg" alt="DemandBlue" width="285" style="border:none;width:285px;display:block; margin:25px 0;"></a></td><td width="5" style="width:5px;min-width:5px;max-width:5px;margin:0;padding:0;">&nbsp;</td><td style="background-color:#4fc9f3; padding:26px; width:276px;"><table><tbody><tr><td><table><tbody><tr><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">Name</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">:</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#000;">'+tsTosendEmail.Approver_Name__r.Name+'</span></p></td></tr></tbody></table></td></tr><tr><td><p style="border-bottom:1px solid #FFF; width:267px; margin:5px 0;"></p></td></tr><tr><td><table><tbody><tr><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">Email</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">:</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#000;">'+tsTosendEmail.Approver_Email__c+'</span></p></td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td style="border-bottom:2px solid #4fc9f3; padding-top:15px;"></td></tr><tr><td width="624" valign="top" style="width:283px;border:none;padding:10px 0"><p style="text-align:justify;"><span style="font-size:11px; font-family:calibri; color:#ff0000; font-weight: bold;">CONFIDENTIALITY STATEMENT:</span><span style="font-size:11px; font-family:Arial, Sans-Serif, Times New Roman; color:#a6a6a6;">The information contained in this communication is confidential and intended only for the use of the recipient named above, and may be legally privileged and exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please resend it to the sender and delete the original message and any copy of it from your computer system</span></p></td></tr></tbody></table>'; 

        mail.setHtmlBody(strHtmlBody);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachement});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }   
}