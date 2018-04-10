global class ContentVersionTrigClass
{
    
    @future(callout=true)
    public static void CVAftUpdateMethod(string contentid)
    {  
        ContentVersion listR = [Select Id,Candidate_ID__c from ContentVersion where Id =:contentid limit 1];                  
        System.Debug(listR);
        Candidate__c can = new Candidate__c(ID = listR.Candidate_ID__c);
        can.Resume_Attach__c = listR.Id;               
        System.debug('can.Resume_Attach__c - Trigger Update' + can.Resume_Attach__c);
        
        update can;
    }
}