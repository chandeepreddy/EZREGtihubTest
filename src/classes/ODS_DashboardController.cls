/**
* @author           Kirankumar D
* @version          1.0 
* @date             25-OCT-2016
* @Status           Developed
* @description      This is the controller for displaying the Saving Cost in Dashboard
*
*/
global class ODS_DashboardController
{
    // public string CurrentAccServiceId {get;set;}
    public Date dtCurrentdate;
    public string intMonth;
    public string intYear;
    Public List<Time_Sheet_Cost__c> lstTimeSt {get;set;} 
    Public List<Time_Sheet_Cost__c> lstPrevMonth {get;set;}
    Public List<Time_Sheet_Cost__c> lstThisYear {get;set;}
    Public List<Time_Sheet_Cost__c> thisMonthTmeSht {get;set;}
    Public List<Time_Sheet_Cost__c> lastMonthTmeSht {get;set;}
    public string thisYearTmeSht  {get;set;}
    public string strStartingMonth;
    public Decimal OdsCostForYear {get;set;}
    public Decimal RegCostForYear{get;set;}
    public Decimal SavingCostForYear {get;set;}
    
    //  public string SelectedGetDashboardByAccountServiceID {get;set;}
    //  public string SelectedServiceId {get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public string PortalUserRole {get;set;}
    public Boolean isCustomer{get;set;}
    public Boolean IsPortalApprover {get;set;}
    //  public string AcntId{get;set;}
    //  public string custSrvceId{get;set;}
    
    public Decimal OdsSavingCostforCurMonth{get;set;}  //To hold current month Saving Cost
    public Decimal OdsCostforCurMonth{get;set;}
    public Decimal RegularCostforCurMonth{get;set;}
    
    public Decimal OdsLastMonthSavingCost{get;set;}
    public Decimal OdsLastMonthCost{get;set;}
    public Decimal RegularLastMonthCost{get;set;}
    
    //Property to hold Formatted Currecy Values
    public string OdsFormattedSavingCost{get;set;}
    public string OdsFormattedCost{get;set;}
    public string RegularFormattedCost{get;set;}
    
    public string OdsFmtdLstMthSavingCost{get;set;}
    public string OdsFmtdLstMthCost{get;set;}
    public string RegularFmtdLstMthCost{get;set;}
    
    public string YearFmtdOdsCost {get;set;}
    public string YearFmtdRegCost {get;set;}
    public string YearFmtdSavingCost {get;set;}
    
    public string OdsThisMonthHours{get;set;}
    public string OdsLastMonthHours{get;set;}
    public decimal OdsThisYearHours{get;set;}
    
    Public string CurrentDate{get;set;}
    Public string CurrentMonthDate{get;set;}
    Public string LastMonthDate{get;set;}
    Public Integer dtCurrentYear{get;set;}
    Public Integer dtNextYear{get;set;}
    Public String strFinancialYear {get;set;}
    Public Integer currentFY;
    Public Integer currentFYMonth;
    Public Integer CurrentFYDays;
    Public Date today;
    Public static Date FYStartDate;
    Public static Date FYEndDate;
    
    // Resource utilization and Submit Query properties
    public string currentUserId{get;set;}
    public string currentUserName{get;set;}
    public string portalRole{get;set;}
    
    public List<AggregateResult> tsDetailsLst{get;set;} 
    
    public List<Account_Services__c> tamLst{get;set;}
    public string TimeshtJSONtoBind {get;set;}
    public string slctdMonth{get;set;}
    public string slctdYear{get;set;}
    public string slctdInitiative {get; set;}
    //  public string slctdAccount{get;set;}
    //  public string slctdService{get;set;}
    public user objUser{get;set;}
    public string clientQueries{get;set;}
    
    //rounding up variables
    public Long YearOdsCost {get;set;}
    public Long YearRegCost {get;set;}
    public Long YearSavingCost {get;set;}
    
    public Long OdsRoundUpSavingCost{get;set;}  //To hold rounded current month saving cost
    public Long OdsRoundUpCost{get;set;}
    public Long RegularRoundUpCost{get;set;}
    
    public Long OdsLstMthSavingCost{get;set;}
    public Long OdsLstMthCost{get;set;}
    public Long RegularLstMthCost{get;set;}
    public Boolean ShowRecOutptPnl {get;set;}
    public Boolean ShowNoRedOutptPnl {get;set;}
    
    //  Public List<Timesheet__c> lstTmeShtSutmtdHrs {get;set;}
    Public Decimal SubmittedHrs {get;set;}
    public String HrsWaitingforApproval {get;set;}
    
    //Rally Integration Properties    
    public static string slctdRallyMonth{get;set;}
    public static string slctdRallyYear{get;set;}
    public static integer countofCompletedUS {get;set;}
    public static integer countofInProgressUS{get;set;}
    public static integer countofFYCompletedUS{get;set;}
    public static String username {get;set;}
    public static String password {get;set;}
    public static String workspaceId{get;set;}
    public static Decimal avgSprintGap{get;set;}
    public static String avgSprintGapInDays{get;set;}
    public static string formattedMonthfirstDate {get;set;}
    public static string formattedMonthLastDate {get;set;}
    public static Boolean isShowRallyDetails{get;set;}
    public static string RallyResponse {get;set;}
    public String CurrentDateTime {get; set;}
    public static string JiraResponse {get;set;}
    
    public static Map<string, List<string>> mapRevisionHistories {get;set;}
    public static List<String> USRevHistryList {get;set;}
    public static Map<string, Integer> mapCompletedUserstoriesByYear {get;set;}
    public static Map<string, Integer> mapInprogressUserstoriesByYear {get;set;}
    public static string CompletedUSJSONToBind {get;set;}
    
    // Notification
    //   public static String notificationMonth {get;set;}
    //  public static String notificationkeyDataPoint {get;set;}
    //  public static List<string> AllMonthNotification {get;set;}
    //  public static List<string> AllDataPointNotification {get;set;}
    
    //   public string DashboardAccountId{get; set;}
    //   public string DashboardServiceId{get; set;}
    
    public boolean ShowTMDashboard{get; set;}
    public static string JiraDomainName {get;set;}
    public boolean ShowInitiativeChart {get; set;}
    Public static String ServiceWorkspaceId;
   
    public ODS_DashboardController()
    {
        objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        SubmittedHrs = 0;
        
        PortalUserRole = objUser.PortalUserRole__c;
        IsPortalApprover = objUser.Contact.Is_Approver__c;
        if(PortalUserRole == 'Customer')
        {   
            isCustomer = true;
            List<Contact> cnt = new List<Contact>();
            cnt = ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId);
            if(cnt.size() > 0){
                AccountId = cnt[0].AccountId;
            }
            
            system.debug('*AccountId'+AccountId);
            List<Account_Services__c> accService = new List<Account_Services__c>();
            accService = ODS_Data_Utility.fetchAccServcesByAcc(AccountId);
            if(accService.size() > 0){
                ServiceId = accService[0].ODS_Services__c;
            }
        }
        else
        {
            
        }
        currentUserId = UserInfo.getUserId();
        currentUserName = UserInfo.getName();
        Datetime objDateTime = Datetime.now(); // Returns the current Datetime based on a GMT calendar.
        CurrentDateTime  = objDateTime.format('MM/dd/YYYY'); // formats the date
        
    }
    
    public PageReference GetDashboardByAccountServiceID()   
    {  
        system.debug('@@@ GetDashboardByAccountServiceID==================');
        if((AccountId == null && ServiceId == null) || (AccountId == '' && ServiceId == ''))         
        {
            ShowRecOutptPnl = false;
            ShowNoRedOutptPnl = true;          
        }
        else
        {
            ShowRecOutptPnl = true;
            ShowNoRedOutptPnl = false;
        }
        
        if(AccountId !='' && ServiceId !='' ){
            
            if(AccountId == 'All' || ServiceId =='All'){
                system.debug('@@@ AccountId '+ AccountId );
                system.debug('@@@ ServiceId '+ ServiceId );
                ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);
                GetDashboardAll();
                PopulateWaitingforApprovalHrs();
                getTimesheetDetailsByMonthYear(AccountId, ServiceId);
                slctdMonth = string.valueof(date.today().Month());
                slctdRallyMonth = string.valueof(date.today().Month());
                slctdRallyYear = string.valueof(date.today().Year());
                
            }
            
            else{
                
                ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);
                GetDashboard();
                PopulateWaitingforApprovalHrs();
                tamLst = new List<Account_Services__c>();
                tamLst = ODS_Data_Utility.fetchTAMBySlctdId(AccountId, ServiceId);
                if(tamLst.size()>0)
                {
                    if(string.isEmpty(tamLst[0].Technical_Account_manager__r.Email))
                        tamLst[0].Technical_Account_manager__r.Email = 'Not available';
                    
                    if(string.isEmpty(tamLst[0].Technical_Account_manager__r.Phone))
                        tamLst[0].Technical_Account_manager__r.Phone = 'Not available';
                }
                getTimesheetDetailsByMonthYear(AccountId, ServiceId);
                //GetWorkspaceIdByAccountServiceId(AccountId, ServiceId);
                slctdMonth = string.valueof(date.today().Month());
                slctdRallyMonth = string.valueof(date.today().Month());
                slctdRallyYear = string.valueof(date.today().Year());
                
                GetNotification();
                
            }
        }
        return null;
    }
    /// <OBJECTIVE>
    /// Fetch sprint details and return it to visualforce page.
    /// </OBJECTIVE>
    @RemoteAction
    global static string GetRallyRelatedDetails(String Account, String Service, String rallyMonth, String rallyYear)
    {
        string Count = '';  
        countofCompletedUS = 0;
        countofInProgressUS = 0;
        countofFYCompletedUS = 0;
        try    {
            setformattedMonthDate(rallyMonth, rallyYear); 
            system.debug('##rallyMonth'+rallyMonth);
            system.debug('##rallyYear'+rallyYear);
            integer CurrentYear;    
            if (system.today().month() >= 4) 
            {
                CurrentYear = system.today().year();
            } 
            else 
            {
                CurrentYear = system.today().year()- 1;
            }
            string formattedFYStartDate = CurrentYear+'-04-01T00:00:00.000Z';
            string formattedFYEndDate = (CurrentYear+1)+'-03-31T00:00:00.000Z';
            system.debug('##formattedFYEndDate '+formattedFYEndDate );
            system.debug('##formattedFYStartDate '+formattedFYStartDate );
            
            if(fetchRallyDetailsByAccountServiceId(Account, Service))
            {
                ODS_RallyIntegration.GetWorkspaceId(userName, password, formattedMonthfirstDate, formattedMonthLastDate, formattedFYStartDate, formattedFYEndDate,ServiceWorkspaceId); //
                
                system.debug('=========SERVICE WORKSPACE ID'+ServiceWorkspaceId);
                if(RallyResponse == 'error')    
                    Count = 'Error';
                else if(RallyResponse == 'success') 
                    Count = countofCompletedUS +','+countofInProgressUS+','+countofFYCompletedUS+','+avgSprintGapInDays;
                else{}
                system.debug('##countofCompletedUS '+countofCompletedUS );
                system.debug('##countofInProgressUS'+countofInProgressUS);
                GetWorkspaceIdByAccountServiceId(Account, Service);
                GetInprogressUserStories(Account, Service);
            }
            else {  
                Count = 'No-Rally';
            }            
        }
        catch(Exception ex)    {
            system.debug('Remote Method Exception: '+ex);
        }
        system.debug('##Count'+Count);
        return Count;
        
    } 
    
    public void GetDashboardAll(){
        system.debug('@@@ get dashboard all ');
        dtCurrentdate = system.today();
        Integer intMonth = dtCurrentdate.Month();
        string strMonth = string.valueof(intMonth);
        Integer intYear = dtCurrentdate.Year();
        //dtCurrentYear = intYear;
        string strYear = string.valueof(intYear);
        Integer intPrevMonth = dtCurrentdate.Month()-1;
        string strPrevMonth = string.valueof(intPrevMonth);
        
        Organization orgInfo = ODS_Data_Utility.fetchFiscalYrStartingMonth(Userinfo.getOrganizationId());
        today = system.today();
        currentFYMonth = orgInfo.FiscalYearStartMonth;
        if (today.month() >= orgInfo.FiscalYearStartMonth) 
        {
            CurrentFY = today.year();
        } 
        else 
        {
            currentFY = today.year() - 1;
        }
        dtCurrentYear = currentFY;
        dtNextYear = currentFY+1;
        strFinancialYear = 'FY'+' '+ dtCurrentYear + ' - ' + dtNextYear; 
        CurrentFYDays = date.daysInMonth(currentFY, currentFYMonth);
        FYStartDate = date.parse(CurrentFYMonth + '/' + '01' + '/' + currentFY);
        FYEndDate = FYStartDate.addYears(1).addDays(-1);
        
        ShowTMDashboard = true;
        LoadCostSavingpanel(strMonth,strPrevMonth,strYear,FYStartDate,FYEndDate);
        LoadTimeSheetHoursPanel(strMonth,strPrevMonth,strYear,FYStartDate,FYEndDate);
    }
    
    public void GetDashboard()
    {
        system.debug('get dashboard');
        dtCurrentdate = system.today();
        Integer intMonth = dtCurrentdate.Month();
        string strMonth = string.valueof(intMonth);
        Integer intYear = dtCurrentdate.Year();
        //dtCurrentYear = intYear;
        string strYear = string.valueof(intYear);
        Integer intPrevMonth = dtCurrentdate.Month()-1;
        string strPrevMonth = string.valueof(intPrevMonth );
        
        Organization orgInfo = ODS_Data_Utility.fetchFiscalYrStartingMonth(Userinfo.getOrganizationId());
        today = system.today();
        currentFYMonth = orgInfo.FiscalYearStartMonth;
        if (today.month() >= orgInfo.FiscalYearStartMonth) 
        {
            CurrentFY = today.year();
        } 
        else 
        {
            currentFY = today.year() - 1;
        }
        dtCurrentYear = currentFY;
        dtNextYear = currentFY+1;
        strFinancialYear = 'FY'+' '+ dtCurrentYear + ' - ' + dtNextYear; 
        CurrentFYDays = date.daysInMonth(currentFY, currentFYMonth);
        FYStartDate = date.parse(CurrentFYMonth + '/' + '01' + '/' + currentFY);
        FYEndDate = FYStartDate.addYears(1).addDays(-1);
        
        List<Account_Services__c> accService = new  List<Account_Services__c>();
        string EngagementType;
        accService = ODS_Data_Utility.fetchAccServcesByAccAndSrv(AccountId,ServiceId);
        JiraDomainName = accService[0].JIRA_Domain_Name__c;  
        system.debug('---accService '+JiraDomainName );
        
        
        if(accService[0].Type_of_Engagement__c == 'ODS')
        {
            ShowTMDashboard = True; //hiden
            LoadCostSavingpanel(strMonth,strPrevMonth,strYear,FYStartDate,FYEndDate);
            LoadTimeSheetHoursPanel(strMonth,strPrevMonth,strYear,FYStartDate,FYEndDate);
        }
        else{
            ShowTMDashboard = False; //display
        }
    } 
    
    //To fetch the submitted hours based on Account and Service Id  
    public void PopulateWaitingforApprovalHrs()
    {
        /* HrsWaitingforApproval = '0';

if(AccountId!='All' && ServiceId!='ALL')
{
Account_Services__c objAcntSrv = ODS_Data_Utility.fetchAcntSrv(AccountId,ServiceId);
//lstTmeShtSutmtdHrs = ODS_Data_Utility.fetchSubmittedHrs(objAcntSrv.Id);


List<AggregateResult> HrsListforApproval = ODS_Data_Utility.fetchHrsWaitingForApproval(objAcntSrv.Id);
for(Aggregateresult eachresult:HrsListforApproval ) {
HrsWaitingforApproval = String.valueof(eachresult.get('WaitingHrs'));
}    
}   */
        
        HrsWaitingforApproval = '0';
        List<AggregateResult> HrsListforApproval=new List<AggregateResult>();
        if(AccountId != 'All' && ServiceId != 'All')
        {
            Account_Services__c objAcntSrv = ODS_Data_Utility.fetchAcntSrv(AccountId,ServiceId);
            //lstTmeShtSutmtdHrs = ODS_Data_Utility.fetchSubmittedHrs(objAcntSrv.Id);      
            HrsListforApproval = ODS_Data_Utility.fetchHrsWaitingForApproval(objAcntSrv.Id);
            for(Aggregateresult eachresult:HrsListforApproval ) {
                HrsWaitingforApproval = String.valueof(eachresult.get('WaitingHrs'));
            }    
        } 
        else 
        {     
            List<Account_Services__c> lstAcntSrv = ODS_Data_Utility.fetchAllAcntSrv(AccountId,ServiceId);
            HrsListforApproval = ODS_Data_Utility.fetchHrsWaitingForApprovalALL(lstAcntSrv);
            for(Aggregateresult eachresult:HrsListforApproval ) {
                HrsWaitingforApproval = String.valueof(eachresult.get('WaitingHrs'));
            }    
        }  
        
    }
    
    // Modified By Anil.    
    public void LoadCostSavingpanel(string strMonth,string strPrevMonth,string strYear,Date FYStartDt,Date FYEndDt)
    {
        List<Decimal> results;
        OdsCostForYear = 0;
        RegCostForYear= 0;
        thisYearTmeSht  = '0';
        
        if(AccountId == 'All' && ServiceId =='All'){
            
            //To Fetch Current Month Cost and its savings from all accounts and all services
            results = ODS_Data_Utility.fetchCurrentAllMthCost(AccountId,ServiceId,strMonth,strYear);
            
            OdsSavingCostforCurMonth = results[0];
            OdsCostforCurMonth  = results[1];
            RegularCostforCurMonth = results[2];          
            
            OdsRoundUpSavingCost = OdsSavingCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            OdsRoundUpCost = OdsCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            RegularRoundUpCost = RegularCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            
            //Fetch Current Month Formatted Currency value
            OdsFormattedSavingCost = '$' + formatCurrencyInDecimal(OdsSavingCostforCurMonth);
            OdsFormattedCost = '$' + formatCurrencyInDecimal(OdsCostforCurMonth);
            RegularFormattedCost = '$' + formatCurrencyInDecimal(RegularCostforCurMonth);
            
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            system.debug('##PreviousMonthDate.Year()'+PreviousMonthDate.Year());
            
            
            
            //To Fetch Previous Month Cost and its Savings from all accounts and all services
            results = ODS_Data_Utility.fetchCurrentAllMthCost(AccountId,ServiceId,strPrevMonth,PrevMonthYear);
            
            OdsLastMonthSavingCost = results[0];
            OdsLastMonthCost = results[1];
            RegularLastMonthCost = results[2];
            
            
            OdsLstMthSavingCost = OdsLastMonthSavingCost.round(System.RoundingMode.HALF_DOWN);
            OdsLstMthCost = OdsLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            RegularLstMthCost = RegularLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            
            //Fetch Previous Month Formatted Currency value
            OdsFmtdLstMthSavingCost = '$' + formatCurrencyInDecimal(OdsLastMonthSavingCost);
            OdsFmtdLstMthCost = '$' + formatCurrencyInDecimal(OdsLastMonthCost);
            RegularFmtdLstMthCost = '$' + formatCurrencyInDecimal(RegularLastMonthCost);
            
            //To Fetch All Year Cost and its Savings from all accounts and all services
            results = ODS_Data_Utility.fetchCurrentAllYearCost(AccountId ,ServiceId,FYStartDt,FYEndDt);
            
            OdsCostForYear = results[0];
            RegCostForYear = results[1];
            system.debug('=====OdsCostForYear===='+OdsCostForYear);
            system.debug('=====RegCostForYear===='+RegCostForYear);
            if(RegCostForYear> OdsCostForYear){
                SavingCostForYear = RegCostForYear- OdsCostForYear;
            }
            else{
                SavingCostForYear = 0; 
            } 
            
            
            
            YearOdsCost = OdsCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearRegCost = RegCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearSavingCost = SavingCostForYear.round(System.RoundingMode.HALF_DOWN);  
            
            //Fetch Current Year Formatted Currency value
            YearFmtdOdsCost = '$' + formatCurrencyInDecimal(OdsCostForYear );
            YearFmtdRegCost = '$' + formatCurrencyInDecimal(RegCostForYear);
            YearFmtdSavingCost = '$' + formatCurrencyInDecimal(SavingCostForYear );
            
            
        }
        
        
        else if(AccountId == 'All' && ServiceId !='All'){
            
            //To Fetch Current Month Cost and its savings from all accounts and particular service.
            results = ODS_Data_Utility.fetchCurrentAllMthCostAccounts(AccountId,ServiceId,strMonth,strYear);
            
            OdsSavingCostforCurMonth = results[0];
            OdsCostforCurMonth = results[1];
            RegularCostforCurMonth = results[2];                    
            
            
            OdsRoundUpSavingCost = OdsSavingCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            OdsRoundUpCost = OdsCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            RegularRoundUpCost = RegularCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            
            //Fetch Current Month Formatted Currency value
            OdsFormattedSavingCost = '$' + formatCurrencyInDecimal(OdsSavingCostforCurMonth);
            OdsFormattedCost = '$' + formatCurrencyInDecimal(OdsCostforCurMonth);
            RegularFormattedCost = '$' + formatCurrencyInDecimal(RegularCostforCurMonth);
            
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            system.debug('##PreviousMonthDate.Year()'+PreviousMonthDate.Year());
            
            //To Fetch Previous Month Cost and its Savings from all accounts and particular service.
            results = ODS_Data_Utility.fetchCurrentAllMthCostAccounts(AccountId,ServiceId,strPrevMonth,PrevMonthYear);
            
            
            OdsLastMonthSavingCost  = results[0];
            OdsLastMonthCost  = results[1];
            RegularLastMonthCost = results[2];
            
            OdsLstMthSavingCost = OdsLastMonthSavingCost.round(System.RoundingMode.HALF_DOWN);
            OdsLstMthCost = OdsLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            RegularLstMthCost = RegularLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            
            //Fetch Previous Month Formatted Currency value
            OdsFmtdLstMthSavingCost = '$' + formatCurrencyInDecimal(OdsLastMonthSavingCost);
            OdsFmtdLstMthCost = '$' + formatCurrencyInDecimal(OdsLastMonthCost);
            RegularFmtdLstMthCost = '$' + formatCurrencyInDecimal(RegularLastMonthCost);
            
            //To Fetch All Year Cost and its Savings from all accounts and particular service.
            results = ODS_Data_Utility.fetchCurrentAllYearCostAccounts(AccountId ,ServiceId,FYStartDt,FYEndDt);
            
            OdsCostForYear = results[0];
            RegCostForYear = results[1];
            
            if(RegCostForYear> OdsCostForYear){
                SavingCostForYear = RegCostForYear- OdsCostForYear;
            }
            else{
                SavingCostForYear = 0; 
            } 
            
            
            YearOdsCost = OdsCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearRegCost = RegCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearSavingCost = SavingCostForYear.round(System.RoundingMode.HALF_DOWN);  
            
            //Fetch Current Year Formatted Currency value
            YearFmtdOdsCost = '$' + formatCurrencyInDecimal(OdsCostForYear );
            YearFmtdRegCost = '$' + formatCurrencyInDecimal(RegCostForYear);
            YearFmtdSavingCost = '$' + formatCurrencyInDecimal(SavingCostForYear );
            
        }
        
        else if(AccountId != 'All' && ServiceId =='All'){
            //To Fetch Current Month Cost and its savings from all services and particular account.
            results = ODS_Data_Utility.fetchCurrentAllMthCostServices(AccountId,ServiceId,strMonth,strYear);
            
            OdsSavingCostforCurMonth = results[0];
            OdsCostforCurMonth= results[1];
            RegularCostforCurMonth = results[2];
            
            OdsRoundUpSavingCost = OdsSavingCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            OdsRoundUpCost = OdsCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            RegularRoundUpCost = RegularCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            
            //Fetch Current Month Formatted Currency value
            OdsFormattedSavingCost = '$' + formatCurrencyInDecimal(OdsSavingCostforCurMonth);
            OdsFormattedCost = '$' + formatCurrencyInDecimal(OdsCostforCurMonth);
            RegularFormattedCost = '$' + formatCurrencyInDecimal(RegularCostforCurMonth);
            
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            system.debug('##PreviousMonthDate.Year()'+PreviousMonthDate.Year());
            
            //To Fetch Previous Month Cost and its Savings from all services and particular account.
            results = ODS_Data_Utility.fetchCurrentAllMthCostServices(AccountId,ServiceId,strPrevMonth,PrevMonthYear);
            
            OdsLastMonthSavingCost = results[0];
            OdsLastMonthCost = results[1];
            RegularLastMonthCost = results[2];
            
            
            OdsLstMthSavingCost = OdsLastMonthSavingCost.round(System.RoundingMode.HALF_DOWN);
            OdsLstMthCost = OdsLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            RegularLstMthCost = RegularLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            
            //Fetch Previous Month Formatted Currency value
            OdsFmtdLstMthSavingCost = '$' + formatCurrencyInDecimal(OdsLastMonthSavingCost);
            OdsFmtdLstMthCost = '$' + formatCurrencyInDecimal(OdsLastMonthCost);
            RegularFmtdLstMthCost = '$' + formatCurrencyInDecimal(RegularLastMonthCost);
            
            
            //To Fetch All Year Cost and its Savings from all services and particular account.
            results = ODS_Data_Utility.fetchCurrentAllYearCostServices(AccountId ,ServiceId,FYStartDt,FYEndDt);
            
            OdsCostForYear = results[0];
            RegCostForYear = results[1];
            
            if(RegCostForYear> OdsCostForYear){
                SavingCostForYear = RegCostForYear- OdsCostForYear;
            }
            else{
                SavingCostForYear = 0; 
            } 
            
            
            
            YearOdsCost = OdsCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearRegCost = RegCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearSavingCost = SavingCostForYear.round(System.RoundingMode.HALF_DOWN);  
            
            //Fetch Current Year Formatted Currency value
            YearFmtdOdsCost = '$' + formatCurrencyInDecimal(OdsCostForYear );
            YearFmtdRegCost = '$' + formatCurrencyInDecimal(RegCostForYear);
            YearFmtdSavingCost = '$' + formatCurrencyInDecimal(SavingCostForYear );
            
        }
        else
        {
            
            lstTimeSt = ODS_Data_Utility.fetchCurrentMthCost(AccountId,ServiceId,strMonth,strYear);
            
            
            if(!lstTimeSt.isEmpty())
            {
                OdsSavingCostforCurMonth = lstTimeSt[0].Saving_Cost__c;
                OdsCostforCurMonth= lstTimeSt[0].ODS_Cost__c;
                RegularCostforCurMonth = lstTimeSt[0].Regular_Cost__c;
            }
            
            else
            {
                OdsSavingCostforCurMonth = 0;
                OdsCostforCurMonth= 0;
                RegularCostforCurMonth = 0;
            }
            
            OdsRoundUpSavingCost = OdsSavingCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            OdsRoundUpCost = OdsCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            RegularRoundUpCost = RegularCostforCurMonth.round(System.RoundingMode.HALF_DOWN);
            
            //Fetch Current Month Formatted Currency value
            OdsFormattedSavingCost = '$' + formatCurrencyInDecimal(OdsSavingCostforCurMonth);
            OdsFormattedCost = '$' + formatCurrencyInDecimal(OdsCostforCurMonth);
            RegularFormattedCost = '$' + formatCurrencyInDecimal(RegularCostforCurMonth);
            
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            system.debug('##PreviousMonthDate.Year()'+PreviousMonthDate.Year());
            
            //To Fetch Previous Month Cost and its Savings
            lstPrevMonth = ODS_Data_Utility.fetchCurrentMthCost(AccountId ,ServiceId,strPrevMonth,PrevMonthYear );
            
            if(!lstPrevMonth.isEmpty())
            {
                OdsLastMonthSavingCost = lstPrevMonth[0].Saving_Cost__c;
                OdsLastMonthCost = lstPrevMonth[0].ODS_Cost__c;
                RegularLastMonthCost = lstPrevMonth[0].Regular_Cost__c;
            }
            
            else{
                OdsLastMonthSavingCost = 0;
                OdsLastMonthCost = 0;
                RegularLastMonthCost = 0;
            }
            
            OdsLstMthSavingCost = OdsLastMonthSavingCost.round(System.RoundingMode.HALF_DOWN);
            OdsLstMthCost = OdsLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            RegularLstMthCost = RegularLastMonthCost.round(System.RoundingMode.HALF_DOWN);
            //Fetch Previous Month Formatted Currency value
            OdsFmtdLstMthSavingCost = '$' + formatCurrencyInDecimal(OdsLastMonthSavingCost );
            OdsFmtdLstMthCost = '$' + formatCurrencyInDecimal(OdsLastMonthCost );
            RegularFmtdLstMthCost = '$' + formatCurrencyInDecimal(RegularLastMonthCost );
            
            //Fetch current year records
            lstThisYear = ODS_Data_Utility.fetchCurrentYearCost(AccountId ,ServiceId,FYStartDt,FYEndDt);
            
            //To calculate this year total cost 
            if(!lstThisYear.isEmpty()){
                for(Time_Sheet_Cost__c objTme : lstThisYear)
                {
                    if(objTme.ODS_Cost__c!= 0 && objTme.Regular_Cost__c!=0){
                        OdsCostForYear +=    objTme.ODS_Cost__c;
                        RegCostForYear+=    objTme.Regular_Cost__c;}
                }
                
                if(RegCostForYear> OdsCostForYear)
                {
                    SavingCostForYear = RegCostForYear- OdsCostForYear;
                }
                else
                {
                    SavingCostForYear = 0; 
                } 
            }
            
            else
            {
                OdsCostForYear = 0;
                RegCostForYear= 0;
                SavingCostForYear = 0;
            }
            
            YearOdsCost = OdsCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearRegCost = RegCostForYear.round(System.RoundingMode.HALF_DOWN);
            YearSavingCost = SavingCostForYear.round(System.RoundingMode.HALF_DOWN);  
            //Fetch Current Year Formatted Currency value
            YearFmtdOdsCost = '$' + formatCurrencyInDecimal(OdsCostForYear );
            YearFmtdRegCost = '$' + formatCurrencyInDecimal(RegCostForYear);
            YearFmtdSavingCost = '$' + formatCurrencyInDecimal(SavingCostForYear );
            
        }
        
        
        
        
        
        
    }
    
    public void LoadTimeSheetHoursPanel(string strMonth,string strPrevMonth,string strYear,Date FYStartDt,Date FYEndDt )
    {
        List<Decimal> results;
        OdsThisMonthHours = '0';
        OdsLastMonthHours  = '0';
        thisYearTmeSht = '0';
        if(AccountId == 'All' && ServiceId == 'All'){
            results = ODS_Data_Utility.fetchOdsALLTmeSht(AccountId ,ServiceId,strMonth,strYear);
            
            if( results[0] != 0 ){
                OdsThisMonthHours  = string.valueof(results[0]);
            }
            
            CurrentMonthDate = TimeSheetMonthCal(date.today());
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            
            results = ODS_Data_Utility.fetchOdsALLTmeSht(AccountId ,ServiceId,strPrevMonth,PrevMonthYear);
            
            if( results[0] != 0 ){
                OdsLastMonthHours  = string.valueof(results[0]);
            }
            
            LastMonthDate = TimeSheetMonthCal(Date.today().addmonths(-1));
            
            results = ODS_Data_Utility.fetchOdsALLYearTmeSht();
            
            if( results[0] != 0){
                thisYearTmeSht = string.valueof(results[0]);
            }
            
        }
        
        else if(AccountId == 'All' && ServiceId !='All'){
            results = ODS_Data_Utility.fetchOdsALLTmeShtAccounts(AccountId ,ServiceId,strMonth,strYear);
            
            if(results[0] != 0){
                OdsThisMonthHours = string.valueof(results[0]);
            }
            
            CurrentMonthDate = TimeSheetMonthCal(date.today());
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            
            results = ODS_Data_Utility.fetchOdsALLTmeShtAccounts(AccountId ,ServiceId,strPrevMonth,PrevMonthYear);
            
            if(results[0] != 0){
                OdsLastMonthHours  = string.valueof(results[0]);
            }
            
            LastMonthDate = TimeSheetMonthCal(Date.today().addmonths(-1));
            
            results = ODS_Data_Utility.fetchOdsALLYearTmeShtAccounts(AccountId ,ServiceId,FYStartDt,FYEndDt);
            
            if(results[0] != 0){
                thisYearTmeSht = string.valueof(results[0]);
            }
        }
        
        else if(AccountId != 'All' && ServiceId =='All'){
            results = ODS_Data_Utility.fetchOdsALLTmeShtServices(AccountId ,ServiceId,strMonth,strYear);
            
            if(results[0] != 0){
                OdsThisMonthHours  = string.valueof(results[0]);
            }
            
            CurrentMonthDate = TimeSheetMonthCal(date.today());
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            
            results = ODS_Data_Utility.fetchOdsALLTmeShtServices(AccountId ,ServiceId,strPrevMonth,PrevMonthYear);
            
            if(results[0] != 0){
                OdsLastMonthHours  = string.valueof(results[0]);
            }
            
            LastMonthDate = TimeSheetMonthCal(Date.today().addmonths(-1));
            
            results = ODS_Data_Utility.fetchOdsALLYearTmeShtServices(AccountId ,ServiceId,FYStartDt,FYEndDt);
            
            if(results[0] != 0){
                thisYearTmeSht = string.valueof(results[0]);
            }
            
        }
        
        else{
            //To Calculate Timesheet Hours Current Month ODS Timesheet
            thisMonthTmeSht  = ODS_Data_Utility.fetchOdsTmeSht(AccountId ,ServiceId,strMonth,strYear);
            if(!thisMonthTmeSht.isEmpty())
            {
                if(thisMonthTmeSht[0].ODS_Hours__c != null)
                {
                    OdsThisMonthHours = string.valueof(thisMonthTmeSht[0].ODS_Hours__c);
                }
                else
                {
                    OdsThisMonthHours = '0';
                }
            }
            
            else
            {
                OdsThisMonthHours = '0';
            }
            
            system.debug('***Hours'+OdsThisMonthHours );
            CurrentMonthDate = TimeSheetMonthCal(date.today());
            Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
            string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
            system.debug('##PreviousMonthDate.Year()'+PreviousMonthDate.Year());
            system.debug('##strPrevMonth.Year()'+PreviousMonthDate.Month());
            strPrevMonth = string.valueof(PreviousMonthDate.Month());
            
            //Last Month ODS Timesheet
            lastMonthTmeSht  = ODS_Data_Utility.fetchOdsTmeSht(AccountId ,ServiceId,strPrevMonth,PrevMonthYear );
            
            if(!lastMonthTmeSht.isEmpty())
            {
                if(lastMonthTmeSht[0].ODS_Hours__c != null)
                {
                    OdsLastMonthHours = string.valueof(lastMonthTmeSht[0].ODS_Hours__c);
                }
                else
                {
                    OdsLastMonthHours = '0';
                }
            }
            
            else
            {
                OdsLastMonthHours = '0';
            }
            
            LastMonthDate = TimeSheetMonthCal(Date.today().addmonths(-1));
            
            //Fetch current year Timesheet records
            lstThisYear = ODS_Data_Utility.fetchOdsYearTmeSht(AccountId ,ServiceId,FYStartDt,FYEndDt);
            
            if(!lstThisYear.isEmpty())
            {
                decimal TimesheetYear= 0;
                
                for(Time_Sheet_Cost__c objTme : lstThisYear)
                {
                    if(objTme.ODS_Hours__c != null)
                    {
                        TimesheetYear += objTme.ODS_Hours__c;
                    }
                }
                thisYearTmeSht=string.valueof(TimesheetYear);
            }
            
            else
            {
                thisYearTmeSht  = '0';
            }
            
        }
    }
    
    public void LoadTimeSheetHrsPanel()
    {
        string strMonth = system.now().format('M');
        string strPrevMonth = string.valueOf(integer.valueOf(strMonth) - 1);
        if(strPrevMonth == '0'){
            strPrevMonth = '12';
        }
        string strYear = system.now().format('Y');
        system.debug('##CurrMonth:' + strMonth + '###CurrYear:' + strYear + '###PrevMonth:' + strPrevMonth);
        Date FYStartDt;
        Date FYEndDt;
        LoadTimeSheetHoursPanel(strMonth, strPrevMonth, strYear, FYStartDt, FYEndDt);
    }
    
    public void LoadTimeSheetAmountPanel( )
    {
        string strMonth = system.now().format('M');
        string strPrevMonth = string.valueOf(integer.valueOf(strMonth) - 1);
        if(strPrevMonth == '0'){
            strPrevMonth = '12';
        }
        string strYear = system.now().format('Y');
        system.debug('##CurrMonth:' + strMonth + '###CurrYear:' + strYear + '###PrevMonth:' + strPrevMonth);
        Date FYStartDt;
        Date FYEndDt;
        Decimal ODSCost;
        //To Calculate Timesheet Hours
        //Current Month ODS Timesheet
        thisMonthTmeSht  = ODS_Data_Utility.fetchOdsTmeSht(AccountId ,ServiceId,strMonth,strYear);
        ODSCost = 0;
        if(!thisMonthTmeSht.isEmpty()){
            for(Time_Sheet_Cost__c  Cost : thisMonthTmeSht ){
                if(Cost.ODS_Cost__c != null){
                    ODSCost += Cost.ODS_Cost__c;
                }
            }
            if(ODSCost > 0){
                OdsThisMonthHours = '$'+formatCurrencyInDecimal(ODSCost);
            }
            else
            {
                OdsThisMonthHours = '$0';
            }
        }
        else
        {
            OdsThisMonthHours = '$0';
        }
        
        CurrentMonthDate = TimeSheetMonthCal(date.today());
        Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
        string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
        system.debug('##PreviousMonthDate.Year()'+PreviousMonthDate.Year());
        system.debug('##strPrevMonth.Year()'+PreviousMonthDate.Month());
        strPrevMonth = string.valueof(PreviousMonthDate.Month());
        //Last Month ODS Timesheet
        lastMonthTmeSht  = ODS_Data_Utility.fetchOdsTmeSht(AccountId ,ServiceId,strPrevMonth,PrevMonthYear);
        ODSCost = 0;      
        if(!lastMonthTmeSht.isEmpty())
        {
            for(Time_Sheet_Cost__c  Cost : lastMonthTmeSht){
                if(Cost.ODS_Cost__c != null){
                    ODSCost  += Cost.ODS_Cost__c;
                }
            }
            if(ODSCost > 0){
                OdsLastMonthHours = '$'+formatCurrencyInDecimal(ODSCost);
            }
            else{
                OdsLastMonthHours = '$0';
            }
        }
        else{
            OdsLastMonthHours = '$0';
        }
        
        system.debug('***Last Month Amount'+OdsLastMonthHours);
        LastMonthDate = TimeSheetMonthCal(Date.today().addmonths(-1));
        
        //Fetch current year Timesheet records
        lstThisYear = ODS_Data_Utility.fetchOdsYearTmeSht(AccountId ,ServiceId,FYStartDt,FYEndDt);
        
        if(!lstThisYear.isEmpty())
        {
            decimal timesheetYear = 0;
            for(Time_Sheet_Cost__c objTme : lstThisYear)
            {
                if(objTme.ODS_Cost__c!= null)
                {
                    timesheetYear += objTme.ODS_Cost__c;
                }
            }
            thisYearTmeSht = '$' + formatCurrencyInDecimal(timesheetYear);
        }
        else
        {
            thisYearTmeSht  = '$0';
        }
        system.debug('***This Year Amount'+thisYearTmeSht);
        
        /*     string strMonth = system.now().format('M');
string strPrevMonth = string.valueOf(integer.valueOf(strMonth) - 1);
if(strPrevMonth == '0'){
strPrevMonth = '12';
}
string strYear = system.now().format('Y');
system.debug('##CurrMonth:' + strMonth + '###CurrYear:' + strYear + '###PrevMonth:' + strPrevMonth);
Date FYStartDt;
Date FYEndDt;
//To Calculate Timesheet Hours
//Current Month ODS Timesheet
thisMonthTmeSht  = ODS_Data_Utility.fetchOdsTmeSht(AccountId ,ServiceId,strMonth,strYear);
if(!thisMonthTmeSht.isEmpty())
{
if(thisMonthTmeSht[0].ODS_Cost__c!= null)
{
OdsThisMonthHours = '$'+formatCurrencyInDecimal(thisMonthTmeSht[0].ODS_Cost__c);
}
else
{
OdsThisMonthHours = '$0';
}
}
else
{
OdsThisMonthHours = '$0';
}        
system.debug('***Amount'+OdsThisMonthHours );
CurrentMonthDate = TimeSheetMonthCal(date.today());
Date PreviousMonthDate = dtCurrentdate.addMonths(-1);
string PrevMonthYear = string.valueof(PreviousMonthDate.Year());
system.debug('##PreviousMonthDate.Year()'+PreviousMonthDate.Year());
system.debug('##strPrevMonth.Year()'+PreviousMonthDate.Month());
strPrevMonth = string.valueof(PreviousMonthDate.Month());
//Last Month ODS Timesheet
lastMonthTmeSht  = ODS_Data_Utility.fetchOdsTmeSht(AccountId ,ServiceId,strPrevMonth,PrevMonthYear );
if(!lastMonthTmeSht.isEmpty())
{
if(lastMonthTmeSht[0].ODS_Cost__c!= null)
{
OdsLastMonthHours = '$'+formatCurrencyInDecimal(lastMonthTmeSht[0].ODS_Cost__c);
}
else
{
OdsLastMonthHours = '$0';
}
}
else
{
OdsLastMonthHours = '$0';
}
system.debug('***Last Month Amount'+OdsLastMonthHours);
LastMonthDate = TimeSheetMonthCal(Date.today().addmonths(-1));

//Fetch current year Timesheet records
lstThisYear = ODS_Data_Utility.fetchOdsYearTmeSht(AccountId ,ServiceId,FYStartDt,FYEndDt);

if(!lstThisYear.isEmpty())
{
decimal timesheetYear = 0;
for(Time_Sheet_Cost__c objTme : lstThisYear)
{
if(objTme.ODS_Cost__c!= null)
{
timesheetYear += objTme.ODS_Cost__c;
}
}
thisYearTmeSht = '$' + formatCurrencyInDecimal(timesheetYear);
}
else
{
thisYearTmeSht  = '$0';
}
system.debug('***This Year Amount'+thisYearTmeSht);   */
    }
    
    public string TimeSheetMonthCal (Date Todaydt)
    {
        string CurrentMonthName; 
        Integer CurrentMonthNameDay; 
        Integer CurrentYear; 
        date TodayDate = Todaydt;
        datetime TodayDateTime = Todaydt;
        Date MonthfirstDate = TodayDate.toStartOfMonth();
        Date MonthlastDate = MonthfirstDate.addDays(date.daysInMonth(TodayDate.year() , TodayDate.month())  - 1);
        CurrentMonthName = TodayDateTime.format('MMM','CDT');
        CurrentMonthNameDay = MonthfirstDate.day();
        CurrentYear = MonthlastDate.day();  
        CurrentDate = CurrentMonthName + ' ' + CurrentMonthNameDay + ' - ' + CurrentMonthName + ' ' +CurrentYear ;        
        Integer Month = Date.Today().Month()-1;
        return CurrentDate ;
    }
    /// <OBJECTIVE>
    /// insert queries into client queries object.
    /// </OBJECTIVE>
    public void insertQueries()
    {
        try {
            ODS_Data_Utility.insertClientQueries(tamLst[0].id, clientQueries, system.today(), tamLst[0].Technical_Account_manager__c,
                                                 tamLst[0].Technical_Account_manager__r.Email, objUser.Email, objUser.Name, tamLst[0].Account__c, tamLst[0].ODS_Services__c);  
            clientQueries =''; 
        }
        catch(Exception ex)    {
            system.debug(ex);
        }   
    }
    /// <OBJECTIVE>
    /// Bind month dropdown.
    /// </OBJECTIVE>
    public List<SelectOption> getMonths()
    {
        List<SelectOption> monthLst = new List<SelectOption>();
        monthLst.add(new SelectOption('0', 'All'));
        monthLst.add(new SelectOption('1', 'January'));
        monthLst.add(new SelectOption('2', 'February'));
        monthLst.add(new SelectOption('3', 'March'));
        monthLst.add(new SelectOption('4', 'April'));
        monthLst.add(new SelectOption('5', 'May'));
        monthLst.add(new SelectOption('6', 'June'));
        monthLst.add(new SelectOption('7', 'July'));
        monthLst.add(new SelectOption('8', 'August'));
        monthLst.add(new SelectOption('9', 'September'));
        monthLst.add(new SelectOption('10', 'October'));
        monthLst.add(new SelectOption('11', 'November'));
        monthLst.add(new SelectOption('12', 'December'));
        
        return monthLst;
    }
    /// <OBJECTIVE>
    /// Bind year dropdown.
    /// </OBJECTIVE>
    public List<SelectOption> getYears()
    {
        List<SelectOption> yearLst = new List<SelectOption>();
        Integer startYear = Date.today().Year();
        Integer endYear = Date.today().addYears(-3).Year();
        for(integer i = startYear; i >= endYear; i--)
        {
            yearLst.add(new SelectOption(string.ValueOf(i),string.ValueOf(i))); 
        }
        return yearLst;
    }
    
    /// <OBJECTIVE>
    /// Bind initiative dropdown.
    /// </OBJECTIVE>
    public List<SelectOption> getInitiatives()
    {
        List<SelectOption> initiativeNames = new List<selectOption>();
        ShowInitiativeChart = False;
        //initiativeNames.add(new selectOption('-select-', '-select-'));
        for(Initiatives__c i : [select Id, Name, CreatedDate, Account_Service__r.ODS_Service_Name__c, Account_Service__r.Account__c FROM Initiatives__c where Account_Service__r.Account__c =: accountId And Account_Service__r.ODS_Services__c =:serviceId And (Status__c = 'Initiative Approved' OR Status__c = 'Active Initiative' OR Status__c ='Initiative Delivered' OR Status__c ='Approved After Re-evaluation' OR Status__c ='On Hold' ) order By LastModifiedDate desc])
        {       
            ShowInitiativeChart = True;     
            initiativeNames.add(new selectOption(i.Id, i.Name));
        }
        system.debug('initiativeNames=========='+initiativeNames);
        return initiativeNames; 
    }
    
    public string formatCurrencyInDecimal(decimal CurrencyValue){
        string FormattedValue = '';  
        decimal convertedValue = 0;
        
        If(CurrencyValue >= 10000000)
        {
            convertedValue  = (CurrencyValue/10000000);
            FormattedValue= RemoveTrailingZeros(convertedValue) + 'M';
        }
        else{
            
            List<String> args = new String[]{'0','number','###,###,##0'};
                String CommaAddedValue = String.format(CurrencyValue.format(), args);
            FormattedValue = CommaAddedValue ;
            
            
            //FormattedValue =  RemoveTrailingZeros(CurrencyValue);
        }
        return FormattedValue;   
        
        
    }
    
    public string RemoveTrailingZeros(decimal value){
        /*    string strValue = value.toPlainString();
string afterdecimalvalue = '';
string BeforeDecimalValue = '';
string Result = strValue ;

if(strValue.indexof('.') > 0){
string[] decimalstring =  strValue.split('\\.');
if(decimalstring.size() > 0){
afterdecimalvalue = decimalstring[1];
BeforeDecimalValue = decimalstring[0];
}
}

if(afterdecimalvalue =='00'){
Result = BeforeDecimalValue;
}     
return Result;   */
        string strValue = value.toPlainString();
        string afterdecimalvalue = '';
        string BeforeDecimalValue = '';
        String truncated = '';
        string Result = strValue ;
        
        if(strValue.indexof('.') > 0){
            string[] decimalstring =  strValue.split('\\.');
            if(decimalstring.size() > 0){
                //   truncated = decimalstring[1].substring(0,3);
                afterdecimalvalue = decimalstring[1].substring(0,2);
                BeforeDecimalValue = decimalstring[0];
                truncated += BeforeDecimalValue+'.'+afterdecimalvalue ;
                Result = truncated;
            }
        }
        
        if(afterdecimalvalue =='00'){
            Result = BeforeDecimalValue;
        }     
        return Result;  
        
    }
    
    public string formatCurrency(Long CurrencyValue)
    {
        string FormattedValue = '';  
        If(CurrencyValue >= 1000000)
        {
            FormattedValue= string.valueof(Math.ROUND(CurrencyValue/1000000)) + 'M';
        }else if(CurrencyValue >= 1000){
            FormattedValue = string.valueof(Math.ROUND(CurrencyValue/1000)) + 'K';
        } 
        else
        {
            List<String> args = new String[]{'0','number','###,###,##0'};
                String s = String.format(CurrencyValue.format(), args);
            //FormattedValue =  string.valueof(CurrencyValue);
            FormattedValue = s;
        }  
        return FormattedValue;
    }
    /// <OBJECTIVE>
    /// To get Timesheet Details Based on Month and Year for chart diagram.
    /// </OBJECTIVE>
    public void getTimesheetDetailsByMonthYear(String AccountId, String ServiceId) 
    {  
        
        
        tsDetailsLst = new  List<AggregateResult>();
        tsDetailsLst = ODS_Data_Utility.getTimesheetDetailsByMonthYear(AccountId, ServiceId);
        
        TimeshtJSONtoBind  = JSON.serialize(tsDetailsLst);
    } 
    /// <OBJECTIVE>
    /// To get photo for the user.
    /// </OBJECTIVE>
    public String getPhoto()
    {
        String Photo = '';
        List<User_Photo__c> userPhotoLst = new List<User_Photo__c>();
        set<Id> userId = new set<Id>();
        try
        {
            if(!tamLst.isEmpty())     
                userId.add(tamLst[0].Technical_Account_manager__c);
            
            userPhotoLst = ODS_Data_Utility.fetchUserPhotoByUserId(userId);
            List<Attachment> attachedFiles = new List<Attachment>();
            if(!userPhotoLst.isEmpty())
                attachedFiles = ODS_Data_Utility.fetchAttachmentByUserPhotoId(userPhotoLst[0].Id);
            
            if(!attachedFiles.isEmpty())         
                Photo = attachedFiles[0].Id;
        }
        
        catch(Exception e)
        {
            system.debug('No rows found');
        }
        return Photo;    
    }
    
    /// <OBJECTIVE>
    /// Fetch rally related details.
    /// </OBJECTIVE>  
    public static Boolean fetchRallyDetailsByAccountServiceId(string AccountId, string ServiceId)
    {
        try {
            isShowRallyDetails = false;
            Account_Services__c objAcntSrvce = ODS_Data_Utility.fetchRallyDetailsByAccountServiceId(AccountId, ServiceId);
            if(!string.isEmpty(objAcntSrvce.Rally_User_Name__c) && !string.isEmpty(objAcntSrvce.Rally_password__c)) {
                username = objAcntSrvce.Rally_User_Name__c;
                password = objAcntSrvce.Rally_password__c;
                isShowRallyDetails = true;
                //Service workspace id of the account with multiple sevices
                ServiceWorkspaceId=objAcntSrvce.Service_Workspace_Id__c;
                system.debug('get SERVICE WORKSPACE ID=========='+ServiceWorkspaceId);
            }
        }
        catch(Exception ex)    {
            system.debug('Fetch Rally Details Exception: '+ex);
        }
        return isShowRallyDetails;
    }
    /// <OBJECTIVE>
    /// Set formatted Month first and last date.
    /// </OBJECTIVE>
    public static void setformattedMonthDate(String rallyMonth, String rallyYear)
    {
        try    {
            Date startDate;
            Date lastDayOfMonth;
            if(rallyMonth == '0'){
                startDate = Date.newInstance(integer.valueOf(rallyYear), 1, 1);
                lastDayOfMonth = Date.newInstance(startDate.year(), 12, 31);
            }
            else{
                startDate = Date.newInstance(integer.valueOf(rallyYear), integer.valueOf(rallyMonth), 1);
                Integer numberOfDays = Date.daysInMonth(startDate.year(), startDate.month());
                lastDayOfMonth = Date.newInstance(startDate.year(), startDate.month(), numberOfDays);
            }
            
            string timestring = 'T00:00:00.000Z';
            
            formattedMonthfirstDate = String.valueOf(startDate.toStartOfMonth())+timestring ;
            formattedMonthLastDate = String.valueOf(lastDayOfMonth )+timestring;
        }
        catch(Exception ex)    {
            system.debug(ex);
        }
    }
    /// <OBJECTIVE>
    /// Fetch count of Completed user stories from rally for the corresponding Month and Year.
    /// </OBJECTIVE>  
    public static void SetUSCompletedByMonthYear(string userStoryJson)
    {
        try    {
            Map<String,Object> jsonResponse = (Map<String,Object>) JSON.deserializeUntyped(userStoryJson);
            Map<String,Object> responseQuery = (Map<String,Object>) jsonResponse.get('QueryResult');
            countofCompletedUS += (Integer)responseQuery.get('TotalResultCount');
            System.debug('countofCompletedUS : '+countofCompletedUS);
        }
        catch(Exception ex)    {
            system.debug('Current Month US Completed: '+ex);
        }
    }
    /// <OBJECTIVE>
    /// Fetch count of in progress user stories  from rally for the corresponding Month and Year.
    /// </OBJECTIVE>  
    public static void SetUSInProgressByMonthYear(string userStoryJson)
    {
        try    {
            Map<String,Object> jsonResponse = (Map<String,Object>) JSON.deserializeUntyped(userStoryJson);
            Map<String,Object> responseQuery = (Map<String,Object>) jsonResponse.get('QueryResult');
            countofInProgressUS += (Integer)responseQuery.get('TotalResultCount');
            System.debug('countofInProgressUS : '+countofInProgressUS );
        }
        catch(Exception ex)    {
            system.debug('Current Month US In Progress: '+ex);
        }
    }
    /// <OBJECTIVE>
    /// Fetch count of Completed user stories from rally for the fiscal Year.
    /// </OBJECTIVE>  
    public static void SetUSCompletedByFY(string userStoryJson)
    {
        try    {
            Map<String,Object> jsonResponse = (Map<String,Object>) JSON.deserializeUntyped(userStoryJson);
            Map<String,Object> responseQuery = (Map<String,Object>) jsonResponse.get('QueryResult');
            countofFYCompletedUS += (Integer)responseQuery.get('TotalResultCount');
            System.debug('countofFYCompletedUS : '+countofFYCompletedUS); 
        }
        catch(Exception ex)    {
            system.debug('Current Month FY Completed: '+ex);
        }
    }
    /// <OBJECTIVE>
    /// Calculate the sprint gaps from rally for corresponding Account and Service.
    /// </OBJECTIVE>
    public static void CalculateSprintGaps(string resBody)
    {
        string Responsebody = resBody;
        Integer SprintDays = 0;              
        List<sprint> sprintlist = new List<sprint>();
        
        // Create a new http object to send the request object
        Map<String,Object> jsonResp = (Map<String,Object>) JSON.deserializeUntyped(Responsebody);       
        Map<String,Object> responsequery = (Map<String,Object>) jsonResp.get('QueryResult');
        Map<String,Object> resultsObject = (Map<String,Object>)responsequery;
        
        Decimal TotalResultCount = (Decimal)resultsObject.get('TotalResultCount');
        
        // A response object is generated as a result of the request
        List<Object> Responseresultquery = (List<Object>)resultsObject.get('Results');
        Map<String,Object> Result = new Map<String,Object>();
        
        for(Object obj: Responseresultquery)
        {
            Result=(Map<String,Object>) obj;             
            String StDate = (string)Result.get('StartDate');
            String EdDate = (string)Result.get('EndDate');
            sprint Sprints = new sprint();
            Sprints.sprintName = (string)Result.get('_refObjectName');
            
            Sprints.startDate = date.valueof(StDate);
            Sprints.endDate = date.valueof(EdDate);
            sprintlist.add(Sprints);                                  
        }
        
        for(integer i=0; i<sprintlist.size()-1; i++)
        {
            Date currentSprintEndDt = sprintlist[i].endDate;
            currentSprintEndDt = currentSprintEndDt .adddays(-1);
            Date NextSprintStartDt = sprintlist[i+1].startDate;
            DateTime CurrentSprintEndDateTime = DateTime.newInstance(currentSprintEndDt.Year(),currentSprintEndDt.Month(),currentSprintEndDt.Day());
            DateTime CurrentSprintStartDateTime = DateTime.newInstance(NextSprintStartDt.Year(),NextSprintStartDt.Month(),NextSprintStartDt.Day());
            
            //Get the number of days between date range
            Integer totalNumberOfDays = currentSprintendDt.daysBetween(NextSprintstartDt);
            //Do not consider startdate. Need to calculate from 'next day' of start date   
            totalNumberOfDays = totalNumberOfDays-1;
            
            //If next sprint starts before current sprint ends. In order avoid negative values, will assign zero.
            if(totalNumberOfDays < 0)
                totalNumberOfDays = 0;
            Integer NoofWeekEndsDays =  ODS_DateUtility.calculateWeekends(CurrentSprintEndDateTime, CurrentSprintStartDateTime );
            
            //Get number of working days
            Integer workingDays = (totalNumberOfDays - NoofWeekEndsDays );
            SprintDays += workingDays;
        }
        
        avgSprintGap = SprintDays /(TotalResultCount-1);
        Decimal AvgSprintGapRoundoff = (avgSprintGap.setscale(2)).stripTrailingZeros();
        
        if(AvgSprintGapRoundoff >= 0)
            avgSprintGapInDays = AvgSprintGapRoundoff + ' day(s)'; 
    }
    
    Public class sprint
    {
        public string sprintName{get;set;}
        public date startDate{get;set;}
        public date endDate{get;set;}
    }
    /// <OBJECTIVE>
    /// set rally response.
    /// </OBJECTIVE>
    public Static void SetRallyResponse(string Response)
    {
        RallyResponse = Response;
    }
    
    public Static void SetJiraResponse(string Response)
    {
        JiraResponse = Response;
    }
    
    @RemoteAction
    global static Map<string, Integer> GetInprogressUserStories(string AccountId, string ServiceId)
    {
        workspaceId = '';
        string JsonInprogressUserStories = '';
        string JsonObjDefToInprogres = '';
        string JsonObjCompToInprogress = '';        
        string JsonObjAccToInprogress = '';
        mapRevisionHistories = new Map<string, List<string>>();
        Map<string, List<string>> mapInprogressUserStoryRevHisDate  = new Map<string, List<string>>();
        mapInprogressUserstoriesByYear = new Map<string, Integer>();
        USRevHistryList = new List<String>();
        if(fetchRallyDetailsByAccountServiceId(AccountId, ServiceId))
        {
            workspaceId = ODS_RallyIntegration.GetWorkspaceId(userName, password,ServiceWorkspaceId);
            system.debug('=========SERVICE WORKSPACE ID'+ServiceWorkspaceId);
            system.debug('@@@USername:'+userName);
            system.debug('@@@password:'+password);
            JsonInprogressUserStories = ODS_RallyIntegration.GetInprogressUserstoriesTillDate(userName, password, workspaceId);
            system.debug('@@@JsonInprogressUserStories :'+JsonInprogressUserStories);
            JsonObjDefToInprogres = ODS_RallyIntegration.GetRevisionsByDescription(userName, password, 'Defined', 'In-Progress', workspaceId);
            system.debug('@@@JsonObjDefToInprogres :'+JsonObjDefToInprogres);
            JsonObjCompToInprogress = ODS_RallyIntegration.GetRevisionsByDescription(userName, password, 'Completed', 'In-Progress', workspaceId);        
            system.debug('@@@JsonObjCompToInprogress :'+JsonObjCompToInprogress);
            JsonObjAccToInprogress = ODS_RallyIntegration.GetRevisionsByDescription(userName, password, 'Accepted', 'In-Progress', workspaceId);        
            system.debug('@@@JsonObjAccToInprogress :'+JsonObjAccToInprogress);
            
            if(JsonObjDefToInprogres != ' ' || JsonObjDefToInprogres != 'Error')
                FormRevisionHistoryMap(JsonObjDefToInprogres);              
            if(JsonObjCompToInprogress != ' ' || JsonObjCompToInprogress != 'Error')
                FormRevisionHistoryMap(JsonObjCompToInprogress);  
            if(JsonObjAccToInprogress != ' ' || JsonObjAccToInprogress != 'Error')
                FormRevisionHistoryMap(JsonObjAccToInprogress);
            
            if(JsonInprogressUserStories != ' ' || JsonInprogressUserStories != 'Error')
                GetUserStoryRevisionHistory(JsonInprogressUserStories);
            
            for(string RevisionHistoryUrl: USRevHistryList)
            {
                if(mapRevisionHistories.containsKey(RevisionHistoryUrl))
                {
                    string USCreationDate = mapRevisionHistories.get(RevisionHistoryUrl)[0];
                    List<string> creationDateSplitArray = new List<string>();
                    creationDateSplitArray = USCreationDate.split('-');
                    string creationYearMonthKey = creationDateSplitArray[0]+creationDateSplitArray[1];
                    if(mapInprogressUserStoryRevHisDate.containsKey(creationYearMonthKey))
                    {
                        mapInprogressUserStoryRevHisDate.get(creationYearMonthKey).add(RevisionHistoryUrl);
                        
                    }
                    else
                    {
                        mapInprogressUserStoryRevHisDate.put(creationYearMonthKey, new List<string>{RevisionHistoryUrl});
                        
                    }
                }            
            }
            
            system.debug('%%%mapInprogressUserStoryRevHisDate'+mapInprogressUserStoryRevHisDate);
            for(string InprogressUserStoriesYear: mapInprogressUserStoryRevHisDate.keySet())
            {
                mapInprogressUserstoriesByYear.put(InprogressUserStoriesYear,(mapInprogressUserStoryRevHisDate.get(InprogressUserStoriesYear)).size());
            }
            system.debug('##mapInprogressUserstoriesByYear:' +mapInprogressUserstoriesByYear);
        }
        else{
            mapInprogressUserstoriesByYear.put('Error', 0);
        }
        return mapInprogressUserstoriesByYear;        
    }
    
    @RemoteAction
    global static Map<string, Integer> GetWorkspaceIdByAccountServiceId(string AccountId, string ServiceId)
    {
        system.debug('##Inside Getting Completed User Stories');
        string JsonObjCompAcceptedUserStories = '';
        workspaceId = '';
        string JsonObjInPrgToCompleted = '';
        string JsonObjDefToCompleted = '';        
        string JsonObjInPrgToAccepted = '';
        string JsonObjDefToAccepted = '';
        mapRevisionHistories = new Map<string, List<string>>();
        Map<string, List<string>> mapCmpltedUserStoryRevHisDate = new Map<string, List<string>>();
        mapCompletedUserstoriesByYear = new Map<string, Integer>();
        USRevHistryList = new List<String>();
        if(fetchRallyDetailsByAccountServiceId(AccountId, ServiceId))
        {
            system.debug('=========SERVICE WORKSPACE ID inside Comp US: '+ServiceWorkspaceId);
            workspaceId = ODS_RallyIntegration.GetWorkspaceId(userName, password, ServiceWorkspaceId);
            system.debug('=========SERVICE WORKSPACE ID obtained from Rally: '+workspaceId);
            system.debug('@@@USername:'+userName);
            system.debug('@@@password:'+password);
            JsonObjCompAcceptedUserStories = ODS_RallyIntegration.GetCompAcceptedUserstoriesTillDate(userName, password, workspaceId);
            system.debug('@@@JsonObjCompAcceptedUserStories :'+JsonObjCompAcceptedUserStories);
            JsonObjInPrgToCompleted = ODS_RallyIntegration.GetRevisionsByDescription(userName, password, 'In-Progress', 'Completed', workspaceId);
            system.debug('@@@JsonObjInPrgToCompleted :'+JsonObjInPrgToCompleted);
            JsonObjDefToCompleted = ODS_RallyIntegration.GetRevisionsByDescription(userName, password, 'Defined', 'Completed', workspaceId);        
            system.debug('@@@JsonObjDefToCompleted :'+JsonObjDefToCompleted);            
            //Added to include In Progress to Accepted User Stories
            JsonObjInPrgToAccepted = ODS_RallyIntegration.GetRevisionsByDescription(userName, password, 'In-Progress', 'Accepted', workspaceId);
            system.debug('@@@JsonObjInPrgToAccepted :'+JsonObjInPrgToAccepted);
            JsonObjDefToAccepted = ODS_RallyIntegration.GetRevisionsByDescription(userName, password, 'Defined', 'Accepted', workspaceId);
            system.debug('@@@JsonObjDefToAccepted :'+JsonObjDefToAccepted);
            
            if(JsonObjInPrgToAccepted != 'Error')
                FormRevisionHistoryMap(JsonObjInPrgToAccepted);              
            if(JsonObjDefToCompleted != 'Error')
                FormRevisionHistoryMap(JsonObjDefToCompleted);  
            if(JsonObjInPrgToCompleted != 'Error')
                FormRevisionHistoryMap(JsonObjInPrgToCompleted);
            if(JsonObjDefToAccepted != 'Error')
                FormRevisionHistoryMap(JsonObjDefToAccepted);
            
            if(JsonObjCompAcceptedUserStories != 'Error')
                GetUserStoryRevisionHistory(JsonObjCompAcceptedUserStories);
            system.debug('%%%USRevHistryList'+USRevHistryList);
            for(string RevisionHistoryUrl: USRevHistryList)
            {
                if(mapRevisionHistories.containsKey(RevisionHistoryUrl))
                {
                    system.debug('###mapRevisionHistories get value:' +mapRevisionHistories.get(RevisionHistoryUrl));
                    string USCreationDate = mapRevisionHistories.get(RevisionHistoryUrl)[0];
                    system.debug('##USCreationDate:' + USCreationDate);
                    List<string> creationDateSplitArray = new List<string>();
                    creationDateSplitArray = USCreationDate.split('-');
                    string creationYearMonthKey = creationDateSplitArray[0]+creationDateSplitArray[1]+creationDateSplitArray[2];
                    if(mapCmpltedUserStoryRevHisDate.containsKey(creationYearMonthKey))
                    {
                        mapCmpltedUserStoryRevHisDate.get(creationYearMonthKey).add(RevisionHistoryUrl);
                        
                    }
                    else
                    {
                        mapCmpltedUserStoryRevHisDate.put(creationYearMonthKey, new List<string>{RevisionHistoryUrl});
                        
                    }
                    system.debug('###mapCmpltedUserStoryRevHisDate:' + mapCmpltedUserStoryRevHisDate);
                }            
            }
            for(string CmpltdUserStoriesYear: mapCmpltedUserStoryRevHisDate.keySet())
            {
                mapCompletedUserstoriesByYear.put(CmpltdUserStoriesYear,(mapCmpltedUserStoryRevHisDate.get(CmpltdUserStoriesYear)).size());
            }
            system.debug('##mapCompletedUserstoriesByYear:' +mapCompletedUserstoriesByYear);
        }
        else{
            mapCompletedUserstoriesByYear.put('Error', 0);
        }
        return mapCompletedUserstoriesByYear;
        //CompletedUSJSONToBind = JSON.Serialize(mapCompletedUserstoriesByYear);
        //system.debug('###Completed US JSON:' +CompletedUSJSONToBind);
        //return CompletedUSJSONToBind;
    }
    
    public static void FormRevisionHistoryMap(string RevisionHistoryJSON)
    {
        system.debug('###RevisionHistoryJSON:'+RevisionHistoryJSON);
        Map<String, Object> mapDeserializedRevHistJson = (Map<String, Object>)JSON.deserializeUntyped(RevisionHistoryJSON);                
        Map<String, Object> mapRevHistoryQueryRslt = (Map<String, Object>)mapDeserializedRevHistJson.get('QueryResult');        
        List<Object>  revHistoryRsltList = (List<Object>)mapRevHistoryQueryRslt.get('Results');        
        Map<String, Object> mapEachRevHistRslt = new Map<String, Object>();
        for(Object RevHistRsltObj: revHistoryRsltList)
        {
            mapEachRevHistRslt = (Map<String, Object>)RevHistRsltObj;        
            Map<String, Object> mapRevHistryRslt = (Map<String, Object>)mapEachRevHistRslt.get('RevisionHistory');
            
            if(mapRevisionHistories.containsKey(string.valueOf(mapRevHistryRslt.get('_ref'))))
            {
                
                mapRevisionHistories.get(string.valueOf(mapRevHistryRslt.get('_ref'))).add(string.valueOf(mapEachRevHistRslt.get('CreationDate')));
            }
            else
            {
                mapRevisionHistories.put(string.valueOf(mapRevHistryRslt.get('_ref')), new List<string>{string.valueOf(mapEachRevHistRslt.get('CreationDate'))});
                
            }            
        }
        system.debug('##mapRevisionHistories:' +mapRevisionHistories);
        system.debug('##mapRevisionHistories Size:' +mapRevisionHistories.keySet().size());
    }
    
    public static void GetUserStoryRevisionHistory(string UserStoryJSON)
    {
        Map<String, Object> mapUSJson = (Map<String, Object>)JSON.deserializeUntyped(UserStoryJSON);        
        Map<String, Object> mapUSQueryRslt = (Map<String, Object>)mapUSJson.get('QueryResult');
        List<Object>  mapUSRslts = (List<Object>)mapUSQueryRslt.get('Results');
        Map<String, Object> mapEachRslt = new Map<String, Object>();        
        for(Object USRslts: mapUSRslts)
        {
            mapEachRslt = (Map<String, Object>)USRslts;
            Map<String, Object> mapRevHistry = (Map<String, Object>)mapEachRslt.get('RevisionHistory');
            USRevHistryList.add(string.valueOf(mapRevHistry.get('_ref')));
        }
        system.debug('##USRevHistryList:' +USRevHistryList);        
    }
    /// <OBJECTIVE>
    /// Redirect to timesheet page on click of waiting for approval hours.
    /// </OBJECTIVE>  
    public pageReference NavigateToViewTimesheetById()
    {
        pageReference pr;
        try    {
            string submitted =  'submitted';
            pr = new pageReference('/apex/viewTimesheet?AccServiceId='+AccountId+'&serviceId='+ServiceId+'&TimesheetStatus='+submitted);
            pr.setRedirect(true);
        }
        catch(Exception e)    {
            system.debug(e);
        }
        return pr;
    }
    /// <OBJECTIVE>
    /// To fetch the Notification based on account service.
    /// </OBJECTIVE>
    public list<Notification__c> GetNotification()
    {
        List<Notification__c> notification = new List<Notification__c>();
        Account_Services__c accountServiceId = ODS_Data_Utility.fetchAcntSrv(AccountId,ServiceId);
        if(accountServiceId !=null)
        {
            //Integer CurrentMonth  = Date.Today().Month();
            DateTime d = datetime.now();
            String monthName= d.format('MMMMM');
            System.debug(monthName);  
            
            
            notification = ODS_Data_Utility.GetNotification(accountServiceId.Id, monthName);
            system.debug('@@@@@@@notification'+ notification );
            
            if(notification.size() == 0)
            {
                List<Notification__c> previousNotification = new list<Notification__c>();
                
                previousNotification = ODS_Data_Utility.GetPreviousMonthNotification(accountServiceId.Id); 
                system.debug('@@@@@@@previousNotification'+ previousNotification );          
                if(previousNotification.size() != 0)
                {
                    string GetPreviousMonth = previousNotification[0].Month__c;
                    system.debug('@@@@@@@GetPreviousMonth '+ GetPreviousMonth );  
                    notification = ODS_Data_Utility.GetNotification(accountServiceId.Id, GetPreviousMonth);    
                }
            }
        }
        
        return notification;
        
    }
    
    @RemoteAction
    global static string RedirectDashboardPage(string DashboardAcntId, string DashboardSrvId)
    {
        List<Account_Services__c> accService = new  List<Account_Services__c>();
        string EngagementType;
        accService = ODS_Data_Utility.fetchAccServcesByAccAndSrv(DashboardAcntId,DashboardSrvId);
        
        system.debug('---accService '+accService );
        
        if(accService[0].Type_of_Engagement__c == 'ODS')
        {
            EngagementType = 'ODS';
        }
        else if (accService[0].Type_of_Engagement__c == 'SOW' || accService[0].Type_of_Engagement__c == 'T&M')
        {
            EngagementType = 'Other';
        }
        
        return EngagementType;
        
    }
    
    @RemoteAction
    global static string GetAverageSprintGap(String AccountId, String ServiceId)
    {
        string username='';
        string password='';
        string domainName='';
        string SprintGapCount='';
        string agileTool;
        
        try
        {
            Account_Services__c objAcntSrvce = GetJiraRelatedDetails(AccountId, ServiceId);
            username = objAcntSrvce.Rally_User_Name__c;
            password = objAcntSrvce.Rally_password__c;
            domainName = objAcntSrvce.JIRA_Domain_Name__c;
            ServiceWorkspaceId=objAcntSrvce.Service_Workspace_Id__c;
            agileTool = objAcntSrvce.Agile__c;
            system.debug('$$$agileTool'+agileTool );
            
            
            if(JiraResponse == 'error')
            {
                SprintGapCount= 'error';
                system.debug('$$$USCount '+SprintGapCount);
            }
            else
            {
                Decimal count = ODS_JIRAIntegration.GetAverageSprintGap(username , password , ServiceWorkspaceId, domainName); 
                SprintGapCount= string.valueof(count);
            }
        }
        
        catch(Exception ex)    
        {
            system.debug('Exception: '+ex);
        }
        
        return SprintGapCount;
        
    }
    
    
    
    @RemoteAction
    global static string GetLifeTimeUS(String AccountId, String ServiceId)
    {
        string username='';
        string password='';
        string domainName='';
        string LifeTimeUS='';
        string agileTool;
        try
        {
            Account_Services__c objAcntSrvce = GetJiraRelatedDetails(AccountId, ServiceId);
            username = objAcntSrvce.Rally_User_Name__c;
            password = objAcntSrvce.Rally_password__c;
            domainName = objAcntSrvce.JIRA_Domain_Name__c;
            ServiceWorkspaceId=objAcntSrvce.Service_Workspace_Id__c;
            agileTool = objAcntSrvce.Agile__c;
            system.debug('$$$agileTool'+agileTool );
            
            Integer count = ODS_JIRAIntegration.GetCompletedUserstoriesTillDate(username , password , ServiceWorkspaceId, domainName); 
            
            if(JiraResponse == 'error')
            {
                LifeTimeUS = 'error';
                system.debug('$$$USCount '+LifeTimeUS );
            }
            
            else
            {
                LifeTimeUS = string.valueof(count);
            }
            
        }
        
        catch(Exception ex)    
        {
            system.debug('Exception: '+ex);
        }
        
        
        return LifeTimeUS;
        
    }
    
    @RemoteAction
    global static string GetSelectedMonthInProgressUS(String AccountId, String ServiceId,string Month,string Year)
    {
        string USCount='';
        string username='';
        string password='';
        string domainName='';
        string agileTool;
        try
        {
            
            Account_Services__c objAcntSrvce = GetJiraRelatedDetails(AccountId, ServiceId);
            username = objAcntSrvce.Rally_User_Name__c;
            password = objAcntSrvce.Rally_password__c;
            domainName = objAcntSrvce.JIRA_Domain_Name__c;
            ServiceWorkspaceId=objAcntSrvce.Service_Workspace_Id__c;
            agileTool = objAcntSrvce.Agile__c;
            system.debug('$$$agileTool'+agileTool );
            
            
            Integer count = ODS_JIRAIntegration.GetMonthlyInProgressUS(username , password , ServiceWorkspaceId, domainName, Month, Year); 
            
            if(JiraResponse == 'error')
            {
                USCount = 'error';
                system.debug('$$$USCount '+USCount );
            }
            
            else
            {
                USCount = string.valueof(count);
            }
        }
        
        catch(Exception ex)    
        {
            system.debug('Exception: '+ex);
        }
        
        return USCount;
        
    }
    
    @RemoteAction
    global static string GetMonthlyCompletedUserStories(String AccountId, String ServiceId,string Month,string Year)
    {
        string USCount='';
        string username='';
        string password='';
        string domainName='';
        string agileTool;
        
        try
        {
            Account_Services__c objAcntSrvce = GetJiraRelatedDetails(AccountId, ServiceId);
            username = objAcntSrvce.Rally_User_Name__c;
            password = objAcntSrvce.Rally_password__c;
            domainName = objAcntSrvce.JIRA_Domain_Name__c;
            ServiceWorkspaceId=objAcntSrvce.Service_Workspace_Id__c;
            system.debug('$$$JiraResponse'+JiraResponse );
            agileTool = objAcntSrvce.Agile__c;
            system.debug('$$$agileTool'+agileTool );
            
            system.debug('$$$agileTool'+agileTool );
            Integer count = ODS_JIRAIntegration.GetMonthlyCompletedUserStories(username , password , ServiceWorkspaceId, domainName, Month, Year); 
            
            if(JiraResponse == 'error')
            {
                USCount = 'error';
                system.debug('$$$USCount '+USCount );
            }
            
            else if(JiraResponse == 'success')
            {
                USCount = string.valueof(count);
            }
            system.debug('(((USCount'+USCount);
            
        }
        
        catch(Exception ex)    
        {
            system.debug('Exception: '+ex);
        }
        
        return USCount;
    }
    
    @RemoteAction
    global static Map<string,Integer> GetTotalCompletedUSWithDate(String AccountId, String ServiceId,string Month,string Year)
    {
        string username='';
        string password='';
        string domainName='';
        string agileTool;
        Map<string,Integer> mapCompletedUserstoriesDte = new Map<string,Integer>();
        try
        {
            Account_Services__c objAcntSrvce = GetJiraRelatedDetails(AccountId, ServiceId);
            username = objAcntSrvce.Rally_User_Name__c;
            password = objAcntSrvce.Rally_password__c;
            domainName = objAcntSrvce.JIRA_Domain_Name__c;
            ServiceWorkspaceId = objAcntSrvce.Service_Workspace_Id__c;
            agileTool = objAcntSrvce.Agile__c;
            
            mapCompletedUserstoriesDte = ODS_JIRAIntegration.GetTotalCompletedUSWithDate(username , password , ServiceWorkspaceId, domainName, Month, Year); 
        }
        
        catch(Exception ex)    
        {
            system.debug('Exception: '+ex);
        }
        
        return mapCompletedUserstoriesDte ;
        
    }
    
    public static Account_Services__c GetJiraRelatedDetails(string AccountId,string ServiceId)
    {
        Account_Services__c objAcntSrvce = new Account_Services__c();
        try
        {
            objAcntSrvce = ODS_Data_Utility.fetchRallyDetailsByAccountServiceId(AccountId, ServiceId);
            JiraDomainName = objAcntSrvce.JIRA_Domain_Name__c;
        }
        
        catch(Exception ex)    
        {
            system.debug('Exception: '+ex);
        }
        return objAcntSrvce;
    }
    
     @RemoteAction
    global static decimal get_Consumed_Hours(String initiativeId)
    {
        decimal utilizedHrs;
        for(Initiatives__c i : [select Id, Name, CreatedDate,Consumed_Hours__c,Utilization__c FROM Initiatives__c where Id =:initiativeId]){
            utilizedHrs = i.Utilization__c;
            system.debug('@@@consumedHrs======'+utilizedHrs);
        }
        return utilizedHrs;
    }
}