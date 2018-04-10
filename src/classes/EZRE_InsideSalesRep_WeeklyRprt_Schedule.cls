/*
 * @author           Shahida K
 * @version          1.0 
 * @date             23/03/2016
 * @description      Scheduler for Inside Sale Rep Report Weekly email alert
 */
global class EZRE_InsideSalesRep_WeeklyRprt_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule method
    // </OBJECTIVE>
     global void execute (SchedulableContext SC)
     {
          EZRE_InsideSalesRep_WeeklyReport salesRprt=new EZRE_InsideSalesRep_WeeklyReport();
          salesRprt.RunReport();
     }
}