/**
 * @author           Shahida K
 * @version          1.0 
 * @date             06/13/2014
 * @Status           Developed
 * @description      Scheduler which runs for every 15 minutes.
 *
 */
global class EZRE_MC_MarketingEmailTask_Scheduler implements Schedulable
{
    //To hold the job name.
    public  String strJobName {get; set;}
    //To hold the schedule time.
    public  String strSchedule {get; set;}
    
    ///OBJECTIVE
    ///To execute the mailchimp apex class and delete the finished jobs.
    ///OBJECTIVE
    global void execute(SchedulableContext SC) 
    {
      /* try
         {
            EZRE_MC_MarketingEmailTask.createSendEmailTask();
             
            String day = string.valueOf(system.now().day());
            String month = string.valueOf(system.now().month());
            String hour = string.valueOf(system.now().hour());
            
            String minute = string.valueOf(system.now().minute());
            if(Integer.valueOf(minute)>= 45)
            {
                minute = string.valueOf(system.now().addMinutes(16).minute());
                hour = string.valueOf(system.now().addHours(1).hour());
            }
            else
            {
                minute = string.valueOf(system.now().addMinutes(15).minute());
            }
            
            if(Integer.valueOf(hour)==23 && Integer.valueOf(minute)>=45)
          {
            day  = string.valueOf(system.now().addDays(1).Day());
          }  
          else
          {
            day =  string.valueOf(system.now().day());
          }
            
            
            
            String second = string.valueOf(system.now().second());
            String year = string.valueOf(system.now().year());

            strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
            //strSchedule = '0 ' + 20 + ' ' + 23 + ' ' + 11 + ' ' + 03 + ' ?' + ' ' + 2015;
            strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            System.schedule(strJobName, strSchedule, new EZRE_MC_MarketingEmailTask_Scheduler());
        }
        catch(Exception ex)
        {
            System.debug('Based on configured schedule, the given trigger will never fire.' + ex.getMessage());
            System.schedule(strJobName, strSchedule, new EZRE_MC_MarketingEmailTask_Scheduler());
        }
        //To delete the finished jobs.
        List<CronTrigger> finishedJobs = [SELECT Id FROM CronTrigger WHERE State = 'DELETED' AND TimesTriggered =1 ];
        for(CronTrigger cronId: finishedJobs)
        {
            System.abortJob(cronId.Id);
        }*/
    }
}