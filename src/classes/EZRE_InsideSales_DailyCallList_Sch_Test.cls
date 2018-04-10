/**
 * @author           Gangadhar R
 * @version          1.0 
 * @date             29/03/2016
 * @Status           Developed
 * @description      Test class for Inside Sale Rep daily Call List scheduler class
 *
 */
 @isTest
 public class  EZRE_InsideSales_DailyCallList_Sch_Test 
 {
     public static testmethod void testScheduler()
     {
       EZRE_InsideSales_DailyCallList_Schedule  schedulerObj =new EZRE_InsideSales_DailyCallList_Schedule();      
       String strSch = '0 0 22 * * ?';
       String strjobId = system.schedule('Test schedule', strSch,schedulerObj); 
       CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
       System.assertEquals(strSch, ct.CronExpression); 

     }

 }