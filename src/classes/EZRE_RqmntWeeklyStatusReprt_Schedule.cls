/*
 * @author           Shahida K
 * @version          1.0 
 * @date             21/03/2016
 * @description      Scheduler for Requirements status weekly report
 */
global class EZRE_RqmntWeeklyStatusReprt_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule class 
    // </OBJECTIVE>
     global void execute (SchedulableContext SC)
     {
          EZRE_RequirementWeeklyStatusReprt_Batch reqDlyRprt=new EZRE_RequirementWeeklyStatusReprt_Batch();
          Database.executeBatch(reqDlyRprt,2000);
     }
}