/**
 * @author           Shahida
 * @version          1.0 
 * @date             27/11/2015
 * @Status           Developed
 * @description      Test class for opportunity report email alert scheduler class
 *
 */
@istest
public class  EZRE_OppEmail_Report_Schedule_Test 
{
    ///<OBJECTIVE>
    /// Test method to test opportunity report email alert scheduler method
    ///<OBJECTIVE>
    static testmethod void testschedule() 
    {        
        EZRE_OppEmail_Report_Schedule objOppEmailSch = new EZRE_OppEmail_Report_Schedule();
        EZRE_OppEmail_Report  objOppEmailRpt= new EZRE_OppEmail_Report ();
        objOppEmailRpt.callScheduleMethod();
        String strSch = '0 0 22 * * ?';
        String strjobId = system.schedule('Test schedule', strSch,objOppEmailSch ); 
        CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
        System.assertEquals(strSch, ct.CronExpression); 
     
    }

}