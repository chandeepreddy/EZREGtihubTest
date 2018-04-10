/*
 * @author           Gangadhar R
 * @version          1.0 
 * @date             29/03/2016
 * @description      Scheduler for Inside Sale Rep Report Daily call List
 */
global class EZRE_InsideSales_DailyCallList_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule method
    // </OBJECTIVE>
     global void execute (SchedulableContext SC)
     {
          EZRE_DailyWorkAllocationNewSet  salesRprt=new EZRE_DailyWorkAllocationNewSet();
          salesRprt.Execute();
     }
}