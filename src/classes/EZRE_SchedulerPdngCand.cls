/**
 * @author           Soumya
 * @version          1.0 
 * @date             28/11/2014
 * @Status           Developed
 * @description      This class is used to schedule batch job to send Email to Recruiters
                          with the list of Pending Candidates on all weekdays at 6AM
 *                   
*/
global class EZRE_SchedulerPdngCand implements Schedulable{
    global void execute(SchedulableContext sc) {
        EZRE_BatchSendMailToPdngCand batchPC = new EZRE_BatchSendMailToPdngCand();
        ID batchprocessid = Database.executeBatch(batchPC,50);           
    }
}