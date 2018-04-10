/**
 * @author           Indumathi
 * @version          1.0 
 * @date             18/11/2015
 * @Status           Developed
 * @description      Data Utility is a class for fetching data from objects and for performing DML operations in objects.
 *
 */

global with sharing class EZRE_OppActReport_DataUtility
{

    ///<OBJECTIVE>
    /// Fetch the list of open tasks associated with opportunity.
    ///<OBJECTIVE>
    public static List<Task> getOpenTaskList()
    {
        return [Select Id, ActivityDate, WhatId, Status from Task where What.Type = 'Opportunity' and ActivityDate >= Today and Status != 'Completed'];
    }   
    
    ///<OBJECTIVE>
    /// Fetch the list of open events associated with opportunity.
    ///<OBJECTIVE>
    public static List<Event> getOpenEventsList()
    {
        return [Select Id, ActivityDate, WhatId from Event where What.Type = 'Opportunity' and ActivityDate >= Today];
    }
    
    
    
    ///<OBJECTIVE>
    /// Fetch the list of all opportunities with StageName and Account Owner Name as filter.
    ///<OBJECTIVE>
   public static List<Opportunity> getAllOppList(String strStgeNme, String strAccntOwner)
    {        
        String strQuery = 'Select Id, Name, Follow_up_Date__c, StageName, AccountId, Account.Owner.Name FROM Opportunity where StageName IN '+strStgeNme+' AND (NOT Account.Owner.Name like \''+strAccntOwner +'%\')';
        System.debug('strquery---------------'+strQuery);
        List<Opportunity> lstOpp = new List<Opportunity>();
        lstOpp  = Database.Query(strQuery);
        return lstOpp;
    } 
    
    ///<OBJECTIVE>
    /// Fetch the list of all opportunities which do not have any open activities.
    ///<OBJECTIVE>
    public static List<Opportunity> getAllOppWthoutActvs(Set<Id> setOppIds)
    {
        return [SELECT Id,Name,Follow_up_Date__c,OwnerId,StageName,AccountId, Account.Owner.Name, Account.Name FROM Opportunity where Id IN: setOppIds ORDER BY OwnerId DESC];
    } 
    
    
    
    ///<OBJECTIVE>
    /// Fetch the list of tasks for the given set of opportunity.
    ///<OBJECTIVE>
    public static List<Task> getTasksList(Set<Id> setOppIds)
    {
        return [Select Id, ActivityDate, WhatId, Owner.Id, Owner.Name from Task where WhatId IN: setOppIds Limit 1];
    }
    
    ///<OBJECTIVE>
    /// Fetch the list of events for the given set of opportunity.
    ///<OBJECTIVE>
    public static List<Event> getEventList(Set<Id> setOppIds)
    {
        return [Select Id, ActivityDate, WhatId, Owner.Id, Owner.Name from Event where WhatId IN: setOppIds Limit 1];
    }
    
    ///<OBJECTIVE>
    /// Fetch the list of opportunity owner names and each owner count
    ///<OBJECTIVE>
    
    public static List<AggregateResult> getOpportunityOwnerCountList(set<Id> setClosedOpportunityIds)
    {   
      return  [SELECT Count(Id),Owner.Name FROM Opportunity where Id IN: setClosedOpportunityIds Group By Owner.Name];  
    }
    
     ///<OBJECTIVE>
    /// Fetch the list of opportunity owner names and each owner count
    ///<OBJECTIVE>
    public static List<User> getOpportunityOwnerInfo()
    {
       return [select profile.name,Email,Name from User];
    
    }
    
    ///<OBJECTIVE>
    ///Fetch the list of OrganizationWideEmailAddress 
    ///<OBJECTIVE>
    public static OrgWideEmailAddress getOrgWideEmailAddress()
    {
        return [select Id from OrgWideEmailAddress where Address = 'ezre@preludesys.com' limit 1];
    }
    ///<OBJECTIVE>
    ///Fetch the list of OrganizationWideEmailAddress 
    ///<OBJECTIVE>
    public static OrgWideEmailAddress getOrgWideAddress()
    {
        return [select Id from OrgWideEmailAddress where Address ='ist@preludesys.com' limit 1];
    }

}