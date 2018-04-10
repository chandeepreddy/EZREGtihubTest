/**
 * @author           Shahida
 * @version          1.0 
 * @date             02/03/2016
 * @Status           Developed
 * @description      Test class for requirements open/reopen more than 30 days email alert scheduler class
 *
 */
@istest
public class  EZRE_SendReqmntListToMR_Schedule_Test 
{
    ///<OBJECTIVE>
    /// Test method to test requirements open/reopen more than 30 days eamil alert scheduler class functionality
    ///<OBJECTIVE>
    static testmethod void testschedule() 
    {        
 
        EZRE_SendReqmntListToMR_Schedule objReqEmailSch = new EZRE_SendReqmntListToMR_Schedule ();
        EZRE_SendRequirementsListToMR objOpenReqEmailAlert= new EZRE_SendRequirementsListToMR ();
        objOpenReqEmailAlert.sendRequirementsListToMR();
        String strSch = '0 0 22 * * ?';
        String strjobId = system.schedule('Test schedule', strSch,objReqEmailSch); 
        CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
        System.assertEquals(strSch, ct.CronExpression); 
     
    }

}