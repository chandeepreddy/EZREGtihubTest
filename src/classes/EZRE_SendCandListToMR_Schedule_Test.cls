/**
 * @author           Shahida
 * @version          1.0 
 * @date             05/02/2015
 * @Status           Developed
 * @description      Test class for candidates waiting for MR approval email alert scheduler class
 *
 */
@istest
public class  EZRE_SendCandListToMR_Schedule_Test 
{
    ///<OBJECTIVE>
    /// Test method to test candidates waiting for MR approval email alert scheduler method
    ///<OBJECTIVE>
    static testmethod void testschedule() 
    {        
        EZRE_SendCandidatesListToMR_Schedule objCandEmailSch = new EZRE_SendCandidatesListToMR_Schedule();
        EZRE_SendCandidatesListToMR  objCandEmailAlert= new EZRE_SendCandidatesListToMR();
        objCandEmailAlert.SendCandidatesListToMR();
        String strSch = '0 0 22 * * ?';
        String strjobId = system.schedule('Test schedule', strSch,objCandEmailSch ); 
        CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
        System.assertEquals(strSch, ct.CronExpression); 
     
    }

}