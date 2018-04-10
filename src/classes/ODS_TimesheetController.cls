/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             03-OCT-2016
 * @Status           Developed
 * @description      This is the controller class for View Timesheet Page
 *
 */

global class ODS_TimesheetController
{
    public string CurrenTimesheetId {get;set;}
    public string PassedTimesheetJSON {get;set;}
    public string currentUserName {get;set;}
    public string AccountName {get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public string ServiceName{get;set;}
    public string CurrentAccServiceId {get;set;}
    public string TimesheetComments {get;set;}
    public boolean IsPortalApprover {get;set;}
    public string PortalUserRole {get;set;}
    public string TimeshtJSONtoBind {get;set;}
    public string CurrentTimeSheetStatus {get;set;}
    public string PassedWeekFromDate{get;set;}
    public string PassedWeekToDate{get;set;}
    public boolean isMyAccShow {get;set;}
    public boolean isCustomer {get;set;}
    public Time_Sheet_Cost__c objTimesheetCost;
    public Date dtStartDate;
    public Date dtEndDate;
    public String CurrentDate {get; set;}
    public  Time_Sheet_Cost__c  objTimesheetCostforNextMonth;   
    public List<AggregateResult> resourceNameLst{get;set;}
    public List<AggregateResult> InitiativeLst{get;set;}
    public Boolean ShowPDFButton {get;set;} 
    public string resourceNameJSONtoBind {get;set;}
    public string initiativeJSONtoBind {get;set;}
    public List<Contact_Account_Service__c> ContctAccService {get;set;}
    public Boolean IsTimesheetInsert {get; set;}
    public string hdnActionValue {get; set;}
    public string invalidInitiativeName {get; set;}
    public decimal invalidInitiateEstimtdHrs {get; set;}
    public decimal inavlidInitiateRemHrs {get; set;}
    
    public ODS_TimesheetController()
    {
       system.debug('@@@ Inside ODS_TimesheetController');
        Datetime currentDateTime = Datetime.now(); // Returns the current Datetime based on a GMT calendar.
        CurrentDate  = currentDateTime.format('MM/dd/yyyy'); // formats the date
              
        objTimesheetCost = new Time_Sheet_Cost__c();
        CurrentAccServiceId = ApexPages.CurrentPage().getParameters().get('AccServiceId');
        CurrenTimesheetId = ApexPages.CurrentPage().getParameters().get('Id');
        CurrentTimeSheetStatus = ApexPages.CurrentPage().getParameters().get('Status');        
        PassedWeekFromDate = ApexPages.CurrentPage().getParameters().get('WeekStart');
        currentUserName = UserInfo.getName();       
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        system.debug('@@@@@@objUser.ContactId:'+objUser.Contact.Id );
        
        PortalUserRole = objUser.PortalUserRole__c;
        IsPortalApprover = False;
        if(objUser.ContactId!= null)
        {        
           if(CurrentAccServiceId != null){
               List<Account_Services__c > accServiceById = new List<Account_Services__c >();
               accServiceById = ODS_Data_Utility.fetchRelatedAccountService(CurrentAccServiceId);
               if(accServiceById.size() >0){
                   ContctAccService = new List<Contact_Account_Service__c>();
                   ContctAccService  = ODS_Data_Utility.fetchContactAccountService(objUser.ContactId, accServiceById[0].ODS_Services__c); 
                   system.debug('@@@@@@ContctAccService:'+ContctAccService);        
                   if(ContctAccService.size() >0){
                       IsPortalApprover = ContctAccService[0].Is_Approver__c;
                   }
               }
           }
        }
        
        //IsPortalApprover = objUser.Contact.Is_Approver__c;
        system.debug('###CurrenTimesheetId:'+CurrenTimesheetId);
        if(CurrenTimesheetId != null){
         GetTimesheetDetails(CurrenTimesheetId);
            
          TimeSheet__c timesheetobj = new TimeSheet__c();  
          timesheetobj = ODS_Data_Utility.FetchTimesheetById(CurrenTimesheetId);          
              CurrentTimeSheetStatus  = timesheetobj.Status__c;          
        }
        if(CurrentAccServiceId == null){
            GetLoggedUserAccountService(); 
        }
        else{
            AssignPassedAccountService();
        }
        GetAccountServiceChanges();
        if(objUser.PortalUserRole__c == 'Customer')
        { 
            isCustomer= true;
        }  
        getResourceNameByAccountServiceId(AccountId, ServiceId); 
        getInitiativeByAccountServiceId(AccountId, ServiceId);        
    }
    
    public void GetTimesheetDetails(string TimesheetId)
    {
        List<Time_Sheet_Details__c> timeShtDetailList = new List<Time_Sheet_Details__c>();
        system.debug('###PortalUserRole :' +PortalUserRole);
        if(PortalUserRole != 'Customer'){
            timeShtDetailList = ODS_Data_Utility.FetchTimesheetDetailsbyId(TimesheetId);
        }
        else{
            timeShtDetailList = ODS_Data_Utility.FetchCustomerTimesheetDetails(TimesheetId);
        }
        List<TimeSheet__c> timesheetobj = new List<TimeSheet__c>();
        timesheetobj = ODS_Data_Utility.FetchTimesheetRecById(CurrenTimesheetId);
        string cmmts = '';
        if(timesheetobj.size() >0){
            CurrentTimeSheetStatus  = timesheetobj[0].Status__c;
            if(timesheetobj[0].Comments__c != null && timesheetobj[0].Comments__c != '')
            {
                cmmts = timesheetobj[0].Comments__c;
            }
        }else{
            CurrentTimeSheetStatus  ='';
        }                        
        TimeshtJSONtoBind = JSON.serialize(timeShtDetailList)+'~'+CurrentTimeSheetStatus  +'~'+cmmts ;
         TimeshtJSONtoBind  = TimeshtJSONtoBind.Replace('\'','$#$');
        system.debug('###TimeshtJSONtoBind:' +TimeshtJSONtoBind);
    }
    
    public void GetWeeklyTimesheet()
    {
        system.debug('##PassedWeekFromDate:' +PassedWeekFromDate);
        system.debug('##PassedWeekToDate:' +PassedWeekToDate);
        system.debug('###CurrentAccServiceId :' +CurrentAccServiceId);
        List<Timesheet__c> timesheetRelatedDate = new List<Timesheet__c>();
        timesheetRelatedDate = ODS_Data_Utility.FetchTimesheetByDate(CurrentAccServiceId,date.parse(PassedWeekFromDate),date.parse(PassedWeekToDate));
        system.debug('###timesheetRelatedDate :' +timesheetRelatedDate);
        if(timesheetRelatedDate.size() > 0){
            CurrenTimesheetId = timesheetRelatedDate[0].Id;
            GetTimesheetDetails(CurrenTimesheetId);    
               
                
        }
        else{
            CurrenTimesheetId = '';
            TimeshtJSONtoBind = '';
        }        
    }
    
    public void AssignPassedAccountService()
    {
        List<Account_Services__c > accServiceLst = new List<Account_Services__c >();
        accServiceLst = ODS_Data_Utility.fetchRelatedAccountService(CurrentAccServiceId);
        if(accServiceLst.size() > 0){
            AccountId = accServiceLst[0].Account__c;
            ServiceId = accServiceLst[0].ODS_Services__c;
        }
    }
    
    public void AddRow()
    {
    }
    
    public PageReference GetTimeSheetIdFromAction()
    {
        system.debug('##CurrenTimesheetId:' +CurrenTimesheetId);        
        return null;
    }
    
    public void GetLoggedUserAccountService()
    {
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        if(objUser.PortalUserRole__c == 'Customer')
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
            List<Account_Services__c> accServices = new List<Account_Services__c>();
            accServices = ODS_Data_Utility.fetchAccServcesByAcc(AccountId);
            if(accServices.size() > 0)
            {
                ServiceId = accServices[0].ODS_Services__c;
            }
            else
            {
                ServiceId = 'All';
            }
        }
    }
    
    public static List<SelectOption> GetAccountPicklistValues()
    {
      
      List<SelectOption> lstSlctOptn = new list<SelectOption>(); 
        ODS_Common_Utility objUtility = new ODS_Common_Utility();
        //lstSlctOptn = objUtility.getCustomersByLoggedInUser();
        return lstSlctOptn;
    }
    
  
    
    public void GetTimesheetByAccountServiceID(string SelectedAccountId, string SelectedServiceID)
    {
        ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);
        GetAccountServiceChanges();  
        GetWeeklyTimesheet();     
    }
    
    public PageReference GetTimesheetByAccountServiceID() {
        
        GetTimesheetByAccountServiceID(AccountId,ServiceID);
        return null;
    }
    
    public void GetAccountServiceChanges()
    {
        List<Account> acc = new List<Account>();
        acc = ODS_Data_Utility.GetAccountNameById(AccountId);
        if(acc.size() > 0){
            AccountName = acc[0].Name;
        }
        else{
            AccountName = 'All';
        }
        List<ODS_Services__c> ods = new List<ODS_Services__c>();
        ods = ODS_Data_Utility.GetServiceNameById(ServiceId);
        if(ods.size() > 0){
            ServiceName = ods[0].Name__c;
        }
        else{
            ServiceName = 'All';
        }
        
        List<Account_Services__c > accServList = new List<Account_Services__c >();
        accServList = ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        if(accServList.size() > 0){
            CurrentAccServiceId = accServList[0].Id;
        }
        else{
            CurrentAccServiceId = '';
        } 
    }
    
    public void SaveTimesheet()
    {   
        system.debug('##Saved PassedTimesheetJSON:' + PassedTimesheetJSON);
        system.debug('##hdnActionValue:' + hdnActionValue);
        
        Map<String, Object> timesheetJSONmap = (Map<String, Object>)JSON.deserializeUntyped(PassedTimesheetJSON);
      
        Timesheet__c timeSheet = new Timesheet__c();
        PassedWeekFromDate = string.valueOf(timesheetJSONmap.get('WeekStartDate'));
        PassedWeekToDate = string.valueOf(timesheetJSONmap.get('WeekEndDate'));
       
        Date dtWeekEndMonth = date.parse(PassedWeekToDate);
        dtStartDate = date.parse(PassedWeekFromDate); //Start Week date
        dtEndDate = date.parse(PassedWeekToDate); //End Week date
        Account_Services__c objAcntSrv = [SELECT ID,ODS_Hourly_Rate_Amount__c, Account__c,Account__r.Name from Account_Services__c  WHERE ID =: CurrentAccServiceId];
        list<User_Account__c> userAcc = new list<User_Account__c> ();
        System.debug('%%%%%%%%objAcntSrv.Id'+objAcntSrv.Id);
        userAcc = [SELECT Account__c, User__c, User__r.Email, Role_in_Account__c FROM User_Account__c WHERE Account__c =: objAcntSrv.Account__c AND Role_in_Account__c = 'Account Manager' LIMIT 1];
        SaveTimesheetCost(dtStartDate,dtEndDate,CurrentAccServiceId,objAcntSrv.ODS_Hourly_Rate_Amount__c);
        system.debug('###objTimesheetCost.Id'+objTimesheetCost.Id);
        System.debug('%%%%%%%%userAcc'+userAcc);
        //Original Code
        timeSheet.Week_Start_Date__c = date.parse(PassedWeekFromDate);
        Integer month = timeSheet.Week_Start_Date__c.month();
        timeSheet.Week_End_Date__c = date.parse(PassedWeekToDate);
        if(userAcc.size()>0){
            timeSheet.Account_Manager_Email__c = userAcc[0].User__r.Email;
            System.debug('%%%%%%%%timeSheet.Account_Manager_Email__c'+ timeSheet.Account_Manager_Email__c);
        }
        timeSheet.Account_Name__c = objAcntSrv.Account__r.Name;
        if(string.valueOf(timesheetJSONmap.get('Status')) != 'Submitted')
            timeSheet.Status__c = string.valueOf(timesheetJSONmap.get('Status'));
            if(string.valueOf(timesheetJSONmap.get('Comments')) != null){
        timeSheet.Comments__c = string.valueOf(timesheetJSONmap.get('Comments')); }
        timeSheet.Time_Sheet_Cost__c = objTimesheetCost.Id;
        timeSheet.Cost_Per_Hour__c = objAcntSrv.ODS_Hourly_Rate_Amount__c ;
        //Contact[] contactObj =  ODS_Data_Utility.GetApproverName(AccountId);
            // system.debug('@@@contactObj '+contactObj );
        ContctAccService  = new List<Contact_Account_Service__c>();
        ContctAccService = ODS_Data_Utility.getContactAccountService(AccountId, ServiceId);

        if(ContctAccService.size() >0){
      system.debug('@@@ContctAccService[0].id'+ContctAccService[0].Contact__c);
             user userobj = ODS_Data_Utility.getuser(ContctAccService[0].Contact__c);
            timeSheet.Approver_Name__c  =userobj.id;
         
        }
    
        List<Object> timeSheetDetailJSON = (List<Object>)(timesheetJSONmap.get('TimesheetDtls'));    
        
        GetWeeklyTimesheet();
        
        if(CurrenTimesheetId == null || CurrenTimesheetId == '')
        {
            IsTimesheetInsert = True;
            timeSheet.Account_Services__c = CurrentAccServiceId;      
            system.debug('###timeSheet to Insert:' +timeSheet);      
            insert timeSheet;
            CurrenTimesheetId = timeSheet.Id;
        }
        else
        {
            IsTimesheetInsert = False;
            timeSheet.Account_Services__c = CurrentAccServiceId; 
            timeSheet.Id = CurrenTimesheetId;    
            system.debug('###timeSheet to Update:' +timeSheet);      
            update timeSheet;            
        }
        system.debug('###CurrenTimesheetId :' +CurrenTimesheetId);
                system.debug('###timeSheetDetailJSON:' +timeSheetDetailJSON);
        system.debug('###timeSheet:' +timeSheet);

        InsertTimeSheetDetail(timeSheetDetailJSON, CurrenTimesheetId,timeSheet);           
        GetTimesheetDetails(CurrenTimesheetId);
    }
    
    
    public void InsertTimeSheetDetail(List<Object> DetailJSONObject, String TimeShtId, Timesheet__c objtimeSheet)
    {
        Map<string,Object> timeshtDtlMap = new Map<string, Object>();
        List<Time_Sheet_Details__c> timesheetDetailList = new List<Time_Sheet_Details__c>();
        Boolean IsValidationSuccess;
        if(IsTimesheetInsert){
            system.debug('##Timesheet Insert');
            if(validateTimesheetHours(DetailJSONObject)){
                if(hdnActionValue == 'Submitted'){
                    Timesheet__c timeSheet = new Timesheet__c(id=TimeShtId);
                    timeSheet.Status__c = 'Submitted';
                    update timeSheet;
                }
                system.debug('##Validate Success');
                //Do Nothing. Proceed with Timesheet detail insert
                IsValidationSuccess = True;
            }
            else{
                //Delete the inserted timesheet as validation failed
                Timesheet__c timeSheet = new Timesheet__c(id=TimeShtId);
                delete timeSheet;
                system.debug('##Validate Failed. So delete the timesheet');
                IsValidationSuccess = False;
            }
        }
        else{
            List<Time_Sheet_Details__c> existingTimesheetDetailList = new List<Time_Sheet_Details__c>();
            system.debug('##Timesheet Update');
            existingTimesheetDetailList = FetchExistingTimesheetDetails(TimeShtId);
            DeleteExistingTimesheetDetail(TimeShtId);
            system.debug('##existingTimesheetDetailList:' +existingTimesheetDetailList);
            if(validateTimesheetHours(DetailJSONObject)){
                if(hdnActionValue == 'Submitted'){
                    Timesheet__c timeSheet = new Timesheet__c(id=TimeShtId);
                    timeSheet.Status__c = 'Submitted';
                    update timeSheet;
                }
                system.debug('##Validate Success');
                //Do Nothing. Proceed with Timesheet detail insert
                IsValidationSuccess = True;
            }
            else{
                insert existingTimesheetDetailList;
                system.debug('##Validate Failed. So inserting deleted timesheet details');
                IsValidationSuccess = False;
            }
        }
        
        system.debug('###DetailJSONObject:' +DetailJSONObject);
        system.debug('&&**'+string.valueOf(timeshtDtlMap.get('ResourceId')));
        system.debug('$$$TimeShtId:' +TimeShtId);
        if(IsValidationSuccess){
            for(Object timeShtDtl: DetailJSONObject)
            {
                timeshtDtlMap = (Map<string,Object>)timeShtDtl;
                system.debug('###InitiativeID:' + string.valueOf(timeshtDtlMap.get('IntiativeId')));
                Time_Sheet_Details__c timesheetDetail = new Time_Sheet_Details__c();
                timesheetDetail.Hours_Worked__c = decimal.Valueof(timeshtDtlMap.get('Hrs')+'');
                timesheetDetail.Row_No__c = integer.valueOf(timeshtDtlMap.get('RowNo'));                    
                timesheetDetail.Task_Name__c = string.valueOf(timeshtDtlMap.get('TaskName'));
                timesheetDetail.Resource_Id__c = string.valueOf(timeshtDtlMap.get('ResourceId'));
                timesheetDetail.Resource__c = string.valueOf(timeshtDtlMap.get('ResourceName'));
                if(string.valueOf(timeshtDtlMap.get('IntiativeId')) != '--Select--'){
                    timesheetDetail.Intiative__c = string.valueOf(timeshtDtlMap.get('IntiativeId'));
                }
                if(string.valueOf(timeshtDtlMap.get('IntiativeName')) != '--Select--'){
                    timesheetDetail.Initiative_Name__c = string.valueOf(timeshtDtlMap.get('IntiativeName'));
                }
                timesheetDetail.Timesheet_Date__c = date.parse(string.valueOf(timeshtDtlMap.get('TDate'))); 
                timesheetDetail.Timesheet__c = TimeShtId;  
                timesheetDetailList.add(timesheetDetail);
            }   
            system.debug('$$$timesheetDetailList:' +timesheetDetailList);
            insert timesheetDetailList;   
            if(hdnActionValue == 'Saved'){
                hdnActionValue = 'Saved';
            }
            else if(hdnActionValue == 'Submitted'){
                hdnActionValue = 'Submitted';
            }
            UpdateODSHoursAndResCountInCost(objtimeSheet);               
        }   
        else{
            hdnActionValue = 'ValidateFailed';
            system.debug('###hdnActionValue post validation:' + hdnActionValue);
        }
    }
    
    public List<Time_Sheet_Details__c> FetchExistingTimesheetDetails(string TimeShtId)
    {
        List<Time_Sheet_Details__c> timesheetDetailList = new List<Time_Sheet_Details__c>();
        for(Time_Sheet_Details__c timeshtDtl: ODS_Data_Utility.FetchExistingTimesheetDetailsforInsert(TimeShtId)){
            Time_Sheet_Details__c timesheetDetail = new Time_Sheet_Details__c();
            timesheetDetail.Hours_Worked__c = timeshtDtl.Hours_Worked__c ;
            timesheetDetail.Row_No__c = timeshtDtl.Row_No__c ;                    
            timesheetDetail.Task_Name__c = timeshtDtl.Task_Name__c ;
            timesheetDetail.Resource_Id__c = timeshtDtl.Resource_Id__c ;
            timesheetDetail.Resource__c = timeshtDtl.Resource__c ;
            timesheetDetail.Intiative__c = timeshtDtl.Intiative__c ;
            timesheetDetail.Initiative_Name__c = timeshtDtl.Initiative_Name__c ;            
            timesheetDetail.Timesheet_Date__c = timeshtDtl.Timesheet_Date__c ; 
            timesheetDetail.Timesheet__c = TimeShtId;  
            timesheetDetailList.add(timesheetDetail);
        }
        return timesheetDetailList;
    }
    
    /// <Objective>
    /// Method to check if the total timesheet hours added for an initiative isnot more than the estimated hours. 
    /// </Objective>
    public boolean validateTimesheetHours(List<Object> DetailJSONObject)
    {
        Map<string,Object> timeshtDtlMap = new Map<string, Object>();
        Map<string, decimal> initiativeAddedHoursMap = new Map<string, decimal>();
        Map<string, Initiatives__c> initiativeRemainingHoursMap = new Map<string, Initiatives__c>();
        List<Initiatives__c> relatedInitiatives = new List<Initiatives__c>();
        boolean isValidHours;
        for(Object timeShtDtl: DetailJSONObject)
        {
            timeshtDtlMap = (Map<string,Object>)timeShtDtl;
            system.debug('##InitiativeValue:' +string.valueOf(timeshtDtlMap.get('IntiativeId')));
            if(string.valueOf(timeshtDtlMap.get('IntiativeId')) != '--Select--' && string.valueOf(timeshtDtlMap.get('IntiativeId')) != ' ' && string.valueOf(timeshtDtlMap.get('IntiativeId')) != null){
                if(initiativeAddedHoursMap.containsKey(string.valueOf(timeshtDtlMap.get('IntiativeId'))))       
                {
                    initiativeAddedHoursMap.put(string.valueOf(timeshtDtlMap.get('IntiativeId')), initiativeAddedHoursMap.get(string.valueOf(timeshtDtlMap.get('IntiativeId'))) + decimal.Valueof(timeshtDtlMap.get('Hrs')+''));
                }
                else
                {
                    initiativeAddedHoursMap.put(string.valueOf(timeshtDtlMap.get('IntiativeId')),decimal.Valueof(timeshtDtlMap.get('Hrs')+''));
                }
            }
            else{
                isValidHours = True;
                break;
            }            
        } 
        
        system.debug('###initiativeAddedHoursMap:' +initiativeAddedHoursMap);       
        relatedInitiatives = ODS_Data_Utility.fetchRelatedInitiativeDetails(initiativeAddedHoursMap.keySet());
        for(Initiatives__c currentIntiative: relatedInitiatives)
        {
            initiativeRemainingHoursMap.put(currentIntiative.Id, currentIntiative);
        }
        system.debug('###initiativeRemainingHoursMap:' +initiativeRemainingHoursMap);
        for(string initiativeId: initiativeRemainingHoursMap.keyset())
        {
            if(initiativeAddedHoursMap.get(initiativeId) > initiativeRemainingHoursMap.get(initiativeId).Remaining_Hours__c){
                system.debug('###InvalidHours');
                isValidHours = False;
                invalidInitiativeName = initiativeRemainingHoursMap.get(initiativeId).Name;
                invalidInitiateEstimtdHrs =initiativeRemainingHoursMap.get(initiativeId).Estimated_hours__c;
                inavlidInitiateRemHrs =initiativeRemainingHoursMap.get(initiativeId).Remaining_Hours__c;
                break;
            }
            else{
                isValidHours = true;
            }
        }
        return isValidHours;
    }
    
     public void UpdateODSHoursAndResCountInCost(Timesheet__c objtimeSheet){
        system.debug('***Object'+objtimeSheet);
        Integer startWeekmonth = objtimeSheet.Week_Start_Date__c .month();
        Integer EndWeekmonth =  objtimeSheet.Week_End_Date__c .month();
         
        
        Integer YearOfWeekstartDate =  objtimeSheet.Week_Start_Date__c .year();
        Integer YearOfWeekEndDate =  objtimeSheet.Week_End_Date__c .year();
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
    
    public boolean SaveTimesheetCost(Date WeekStartDate, Date WeekEndDate, string CurrentAccServiceId, Decimal HourlyRate ){
    
        boolean Result = false;
        Integer startWeekmonth =WeekStartDate.month();
        Integer EndWeekmonth = WeekEndDate.month();
         
      
        Integer YearOfWeekstartDate = WeekStartDate.year();
        Integer YearOfWeekEndDate = WeekEndDate.year();
        system.debug('#startWeekmonth'+startWeekmonth);
        system.debug('#EndWeekmonth'+EndWeekmonth );
        
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
    
    public void DeleteExistingTimesheetDetail(String TimeShtId)
    {
        List<Time_Sheet_Details__c> timesheetDetailList = new List<Time_Sheet_Details__c>();
        timesheetDetailList = ODS_Data_Utility.FetchExistingTimesheetDetail(TimeShtId);
        Timesheet__c timesheet = new Timesheet__c();
        timesheet = [SELECT Time_Sheet_Cost__c FROM Timesheet__c WHERE ID =: TimeShtId];
        Id TmeShtCstId = timesheet.Time_Sheet_Cost__c;
        
        delete timesheetDetailList;
        
    }
    
    public PageReference ApproveTimesheet()
    {
        system.debug('@@@ApproveTimesheetId:' +CurrenTimesheetId);
        TimeSheet__c timeSht = new Timesheet__c(id=CurrenTimesheetId);
        system.debug('@@@');
        timeSht.Status__c = 'Approved';
        timeSht.Comments__c = TimesheetComments;
        timeSht.Approver_Name__c = UserInfo.GetUserID();
        timesht.Approved_Date__c = Date.Today();
        system.debug('***timeSht'+timeSht);
        Update timeSht;
        system.debug('***timeSht'+timeSht);
        system.debug('**ApproveTmSheet');        
           TimeSheet__c  timesheetobj =   ODS_Data_Utility.FetchTimesheetById(CurrenTimesheetId);
        Account_Services__c objAcntSrv = [SELECT ID,ODS_Hourly_Rate_Amount__c from Account_Services__c  WHERE ID =: CurrentAccServiceId];
        system.debug('^^^timesheetobj.Week_Start_Date__c'+timesheetobj.Week_Start_Date__c);
        SaveTimesheetCost(timesheetobj.Week_Start_Date__c,timesheetobj.Week_End_Date__c,CurrentAccServiceId,objAcntSrv.ODS_Hourly_Rate_Amount__c);
        UpdateODSHoursAndResCountInCost(timesheetobj);

        sendEmail(CurrenTimesheetId);
        return null;
    }
    
    public PageReference RejectTimesheet()
    {
        system.debug('###RejectTimesheetId:' +CurrenTimesheetId);
        TimeSheet__c timeSht = new Timesheet__c(id=CurrenTimesheetId);
        timeSht.Status__c = 'Rejected';
        timeSht.Comments__c = TimesheetComments;
        timeSht.Approver_Name__c = UserInfo.GetUserID();
        timesht.Approved_Date__c = Date.Today();
        Update timeSht;
        system.debug('**timeSht'+timeSht);
          TimeSheet__c  timesheetobj =   ODS_Data_Utility.FetchTimesheetById(CurrenTimesheetId);
        Account_Services__c objAcntSrv = [SELECT ID,ODS_Hourly_Rate_Amount__c from Account_Services__c  WHERE ID =: CurrentAccServiceId];
        system.debug('^^^timesheetobj.Week_Start_Date__c'+timesheetobj.Week_Start_Date__c);
        SaveTimesheetCost(timesheetobj.Week_Start_Date__c,timesheetobj.Week_End_Date__c,CurrentAccServiceId,objAcntSrv.ODS_Hourly_Rate_Amount__c);
        UpdateODSHoursAndResCountInCost(timesheetobj);

        sendEmail(CurrenTimesheetId);
        return null;
    }
    
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
        tsTosendEmail = [Select Id, Name, Approver_Name__c,Approver_Email__c, Comments__c,Approver_Name__r.Name,Status_Date__c,Week_Start_Date__c,Week_End_Date__c,Account_Services__c,Account_Services__r.Account__c, Account_Services__r.Account__r.name, Account_Services__r.ODS_Service_Name__c,Account_Services__r.Technical_Account_manager__r.Name, Status__c from Timesheet__c where Id=: timsheetid];
        System.debug('tsTosendEmail------------'+tsTosendEmail.Account_Services__c);
        
        System.debug('lstCcAddress------------'+lstCcAddress);
        String accntId = tsTosendEmail.Account_Services__r.Account__c;
        
        Date StartDate = tsTosendEmail.Week_Start_Date__c; 
        String FromDate = DateTime.newInstance(StartDate.year(),StartDate.month(),StartDate.day()).format('MM/dd/yyyy');       

        Date EndDate = tsTosendEmail.Week_End_Date__c;
        String ToDate= DateTime.newInstance(EndDate.year(),EndDate.month(),EndDate.day()).format('MM/dd/yyyy');

        String[] bccAddress = new List<String>();      
        String AccSerId= tsTosendEmail.Account_Services__c;
        string timshtCmts = '';

        System.debug('accntId------------'+accntId);

        //List of User Accounts associated
        List<User_Account__c> lstUsrAccnts = new List<User_Account__c>();
        lstUsrAccnts = [Select Id, name, User__c,User__r.Email, Account__c, Role_in_Account__c from User_Account__c where Account__c =: accntId];
        System.debug('lstUsrAccnts------------'+lstUsrAccnts);

        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        
        if(objUser.PortalUserRole__c == 'Customer'){
                     if(tsTosendEmail.Approver_Email__c != null){
                             lstCcAddress.add(tsTosendEmail.Approver_Email__c);
                     }
                     if(timesheetMailIdLabel != null){
                             lstCcAddress.add(timesheetMailIdLabel);     
                     }

                     if(tsTosendEmail.Comments__c != null && tsTosendEmail.Comments__c != ''){
                             timshtCmts = tsTosendEmail.Comments__c;
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
        
        if(objUser.PortalUserRole__c == 'Technical Account Manager' || objUser.PortalUserRole__c == 'Practice Head'){
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
        mail.setSenderDisplayName('DemandBlue - ODS');
        if(lstCcAddress.size() > 0){
                  mail.setCcAddresses(lstCcAddress);
        }
        if(bccAddress.size() > 0){
                  mail.setBccAddresses(bccAddress);
        }
        String subject = 'Timesheet Report for: ' +tsTosendEmail.Account_Services__r.Account__r.name+ ' - '+tsTosendEmail.Account_Services__r.ODS_Service_Name__c+ ' from ' + (tsTosendEmail.Week_Start_Date__c).format() + ' to ' +(tsTosendEmail.Week_End_Date__c).format() + ' - ' +tsTosendEmail.Status__c;
        mail.setSubject(subject);

        String strHtmlBody = '' ;        
        strHtmlBody = '<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2"> <font face="Calibri " size="3">Hi '+ tsTosendEmail.Account_Services__r.Technical_Account_manager__r.Name+', <br/><br/>The timesheet for '+ (tsTosendEmail.Week_Start_Date__c).format() + ' through ' +(tsTosendEmail.Week_End_Date__c).format() +' has been '+ tsTosendEmail.Status__c
            + '.<br/><br/>';
        if(timshtCmts!=''){
            strHtmlBody += 'Comments : '+timshtCmts +' <br/><br/>';
        }
        strHtmlBody += '<table style="border:none; width:624px; border-collapse: collapse;"><tbody><tr><td style="border-top:2px solid #000; padding-bottom:15px;"></td></tr><tr><td><p style="margin:0px; color:#000;">Thanks,</p></td></tr><tr><td><p style="margin:0px; color:#000;">'+tsTosendEmail.Approver_Name__r.Name+'</p></td></tr><tr><td><table><tbody><tr><td valign="top" width="283" style="width:285px; margin:0; padding:25px;vertical-align:top; background-color:#07080A;"><a href="https://www.demandblue.com/" target="_blank"><img src="https://www.demandblue.com/image-assets/signature/demandblue-logo-signature.jpg" alt="DemandBlue" width="285" style="border:none;width:285px;display:block; margin:25px 0;"></a></td><td width="5" style="width:5px;min-width:5px;max-width:5px;margin:0;padding:0;">&nbsp;</td><td style="background-color:#4fc9f3; padding:26px; width:276px;"><table><tbody><tr><td><table><tbody><tr><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">Name</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">:</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#000;">'+tsTosendEmail.Approver_Name__r.Name+'</span></p></td></tr></tbody></table></td></tr><tr><td><p style="border-bottom:1px solid #FFF; width:267px; margin:5px 0;"></p></td></tr><tr><td><table><tbody><tr><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">Email</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">:</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#000;">'+tsTosendEmail.Approver_Email__c+'</span></p></td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td style="border-bottom:2px solid #4fc9f3; padding-top:15px;"></td></tr><tr><td width="624" valign="top" style="width:283px;border:none;padding:10px 0"><p style="text-align:justify;"><span style="font-size:11px; font-family:calibri; color:#ff0000; font-weight: bold;">CONFIDENTIALITY STATEMENT:</span><span style="font-size:11px; font-family:Arial, Sans-Serif, Times New Roman; color:#a6a6a6;">The information contained in this communication is confidential and intended only for the use of the recipient named above, and may be legally privileged and exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please resend it to the sender and delete the original message and any copy of it from your computer system</span></p></td></tr></tbody></table>';
        mail.setHtmlBody(strHtmlBody);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachement});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    } 
     /// <OBJECTIVE>
    /// Method to redirect to Timesheet page
    /// </OBJECTIVE> 
    public pagereference redirectToTimeSheet()
    {
        
        String url = '/apex/ViewTimesheet?accntId='+AccountId+'&srvcId='+serviceId;        
        Pagereference pgRef = new PageReference(url);
        return pgRef ;
    
    }
    /// <OBJECTIVE>
    /// To get resource name for the selected account and service.
    /// </OBJECTIVE>
    public void getResourceNameByAccountServiceId(String AccountId, String ServiceId) 
    {  
        try {
            resourceNameLst = new  List<AggregateResult>();
            resourceNameLst = ODS_Data_Utility.getResourceNameByAccountServiceId(AccountId, ServiceId);
            resourceNameJSONtoBind = JSON.serialize(resourceNameLst);
        }
        catch(Exception e)  {
            system.debug('AddTimesheet-getResourceNameByAccountServiceId: '+e);
        }
    }
    
    public void getInitiativeByAccountServiceId(String AccountId, String ServiceId) 
    {  
        try {
            InitiativeLst = new  List<AggregateResult>();
            InitiativeLst = ODS_Data_Utility.getInitiativeByAccountServiceId(AccountId, ServiceId);
            initiativeJSONtoBind = JSON.serialize(InitiativeLst);
        }
        catch(Exception e)  {
            system.debug('AddTimesheet-getInitiativeByAccountServiceId: '+e);
        }
    }
    
    Public pagereference exportAsPDF()
    {
        PageReference pdf = Page.ODS_ExportTimesheet;
        Timesheet__c  exportTimesheet = new Timesheet__c();
        //system.debug('####@@timsheetid:' +timsheetid);
        exportTimesheet = [Select Id, Name, Approver_Name__c,Approver_Email__c, Comments__c,Approver_Name__r.Name,Status_Date__c,Week_Start_Date__c,Week_End_Date__c,Account_Services__c,Account_Services__r.Account__c, Account_Services__r.Account__r.name, Account_Services__r.ODS_Service_Name__c, Status__c from Timesheet__c where Id=: CurrenTimesheetId ];
        System.debug('exportTimesheet ------------'+exportTimesheet .Account_Services__c);
        
        Date StartDate = exportTimesheet.Week_Start_Date__c; 
        String FromDate = DateTime.newInstance(StartDate.year(),StartDate.month(),StartDate.day()).format('MM/dd/yyyy');       
        
        Date EndDate = exportTimesheet .Week_End_Date__c;
        String ToDate= DateTime.newInstance(EndDate.year(),EndDate.month(),EndDate.day()).format('MM/dd/yyyy');
        
        
        String AccSerId= exportTimesheet.Account_Services__c;
        pdf.getParameters().put('Weekfromdate',FromDate);
        System.debug('@@@@@@@@FromDate------------'+FromDate);
        pdf.getParameters().put('Weektodate',ToDate);
        System.debug('@@@ToDate------------'+ToDate);
        pdf.getParameters().put('Accountservice',AccSerId);
        System.debug('@@@@@@@@@AccSerId------------'+AccSerId);
        
        return pdf;
    }
    Public pagereference exportAsExcel()
    {
        PageReference pdf = Page.ODS_ExportTimesheetExcel;
        Timesheet__c  exportTimesheet = new Timesheet__c();
        //system.debug('####@@timsheetid:' +timsheetid);
        exportTimesheet = [Select Id, Name, Approver_Name__c,Approver_Email__c, Comments__c,Approver_Name__r.Name,Status_Date__c,Week_Start_Date__c,Week_End_Date__c,Account_Services__c,Account_Services__r.Account__c, Account_Services__r.Account__r.name, Account_Services__r.ODS_Service_Name__c, Status__c from Timesheet__c where Id=: CurrenTimesheetId ];
        System.debug('exportTimesheet ------------'+exportTimesheet .Account_Services__c);
        
        Date StartDate = exportTimesheet.Week_Start_Date__c; 
        String FromDate = DateTime.newInstance(StartDate.year(),StartDate.month(),StartDate.day()).format('MM/dd/yyyy');       
        
        Date EndDate = exportTimesheet .Week_End_Date__c;
        String ToDate= DateTime.newInstance(EndDate.year(),EndDate.month(),EndDate.day()).format('MM/dd/yyyy');
        
        
        String AccSerId= exportTimesheet.Account_Services__c;
        System.debug('@@@@@@@@AccSerId------------'+AccSerId);
        pdf.getParameters().put('Weekfromdate',FromDate);
        System.debug('@@@@@@@@FromDate------------'+FromDate);
        pdf.getParameters().put('Weektodate',ToDate);
        System.debug('@@@ToDate------------'+ToDate);
        pdf.getParameters().put('Accountservice',AccSerId);
        System.debug('@@@@@@@@@AccSerId------------'+AccSerId);
        pdf.setRedirect(false);
        return pdf;
    }
    
}