/**
 * @author           Kirankumar D
 * @version          1.0 
 * @date             25-OCT-2016
 * @Status           Developed
 * @description      This is the controller for inserting Time Sheet Cost record
 *
 */
 
global class ODS_TimeSheetCostController
{
    //To check whether the record is already available, if yes update else insert new record
    public static Time_Sheet_Cost__c CheckIfMonthExistInCostTable(Integer IntMonth,Integer IntYear,string AcntSrvId,Decimal dcCostPerHour,Date dtStartDate)
    {
        Date firstDate = dtStartDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(date.daysInMonth(dtStartDate.year() , dtStartDate.month())  - 1);
        string strMonth=string.valueof(IntMonth);
        string strYear=string.valueof(IntYear);
        Time_Sheet_Cost__c objTmeStCst;
        List<Time_Sheet_Cost__c> objTimeCost = [SELECT Id from Time_Sheet_Cost__c WHERE Month__c =: strMonth AND Year__c =: strYear AND Account_Services__c =: AcntSrvId];
        system.debug('***lstTimeCost'+objTimeCost);
        Time_Sheet_Cost__c objTimeStCost = new Time_Sheet_Cost__c();
        if(objTimeCost.size()==0)
        {
                objTimeStCost.Month__c = strMonth;
                objTimeStCost.Year__c = strYear;
                objTimeStCost.Account_Services__c = AcntSrvId;
                objTimeStCost.Cost_Per_Hour__c = dcCostPerHour;
                objTimeStCost.Start_Date_of_Month__c = firstDate ;
                objTimeStCost.End_Date_of_Month__c = lastDate ;
                insert objTimeStCost;
                objTmeStCst = objTimeStCost;
        }
        else
        {
        objTmeStCst = objTimeCost[0];
        }
      //return objTimeCost[0];  
      //return objTimeStCost;
      return objTmeStCst;
        
    } 
    
  
    //To populate the ODS Hours in TimeSheetCost object
    public static void populateODSHours(Time_Sheet_Cost__c objTimesheetCost,Date WeekStartDate, string CurrentAccServiceId)
    {    
        List<Time_Sheet_Details__c > lst = new List<Time_Sheet_Details__c >();
 
        Date startDateofMonth= WeekStartDate.toStartOfMonth();
        integer NumberOfDaysInMonth = date.daysInMonth(WeekStartDate.year() , WeekStartDate.month())-1;
        Date EndDateOfMonth= startDateofMonth.addDays(NumberOfDaysInMonth);
        
        Decimal TotalODSHours;
        
        AggregateResult[] lstTimeshtdtl = [SELECT SUM(Hours_Worked__c) ODSTotalHrs from Time_Sheet_Details__c WHERE Timesheet_Date__c >=: startDateofMonth AND Timesheet_Date__c <=: EndDateOfMonth AND Timesheet__r.Account_Services__c =: CurrentAccServiceId AND Status__c =: 'Approved'];
        system.debug('***lstTimeshtdtl'+lstTimeshtdtl );
        TotalODSHours = (Decimal)lstTimeshtdtl[0].get('ODSTotalHrs');
        //Update ODS Hours in Time Sheet Cost
        
        objTimesheetCost.ODS_Hours__c = TotalODSHours ;
        update objTimesheetCost;
      
    }
    
    //To populate the Resource count in TimeSheetCost object
    public static void populateResourceCount(Time_Sheet_Cost__c objTimesheetCost,Date WeekStartDate,string CurrentAccServiceId)
    {   
        Integer ResourceCount = 0; 
        Date startDateofMonth= WeekStartDate.toStartOfMonth();
        Date EndDateOfMonth= startDateofMonth.addDays(date.daysInMonth(startDateofMonth.year() , startDateofMonth.month())  - 1);
        List<Timesheet__c> lstTimesht = new List<Timesheet__c>();
        List<Time_Sheet_Details__c> lstTimeshtdtl = new List<Time_Sheet_Details__c>();
         
      
        DateTime startDateTimeofMonth =  DateTime.newInstance(startDateofMonth.Year(),startDateofMonth.Month(),startDateofMonth.Day());
        string[] WeekBoundaryDates = ODS_DateUtility.GetWeekBoundaryDatesByMonth(startDateTimeofMonth);
        for(string eachBoundary: WeekBoundaryDates )
        {
            string StartDate = eachBoundary.split('~')[0];
            string EndDate = eachBoundary.split('~')[1];

            //Date eachWeekStartDate = setStringToDateFormat(StartDate);
            //Date eachWeekEndDate = setStringToDateFormat(EndDate);
            
            Date eachWeekStartDate = date.valueof(StartDate);
            Date eachWeekEndDate = date.valueof(EndDate);
            AggregateResult[] aggResourceCount = [SELECT Resource__c from Time_Sheet_Details__c WHERE  Timesheet_Date__c >=: eachWeekStartDate
                                         AND Timesheet_Date__c <=: eachWeekEndDate AND Timesheet__r.Account_Services__c =: CurrentAccServiceId 
                                         AND Status__c =: 'Approved' Group By Resource__c];
            system.debug('***aggResourceCount'+aggResourceCount);
            ResourceCount += aggResourceCount.size();
        }
        objTimesheetCost.Resource_Count__c = ResourceCount ;
        update objTimesheetCost;
        
        
    }
    
   //To update the Regular Hours
    public static void populateRegularHours(Time_Sheet_Cost__c objTimesheetCost,Date WeekStartDate,string CurrentAccServiceId)
    {
        system.debug('***Start***');
        List<Timesheet__c> lstTimesht = new List<Timesheet__c>();
        Integer ResourceCount = 0;
        Integer ResourceCountInPrjStartWk = 0;  
        Integer RegularHours = 0;
        Integer RegHrsInPrjStartWk = 0;  
        Integer NoOfDaysInBtw = 0;
        Integer BalanceDaysInPrjStartWk = 0;
        Integer TotalRegHours = 0;
        
        //To fetch Timesheet start date
        Account_Services__c objAcntSrv = [SELECT ID,Timesheet_Start_Date__c from Account_Services__c  WHERE ID =: CurrentAccServiceId];
        Date TimesheetStartDt = objAcntSrv.Timesheet_Start_Date__c ;
        system.debug('@@@ TimesheetStartDt @@@'+TimesheetStartDt);
        
        //Getting list of Holidays
        List<Holiday> Holidays = new List <Holiday>();
        Holidays = ODS_Data_Utility.getHolidaydetails(); 
        Set<Date> activityDateSet = new set<Date>();
        system.debug('***Holidays***'+Holidays);
        for(Holiday Holidaydate :Holidays)
        {
            activityDateSet.add(Holidaydate.ActivityDate);  
        
        }
        
        Date startDateofMonth= WeekStartDate.toStartOfMonth();
        Date EndDateOfMonth= startDateofMonth.addDays(date.daysInMonth(startDateofMonth.year() , startDateofMonth.month())  - 1);
         
        DateTime startDateTimeofMonth =  DateTime.newInstance(startDateofMonth.Year(),startDateofMonth.Month(),startDateofMonth.Day());
        string[] WeekBoundaryDates = ODS_DateUtility.GetWeekBoundaryDatesByMonth(startDateTimeofMonth);
        system.debug('***WeekBoundaryDates ***'+WeekBoundaryDates );
        for(string eachBoundary: WeekBoundaryDates)
        {
              string StartDate = eachBoundary.split('~')[0];
              string EndDate = eachBoundary.split('~')[1];
                
              Date eachWeekStartDate = date.valueof(StartDate);
              Date eachWeekEndDate = date.valueof(EndDate);
              system.debug('##eachWeekEndDate:' +eachWeekEndDate);
              DateTime WeekEndDate = datetime.newInstance(eachWeekEndDate.year(), eachWeekEndDate.month(), eachWeekEndDate.day());
              system.debug('##WeekEndDate:' +WeekEndDate);
              String dayOfWeek = WeekEndDate.format('E');
              system.debug('##dayOfWeek:' +dayOfWeek);
              system.debug('##EndDate:' +EndDate);
               Date eachWeekEndDateExcludingWeekend;
               
               if( dayOfWeek == 'Sun')
               {
                   eachWeekEndDateExcludingWeekend = (date.valueof(EndDate)).adddays(-2);
               }
               
               else if(dayOfWeek == 'Sat')
               {
                   eachWeekEndDateExcludingWeekend = (date.valueof(EndDate)).adddays(-1);
               }
               else
               {
                   eachWeekEndDateExcludingWeekend = eachWeekEndDate ;
               }
               system.debug('##eachWeekEndDateExcludingWeekend:' +eachWeekEndDateExcludingWeekend);
              Integer NoOfDays = eachWeekStartDate.daysBetween(eachWeekEndDateExcludingWeekend);
              system.debug('-----NoOfDays----- '+NoOfDays);
              
              Integer TotalHoliday = 0;
             
                   if(eachWeekStartDate >= TimesheetStartDt )
                   {
                       system.debug('***Activity Date Set ***'+activityDateSet);
                       for(Date activityDate : activityDateSet )
                       {
                           system.debug('***activityDate ***'+activityDate );
                            system.debug('***TimesheetStartDt ***'+TimesheetStartDt );
                            system.debug('***eachWeekEndDateExcludingWeekend ***'+eachWeekEndDateExcludingWeekend );
                           if(activityDate >=TimesheetStartDt && activityDate <= eachWeekEndDateExcludingWeekend && activityDate >= eachWeekStartDate)
                           {
                               TotalHoliday += 1;
                                system.debug('***Inside If Loop***');
                               
                           }
                       system.debug('------Total Holiday----- '+TotalHoliday );
                       }
                       
                       DateTime DayOfDate = datetime.newInstance(eachWeekStartDate,Time.newInstance(0, 0, 0, 0));
                       String strdayOfdate = DayOfDate.format('EEE');
                       system.debug('***strdayOfdate'+strdayOfdate);
                       
                       system.debug('***true');
                       AggregateResult[] aggResourceCount = [SELECT Resource__c from Time_Sheet_Details__c WHERE  Timesheet_Date__c >=: eachWeekStartDate
                                         AND Timesheet_Date__c <=: eachWeekEndDate AND Timesheet__r.Account_Services__c =: CurrentAccServiceId 
                                         AND Status__c =: 'Approved' Group By Resource__c];
                       ResourceCount = aggResourceCount.size(); 
                       system.debug('***ResourceCount '+ResourceCount );   
                       
                        //Integer RegHrs = ODS_DateUtility.getHoursByDayofDate(strdayOfdate );
                        Integer RegHrs = ODS_DateUtility.getHoursByDays(NoOfDays);
                        Integer RegHrsExcludigHoliday = RegHrs -(TotalHoliday *8); 
                        system.debug('------RegHrs ----- '+RegHrs );
                        system.debug('------RegHrsExcludigHoliday ----- '+RegHrsExcludigHoliday );
                        RegularHours = ResourceCount * RegHrsExcludigHoliday ;
                          
                           system.debug('***RegularHours1 '+RegularHours );
                      
                   }
                   
                   else
                   {    
                      system.debug('***false');
                      system.debug('***Else Activity Date Set ***'+activityDateSet);
                      for(Date activityDate : activityDateSet )
                       {
                           if(activityDate >= eachWeekStartDate && activityDate <= eachWeekEndDateExcludingWeekend )
                           {
                               TotalHoliday += 1;
                               
                           }
                       system.debug('-----Else-Total Holiday----- '+TotalHoliday );
                       }

                      AggregateResult[] aggResourceCount = [SELECT Resource__c from Time_Sheet_Details__c WHERE  Timesheet_Date__c >=: eachWeekStartDate
                                         AND Timesheet_Date__c <=: eachWeekEndDate AND Timesheet__r.Account_Services__c =: CurrentAccServiceId 
                                         AND Status__c =: 'Approved' Group By Resource__c];
                       ResourceCount = aggResourceCount.size();
                       ResourceCountInPrjStartWk += aggResourceCount.size();
                       system.debug('***ResourceCountInPrjStartWk '+ResourceCountInPrjStartWk );
                       if(aggResourceCount.size() > 0)
                       {
                           System.debug('@@@@@TimesheetStartDt'+TimesheetStartDt);
                           DateTime DayOfDate = datetime.newInstance(TimesheetStartDt,Time.newInstance(0, 0, 0, 0));
                           String strdayOfdate = DayOfDate.format('EEE');
                           //Integer RegHrs = ODS_DateUtility.getHoursByDayofDate(strdayOfdate );
                           Integer RegHrs = ODS_DateUtility.getHoursByDays(NoOfDays);
                           Integer RegHrsExcludigHoliday = RegHrs -(TotalHoliday *8); 
                           system.debug('------RegHrs ----- '+RegHrs );
                           system.debug('------RegHrsExcludigHoliday ----- '+RegHrsExcludigHoliday );
                           RegularHours = ResourceCount * RegHrsExcludigHoliday ;
                            system.debug('------RegularHours2----- '+RegularHours );

                        
                       }
                       
                   }
                   
                
                TotalRegHours += RegularHours;
                system.debug('***TotalRegHours '+TotalRegHours );  
                objTimesheetCost.Regular_Hours_New__c = TotalRegHours ;
                update objTimesheetCost;
        }
    }
    public static Date setStringToDateFormat(String strDatevalue) {

          
           String[] strDate = strDatevalue.split('-');
           Integer myIntDate = integer.valueOf(strDate[1]);
        
           Integer myIntMonth = integer.valueOf(strDate[0]);
        
           Integer myIntYear = integer.valueOf(strDate[2]);
        
           Date datevalue = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        
           return datevalue ;

    }

}