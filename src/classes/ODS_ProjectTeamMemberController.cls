/**
* @author           Kalaiselvi R
* @version          1.0 
* @date             09-Dec-2016
* @Status           In Development
* @description      This is the controller for ODS_ProjectTeamMemberTrigger to avoid duplicate team 
                    member based on service and also to update names to existing timesheet record when
                    ProjectTeamMember name changes.
*/

public class ODS_ProjectTeamMemberController 
{ 
    /// <OBJECTIVE>
    /// validate Team Member name in project Team Member object to avoid duplication based on service.
    /// </OBJECTIVE>
    public void validateTeamMemberName(List<Project_Team_Member__c> teamMemberList)
    {
        try{
            set<Id> acntId = new set<Id>();
             
            for (Project_Team_Member__c objAcnt : teamMemberList)
            {
                 acntId.add(objAcnt.Account__C);
            }
            List<Project_Team_Member__c> prjctTeamMembrList = new List<Project_Team_Member__c>();
            prjctTeamMembrList = ODS_Data_Utility.fetchPrjctTeamMembrByAcntId(acntId);
            
            for (Project_Team_Member__c newTeamMembr : teamMemberList)
            {      
                for(Project_Team_Member__c oldTeamMembr: prjctTeamMembrList)
                {         
                    if(newTeamMembr.ODS_Services__c == oldTeamMembr.ODS_Services__c && newTeamMembr.Resource_Name__c == oldTeamMembr.Resource_Name__c )         
                    {              
                        newTeamMembr.Resource_Name__c.addError(oldTeamMembr.Resource_Name__c+ ' is already exist for this '
                                +oldTeamMembr.ODS_Services__r.name__c+' Service.');        
                    }     
                } 
            }
        }
        Catch(Exception e){
            system.debug('-- ODS_ProjectTeamMemberController - validateTeamMemberName: '+e);
        }
    }
    /// <OBJECTIVE>
    /// update TeamMember names to existing timesheet record when ProjectTeamMember name changes.
    /// </OBJECTIVE>
    public void updateTeamMemberName(List<Project_Team_Member__c> teamMemberList)
    {
        try{
            set<Id> teamMembrId = new set<Id>();
            for (Project_Team_Member__c newTeamMembr : teamMemberList)
            {
                teamMembrId.add(newTeamMembr.id);
            }
            List<Time_Sheet_Details__c> resourceNameLst = new List<Time_Sheet_Details__c>();
            resourceNameLst = ODS_Data_Utility.fetchResourceNameById(teamMembrId);
           
            List<Time_Sheet_Details__c> updateNameLst = new List<Time_Sheet_Details__c>();
            for (Project_Team_Member__c newTeamMembr : teamMemberList)
            {
                for(Time_Sheet_Details__c objTimeShtDt :resourceNameLst )
                {
                    Time_Sheet_Details__c updateName = new Time_Sheet_Details__c(id = objTimeShtDt.Id);
                    if(objTimeShtDt.Resource_Id__c == newTeamMembr.id)
                    {
                        updateName.Resource__c = newTeamMembr.Resource_Name__c;
                        updateNameLst.add(updateName);
                    }
                }
                ODS_Data_Utility.updateResourceName(updateNameLst);
            }
        }
        Catch(Exception e){
            system.debug('-- updateTeamMemberName - updateTeamMemberName: '+e);
        }
    }
}