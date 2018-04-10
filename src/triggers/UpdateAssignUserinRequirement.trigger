trigger UpdateAssignUserinRequirement on RequirementAssignment__c (before insert) 
{
    System.debug('&&&&&&&&&&&&UpdateAssignUserinRequirement :Debug');
    RequirementAssignment__c oppa = trigger.new[0];
    System.debug('a:'+oppa );
    
    //if the role is management representative then the assign to field value should be saved in 
    //assign user of opportunity else the value of assigned user field value should be saved -- Abinaya 16-Apr-12
    string userid = UserInfo.getProfileId();
    System.debug('33' + userid);
    List<Profile> UserProfileList =[Select u.Id,u.Name from Profile u where u.id =:userid limit 1];    
    System.debug('44' + UserProfileList);
    
    List<Requirement__c> req1 = [Select Assigned_User__c, Status__c from Requirement__c where Requirement__c.id= :oppa.Requirement__c limit 1 ];
    System.debug('req1============='+req1);
    for(Requirement__c req: req1)
    { 
        System.debug('req1============='+req1);
    //if the role is management representative then the assign to field value should be saved in 
    //assign user of opportunity else the value of assigned user field value should be saved -- Abinaya 16-Apr-12
    
      //string userid = UserInfo.getUserRoleId();
      //string userid = UserInfo.getProfileId();
      //System.debug('33' + userid);
      
      //List<UserRole> UserProfileList =[Select u.Name from UserRole u where u.id =:userid];    
      try
      {
      //List<Profile> UserProfileList =[Select u.Id,u.Name from Profile u where u.id =:userid limit 1];    
      //System.debug('44' + UserProfileList);
      string UserRoleName ; //= UserRoleList[0];
      //string reqdetail;
      
      for(Integer i = 0; i<UserProfileList.size(); i++)
      {
        UserRoleName = UserProfileList[0].Name;       
      }
       
      //string role = UserRoleList.Name;
      //System.debug('55' + role);
      if((UserRoleName == 'Management Representative') || (UserRoleName == 'MR Chatter Only User') || (UserRoleName == 'System Administrator') || (UserRoleName == 'Custom Standard User'))
      {
      
           System.debug('UserRoleName if============='+UserRoleName);
           System.debug('LR Id============='+oppa.Lead_Recruiter__c);
           System.debug('R Id============'+oppa.Recruiter__c);
           String LeadRecruiter=oppa.Lead_Recruiter__c;
        if(String.isNotBlank(LeadRecruiter))
        {       
            req.Assigned_User__c = oppa.Lead_Recruiter__c;
            System.debug('MR assigned to LR:' + req.Assigned_User__c);
        }
        else
        {
            req.Assigned_User__c = oppa.Recruiter__c;
            System.debug('MR assigned to Recruiter:' + req.Assigned_User__c);
        }
          
      }
      else
      {
         String Recruiter=oppa.Recruiter__c;
        if(String.isNotBlank(Recruiter))
        {   
            req.Assigned_User__c = oppa.Recruiter__c;
             System.debug('others assigned to LR:' + req.Assigned_User__c);
        }
        else
        {
            req.Assigned_User__c = oppa.Lead_Recruiter__c;
            System.debug('others assigned to R:' + req.Assigned_User__c);
        }
          System.debug('21:' +req.Assigned_User__c);
      }
      
      User UpdateLead = [Select Name from User where User.ID= :req.Assigned_User__c];
      System.debug('User22:'+UpdateLead );
      req.Assigned_User__c =UpdateLead.Name;  
      System.debug('111:' + req.Assigned_User__c);
      if(req.Assigned_User__c == UserInfo.getUserId())
      system.debug('userid:' + UserInfo.getUserId());
      oppa.AssignStatus__c = 'True';
      System.debug('11:' + oppa.AssignStatus__c);
      oppa.Requirement_Status__c = req.Status__c;
      upsert req;
      }
      catch(Exception e)
      {
        
      }
    }
    
}