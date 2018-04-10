@istest

class TestEmailAlertScheduleClass 
{

    static testmethod void testschedule() 
    {  
       
                Emailalert sh1 = new Emailalert();

                assigncandidatestatusemailalert e = new assigncandidatestatusemailalert();

                e.SendEmail();

                  String sch = '0 0 22 * * ?';
                  
              system.schedule('Test schedule', sch, sh1); 
     
    }

}