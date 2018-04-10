/* @author           Keerthi Chandra
 * @createdDate      2/8/2015 
 * @Modified By      Shahida K
 * @version          1.0 
 * @Modified date    11/14/2016
 * @description      Scheduler that runs every 15 minutes to send Mailchimp campaigns 
 */
global class sendCndtEmailScheduler{
/*
global class sendCndtEmailScheduler  implements Schedulable
{
    //To hold the job name.
    public  String jobNameStr {get; set;}
    //To hold the schedule time.
    public  String scheduleStr {get; set;}
    
     /// <OBJECTIVE>
     /// Interface method to execute the schedule method
     /// </OBJECTIVE>
    global void execute(SchedulableContext SC) 
    {
       try
         {
           EZRE_MCEmailToAssignmentOwner.sendMailToAssgnmntOwnr();
          //EZRE_MCEmailToAssignmentOwner_V3_1.sendMailToAssgnmntOwnr();
        
            String day = string.valueOf(system.now().day());
            String month = string.valueOf(system.now().month());
            String hour = string.valueOf(system.now().hour());
            String minute = string.valueOf(system.now().minute());
            String second = String.valueOf(system.now().second());
            String year = String.valueOf(system.now().year());
            String milliseconds = String.valueOf(system.now().millisecond());
           
            System.debug('milliseconds :============'+milliseconds);
            
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
            jobNameStr = 'SendCndtEmailScheduler-' + milliseconds + '_ ' +second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
            system.debug('jobNameStr==================='+jobNameStr);
            
            scheduleStr = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            System.schedule(jobNameStr,scheduleStr,new sendCndtEmailScheduler());
        }
        catch(Exception ex)
        {
            System.debug('Based on configured schedule, the given trigger will never fire:sendCndtEmailScheduler' + ex.getMessage());
            System.schedule(jobNameStr,scheduleStr,new sendCndtEmailScheduler());
        }
        //To delete the finished jobs.
        List<CronTrigger> finishedJobs =[SELECT Id,state FROM CronTrigger WHERE State = 'DELETED' AND TimesTriggered =1 ];
        for(CronTrigger cronId: finishedJobs)
        {
            System.debug('Job Id To Abort:========='+cronId.Id);
            System.abortJob(cronId.Id);
        }
    }*/
}