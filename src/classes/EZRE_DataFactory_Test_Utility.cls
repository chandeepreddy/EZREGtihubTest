/**
 * @author           Keerthi Chandra
 * @version          1.0 
 * @date             7/8/2014
 * @Status           Developed
 * @description      Test Utility Class is a public test class that contain reusable code for test data creation.
 *
 */
@isTest
public class EZRE_DataFactory_Test_Utility
{ 
    ///OBJECTIVE
    /// Insert records in "Candidate" custom object and return the inserted candidate record.
    ///OBJECTIVE
    public static Candidate__c  createCan(String strCanName, String strCanLastName, String strCurrentCity, String strCurrentState, String strGender,
                                             String strEmpName, String  strEmail, String strIntrvwContactPhone, String strContractType, String strVisaType,
                                             Integer intCost, String strMobile, String strContactEmail,  String strEmpCName, String strEmpMobile, String strEmplName,
                                             String strEmpPhone, Date dtDate, String strSkills)
    { 
        Candidate__c can=new Candidate__c();                       
                    can.Name = strCanName;
                    can.Last_name__c = strCanLastName;
                    can.Current_city__c = strCurrentCity;
                    can.Current_state__c = strCurrentState;
                    can.Gender__c = strGender;
                    can.Employer_Name__c = strEmpName;
                    can.Email__c = strEmail;
                    can.interview_contact_phone__c = strIntrvwContactPhone;
                    can.Contract_type__c = strContractType;
                    can.visa_type__c = strVisaType;
                    can.cost__c = intCost;
                    can.mobile_phone_no__c = strMobile;
                    can.employer_contact_email__c = strContactEmail;
                    can.Employer_Contact_Name_Name__c = strEmpCName;
                    can.Employer_Mobile_No__c = strEmpMobile;       
                    can.Employer_Name__c = strEmplName; 
                    can.Employer_Work_Phone_No__c = strEmpPhone;              
                    can.Followup_Date__c = dtDate;              
                    can.Skills__c = strSkills;
                    insert can;  
                    return can;      
    }
    
    
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
    /// Insert records in "Requirement" custom object and return the inserted requirement record.
    ///OBJECTIVE
    public static Requirement__c createReqr(String strName,String strJobTitl,String strDuration,
                                                Integer intNoResumes,Integer intMinCost,Integer intMaxCost,
                                                Integer intRate,String strRateBasis,String strStatus,String strPostnType,
                                                String strState,String strCity,Date dtEstStrtDate,Boolean blReqWon,string strEasy1, 
                                                String strRqrmntCode)
    
    {
    
         Requirement__c req = new Requirement__c();
                    req.Name = strName;
                    //req.Job_Title__c = strJobTitl;
                    req.Duration__c = strDuration;
                    req.No_Of_Resumes__c = intNoResumes;
                    req.Min_Cost__c = intMinCost;
                    req.Max_Cost__c = intMaxCost;
                    req.Rate__c = intRate;
                    req.Rate_Basis__c = strRateBasis;
                    req.Status__c = strStatus;
                    req.Position_Type__c = strPostnType;
                    req.State__c = strState;
                    req.City__c = strCity;
                    req.Est_Start_Date__c = dtEstStrtDate;
                    req.won__c = blReqWon;
                    req.easy1__c = strEasy1;
                    req.Opportunity_Code__c = strRqrmntCode;
                    insert req; 
                    return req;           
     }
     
     public static Profile ProfileByName(string ProfileName)
    {
        return [SELECT Id,
                    Name 
                FROM 
                    Profile
                WHERE
                    Name = 'Administrator'];
    }
     
     
     
    ///OBJECTIVE
    /// Insert records in "User" standard object and return the inserted user record.
    ///OBJECTIVE
    public static User createUser(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,String strPhone)
    
    {
          User objUser = new User();
                    objUser.Alias = strAlias;
                    objUser.Email = strEmail; 
                    objUser.EmailEncodingKey = strEmailEncodKey;
                    objUser.LastName = strLastName;
                    objUser.LanguageLocaleKey = strLangLocalKey;
                    objUser.LocaleSidKey = strLocalSideKey;
                    objUser.ProfileId = strProfileId;
                    objUser.TimeZoneSidKey = strTimeZoneKey;
                    objUser.UserName = strUserName;
                    objUser.phone = strPhone;
                    insert objUser;
                    return objUser;

    }
    
    ///OBJECTIVE
    /// Insert records in "Assign Requirement" custom object and return the inserted Assign Requirement record.
    ///OBJECTIVE
    public static RequirementAssignment__c createAssignmentReq(String strRequirement, String  strLeadRecruiter)
    
    {
         RequirementAssignment__c reqAssgn = new RequirementAssignment__c();
                    reqAssgn.Requirement__c = strRequirement;
                    reqAssgn.Lead_Recruiter__c = strLeadRecruiter;
                    insert reqAssgn;
                    return reqAssgn;
    } 
    

    /// <OBJECTIVE>
    /// Fetch the library data from ContentWorkspace standard object. 
    /// </OBJECTIVE>    
    
    public static List<ContentWorkspace> fetchContent()
    {
        return [SELECT id FROM ContentWorkspace];   
              
    }  
    
    /// <OBJECTIVE>
    /// Fetch the lead recruiter profile data from Profile standard object. 
    /// </OBJECTIVE>    
    
    public static Profile fetchProfile()
    {
        return [SELECT Id FROM Profile WHERE Name ='Lead Recruiter'];   
    }  
    
    /// <OBJECTIVE>
    /// Fetch the profile data from Profile standard object. 
    /// </OBJECTIVE>    
    
    public static Profile getProfile(String strPrflName)
    {
        return [SELECT Id FROM Profile WHERE Name =: strPrflName];   
    }  
    
    /// <OBJECTIVE>
    /// Fetch the recruiter profile data from Profile standard object. 
    /// </OBJECTIVE>    
    
    public static Profile fetchProfileRec()
    {
        return [SELECT Id FROM Profile WHERE Name ='Recruiter'];   
    }          
    
    ///OBJECTIVE
    /// Insert records in "User" standard object and return the inserted user record.
    ///OBJECTIVE
    public static User createUserWithMngr(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,String strManager,Boolean blIsActive, String strUserRole)
    
    {
          User objUser = new User();
                    objUser.Alias = strAlias;
                    objUser.Email = strEmail; 
                    objUser.EmailEncodingKey = strEmailEncodKey;
                    objUser.LastName = strLastName;
                    objUser.LanguageLocaleKey = strLangLocalKey;
                    objUser.LocaleSidKey = strLocalSideKey;
                    objUser.ProfileId = strProfileId;
                    objUser.TimeZoneSidKey = strTimeZoneKey;
                    objUser.UserName = strUserName;
                    objUser.phone = strPhone;
                    objUser.ManagerId = strManager;
                    objUser.IsActive = blIsActive;
                    objUser.UserRoleId = strUserRole;
                    insert objUser;
                    return objUser;

    }
    
     ///OBJECTIVE
    /// Insert records in "User" standard object and return the inserted user record.
    ///OBJECTIVE
    public static User createUserWithM(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,String strManager,Boolean blIsActive)
    
    {
          User objUser = new User();
                    objUser.Alias = strAlias;
                    objUser.Email = strEmail; 
                    objUser.EmailEncodingKey = strEmailEncodKey;
                    objUser.LastName = strLastName;
                    objUser.LanguageLocaleKey = strLangLocalKey;
                    objUser.LocaleSidKey = strLocalSideKey;
                    objUser.ProfileId = strProfileId;
                    objUser.TimeZoneSidKey = strTimeZoneKey;
                    objUser.UserName = strUserName;
                    objUser.phone = strPhone;
                    objUser.ManagerId = strManager;
                    objUser.IsActive = blIsActive;
                    insert objUser;
                    return objUser;

    }
    
    
    ///OBJECTIVE
    /// Insert records in "UserRole" standard object and return the inserted user record.
    ///OBJECTIVE
    public static UserRole createUserRole(String strName, String strParentRole)
    
    {
          UserRole objUserRole = new UserRole();
                    objUserRole.Name = strName;
                    objUserRole.ParentRoleId = strParentRole; 
                    insert objUserRole;
                    return objUserRole;
          
    }
    
    /// <OBJECTIVE>
    /// Fetch the records from UserRole standard object. 
    /// </OBJECTIVE>    
    
    public static UserRole fetchRole()
    {
        return [SELECT id,Name FROM UserRole LIMIT 1];   
              
    }  
    
    /// <OBJECTIVE>
    /// Fetch the records from UserRole standard object. 
    /// </OBJECTIVE>   
    
   /*  public static Mailchimp_Details__c createMCCustomSetting(string strNme, string strAPIKey, string strDmnNme, string strCmpgnId, string strLstId)
    {
        
            Mailchimp_Details__c objMCDtls = new Mailchimp_Details__c();
            objMCDtls.Name = strNme;
            objMCDtls.API_Key__c = strAPIKey;
            objMCDtls.Domain_Name__c = strDmnNme;
            objMCDtls.List_Id__c = strLstId;  
            objMCDtls.Campaign_Id__c = strCmpgnId;          
            insert objMCDtls;
            return objMCDtls;
        
    }*/
    
    /// <OBJECTIVE>
    /// Fetch the records from UserRole standard object. 
    /// </OBJECTIVE>   
    
     public static Mailchimp_Details__c createMCCustomSettingLimit(string strNme, string strAPIKey, string strDmnNme, string strCmpgnId, string strLstId, decimal strLimit)
    {
        
            Mailchimp_Details__c objMCDtls = new Mailchimp_Details__c();
            objMCDtls.Name = strNme;
            objMCDtls.API_Key__c = strAPIKey;
            objMCDtls.Domain_Name__c = strDmnNme;
            objMCDtls.List_Id__c = strLstId;  
            objMCDtls.Campaign_Id__c = strCmpgnId;   
            objMCDtls.countLimit__c = strLimit;       
            insert objMCDtls;
            return objMCDtls;
        
    }
    
     ///OBJECTIVE
    /// Insert records in "Candidate" custom object and return the inserted candidate record.
    ///OBJECTIVE
    public static Candidate__c  createActCan(String strCanName, String strCanLastName, String strCurrentCity, String strCurrentState, String strGender,
                                             String strEmpName, String  strEmail, String strIntrvwContactPhone, String strContractType, String strVisaType,
                                             Integer intCost, String strMobile, String strContactEmail,  String strEmpCName, String strEmpMobile, String strEmplName,
                                             String strEmpPhone, Date dtDate, String strSkills, string strCtgry, string strEmlSts)
    { 
        Candidate__c can=new Candidate__c();                       
                    can.Name = strCanName;
                    can.Last_name__c = strCanLastName;
                    can.Current_city__c = strCurrentCity;
                    can.Current_state__c = strCurrentState;
                    can.Gender__c = strGender;
                    can.Employer_Name__c = strEmpName;
                    can.Email__c = strEmail;
                    can.interview_contact_phone__c = strIntrvwContactPhone;
                    can.Contract_type__c = strContractType;
                    can.visa_type__c = strVisaType;
                    can.cost__c = intCost;
                    can.mobile_phone_no__c = strMobile;
                    can.employer_contact_email__c = strContactEmail;
                    can.Employer_Contact_Name_Name__c = strEmpCName;
                    can.Employer_Mobile_No__c = strEmpMobile;       
                    can.Employer_Name__c = strEmplName; 
                    can.Employer_Work_Phone_No__c = strEmpPhone;              
                    can.Followup_Date__c = dtDate;              
                    can.Skills__c = strSkills;
                    can.Category__c  = strCtgry;
                    can.Email_Status__c = strEmlSts;
                    insert can;  
                    return can;      
    }
    
     ///OBJECTIVE
    /// Insert records in "Requirement" custom object and return the inserted requirement record.
    ///OBJECTIVE
    public static Requirement__c createReqWthCtgr(String strName, String  strDuration, Integer intMinCost,
                                           Integer intMaxCost,Integer intRate, String status,String strPostnType,
                                           String strState,String strIntrvwType,Integer intNoResumes,String strCity,
                                           Date dtEstStrtDate,String strEasy,String strUnique,String strSkillSet, String strCtg)
    
    {
    
         Requirement__c req = new Requirement__c();
                    req.Name = strName;
                    req.Duration__c = strDuration;
                    req.Min_Cost__c = intMinCost;
                    req.Max_Cost__c = intMaxCost;
                    req.Rate__c = intRate;
                    req.Status__c = status;
                    req.Position_Type__c = strPostnType;
                    req.State__c = strState;
                    req.Interview_Type__c = strIntrvwType;
                    req.No_Of_Resumes__c = intNoResumes;
                    req.City__c = strCity;
                    req.Est_Start_Date__c = dtEstStrtDate;
                    req.Easy1__c = strEasy;
                    req.Unique_1__c = strUnique;
                    req.Skill_Set__c = strSkillSet;
                    req.Job_Category__c = strCtg;
                    insert req; 
                    return req;           
     }
      /// <OBJECTIVE>
    /// create a record in thecustom settings. 
    /// </OBJECTIVE>   
    
    /* public static LinkedInDetails__c createLnkdInCustomSetting(string strNme, string strAPIKey, string strAPISecret, string strAcsTkn, DateTime strTokenGen,DateTime strValidTo)
    {
        
            LinkedInDetails__c objLnkInDtls = new LinkedInDetails__c();
            objLnkInDtls.Name = strNme;
            objLnkInDtls.AccessToken__c = strAcsTkn;
            objLnkInDtls.API_Key__c = strAPIKey;
            objLnkInDtls.API_Secret__c = strAPISecret;  
            objLnkInDtls.TokenGeneratedOn__c = strTokenGen;   
            objLnkInDtls.ValidTo__c = strValidTo;       
            insert objLnkInDtls;
            return objLnkInDtls;
        
    }
    
    /// <OBJECTIVE>
    /// Create Mc Details custom settings record. 
    /// </OBJECTIVE>   
    
     public static Mailchimp_Details__c createMCCustomSetting(string strNme, string strAPIKey, string strDmnNme, string strCmpgnId, string strLstId, decimal strLimit)
    {
        
            Mailchimp_Details__c objMCDtls = new Mailchimp_Details__c();
            objMCDtls.Name = strNme;
            objMCDtls.API_Key__c = strAPIKey;
            objMCDtls.Domain_Name__c = strDmnNme;
            objMCDtls.MC_List_Id__c = strLstId;  
            objMCDtls.MC_Campaign_Id__c = strCmpgnId;   
            objMCDtls.countLimit__c = strLimit;       
            insert objMCDtls;
            return objMCDtls;
        
    }
    
    ///<OBJECTIVE>
    ///Create McCandidateList record.
    ///<OBJECTIVE>
    public static MCCandidateList__c createMcCanLst(String strCampaign,String strCampId,String strEmail,Boolean blIsNew,String strLstTyp,
                                                    String strContctOwnrEmail,String strCntctOwnrName)
    {
        MCCandidateList__c mcCan = new MCCandidateList__c();
        mccan.Campaign_Name__c = strCampaign;
        mcCan.Campaign_Id__c = strCampId;
        mcCan.Candidate_Email__c = strEmail;
        mcCan.IsNew__c = blIsNew;
        mcCan.MC_List_Type__c = strLstTyp;
        mcCan.Contact_Owner_Email__c = strContctOwnrEmail;
        mcCan.Contact_Owner_Name__c = strCntctOwnrName;
        insert mcCan;
        return mcCan;
    }*/
   
    
    ///<OBJECTIVE>
    ///Create Account record.
    ///<OBJECTIVE>
    public static Account createAcc(String strAccName)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        insert acc;
        return acc;
    }
    ///Create Account record.
    
    
    
    ///<OBJECTIVE>
    ///Create Contact record.
    ///<OBJECTIVE>
    public static contact createCon(String strContctFName,String strContactLName,String strPhn,String strTitle,String strEmail)
    {
        Contact con = new Contact();
        con.FirstName = strContctFName;
        con.LastName = strContactLName;
        con.Phone = strPhn;
        con.Title = strTitle;
        con.Email = strEmail;
        con.Lead_Gen_Name__c='Others';
        con.If_Others_Please_Specify__c='Shahida';
        insert con;
        return con;
    }
    
    ///<OBJECTIVE>
    ///Create Task record.
    ///<OBJECTIVE>
    public static Task createTask(String strCampId,String strConId, String strSub,String strPriority,String strDescrptn)
    {
        Task tsk = new Task();
        tsk.Campaign_Id__c = strCampId;
        tsk.WhoId = strConId;
        tsk.subject = strSub;
        tsk.Priority = strPriority;
        tsk.description = strDescrptn;
        tsk.ActivityDate = system.today();
        insert tsk;
        return tsk;
    }
    public static Task createTasks(String run,String strCampId,String strConId, String strSub,String strPriority,String strDescrptn)
    {
        Task tsk = new Task();
        tsk.Run__c = run;
        tsk.Campaign_Id__c = strCampId;
        tsk.WhoId = strConId;
        tsk.subject = strSub;
        tsk.Priority = strPriority;
        tsk.description = strDescrptn;
        tsk.ActivityDate = system.today();
        insert tsk;
        return tsk;
    }
    
    ///<OBJECTIVE>
    ///To fetch the candidate record.
    ///<OBJECTIVE>
    public static candidate__c fetchCandtRec(String strId)
    {
        return [SELECT id,Last_name__c FROM Candidate__c WHERE Id =: strId];
    }
    
    ///<OBJECTIVE>
    ///To update the candidate record.
    ///<OBJECTIVE>
    public static candidate__c updtCand(candidate__c can)
    {
        update can;
        return can;
    } 
    
    ///<OBJECTIVE>
    ///Create McContact record.
    ///<OBJECTIVE>
   /* public static MC_Marketing__c createMcConLst(String strCampaign,String strCampId,String strEmail,Boolean blIsNew,
                                                    String strContctOwnrEmail,String strCntctOwnrName)
    {
        MC_Marketing__c mcCan = new MC_Marketing__c();
        mccan.CampaignName__c = strCampaign;
        mcCan.CampaignId__c = strCampId;
        mcCan.Contact_Email__c = strEmail;
        mcCan.MC_Marketing_IsNew__c = blIsNew;
        mcCan.Contact_OwnerEmail__c = strContctOwnrEmail;
        mcCan.Contact_OwnerName__c = strCntctOwnrName;
        insert mcCan;
        return mcCan;
    }
    
     ///<OBJECTIVE>
    /// Fetch the MC Marketing record.
    ///<OBJECTIVE>
    public static MC_Marketing__c fetchMcContctlst(String strCandLst)
    {
        return [SELECT id,Contact_OwnerEmail__c FROM MC_Marketing__c WHERE Id =: strCandLst];
    }*/
    
    ///<OBJECTIVE>
    /// Fetch the Contact record.
    ///<OBJECTIVE>
    public static Contact fetchContct(String strContctId)
    {
        return [SELECT id,owner.Email,owner.Name from Contact WHERE Id =: strContctId];
    }
    
    ///<OBJECTIVE>
    ///Fetch the Task records.
    ///<OBJECTIVE>
    public static List<Task> fetchTaskRcrds(set<Id> setContId)
    {
        return [SELECT id, Campaign_Id__c,subject,Priority,description,ActivityDate FROM Task 
                WHERE whoId IN: setContId];
    }  
     
    ///<OBJECTIVE>
    /// Fetch the contentversion based on the candidate id mapping.
    ///<OBJECTIVE>
    public static List<ContentVersion> ftchCntntVrsn(String strCand)
    {
        return [Select Id, Candidate_ID__c From ContentVersion where Candidate_ID__c =:strCand limit 1];
    }
    
    //OBJECTIVE
    /// Insert records in "Candidate" custom object and return the inserted candidate record.
    ///OBJECTIVE
   public static Candidate__c  createCandtVthNotes(String strCanName, String strCanLastName, String strCurrentCity, String strCurrentState, String strGender,
                                             String strEmpName, String  strEmail, String strIntrvwContactPhone, String strContractType, String strVisaType,
                                             Integer intCost, String strMobile, String strContactEmail,  String strEmpCName, String strEmpMobile, String strEmplName,
                                             String strEmpPhone, Date dtDate, String strSkills, String strReloc, String strAvailbl, Date dtCanContrctEndDt,String strNotes)
    { 
        Candidate__c can=new Candidate__c();                       
                    can.Name = strCanName;
                    can.Last_name__c = strCanLastName;
                    can.Current_city__c = strCurrentCity;
                    can.Current_state__c = strCurrentState;
                    can.Gender__c = strGender;
                    can.Employer_Name__c = strEmpName;
                    can.Email__c = strEmail;
                    can.interview_contact_phone__c = strIntrvwContactPhone;
                    can.Contract_type__c = strContractType;
                    can.visa_type__c = strVisaType;
                    can.cost__c = intCost;
                    can.mobile_phone_no__c = strMobile;
                    can.employer_contact_email__c = strContactEmail;
                    can.Employer_Contact_Name_Name__c = strEmpCName;
                    can.Employer_Mobile_No__c = strEmpMobile;       
                    can.Employer_Name__c = strEmplName; 
                    can.Employer_Work_Phone_No__c = strEmpPhone;              
                    can.Followup_Date__c = dtDate;              
                    can.Skills__c = strSkills;
                    can.Relocation__c = strReloc;
                    can.Availability__c = strAvailbl;
                    can.Contract_End_Date__c = dtCanContrctEndDt;
                    can.Notes__c = strNotes;
                    insert can;  
                    return can;      
    }
    
     ///OBJECTIVE
    /// Insert records in "Candidate" custom object and return the inserted candidate record.
    ///OBJECTIVE
   public static Candidate__c  createCan(String strCanName, String strCanLastName, String strCurrentCity, String strCurrentState, String strGender,
                                             String strEmpName, String  strEmail, String strIntrvwContactPhone, String strContractType, String strVisaType,
                                             Integer intCost, String strMobile, String strContactEmail,  String strEmpCName, String strEmpMobile, String strEmplName,
                                             String strEmpPhone, Date dtDate, String strSkills, String strReloc, String strAvailbl, Date dtCanContrctEndDt)
    { 
        Candidate__c can=new Candidate__c();                       
                    can.Name = strCanName;
                    can.Last_name__c = strCanLastName;
                    can.Current_city__c = strCurrentCity;
                    can.Current_state__c = strCurrentState;
                    can.Gender__c = strGender;
                    can.Employer_Name__c = strEmpName;
                    can.Email__c = strEmail;
                    can.interview_contact_phone__c = strIntrvwContactPhone;
                    can.Contract_type__c = strContractType;
                    can.visa_type__c = strVisaType;
                    can.cost__c = intCost;
                    can.mobile_phone_no__c = strMobile;
                    can.employer_contact_email__c = strContactEmail;
                    can.Employer_Contact_Name_Name__c = strEmpCName;
                    can.Employer_Mobile_No__c = strEmpMobile;       
                    can.Employer_Name__c = strEmplName; 
                    can.Employer_Work_Phone_No__c = strEmpPhone;              
                    can.Followup_Date__c = dtDate;              
                    can.Skills__c = strSkills;
                    can.Relocation__c = strReloc;
                    can.Availability__c = strAvailbl;
                    can.Contract_End_Date__c = dtCanContrctEndDt;
                    insert can;  
                    return can;      
    }
    
      ///<OBJECTIVE>
     ///Fetch Candidate record
     ///<OBJECTIVE>
     public static Candidate__c fetchCandadt(String strCanId)
     {
         return [SELECT id,Star_Candidate__c,Placed__c,Contract_End_Date__c FROM Candidate__c WHERE id=: strCanId];
     }
     
     ///<OBJECTIVE>
     ///Update Candidate record
     ///<OBJECTIVE>
     public static Candidate__c updateCandida(Candidate__c strCan)
    {
  
        Update strCan;
        return strCan;
     }
     
      
    
     
     ///<OBJECTIVE>
     ///Fetch the current user id from standard user object 
     ///<OBJECTIVE>
     public static User fetchCurrntUsr()
     {
         return [Select id from user where Id =: UserInfo.getUserId()];
     }
     
       ///<OBJECTIVE>
     ///Insert Assign Requirement record.
     ///<OBJECTIVE>
     public static RequirementAssignment__c createReqAss(String strReq,String strUp)
     {
         RequirementAssignment__c reqas = new RequirementAssignment__c();
             reqas.Requirement__c=strReq;   
             if(strUp != null)
             { 
                     reqas.Lead_Recruiter__c = strUp; 
             }   
             else  
             {      
                     reqas.Lead_Recruiter__c=''; 
             } 
         
             insert reqas;
             return reqas;
     }
     
     ///<OBJECTIVE>
     ///Fetch Assign Requirement record
     ///<Objective>
     public static RequirementAssignment__c fetchAssReq()
     {
       return [SELECT Id, Requirement__c, Lead_Recruiter__c, Recruiter__c FROM RequirementAssignment__c limit 1];
     }
     
     ///<OBJECTIVE>
     ///Insert Assign Requirement record
     ///<OBJECTIVE>
     public static RequirementAssignment__c assignReq(String strReqAssId)
     {
         RequirementAssignment__c reqAssgnm = new RequirementAssignment__c();
         reqAssgnm.Id = strReqAssId;
         insert reqAssgnm;
         return reqAssgnm;
     }
     
     ///<OBJECTIVE>
     ///Update Assign Requirement record
     ///<OBJECTIVE>
     public static RequirementAssignment__c updateAsgn(RequirementAssignment__c  strAssign)
    {
  
        Update strAssign;
        return strAssign;
     } 
     
      ///<OBJECTIVE>
     /// Fetch the Requirement with opportunity code.
     ///<OBJECTIVE>
     public static Requirement__c ftchReqVthOpp(String strReqId)
     {
         return [SELECT id,Opportunity_Code__c FROM Requirement__c WHERE Id =: strReqId];
     }
     
     ///<OBJECTIVE>
     ///Update Requirement record
     ///<OBJECTIVE>
     public static Requirement__c updateReqrmn(Requirement__c strReq)
    {
  
        Update strReq;
        return strReq;
     }  
     
     ///OBJECTIVE
    /// Insert records in "Requirement" custom object and return the inserted requirement record.
    ///OBJECTIVE
    public static Requirement__c createReqr(String strName,String strJobTitle,String strDuration,Integer intMaxCost,
                                            Integer intMinCost,Integer intRate,Date dtEstDate,String strPostnType,
                                            Boolean blReopn,String strState,Integer intRes,String strStatus,Integer intNoResumes,
                                            String strCity, String strEasy,String strUnique)
    
    {
    
         Requirement__c req = new Requirement__c();
                    req.Name = strName;
                    //req.Job_Title__c = strJobTitle;
                    req.Duration__c = strDuration;
                    req.Max_Cost__c = intMaxCost;
                    req.Min_Cost__c = intMinCost;
                    req.Rate__c = intRate;
                    req.Est_Start_Date__c = dtEstDate;
                    req.Position_Type__c = strPostnType;
                    req.isReopen__c= blReopn;
                    req.State__c = strState;
                    req.Resumes_2__c = intRes;
                    req.Status__c = strStatus;
                    req.No_Of_Resumes__c = intNoResumes;
                    req.City__c = strCity;
                    req.Easy1__c = strEasy;
                    req.Unique_1__c = strUnique;
                    insert req; 
                    return req;           
     }
      ///<OBJECTIVE>
     ///Update Requirement record
     ///<OBJECTIVE>
     public static Requirement__c updateReq(Requirement__c objReq)
    {
  
        Update objReq;
        return objReq;
     }
     
        ///OBJECTIVE
    /// Insert records in "Requirement" custom object and return the inserted requirement record.
    ///OBJECTIVE
    public static Requirement__c createReq(String strName, String  strDuration, Integer intMinCost,
                                           Integer intMaxCost,Integer intRate, String status,String strPostnType,
                                           String strState,String strIntrvwType,Integer intNoResumes,String strCity,
                                           Date dtEstStrtDate,String strEasy,String strUnique,String strSkillSet)
    
    {
    
         Requirement__c req = new Requirement__c();
                    req.Name = strName;
                    req.Duration__c = strDuration;
                    req.Min_Cost__c = intMinCost;
                    req.Max_Cost__c = intMaxCost;
                    req.Rate__c = intRate;
                    req.Status__c = status;
                    req.Position_Type__c = strPostnType;
                    req.State__c = strState;
                    req.Interview_Type__c = strIntrvwType;
                    req.No_Of_Resumes__c = intNoResumes;
                    req.City__c = strCity;
                    req.Est_Start_Date__c = dtEstStrtDate;
                    req.Easy1__c = strEasy;
                    req.Unique_1__c = strUnique;
                    req.Skill_Set__c = strSkillSet;
                    insert req; 
                    return req;           
     } 
     
       ///<OBJECTIVE>
    /// Fetch candidate.
    ///<OBJECTIVE>
    public static candidate__c getCand()
    {
         return [select Candidate__c.ID from Candidate__c LIMIT 1];
    }
    
     ///OBJECTIVE
    /// Insert records in "EZRE_Search_Candidate_Log_Activation__c" custom object and return the inserted EZRE_Search_Candidate_Log_Activation__c record.
    ///OBJECTIVE
    public static EZRE_Search_Candidate_Log_Activation__c  InsertCandLogAct()
    { 
        EZRE_Search_Candidate_Log_Activation__c objSerachCandLog = new EZRE_Search_Candidate_Log_Activation__c();    
 
           objSerachCandLog.name = 'SearchCandidateLog';
           objSerachCandLog.Activate_Search_Candidate_Log__c = true;        
                
                    insert objSerachCandLog;  
                    return objSerachCandLog;      
    }
    
     ///OBJECTIVE
    /// Insert test data for Requirement object and return the inserted record.
    ///OBJECTIVE
    public static Requirement__c CreateRqmt(string strReqName, string strReqDuration, decimal decMinCost,
                                    decimal decMaxCost, decimal decRate, string strStatus, string strPosition,
                                    string strState, string strIntrviwType, decimal decResumes, string strCity,
                                    string strEasy1, string strUnique1, string strSkillSet, string strRecFeedback)
    {
        Requirement__c objReqmt = new Requirement__c();
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
        //objReqmt.Total_Feedback__c  = strTotalFeedback;
        
        insert objReqmt;
        return objReqmt;
    }
    
    ///OBJECTIVE
    /// Insert test data for Candidate object and return the inserted record.
    ///OBJECTIVE
    public static Candidate__c CreateCand(String strCanName, String strCanLastName, String strCurrentCity,  
                                     String strCurrentState,String strGender,String strEmpName, String  strEmail,  
                                     String strIntrvwContactPhone,String strContractType, String strVisaType,Integer intCost,  
                                     String strMobile,String strContactEmail,  String strEmpCName, String strEmpMobile, 
                                     String strEmplName,String strEmpPhone, String strSkills,boolean face2face,string strAvailableTime)
    {
        Candidate__c objCand = new Candidate__c();
        
        objCand.Name = strCanName;
        objCand.Last_name__c = strCanLastName;
        objCand.Current_city__c = strCurrentCity;
        objCand.Current_state__c = strCurrentState;
        objCand.Gender__c = strGender;
        objCand.Employer_Name__c = strEmpName;
        objCand.Email__c = strEmail;
        objCand.interview_contact_phone__c = strIntrvwContactPhone;
        objCand.Contract_type__c = strContractType;
        objCand.visa_type__c = strVisaType;
        objCand.cost__c = intCost;
        objCand.mobile_phone_no__c = strMobile;
        objCand.employer_contact_email__c = strContactEmail;
        objCand.Employer_Contact_Name_Name__c = strEmpCName;
        objCand.Employer_Mobile_No__c = strEmpMobile;       
        objCand.Employer_Name__c = strEmplName; 
        objCand.Employer_Work_Phone_No__c = strEmpPhone;              
        objCand.Followup_Date__c = date.today();              
        objCand.Skills__c = strSkills;
        objCand.face_to_face__c = face2face;
        objCand.Available_Time__c = strAvailableTime;
        insert objCand;
        return objCand;
    }
    
       /// OBJECTIVE
    /// Insert test data for RequirementAssignment object and return the inserted record. 
    /// OBJECTIVE
    public static RequirementAssignment__c CreateAssignRequirement(id reqId,id lrId,id rId)
    {
        RequirementAssignment__c reqAssign = new RequirementAssignment__c();
        reqAssign.requirement__c = reqId;
        reqAssign.lead_recruiter__c = lrId;
        reqAssign.recruiter__c = rId;
        insert reqAssign;
        return reqAssign;
    }
    
    /// <OBJECTIVE>
    /// Fetches the content library data from ContentWorkspace. 
    /// </OBJECTIVE>        
    public static ContentWorkspace GetContentVersion()
    {
        return [SELECT id FROM ContentWorkspace LIMIT 1];   
              
    }  
    
      /// OBJECTIVE
    /// Insert and return a Content Version record with the given values.
    /// OBJECTIVE
    public static ContentVersion createContentVersion(string strCntntURL, string strTitle, string strCandId, 
                                                        string strPublshLoc)
    {
        ContentVersion testContentInsert = new ContentVersion(); 
        
        testContentInsert.ContentURL=strCntntURL; 
        testContentInsert.Title = strTitle;         
        testContentInsert.Candidate_ID__c=strCandId;
        testContentInsert.firstpublishlocationid=strPublshLoc;
        insert testContentInsert;  
        return testContentInsert;
    }
    
       ///OBJECTIVE
    /// Insert test data for Candidate Mapping object and return the inserted record.
    ///OBJECTIVE
    public static Candidate_Mapping__c CreateCandidateMapng(string strReqmt, string strCandt, string strStatus1,string strLRStats,
                                        string strMRStats, string strEmpAuth,string strLrComments,string strMrComments,string strMrStatus1)
    {
        Candidate_Mapping__c objCandtMapng = new Candidate_Mapping__c();
        objCandtMapng.Requirement__c = strReqmt;
        objCandtMapng.Candidate__c = strCandt;
        objCandtMapng.Status1__c   = strStatus1;
        objCandtMapng.LR_Status__c = strLRStats;
        objCandtMapng.MR_Status__c = strMRStats;
        objCandtMapng.Employer_s_Authorization__c = strEmpAuth;
        objCandtMapng.LR_Comments__c = strLrComments;     
        objCandtMapng.MR_Comments__c = strMrComments;    
        objCandtMapng.MR_Status1__c = strMrStatus1;
        insert objCandtMapng;
        return objCandtMapng;
    } 
    
        ///<OBJECTIVE>
    /// Fetch active user with Lead Recruiter or LR chatter Only User profile.
    ///<OBJECTIVE>
    public static User fetchLRUser()
    {
         return [Select u.Id from User u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User')  and u.IsActive=true limit 1];
    }
    
    ///<OBJECTIVE>
    /// Fetch active user with Lead Recruiter or LR chatter Only User profile.
    ///<OBJECTIVE>
    public static User fetchRUser()
    {
         return [Select u1.Id from User u1 where (u1.Profile.Name ='Recruiter' or u1.Profile.Name ='R Chatter Only User')  and u1.IsActive=true limit 1];
    }
    
    ///<OBJECTIVE>
    /// Fetch user.
    ///<OBJECTIVE>
    public static User fetchUser()
    {
         return [Select Id from User limit 1];
    } 
    
      ///<OBJECTIVE>
    /// Fetch user.
    ///<OBJECTIVE>
    public static EmailTemplate fetchCanAprvlEml()
    {
         return [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Candidate Approval Email with link EZRE'];
    }
    
     ///OBJECTIVE
    /// Insert test data for ContentVersionobject and return the inserted record. 
    ///OBJECTIVE
    public static ContentVersion CreateContentVersion(String strPublshLocationId,id CandId, Blob blobVersionData,
                                            String strPathClient, String strTitle)    
    {            
        ContentVersion objContentVersion = new ContentVersion();  
                
        objContentVersion.FirstPublishLocationId = strPublshLocationId; 
        objContentVersion.Candidate_Id__c = CandId;      
        objContentVersion.VersionData = blobVersionData; 
        objContentVersion.PathOnclient = strPathClient;
        objContentVersion.Title = strTitle;  
        
        insert objContentVersion; 
        return objContentVersion;                    
    }
     ///<OBJECTIVE>
    /// Fetch the organizationWideEmailAddress.
    ///<OBJECTIVE>
    public static OrgWideEmailAddress ftchOEA()
    {
        return [select Id from OrgWideEmailAddress where Address = 'ezre@preludesys.com' limit 1];
    }
    
      ///<OBJECTIVE>
    /// Method to insert and return Account test data.
    ///<OBJECTIVE>    
    public static Account createAccount(string strName,string strAcntStatus,string strWebsite)
    {
        Account objAcnt = new Account();
        objAcnt.Name = strName;       
        objAcnt.Account_Status__c = strAcntStatus;
        objAcnt.Website = strWebsite;
        objAcnt.AnnualRevenue=567;
        objAcnt.Phone='9677273086';
        objAcnt.Lead_Gen_Name__c='Others';
        objAcnt.If_Others_Please_Specify__c='Shahida';
        objAcnt.NumberOfEmployees = 100;
        objAcnt.Industry = 'Technology';
        insert objAcnt ;
        return objAcnt ;
    } 
    
      ///<OBJECTIVE>
    /// Method to insert and return Contact test data without Reports To Id.
    ///<OBJECTIVE> 
    public static Contact crtCntcWithoutRprtsTo(string strFrstName,string strLstname,string strAcntId)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;       
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        insert objCnt ;
        return objCnt ;
    }
    
    
    ///<OBJECTIVE>
    /// Method to insert and return Contact test data.
    ///<OBJECTIVE> 
    public static Contact createContact(string strFrstName,string strLstname,string strAcntId,string WhoId)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.ReportsToId = WhoId;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        insert objCnt ;
        return objCnt ;
    }
    
    ///<OBJECTIVE>
    /// Method to insert and return Task test data.
    ///<OBJECTIVE>
    public static Task createTask(string strSub,string strWhoId,Date dtActvtyDate,String strStatus)
    {
        Task objTsk = new Task();
        objTsk.Subject = strSub;
        objTsk.whoid = strWhoId;
        objTsk.ActivityDate = dtActvtyDate;
        objTsk.Status = strStatus;
        insert objTsk ;
        return objTsk ;
    }
    
    ///<OBJECTIVE>
    /// Method to insert and return Event test data.
    ///<OBJECTIVE>
    public static Event createEvent(String strSubjct,Date dtActvtyDate,string strUsrId,Id strAccntId)
    {
        Event objevnt = new Event();
        objevnt.Subject = strSubjct;
        objevnt.ActivityDate = dtActvtyDate;
        objevnt.OwnerId = strUsrId;       
        
        objevnt.StartDateTime = dtActvtyDate;
        objevnt.EndDateTime = dtActvtyDate;
        objevnt.WhoId = strAccntId;
         
        insert objevnt;
        return objevnt;
    }
    
    
    ///<OBJECTIVE>
    ///Insert records in "Opportunity" standard object and return the inserted opportunity records.
    ///<OBJECTIVE>
    public static Opportunity createOpp(String strName,String strAccId,Date dtCloseDate,String strStageName)
    {
        Opportunity opp = new Opportunity();
        opp.Name = strName; 
        opp.AccountId = strAccId; 
        opp.CloseDate = dtCloseDate; 
        opp.StageName = strStageName;        
        insert opp;
        return opp;
    }
    
    ///<OBJECTIVE>
    ///Insert records in "Initiative" cusotm object and return the inserted record.
    ///<OBJECTIVE>
    public static Initiative__c createInitiative(String strName,Id accntId)
    {
        Initiative__c  objItve = new Initiative__c();
        objItve.Account__c = accntId; 
        //objItve.Name = strName;                
        insert objItve ;
        return objItve ;
    }
    
     ///<OBJECTIVE>
    /// Method to insert and return Account test data.
    ///<OBJECTIVE>    
    public static Account createAcctwthClntPrtnr(string strName,string strAcntStatus,Id clntPrtnrId,string strWebsite)
    {
        Account objAcnt = new Account();
        objAcnt.Name = strName;       
        objAcnt.Account_Status__c = strAcntStatus;
        objAcnt.Client_Partner__c = clntPrtnrId;
        objAcnt.Website = strWebsite;
        objAcnt.AnnualRevenue=546;
        objAcnt.Phone='9677273086';
        objAcnt.Lead_Gen_Name__c='Others';
        objAcnt.If_Others_Please_Specify__c='Shahida';
        objAcnt.Industry = 'Technology';
        objAcnt.NumberofEmployees = 100;
        insert objAcnt ;
        return objAcnt ;
    } 
    
    ///<OBJECTIVE>
    /// Method to insert and return Account test data.
    ///<OBJECTIVE>    
    public static Account fetchAccount(string strId)
    {
        return [Select Id, Name, Client_Partner__c from Account where Id =: strId];
    } 
    
    ///<OBJECTIVE>
    /// Method to insert and return Account test data.
    ///<OBJECTIVE>    
    public static Opportunity fetchOpp(string strId)
    {
        return [Select Id, Name,Execution_Partner__c from Opportunity where Id =: strId];
    } 
    
      ///<OBJECTIVE>
    /// Fetch Opportunity.
    ///<OBJECTIVE>
    public static opportunity getOpp()
    {
         return [select Opportunity.ID from Opportunity LIMIT 1];
    }
    
    
       ///<OBJECTIVE>
    /// Create a test user and return.
    ///<OBJECTIVE>
    Public static User CreateUserWithRole(string Alias,string Email,string EnCoding,string LastName,string LanguageLocaleKey,
                                string LocaleSidKey,string ProfileId,string TimeZoneSidKey,string UserName, String RoleId)
    {
        User usr = new user();
        usr.Alias = Alias;
        usr.Email= Email;          
        usr.EmailEncodingKey=EnCoding;
        usr.LastName=LastName;
        usr.LanguageLocaleKey=LanguageLocaleKey; 
        usr.LocaleSidKey=LocaleSidKey;
        usr.ProfileId = ProfileId; 
        usr.TimeZoneSidKey=TimeZoneSidKey;
        usr.UserName=UserName;
        usr.UserRoleId = RoleId;
        
        insert usr;
        return usr;
    }
    
    //------------------- test methods for Mailchimp batch deletion functionality-----------------
    
      /// <OBJECTIVE>
    /// Fetch the records from UserRole standard object. 
    /// </OBJECTIVE>   
    
  /*   public static Mailchimp_Details__c createMCSettngforDeletion(string strNme, string strAPIKey, string strDmnNme, string strCmpgnId, string strLstId, integer iDltnDays)
    {
        
            Mailchimp_Details__c objMCDtls = new Mailchimp_Details__c();
            objMCDtls.Name = strNme;
            objMCDtls.API_Key__c = strAPIKey;
            objMCDtls.Domain_Name__c = strDmnNme;
            objMCDtls.List_Id__c = strLstId;  
            objMCDtls.Campaign_Id__c = strCmpgnId; 
            objMCDtls.DateforDeletion__c = iDltnDays;          
            insert objMCDtls;
            return objMCDtls;
        
    }
         /// <OBJECTIVE>
         /// Create Mailchimp list
        /// </OBJECTIVE>   
        public static MailchimpListDetails__c createMCList(String Name,String company,String address1,String city,String state,String zip,String country,String permissionRemainder,String fromName,String fromEmail)
        {
        
            MailchimpListDetails__c  listDetailsObj=new MailchimpListDetails__c();
            listDetailsObj.Name=Name;
            listDetailsObj.Company__c=company;
            listDetailsObj.Address1__c=address1;
            listDetailsObj.City__c=city;
            listDetailsObj.State__c=state;
            listDetailsObj.Zip__c=zip;
            listDetailsObj.Country__c=country;
            listDetailsObj.Permission_Reminder__c=permissionRemainder;
            listDetailsObj.From_Name__c=fromName;
            listDetailsObj.From_Email__c=fromEmail;      
            insert listDetailsObj;
            return listDetailsObj;
        
        }*/
        
   public static Account createCampaignAccounts(String strAccName, Id userid)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }     
    
     public static Account createITSACAccounts(String strAccName, Id userid,Boolean IsITSAC)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        acc.ITSAC__c = IsITSAC;
        insert acc;
        return acc;
    }     
    
  /*  public static Account createDBITSAccounts(String strAccName, Id userid,Boolean IsDBITS)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        acc.DBITS__c = IsDBITS;
        insert acc;
        return acc;
    }     
    */
        
        
        
        
    public static Account createVMSaccounts(String strAccName, Id userid, String accountstatus,String strISR)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
      // acc.VMS__c= isActive;
        acc.VMS_Account_Status__c= accountstatus;
        acc.VMS_ISR__c= strISR;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }
    
    public static Contact createVMSContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsVMS)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.VMS__c= IsVMS;
        insert objCnt ;
        return objCnt ;
    }
    
    
    
    
     public static Account createForcecomaccounts(String strAccName, Id userid, String ForcecomStatus,String ForcecomSource,String ForcecomISR,String ForcecomDataStatus,String ForcecomComments)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
        //acc.Force_com__c = IsForcecom;
        acc.Force_com_Account_Status__c = ForcecomStatus;
        acc.Source__c = ForcecomSource;
        acc.Inside_SalesRep__c= ForcecomISR;
        acc.Force_com_Data_Status__c = ForcecomDataStatus;
        acc.Force_com_Data_Status_Comments__c = ForcecomComments;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }
    
    
     public static Contact createForcecomContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsForcecom)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        
        objCnt.Number_Validation__c='Board Correct';
        objcnt.Force_com__c= IsForcecom;
        
        
        insert objCnt ;
        return objCnt ;
    }
    
    
     public static Contact createForcecomContactonly(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsForcecom,boolean IsAWS)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        
        objCnt.Number_Validation__c='Board Correct';
        objcnt.Force_com__c= IsForcecom;
        objcnt.ODS_AWS__c= IsAWS;
        objcnt.Status__c= '2d: Call later';
        
        insert objCnt ;
        return objCnt ;
    }
    
    
    
    
    
    
    
    
    public static Account createAWSaccounts(String strAccName, Id userid, String AWSStatus,String AWSSource,String AWSISR,String AWSDataStatus,String AWSDataComments)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
       // acc.ODS_AWS__c = IsAWS;
        acc.AWS_Account_source__c = AWSSource;
        acc.ODS_AWS_Data_Status_Comments__c = AWSDataComments;
        acc.ODS_AWS_Inside_SalesRep__c = AWSISR;
        acc.ODS_AWS_Account_Status__c = AWSStatus;
        acc.ODS_AWS_Data_Status__c = AWSDataStatus;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }
    
     public static Contact createAWSContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsAWS)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.ODS_AWS__c= IsAWS;
       
        insert objCnt ;
        return objCnt ;
    }
    
      public static Contact createAWSContactonly(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsForcecom,boolean IsAWS)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        
        objCnt.Number_Validation__c='Board Correct';
        objcnt.Force_com__c= IsForcecom;
        objcnt.ODS_AWS__c= IsAWS;
        objcnt.ODS_AWS_Status__c= '2d: Call later';
        
        insert objCnt ;
        return objCnt ;
    }
    
    public static Contact createbothContacts(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsForcecom,boolean IsAWS)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        
        objCnt.Number_Validation__c='Board Correct';
        objcnt.Force_com__c= IsForcecom;
        objcnt.ODS_AWS__c= IsAWS;
        objcnt.ODS_AWS_Status__c= '2d: Call later';
        objcnt.Status__c= '2a: Connected - Not Interested';
        insert objCnt ;
        return objCnt ;
    }
    
    
    
     public static Account createDotNetaccounts(String strAccName, Id userid , String DotNetStatus,String DotNetISR,String DotNetDataStatus,String DotNetDataComments)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
      //  acc.ODSDotNet__c = IsDotNet;
        acc.ODSDotNet_Account_Status__c = DotNetStatus;
        acc.ODSDotNet_Inside_Sales_Rep__c = DotNetISR;
        acc.ODSDotNet_Data_Status__c = DotNetDataStatus;
        acc.ODSDotNet_Data_Status_Comments__c = DotNetDataComments;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }
    
     public static Contact createDotNetContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsDotNet)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.ODSDotNet__c= IsDotNet;
        insert objCnt ;
        return objCnt ;
    }
    
    
    
    
    
    
     public static Account create500hourpromotionaccounts(String strAccName, Id userid, String HourpromotionStatus,String HourpromotionISR,String HourpromotiondataComments)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
       // acc.Staffing_Promotion__c = Ishourpromotion;
        acc.Staffing_Promotion_Account_Status__c = HourpromotionStatus;
        
        acc.Staffing_Promotion_Inside_Sales_Rep__c = HourpromotionISR;
   
        acc.Staffing_Promotion_Data_Comments__c = HourpromotiondataComments;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }
    
    
     public static Contact createHourPromotionContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean Ishourpromotion)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.free500hrs__c= Ishourpromotion;
        insert objCnt ;
        return objCnt ;
    }
    
    
    
    
    
    
     public static Account createKPOaccounts(String strAccName, Id userid, String KPOStatus)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
        //acc.KPO__c = IsKPO;
        acc.KPO_Account_Status__c = KPOStatus;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }
    
     public static Contact createKPOContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsKPO)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.KPO__c= IsKPO;
        insert objCnt ;
        return objCnt ;
    }
    
    
    
    
    
    
     public static Account createTurnsliftaccounts(String strAccName, Id userid, String TurnsliftStatus)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        acc.AnnualRevenue=879;
        acc.Executive_Summary__c='test executive summary for test lead  ';
        acc.Phone='9677273086';
        acc.Lead_Gen_Name__c='Others';
        acc.If_Others_Please_Specify__c='Shahida';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 100;
        acc.OwnerId= userid;
        //acc.TurnsLift__c = IsTurnslift;
        acc.Turnslift_Account_Status__c = TurnsliftStatus;
        acc.NumberOfEmployees=20;
        acc.AnnualRevenue=200;
        acc.Description='test prelude contact';   
        insert acc;
        return acc;
    }
    
    
    public static Contact createTurnsliftContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsTurnslift)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.TurnsLift__c= IsTurnslift;
        objcnt.Turnslift_Account_Status__c= '2e: Do Not Call';
        insert objCnt ;
        return objCnt ;
    }
   
   
   
    
    public static Contact createISR2Contact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
       // objCnt.Account.Executive_Summary__c='test executive summary for test lead  ';
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
      
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        objCnt.Inside_SalesRep__c='Ashok Mani';   
        objCnt.Number_Validation__c='Board Correct';
      
        insert objCnt ;
        return objCnt ;
    }
    
    
    public static Contact createholidaycardsContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean Isholidaycards)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.Holiday_Cards__c = Isholidaycards;
        insert objCnt ;
        return objCnt ;
    }
    
    
    public static Contact createGLIXContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsGLIX)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        
        objCnt.Number_Validation__c='Board Correct';
        objcnt.GLIX__c = IsGLIX;
        insert objCnt ;
        return objCnt ;
    }
    
    
    public static Contact createAnBContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsAnB)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.AnB__c = IsAnB;
        insert objCnt ;
        return objCnt ;
    }
    
     public static Contact createADMContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsADM)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
       
        objCnt.Number_Validation__c='Board Correct';
        objcnt.ADM__c = IsADM;
        insert objCnt ;
        return objCnt ;
    }
    
    public static Contact createDataStaxContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsDatastax)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
          
        objCnt.Number_Validation__c='Board Correct';
        objcnt.DataStax__c = IsDatastax;
        insert objCnt ;
        return objCnt ;
    }
    
    public static Contact createLegModContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsLegMod)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
         
        objCnt.Number_Validation__c='Board Correct';
        objcnt.LegMod__c = IsLegMod;
        insert objCnt ;
        return objCnt ;
    }
    
     public static Contact createMiniFoxMascoWBContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsMiniFox,String strstatus,String strISR)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        
        objCnt.Number_Validation__c='Board Correct';
        objcnt.Mini_FOX_Masco_W_B__c = IsMiniFox;
        objcnt.Mini_FOX_Masco_W_B_Status__c = strstatus;
        objcnt.Mini_FOX_Masco_W_B_ISR__c = strISR;
        insert objCnt ;
        return objCnt ;
    }
    
    
    public static Contact createDISContact(string strFrstName,string strEmail,string strLstname,string strAcntId,String strAccountName,boolean isConverted,boolean IsDIS)
    {
        Contact objCnt = new Contact();
        objCnt.FirstName = strFrstName;
        objCnt.LastName = strLstname;
        objCnt.AccountId  = strAcntId;
        objCnt.IsContactConvertedtoLead__c=isConverted;
        objCnt.Lead_Gen_Name__c='Others';
        objCnt.If_Others_Please_Specify__c='Shahida';
        objCnt.Description='long text test desription for contact';
        objCnt.Salutation='Mr.';
        objCnt.Title='A';
        objCnt.MobilePhone='9124345678';
        objCnt.Phone='9123445678';
        objCnt.Email=strEmail;
        objCnt.HasOptedOutOfEmail=false;        
        objCnt.LeadSource='Web';
        
        objCnt.Number_Validation__c='Board Correct';
        objcnt.DIS__c = IsDIS;
        insert objCnt ;
        return objCnt ;
    }
    
    public static Task createTasktoleads(string strSub,string strWhoId,Date dtActvtyDate,String strStatus,Id ownerid,Boolean IsTrue)
    {
        Task objTsk = new Task();
        objTsk.Subject = strSub;
        objTsk.whoid = strWhoId;
        objTsk.ActivityDate = dtActvtyDate;
        objTsk.Status = strStatus;
        objTsk.Priority ='Normal';
        objTsk.OwnerId = ownerid;
        objTsk.IsTaskMovedtoLead__c=IsTrue;
        insert objTsk ;
        return objTsk ;
    }
    public static Campaign createcampaignstoleads(string strCampaignName)
    {
        Campaign objcam = new Campaign();
        objcam.Name = strCampaignName;
        objcam.Status='Planned';
        objcam.Type= 'Email';
        objcam.IsActive =true;
        objcam.Description='this is an active test camapign by preludesys';
        insert objcam ;
        return objcam ;
    }
    
     public static Lead createLeadwithcampaignmember(String strfirstname,String strlastname,String strleadgenname,String strstatus,String strcompany,String strwebsite)
    {
        Lead objlead = new Lead();
        objlead.FirstName= strfirstname;
        objlead.LastName=strlastname;
        objlead.Lead_Gen_Name__c= strleadgenname;
        objlead.Status=strstatus;
        objlead.Company=strcompany;
        objlead.Website=strwebsite;
        objlead.IsContactConvertedasLead__c=true;
        insert objlead;
        return objlead;
    }
    
    public static Lead createLeadToConvert(String strlastname,String strleadgenname,String strstatus,String strcompany,String strwebsite,String phone,Integer NumberOfEmployees,Integer AnnualRevenue,String Industry)
    {
        Lead lead = new Lead();
        lead.LastName=strlastname;
        lead.Lead_Gen_Name__c= strleadgenname;
        lead.Status=strstatus;
        lead.Company=strcompany;
        lead.Website=strwebsite;
        lead.Phone = phone;
        lead.NumberOfEmployees = NumberOfEmployees;
        lead.AnnualRevenue = AnnualRevenue;
        lead.Industry = Industry;
        insert lead;
        return lead;
    } 
    
    public static CampaignMember createcampaignmember(Id LeadId,String strstatus,Id CampaignId)
    {
        CampaignMember objCamMem = new CampaignMember();
        objCamMem.LeadId= LeadId;
        objCamMem.Status=strstatus;
        objCamMem.CampaignId= CampaignId;
        insert objCamMem;
        return objCamMem;
    }
    
    public static CampaignMember createcampaignmembers(Id LeadId,String run,String strstatus,Id CampaignId)
    {
        CampaignMember objCamMem = new CampaignMember();
        objCamMem.LeadId= LeadId;
        objCamMem.Run__c = run;
        objCamMem.Status=strstatus;
        objCamMem.CampaignId= CampaignId;
        insert objCamMem;
        return objCamMem;
    }
         
}