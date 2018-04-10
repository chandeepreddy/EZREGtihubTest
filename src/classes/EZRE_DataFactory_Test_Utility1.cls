/**
 * @author           Indhu
 * @version          1.0 
 * @date             10-Dec-2014
 * @Status           Developed
 * @description      Data Factory Test Utility Class is a utility class which includes test data for test classes.
 *
 */
@isTest
public class EZRE_DataFactory_Test_Utility1
{ 
    
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
        
        insert objReqmt;
        return objReqmt;
    }
    ///OBJECTIVE
    /// Insert test data for Requirement object and return the inserted record.
    ///OBJECTIVE
    public static Requirement__c CreateRequirement(string strReqName, string strReqDuration, decimal decMinCost,
                                    decimal decMaxCost, decimal decRate, string strStatus, string strPosition,
                                    string strState, string strIntrviwType, decimal decResumes, string strCity,
                                    string strEasy1, string strUnique1, string strSkillSet, string strRecFeedback,boolean won)
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
        objReqmt.Won__c = won;
        insert objReqmt;
        return objReqmt;
    }
    
    ///OBJECTIVE
    /// Insert test data for Candidate object and return the inserted record.
    ///OBJECTIVE
    public static Candidate__c CreateCandidate(String strCanName, String strCanLastName, String strCurrentCity,  
                                     String strCurrentState,String strGender,String strEmpName, String  strEmail,  
                                     String strIntrvwContactPhone,String strContractType, String strVisaType,Integer intCost,  
                                     String strMobile,String strContactEmail,  String strEmpCName, String strEmpMobile, 
                                     String strEmplName,String strEmpPhone, String strSkills)
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
        
        insert objCand;
        return objCand;
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
    
    ///OBJECTIVE
    /// Insert test data for ContentVersionobject and return the inserted record. 
    ///OBJECTIVE
    public static ContentVersion CreateContVersion(String strPublshLocationId, Blob blobVersionData,
                                            String strPathClient, String strTitle)    
    {            
        ContentVersion objContentVersion = new ContentVersion();          
        objContentVersion.FirstPublishLocationId = strPublshLocationId;       
        objContentVersion.VersionData = blobVersionData; 
        objContentVersion.PathOnclient = strPathClient;
        objContentVersion.Title = strTitle;  
        
        insert objContentVersion; 
        return objContentVersion;                    
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
    
    ///OBJECTIVE
    /// Insert test data for UserRole object and return the inserted record.
    ///OBJECTIVE
    public static UserRole CreateUserRole(String strName)    
    {
        UserRole objUserRole = new UserRole();
        objUserRole.Name = strName;         
        
        insert objUserRole;
        return objUserRole;          
    }
    
    ///OBJECTIVE
    /// Insert test data for User object and return the inserted record.
    ///OBJECTIVE
    public static User CreateUser(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,Boolean blIsActive, String strUserRole)    
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
        objUser.IsActive = blIsActive;
        objUser.UserRoleId = strUserRole;
        
        insert objUser;
        return objUser;
    }
    
    
    ///OBJECTIVE
    /// Insert test data for User object and return the inserted record.
    ///OBJECTIVE
    public static User CreateUsers(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,Boolean blIsActive)    
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
        objUser.IsActive = blIsActive;
        
        insert objUser;
        return objUser;
    }
    
    ///OBJECTIVE
    /// Insert test data for Candidate Mapping object and return the inserted record.
    ///OBJECTIVE
    public static Candidate_Mapping__c CreateCandtMapng(string strReqmt, string strCandt, string strLRStats,
                                        string strMRStats, string strEmpAuth)
    {
        Candidate_Mapping__c objCandtMapng = new Candidate_Mapping__c();
        objCandtMapng.Requirement__c = strReqmt;
        objCandtMapng.Candidate__c = strCandt;
        objCandtMapng.LR_Status__c = strLRStats;
        objCandtMapng.MR_Status__c = strMRStats;
        objCandtMapng.Employer_s_Authorization__c = strEmpAuth;
        
        insert objCandtMapng;
        return objCandtMapng;
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
    ///OBJECTIVE
    /// Insert test data for Hot List Custom setting and return the inserted record.
    ///OBJECTIVE
    public static EZRE_HotListUsers__c CreateHotListCustomSetting(string strName,string strCCUsr,string strToUsr)
    {
        EZRE_HotListUsers__c objHotList = new EZRE_HotListUsers__c();
        objHotList.Name = strName;
        objHotList.HotList_CCUsers__c = strCCUsr;
        objHotList.HotList_toUsers__c = strToUsr;
        
        insert objHotList;
        return objHotList;
    }   
    
    /// <OBJECTIVE>
    /// Fetches the content library data from ContentWorkspace. 
    /// </OBJECTIVE>        
    public static ContentWorkspace GetContentVersion()
    {
        return [SELECT id FROM ContentWorkspace LIMIT 1];   
              
    }  
    
    /// <OBJECTIVE>
    /// Fetches the profile data from Profile. 
    /// </OBJECTIVE> 
    public static Profile GetProfile()
    {
        return [SELECT Id FROM Profile LIMIT 1];   
    } 
     /// <OBJECTIVE>
    /// Fetches the profile data from Profile. 
    /// </OBJECTIVE> 
    public static Profile GetParticularProfile(string strProfileName)
    {
        return [SELECT Id,name FROM Profile where name =:strProfileName LIMIT 1];   
    } 
     
     public static Candidate__c InsertCandidate(String strCanName, String strCanLastName, String strCurrentCity,  
                                     String strCurrentState,String strGender,String strEmpName, String  strEmail,  
                                     String strIntrvwContactPhone,String strContractType, String strVisaType,Integer intCost,  
                                     String strMobile,String strContactEmail,  String strEmpCName, String strEmpMobile, 
                                     String strSkills,boolean bench,string strRelocation,string strAvailability)
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
        objCand.bench__c = bench;
        objCand.Relocation__c = strRelocation;
        objCand.Availability__c = strAvailability;
        objCand.Skills__c = strSkills;
        insert objCand;
        return objCand;
    }
    public static User fetchUser(Boolean active)
    {
        return [Select Id from User where IsActive =:active limit 1];
    } 
    
    public static EmailTemplate fetchTemplate(string tempName)
    {
        return [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name =:tempName];
    } 
    public static Candidate_Mapping__c InsertCandMapng(string Status,string EmailAuth,string LrComments,string MrComments,string ReqOwnerEmail,
                                                       string MangEmailId,string RComments,string LRStatus,string MrStatus,string LRStatusDate,
                                                       string MRStatusDate,string SubToclient,string InterviewSchd,string IntAccepted,string ClientInterviewed,
                                                       string ClientOffered,string CandStarted,string Comments,Date ContEndDate,Id ReqId,Id CandtId)
    {
        Candidate_Mapping__c coa =new Candidate_Mapping__c();

            coa.status1__c = Status;
            coa.Employer_s_Authorization__c = EmailAuth;
            coa.LR_Comments__c = LrComments;
            coa.MR_Comments__c = MrComments;
            coa.Requirement_Owner_Email__c = ReqOwnerEmail;
            coa.Manager_Email_ID__c = MangEmailId;
            coa.R_Comments__c = RComments;
            coa.LR_Status__c = LRStatus;
            coa.MR_Status__c = MrStatus;
            coa.LR_Status_Date__c = LRStatusDate;
            coa.MR_Status_Date__c = MRStatusDate;
            coa.Submitted_to_Client__c = SubToclient;
            coa.Interview_Scheduled__c = InterviewSchd;
            coa.Interview_Accepted__c = IntAccepted;
            coa.Client_Interviewed__c = ClientInterviewed;
            coa.Client_Offered__c = ClientOffered;
            coa.Candidate_started__c = CandStarted;
            coa.Comments__c = Comments;
            coa.Contract_End_Date__c = ContEndDate;
            coa.Requirement__c=ReqId;
            coa.Candidate__c=CandtId;
            
                insert coa;
                return coa;
    }   
    
   ///OBJECTIVE
    /// Insert test data for RequirementAssignment object and return the inserted record. 
    ///OBJECTIVE
    public static RequirementAssignment__c CreateAssignRequirement(id reqId,id lrId,id rId)
    {
        RequirementAssignment__c reqAssign = new RequirementAssignment__c();
        reqAssign.requirement__c = reqId;
        reqAssign.lead_recruiter__c = lrId;
        reqAssign.recruiter__c = rId;
       insert reqAssign;
       return reqAssign;
    }
    ///OBJECTIVE
    /// Insert test data for RequirementAssignment object and return the inserted record. 
    ///OBJECTIVE
    public static RequirementAssignment__c CreateAssignReq(id reqId,id rId)
    {
        RequirementAssignment__c reqAssign = new RequirementAssignment__c();
        reqAssign.requirement__c = reqId;
        reqAssign.recruiter__c = rId;
       insert reqAssign;
       return reqAssign;
    }
    
    //OBJECTIVE
    /// Insert test data for User object and return the inserted record.
    ///OBJECTIVE
    public static User CreateUserMgr(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,Boolean blIsActive, String strUserRole,User strMgr)    
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
        objUser.IsActive = blIsActive;
        objUser.UserRoleId = strUserRole;
        objUser.Manager = strMgr;
        
        insert objUser;
        return objUser;
    }
   
    
    public static candidate__c createCandidateReqmt(string strName, string strLastName, string strCity, 
                    string strState, string strGender, string strEmpName, string strEmail, string strIntCont,
                    string strContract, string strVisa, Integer intCost, string strMobile, string strEmpContEmail,
                     string strEmpContName, string strEmpMob)
    {
        candidate__c cc1 = new candidate__c();
        cc1.Name=strName;
        cc1.last_name__c=strLastName;
        cc1.current_city__c=strCity;
        cc1.current_state__c=strState;
        cc1.gender__c=strGender;
        cc1.Employer_Name__c=strEmpName;
        cc1.email__c=strEmail;
        cc1.interview_contact_phone__c=strIntCont;
        cc1.contract_type__c=strContract;
        cc1.visa_type__c=strVisa;
        cc1.cost__c =intCost;
        cc1.mobile_phone_no__c=strMobile;
        cc1.employer_contact_email__c=strEmpContEmail;
        cc1.Employer_Contact_Name_Name__c=strEmpContName;
        cc1.Employer_Mobile_No__c=strEmpMob;
        
        insert cc1; 
        return cc1;
    }
    
    public static requirement__c createReqmtCandt(string strName, string strJobTitle, string strDuaration,
                        Integer intResumes,Integer intMinCost, Integer intMaxCost, Integer intRate, 
                        string strRateBasis, string strStatus, string strPosition,string strState,
                        string strCity,Boolean isWon, Boolean isReopen)
    {
        requirement__c rc1= new requirement__c();
        
        rc1.Name=strName;
        //rc1.Job_Title__c = strJobTitle;        
        rc1.Duration__c = strDuaration;
        rc1.No_Of_Resumes__c = intResumes;
        rc1.Min_Cost__c = intMinCost;
        rc1.Max_Cost__c = intMaxCost;
        rc1.Rate__c = intRate;
        rc1.Rate_Basis__c = strRateBasis;
        rc1.Status__c = strStatus;
        rc1.Position_Type__c = strPosition;
        rc1.State__c = strState;
        rc1.City__c = strCity;
        rc1.Est_Start_Date__c = date.today();
        rc1.won__c = isWon;
        rc1.isReopen__c = isReopen;
        
        insert rc1;
        return rc1;
    }
    
    public static ContentWorkspace getContentWorkSpace(string strName)
    {
        return [SELECT Id FROM ContentWorkspace WHERE Name =: strName];
    }
    
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
}