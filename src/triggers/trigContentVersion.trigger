trigger trigContentVersion on ContentVersion (after update, before insert) 
{             
    for(ContentVersion cv :Trigger.new)
    {
        if(Trigger.isInsert)
        {     
            ContentVersionTrigClass obj = new ContentVersionTrigClass();
            Candidate__c c = [Select Id from Candidate__c Limit 1];
            Candidate__c can = new Candidate__c(Id = c.Id);
            System.Debug('@@@@@@@@@@@@@@@@@@@can '+ can);   
            can.Resume_Attach__c = cv.Id;   
            System.debug('can.Resume_Attach__c - Trigger Insert' + can.Resume_Attach__c);
            update can;
        }    
        if(Trigger.isUpdate)
        {     
            ContentVersionTrigClass.CVAftUpdateMethod(cv.Id);
        }
    }                    
}