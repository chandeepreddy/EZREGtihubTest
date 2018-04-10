/**
 * @author           Shahida
 * @version          1.0 
 * @date             24/03/2016
 * @Status           Developed
 * @description      Test class for Inside Sale Rep Report email alert(Daily) scheduler class
 *
 */
 @isTest
 public class  EZRE_InsideSalsRep_DailyRprt_Schdl_Test 
 {
     public static testmethod void testScheduler()
     {
        EZRE_InsideSalesRep_DailyReport_Schedule schedulerObj=new EZRE_InsideSalesRep_DailyReport_Schedule();
        EZRE_InsideSalesRep_DailyReport DailyReport=new EZRE_InsideSalesRep_DailyReport();
        DailyReport.RunReport();
        String strSch = '0 0 22 * * ?';
        String strjobId = system.schedule('Test schedule', strSch,schedulerObj); 
        CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
        System.assertEquals(strSch, ct.CronExpression); 

     }

 }