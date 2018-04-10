/**
 * @author           Shahida K
 * @version          1.0 
 * @date             04/02/2015
 * @Status           Developed
 * @description      Data Utility is a class for fetching data from objects and for performing DML operations in objects.
 *
 */

global with sharing class EZRE_Requirement_DataUtility
{
    ///<OBJECTIVE>
    /// Fetch Candidates waiting for MR approval
    ///<OBJECTIVE>
    public static list<Candidate_Mapping__c> getCandsWatngForMRApprov()
    {
    
        return [select candidate__c,candidate__r.CreatedDate,Job_Title__c, id, Name, candidate__r.Candidate_Full_Name__c, Added_User__c, LR_Status__c, 
                MR_Status__c, Status1__c, Requirement__r.Ownerid, Requirement_Owner_Email__c ,Req_Owner_Email__c,
                Requirement__r.status__c from Candidate_Mapping__c where Status1__c = 'LR Approved' AND MR_Status__c =null  AND
                (Requirement__r.status__c='open' OR Requirement__r.status__c='Re-Open')];
        
    }
     ///<OBJECTIVE>
    ///Fetch the ContentVersion Record.
    ///<OBJECTIVE>
    public static ContentVersion  fetchCntVrsn( Id strContentId)
    {
       ContentVersion objContentVersion=new ContentVersion();      
        try
        {
          objContentVersion = [Select Id,Candidate_ID__c,LastModifiedDate from ContentVersion where Id =:strContentId];
          system.debug('@@@@@@@@objContentVersion'+objContentVersion);
        }
        catch(exception Ex)
        {
            system.debug('@@@@@@@@Exception'+Ex);
        }
      return objContentVersion;
    } 
     ///<OBJECTIVE>
    ///Fetch the candidate records
    ///<OBJECTIVE>
    public static list<Candidate__c> fetchCand(set<ID> setcandId)
    {
    
      return [select id,name,Mobile_Phone_No__c,Email__c From Candidate__c where ID IN:setcandId];
    } 
     ///<OBJECTIVE>
    ///Fetch the candidate records
    ///<OBJECTIVE>
    public static list<Candidate__c> fetchCandidate()
    {
    
      return [select id,name,Mobile_Phone_No__c,Email__c From Candidate__c order by Mobile_Phone_No__c,Email__c];
    }         
    /// <OBJECTIVE>
    /// Fetch the requirement data from the "Requirement".
    /// </OBJECTIVE>       
    public static List<Requirement__c> fetchReqData(Date statusUpdatedDt)
    {            
        return [SELECT id,
                    Ownerid,
                    owner.name,
                    Name, 
                    Status__c,
                    StatusUpdated_Date__c,
                    CreatedDate,
                    No_Of_Resumes__c,
                    ResumesSubmitted__c,
                    Opportunity_Code__c,
                    Owner.email,
                    createdby.email 
                FROM 
                    Requirement__c
                WHERE 
                    (Status__c = 'Open' 
                    OR  
                    Status__c = 'Re-Open') 
                    AND 
                    (StatusUpdated_Date__c<:statusUpdatedDt) ];
         
    }
    /// <OBJECTIVE>
    /// Fetch the requirement data from the "Requirement".
    /// </OBJECTIVE>       
    public static List<Requirement__c> fetchReqmntData()
    {    
       date statusUpdatedDt= system.today().addDays(-30);        
        return [SELECT id,
                    Ownerid,
                    owner.name,
                    Name, 
                    Status__c,
                    StatusUpdated_Date__c,
                    CreatedDate,
                    No_Of_Resumes__c,
                    ResumesSubmitted__c,
                    Opportunity_Code__c,
                    Owner.email,
                    createdby.email 
                FROM 
                    Requirement__c
                WHERE 
                    (Status__c = 'Open' 
                    OR  
                    Status__c = 'Re-Open') 
                   
                   ];
         
    }
    public static list<Account> fetchAccountBasedOnWebsite(set<string> AccIds)
    {
         return [Select id,
                        Name,
                        Website
                    FROM 
                         Account                      
                    WHERE
                         Website IN:AccIds];
    
    }
    
    ///<OBJECTIVE>
    ///Method to fetch Candidate mapping records related to set of Requirement ids
    ///</OBJECTIVE>
    public static list<Candidate_Mapping__c>  fetchAssignCandidates(DateTime fromDateTime,DateTime toDateTime,Set<Id> RqmntIdSet)
    {
             return [SELECT  Candidate_started__c,
                             Candidate__c,
                             Id,
                             Name,
                             requirement__r.Requirement_type__c,
                             Resumes_Status__c,
                             Requirement__c 
                         FROM 
                             Candidate_Mapping__c
                         where (CreatedDate>: fromDateTime and CreatedDate<: toDateTime) AND (requirement__c IN:RqmntIdSet)];
     
    }
    
    ///<OBJECTIVE>
    ///Method to fetch Accounts 
    ///</OBJECTIVE>  
    public static List<Account> fetchSFDCCampignAccounts(Set<string> userIdSet)
    {
              return [select  id,
                              name,
                              Force_com__c,
                              Datastax__C,
                              lastModifiedbyid,
                              Inside_SalesRep__c
                              //Inside_Sales_Rep__r.Name 
                       from 
                             Account 
                       where
                       force_com__c = True AND Inside_SalesRep__c IN:userIdSet];
    
    
    }
     
    ///<OBJECTIVE>
    ///Method to fetch Accounts 
    ///</OBJECTIVE>  
    public static List<Account> fetchDataStaxCampignAccounts(Set<string> userIdSet)
    {
            return[select id,
                            name,
                            Force_com__c,
                            Datastax__C,
                            lastModifiedbyid,
                            Inside_SalesRep__c
                    from 
                            Account 
                    where datastax__c = True AND Inside_SalesRep__c IN:userIdSet];
    }
    
     ///<OBJECTIVE>
    ///Method to fetch Accounts 
    ///</OBJECTIVE>  
    public static List<Account> fetchODSDotNetCampignAccounts(Set<string> userIdSet)
    {
            return[select id,
                            name,
                            Force_com__c,
                            Datastax__C,
                            ODSDotNet__c,
                            lastModifiedbyid,
                            Inside_SalesRep__c
                    from 
                            Account 
                    where ODSDotNet__c = True AND Inside_SalesRep__c IN:userIdSet];
    }
    ///<OBJECTIVE>
    ///Method to fetch SFDC Campaign contacts
    ///</OBJECTIVE>  
    public static List<Contact> fetchSFDCCampaignContacts(Set<Id> accIdSet)
    {
    return[Select id,
                  lastname,
                  Inside_Sales_Rep__c,
                  lastModifiedbyid,
                  Force_com__c,
                  Datastax__C,
                  ODSDotNet__c,
                  account.Inside_SalesRep__c,
                  status__c,
                  AccountId 
            from
                  Contact
            WHERE AccountId IN:accIdSet and Force_com__c=:true];       
    
    
    }
    ///<OBJECTIVE>
    ///Method to fetch Data Stax Campaign contacts
    ///</OBJECTIVE>  
    public static List<Contact> fetchDataStaxCampaignContacts(Set<Id> accIdSet)
    {
    return[Select id,
                  lastname,
                  Inside_Sales_Rep__c,
                  lastModifiedbyid,
                  Force_com__c,
                  Datastax__C,
                  ODSDotNet__c,
                  account.Inside_SalesRep__c,
                  status__c,
                  AccountId 
            from
                  Contact
            WHERE AccountId IN:accIdSet and Datastax__C=:true];       
    
    
    }
    ///<OBJECTIVE>
    ///Method to fetch ODS DotNet Campaign contacts
    ///</OBJECTIVE>  
    public static List<Contact> fetchODSDotNetCampaignContacts(Set<Id> accIdSet)
    {
    return[Select id,
                  lastname,
                  Inside_Sales_Rep__c,
                  lastModifiedbyid,
                  Force_com__c,
                  Datastax__C,
                  ODSDotNet__c,
                  account.Inside_SalesRep__c,
                  status__c,
                  AccountId 
            from
                  Contact
            WHERE AccountId IN:accIdSet and ODSDotNet__c=:true];       
    
    
    }
    
    
    ///<OBJECTIVE>
    ///Method to fetch tasks of contacts
    ///</OBJECTIVE>  
    public static List<Task> fetchContactTasks(DateTime dttimefromDate ,DateTime dttimeToDate,set<Id> userIdSet ,set<Id> contIdSet)
    {
        return [select id,
         whoid,
         subject,
         AccountId,
         createdby.name
    from Task 
    where  (CreatedDate >: dttimefromDate and CreatedDate <: dttimeToDate)  AND createdby.Id IN: userIdSet AND WhoId IN: contIdSet];
    
    } 
    
    public static List<Contact> fetchContactToCountAppointments(DateTime dttimefromDate ,DateTime dttimeToDate,String contactStatus)
    {
    
        return [select id,lastname,status__C,account.Inside_SalesRep__c  from contact where (Meeting_Set_Date__c >: dttimefromDate and Meeting_Set_Date__c <: dttimeToDate) AND status__C =: contactStatus];
    
    }
    ///<OBJECTIVE>
    //Method to fetch assign requirement of requirement
    ///</OBJECTIVE>
    public static list<RequirementAssignment__c> fetchAssgnReq(set<Id> reqIDSet,set<Id> candMapCrtdUserSet) 
    {
        return [select Id,
                    Requirement__c,
                    Recruiter__c,
                    Lead_Recruiter__c  
                From 
                    RequirementAssignment__c
                Where 
                    (Requirement__c IN:reqIDSet) and (Recruiter__c IN:candMapCrtdUserSet or Lead_Recruiter__c IN:candMapCrtdUserSet)];        
    }
///<OBJECTIVE>
//Method to fetch client interviewed assign candidates between given datetime
///</OBJECTIVE>
public static list<Candidate_Mapping__c> fetchClientinvwedAssgnCand(DateTime dtFromDateTime,DateTime dtToDateTime,set<Id> reqIdSet)
{
        
    return [SELECT requirement__r.Requirement_type__c,
                 Client_Interviewed_Date__c,
                 Client_Offered_Date__c,
                 Candidate_Started_Date__c,
                 Candidate_started__c,
                 Client_Interviewed__c,
                 Client_Offered__c,
                 Id,
                 Requirement__c 
            FROM 
                    Candidate_Mapping__c
            WHERE 
                    (requirement__c IN: reqIdSet) 
            AND
                    (Client_Interviewed_Date__c>: dtFromDateTime AND Client_Interviewed_Date__c<: dtToDateTime)];

}
///<OBJECTIVE>
//Method to fetch client Offered assign candidates between given datetime
///</OBJECTIVE>
public static list<Candidate_Mapping__c> fetchClntOfferedAssgnCands(DateTime dtFromDateTime,DateTime dtToDateTime,set<Id> reqIdSet)
{
    return [SELECT requirement__r.Requirement_type__c,
            Client_Interviewed_Date__c,
            Client_Offered_Date__c,
            Candidate_Started_Date__c,
            Candidate_started__c,
            Client_Interviewed__c,
            Client_Offered__c,
            Id,
            Requirement__c
    FROM 
            Candidate_Mapping__c 
    WHERE  
            (requirement__c IN: reqIdSet)
    AND 
            (Client_Offered_Date__c>: dtFromDateTime AND Client_Offered_Date__c<: dtToDateTime)];



}
///<OBJECTIVE>
//Method to fetch candidate Started assign candidates between given datetime
///</OBJECTIVE>
public static list<Candidate_Mapping__c> fetchCandStartdAssgnCands(DateTime dtFromDateTime,DateTime dtToDateTime,set<Id> reqIdSet)
{
return [SELECT requirement__r.Requirement_type__c,
                Client_Interviewed_Date__c,
                Client_Offered_Date__c,
                Candidate_Started_Date__c,
                Candidate_started__c,
                Client_Interviewed__c,
                Client_Offered__c,
                Id,
                Requirement__c 
        FROM 
                Candidate_Mapping__c 
        WHERE  
                (requirement__c IN: reqIdSet) 
        AND
                (Candidate_Started_Date__c>: dtFromDateTime AND Candidate_Started_Date__c<: dtToDateTime)];     

}
 ///<OBJECTIVE>
    ///Method to fetch contacts
    ///</OBJECTIVE>  
    public static List<Contact> fetchContacts(Set<Id> accIdSet)
    {
    return[Select id,
                  lastname,
                  Inside_Sales_Rep__c,
                  lastModifiedbyid,
                  Force_com__c,
                  Datastax__C,
                  account.Inside_SalesRep__c,
                  status__c,
                  AccountId 
            from
                  Contact
            WHERE AccountId IN:accIdSet];       
    
    
    }
    /// <OBJECTIVE>
    /// Fetch Account Related Campaign
    /// </OBJECTIVE>                                              
    public static LIST<Account_Related_Campaign__c> ftchAccntRltdCmpgn(set<Id> accIdSet)
    {
        return [select Id,
                       Account__c,
                       Campaign__c
                from 
                        Account_Related_Campaign__c
                where 
                        Account__c IN: accIdSet];
    }
    //<OBJECTIVE>
    //Method to fetch Work Allocation Records
    //</OBJECTIVE>
    public static List<Work_Allocation__c> fetchWorkAllocation(String repName,String campaign)
    {
        return  [select id,
                        name,
                        Campaign__c,
                        Comments__c,
                        worked__C,
                        email__c,
                        phone__c,
                        TimeZone__c,
                        account_name__C,
                        account_name__r.Name,
                        Activity_Created_Date__c,
                        Status__c,
                        Contact__c,
                        Contact__r.name,
                        CreatedDate,
                        Contact_Status__c,
                        Account_Status__c,
                        Contact_Title__c,
                        Reason_for_not_calling__c,
                        Assigned_Account_Status__c,
                        Assigned_Contact_Status__c
                        
            From
                        Work_Allocation__c 
            Where
                        Name =: repName
            AND
                        Campaign__c =: campaign
            AND        
                        worked__c=:false
                        
            AND
                        CreatedDate = Today
                      
            Order By    Activity_Created_Date__c];
    }
    
    //<OBJECTIVE>
    //Method to fetch Work Allocation Records with worked filter 
    //</OBJECTIVE>
    public static List<Work_Allocation__c> ftchWrkAllctnWthFlter(List<String> repNamesLst,String userCampaign,Boolean isWorked)
    {
        return  [select id,
                        name,
                        Campaign__c,
                        Comments__c,
                        worked__C,
                        email__c,
                        phone__c,
                        TimeZone__c,
                        account_name__C,
                        account_name__r.Name,
                        Activity_Created_Date__c,
                        Status__c,
                        Contact__c,
                        Contact__r.name
            From
                        Work_Allocation__c 
            Where
                        Name IN: repNamesLst 
            AND
                        Campaign__c =:userCampaign
            AND        
                        worked__c=:isWorked
                        
            Order By    Activity_Created_Date__c];
    }
    //<OBJECTIVE>
    //Method to fetch Users
    //</OBJECTIVE>
    Public static List<User> fetchUsers()
    {
        return[Select id,
                      Name,
                      IsActive
               from   User];
    }
    //------------Requirement Status Report-----------
     //<OBJECTIVE>
    //Method to fetch Requirements for requirement status report
    //</OBJECTIVE>
    Public static List<Requirement__c> fetchRequirementForStatusReport(Datetime ReqCreatedfromDate,DateTime ReqCreatedToDate,Date statusClosedFromDate,Date statusClosedToDate)
     {
        return [Select  Id,
                        Status__c,
                        Requirement_type__C,
                        Name,
                        LastModifiedDate,
                        createddate,
                        c_name__r.name,
                        Opportunity_Code__c,
                        Req_Closed_Date__c,
                        Submitted_Resumes__c,
                        ResumesSubmitted__c,
                        No_Of_Resumes__c
                FROM Requirement__c 
                where (createdDate >: ReqCreatedfromDate AND createdDate <: ReqCreatedToDate) 
                OR (StatusClosed_Date__c >: statusClosedFromDate AND StatusClosed_Date__c<: statusClosedToDate)
                OR (Status__c = 'Open' OR Status__c = 'Re-Open')];  
     }
    //<OBJECTIVE>
    //Method to fetch Assign Requirements for requirement status report
    //</OBJECTIVE>
     Public static List<RequirementAssignment__c> fetchAssignRequirements(Set<Id> reqIdSet)
     {
        return [select Requirement__c,
                    Recruiter__c,
                    lead_Recruiter__c,
                    lead_Recruiter__r.name,
                    Recruiter__r.name,
                    CreatedDate
            From RequirementAssignment__c 
            Where requirement__c IN: reqIdSet 
            order by createdDate]; 
     }
     //<OBJECTIVE>
    //Method to fetch Client interviewed candiates between given dates
    //</OBJECTIVE>
     Public static List<Candidate_Mapping__c> fetchClientInterviewedCandidtes(Set<Id> reqIdSet,Datetime ClntIntrvwdfromDate,Datetime ClntIntrvwdToDate)
    {
        return [SELECT requirement__r.Requirement_type__c,
                             Client_Interviewed_Date__c,
                             Client_Offered_Date__c,
                             Candidate_Started_Date__c,
                             Candidate_started__c,
                             Client_Interviewed__c,
                             Client_Offered__c,
                             Id,
                             Requirement__c 
                     FROM Candidate_Mapping__c 
                     Where (requirement__c IN: reqIdSet) 
                     And (Client_Interviewed_Date__c>: ClntIntrvwdfromDate and Client_Interviewed_Date__c<: ClntIntrvwdToDate)];
    }
    //<OBJECTIVE>
    //Method to fetch MR approved candidates between given dates
    //</OBJECTIVE>
    Public static List<Candidate_Mapping__c> fetchMRApprovedCanidates(Datetime dttimefromDate,Datetime dttimeToDate)
    {
        return [SELECT Candidate_started__c,
                 Candidate__c,
                 Id,
                 Name,
                 requirement__c,
                 MR_Status__c,
                 MR_Approved_Date__c
                 FROM Candidate_Mapping__c 
         Where (CreatedDate>: dttimefromDate and CreatedDate<: dttimeToDate)];
    }
    //<OBJECTIVE>
    //Method to fetch Client Offered Candidates
    //</OBJECTIVE>
    Public static List<Candidate_Mapping__c> fetchClientOfferedCandidates(Set<Id> reqIdSet,Datetime dttimefromDate,Datetime dttimeToDate)
    {
        return [SELECT requirement__r.Requirement_type__c,
                                            Client_Interviewed_Date__c,
                                            Client_Offered_Date__c,
                                            Candidate_Started_Date__c,
                                            Candidate_started__c,
                                            Client_Interviewed__c,
                                            Client_Offered__c,
                                            Id,
                                            Requirement__c 
                                    FROM Candidate_Mapping__c 
                                    where (requirement__c IN: reqIdSet) 
                                    and (Client_Offered_Date__c>: dttimefromDate and Client_Offered_Date__c<: dttimeToDate)];
    }
     //<OBJECTIVE>
    //Method to fetch Started Candidates
    //</OBJECTIVE>
    Public static List<Candidate_Mapping__c> fetchCandidatesStarted(Set<Id> reqIdSet,Datetime dttimefromDate,Datetime dttimeToDate)
    {
        return [SELECT requirement__r.Requirement_type__c,
                        Client_Interviewed_Date__c,
                        Client_Offered_Date__c,
                        Candidate_Started_Date__c,
                        Candidate_started__c,
                        Client_Interviewed__c,
                        Client_Offered__c,
                        Id,
                        Requirement__c 
                FROM Candidate_Mapping__c 
                where (requirement__c IN: reqIdSet) 
                and (Candidate_Started_Date__c>: dttimefromDate and Candidate_Started_Date__c<: dttimeToDate)];     
    }
    ///<OBJECTIVE>
    ///Method to fetch assign requiremnts that are assigned to LR/R
    ///</OBJECTIVE>
    Public static List<RequirementAssignment__c> getAssignRequirements(Set<Id> requirementIdSet)
    {
            return [select id,
                           requirement__c,
                           Lead_Recruiter__c,
                           Recruiter__c  
                from 
                    RequirementAssignment__c 
                where requirement__c IN:requirementIdSet];
    }
    
    //----------------lightning files upload for candidate resumes
     ///<OBJECTIVE>
    ///Method to fetch Resume count that are Attached through Files
    ///</OBJECTIVE>
    Public static  List<AggregateResult> getResumeAttachedThroughFiles(String candidateId)
    {
          return [SELECT count(LinkedEntityId) fileUploadResume FROM ContentDocumentLink Where LinkedEntityId =:candidateId];    
    }
    
    
    public static List<List<SObject>> getCandidatelist(String inputValue)
    {
    
       return [FIND :inputValue IN ALL FIELDS RETURNING Candidate__c(Id)];
    
    }
    
    public static List<Candidate__c> getCandidatequery(List<SObject> inputlst)
    {
    
       return [select id from Candidate__c where id in: inputlst];
    
    }
    
    public static List<List<SObject>> getContentDocument(String inputValue)
    {
    
       return [FIND :inputValue IN ALL FIELDS RETURNING ContentDocument(Id)];
    
    }
    
     public static List<ContentDocument> getContentDocumentquery(List<SObject> inputlst)
    {
    
       return [select id from ContentDocument where id in:inputlst];
    
    }
    
    public static List<ContentDocumentLink> getContentDocumentlinkquery(List<Id> inputlst)
    {
    
       return [SELECT ContentDocumentId, LinkedEntityId,ContentDocument.Title FROM ContentDocumentLink WHERE ContentDocumentId IN:inputlst];
    
    }
    
    public static List<ContentDocumentLink> getContentDocumentlinkFromCandidate(List<Id> inputlst)
    {
    
       return [SELECT ContentDocumentId, LinkedEntityId,ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN:inputlst];
    
    }
    //<OBJECTIVE>
    //Method to fetch Work Allocation Records
    //</OBJECTIVE>
    public static List<Work_Allocation__c> fetchWorkAllocation(List<String> repNamesLst,String userCampaign)
    {
        return  [select id,
                        name,
                        Campaign__c,
                        Comments__c,
                        worked__C,
                        email__c,
                        phone__c,
                        TimeZone__c,
                        account_name__C,
                        account_name__r.Name,
                        Activity_Created_Date__c,
                        Status__c,
                        Contact__c,
                        Contact__r.name,
                        Reason_for_not_calling__c   
                        
            From
                        Work_Allocation__c 
            Where
                        Name IN: repNamesLst 
            AND
                        Campaign__c =:userCampaign
            AND        
                        worked__c=:false
                        
            Order By    Activity_Created_Date__c];
    }
    
    //<OBJECTIVE>
    //Method to fetch list of task based on ids
    //</OBJECTIVE>
    public static List<Task> fetchTaskById(set<id> taskIds, String subject)
    {
        return [SELECT 
                    Id, 
                    Description, 
                    Subject 
                FROM 
                    Task 
                WHERE 
                    Id IN: taskIds 
                AND 
                    Subject =: subject];
    }
}