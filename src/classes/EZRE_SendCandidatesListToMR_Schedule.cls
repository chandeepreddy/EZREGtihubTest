/*
 * @author           Shahida K
 * @version          1.0 
 * @date             04/02/2016
 * @description      Scheduler to send Candidates waiting for MR approval email
 */
global class EZRE_SendCandidatesListToMR_Schedule implements Schedulable
{
    // <OBJECTIVE>
    // Interface method to execute the schedule class 
    // </OBJECTIVE>
    global void execute (SchedulableContext SC)
     {
          EZRE_SendCandidatesListToMR objCandidate=new EZRE_SendCandidatesListToMR();
          objCandidate.SendCandidatesListToMR();
     }
}