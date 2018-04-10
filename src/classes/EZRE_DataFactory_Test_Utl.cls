/**
 * @author           Shahida k
 * @version          1.0 
 * @date             18.Feb.2016
 * @Status           Developed
 * @description      Test Utility Class is a public test class that contain reusable code for test data creation.
 *
 */
@isTest
public class EZRE_DataFactory_Test_Utl
{ 
  ///OBJECTIVE
    /// Insert records in "ContentVersion" standard object and return the inserted ContentVersion record.
    ///OBJECTIVE
    public static ContentVersion createContVer(String strFirstPublishLocationId, String  strCan, Blob blVersionData,String strPathOnclient, String strTitle)
    
    {
    
        ContentVersion contentVersionObj = new ContentVersion();          
                    contentVersionObj.FirstPublishLocationId = strFirstPublishLocationId;       
                    contentVersionObj.Candidate_Id__c = strCan; 
                    contentVersionObj.VersionData = blVersionData; 
                    contentVersionObj.PathOnclient = strPathOnclient;
                    contentVersionObj.Title = strTitle;  
                    insert contentVersionObj; 
                    return contentVersionObj;
                    
    }
     ///OBJECTIVE
    /// Insert records in "ContentVersion" standard object and return the inserted ContentVersion record.
    ///OBJECTIVE
    public static ContentVersion createContVersn(ContentVersion cv)
    
    { 
        insert cv; 
        return cv;
                    
    }
    
    
     ///OBJECTIVE
    /// Insert test data for Candidate object and return the inserted record.
    ///OBJECTIVE
    public static Candidate__c CreateCandidate(String strCanName, String strCanLastName, String strCurrentCity,  
                                     String strCurrentState,String strGender,String strEmpName, String  strEmail,  
                                     String strIntrvwContactPhone,String strContractType, String strVisaType,Integer intCost,  
                                     String strMobile,String strContactEmail,  String strEmpCName, String strEmpMobile, 
                                     String strEmpWorkPhone,date dtFlowUpDate, String strSkills)
    {
        Candidate__c objCand = new Candidate__c();        
        objCand.Name = strCanName;
        objCand.Last_name__c = strCanLastName;
        objCand.Current_city__c = strCurrentCity;
        objCand.Current_state__c =strCurrentState ;
        objCand.Gender__c = strGender;
        objCand.Employer_Name__c = strEmpName;
        objCand.Email__c =strEmail ;
        objCand.interview_contact_phone__c = strIntrvwContactPhone;
        objCand.Contract_type__c = strContractType;
        objCand.visa_type__c = strVisaType;
        objCand.cost__c = intCost;
        objCand.mobile_phone_no__c =strMobile;
        objCand.employer_contact_email__c = strContactEmail;
        objCand.Employer_Contact_Name_Name__c =strEmpCName;
        objCand.Employer_Mobile_No__c = strEmpMobile; 
        objCand.Employer_Work_Phone_No__c = strEmpWorkPhone;              
        objCand.Followup_Date__c = dtFlowUpDate;              
        objCand.Skills__c =strSkills ; 
        insert objCand;
        return objCand;
    }
     ///<OBJECTIVE>
    /// Fetch ContentWorkspace
    ///<OBJECTIVE>
    public static ContentWorkspace fetchCntntWS()
    {
        return [SELECT id FROM ContentWorkspace LIMIT 1];
    }
      ///<OBJECTIVE>
    /// Fetch the contentVersion 
    ///<OBJECTIVE>
    public static ContentVersion fetchCV(String strCV)
    {
        return  [select ContentDocumentId from ContentVersion 
                 WHERE id =:strCV LIMIT 1];
    }
     ///<OBJECTIVE>
    /// Create ContentWorkspaceDoc 
    ///<OBJECTIVE>
    public static ContentWorkspaceDoc createCWSDoc(String strCntntWSId,String strCntntDocId)
    {
        ContentWorkspaceDoc cntntWSDoc = new ContentWorkspaceDoc();
        cntntWSDoc.ContentWorkspaceId = strCntntWSId;
        cntntWSDoc.ContentDocumentId = strCntntDocId;
        INSERT cntntWSDoc;
        return cntntWSDoc;
    }
    ///<OBJECTIVE>
    ///Update ContentVersion.
    ///<OBJECTIVE>
    public static ContentVersion updtContntVer(ContentVersion cv)
    {
        UPDATE cv;
        return cv;
    }
    
    ///OBJECTIVE
    /// Insert test data for Requirement object and return the inserted record.
    ///OBJECTIVE
    public static Requirement__c CreateRequirement(string strReqName, string strReqDuration, decimal decMinCost,
                                                    decimal decMaxCost, decimal decRate, string strStatus, string strPosition,
                                                    string strState, string strIntrviwType, decimal decResumes, string strCity,
                                                    string strEasy1, string strUnique1, string strSkillSet, string strRecFeedback,
                                                    boolean won,date dtStatusOpenOrReopen,String strjobCategry)
    {
        Requirement__c  objReqmt=new Requirement__c(); 
        objReqmt.Name = strReqName;
        objReqmt.Duration__c = strReqDuration;
        objReqmt.Min_Cost__c = decMinCost;
        objReqmt.Max_Cost__c = decMaxCost;
        objReqmt.Rate__c = decRate;
        objReqmt.Status__c = strStatus;
        objReqmt.Position_Type__c = strPosition;
        objReqmt.State__c = strState;
        objReqmt.Interview_Type__c = strIntrviwType;
        objReqmt.No_Of_Resumes__c = decResumes;
        objReqmt.City__c = strCity;
        objReqmt.Est_Start_Date__c =date.today();
        objReqmt.Easy1__c = strEasy1;
        objReqmt.Unique_1__c = strUnique1;
        objReqmt.Skill_Set__c = strSkillSet;
        objReqmt.Recruiter_Feedback__c = strRecFeedback;
        objReqmt.Won__c = won;
        objReqmt.StatusUpdated_Date__c =dtStatusOpenOrReopen;       
        objReqmt.Job_Category__c =strjobCategry;
        insert objReqmt;
        return objReqmt;
    }
    /// OBJECTIVE
    /// Insert test data for User object and return the inserted record.
    /// OBJECTIVE
    public static User CreateUser(String strAlias, String strEmail,String strEmailEncodKey, String strFirstName,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,Boolean blIsActive)    
    {
        User objUser = new User();
        objUser.Alias = strAlias;
        objUser.Email = strEmail; 
        objUser.EmailEncodingKey = strEmailEncodKey;
        objUser.FirstName = strFirstName;
        objUser.LastName = strLastName;
        objUser.LanguageLocaleKey = strLangLocalKey;
        objUser.LocaleSidKey = strLocalSideKey;
        objUser.ProfileId = strProfileId;
        objUser.TimeZoneSidKey = strTimeZoneKey;
        objUser.UserName = strUserName;
        objUser.phone = strPhone;
        objUser.IsActive = blIsActive;        
        insert objUser;
        return objUser;
    }
    /// OBJECTIVE
    /// Insert test data for User object and return the inserted record.
    /// OBJECTIVE
    public static User CreateUserwithRole(String strAlias, String strEmail,String strEmailEncodKey, String strFirstName,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,Boolean blIsActive,ID RoleId)    
    {
        User objUser = new User();
        objUser.Alias = strAlias;
        objUser.Email = strEmail; 
        objUser.EmailEncodingKey = strEmailEncodKey;
        objUser.FirstName = strFirstName;
        objUser.LastName = strLastName;
        objUser.LanguageLocaleKey = strLangLocalKey;
        objUser.LocaleSidKey = strLocalSideKey;
        objUser.ProfileId = strProfileId;
        objUser.TimeZoneSidKey = strTimeZoneKey;
        objUser.UserName = strUserName;
        objUser.phone = strPhone;
        objUser.IsActive = blIsActive;
        objUser.UserRoleId = RoleId;        
        insert objUser;
        return objUser;
    }

    /// <OBJECTIVE>
    /// Fetches the profile data from Profile. 
    /// </OBJECTIVE> 
    public static Profile getParticularProfile(string strProfileName){
        return [SELECT 
                    Id,
                    Name
                FROM 
                    Profile 
                WHERE
                    Name =: strProfileName
                LIMIT 1];   
    } 
     /// <OBJECTIVE>
    /// Fetches the profile data from Profile. 
    /// </OBJECTIVE> 
    public static UserRole getParticularRole(string strRoleName){
        return [SELECT 
                    Id,
                    Name
                FROM 
                    UserRole
                WHERE
                    Name =: strRoleName
                LIMIT 1];   
    } 
    ///<OBJECTIVE>
    ///Insert Account record.
    ///<OBJECTIVE>
    public static Account createAccnt(String AccName,String website)
    {
         Account acc; 
        try
        {
            acc = new Account();
            acc.Name = AccName;
            acc.website= website; 
            acc.Phone='9677273086';    
            acc.AnnualRevenue=897;
            acc.Lead_Gen_Name__c='Others';
            acc.If_Others_Please_Specify__c='Shahida';
            INSERT acc;
         }
         catch(Exception Ex)
         {
         system.debug('@@@@@@@Validation Exception'+Ex);
         }       
        return acc;
    }
    ///<OBJECTIVE>
    ///Insert Account record.
    ///<OBJECTIVE>
    public static Account createSfdcAccnt(String AccName,Decimal anualRevenue,Boolean sfdc,String salesRep,String website)
    {
         Account acc; 
        try
        {
            acc = new Account();
            acc.Name = AccName;
            acc.AnnualRevenue=anualRevenue;
            acc.force_com__c=sfdc;
            acc.Inside_SalesRep__c =salesRep;
            acc.website= website;  
            acc.Lead_Gen_Name__c='Others';
            acc.If_Others_Please_Specify__c='Shahida';          
            INSERT acc;
         }
         catch(Exception Ex)
         {
         system.debug('@@@@@@@Validation Exception'+Ex);
         }       
        return acc;
    }
    
    ///<OBJECTIVE>
    ///Insert Account record.
    ///</OBJECTIVE>
    public static Account createAccnt(String accName, Decimal anualRevenue, Boolean force, String forceRep,String forceDotcomStatus,
                                     Boolean dotNet, String dotNetRep,String ODSDotNetStatus,
                                     String website, string accStatus) {
               
        Account acc; 
        try
        {
            acc = new Account();
            acc.Name = accName;
            acc.AnnualRevenue = anualRevenue;
            acc.force_com__c = force;
            acc.Inside_SalesRep__c = forceRep;
            acc.Force_com_Account_Status__c=forceDotcomStatus;
            acc.ODSDotNet__c = dotNet;
            acc.ODSDotNet_Inside_Sales_Rep__c = dotNetRep;
            acc.ODSDotNet_Account_Status__c=ODSDotNetStatus;           
            acc.website = website;    
            acc.Account_Status__c = accStatus; 
            acc.Phone='9677273086'; 
            acc.Lead_Gen_Name__c='Others';
            acc.If_Others_Please_Specify__c='Shahida';  
            acc.NumberOfEmployees = 10; 
            acc.Industry ='Insurance';     
            INSERT acc;
         }
         catch(Exception Ex)
         {
         system.debug('@@@@@@@Validation Exception'+Ex);
         }       
        return acc;
    }
    ///<OBJECTIVE>
    ///Insert Account record.
    ///<OBJECTIVE>
    public static Account createDataStaxAccnt(String AccName,Decimal anualRevenue,Boolean dataStax,String salesRep,String website)
    {
         Account acc; 
        try
        {
            acc = new Account();
            acc.Name = AccName;
            acc.AnnualRevenue=anualRevenue;
            acc.DataStax__c=dataStax;
            acc.Inside_SalesRep__c=salesRep;
            acc.website= website;    
            acc.Lead_Gen_Name__c='Others';
            acc.If_Others_Please_Specify__c='Shahida';      
            INSERT acc;
         }
         catch(Exception Ex)
         {
         system.debug('@@@@@@@Validation Exception'+Ex);
         }       
        return acc;
    }
    /// <OBJECTIVE>
    /// Fetches the account 
    /// </OBJECTIVE> 
    public static account getAccount(string accountId){
        return [select id,
                        name,
                        website
                   FROM 
                        account
                   WHERE  id=:accountId limit 1];  
                    
    } 
    ///<OBJECTIVE>
    ///Update account
    ///<OBJECTIVE>
    public static Account updtAccount(Account accunt)
    {
       try{
          accunt.Lead_Gen_Name__c='Others';
          accunt.If_Others_Please_Specify__c='Shahida'; 
          UPDATE accunt;
       }
       catch(Exception Ex)
       {
           System.debug('Website validation in account update'+Ex);
       }
        
        return accunt;
    }
     ///<OBJECTIVE>
    ///created assign requirement
    ///<OBJECTIVE>
    public static RequirementAssignment__c createAssReq(Id reqId)
    {
       RequirementAssignment__c obj = new RequirementAssignment__c();
       obj.requirement__C = reqId;
        return obj;
    }
    
     ///<OBJECTIVE>
    ///Insert assign Requirement
    ///<OBJECTIVE>
    public static RequirementAssignment__c createAssgnReq(Id reqId)
    {
        RequirementAssignment__c objAssgnReq= new RequirementAssignment__c();
        objAssgnReq.requirement__C = reqId;   
        insert objAssgnReq;      
        return objAssgnReq;
    }
    ///<OBJECTIVE>
    ///Insert assign Requirement to recruiter
    ///<OBJECTIVE>
    public static RequirementAssignment__c assgnReqToRecruiter(Id reqId,Id recruiterId)
    {
        RequirementAssignment__c objAssgnReq= new RequirementAssignment__c();
        objAssgnReq.requirement__C = reqId;
        objAssgnReq.Recruiter__c=recruiterId;
        insert objAssgnReq;      
        return objAssgnReq;
    }
    
   ///<OBJECTIVE>
    ///Create Contact record.
    ///<OBJECTIVE>
    public static contact createContact(String ContctFName,String ContactLName,String Phn,String Title,String Email,String status)
    {
        Contact con = new Contact();
        con.FirstName =ContctFName;
        con.LastName = ContactLName;
        con.Phone = Phn;
        con.Title = Title;
        con.Email = Email;
        con.Status__c=status;
        con.Lead_Gen_Name__c='Others';
        con.If_Others_Please_Specify__c='Shahida';
        insert con;
        return con;
    }
    ///<OBJECTIVE>
    ///Create Contact record.
    ///<OBJECTIVE>
    public static contact createSfdcContact(String ContactLName,string account,Boolean isSfdc,String status)
    {
        Contact con = new Contact();      
        con.LastName = ContactLName;
        con.AccountId=account;
        con.force_com__c=isSfdc;       
        con.Status__c=status;
        con.Lead_Gen_Name__c='Others';
        con.If_Others_Please_Specify__c='Shahida';
        insert con;
        return con;
    }
    
     ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task createTask(String taskSubject,String contactId,String taskStatus,String TaskPriority)
    {
        Task Tsk=new Task();
        Tsk.Subject=taskSubject;
        Tsk.Whoid=contactId;
        Tsk.status=taskStatus;
        Tsk.priority=TaskPriority;
        insert Tsk;
        return Tsk;
    }
    
     ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task createTasks(String taskSubject,String contactId,String taskStatus,String TaskPriority,Date ActivityDate)
    {
        Task Tsk=new Task();
        Tsk.Subject=taskSubject;
        Tsk.Whoid=contactId;       
        Tsk.status=taskStatus;
        Tsk.priority=TaskPriority;
        Tsk.ActivityDate=ActivityDate;
        tsk.Created_by_Rep__c = 'Sen Poulami';
        insert Tsk;
        return Tsk;
    }
     ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task createTask(String taskSubject,String contactId,String taskStatus,String TaskPriority,String campaign)
    {
        Task Tsk=new Task();
        Tsk.Subject=taskSubject;
        Tsk.Whoid=contactId;
        Tsk.status=taskStatus;
        Tsk.priority=TaskPriority;
        Tsk.Campaign__c=campaign;
        insert Tsk;
        return Tsk;
    }
    
    
     ///<OBJECTIVE>
    ///Create Contact record.
    ///<OBJECTIVE>
    public static contact updateContact(Id contactId,String status)
    {
        Contact con = new Contact();       
        con.Id=contactId;
        con.Status__c=status;
        con.Lead_Gen_Name__c='Others';
        con.If_Others_Please_Specify__c='Shahida';
        Update con;
        return con;
    }
     /// <OBJECTIVE>
    /// To insert and return a Candidate Mapping record. 
    /// </OBJECTIVE> 
    public static Candidate_Mapping__c InsertCandMapng(string Status,string EmailAuth,string LrComments,string MrComments,string ReqOwnerEmail,
                                                       string MangEmailId,string RComments,string LRStatus,string MrStatus,string LRStatusDate,
                                                       string MRStatusDate,string SubToclient,string InterviewSchd,string IntAccepted,string ClientInterviewed,
                                                       string ClientOffered,string CandStarted,string Comments,Date ContEndDate,Id ReqId,Id CandtId)
    {
        Candidate_Mapping__c candMapping =new Candidate_Mapping__c();

            candMapping .status1__c = Status;
            candMapping .Employer_s_Authorization__c = EmailAuth;
            candMapping .LR_Comments__c = LrComments;
            candMapping .MR_Comments__c = MrComments;
            candMapping .Requirement_Owner_Email__c = ReqOwnerEmail;
            candMapping .Manager_Email_ID__c = MangEmailId;
            candMapping .R_Comments__c = RComments;
            candMapping .LR_Status__c = LRStatus;
            candMapping .MR_Status__c = MrStatus;
            candMapping .LR_Status_Date__c = LRStatusDate;
            candMapping .MR_Status_Date__c = MRStatusDate;
            candMapping .Submitted_to_Client__c = SubToclient;
            candMapping .Interview_Scheduled__c = InterviewSchd;
            candMapping .Interview_Accepted__c = IntAccepted;
            candMapping .Client_Interviewed__c = ClientInterviewed;
            candMapping .Client_Offered__c = ClientOffered;
            candMapping .Candidate_started__c = CandStarted;
            candMapping .Comments__c = Comments;
            candMapping .Contract_End_Date__c = ContEndDate;
            candMapping .Requirement__c=ReqId;
            candMapping .Candidate__c=CandtId;
            
            insert candMapping ;
            return candMapping ;
    } 
     ///OBJECTIVE
    /// Insert test data for Requirement object and return the inserted record.
    ///OBJECTIVE
    public static Requirement__c CreateRqrmnt(string strReqName, string strReqDuration, decimal decMinCost,
                                                    decimal decMaxCost, decimal decRate, string strStatus, string strPosition,
                                                    string strState, string strIntrviwType, decimal decResumes, string strCity,
                                                    string strEasy1, string strUnique1, string strSkillSet, string strRecFeedback,
                                                    boolean won,date dtStatusOpenOrReopen,String strjobCategry,String strType)
    {
        Requirement__c  objReqmt=new Requirement__c(); 
        objReqmt.Name = strReqName;
        objReqmt.Duration__c = strReqDuration;
        objReqmt.Min_Cost__c = decMinCost;
        objReqmt.Max_Cost__c = decMaxCost;
        objReqmt.Rate__c = decRate;
        objReqmt.Status__c = strStatus;
        objReqmt.Position_Type__c = strPosition;
        objReqmt.State__c = strState;
        objReqmt.Interview_Type__c = strIntrviwType;
        objReqmt.No_Of_Resumes__c = decResumes;
        objReqmt.City__c = strCity;
        objReqmt.Est_Start_Date__c =date.today();
        objReqmt.Easy1__c = strEasy1;
        objReqmt.Unique_1__c = strUnique1;
        objReqmt.Skill_Set__c = strSkillSet;
        objReqmt.Recruiter_Feedback__c = strRecFeedback;
        objReqmt.Won__c = won;
        objReqmt.StatusUpdated_Date__c =dtStatusOpenOrReopen;       
        objReqmt.Job_Category__c =strjobCategry;
        objReqmt.Requirement_Type__c=strType;
        insert objReqmt;
        return objReqmt;
    }
     
     ///OBJECTIVE
    /// Insert test data for Work_Allocation__c object and return the inserted record.
    ///OBJECTIVE
    public static Work_Allocation__c createWorkalloc(string name,String accountId,Boolean isWorked)
    {
        Work_Allocation__c WrkAllc=new Work_Allocation__c();
        WrkAllc.Name=Name;
        WrkAllc.Account_Name__c=accountId;  
        WrkAllc.Worked__c=isWorked;
        insert WrkAllc;
        return WrkAllc;

    
    }  
    /// <OBJECTIVE>
    /// Fetches the account 
    /// </OBJECTIVE>                                              
    public static Account fetchaccount(String accountId)
    {
        return [select id,
                        Activity_Created_Date__c ,
                        name,
                        createdDate from account where Id=:accountId];
    }
     /// <OBJECTIVE>
    /// Fetches the Work Allocation of an Account
    /// </OBJECTIVE>                                              
    public static Work_Allocation__c fetchWorkAllocation(String WorkallocationId)
    {
        return [select id,
                        worked__c ,
                        name,
                        createdDate from Work_Allocation__c where Id=:WorkallocationId];
    }
    /// <OBJECTIVE>
    /// Fetches the Work Allocation
    /// </OBJECTIVE>                                              
    public static LIST<Work_Allocation__c> fetchWorkAlloc()
    {
        return [SELECT
                    Id
                FROM
                    Work_Allocation__c];
    }
    /// <OBJECTIVE>
    /// Insert Task Allocation  custom Setting
    /// </OBJECTIVE>
     public static TaskAllocation__c createWorkallocSettings()
    {
        TaskAllocation__c WrkAllc=new TaskAllocation__c();
        WrkAllc.Name = 'workAllocation';
        WrkAllc.Daily_Limit__c =50;
        WrkAllc.DataStax__c =true;
        WrkAllc.Force_com__c =false;       
        
        insert WrkAllc;
        return WrkAllc;
    
    }         
    /// <OBJECTIVE>
    /// Insert Call List Allocation  custom Setting.
    /// </OBJECTIVE>
     public static Call_List_Allocation__c createCallListAllocSettings(string strCampaign,String strRepNames)
    {
        Call_List_Allocation__c allocationSetting=new Call_List_Allocation__c();
        
        allocationSetting.Name = strCampaign;
        allocationSetting.Rep_Names__c = strRepNames;
        allocationSetting.Daily_Limit__c =1;      
        allocationSetting.Anual_Revenue_From__c=1000;
        allocationSetting.Anual_Revenue_To__c=2000;
        allocationSetting.Account_Status__c='1: Calling';
        
        insert allocationSetting;
        return allocationSetting;
    
    }  
    /// OBJECTIVE
    /// Insert test data for User object and return the inserted record.
    /// OBJECTIVE
    public static User CreateUserWithCampaign(String strAlias, String strEmail,String strEmailEncodKey, String strFirstName,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,Boolean blIsActive,string strCampaign)    
    {
        User objUser = new User();
        objUser.Alias = strAlias;
        objUser.Email = strEmail; 
        objUser.EmailEncodingKey = strEmailEncodKey;
        objUser.FirstName = strFirstName;
        objUser.LastName = strLastName;
        objUser.LanguageLocaleKey = strLangLocalKey;
        objUser.LocaleSidKey = strLocalSideKey;
        objUser.ProfileId = strProfileId;
        objUser.TimeZoneSidKey = strTimeZoneKey;
        objUser.UserName = strUserName;
        objUser.phone = strPhone;
        objUser.IsActive = blIsActive;
        objUser.Campaign__c = strCampaign;       
        insert objUser;
        return objUser;
    }  
   
    /// <OBJECTIVE>
    /// Fetches the Assign Requirement id of updated Assign Candidate 
    /// </OBJECTIVE> 
    public static string getCandMapAssgnReqId(string assignReqId){
        return [SELECT 
                    Id,
                    RequirementAssignment__c
                FROM 
                    Candidate_Mapping__c
                WHERE
                    RequirementAssignment__c =:assignReqId
                LIMIT 1].RequirementAssignment__c;   
    } 
    /// <OBJECTIVE>
    /// insert candidate mapping with client interviews,client offered ,candidate started fields.
    /// </OBJECTIVE> 
    public static Candidate_Mapping__c InsertCandidateMappingng(string Status,string EmailAuth,string LrComments,string MrComments,string ReqOwnerEmail,
                                                   string MangEmailId,string RComments,string LRStatus,string MrStatus,string LRStatusDate,
                                                   string MRStatusDate,string SubToclient,string InterviewSchd,string IntAccepted,string ClientInterviewed,
                                                   string ClientOffered,string CandStarted,string Comments,
                                                   Date ContEndDate,Id ReqId,Id CandtId,
                                                   DateTime ClntInvwd,DateTime ClntOffrd,DateTime CandStrtd)
    {
        Candidate_Mapping__c candMapping =new Candidate_Mapping__c();
        candMapping .status1__c = Status;
        candMapping .Employer_s_Authorization__c = EmailAuth;
        candMapping .LR_Comments__c = LrComments;
        candMapping .MR_Comments__c = MrComments;
        candMapping .Requirement_Owner_Email__c = ReqOwnerEmail;
        candMapping .Manager_Email_ID__c = MangEmailId;
        candMapping .R_Comments__c = RComments;
        candMapping .LR_Status__c = LRStatus;
        candMapping .MR_Status__c = MrStatus;
        candMapping .LR_Status_Date__c = LRStatusDate;
        candMapping .MR_Status_Date__c = MRStatusDate;
        candMapping .Submitted_to_Client__c = SubToclient;
        candMapping .Interview_Scheduled__c = InterviewSchd;
        candMapping .Interview_Accepted__c = IntAccepted;
        candMapping .Client_Interviewed__c = ClientInterviewed;
        candMapping .Client_Offered__c = ClientOffered;
        candMapping .Candidate_started__c = CandStarted;
        candMapping .Comments__c = Comments;
        candMapping .Contract_End_Date__c = ContEndDate;
        candMapping .Requirement__c=ReqId;
        candMapping .Candidate__c=CandtId;
        candMapping.Candidate_Started_Date__c=ClntInvwd;
        candMapping.Client_Interviewed_Date__c=ClntOffrd;
        candMapping.Client_Offered_Date__c=CandStrtd;
        insert candMapping ;
        return candMapping ;
    }
    ///<OBJECTIVE>
    ///Insert Account Related Campaign Record.
    ///<OBJECTIVE>
    public static Account_Related_Campaign__c createAccntRltdCmpgn(Id AcccountId,String AccountStatusStr,String CampaignStr,String DataStatusStr,String RepNameStr)
    {
         Account_Related_Campaign__c accntRltdCmpgnObj=new Account_Related_Campaign__c(); 
       
            //accntRltdCmpgnObj.Name=NameStr;
            accntRltdCmpgnObj.Account__c=AcccountId;
            accntRltdCmpgnObj.Account_Status__c=AccountStatusStr; 
            accntRltdCmpgnObj.Campaign__c=CampaignStr;
            accntRltdCmpgnObj.Data_Status__c=DataStatusStr;
            accntRltdCmpgnObj.Rep_Name__c=RepNameStr;
            
            insert accntRltdCmpgnObj;   
            return accntRltdCmpgnObj;
    }
      ///OBJECTIVE
    /// Insert test data for Requirement object and return the inserted record.
    ///OBJECTIVE
    public static Requirement__c CreateRqrmnt(string strReqName, string strReqDuration, decimal decMinCost,
                                                    decimal decMaxCost, decimal decRate, string strStatus, string strPosition,
                                                    string strState, string strIntrviwType, decimal decResumes, string strCity,
                                                    string strEasy1, string strUnique1, string strSkillSet, string strRecFeedback,
                                                    boolean won,date dtStatusOpenOrReopen,String strjobCategry,String strType,Datetime dtmReqReopendate)
    {
        Requirement__c  objReqmt=new Requirement__c(); 
        objReqmt.Name = strReqName;
        objReqmt.Duration__c = strReqDuration;
        objReqmt.Min_Cost__c = decMinCost;
        objReqmt.Max_Cost__c = decMaxCost;
        objReqmt.Rate__c = decRate;
        objReqmt.Status__c = strStatus;
        objReqmt.Position_Type__c = strPosition;
        objReqmt.State__c = strState;
        objReqmt.Interview_Type__c = strIntrviwType;
        objReqmt.No_Of_Resumes__c = decResumes;
        objReqmt.City__c = strCity;
        objReqmt.Est_Start_Date__c =date.today();
        objReqmt.Easy1__c = strEasy1;
        objReqmt.Unique_1__c = strUnique1;
        objReqmt.Skill_Set__c = strSkillSet;
        objReqmt.Recruiter_Feedback__c = strRecFeedback;
        objReqmt.Won__c = won;
        objReqmt.StatusUpdated_Date__c =dtStatusOpenOrReopen;       
        objReqmt.Job_Category__c =strjobCategry;
        objReqmt.Requirement_Type__c=strType;
        objReqmt.Req_reopen_date__c=dtmReqReopendate;
        objReqmt.Est_Start_Date__c=Date.Today();
        insert objReqmt;
        return objReqmt;
    }
     ///<OBJECTIVE>
    ///Method to create Contact record.
    ///<OBJECTIVE>
    public static contact createContact(String contactFName,String contactLName,string account,
                                    String phn,String title,String email,Boolean isSfdc,
                                    String status,Boolean isTitleInsurance,String TitleInsuranceStatus,
                                    Boolean isODSAWS,String ODSAWSStatus,String repName)
    {
        Contact con = new Contact(); 
        con.FirstName =contactFName;        
        con.LastName = ContactLName;
        con.AccountId=account;
        con.Phone = Phn;
        con.Title = Title;
        con.Email = Email;
        con.force_com__c=isSfdc;       
        con.Status__c=status;
        con.Title_Insurance__c=isTitleInsurance;
        con.Title_Insurance_Status__c=TitleInsuranceStatus;
        con.ODS_AWS__c=isODSAWS;
        con.ODS_AWS_Status__c=ODSAWSStatus;
        con.Inside_SalesRep__c =repName;
        con.Lead_Gen_Name__c='Others';
        con.If_Others_Please_Specify__c='Shahida';
        insertContact(con);
        return con;
    }
    ///<OBJECTIVE>
    ///Method to insert Contact record.
    ///<OBJECTIVE>
    Public static void insertContact(Contact cntct)
    {
        cntct.Lead_Gen_Name__c='Others';
        cntct.If_Others_Please_Specify__c='Shahida';
        insert cntct;
       
    }
     ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task createAccountTask(String taskSubject,String accountId,String contactId,String taskStatus,String TaskPriority,Date ActivityDate)
    {
        Task Tsk=new Task();
        Tsk.Subject=taskSubject;
        Tsk.WhatId=accountId;
        Tsk.Whoid=contactId;       
        Tsk.status=taskStatus;
        Tsk.priority=TaskPriority;
        Tsk.ActivityDate=ActivityDate;
        tsk.Created_by_Rep__c = 'Sen Poulami';
        insert Tsk;
        return Tsk;
    }
     ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task createContactTask(String taskSubject,String accountId,String taskStatus,String TaskPriority,Date ActivityDate)
    {
        Task Tsk=new Task();
        Tsk.Subject=taskSubject;
        Tsk.WhatId=accountId;
        Tsk.status=taskStatus;
        Tsk.priority=TaskPriority;
        Tsk.ActivityDate=ActivityDate;
        tsk.Created_by_Rep__c = 'Sen Poulami';
        insert Tsk;
        return Tsk;
    }
    ///<OBJECTIVE>
    ///Update account
    ///<OBJECTIVE>
    public static void updateTask(task taskRecord)
    {
          UPDATE taskRecord; 
    }
    ///<OBJECTIVE>
    ///Insert ExportContactsDate custom setting record
    ///<OBJECTIVE>
    Public static EZRE_ExportContactsDate__c insertExportContactsDate(String name,Datetime lastExportedDate)
    {
        
          EZRE_ExportContactsDate__c objExCon=new EZRE_ExportContactsDate__c(); 
          objExCon.name=name;
          objExCon.ExportedDate__c=lastExportedDate; 
          insert objExCon;
          return objExCon;
   }
   //-----------lightning issue fix for content version in assign candidate create page-------------
   ///<OBJECTIVE>
   //Fetch recuriters
   ///</OBJECTIVE>
   Public static User fetchRecruiters(Id profileId,Id roleId)
   {
       return [select id,Manager_Email__c from user where UserRoleId=:roleId and ProfileId=:profileId and IsActive =true and Manager_Email__c!=null limit 1];

   }
     ///OBJECTIVE
    /// Insert assign candidate record
    ///OBJECTIVE
    Public static Candidate_Mapping__c  createCandidateMapping(String managerEmail,String candidateId,String requirementId,String status,String empAuth,String lrComments,String mrComments,String reqOwnerEmail)
    {   
        Candidate_Mapping__c coa =new Candidate_Mapping__c();
        coa.Manager_Email_ID__c =managerEmail;
        coa.Candidate__c =candidateId;
        coa.Requirement__c =requirementId;
        coa.status1__c = status;
        coa.Employer_s_Authorization__c = empAuth;  
        coa.LR_Comments__c = lrComments;
        coa.MR_Comments__c =mrComments;      
        coa.Requirement_Owner_Email__c = reqOwnerEmail;
        return coa;
    
    }
    ///OBJECTIVE
    /// Insert candidate record
    ///OBJECTIVE
    Public static candidate__c insertCandidateRecord(String name,String lastName,String currentCity,String currentState,String gender,
    String empName,String email,String contactPhone,String contractType,String visaType,Decimal cost,
    String mobilePhone,String empContactEmail,String EmpContactName,String emprMobileNo)
    {
        candidate__c cand=new candidate__c();
        cand.Name=name;
        cand.last_name__c=lastName;
        cand.current_city__c=currentCity;
        cand.current_state__c=currentState;
        cand.gender__c=gender;
        cand.Employer_Name__c=empName;
        cand.email__c=email;
        cand.interview_contact_phone__c=contactPhone;
        cand.contract_type__c=contractType;
        cand.visa_type__c=visaType;
        cand.cost__c =cost;
        cand.mobile_phone_no__c=mobilePhone;
        cand.employer_contact_email__c=empContactEmail;
        cand.Employer_Contact_Name_Name__c=EmpContactName;
        cand.Employer_Mobile_No__c=emprMobileNo;
        insert cand;          
        return cand;
    }
    ///OBJECTIVE
    /// Insert requirement record
    ///OBJECTIVE
    Public static requirement__c insertRequirement(String name,String duration,Integer noOfResumes,integer minCost,integer maxCost,Integer rate,String rateBasis,
                                                   String status,String positionType,String state,String city,Date estStartDate,Boolean won,String easy1)
    {
        requirement__c rc=new requirement__c();
        rc.Name=name;
        rc.Duration__c=duration;
        rc.No_Of_Resumes__c=noOfResumes;
        rc.Min_Cost__c=minCost;
        rc.Max_Cost__c=maxCost;
        rc.Rate__c=rate;
        rc.Rate_Basis__c=rateBasis;
        rc.Status__c=status;
        rc.Position_Type__c=positionType;
        rc.State__c=state;
        rc.City__c=city;
        rc.Est_Start_Date__c=estStartDate; 
        rc.won__c =won;   
        rc.easy1__c=easy1;     
        insert rc;
        return rc;
    
    }
    ///<OBJECTIVE>
    /// Fetch the workspace folder
    ///<OBJECTIVE>
    public static ContentWorkspace FetchContentWorkspace(String libraryName)
    {
        return [SELECT Id FROM ContentWorkspace WHERE Name =:libraryName];
    } 
    ///OBJECTIVE
    /// Insert records in "ContentVersion" standard object and return the inserted ContentVersion record.
    ///OBJECTIVE
    public static ContentVersion createContentVersion(String workSpaceId, String  contentURL,String title, String candidateId)   
    {
            ContentVersion ContentInsert = new ContentVersion(); 
            ContentInsert .firstpublishlocationid=workSpaceId;
            ContentInsert .ContentURL=contentURL; 
            ContentInsert .Title = title;           
            ContentInsert .Candidate_ID__c=candidateId;
            insert ContentInsert ;   
            return ContentInsert;                
    }
    ///<OBJECTIVE>
    ///Insert assign Requirement to Lead recruiter
    ///<OBJECTIVE>
    public static RequirementAssignment__c assgnReqToLR(Id reqId,Id leadrecruiterId)
    {
        RequirementAssignment__c objAssgnReq= new RequirementAssignment__c();
        objAssgnReq.requirement__C = reqId;
        objAssgnReq.Lead_Recruiter__c=leadrecruiterId;
        insert objAssgnReq;      
        return objAssgnReq;
    }
     /// <OBJECTIVE>
    /// Insert Contact 
    
     public static Contact createcontact(string Name,String Email,String Status,Id accountid,Boolean forceCom,Boolean OdsAws,String OdsAwsstatus)
    {
        Contact contactcallList=new Contact();
       
        contactcallList.LastName = Name;
        contactcallList.Email=Email;
        //contactcallList.Timezone__c=Timezone;
        contactcallList.Status__c=Status;
        contactcallList.AccountId=accountid;
        //contactcallList.Activity_Created_Date__c=activitycreateddate;
        contactcallList.Force_com__c=forceCom;
        contactcallList.ODS_AWS__c=OdsAws;
        contactcallList.ODS_AWS_Status__c=OdsAwsstatus;
       /* contactcallList.Contact_Campaign_Name__c=ContactCampaignName;
        contactcallList.Contact_Last_Activity__c=ContactLastActivity;
        contactcallList.Contact_Number_Validation__c=ContactNumberValidation;      
        contactcallList.Contact_Status__c=ContactStatus;
        contactcallList.Status_Api_Fld_Name__c=StatusApiFldName;*/
        contactcallList.Lead_Gen_Name__c = 'Others';
        contactcallList.If_Others_Please_Specify__c = 'test';
        insert contactcallList;
        return contactcallList;
    
    }  
     /// <OBJECTIVE>
    /// Insert Account Call List Allocation  custom Setting.
    /// </OBJECTIVE>
     public static Account_Call_List_Allocation__c createAccCallListAlloc(string strCampaign)
    {
        Account_Call_List_Allocation__c AccCallListalloction=new Account_Call_List_Allocation__c();
        AccCallListalloction.Name = strCampaign;
        AccCallListalloction.Account_Annual_Revenue__c = 1000;
        AccCallListalloction.Account_Campaign_Name__c = strCampaign;
        AccCallListalloction.Account_ISR_Name__c ='Sen Poulami';      
        AccCallListalloction.ISR_Field_API_Name__c='Inside_SalesRep__c';
        AccCallListalloction.Daily_Limit__c=0;
        AccCallListalloction.Account_Status__c='1: Calling';
        AccCallListalloction.Status_Field_API_Name__c='Force_com_Account_Status__c';
        insert AccCallListalloction;
        return AccCallListalloction;
    
        }  
        
        /// <OBJECTIVE>
    /// Insert Contact Call List Allocation  custom Setting.
    /// </OBJECTIVE>
     public static Contact_Call_List_Allocation__c createContCallListAlloc(string strCampaign)
    {
        Contact_Call_List_Allocation__c ContCallListAlloc=new Contact_Call_List_Allocation__c();
        ContCallListAlloc.Name = strCampaign;
        ContCallListAlloc.Contact_Campaign_Name__c= strCampaign;
        ContCallListAlloc.Contact_Number_Validation__c='Both correct';      
        ContCallListAlloc.Contact_Status__c='1: Calling';
        ContCallListAlloc.Status_Api_Fld_Name__c='Status__c';
        insert ContCallListAlloc;
        return ContCallListAlloc;
    
    }
    /// <OBJECTIVE>
        /// Insert Account Call List Allocation  custom Setting for Account Daily Call List Allocation
        /// </OBJECTIVE>
         public static Account_Call_List_Allocation__c createaccountcallListAlloc(String Name,Integer AccountAnnualRevenue,String AccountCampaignName,String AccountISRName,String  
    AccountStatus,Integer DailyLimit,String ISRFieldAPIName,String StatusFieldAPIName,string contactNoVal,string contStatusFilter,string contfldApiName)
        {
              Account_Call_List_Allocation__c acclistalloction=new Account_Call_List_Allocation__c();
              acclistalloction.Name=Name;
              acclistalloction.Account_Annual_Revenue__c=AccountAnnualRevenue;
              acclistalloction.Account_Campaign_Name__c=AccountCampaignName;
              acclistalloction.Account_ISR_Name__c=AccountISRName;
              acclistalloction.Account_Status__c=AccountStatus;
              acclistalloction.Daily_Limit__c=DailyLimit;
              acclistalloction.ISR_Field_API_Name__c=ISRFieldAPIName;
              acclistalloction.Status_Field_API_Name__c=StatusFieldAPIName;
              acclistalloction.Contact_NumberValidation__c = contactNoVal;
              acclistalloction.Contact_Status__c = contStatusFilter;
              acclistalloction.Contact_Status_Field_API_Name__c = contfldApiName;
               insert acclistalloction;
               return acclistalloction;
        }
        
    /// <OBJECTIVE>
    /// Insert Contact Call List Allocation  custom Setting Contact Daily Call List Allocation.
    /// </OBJECTIVE>
     public static Contact_Call_List_Allocation__c createcontcallListalloc(string Name,String ContactCampaignName,String ContactLastActivity,String ContactNumberValidation,String ContactStatus,String StatusApiFldName)
    {
        Contact_Call_List_Allocation__c contactcallListalloc=new Contact_Call_List_Allocation__c();
        contactcallListalloc.Name = Name;
        contactcallListalloc.Contact_Campaign_Name__c=ContactCampaignName;
        contactcallListalloc.Contact_Number_Validation__c=ContactNumberValidation;      
        contactcallListalloc.Contact_Status__c=ContactStatus;
        contactcallListalloc.Status_Api_Fld_Name__c=StatusApiFldName;
        insert contactcallListalloc;
        return contactcallListalloc;
    
    }
    
     /// <OBJECTIVE>
    /// Insert lead
    /// </OBJECTIVE>
    public static lead insertLead(String leadFirstName,String leadLastName,String leadStatus,String leadCompany)
    {
        Lead leadRecord=new Lead();
        leadRecord.FirstName=leadFirstName;
        leadRecord.LastName=leadLastName;
        leadRecord.Status=leadStatus;
        leadRecord.Company=leadCompany;
        leadRecord.Lead_Gen_Name__c='Others';
        leadRecord.If_Others_Please_Specify__c='shahida';
        insert leadRecord;
        return leadRecord;
    }    
    ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task CreateTask(String subject, String description)
    {
        Task tsk = new Task();
        tsk.subject = subject;
        tsk.description = description;
        
        insert tsk;
        return tsk;
    }
    
    
}