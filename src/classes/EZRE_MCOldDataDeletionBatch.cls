/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             30-Sept-2016
 * @Status           Developed
 * @description      Batch apex class for deleting old subscriber data from Mailchimp objects
 *                  EZRE_MCOldDataDeletion_Sch - scheduler is written to run the batch job once in every 10 days.
 **/
global class EZRE_MCOldDataDeletionBatch {
/*
global class EZRE_MCOldDataDeletionBatch implements Database.batchable<sObject>
{ 
   global Iterable<SObject> start(Database.batchableContext info)
   { 
       Iterable<SObject> objItrble = (Iterable<SObject>) new EZRE_MC_CustomIterable();       
       return objItrble;
       
   } 
   
   global void execute(Database.batchableContext info, List<sObject> scope)
   {      
           System.debug('scope--------------------'+scope);
           System.debug('scope------size--------------'+scope.size());
           if(scope.size() != 0)
           {
           
                try
               {
                    delete scope; 
               }
               catch(Exception ex)
               {
                   System.debug('exception in EZRE_MCOldDataDeletionBatch  execute'+ex);
               }
           
           }
          
          
   } 
   
   global void finish(Database.batchableContext info)
   { 
       
   } */
}