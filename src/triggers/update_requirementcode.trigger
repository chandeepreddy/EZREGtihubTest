/**
 * @author           Selva pandian
 * @version          1.0 
 * @date             08/10/2012
 * @Status           Developed
 * @description      This trigger is to Update Field in the Requirement object
 * @changes Done     Gangadhar R 29/02/2016.
 */
trigger update_requirementcode on Requirement__c (Before insert, Before update) 
{
    if(Trigger.isInsert)
    {
       Requirement__c[] req =Trigger.new;
       UpdateRequirementCode.display(req);
       for(Requirement__c reqt: Trigger.New)
       {
           if(reqt.Status__c == 'Open')
           {
               reqt.StatusUpdated_Date__c = Date.Today();
           } 
       }
            
    }
    
    if(Trigger.isUpdate)
    {      
          for (Integer i = 0; i < Trigger.new.size(); i++)    
          {
               if (Trigger.new[i].Opportunity_Code__c!= Trigger.old[i].Opportunity_Code__c )
               {
                 Requirement__c[] req  = Trigger.new;
            
                 UpdateRequirementCode.display(req); 
               }  
          }   
           for(Requirement__c reqt: Trigger.New)
           {  
               if ((Reqt.Status__c == 'Open' || Reqt.Status__c == 'Re-Open') && (Reqt.Status__c != Trigger.OldMap.get(reqt.Id).Status__c))
               {           
                 reqt.StatusUpdated_Date__c = Date.Today(); 
               } 
               if ((Reqt.Status__c == 'Manually closed' || Reqt.Status__c == 'Auto closed') && (Reqt.Status__c != Trigger.OldMap.get(reqt.Id).Status__c))
               {           
                 reqt.StatusClosed_Date__c = Date.Today(); 
               } 
                
          }                            
     }
}