global class Emailalert implements Schedulable
{
        global void execute (SchedulableContext SC)
             {
                      assigncandidatestatusemailalert e = new assigncandidatestatusemailalert();
                      e.SendEmail();
             }
}