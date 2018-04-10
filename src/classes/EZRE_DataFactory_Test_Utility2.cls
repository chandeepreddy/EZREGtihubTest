/**
 * @author           Keerthi Chandra
 * @version          1.0 
 * @date             12/10/2014
 * @Status           Developed
 * @description      Test Utility Class is a public test class that contain reusable code for test data creation.
 *
 */
@isTest
public class EZRE_DataFactory_Test_Utility2
{ 
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
    
    ///OBJECTIVE
    /// Insert records in "Candidate" custom object and return the inserted candidate record.
    ///OBJECTIVE
    public static Candidate__c  createCand(String strCanName, String strCanLastName, String strCurrentCity, String strCurrentState, String strGender,
                                             String strEmpName, String  strEmail, String strIntrvwContactPhone, String strContractType, String strVisaType,
                                             Integer intCost, String strMobile, String strContactEmail,  String strEmpCName, String strEmpMobile, String strEmplName,
                                             String strEmpPhone, Date dtDate)
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
                    insert can;  
                    return can;      
    }
    
    ///OBJECTIVE
    /// Insert records in "Candidate" custom object and return the inserted candidate record.
    ///OBJECTIVE
    public static Candidate__c  createCanWRes(String candId,String strCanName, String strCanLastName, String strCurrentCity, String strCurrentState, String strGender,
                                             String strEmpName, String  strEmail, String strIntrvwContactPhone, String strContractType, String strVisaType,
                                             Integer intCost, String strMobile, String strContactEmail,  String strEmpCName, String strEmpMobile, String strEmplName,
                                             String strEmpPhone, Date dtDate, String strSkills, String strReloc, String strAvailbl, Date dtCanContrctEndDt,String strRes)
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
                    can.Resume_Attach__c  = strRes;
                    insert can;  
                    return can;      
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
  
     ///OBJECTIVE
    /// Insert records in "Requirement" custom object and return the inserted requirement record.
    ///OBJECTIVE
    public static Requirement__c createReqrmnt(String strName,String strJobTitl,String strDuration,
                                                Integer intNoResumes,Integer intMinCost,Integer intMaxCost,
                                                Integer intRate,String strRateBasis,String strStatus,String strPostnType,
                                                String strState,String strCity,Date dtEstStrtDate,Boolean blReqWon,string strEasy1)
    
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
                    insert req; 
                    return req;           
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
    /// Fetch the lead recruiter profile data from Profile standard object. 
    /// </OBJECTIVE>    
    
    public static Profile fetchProfile()
    {
        return [SELECT Id FROM Profile WHERE Name ='Lead Recruiter'];   
    }  
    
     /// <OBJECTIVE>
    /// Fetch the System Admin profile data from Profile standard object. 
    /// </OBJECTIVE>    
    
    public static Profile fetchProfileSysAdmn()
    {
        return [SELECT Id FROM Profile WHERE Name ='System Administrator'];   
    }  
    
    ///<OBJECTIVE>
    ///Fetch the "Candidate Approval Email with link EZRE" email template.
    ///</OBJECTIVE>
    public static EmailTemplate fetchET()
    {
        return [Select Id, Name, Subject, HtmlValue, Body from EmailTemplate where Name =: 'Candidate Approval Email with link EZRE'];
    }
    
    ///<OBJECTIVE>
    ///Fetch the content workspace library.
    ///</OBJECTIVE>
    public static ContentWorkspace fetchContntWS()
    {
        return [SELECT id FROM ContentWorkspace LIMIT 1];
    }
    ///OBJECTIVE
    /// Insert records in "User" standard object and return the inserted user record.
    ///OBJECTIVE
    public static User createUser(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,Boolean blIsActv)
    
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
                    objUser.IsActive = blIsActv;
                    insert objUser;
                    return objUser;

    }
    
    
    ///OBJECTIVE
    /// Insert records in "User" standard object and return the inserted user record.
    ///OBJECTIVE
    public static User createUserWRole(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName,
                                  String strPhone,String strUsrRole)
    
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
                    objUser.UserRoleId = strUsrRole;
                    insert objUser;
                    return objUser;

    }
    
    ///OBJECTIVE
    ///Insert records in the "Assign Candidate" custom object and return the inserted record.
    ///OBJECTIVE
    
    public static Candidate_Mapping__c createCandMap(String strCan, String strCanStarted, 
                                             String strClntIntrviwd, String strClntOffered, String strComments,
                                             Date dtContrctEndDt, String strEmpAuth, String strIntrvwAccptd,
                                             String strIntrvwSchdl,Boolean blCandAdded, String strReq, String strMRStatus)
    {
        Candidate_Mapping__c canMap = new Candidate_Mapping__c();
        canMap.Candidate__c = strCan;
        canMap.Candidate_started__c = strCanStarted;
        canMap.Client_Interviewed__c = strClntIntrviwd;  
        canMap.Client_Offered__c = strClntOffered;
        canMap.Comments__c = strComments;
        canMap.Contract_End_Date__c = dtContrctEndDt;
        canMap.Employer_s_Authorization__c = strEmpAuth;
        canMap.Interview_Accepted__c = strIntrvwAccptd;
        canMap.Interview_Scheduled__c = strIntrvwSchdl;
        canMap.Is_Candidate_Added__c = blCandAdded;
        canMap.Requirement__c = strReq;
        canMap.MR_Status__c = strMRStatus;
        insert canMap;
        return canMap;
    }
    ///OBJECTIVE
    ///Insert records in the "Assign Candidate" custom object and return the inserted record.
    ///OBJECTIVE
    
    public static Candidate_Mapping__c createCandMapping(String strStatus,String strAuth,String strLRComm,
                                                         String strMRComm,String strReqOwnrEml,String strMngrEmail,
                                                         String strRComm,String strLRSts,String strMRSts,
                                                         String strLRDate,String strMRdate,String strCan,String strReq)
    {
        Candidate_Mapping__c canMap = new Candidate_Mapping__c();
        canMap.status1__c = strStatus;
        canMap.Employer_s_Authorization__c= strAuth;
        canMap.LR_Comments__c= strLRComm;  
        canMap.MR_Comments__c = strMRComm;
        canMap.Requirement_Owner_Email__c= strReqOwnrEml;
        canMap.Manager_Email_ID__c= strMngrEmail;
        canMap.R_Comments__c= strRComm;
        canMap.LR_Status__c= strLRSts;
        canMap.MR_Status__c= strMRSts;
        canMap.LR_Status_Date__c= strLRDate;
        canMap.MR_Status_Date__c = strMRdate;
        canMap.Candidate__c = strCan;
        canMap.Requirement__c = strReq;
        insert canMap;
        return canMap;
    } 
    
   ///OBJECTIVE
    ///Insert records in the "Assign Candidate" custom object and return the inserted record.
    ///OBJECTIVE
    
    public static Candidate_Mapping__c createCandMappingWDts(String strAuth,String strLRComm,
                                                         String strMRComm,String strReqOwnrEml,String strMngrEmail,
                                                         String strRComm,String strLRSts,String strMRSts,
                                                         String strLRDate,String strMRdate,String strSubmtd,
                                                         String strSbmtdToClnt,String strIntrvwSchdl,String strIntrvwSchdlDt,
                                                         String strIntrvwAccptd,String strIntrvwAcptd,String strClntIntrvwd,
                                                         String strClntIntrvwDt,String strClntOffrd,String strClntOffrdDt,
                                                         String strSts,String strCandStrtd,String strComm,String strMRStats,
                                                         String strStrtdDate,String strCan,String strReq)
    {
        Candidate_Mapping__c canMap = new Candidate_Mapping__c();
        canMap.Employer_s_Authorization__c= strAuth;
        canMap.LR_Comments__c= strLRComm;  
        canMap.MR_Comments__c = strMRComm;
        canMap.Requirement_Owner_Email__c= strReqOwnrEml;
        canMap.Manager_Email_ID__c= strMngrEmail;
        canMap.R_Comments__c= strRComm;
        canMap.LR_Status__c= strLRSts;
        canMap.MR_Status__c= strMRSts;
        canMap.LR_Status_Date__c= strLRDate;
        canMap.MR_Status_Date__c = strMRdate;
        canMap.Submitted_to_Client__c = strSubmtd;
        canMap.Submitted_to_Client_Date__c = strSbmtdToClnt;
        canMap.Interview_Scheduled__c = strIntrvwSchdl;
        canMap.Interview_Scheduled_Date__c = strIntrvwSchdlDt;
        canMap.Interview_Accepted__c = strIntrvwAccptd;
        canMap.Interview_Accepted_Date__c = strIntrvwAcptd;
        canMap.Client_Interviewed__c = strClntIntrvwd;
        canMap.Client_Interview_Date__c = strClntIntrvwDt;
        canMap.Client_Offered__c = strClntOffrd;
        canMap.Client_Offer_Date__c = strClntOffrdDt;
        canMap.status1__c = strSts;
        canMap.Candidate_started__c = strCandStrtd;
        canMap.Comments__c = strComm;
        canMap.MR_Status1__c = strMRStats;
        canMap.started_date__c = strStrtdDate;
        canMap.Candidate__c = strCan;
        canMap.Requirement__c = strReq;
        insert canMap;
        return canMap;
    }  
    
    
    ///OBJECTIVE
    ///Update records in the "Asign Candidate" custom object and return the inserted record.
    ///OBJECTIVE
    
    public static Candidate_Mapping__c updateCanMap(String strCan, String strCanStarted, 
                                             String strClntIntrviwd, String strClntOffered, String strComments,
                                             Date dtContrctEndDt, String strEmpAuth, String strIntrvwAccptd,
                                             String strIntrvwSchdl,Boolean blCandAdded, String strReq, String strMRStatus)
    {
        Candidate_Mapping__c canMap = new Candidate_Mapping__c();
        canMap.Candidate__c = strCan;
        canMap.Candidate_started__c = strCanStarted;
        canMap.Client_Interviewed__c = strClntIntrviwd;  
        canMap.Client_Offered__c = strClntOffered;
        canMap.Comments__c = strComments;
        canMap.Contract_End_Date__c = dtContrctEndDt;
        canMap.Employer_s_Authorization__c = strEmpAuth;
        canMap.Interview_Accepted__c = strIntrvwAccptd;
        canMap.Interview_Scheduled__c = strIntrvwSchdl;
        canMap.Is_Candidate_Added__c = blCandAdded;
        canMap.Requirement__c = strReq;
        canMap.MR_Status__c = strMRStatus;
        Update canMap;
        return canMap;
    } 
    
    
    
    
    
    ///OBJECTIVE
    ///Insert records in the "Asign Candidate" custom object and return the inserted record.
    ///OBJECTIVE
    
    public static Candidate_Mapping__c createAssignCand(String strCan, String strMngrEmail, String strStatus,
                                                        String strEmpAuth,String strLRCommnts, String strMRCommnts,
                                                        String strReqOwnrEmail, String strReq, String strCandStrtd) 
    {
        Candidate_Mapping__c canMap = new Candidate_Mapping__c();
        canMap.Candidate__c = strCan;
        canMap.Manager_Email_ID__c = strMngrEmail;
        canMap.status1__c = strStatus;  
        canMap.Employer_s_Authorization__c = strEmpAuth;
        canMap.LR_Comments__c = strLRCommnts;
        canMap.MR_Comments__c = strMRCommnts;
        canMap.Requirement_Owner_Email__c = strReqOwnrEmail;
        canMap.Requirement__c = strReq;
        canMap.Candidate_started__c = strCandStrtd;
        insert canMap;
        return canMap;
    } 
    
    ///OBJECTIVE
    ///Insert records in the "Asign Candidate" custom object and return the inserted record.
    ///OBJECTIVE
    
    public static Candidate_Mapping__c createAssigCand(String strCan, String strMngrEmail, String strStatus,
                                                        String strEmpAuth,String strLRCommnts, String strMRCommnts,
                                                        String strReqOwnrEmail, String strReq) 
    {
        Candidate_Mapping__c canMap = new Candidate_Mapping__c();
        canMap.Candidate__c = strCan;
        canMap.Manager_Email_ID__c = strMngrEmail;
        canMap.status1__c = strStatus;  
        canMap.Employer_s_Authorization__c = strEmpAuth;
        canMap.LR_Comments__c = strLRCommnts;
        canMap.MR_Comments__c = strMRCommnts;
        canMap.Requirement_Owner_Email__c = strReqOwnrEmail;
        canMap.Requirement__c = strReq;
        insert canMap;
        return canMap;
    }
    
    ///<OBJECTIVE>
    ///Fetch the record from asign candidate
    ///<PBJECTIVE>
    public static Candidate_Mapping__c  fetchCanMap(String strCan, String strReq)
    {
        return [Select Id,Status1__c, LR_Status__c, MR_Status__c from Candidate_Mapping__c where Candidate__c =: strCan and Requirement__c  =: strReq limit 1];
    }
    
    ///<OBJECTIVE>
    ///Fetch the record from asign candidate
    ///<PBJECTIVE>
    public static Candidate_Mapping__c  fetchCanMapRec(String strCandAss)
    {
        return [SELECT ID,CREATEDBYID,Added_User__c FROM Candidate_Mapping__c WHERE ID =: strCandAss];
    }
    
    ///<OBJECTIVE>
    ///Fetch the record from asign candidate
    ///<PBJECTIVE>
    public static CronTrigger fetchCronTriggr(String strJob)
    {
        return [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id =: strJob];
    }
    
    ///<OBJECTIVE>
    ///Fetch content workspace resumes.
    ///<OBJECTIVE>
    public static ContentWorkspace fetchCntntResumes() 
    {
        //return [SELECT Id FROM ContentWorkspace WHERE Name = 'Resumes'];
        return [SELECT Id FROM ContentWorkspace  LIMIT 1];
    }
    
    ///<OBJECTIVE>
    ///Fetch content workspace resumes.
    ///<OBJECTIVE>
    public static ContentWorkspace fetchCntntResum() 
    {
       return [SELECT Id FROM ContentWorkspace WHERE Name = 'Resumes' LIMIT 1];
        
    }
        
    ///OBJECTIVE
    /// Insert records in "Account" standard object and return the inserted account record.
    ///OBJECTIVE
    public static Account createAcc(String strName)
    
    {
          Account objAcc = new Account();
          objAcc.Name = strName;
          objAcc.AnnualRevenue=567;
          objAcc.Phone='9677273086';
          objAcc.Lead_Gen_Name__c='Others';
          objAcc.If_Others_Please_Specify__c='Shahida';
          objAcc.Industry = 'Technology';
          objAcc.NumberOfEmployees = 100;
          insert objAcc;
          return objAcc;
    }
    
    
    ///<OBJECTIVE>
    ///Insert records in "Opportunity" standard object and return the inserted opportunity records.
    ///<OBJECTIVE>
    public static Opportunity createOpp(String strName,String strAccId,Date dtCloseDate,String strStageName,
                                    String strTitle,Integer intProjVal,String strTeamSize,String strProjDur,
                                    String strTechUsed,String strProjDesc,String strWin,String strComp,String strNotes,
                                    String strSalesContctId,String strTechConId)
    {
        Opportunity opp = new Opportunity();
        opp.Name = strName; 
        opp.AccountId = strAccId; 
        opp.CloseDate = dtCloseDate; 
        opp.StageName = strStageName;
        opp.Project_Title__c = strTitle;
        opp.Total_Project_Value__c = intProjVal;
        opp.Team_Size__c = strTeamSize;
        opp.Project_Duration__c = strProjDur;
        opp.Technologies_Used__c = strTechUsed;
        opp.Project_Description__c = strProjDesc;
        opp.How_did_we_win__c = strWin;
        opp.Competition__c = strComp;
        opp.Special_Notes__c = strNotes;
        opp.Sales_Contact__c = strSalesContctId;
        opp.Technical_Contact__c = strTechConId;
        insert opp;
        return opp;
    }
    
     ///<OBJECTIVE>
    ///Update records in "Opportunity" standard object and return the inserted opportunity records.
    ///<OBJECTIVE>
    public static Opportunity updatOpp(String strOppID,String strName,String strAccId,Date dtCloseDate,String strStageName,
                                    String strTitle,Integer intProjVal,String strTeamSize,String strProjDur,
                                    String strTechUsed,String strProjDesc,String strWin,String strComp,String strNotes,
                                    String strSalesContctId,String strTechConId)
    {
        Opportunity opp = new Opportunity();
        opp.Id = strOppID;
        opp.Name = strName; 
        opp.AccountId = strAccId; 
        opp.CloseDate = dtCloseDate; 
        opp.StageName = strStageName;
        opp.Project_Title__c = strTitle;
        opp.Total_Project_Value__c = intProjVal;
        opp.Team_Size__c = strTeamSize;
        opp.Project_Duration__c = strProjDur;
        opp.Technologies_Used__c = strTechUsed;
        opp.Project_Description__c = strProjDesc;
        opp.How_did_we_win__c = strWin;
        opp.Competition__c = strComp;
        opp.Special_Notes__c = strNotes;
        opp.Sales_Contact__c = strSalesContctId;
        opp.Technical_Contact__c = strTechConId;
        Update opp;
        return opp;
    }
    
    ///<OBJECTIVE>
    ///Insert record in Approval custom object and return the inserted approval record.
    ///<OBJECTIVE>
    public static Approval__c createApprvl(String strName,Integer intAmnt,Date dtExpnsDate)
    {
        Approval__c apprvl = new Approval__c();
        apprvl.Name = strName;
        apprvl.Amount__c = intAmnt;
        apprvl.Expense_Date__c = dtExpnsDate;
        insert apprvl;
        return apprvl;
    }
    
    ///<OBJECTIVE>
    ///Fetch the approval records.
    ///<OBJECTIVE>
    public static List<Approval__c> fetchApprvl(String strAppId)
    {
      return [SELECT id, Name,Amount__c, Expense_Date__c FROM Approval__c WHERE id=: strAppId];
    }
    
    ///<OBJECTIVE>
    ///Fetch the candidate record
    ///<OBJECTIVE>
    public static Candidate__c fetchCan(String strCan)
    {
        return [SELECT Id,LastModifiedById,Resume_Attach__c FROM Candidate__c WHERE Id =: strCan limit 1];
    }
    
    ///<OBJECTIVE>
    ///Fetch the candidate record
    ///<OBJECTIVE>
    public static ContentVersion fetchCntntVer(String strContntVer)
    {
        return [SELECT Id,Candidate_Id__c FROM ContentVersion WHERE Candidate_Id__c =: strContntVer];
    }
    
    
     ///OBJECTIVE
    /// Update records in "Candidate" custom object and return the Updated candidate record.
    ///OBJECTIVE
    public static Candidate__c  createCanU(String strcanId,String strCanName, String strCanLastName, String strCurrentCity, String strCurrentState, String strGender,
                                             String strEmpName, String  strEmail, String strIntrvwContactPhone, String strContractType, String strVisaType,
                                             Integer intCost, String strMobile, String strContactEmail,  String strEmpCName, String strEmpMobile, String strEmplName,
                                             String strEmpPhone, Date dtDate, String strSkills, String strReloc, String strAvailbl, Date dtCanContrctEndDt,String strNotes)
    { 
        Candidate__c can=new Candidate__c(); 
                    can.Id = strcanId;                      
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
                    Update can;  
                    return can;      
    }
  ///<OBJECTIVE>
  ///Insert record in notes and fetch the inserted record.
  ///<OBJECTIVE>
  public static Note createNotes(String strPrnt,String strTitle,String strBody)
  {
      Note note = new Note();
      note.ParentId = strPrnt;
      note.Title = strTitle;
      note.Body = strBody;
      insert note;
      return note;
  }
  
  
   ///<OBJECTIVE>
    ///Fetch content workspace resumes.
    ///<OBJECTIVE>
    public static List<ContentWorkspace> fetchCntntWS() 
    {
        return [SELECT id FROM ContentWorkspace LIMIT 1];
    }
    
    ///<OBJECTIVE>
    ///Fetch user
    ///<OBJECTIVE>
    public static User fetchUs()
    {
        return [Select Id from User limit 1];
    }
    
    ///OBJECTIVE
    ///Update records in the "Assign Candidate" custom object and return the inserted record.
    ///OBJECTIVE
    
    public static Candidate_Mapping__c updateCanMapg(Candidate_Mapping__c CanMap)
    {
  
        Update CanMap;
        return CanMap;
     }  
     
     ///<OBJECTIVE>
     ///Fetch Assign Candidate record
     ///<OBJECTIVE>
     public static Candidate_Mapping__c fetchAssCan(String strCan,String strReq)
     {
        return [Select Id,Status1__c, LR_Status__c, MR_Status__c, MR_Status1__c from Candidate_Mapping__c where Candidate__c =: strCan AND Requirement__c =: strReq limit 1];
     }
     
     ///<OBJECTIVE>
     ///Fetch Assign Candidate record
     ///<OBJECTIVE>
     public static Candidate_Mapping__c assCanMap(String strCan)
     {
        return [SELECT id,Contract_End_Date__c FROM Candidate_Mapping__c WHERE id=: strCan];
     }
     
     ///<OBJECTIVE>
     ///Fetch Candidate record
     ///<OBJECTIVE>
     public static Candidate__c fetchCandadt(String strCanId)
     {
         return [SELECT id,Star_Candidate__c,Placed__c,Contract_End_Date__c FROM Candidate__c WHERE id=: strCanId];
     }
     
     ///<OBJECTIVE>
     ///Fetch Candidate record
     ///<OBJECTIVE>
     public static Requirement__c  fetchReqr(String strReq)
     {
         return [SELECT won__c,Id from Requirement__c WHERE id=: strReq];
     }
     
     ///<OBJECTIVE>
     ///Update Requirement record
     ///<OBJECTIVE>
     public static Requirement__c updateReqrmn(Requirement__c strReq)
    {
  
        Update strReq;
        return strReq;
     }  
     
     ///<OBJECTIVE>
     ///Update Candidate record
     ///<OBJECTIVE>
     public static Candidate__c updateCandida(Candidate__c strCan)
    {
  
        Update strCan;
        return strCan;
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
     ///Fetch Requirement custom object record
     ///<OBJECTIVE>
    public static Requirement__c fetchRequirRec()
    {
        return [select Requirement__c.Id,Requirement__c.Name, Requirement__c.C_Name__r.Name, Requirement__c.Duration__c,    
          Requirement__c.Min_Cost__c, Requirement__c.Max_Cost__c, Requirement__c.Rate__c, Requirement__c.Est_Start_Date__c,    
          Requirement__c.Position_Type__c, Requirement__c.State__c, Requirement__c.Status__c, Requirement__c.No_Of_Resumes__c,    
          Requirement__c.City__c, Requirement__c.Easy1__c, Requirement__c.Unique_1__c, Requirement__c.Resumes_2__c, 
          Requirement__c.isReopen__c from Requirement__c LIMIT 1];
    }
    
    ///<OBJECTIVE>
    ///Fetch requirement record with opportunity code
    ///<OBJECTIVE>
    public static List<Requirement__c> fetchReqWOpp()
    {
    return [Select Id, Opportunity_Code__c from Requirement__c limit 1];
    }
    
     ///<OBJECTIVE>
     ///Update Requirement record
     ///<OBJECTIVE>
     public static Requirement__c updateReq(Requirement__c strReq)
    {
  
        Update strReq;
        return strReq;
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
    
}