/*
 * @author           Shahida K
 * @version          1.0 
 * @date             21/03/2016
 * @description      Scheduler for Requirements status monthly report
 */
global class EZRE_RqmntMonthlyStatusReprt_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule class 
    // </OBJECTIVE>
     global void execute (SchedulableContext SC)
     {
          EZRE_RequirementMonthlyStatusReprt_Batch reqDlyRprt=new EZRE_RequirementMonthlyStatusReprt_Batch();
          Database.executeBatch(reqDlyRprt,2000);
     }
}