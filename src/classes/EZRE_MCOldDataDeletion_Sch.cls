/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             30-Sept-2016
 * @Status           Developed
 * @description      Scheduler class to schedule EZRE_MCOldDataDeletionBatch batch class for deleting old subscriber data from Mailchimp objects
 *                  The job will run once in every 10 days.
 **/
global class EZRE_MCOldDataDeletion_Sch {
/*
global class EZRE_MCOldDataDeletion_Sch  implements Schedulable
{
    //To hold the job name.
    public  String jobNameStr {get; set;}
   
    
    ///OBJECTIVE
    ///To execute EZRE_MCOldDataDeletionBatch batch class and delete the old records.
    ///OBJECTIVE
    global void execute(SchedulableContext SC) 
    {      
   
       try
        {
            EZRE_MCOldDataDeletionBatch objMCDeletionBatch=new EZRE_MCOldDataDeletionBatch ();
            Database.executeBatch(objMCDeletionBatch);
            jobNameStr = 'Job-MC_OldDataDeletion' +System.Today();            
            
            System.schedule(jobNameStr,'0 0 0 1 * ? *',new EZRE_MCOldDataDeletion_Sch());
             

        }
       
        catch(Exception ex)
        {           
            System.debug('Based on configured schedule, the given trigger will never fire.' + ex.getMessage());
            System.schedule(jobNameStr,'0 0 0 10 * ? *',new EZRE_MCOldDataDeletion_Sch());
            
        }
    
    }*/
}