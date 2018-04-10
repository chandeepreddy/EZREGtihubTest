/*
 * @author           Indhu
 * @version          1.0 
 * @date             10/20/2014
 * @Modified By      Shahida M
 * @Modified Date    11/15/2016
 * @description      Trigger to call mailChimp callout class to created campaign only once when requirement assigned to first LR.  
 * @Modified By      Shahida M
 * @Modified Date    01/16/2017
 * @description      Trigger to call mailChimp callout class to created campaign only once when requirement assigned to first LR/R.  
 */   
trigger EZRE_SendReqmtAssignMailTrigger on RequirementAssignment__c(after insert,after update)
{

    if(Trigger.isAfter)
    {
       if(Trigger.isInsert)
       {   
        Set<Id> requirementIdSet=new Set<Id>();
        List<RequirementAssignment__c> assignRequiementList=new List<RequirementAssignment__c>();
        Map<String,List<RequirementAssignment__c>> allAssignRequiementsMap=new  Map<String,List<RequirementAssignment__c>>();  
        for(RequirementAssignment__c requirementAssignment :trigger.new)
        {
            if(requirementAssignment.Lead_Recruiter__c!=null)
            {
                requirementIdSet.add(requirementAssignment.requirement__c);  
            }
            else if(requirementAssignment.Recruiter__c!=null)
            {
                requirementIdSet.add(requirementAssignment.requirement__c);  
            }
        }
        system.debug('requirementIdSet:=========='+requirementIdSet);
        assignRequiementList=EZRE_Requirement_DataUtility.getAssignRequirements(requirementIdSet);
        system.debug('assignRequiementList size========'+assignRequiementList.size());

        if(assignRequiementList.size()>0)
        {
            for(RequirementAssignment__c  assgnReq:assignRequiementList)
            {
                if(allAssignRequiementsMap.containsKey(assgnReq.requirement__c))
                {
                      allAssignRequiementsMap.get(assgnReq.requirement__c).add(assgnReq);
                }
                else
                {
                     allAssignRequiementsMap.put(assgnReq.requirement__c,new List<RequirementAssignment__c>{assgnReq});
                }
            system.debug('allAssignRequiementsMap==============='+allAssignRequiementsMap);
            }
             //block of code to get requirements assigned to lead recruiter.
           /* if(allAssignRequiementsMap.size()>0)
            {
                for(String requirementId:allAssignRequiementsMap.Keyset())
                {
                    if(allAssignRequiementsMap.containsKey(requirementId))
                    {
                        List<RequirementAssignment__c> requirementAssignments=allAssignRequiementsMap.get(requirementId);
                        system.debug('requirementAssignments=========='+requirementAssignments);
                        if(requirementAssignments.size()==1)   
                        {
                             for(RequirementAssignment__c assgnReq:requirementAssignments)
                             {
                                if((assgnReq.Lead_Recruiter__c!=null)||(assgnReq.Recruiter__c!=null))
                                {
                                   
                                    //Call mailchimp callout to create campaign
                                    EZRE_MailChimp_MultiListCampaign.sendReqmtMail(requirementId);
                                    system.debug('############go to mailchimp call');   
                                }
                            }
                        }
                    } 
                }               
            }   */
        }
      } 
    }
    if(Trigger.isAfter)
    {
       if(Trigger.isUpdate)
       {
        if(EZRE_RecursionCheckforTrigger.isFutureUpdate!=true)
        {
            EZRE_RecursionCheckforTrigger.isFutureUpdate = true; 
            system.debug('Recrusive flag in assign requirement after insert:'+EZRE_RecursionCheckforTrigger.isFutureUpdate);
            
        system.debug('Recrusive flag in assign requirement after update:'+EZRE_RecursionCheckforTrigger.isFutureUpdate);
        Set<Id> requirementIds=new Set<Id>();
        List<RequirementAssignment__c> assignRequiements=new List<RequirementAssignment__c>();
        Map<String,List<RequirementAssignment__c>> allAssignRequiements=new  Map<String,List<RequirementAssignment__c>>();  
        for(RequirementAssignment__c requirementAssignment :trigger.old)
        {
            system.debug('old requirementAssignment '+requirementAssignment );
            if((String.isBlank(requirementAssignment.Lead_Recruiter__c))&&(String.isBlank(requirementAssignment.Recruiter__c)))
            {
                requirementIds.add(requirementAssignment.requirement__c);  
            } 
        }
        system.debug('Update_requirementIds:=========='+requirementIds);
        assignRequiements=EZRE_Requirement_DataUtility.getAssignRequirements(requirementIds);
        system.debug('Update_assignRequiements size========'+assignRequiements.size());
        if(assignRequiements.size()>0)
        {
            for(RequirementAssignment__c  assgnReq:assignRequiements)
            {
                if(allAssignRequiements.containsKey(assgnReq.requirement__c))
                {
                      allAssignRequiements.get(assgnReq.requirement__c).add(assgnReq);
                }
                else
                {
                     allAssignRequiements.put(assgnReq.requirement__c,new List<RequirementAssignment__c>{assgnReq});
                }
            system.debug('Update_allAssignRequiements==============='+allAssignRequiements);
            }
             //block of code to get requirements assigned to lead recruiter.
           /* if(allAssignRequiements.size()>0)
            {
                for(String requirementId:allAssignRequiements.Keyset())
                {
                    integer unAssignedRequirementCount=0;   
                    if(allAssignRequiements.containsKey(requirementId))
                    {
                        List<RequirementAssignment__c> requirementAssignments=allAssignRequiements.get(requirementId);
                        system.debug('Update_requirementAssignments=========='+requirementAssignments);
                        //This block executes when requirement having only one assign requirement record and it is not assigned to any LR/R while creation.
                        if(requirementAssignments.size()==1)   
                        {
                           for(RequirementAssignment__c assgnReq:requirementAssignments)
                           {
                                if((assgnReq.Lead_Recruiter__c!=null)||(assgnReq.Recruiter__c!=null))
                                {
                                    //Call mailchimp callout to create campaign
                                    EZRE_MailChimp_MultiListCampaign.sendReqmtMail(assgnReq.requirement__c);
                                    system.debug('Update_############go to mailchimp call');   
                                }
                           }
                        }
                    } 
                }      
            }   */
        }   
     }
     }   
   }
  
}