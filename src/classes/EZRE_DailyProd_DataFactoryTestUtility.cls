/**
 * @author           Indhu
 * @version          1.0 
 * @date             07-Jan-2014
 * @Status           Developed
 * @description      This is a data factory utility for daily productivity test class that includes test data.
 *                   
 */
 
public class EZRE_DailyProd_DataFactoryTestUtility
{

    //returns the active user name.
    public static User getUserName()
    {
        return [select id,Name from User where isActive = true Limit 1];
    }

    //This method creates custom setting records and returns the same.
    public static EZRE_DailyProductivityDetails__c createDailyProdCustmSetng(string strName, string strFromAddr,
                        string strToAddr, string strFromName,string strSubject,string strFileName, string strUser,
                        string strCCAddr, string strMailBody)
    {
        EZRE_DailyProductivityDetails__c objDailyProd = new EZRE_DailyProductivityDetails__c();
        objDailyProd.Name = strName;
        objDailyProd.DailyProductivity_FromEmail__c = strFromAddr;
        objDailyProd.DailyProductivity_ToEmail__c = strToAddr;
        objDailyProd.DailyProductivity_FromDiaplayName__c = strFromName;
        objDailyProd.DailyProductivity_MailSubject__c = strSubject;
        objDailyProd.DailyProductivity_ReportName__c = strFileName;
        objDailyProd.DailyProductivity_User__c = strUser;
        objDailyProd.DailyProductivity_CCEmail__c = strCCAddr;
        objDailyProd.DailyProductivity_EmailBody__c = strMailBody;
        
        insert objDailyProd;
        return objDailyProd;
    }
    
    ///OBJECTIVE
    /// Insert test data for Requirement object and return the inserted record.
    ///OBJECTIVE
    public static Requirement__c CreateRqmt(string strReqName, string strReqDuration, decimal decMinCost,
                                    decimal decMaxCost, decimal decRate, string strStatus, string strPosition,
                                    string strState, string strIntrviwType, decimal decResumes, string strCity,
                                    string strEasy1, string strUnique1, string strSkillSet, string strAssgnUsr)
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
        objReqmt.Assigned_User__c = strAssgnUsr;
        
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
    /// Insert test data for Candidate Mapping object and return the inserted record.
    ///OBJECTIVE
    public static Candidate_Mapping__c createCandMapng(string Status,string EmailAuth,string LrComments,string MrComments,string ReqOwnerEmail,
                                       string MangEmailId,string RComments,string LRStatus,string MrStatus,string LRStatusDate,
                                       string MRStatusDate,string SubToclient,string InterviewSchd,string IntAccepted,string ClientInterviewed,
                                       string ClientOffered,string CandStarted,string Comments,Date ContEndDate,Id ReqId,Id CandtId)
    {
        Candidate_Mapping__c objCandMap =new Candidate_Mapping__c();

        objCandMap.status1__c = Status;
        objCandMap.Employer_s_Authorization__c = EmailAuth;
        objCandMap.LR_Comments__c = LrComments;
        objCandMap.MR_Comments__c = MrComments;
        objCandMap.Requirement_Owner_Email__c = ReqOwnerEmail;
        objCandMap.Manager_Email_ID__c = MangEmailId;
        objCandMap.R_Comments__c = RComments;
        objCandMap.LR_Status__c = LRStatus;
        objCandMap.MR_Status__c = MrStatus;
        objCandMap.LR_Status_Date__c = LRStatusDate;
        objCandMap.MR_Status_Date__c = MRStatusDate;
        objCandMap.Submitted_to_Client__c = SubToclient;
        objCandMap.Interview_Scheduled__c = InterviewSchd;
        objCandMap.Interview_Accepted__c = IntAccepted;
        objCandMap.Client_Interviewed__c = ClientInterviewed;
        objCandMap.Client_Offered__c = ClientOffered;
        objCandMap.Candidate_started__c = CandStarted;
        objCandMap.Comments__c = Comments;
        objCandMap.Contract_End_Date__c = ContEndDate;
        objCandMap.Requirement__c=ReqId;
        objCandMap.Candidate__c=CandtId;
        
        insert objCandMap;
        return objCandMap;
    }  
}