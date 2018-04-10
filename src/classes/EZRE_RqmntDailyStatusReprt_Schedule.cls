/*
 * @author           Shahida K
 * @version          1.0 
 * @date             21/03/2016
 * @description      Scheduler for Requirements status report
 */
global class EZRE_RqmntDailyStatusReprt_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule class 
    // </OBJECTIVE>
     global void execute (SchedulableContext SC)
     {
          EZRE_RequirementDailyStatusReprt_batch reqDlyRprt=new EZRE_RequirementDailyStatusReprt_batch();
          Database.executeBatch(reqDlyRprt,2000);
     }
}