trigger reqstatus on Requirement__c (before insert,before update) 
{
           Requirement__c req = Trigger.new[0];

           if (Trigger.isInsert)
           {
                              
               req.Resumes_2__c = 0;
               
               req.Resumes_2__c = req.No_Of_Resumes__c + req.Resumes_2__c;
               
               if(req.Submitted_Resumes__c == null && req.Status__c == 'open')
               {
                 req.Submitted_Resumes__c = req.Resumes_Submitted__c;
               }
               
           }
      
            if(Trigger.isUpdate)
            {    
            
                 if(req.Submitted_Resumes__c == null && req.Status__c == 'open')
                   {
                         req.Submitted_Resumes__c = req.Resumes_Submitted__c;
                   }                             
                 if(req.Status__c == 'Re-open' && req.isReopen__c == false)
                 {   
                     req.isReopen__c = true;

                     req.Submitted_Resumes__c = 0;
                     
                     req.Resumes_2__c = req.No_Of_Resumes__c + req.Resumes_2__c ;
                     
                     req.Req_reopen_date__c = datetime.now();
                 }
                 
                 if(req.Status__c == 'Manually Closed')
                 {
                     req.Resumes_2__c = req.Candidate_Approved_Count__c;
                     
                     req.isReopen__c = false;          
                  
                     req.Req_Closed_Date__c= datetime.now();
                 }
                 
                 if(req.Status__c == 'Auto Closed')
                 {
                     req.isReopen__c = false;   
                     
                     req.Req_Closed_Date__c= datetime.now();            
                     
                 }
              }
            
}