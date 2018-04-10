/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             09-Dec-2016
 * @Status           In Development
 * @description      Trigger on ProjectTeamMember object to avoid duplicate team member based on service and also to
                     update names to existing timesheet record when ProjectTeamMember name changes.
 */
 
trigger ODS_ProjectTeamMemberTrigger on Project_Team_Member__c (before insert, before update, after update) {

ODS_ProjectTeamMemberController objTeamMemberName = new ODS_ProjectTeamMemberController ();
     
     if(Trigger.isBefore)
     {
         if(Trigger.isInsert)
             objTeamMemberName.validateTeamMemberName(Trigger.new);
         if(Trigger.isupdate)
         {
            for(Project_Team_Member__c objMember: Trigger.new)
            {
                Project_Team_Member__c oldPTM = Trigger.oldMap.get(objMember.id);
                string oldMemberName = oldPTM.Resource_Name__c;            
                if(!string.isEmpty(oldMemberName)) {
                    if(!oldMemberName.equalsignorecase(objMember.Resource_Name__c))
                        objTeamMemberName.validateTeamMemberName(Trigger.new);
                }
            }
         }
      }
      if(Trigger.isAfter)
      {
          if(Trigger.isupdate)
         {
            for(Project_Team_Member__c objMember: Trigger.new)
            {
                Project_Team_Member__c oldPTM = Trigger.oldMap.get(objMember.id);
                string oldMemberName = oldPTM.Resource_Name__c;            
                if(!string.isEmpty(oldMemberName)) {
                    if(!oldMemberName.equalsignorecase(objMember.Resource_Name__c))
                    {
                        objTeamMemberName.updateTeamMemberName(Trigger.new);
                    }
                }
            }
         }
      }
}