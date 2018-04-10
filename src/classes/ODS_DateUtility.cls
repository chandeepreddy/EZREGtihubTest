public class ODS_DateUtility{

    public static string[] GetWeekBoundaryDatesByMonth(DateTime StartDateOfMonth){
     
        List<String> weekBoundaryDates= new List<String>();
        Integer numberOfDaysinMonth = date.daysInMonth(StartDateOfMonth.Year(), StartDateOfMonth.Month());
        String dayOfWeek = StartDateOfMonth.format('E');
        
        integer NumberOfDaysToAddForSunday = getDaysToAddForSundayByDoW(dayofWeek);
        datetime MonthEndDate = StartDateOfMonth.addDays(numberOfDaysinMonth).date();
        weekBoundaryDates.Add(StartDateOfMonth.format('yyyy-MM-dd')+'~'+StartDateOfMonth.adddays(NumberOfDaysToAddForSunday).format('yyyy-MM-dd'));
        
        for(integer i=(NumberOfDaysToAddForSunday+1)  ; i<numberOfDaysinMonth;i++){
        datetime DateofDay = StartDateOfMonth.AddDays(i);
        string DOW = DateofDay.format('E');
        if(DOW == 'Mon')
        {
           datetime thisWeekSunDate = DateofDay.adddays(6);
           if(thisWeekSunDate.date() <= MonthEndDate.date()){
               weekBoundaryDates.Add(DateofDay.format('yyyy-MM-dd')+'~'+thisWeekSunDate.format('yyyy-MM-dd') );
           }else{
                 weekBoundaryDates.Add(DateofDay.format('yyyy-MM-dd')+'~'+MonthEndDate.format('yyyy-MM-dd') );
           }
           
        } 
         
        
        }
     
        return weekBoundaryDates;
    }
    
    public static integer getDaystoAddForSundayByDoW(string DayofWeek)
    {
       if (DayofWeek == 'Mon')
        {
          return 6;
        }
        else if (DayofWeek == 'Tue')
        {
        
         return 5;
        }
        else if (DayofWeek == 'Wed')
        {
        
          return 4;
        }
        else if (DayofWeek == 'Thu')
        {
        
          return 3;
        }
        else if (DayofWeek == 'Fri')
        {
        
        return 2;
        }
        else if (DayofWeek == 'Sat')
        {
        
        return 1;
        }else if(DayofWeek == 'Sun')
        {
        
         return 0;
        
        }
        return 0;
    }
    
    /// <OBJECTIVE>
    /// Calculate Weekends
    /// </OBJECTIVE>
    public static Integer calculateWeekends(Datetime startDate, Datetime endDate)
    {
        Integer noOfWeekends  = 0;
        string prevDOW = '';  
        //Do not consider startdate. Need to calculate from next day of start date   
        startDate = startDate.adddays(1);
        while (startDate < endDate) {

        if (startDate.format('E') == 'Sat' | startDate.format('E') == 'Sun'){
            // This is to prevent dayLight save time on first week of november.
            if(startDate.format('E')!= prevDOW)
            {
                noOfWeekends  =noOfWeekends  + 1;
            }
            prevDOW = startDate.format('E');
        }
        startDate = startDate.addDays(1);
        }
        return noOfWeekends;
    }
    
    /// <OBJECTIVE>
    /// Calculate Regular Hor
    /// </OBJECTIVE>
    
    public static Integer getHoursByDayofDate(String DayofWeek)
    {
        if (DayofWeek == 'Mon')
        {
          return 40;
        }
        else if (DayofWeek == 'Tue')
        {
        
         return 32;
        }
        else if (DayofWeek == 'Wed')
        {
        
          return 24;
        }
        else if (DayofWeek == 'Thu')
        {
        
          return 16;
        }
        else if (DayofWeek == 'Fri')
        {
        
        return 8;
        }
        
        return 0;
    }
    
    public static Integer getHoursByDays(Integer NoOfDays)
    {
        Integer TotalHours = 0; 
        
        if (NoOfDays == 0)
        {
          TotalHours = 8;
        }
        else if (NoOfDays == 1)
        {
        
         TotalHours = 16;
        }
        else if (NoOfDays == 2)
        {
        
          TotalHours  = 24;
        }
        else if (NoOfDays == 3)
        {
        
          TotalHours  = 32;
        }
        else if (NoOfDays == 4)
        {
        
        TotalHours  = 40;
        }
        
       return TotalHours;
    }
}