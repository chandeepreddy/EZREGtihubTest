/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             03-OCT-2016
 * @Status           Developed
 * @description      This is the controller class for View Timesheet Page
 *
 */

Public class ODS_ExportTimesheetController
{

    public string CurrenTimesheetId {get;set;}
    public string CurrentAccServiceId {get;set;}
    public string PassedWeekFromDate{get;set;}
    public string PassedWeekToDate{get;set;}
    public string TimeshtJSONtoBind {get;set;}
    public string PortalUserRole {get;set;}
    public Boolean Iscustomer{get;set;}
    public Boolean IsPortalApprover{get;set;}
    public string AccountId{get;set;}
    public string CurrentTimeSheetStatus {get;set;}
    public string FromDate {get;set;}
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    public string ToDate {get;set;}
    public string ManagerName {get;set;}
    public string CurrentDate{get;set;}
    public Date CurDt{get;set;}
    public string CuDt{get;set;}
    public string TotalTimesheetHours {get;set;}
    public string TimesheetEntries {get;set;}
    public string TimesheetAccount {get;set;}
    public string TimesheetAccountService {get;set;}
    public string Comments{get;set;} 
    public string ApproverName {get;set;}
 
    Public ODS_ExportTimesheetController()
    {
       
       
    }

    public void GetWeeklyTimesheet()
    {
        PassedWeekFromDate = Apexpages.currentpage().getparameters().get('Weekfromdate');
        PassedWeekToDate = Apexpages.currentpage().getparameters().get('Weektodate');
        CurrentAccServiceId = Apexpages.currentpage().getparameters().get('Accountservice');

        system.debug('##PassedWeekFromDate:' +PassedWeekFromDate);
        system.debug('##PassedWeekToDate:' +PassedWeekToDate);
        system.debug('###CurrentAccServiceId :' +CurrentAccServiceId);
        
        List<Timesheet__c> timesheetRelatedDate = new List<Timesheet__c>();
        //if(PassedWeekFromDate != null && PassedWeekToDate != null && CurrentAccServiceId != null){
            timesheetRelatedDate = ODS_Data_Utility.FetchTimesheetByDate(CurrentAccServiceId,date.parse(PassedWeekFromDate),date.parse(PassedWeekToDate));
            system.debug('###timesheetRelatedDate :' +timesheetRelatedDate);
           //CurrentTimeSheetStatus = timesheetRelatedDate[0].Status__c;
           
            if(timesheetRelatedDate.size() > 0){
                CurrenTimesheetId = timesheetRelatedDate[0].Id;
                GetTimesheetDetails(CurrenTimesheetId);       
            }
            else{
                CurrenTimesheetId = '';
                TimeshtJSONtoBind = '';
            }    
        //}    
    }
    
    public void GetTimesheetDetails(string TimesheetId)
    {
        List<Time_Sheet_Details__c> timeShtDetailList = new List<Time_Sheet_Details__c>();
        if(PortalUserRole != 'Customer'){
            timeShtDetailList = ODS_Data_Utility.FetchTimesheetDetailsbyId(TimesheetId);
        }
        else{
            timeShtDetailList = ODS_Data_Utility.FetchCustomerTimesheetDetails(TimesheetId);
        }
        TimeSheet__c  timesheetobj =   ODS_Data_Utility.FetchTimesheetById(CurrenTimesheetId);
        CurrentTimeSheetStatus  = timesheetobj.Status__c;
        Comments = timesheetobj.Comments__c;
        system.debug('@@@@@@@CurrentTimeSheetStatus'+ CurrentTimeSheetStatus);
        //FromDate = string.valueof(timesheetobj.Week_Start_Date__c);
        StartDate = timesheetobj.Week_Start_Date__c; 
        FromDate = DateTime.newInstance(StartDate.year(),StartDate.month(),StartDate.day()).format('MM/dd/yyyy');       
        //ToDate = string.valueof(timesheetobj.Week_End_Date__c);
        EndDate = timesheetobj.Week_End_Date__c;
        ToDate= DateTime.newInstance(EndDate.year(),EndDate.month(),EndDate.day()).format('MM/dd/yyyy');
        ManagerName = timesheetobj.Approver_Name__r.Name;
        TimesheetAccount = timesheetobj.Account_Services__r.Account__r.Name;
        TimesheetAccountService = timesheetobj.Account_Services__r.ODS_Service_Name__c;
        if(CurrentDate!= null){
            CurrentDate = string.valueof(timesheetobj.Approved_Date__c);
            }
        CurDt = timesheetobj.Approved_Date__c;
        ApproverName = timesheetobj.ApproverName__c;
        system.debug('@@@@@@@CurDt '+ CurDt );
        if(CurDt != null){
            CuDt = DateTime.newInstance(CurDt.year(),CurDt.month(),CurDt.day()).format('MM/dd/yyyy');
       }
        
        TimesheetEntries = BuildTimesheeHtml(timeShtDetailList,TimesheetId,timesheetobj.Week_Start_Date__c);
      
        TimeshtJSONtoBind = JSON.serialize(timeShtDetailList)+'~'+timesheetobj.Status__c+'~'+timesheetobj.Comments__c;
        system.debug('###TimeshtJSONtoBind:' +TimeshtJSONtoBind);
        
    }
    
    public string BuildTimesheeHtml( List<Time_Sheet_Details__c> timeShtDetailList,string TimesheetId, Date WeekStartDate)
    {
        decimal MonTotalHours=0;
        decimal TueTotalHours=0;
        decimal WedTotalHours=0;
        decimal ThuTotalHours=0;
        decimal FriTotalHours=0;
        decimal SatTotalHours=0;
        decimal SunTotalHours=0;
        DateTime weekStartDateTime = Datetime.NewInstance(WeekStartDate.year(), WeekStartDate.Month(), WeekStartDate.day());
        
        DateTime Mondaydate = weekStartDateTime;
        DateTime Tuedate = weekStartDateTime.addDays(1);
        DateTime Weddate = weekStartDateTime.addDays(2);
        DateTime Thudate = weekStartDateTime.addDays(3);
        DateTime Fridate = weekStartDateTime.addDays(4);
        DateTime Satdate = weekStartDateTime.addDays(5);
        DateTime Sundate = weekStartDateTime.addDays(6);
          
        string  TimesheetBuilder = '<table border=\'1 px solid #d7d7d7\'   id=\'Tbltimesheet\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\'>';  
     //Header Row
        //TimesheetBuilder +='<tr >';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;  padding:5px; text-align: center;" ><strong>INITIATIVE NAME</strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>USER STORIES/TASK NAME</strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>'+Mondaydate.format('MMM')+' '+ Mondaydate.format('dd')+'<br />MON </strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>'+Tuedate.format('MMM')+' '+ TueDate.format('dd')+'<br />TUE </strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>'+Weddate.format('MMM')+' '+ Weddate.format('dd')+'<br />WED </strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>'+Thudate.format('MMM')+' '+ Thudate.format('dd')+'<br />THU </strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>'+Fridate.format('MMM')+' '+ Fridate.format('dd')+'<br />FRI </strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>'+Satdate.format('MMM')+' '+ Satdate.format('dd')+'<br />SAT </strong>';
        TimesheetBuilder +='</th>';
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>'+Sundate.format('MMM')+' '+ Sundate.format('dd')+'<br />SUN </strong>';
        TimesheetBuilder +='</th>';
        
        TimesheetBuilder +='<th style="background: #3399cc; border: 1px solid #d7d7d7;  border-bottom: none;  color: #fff; font-size: 14px;  padding:5px; text-align: center;"><strong>Total</strong>';
        TimesheetBuilder +='</th> ';
        TimesheetBuilder +='</tr>';
         Map<String,Decimal> TimesheetMap =new Map<String,Decimal>();
        ///For loop 
        for(Time_Sheet_Details__c eachRow: timeShtDetailList){
        Datetime TimesheetDate = DateTime.newinstance(eachRow.Timesheet_Date__c.year(),eachRow.Timesheet_Date__c.month(),eachRow.Timesheet_Date__c.day());
        string EachDateString = eachRow.Row_No__c + '_'+ TimesheetDate .format('MM/dd/yyyy');
            TimesheetMap.put(EachDateString,eachRow.Hours_Worked__c );
        
        }
        system.debug('##TimesheetMap'+TimesheetMap);
        List<Aggregateresult> objResult=  ODS_Data_Utility.GetAggregateTimesheetDetails(TimesheetId,CurrentAccServiceId);
        decimal TotalHours = 0;
        for( Aggregateresult  eachrowresult :objResult)
        {
        
            TimesheetBuilder +='<tr>';
            string InitiativeName = string.valueof(eachrowresult.get('Initiative_Name__c'));
            string TaskName = string.valueof(eachrowresult.get('Task_Name__c'));
            string ResourceName =  string.valueof(eachrowresult.get('Resource__c'));
            string RowNo =  string.valueof(eachrowresult.get('Row_No_Value__c'));
            
            string strMondate = RowNo+'_'+Mondaydate.format('MM/dd/yyyy');
            string strTueDate =  RowNo+'_'+Tuedate.Format('MM/dd/yyyy');
            string strWedDate =  RowNo+'_'+Weddate.format('MM/dd/yyyy');
            string strThuDate =  RowNo+'_'+Thudate.format('MM/dd/yyyy');
            string strFriDate =  RowNo+'_'+Fridate.Format('MM/dd/yyyy');
            string strSatDate =  RowNo+'_'+Satdate.format('MM/dd/yyyy');
            string strSunDate =  RowNo+'_'+Sundate.format('MM/dd/yyyy');
            decimal HoursWorked =0;
            decimal EachRowTotalHours=0;
            
             TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  ">';
             if(InitiativeName != null){
                 TimesheetBuilder += InitiativeName;
             }
             TimesheetBuilder +='</td>  ';
             
             TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  ">';
             TimesheetBuilder += TaskName;
             TimesheetBuilder +='</td>  ';

            if ((TimesheetMap.containsKey(strMondate))) {
                    HoursWorked =  TimesheetMap.get(strMondate);
                    EachRowTotalHours+=HoursWorked;
                    MonTotalHours +=HoursWorked;
                    TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                    TimesheetBuilder += HoursWorked ;
                    TimesheetBuilder +='</td>  ';
         
            }else{
            
                TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                TimesheetBuilder += '';
                TimesheetBuilder +='</td>  ';
            } 
            
             if ((TimesheetMap.containsKey(strTueDate ))) {
            
                    HoursWorked =  TimesheetMap.get(strTueDate);
                    EachRowTotalHours+=HoursWorked;
                    TueTotalHours +=HoursWorked;
                    TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                    TimesheetBuilder += HoursWorked ;
                    TimesheetBuilder +='</td>  ';
         
            }else{
            
                TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                TimesheetBuilder += '';
                TimesheetBuilder +='</td>  ';
            } 
            
             if ((TimesheetMap.containsKey(strWedDate ))) {
             
                    HoursWorked =  TimesheetMap.get(strWedDate );
                    EachRowTotalHours+=HoursWorked;
                    WedTotalHours +=HoursWorked;
                    TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                    TimesheetBuilder += HoursWorked ;
                    TimesheetBuilder +='</td>  ';
         
            }else{
            
                TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                TimesheetBuilder += '';
                TimesheetBuilder +='</td>  ';
            } 
             if ((TimesheetMap.containsKey(strThudate))) {
             
                    HoursWorked =  TimesheetMap.get(strThudate);
                    EachRowTotalHours+=HoursWorked;
                    ThuTotalHours +=HoursWorked;
                    TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                    TimesheetBuilder += HoursWorked ;
                    TimesheetBuilder +='</td>  ';
         
            }else{
            
                TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                TimesheetBuilder += '';
                TimesheetBuilder +='</td>  ';
            } 
             if ((TimesheetMap.containsKey(strFridate))) {
            
                    HoursWorked =  TimesheetMap.get(strFridate);
                    EachRowTotalHours+=HoursWorked;
                    FriTotalHours +=HoursWorked;
                    TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                    TimesheetBuilder += HoursWorked ;
                    TimesheetBuilder +='</td>  ';
         
            }else{
            
                TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                TimesheetBuilder += '';
                TimesheetBuilder +='</td>  ';
            } 
             if ((TimesheetMap.containsKey(strSatdate))) {
                    HoursWorked =  TimesheetMap.get(strSatdate);
                    EachRowTotalHours+=HoursWorked; 
                    SatTotalHours +=HoursWorked;
                    TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                    TimesheetBuilder += HoursWorked ;
                    TimesheetBuilder +='</td>  ';
            }else{
                TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                TimesheetBuilder += '';
                TimesheetBuilder +='</td>  ';
            } 
            if ((TimesheetMap.containsKey(strSundate))) {
                    HoursWorked =  TimesheetMap.get(strSundate);
                    EachRowTotalHours+=HoursWorked;
                    SunTotalHours +=HoursWorked;
                    TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                    TimesheetBuilder += HoursWorked ;
                    TimesheetBuilder +='</td>  ';
            }else{
            
                TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: right; ">';
                TimesheetBuilder += '';
                TimesheetBuilder +='</td>  ';
            } 
             
            TimesheetBuilder +='<td  style=" padding:5px; border: 1px solid #d7d7d7; border-bottom: none;  text-align: right;">';
            TimesheetBuilder += EachRowTotalHours;
            TimesheetBuilder +='</td>  ';

            TimesheetBuilder +='</tr>';
            TotalHours +=EachRowTotalHours;
        }
            TimesheetBuilder +='<tr>';
            TimesheetBuilder +='<td  colspan=\'2\'  style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; text-align: Left; ">';
            TimesheetBuilder += 'Total';
            TimesheetBuilder +='</td>  ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">'+MonTotalHours +'</td> ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">'+TueTotalHours +'</td> ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">'+WedTotalHours +'</td> ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">'+ThuTotalHours +'</td> ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">'+FriTotalHours +'</td> ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">'+SatTotalHours +'</td> ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">'+SunTotalHours +'</td> ';
            TimesheetBuilder +='<td style=" padding:5px; border: 1px solid #d7d7d7;  text-align: right; ">';
            TimesheetBuilder += TotalHours  ;
            TimesheetBuilder +='</td>  ';
            TimesheetBuilder +='</tr>';
          return TimesheetBuilder ;
    }
}