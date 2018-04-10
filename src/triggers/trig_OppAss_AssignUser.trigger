trigger trig_OppAss_AssignUser on OpportunityUserAssociation__c (before insert,before update) 
{
OpportunityUserAssociation__c oppa = trigger.new[0];
System.debug('a:'+oppa );
//List<Opportunity> Opp = new List<Opportunity>();
//Opp = [Select AssignUser__c from Opportunity where Opportunity.ID = :oppa.Opportunity__c];


    for(Opportunity opp: [Select AssignUser__c from Opportunity where Opportunity.id= :oppa.Opportunity__c])
    { 
    
    //if the role is management representative then the assign to field value should be saved in 
    //assign user of opportunity else the value of assigned user field value should be saved -- Abinaya 16-Apr-12
    
      string userid = UserInfo.getUserRoleId();
      System.debug('33' + userid);
      List<UserRole> UserRoleList =[Select u.Name from UserRole u where u.id =:userid];    
      System.debug('44' + UserRoleList);
      string UserRoleName ; //= UserRoleList[0];
      
      for(Integer i = 0; i<UserRoleList.size(); i++)
      {
        UserRoleName = UserRoleList[0].Name;       
      }
      
      //string role = UserRoleList.Name;
      //System.debug('55' + role);
      if(UserRoleName == 'Management Representative')
      {
          opp.AssignUser__c = oppa.AssignedUser__c;
          System.debug('11' + opp.AssignUser__c);
      }
      else 
      {
          opp.AssignUser__c = oppa.Assigned_User__c;
          if ( opp.AssignUser__c==null)
          {
          	opp.AssignUser__c=oppa.AssignedUser__c;
          }          
          System.debug('21:' +opp.AssignUser__c);
      }
      
      User UpdateLead = [Select Name from User where User.ID= :opp.AssignUser__c];
      System.debug('User22:'+UpdateLead );
      opp.AssignUser__c =UpdateLead.Name;  
      if(opp.AssignUser__c == UserInfo.getUserId())
       oppa.AssignStatus__c = 'True';
      upsert opp;
    }

}