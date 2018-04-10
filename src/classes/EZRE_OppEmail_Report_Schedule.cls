/*
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             27/11/2015
 * @description      Scheduler send opportunity report as email alert
 */
global class EZRE_OppEmail_Report_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule class 
    // </OBJECTIVE>
    global void execute (SchedulableContext SC)
     {
          EZRE_OppEmail_Report email = new EZRE_OppEmail_Report();  
          email.callScheduleMethod();
     }
}