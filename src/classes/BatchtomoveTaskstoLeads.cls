global class BatchtomoveTaskstoLeads implements Database.Batchable<sObject>
{   
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String contactslist='select Id,Lead_Id__c,Email,(select WhoId,subject,Priority,Status,ReminderDateTime,IsReminderSet,Campaign__c,OwnerId,Who.type,Created_by_Rep__c,Sentiment_Score__c,Description ,ActivityDate,TaskSubtype,Type,CallType,CallDisposition,IsTaskMovedtoLead__c from Tasks where IsTaskMovedtoLead__c=false and Who.Type = \'Contact\') from Contact where IsContactConvertedtoLead__c=true and isDoNotDelete__c = true Order by CreatedDate desc';
        return Database.getQueryLocator(contactslist);
    }
    global void execute(Database.BatchableContext bc, List<Contact> contactslist)
    {
         List<Task> lsttask = new List<Task>();
             for ( Contact contask : contactslist)
             {
            
                 for ( Task eachtask: contask.tasks )
                 {
                     
                        Task newtask = new Task();
                        newtask.subject=eachtask.subject;
                        newtask.Priority=eachtask.Priority;
                        newtask.Status=eachtask.Status;            
                        newtask.ReminderDateTime =eachtask.ReminderDateTime;
                        newtask.IsReminderSet =eachtask.IsReminderSet;
                      newtask.Campaign__c =eachtask.Campaign__c;
                     system.debug('==CAMPAIGN1==' +newtask.Campaign__c);
                     system.debug('==CAMPAIGN2==' +eachtask.Campaign__c);

                     if(eachtask.OwnerId == '00540000003nyiNAAQ' || eachtask.OwnerId == '00540000003nyiXAAQ' || eachtask.OwnerId == '005400000033nU3AAI' || eachtask.OwnerId == '00540000003476LAAQ' || eachtask.OwnerId == '005400000033wgDAAQ' || eachtask.OwnerId == '00540000003caMBAAY' || eachtask.OwnerId == '00540000003cbWvAAI' || eachtask.OwnerId == '00540000003cTEjAAM')
                           {
                               
                             eachtask.OwnerId = '0051W000004iCSVQA2';
                                
               }
                        newtask.OwnerId =eachtask.OwnerId;
                     system.debug('+++++' +newtask.ownerId);
                     system.debug('====' +eachtask.ownerId);

                        newtask.Created_by_Rep__c =eachtask.Created_by_Rep__c ;
                        newtask.Sentiment_Score__c =eachtask.Sentiment_Score__c ;
                        newtask.Description =eachtask.Description ;
                        newtask.ActivityDate =eachtask.ActivityDate;
                      //  newtask.Email = contask.Email;
                        
                        //newtask.Phone =eachtask.Phone;
                        newtask.TaskSubtype =eachtask.TaskSubtype;
                        newtask.Type=eachtask.Type;
                        newtask.CallType=eachtask.CallType;
                        newtask.CallDisposition=eachtask.CallDisposition;
                        newtask.WhoId = contask.Lead_Id__c;
                     system.debug('$$$$' +newtask.whoId);
                     SYSTEM.debug('CONTASK'+CONTASK);
                     system.debug('$$$$' +contask.Lead_Id__c);

                      lsttask.add(newtask);
                     system.debug('%%%%%%%%' +lsttask);
                 }
             }
         insert lsttask;
    }
      
   global void finish(Database.BatchableContext bc) 
    {

    }
}