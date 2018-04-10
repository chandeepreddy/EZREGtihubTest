/*
 * @author           Kirankumar
 * @version          1.0 
 * @date             01/05/2017
 * @description      Test class for Inside Sale Rep daily Call List scheduler class
 *
 */
 @isTest
 public class  EZRE_ContactDailyCalLstAllction_Sch_Test
 {
     public static testmethod void testScheduler()
     {
       EZRE_ContactDailyCalLstAllction_Schedule schedulerObj =new EZRE_ContactDailyCalLstAllction_Schedule();      
       String strSch = '0 0 22 * * ?';
       String strjobId = system.schedule('Test schedule', strSch,schedulerObj); 
       CronTrigger ct = EZRE_OppRprt_DataFactory_Test_Utility.getCronTriggewrDetails(strjobId);
       System.assertEquals(strSch, ct.CronExpression); 

     }

 }