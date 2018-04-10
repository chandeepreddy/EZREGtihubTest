/**
 * @author           Keerthi Chandra
 * @version          1.0 
 * @date             06/05/2014
 * @Status           Developed
 * @Modified By      Shahida K
 * @Modified Date    11/22/2016 
 * @description      Scheduler which runs for every 15 minutes.
 *
 */
global class EZRE_MC_MarketingEmail_Scheduler implements Schedulable
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
      /*  try
       {
            EZRE_MC_MarketingEmail.sendMailToContactOwnr();
            EZRE_MC_MarketingSendEmailTask.sendMailToContactOwnr();
             
            String day = string.valueOf(system.now().day());
            String month = string.valueOf(system.now().month());
            String hour = string.valueOf(system.now().hour());
            String second = string.valueOf(system.now().second());
            String year = string.valueOf(system.now().year());
            String minute = string.valueOf(system.now().minute());
            String milliseconds = String.valueOf(system.now().millisecond());
            
           if(Integer.valueOf(minute)>= 45)
            {
                minute = string.valueOf(system.now().addMinutes(16).minute());
                hour = string.valueOf(system.now().addHours(1).hour());
                System.debug('Add minutes============='+minute);
                System.debug('Add Hours==========='+hour );
            }
            else
            {
                minute = string.valueOf(system.now().addMinutes(15).minute());
                system.debug('Add 15 minutes:' +minute);
            }
            
           if((Integer.valueOf(system.now().hour())== 23) && (Integer.valueOf(system.now().minute())>=45))
           {
                minute = String.valueOf(0);
                hour = String.valueOf(0);
                day  = string.valueOf(system.now().addDays(1).Day());
                System.debug('Add Day============='+day);
           }  
           else
           {
                 day =  string.valueOf(system.now().day());
                 System.debug('Same Day============='+day);
           }
            strJobName = 'EZRE_MC_MarketingEmail_SchedulerJob-' + milliseconds + '_' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
            //strSchedule = '0 ' + 20 + ' ' + 23 + ' ' + 11 + ' ' + 03 + ' ?' + ' ' + 2015;
            strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            System.schedule(strJobName, strSchedule, new EZRE_MC_MarketingEmail_Scheduler());
        }
        catch(Exception ex)
        {
            System.debug('Based on configured schedule, the given trigger will never fire:EZRE_MC_MarketingEmail_Scheduler' + ex.getMessage());
            System.schedule(strJobName, strSchedule, new EZRE_MC_MarketingEmail_Scheduler());
        }
        //To delete the finished jobs.
        List<CronTrigger> finishedJobs = [SELECT Id FROM CronTrigger WHERE State = 'DELETED' AND TimesTriggered =1 ];
        for(CronTrigger cronId: finishedJobs)
        {
            System.debug('Aborted Job Id:========'+cronId.Id);
            System.abortJob(cronId.Id);
        }*/
        
    }
}