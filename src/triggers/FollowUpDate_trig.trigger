/*
* @author           Joseph Britto, 
* @version          1.0 
 * @date             9/1/2013
* @description      Trigger to insert Note when Follow Up date is changed in Candidate
*/ 
trigger FollowUpDate_trig on Candidate__c(before update) 
{
    for(Candidate__c ca : Trigger.new)
    {
        //Candidate__c ca = Trigger.new[0];   
        if(Trigger.isUpdate)
        {     
            Map<Id,Candidate__c> newContactMap = Trigger.newMap; 
            Map<Id,Candidate__c> oldContactMap = Trigger.oldMap;
            //Loop through the map
            for(Id contactId:newContactMap.keySet())
            { 
                Candidate__c myNewContact = newContactMap.get(contactId);
                Candidate__c myOldContact = oldContactMap.get(contactId);
                if (myNewContact.Followup_Date__c <> myOldContact.Followup_Date__c)
                {
                    if(ca.Notes__c !=null)
                    {
                        Note n  = new Note();
                        n.ParentId = ca.Id;
                        n.Title = ca.Notes__c;
                        n.Body = ca.Notes__c; 
                        try
                        {
                            insert n;    
                                
                        } 

                        catch(System.DMLException e)
                        {
                            ApexPages.addMessages(e);
                        }               
                                        
                        ca.Notes__c='';
                    }
                    else
                    {                       
                        ca.Notes__c.addError('Notes are mandatory while changing FollowUpDate​');
                    }
                }

            }

        }
    }
}