/**
 * @author           Shahida
 * @version          1.0 
 * @date             22/03/2016
 * @Status           Developed
 * @description      Test class for requirements status report email alert scheduler class
 *
 */
@istest
public class  EZRE_RqmntWeeklyStusRprt_Schedule_Test 
{
    ///<OBJECTIVE>
    /// Test method to test requirements open/reopen more than 30 days eamil alert scheduler class functionality
    ///<OBJECTIVE>
    static testmethod void testschedule() 
    {        
 
        EZRE_RqmntWeeklyStatusReprt_Schedule  RqmntStatusSch = new  EZRE_RqmntWeeklyStatusReprt_Schedule();
        EZRE_RequirementWeeklyStatusReprt_Batch ReqStatusBatchAlert= new EZRE_RequirementWeeklyStatusReprt_Batch();
        Database.executeBatch(ReqStatusBatchAlert,2000);  
        String strSch = '0 0 22 * * ?';
        String strjobId = system.schedule('Test schedule', strSch,RqmntStatusSch); 
        CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
        System.assertEquals(strSch, ct.CronExpression); 
     
    }

}