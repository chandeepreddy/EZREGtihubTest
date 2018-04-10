/**
 * @author           Indhu
 * @version          1.0 
 * @date             07-Jan-2014
 * @Status           Developed
 * @description      This is the data utility class that includes DML operations for EZRE_SendMailDailyProdcutivity.
 *                   
 */
 
public class EZRE_DailyProductivity_DataUtility
{
    //This method returns the list of content version records
    public static List<ContentVersion> getContntVersList(string strCreatedName)
    {
        return [Select createdBy.name, 
                    title,
                    createddate 
                from 
                    ContentVersion 
                where  
                    createdby.name =: strCreatedName 
                AND 
                    createddate = TODAY];
    }
    
    //This method returns the list of candidate mapping records
    public static List<Candidate_Mapping__c> getCandMappngList()
    {
        return [select Candidate__r.last_name__c,
                    Candidate__r.name,
                    Requirement__r.name,        
                    Client_Name__c,
                    lastModifiedDate,
                    Status1__c,
                    Added_User__c,
                    requirement__r.Owner.name,
                    Candidate__r.Resume_Source__c 
                from 
                    Candidate_Mapping__c 
                where 
                    CreatedDate = TODAY];
    }
    
    //This method returns the list of requirement records.
    public static List<Requirement__c> getReqmtList(string strAssgndUsr)
    {
        return [select Name,
                    Assigned_User__c,
                    Req_Closed_Date__c,
                    Req_Closed_hrs__c,
                    First_Response__c,
                    Assign_Candidate_date__c,
                    cumulative_resumes_submitted__c,
                    Submitted_Resumes__c,
                    Opportunity_Code__c,
                    C_Name__r.Name,
                    Status__c,
                    createddate,
                    No_Of_Resumes__c 
                from 
                    Requirement__c
                where 
                    Status__c = 'open' 
                AND 
                    Assigned_User__c =: strAssgndUsr];
    }
    
    //Gets Org wide email id value
    public static Id getOrgWideEmailId()
    {
        return [Select Id, 
                    Address, 
                    DisplayName 
                from 
                    OrgWideEmailAddress 
                where 
                    DisplayName = 'EZRE'].id;
    }
}