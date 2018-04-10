/*
 * @author           Gangadhar
 * @version          1.0 
 * @date             29/02/2016
 * @description      Scheduler for Requirements open report
 */
global class EZRE_SendReqmntListToMR_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule class 
    // </OBJECTIVE>
     global void execute (SchedulableContext SC)
     {
          EZRE_SendRequirementsListToMR objCandidate=new EZRE_SendRequirementsListToMR();
          objCandidate.sendRequirementsListToMR();
     }
}