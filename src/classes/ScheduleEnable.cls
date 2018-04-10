/**
 * @author           Indhu
 * @version          1.0 
 * @date             12/17/2014
 * @Status           Developed
 * @description      Scheduler class for schedule mail to send hot list report.
 *
 */
global class ScheduleEnable implements Schedulable
{
    global void execute (SchedulableContext SC)
    {
        EmailMessage objEmailMsg = new EmailMessage();
        objEmailMsg.SendEmail();
    }
}