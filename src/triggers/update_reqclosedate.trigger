trigger update_reqclosedate on Requirement__c (after insert, after update) 
{


            if(Trigger.isUpdate)
            {                                  
                 
                Requirement__c req = Trigger.new[0];
                 
                 if(req.Status__c == 'Manually Closed')
                 {
                     
                     req.Req_Closed_Date__c = system.datetime.now();
                     
                 }
                 
                 if(req.Status__c == 'Auto Closed')
                 {
                     
                     req.Req_Closed_Date__c = system.datetime.now();
                     
                 }
            }

}