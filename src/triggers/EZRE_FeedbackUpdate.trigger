Trigger EZRE_FeedbackUpdate on Requirement__c (before update,before insert) {
 //<Requirement__c> s = Trigger.oldMap.get(Requirement__c.Id);
       // string s    = Trigger.oldMap.get(Req.Id).Recruiter_Feedback__c ; 
         Datetime yourDate = Datetime.now();
         String dateOutput = yourDate.format('dd/MM/yyyy');
for(Requirement__c  req : Trigger.New )
{
    if(Trigger.isInsert)
{
  if(req .Recruiter_Feedback__c != null)
  {
     req .Total_Feedback__c = dateOutput+ ' ' +UserInfo.getName()+':'+ req .Recruiter_Feedback__c;
      req.Recruiter_Feedback__c = '';
  }
}
   if (Trigger.isUpdate) 
   { 
   string oldtotalFeedbackValue    = Trigger.oldMap.get(Req.Id).Total_Feedback__c;
     string oldFeedbackValue         = Trigger.oldMap.get(Req.Id).Recruiter_Feedback__c;
   
   if(req .Recruiter_Feedback__c != null && oldtotalFeedbackValue == null)
   {
     
      req .Total_Feedback__c = dateOutput+ ' ' +UserInfo.getName()+':'+ req .Recruiter_Feedback__c;
      req.Recruiter_Feedback__c = '';
    
   }
   else if(req .Recruiter_Feedback__c != null && oldtotalFeedbackValue != null )
   {
       req .Total_Feedback__c = oldtotalFeedbackValue+ '\n'+dateOutput+ ' ' +UserInfo.getName()+':'+ req .Recruiter_Feedback__c;
       req.Recruiter_Feedback__c = '';
   }
 
   }
   
}
   


}