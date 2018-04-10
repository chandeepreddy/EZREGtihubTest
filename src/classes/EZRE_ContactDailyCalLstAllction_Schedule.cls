/*
 * @author           Kirankumar
 * @version          1.0 
 * @date             01/05/2017
 * @description      Scheduler for Daily Call List
 */
global class EZRE_ContactDailyCalLstAllction_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule method
    // </OBJECTIVE>
     global void execute (SchedulableContext SC)
     {
          EZRE_ContactDailyCallListAllocation salesRprt=new EZRE_ContactDailyCallListAllocation();
          salesRprt.Execute();
     }
}