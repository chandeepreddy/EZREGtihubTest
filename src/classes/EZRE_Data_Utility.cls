/**
 * @author           Keerthi Chandra/Edited Production Org
 * @version          1.0 
 * @date             7/8/2014
 * @Status           Developed
 * @description      Data Utility is a class for fetching data from objects and for performing DML operations in objects.
 * @Modified by      Shahida K
 * @Modified Date    23/Feb/2017
 * @description      We have removed unused Type__c field and replaced that field with Requirement_Type__c field.
 */

global with sharing class EZRE_Data_Utility
{
    /// <OBJECTIVE>
    /// Fetch the requirement data from requirement custom object where the id equals to the stReqmtId 
    /// </OBJECTIVE>    
    
    public static Requirement__c fetchReq(string strReqmtId)
    {
        return [SELECT Id,
                       Name,
                       Easy1__c,Job_Category__c,status__c
                       FROM Requirement__c
                       WHERE Id =: strReqmtId];   
    }   
    
    /// <OBJECTIVE>
    /// Fetch the the eligible candidates list from the "Candidate" custom object where id in the lstRefAccs.
    /// </OBJECTIVE>    
    
    public static List<Candidate__c> fetchLstElgblCan(List<Id> lstRefAccs)
    {
        return [SELECT Name,
                       Last_Name__c,
                       Email__c,
                       Category__c,
                       Do_Not_Recruit__c,
                       Email_Status__c
                       FROM Candidate__c
                       WHERE Id in :lstRefAccs];   
    }   
    
    /// <OBJECTIVE>
    /// Fetch the requirement data from the "Requirement" custom object where id equals to strReqId.
    /// </OBJECTIVE>    
    
    public static Requirement__c fetchReqData(Id strReqID)
    {
        return [SELECT Name,
                       Skill_Set__c,
                       Location__c,
                       Position_Type__c,
                       Easy1__c,
                       Job_Category__c,
                       status__c,
                       Requirement_Type__c,
                       Duration__c,
                       Interview_Type__c,
                       City__c ,
                       State__c,
                       Preference__c
                       FROM Requirement__c
                       WHERE Id =: strReqID LIMIT 1];   
    }
    
    /// <OBJECTIVE>
    /// Fetch the Assign Requiremnetdata from the "Assign Requirement" custom object where id equals to strReqId.
    /// </OBJECTIVE>    
    
    public static RequirementAssignment__c fetchReqAssgData(Id strReqID)
    {
        return [SELECT Requirement__c,
                       Recruiter__r.Name,
                       Recruiter__r.Email,
                       Recruiter__r.phone,
                       Requirement__r.Name,
                       Lead_Recruiter__r.Name,
                       Lead_Recruiter__r.Email,
                       Lead_Recruiter__r.Phone
                       FROM RequirementAssignment__c
                       WHERE Requirement__c =: strReqID 
                       ORDER BY CreatedDate DESC LIMIT 1];   
    }
    
    /// <OBJECTIVE>
    /// Fetch the eligible candidates list based on the candidate resumes by using SOSL find query.
    /// </OBJECTIVE> 
    public static List<List<SObject>> fetchSearchList(string strReqmtName)
    {
        /*String searchquery='FIND {\"' +strReqmtName + '\"} IN ALL FIELDS RETURNING ContentVersion(Candidate_ID__c)';
        system.debug('###SOSL:'+searchquery);
        
        List<List<SObject>> searchList = System.Search.query(searchquery);
        system.debug('Size' +searchList.size());
        return searchList;*/
        return [FIND :strReqmtName IN ALL FIELDS RETURNING ContentVersion(Candidate_ID__c)];
    }
    
    /// <OBJECTIVE>
    /// To insert contact for each candidate
    /// </OBJECTIVE> 
    public static contact insertContact(string strAccId, string strEmail, string strLstName)
    {
        Contact objCntct = new Contact();
        objCntct.AccountId = strAccId;
        objCntct.Email= strEmail;
        objCntct.LastName = strLstName;
        //insert objCntct ;
        return objCntct ;
    }
    
    /// <OBJECTIVE>
    /// To fetch custom setting details for Mailchimp account
    /// </OBJECTIVE> 
  public static Mailchimp_Details__c getMCDtls(String accName)
    {
        return(Mailchimp_Details__c.getValues(accName));
    }
    
    /// <OBJECTIVE>
    /// Fetch the Candidate Mapping records for the given Requirement and Candidate.
    /// </OBJECTIVE>    
    
    public static List<Candidate_Mapping__c> fetchCndtMppngLst(Id strReqID, Id strCndtId)
    {
        return [SELECT Candidate__c,
                        Id,
                        Name,
                        Requirement__c,
                        Requirement__r.status__c 
                    FROM Candidate_Mapping__c                       
                       WHERE Candidate__c =: strCndtId 
                       AND
                       Requirement__c =: strReqID];   
    }
    
   /* /// <OBJECTIVE>
    /// Create and Return MCCandidateList Record
    /// </OBJECTIVE>    
    
    public static MCCandidateList__c CrtMCCndtLst(String strCmpgnId, String strCndtEml)
    {
        MCCandidateList__c obj = new MCCandidateList__c();
        obj.Campaign_Id__c = strCmpgnId;       
        obj.Candidate_Email__c = strCndtEml;
        insert obj;
        return obj;     
    }
    
    /// <OBJECTIVE>
    /// Fetch the list of  MCCandidateList Record for the given Campagin Id and Email address
    /// </OBJECTIVE>    
    
    public static List<MCCandidateList__c> lstMCCndtLst(String strCmpgnId, Set<String> strCndtEml)
    {
        return [SELECT Id, Name, 
                Campaign_Id__c,      
                Candidate_Email__c,
                Campaign_Name__c,
                From_Email__c,
                IsNew__c 
                FROM MCCandidateList__c
                WHERE
                Campaign_Id__c  =: strCmpgnId
                AND
                Candidate_Email__c IN: strCndtEml ];         
    }
    
     /// <OBJECTIVE>
    /// Fetch the list of  MCCandidateList Record whihc has been inserted newly
    /// </OBJECTIVE>    
    
    public static List<MCCandidateList__c> lstNewMCCndtLst()
    {
        return [SELECT Id, Name, 
                Campaign_Id__c,
                Campaign_Name__c,
                From_Email__c,      
                Candidate_Email__c,
                IsNew__c 
                FROM MCCandidateList__c
                WHERE
                IsNew__c =: true
               ];         
    }
    
    /// <OBJECTIVE>
    /// Fetch the Candidate email list for particular campaign
    /// </OBJECTIVE>    
    
    public static List<MCCandidateList__c> lstNewCndtLst(String strCmpgnID)
    {
        return [SELECT Id, Name, 
                Campaign_Id__c,      
                Candidate_Email__c,
                Campaign_Name__c,
                IsNew__c,
                From_Email__c 
                FROM MCCandidateList__c
                WHERE
                IsNew__c =: true
                AND
                Campaign_Id__c =: strCmpgnID];         
    }
    /// <OBJECTIVE>
    /// To upsert McCandidate records.
    /// </OBJECTIVE>  
    public static List<MCCandidateList__c> upsrtMcCandRecs(List<MCCandidateList__c> upsrtMcCan)
    {
        Upsert upsrtMcCan;
        return upsrtMcCan;
    }  
    
    ///<OBJECTIVE>
    ///Fetch the McCandidateList records.
    ///<OBJECTIVE>
    public static List<MCCandidateList__c> fetchMcCanRecs(set<String> mapCmpgnIdSet)
    {
        return [Select Id, Campaign_Id__c,Campaign_Name__c, From_Email__c,Candidate_Email__c, MC_List_Type__c, IsNew__c from MCCandidateList__c 
                       where (Campaign_Id__c IN : mapCmpgnIdSet) AND (MC_IsNew__c = True) AND (MC_List_Type__c = 'Marketing') AND (NOT(Campaign_Name__c like 'Need %'))];
    }
     ///<OBJECTIVE>
    ///To update the McCandidateList records.
    ///<OBJECTIVE>
    public static List<MCCandidateList__c> McCanRecUpdt(List<MCCandidateList__c> lstUpdt)
    {
        Update lstUpdt;
        return lstUpdt;
    }
      ///<OBJECTIVE>
    ///Fetch the MCContactList records.
    ///<OBJECTIVE>
    public static List<MCCandidateList__c> fetchMcCanRecords(String strCmpgnId,set<String> strEmail)
    {
        return [Select Id, Campaign_Id__c, Candidate_Email__c, IsNew__c from MCCandidateList__c
                                    where (Campaign_Id__c = : strCmpgnId) AND (Candidate_Email__c IN : strEmail)];
    }
     ///<OBJECTIVE>
    ///Fetch the MCContactList records.
    ///<OBJECTIVE>
    public static List<MC_Marketing__c> fetchMcConRecs(String strCmpgnId,set<String> strEmail)
    {
        return [Select Id, CampaignId__c, 
                          Contact_Email__c, 
                          MC_Marketing_IsNew__c
                    FROM  MC_Marketing__c

                    WHERE (CampaignId__c = : strCmpgnId) 
                    AND   (Contact_Email__c IN : strEmail)
                    AND   (NOT(CampaignName__c like 'Need %'))];
                        
    }

    /// <OBJECTIVE>
    /// To upsert McCandidate records.
    /// </OBJECTIVE>  
    public static List<MC_Marketing__c> upsrtMcConRecs(List<MC_Marketing__c> upsrtMcCon)
    {
        Upsert upsrtMcCon;
        return upsrtMcCon;
    } 
    
     ///<OBJECTIVE>
    ///Fetch the McCandidateList records.
    ///<OBJECTIVE>
    public static List<MC_Marketing__c> fetchMcContctRecs(set<String> mapCmpgnIdSet)
    {
        return [Select Id, 
                        CampaignId__c,
                        CampaignName__c, 
                        MC_From_Email__c,
                        Contact_Email__c, 
                        MC_Marketing_IsNew__c
                   from MC_Marketing__c
                   where (CampaignId__c IN : mapCmpgnIdSet) 
                            AND 
                        (MC_Marketing_IsNew__c= True)  
                            AND 
                        (NOT(CampaignName__c like 'Need %'))];
    } 
    
     ///<OBJECTIVE>
    ///To update the MC Marketing records.
    ///<OBJECTIVE>
    public static List<MC_Marketing__c> McConRecUpdt(List<MC_Marketing__c> lstUpdt)
    {
        Update lstUpdt;
        return lstUpdt;
    }
    */
    /// <OBJECTIVE>
    /// Fetch the requirement record.
    /// </OBJECTIVE>    
    
    public static Requirement__c reqRec(String strReqId)
    {
        return [SELECT Name,
        Requirement_Type__c,Duration__c,
        Position_Type__c,
        Location__c,
        Preference__c,
        Interview_Type__c,
        Min_Cost__c,
        Skill_Set__c,
        State__c,
        Job_Category__c,
        City__c, 
        Non_H1B_Preffered__c 
        FROM Requirement__c WHERE Id=: strReqId];         
    }
    
    
    ///<OBJECTIVE>
    ///Fetch the contact records.
    ///<OBJECTIVE>
    public static List<Contact> fetchConRecs(List<String> lstCanEmls)
    {
        return [Select id,Name,FirstName,LastName,Owner.Email,Owner.Name,Email from Contact where Email IN : lstCanEmls];
    }
    
    ///<OBJECTIVE>
    ///fetch candidate records.
    ///<OBJECTIVE>
    public static List<Candidate__c> fetchLstcan(set<String> setStrEmail)
    {
        return [select id,Name,Email__c,email_status__c from candidate__c where Email__c IN: setStrEmail];
    }
    
  
   ///<OBJECTIVE>
    ///Fetch the Contact records.
    ///<OBJECTIVE>
    public static List<Contact> fetchConRecords(set<String> setAllEmlAddrss)
    {
        return [SELECT id, FirstName,LastName,Phone,Email,Title FROM Contact WHERE Email IN: setAllEmlAddrss and Send_Email_Test__c=:false];
    } 
    
      ///<OBJECTIVE>
    /// Fetch the Cron trigger Details.
    ///<OBJECTIVE>
    public static CronTrigger getCronTriggewrDetails(string JobId)
    {
        return  [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :JobId];
    }
    
    //------------------EZRE_Account Report---------------------//
    
    ///<OBJECTIVE>
    ///Fetch the Oportunity list.
    ///<OBJECTIVE>
    public static List<Opportunity> fetchOppList(Id accntId)
    {
        return [Select Id, Name,StageName,Status__c ,Amount from Opportunity where AccountId = :accntId AND isClosed != true];
    } 
    
    
    ///<OBJECTIVE>
    ///Fetch the Event List.
    ///<OBJECTIVE>
    public static List<Event> fetchEventList(Id accntId)
    {
        DateTime strDt = DateTime.Now();
        DateTime endDt = DateTime.Now().addDays(-30);        
         
        return [SELECT AccountId,OwnerId,Owner.Name, ActivityDate,ActivityDateTime,Id,StartDateTime,lastModifieddate,Subject,WhatId,Who.Name FROM Event where AccountId = :accntId  AND ( ActivityDateTime <= : strDt AND ActivityDateTime >=: endDt ) ORDER BY ActivityDateTime DESC];
    }
    
    
    ///<OBJECTIVE>
    ///Fetch the Task List.
    ///<OBJECTIVE>
    public static List<Task> fetchTaskList(Id accntId)
    {
        return [SELECT AccountId,Owner.Name,CallType,Id,WhoId,OwnerId,Priority,Status,ActivityDate, Subject,WhatId,Who.Name FROM Task WHERE AccountId = :accntId AND Status='Completed' AND ActivityDate>= LAST_N_DAYS:30 ORDER BY ActivityDate DESC];
    }
    
    ///<OBJECTIVE>
    /// Fetch the list of all opportunities with StageName and Account Owner Name as filter.
    ///<OBJECTIVE>
   public static List<Opportunity> getOppList(String accntId,String stgeNmeString, String accntOwnerString)
    {        
        String strQuery = 'Select Id,Amount, Name,Execution_Partner__c, Follow_up_Date__c, StageName, AccountId, Account.Owner.Name FROM Opportunity where AccountId = \''+accntId+'\' AND StageName IN '+stgeNmeString+' AND (NOT Account.Owner.Name like \''+accntOwnerString +'%\')';        
        List<Opportunity> lstOpp = new List<Opportunity>();
        lstOpp  = Database.Query(strQuery);
        return lstOpp;
    } 
    
    ///<OBJECTIVE>
    ///Fetch the Contact list for the given account.
    ///<OBJECTIVE>
    public static List<Contact> fetchCntctList(Id accntId)
    {
        return [Select Id, Name, Title,Reportsto.Id, FirstName, LastName, AccountId from Contact where AccountId =: accntId];
    } 
    
    ///<OBJECTIVE>
    ///Fetch the Initiative list for the given account.
    ///<OBJECTIVE>
    public static List<Initiative__c> fetchIntitveList(Id accntId)
    {
        return [Select Id,Account__c from Initiative__c where Account__c =: accntId];
    } 
    ///<OBJECTIVE>
    ///Fetch the UserRole.
    ///<OBJECTIVE>
    public static UserRole fetchUserRole()
    {
        return [select id,name from UserRole Where Name = 'ISR-India'];
    } 
    
    ///<OBJECTIVE>
    ///Fetch the Initiative list for the given account.
    ///<OBJECTIVE>
    public static List<User> fetchUsersList(Id RoleId)
    {
        return [select id,name,UserRoleId,userrole.name from user where UserRoleId =:RoleId AND isActive=true];
    } 
    
    //-------------------------Inside Sales Team Work Allocation----------------------//
    ///<OBJECTIVE>
    ///Fetch the Work Allocation list .
    ///<OBJECTIVE>
    public static List<Work_Allocation__c>  fetchWorkAllocationList()
    {
        return [select id,name,worked__c,Comments__c from Work_Allocation__c];
    } 
    ///<OBJECTIVE>
    ///Insert the List of Work Allocation Records .
    ///<OBJECTIVE>
    public static void   insertWorkAllocationList(List<Work_Allocation__c> workAllocationList)
    {
        insert workAllocationList;
        system.debug('@@@@ Inserted values: '+workAllocationList);
    }

   ///<OBJECTIVE>
    ///Insert the List of Work Allocation Records .
    ///<OBJECTIVE>
    public static void   deleteWorkAllocationList(List<Work_Allocation__c> deleteWorkAllocationList)
    {
         List<Work_Allocation__c> objworkAllocationdelete = new List<Work_Allocation__c>();
             for(Work_Allocation__c workDeletion : deleteWorkAllocationList)
             {   
                Work_Allocation__c objwork = new Work_Allocation__c(id =workDeletion.Id); 
                objworkAllocationdelete.add(objwork);
             }
             if(objworkAllocationdelete.size()>0){
                 delete objworkAllocationdelete;
             }
    }
     ///<OBJECTIVE>
    ///Fetch the Work Allocation list order by time Zone .
    ///<OBJECTIVE>
    public static List<Work_Allocation__c>  fetchWrkAllctnLstOrderbyTimezone(List<string> RepNamesList)
    {
        return [select id,name,worked__C,email__c,phone__c,TimeZone__c,
                account_name__C,account_name__r.Name,Activity_Created_Date__c,Status__c,Contact__c,Contact__r.name from Work_Allocation__c where Name IN: RepNamesList Order By Activity_Created_Date__c];
    } 
    
     ///<OBJECTIVE>
    ///Fetch the Work Allocation list order by time Zone .
    ///<OBJECTIVE>
    public static List<Contact>  fetchContacts(set<Id> activityIdSet)
    {
        return [select id,name,Activity_Created__c,accountId from contact where Id IN: activityIdSet];
    } 
     ///<OBJECTIVE>
    ///Fetch the Work Allocation list .
    ///<OBJECTIVE>
    public static List<Work_Allocation__c>  fetchWorkAllctnCaledList(set<Id> cntIdSet,DateTime startDtTime,DateTime endDtTime)
    {
        return  [select id,name,worked__c,contact__c,account_Name__c,CreatedDate from Work_Allocation__c where Contact__c IN: cntIdSet AND CreatedDate = Today];
    } 
    ///<OBJECTIVE>
    ///Update the List of Work Allocation Records .
    ///<OBJECTIVE>
    public static void   updateWorkAllocationList(List<Work_Allocation__c> workAllocationList)
    {
        update workAllocationList;
    }
    ///<OBJECTIVE>
    ///Update the List of contact Records .
    ///<OBJECTIVE>
    public static void   updateContactsList(List<contact> contactList)
    {
        update contactList;
    }
     ///<OBJECTIVE>
    ///Update the List of account Records .
    ///<OBJECTIVE>
    public static void   updateAccountsList(List<Account> accList)
    {
        List<Account> lstAccount = new List<Account>();
        update accList;
    }

    ///<OBJECTIVE>
    ///Fetch the Work Allocation list order by time Zone .
    ///<OBJECTIVE>
    public static List<Account>  fetchAccounts(set<Id> activityIdSet)
    {
        return [select id,name,Activity_Created_Date__c from account where Id IN: activityIdSet];
    }
    ///<OBJECTIVE>
    ///Fetch the User Details.
    ///<OBJECTIVE>
    public static User fetchUser(Id usrId)
    {
        return [select id,name,UserRoleId,userrole.name,Campaign__C from user where Id =:usrId AND isActive=true];
    }  
    ///<OBJECTIVE>
    ///Fetch the Task records.
    ///<OBJECTIVE>
    public static List<Task> fetchTaskRcrds(set<Id> setContId)
    {
        return [SELECT id, Campaign_Id__c, whoId, subject,Priority,description,ActivityDate FROM Task 
                WHERE whoId IN: setContId];
    } 
    
    ///<OBJECTIVE>
    ///Fetch contacts Id's
    ///</OBJECTIVE>
    public static List<Contact> fetchContRec(Set<String> cntEmail)
    {
        return [SELECT Id from Contact WHERE Email IN: cntEmail];
    }
    ///<OBJECTIVE>
    ///Fetch Task Records
    ///</OBJECTIVE>
    public static List<Task> fetchTaskRecs(Contact lstContct)
    {
        return [SELECT id from Task WHERE subject = 'Send Email' AND status = 'Completed' AND WhoId =: lstContct.Id];
    }
    
    /// <OBJECTIVE>
    /// Fetch the Assign Requiremnetdata from the "Assign Requirement" custom object where id equals to strReqId.
    /// </OBJECTIVE>    
    
    public static List<RequirementAssignment__c> fetchAllReqAssgData(Id strReqID)
    {
        return [SELECT Requirement__c,
                       Recruiter__r.Name,
                       Recruiter__r.Email,
                       Recruiter__r.phone,
                       Requirement__r.Name,
                       Lead_Recruiter__r.Name,
                       Lead_Recruiter__r.Email,
                       Lead_Recruiter__r.Phone
                       FROM RequirementAssignment__c
                       WHERE Requirement__c =: strReqID 
                       ];   
    }
    
    
     ///<OBJECTIVE>
    ///Fetch Opportunity Record.
    ///<OBJECTIVE>
    public static Opportunity fetchOpp( Id CurrentId)
    {
        return [select id, 
                     StageName, 
                     forecastcategory
                      from Opportunity 
                        where id= :CurrentId]; 
    }
    
    ///<OBJECTIVE>
    /// Fetch Sales Coach Stage Record.
    ///<OBJECTIVE>
    public static Sales_Coach_Stage__c fetchSalesCoach(string strName)
    {
        return [select  
                         Name, 
                         Id, 
                         Buyer_Stage__c, 
                         Active__c 
                                  from Sales_Coach_Stage__c
                                  where Name = : strName Limit 1];
    }
    ///<OBJECTIVE>
    /// Fetch list of Sales Coach section  Records.
    ///<OBJECTIVE>
    public static List<Sales_Coach_Section__c> fetchlstSalesCoach(Id salesCoachId)
    {
        return [select Section_Ordering__c, 
                                 Section_Name__c, 
                                 Sales_Coach_Stage__c, 
                                 Name, 
                                 Id,
                                 Sales_Coach_Section__c.Sales_Coach_Stage__r.Name, 
                                 Section_Width__c,
                                 (select Section_Ordering__c, 
                                     Sales_Coach_Section__c, 
                                     Name, 
                                     Link_to_Content__c, 
                                     Item_Name__c, 
                                     Id, 
                                     Display__c, 
                                     Products__c 
                                              from Sales_Coach_Section_Items__r
                                              order by Section_Ordering__c)  
                                                  from Sales_Coach_Section__c
                                                  where Sales_Coach_Stage__c = :SalesCoachId
                                                  order by Section_Ordering__c];
    }
    ///<OBJECTIVE>
    /// Fetch list of Sales Coach Activity Records.
    ///<OBJECTIVE>
    public static List<Sales_Coach_Activity__c> fetchlstSalesCoachActvty(Id salesCoachId)
    {
        return [select Sales_Coach_Stage__c, 
                            Ordering_Number__c, 
                            Name, 
                            Id, 
                            Activity_Details__c 
                         from Sales_Coach_Activity__c
                         where Sales_Coach_Stage__c = : salesCoachId
                         order by Ordering_Number__c];
    }
    
    ///<OBJECTIVE>
    /// Fetch list of Sales Coach stage Records.
    ///<OBJECTIVE>
    public static Sales_Coach_Stage__c[]  fetchSalesCoachstage(string  strStage)
    {
        return [select id, 
                          name, 
                          buyer_stage__c,  
                          active__c
                   from Sales_Coach_Stage__c 
                   where active__c = true 
                   and name = : strStage];
    }
     ///<OBJECTIVE>
    /// Fetch list of Sales Coach Activity Records.
    ///<OBJECTIVE>
    public static List<Sales_Coach_Activity__c> fetchSalesCoachActy(Id scStageId)
    {
        return [select id, 
                        name, 
                        activity_details__c, 
                        ordering_number__c
                 from Sales_Coach_Activity__c
                 where sales_coach_stage__c = : scStageId];
    }
    ///<OBJECTIVE>
    /// Fetch list of Sales Coach section  Records.
    ///<OBJECTIVE>
    public static List<Sales_Coach_Section__c> fetchlstSalesCoachSection(string SalesCoachSection )
    {
        return [select id from Sales_Coach_Section__c where Section_Name__c = : SalesCoachSection ];
    }
     ///<OBJECTIVE>
    /// Fetch  Sales Coach Activity Records.
    ///<OBJECTIVE>
    public static Sales_Coach_Activity__c getSalesCoachActy(Id SalesId)
    {
        return [select id
                       from Sales_Coach_Activity__c
                       where id = : SalesId];
    }
    ///<OBJECTIVE>
    /// Fetch  Sales Coach Section Records.
    ///<OBJECTIVE>
    public static Sales_Coach_Section__c getSalesCoachSect(Id SalesId)
    {
        return [select id
                         from Sales_Coach_Section__c
                         where id = : SalesId];
    }
    
    ///<OBJECTIVE>
    /// Fetch  Sales Coach Activity Records.
    ///<OBJECTIVE>
    public static Sales_Coach_Section_Item__c getSalesCoachItem(Id SalesId)
    {
        return [select id
                         from Sales_Coach_Section_Item__c 
                         where id = : SalesId];
    }
    ///<OBJECTIVE>
    /// Fetch  Sales Coach Section Records.
    ///<OBJECTIVE>
    public static Sales_Coach_Stage__c InsertSalesCoachSect(string strStage)
    {
        Sales_Coach_Stage__c scStage = new Sales_Coach_Stage__c(Name = strStage,
                                                Active__c = true);
            
        insert scStage;
        return scStage;
    }
    ///<OBJECTIVE>
    /// Fetch  Sales Coach Section Records.
    ///<OBJECTIVE>
    public static List<Sales_Coach_Section__c> getSalesCoachSection(Id salesId)
    {
       return [select id, 
                         sales_coach_stage__c, 
                         section_name__c, 
                         section_ordering__c, 
                         section_width__c,
                         (select id, 
                                 sales_coach_section__c, 
                                 item_name__c, 
                                 link_to_content__c, 
                                 section_ordering__c
                         from Sales_Coach_Section_Items__r order by section_ordering__c, item_name__c)
                  from Sales_Coach_Section__c
                  where sales_coach_stage__c = : salesId order by section_ordering__c, section_name__c];
    }
    
    //-------------- Methods utilised in EZRE_MailchimpDeletion_OldSubscriberData ----------------------
    ///<OBJECTIVE>
    /// Method to fetch old data from MCCandidate object for deletion
    ///<OBJECTIVE>
    public static List<MCCandidateList__c> getMCCndtOldData(Integer iDate)
    {
        String sQuery = 'Select Id, Name, CreatedDate, LastModifiedDate from MCCandidateList__c where IsNew__c = false and LastModifiedDate < LAST_N_DAYS:'+iDate; 
        //WHERE CALENDAR_YEAR(CreatedDate) = 2016';        
        return Database.Query(sQuery);
    }
    
    ///<OBJECTIVE>
    /// Method to fetch old data from MC_Marketing__c object for deletion
    ///<OBJECTIVE>
    public static List<MC_Marketing__c> getMCMrktngOldData(Integer iDate)
    {
        String sQuery = 'Select Id, Name, CreatedDate, LastModifiedDate from MC_Marketing__c where MC_Marketing_IsNew__c = false and LastModifiedDate < LAST_N_DAYS:'+iDate ;
        //WHERE CALENDAR_YEAR(CreatedDate) = 2016';        
        return Database.Query(sQuery);
    }
    ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task createTask(String taskSubject,String accountId,String contactId,String taskStatus,String TaskPriority)
    {
        Task Tsk=new Task();
        Tsk.Subject=taskSubject;
        Tsk.WhatId=accountId;
        Tsk.Whoid=contactId;       
        Tsk.status=taskStatus;
        Tsk.priority=TaskPriority;
        tsk.Created_by_Rep__c = 'Sen Poulami';
        insert Tsk;
        return Tsk;
    }
    public static Task createAccountTask(String taskSubject,String accountId,String taskStatus,String TaskPriority)
    {
        Task Tsk=new Task();
        Tsk.Subject=taskSubject;
        Tsk.WhatId=accountId;      
        Tsk.status=taskStatus;
        Tsk.priority=TaskPriority;
        tsk.Created_by_Rep__c = 'Sen Poulami';
        insert Tsk;
        return Tsk;
    }
    ///<OBJECTIVE>
    ///Fetch the lead records
    ///<OBJECTIVE>
    public static List<lead>  fetchLeadstoUpdateLastActicityCreatedDate(set<Id> leadIdSet)
    {
        return [select id,name,Last_Activity_Created_Date__c from lead where Id IN:leadIdSet];
    }
     ///<OBJECTIVE>
    ///Update created date of the last activity created under lead object
    ///<OBJECTIVE>
    public static void leadsToUpdateLastActivtyCreatedDate(List<lead> leadsToUpdate)
    {
        update leadsToUpdate;
    }
}