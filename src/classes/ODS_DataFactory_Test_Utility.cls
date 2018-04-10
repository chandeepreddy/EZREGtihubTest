/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             30-Sep-2016
 * @Status           Developed
 * @description      The main purpose of this class is for performing DML operations
 */
@isTest 
public class ODS_DataFactory_Test_Utility
{
     /// <OBJECTIVE>
    /// Insert a record in Account object and return.
    /// </OBJECTIVE>    
    Public static Account InsertAccount(string accName, string billingCity, Boolean isPortalAccess, Integer accAnnualRevenue,String Phone,
                                string leadGenName, string specifyOthers)
    {
        Account acc = new Account();
        acc.Name = accName;
        acc.BillingCity = billingCity;
        acc.Is_Portal_Access__c = isPortalAccess;
        acc.AnnualRevenue = accAnnualRevenue;
        acc.Phone = Phone;
        acc.Lead_Gen_Name__c = leadGenName;
        acc.If_Others_Please_Specify__c = specifyOthers;
        acc.NumberofEmployees = 100;
        acc.Industry = 'Technology';
        
        insert acc;
        return acc;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Account object with owner and return.
    /// </OBJECTIVE>    
    Public static Account InsertAccountWithOwner(string accName, string OwnerID, Boolean isPortalAccess,Integer accAnnualRevenue,String Phone,
                                            string leadGenName, string specifyOthers)
    {
        Account acc = new Account();
        acc.Name = accName;
        acc.OwnerID = OwnerID;
        acc.Is_Portal_Access__c = isPortalAccess;
        acc.AnnualRevenue = accAnnualRevenue;
        acc.Phone = Phone;
        acc.Lead_Gen_Name__c = leadGenName;
        acc.If_Others_Please_Specify__c = specifyOthers;
        acc.NumberofEmployees = 100;
        acc.Industry = 'Technology';
        insert acc;
        return acc;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact InsertContact(string firstName, string lastName, Boolean isPortalAccess,Id Accid,
                                        string leadGenName, string specifyOthers)
    {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Is_Portal_Access__c = isPortalAccess;
        
        con.AccountId = Accid;
        con.Lead_Gen_Name__c = leadGenName;
        con.If_Others_Please_Specify__c = specifyOthers;
        
        insert con;
        return con;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact InsertContactWithEmail(string firstName ,string lastName, Boolean isPortalAccess, Id Accid,
                                    string Email, string leadGenName, string specifyOthers)
    {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Is_Portal_Access__c = isPortalAccess;
        con.AccountId = Accid;
        con.Email = email;
        con.Lead_Gen_Name__c = leadGenName;
        con.If_Others_Please_Specify__c = specifyOthers;
        
        insert con;
        return con;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact InsertContactWithoutAcc(string firstName ,string lastName, Boolean isPortalAccess,
                                                        string leadGenName, string specifyOthers)
    {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Is_Portal_Access__c = isPortalAccess;
        con.Lead_Gen_Name__c = leadGenName;
        con.If_Others_Please_Specify__c = specifyOthers;
        
        insert con;
        return con;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact InsertContactWithApprover(string firstName, string lastName, Boolean isPortalAccess,Id Accid,
                    Boolean isApprover, string leadGenName, string specifyOthers)
    {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Is_Portal_Access__c = isPortalAccess;
        con.AccountId = Accid;
        con.IS_Approver__c = isApprover;
        con.Lead_Gen_Name__c = leadGenName;
        con.If_Others_Please_Specify__c = specifyOthers;
        
        insert con;
        return con;  
    }
    
    public static Contact UpdateContactApprover(String ContactId)
    {
        Contact con =  new Contact(Id = ContactId);
        con.IS_Approver__c = True;
        update con;
        return con;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in user object and return.
    /// </OBJECTIVE>    
    Public static User Insertuser(string Alias,string Email,string EnCoding,string LastName,string LanguageLocaleKey,
                                string LocaleSidKey,string ProfileId,string TimeZoneSidKey,string UserName, 
                                string RoleId)
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
        //usr.ContactId = ContactId;
        usr.UserRoleId = RoleId;
        
        insert usr;
        return usr;
    } 
    
    /// <OBJECTIVE>
    /// Insert a record in user object and return.
    /// </OBJECTIVE>    
    Public static User InsertUserWithContact(string Alias,string Email,string EnCoding,string LastName,string LanguageLocaleKey,
                                string LocaleSidKey,string ProfileId,string TimeZoneSidKey,string UserName, 
                                string ContactId,string PortalUsr)
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
        usr.ContactId = ContactId;
        usr.PortalUserRole__c = PortalUsr;
        //usr.UserRoleId = RoleId;
        
        insert usr;
        return usr;
    }
    
   
    
    /// <OBJECTIVE>
    /// Insert a record in user object and return.
    /// </OBJECTIVE>    
    Public static User InsertUserWithPortalContact(string Alias,string Email,string EnCoding,string LastName,string LanguageLocaleKey,
                                string LocaleSidKey,string ProfileId,string TimeZoneSidKey,string UserName, 
                                string ContactId, boolean IsPortalAccess)
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
        usr.ContactId = ContactId;
        usr.Is_Portal_Access__c = IsPortalAccess;
        //usr.UserRoleId = RoleId;
        
        insert usr;
        return usr;
    }       
    
    /// <OBJECTIVE>
    /// Fetch a record in user role object and return.
    /// </OBJECTIVE>    
    Public static User FetchUser(string UserName)
    {
        return [SELECT Id,
                    UserName
                FROM
                    User
                WHERE
                    UserName =: UserName];
    }
    
    /// <OBJECTIVE>
    /// Fetch a record in user role object and return.
    /// </OBJECTIVE>    
    Public static UserRole FetchUserRole()
    {
        return [SELECT Id,
                    PortalType
                FROM
                    UserRole
                WHERE
                    PortalType = 'None'
                LIMIT 1];
    }
    
    /// <OBJECTIVE>
    /// fetch the profile details and return.
    /// </OBJECTIVE>      
    Public static profile GetProfileName(string ProfileName)
    {
        return [select id,
                        Name
                From Profile
                where Name=:ProfileName];
    }
    
    /// <OBJECTIVE>
    /// fetch the Account details and return.
    /// </OBJECTIVE> 
    Public static Account FetchAccount(string AccountId)
    {
        return [select id,
                   Name,
                   Is_Portal_Access__c 
                   From
                   Account
                   where Id =: AccountId];    
    }
    
    /// <OBJECTIVE>
    /// fetch the Account details and return.
    /// </OBJECTIVE> 
    Public static Contact Fetchcontact(string ContactId)
    {
        return [select id,
                   LastName,
                   Is_Portal_Access__c 
                   From
                   Contact
                   where Id =: ContactId];    
    }
    /// <OBJECTIVE>
    /// Insert a record in user object and return.
    /// </OBJECTIVE>    
    Public static User InsertUserWithPortalRole(string Alias,string Email,string EnCoding,string LastName,string LanguageLocaleKey,
                                string LocaleSidKey,string ProfileId,string TimeZoneSidKey,string UserName, 
                                string PortalRole, boolean IsPortalAccess)
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
        usr.PortalUserRole__c = PortalRole;
        usr.Is_Portal_Access__c = IsPortalAccess;
        //usr.UserRoleId = RoleId;
        
        insert usr;
        return usr;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in user object with role and return.
    /// </OBJECTIVE>    
    Public static User InsertUserWithRole(string Alias,string Email,string EnCoding,string LastName,string LanguageLocaleKey,
                                string LocaleSidKey,Id ProfileId,string TimeZoneSidKey,string UserName, 
                                string PortalRole, boolean IsPortalAccess,Id UsrRole)
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
        usr.PortalUserRole__c = PortalRole;
        usr.Is_Portal_Access__c = IsPortalAccess;
        usr.UserRoleId = UsrRole;
        
        insert usr;
        return usr;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Account Services Object
    /// </OBJECTIVE>    
    public static Status_Report__c InsertSR(String sAccntSrvcId, Date dStsDate, string sWrkfortheDay, string sWrkforNextDay, String sIssues, String sStatus)
    {
        Status_Report__c  objSR= new Status_Report__c();
        objSR.Account_Services__c = sAccntSrvcId;
        objSR.Status_Date__c = dStsDate;
        objSR.Work_for_the_Day__c = sWrkfortheDay;
        objSR.Work_for_the_Next_Day__c = sWrkforNextDay;
        objSR.Issues_And_Concerns__c = sIssues;
        objSR.Status__c = sStatus;
        insert objSR;
        return objSR;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in user account object and return.
    /// </OBJECTIVE>    
    Public static User_Account__c insertUserAccount(string Accnt,string Role,string userId, string SrvceId)
    {
        User_Account__c usrAcc = new User_Account__c();
        usrAcc.Account__c = Accnt;
        usrAcc.Role_in_Account__c = Role;          
        usrAcc.User__c = userId;
        usrAcc.ODS_Services__c = SrvceId;
        insert usrAcc;
        return usrAcc;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in user account object and return.
    /// </OBJECTIVE>    
    Public static User_Account__c insertUsrAccnt(string Accnt,string Role,string userId,Id SrvId)
    {
        User_Account__c usrAcc = new User_Account__c();
        usrAcc.Account__c = Accnt;
        usrAcc.Role_in_Account__c = Role;          
        usrAcc.User__c = userId;
        usrAcc.ODS_Services__c = SrvId;
        
        insert usrAcc;
        return usrAcc;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in account service object and return.
    /// </OBJECTIVE>    
    Public static Account_Services__c insertAccountServices(string Accnt,Date startDt,Date endDt,
                            decimal hourlyRate, string srvce, decimal retainerFeeAmt, string retainerFeeType,
                            string TAM, string DocumentSuffix)
    {
        Account_Services__c accSrvc = new Account_Services__c();
        accSrvc.Account__c = Accnt;
        accSrvc.Contract_Start_Date__c = startDt;          
        accSrvc.Contract_End_Date__c = endDt;
        accSrvc.ODS_Hourly_Rate_Amount__c = hourlyRate;
        accSrvc.ODS_Services__c = srvce;
        accSrvc.Retainer_Fee_Amount__c = retainerFeeAmt;
        accSrvc.Retainer_Fee_Frequency_Type__c = retainerFeeType;
        accSrvc.Technical_Account_manager__c = TAM;
        accSrvc.Document_Suffix__c = DocumentSuffix;
        
        insert accSrvc;
        return accSrvc;
    }
    /// <OBJECTIVE>
    /// Insert a record in account service object and return.
    /// </OBJECTIVE>    
    Public static Account_Services__c insertAccountServicesWithEngagementType(string Accnt,Date startDt,Date endDt,
                            decimal hourlyRate, string srvce, decimal retainerFeeAmt, string retainerFeeType,
                            string TAM, string DocumentSuffix, string EngagementType)
    {
        Account_Services__c accSrvc = new Account_Services__c();
        accSrvc.Account__c = Accnt;
        accSrvc.Contract_Start_Date__c = startDt;          
        accSrvc.Contract_End_Date__c = endDt;
        accSrvc.ODS_Hourly_Rate_Amount__c = hourlyRate;
        accSrvc.ODS_Services__c = srvce;
        accSrvc.Retainer_Fee_Amount__c = retainerFeeAmt;
        accSrvc.Retainer_Fee_Frequency_Type__c = retainerFeeType;
        accSrvc.Technical_Account_manager__c = TAM;
        accSrvc.Document_Suffix__c = DocumentSuffix;
        accSrvc.Type_of_Engagement__c = EngagementType;
        insert accSrvc;
        return accSrvc;
    }
    
    
        
    /// <OBJECTIVE>
    /// Insert a record in ODS Services object and return.
    /// </OBJECTIVE>    
    Public static ODS_Services__c insertODSServices(string Name,string descrption, Boolean active)
    {
        ODS_Services__c srvce = new ODS_Services__c();
        srvce.Name__c = Name;
        srvce.Description__c = descrption;
        srvce.Active__c = active;
        
        insert srvce;
        return srvce;
    }
    /// <OBJECTIVE>
    /// Insert a record in Timesheet object and return.
    /// </OBJECTIVE>    
    Public static Timesheet__c insertTimesheet(string name, string accSrvc, Date aprvdDt,
                            string AprvrName, string cmts, string Status, Date StatusDt, Date endDt,
                            Date startDt)
    {
        Timesheet__c tsObj = new Timesheet__c();
        tsObj.Name = Name;
        tsObj.Account_Services__c = accSrvc;          
        tsObj.Approved_Date__c = aprvdDt;
        tsObj.Comments__c = cmts;
        tsObj.Status__c = status;
        tsObj.Status_Date__c = StatusDt;
        tsObj.Week_Start_Date__c = startDt;
        tsObj.Week_End_Date__c = endDt;
        
        insert tsObj;
        return tsObj;
    }
    
 /*   Public static View_Initiative__c insertviewintiative(string name, string accSrvc,integer hours,string status)
    { 
       View_Initiative__c vint= new View_Initiative__c(); 
            vint.name=name;
             vint.Account_Service__c=accSrvc; 
         //   vint.Estimated_Hours__c=hours;
            vint.Status__C=status;
            insert vint;
            return vint;
        
    }  */
    
    Public static Timesheet__c insertTimesheetWithCost(string name, string accSrvc, Date aprvdDt,
                            string AprvrName, string cmts, string Status, Date StatusDt, Date endDt,
                            Date startDt,Id TimeShtCstId)
    {
        Timesheet__c tsObj = new Timesheet__c();
        tsObj.Name = Name;
        tsObj.Account_Services__c = accSrvc;          
        tsObj.Approved_Date__c = aprvdDt;
        tsObj.Comments__c = cmts;
        tsObj.Status__c = status;
        tsObj.Status_Date__c = StatusDt;
        tsObj.Week_Start_Date__c = startDt;
        tsObj.Week_End_Date__c = endDt;
        tsObj.Time_Sheet_Cost__c = TimeShtCstId;
        
        insert tsObj;
        return tsObj;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in TimesheetCost object and return.
    /// </OBJECTIVE>    
    Public static Time_Sheet_Cost__c insertTimesheetCost(Id AcntSrvId,Integer Cost,Date StartDt,Date EndDt,string strMth,string strYr)
    {
        Time_Sheet_Cost__c objTmeShtCst = new Time_Sheet_Cost__c();
        objTmeShtCst.Account_Services__c = AcntSrvId;
        objTmeShtCst.Cost_Per_Hour__c = Cost;
        objTmeShtCst.Start_Date_of_Month__c = StartDt;
        objTmeShtCst.End_Date_of_Month__c =  EndDt;
        objTmeShtCst.Month__c = strMth;
        objTmeShtCst.Year__c = strYr;
        
        insert objTmeShtCst;
        return objTmeShtCst;
    }
   
   /// <OBJECTIVE>
   /// Insert a record in Timesheet object with TimeSheetCost and return.
   /// </OBJECTIVE>
   Public static Timesheet__c insertTimesheetWithCst(string name, Id TimeShtCstId,Date WeekSrtDt,Date WeekEnddt)
    {
        Timesheet__c tsObj = new Timesheet__c();
        tsObj.Name = Name;
        tsObj.Time_Sheet_Cost__c = TimeShtCstId;   
        tsObj.Week_Start_Date__c = WeekSrtDt;
        tsObj.Week_End_Date__c = WeekEnddt;
                
        insert tsObj;
        return tsObj;
    } 
    
   /// <OBJECTIVE>
   /// Insert a record in TimesheetDetail object and return.
   /// </OBJECTIVE>
   Public static Time_Sheet_Details__c insertTimesheetdetail(Integer HoursWrd,String resId,String ResName,Id TmeShtId,Date TmeShtDt)
    {
        Time_Sheet_Details__c objTmeShtDtl = new Time_Sheet_Details__c();
        objTmeShtDtl.Hours_Worked__c = HoursWrd;
        objTmeShtDtl.Resource_Id__c = resId;
        objTmeShtDtl.Resource__c = ResName;
        objTmeShtDtl.Timesheet__c = TmeShtId;
        objTmeShtDtl.Timesheet_Date__c = TmeShtDt;
        
        insert objTmeShtDtl;         
        return objTmeShtDtl;      
       
    }
    /// <OBJECTIVE>
    /// Insert a record in ClientQueries object and return.
    /// </OBJECTIVE>
    Public static ClientQueries__c insertClientQueries(Id accId,Id acntServiceId, string clientEmail, string clientName,
                            string Queries, Date QueryDt, string serviceId, string TAMEmail, string TAMId)
    {
        ClientQueries__c objClientQueries = new ClientQueries__c();
        objClientQueries.Account_Name__c = accId;
        objClientQueries.Account_Services__c = acntServiceId;
        objClientQueries.Client_Email__c = clientEmail;
        objClientQueries.Client_Name__c = clientName;
        objClientQueries.Queries__c = Queries;
        objClientQueries.Query_Date__c = QueryDt;
        objClientQueries.Service_Name__c = serviceId;
        objClientQueries.TAM_Email__c = TAMEmail;
        objClientQueries.Technical_Account_Manager__c = TAMId;
            
        insert objClientQueries;         
        return objClientQueries;           
    }     
    /// <OBJECTIVE>
    /// Insert a record in user photo object and return.
    /// </OBJECTIVE>
    Public static User_Photo__c insertUsrPhoto(Id userId)
    {
        User_Photo__c objUsrPhoto = new User_Photo__c();
        objUsrPhoto.User__c = userId;
             
        insert objUsrPhoto;         
        return objUsrPhoto;           
    }    
    /// <OBJECTIVE>
    /// Insert a record in attachment object and return.
    /// </OBJECTIVE>
    Public static Attachment insertAttachment(string attchmtName,Id parentId)
    {
        Attachment Objattach = new Attachment();    
        Objattach.Name = attchmtName;
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Objattach.body = bodyBlob;
        Objattach.parentId = parentId;
        Objattach.ContentType = 'image/jpeg';
        
        insert Objattach;
        return Objattach;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in attachment object and return.
    /// </OBJECTIVE>
    Public static Attachment insertInvoiceAttachment(string attchmtName)
    {
        Attachment Objattach = new Attachment();    
        Objattach.Name = attchmtName;
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Objattach.body = bodyBlob;
        //Objattach.parentId = parentId;
        Objattach.ContentType = 'pdf';
        
        insert Objattach;
        return Objattach;
    }
    /// <OBJECTIVE>
    /// Insert a record in UserPhoto object and return.
    /// </OBJECTIVE>
    Public static User_Photo__c insertUsrPhoto(string strName,Id UserId)
    {
        User_Photo__c ObjUserPhoto = new User_Photo__c();
        ObjUserPhoto.Name = strName;
        ObjUserPhoto.User__c = UserId;
        
        insert ObjUserPhoto;
        return ObjUserPhoto;
    }
    
     /// <OBJECTIVE>
    /// Update a record in UserPhoto object and return.
    /// </OBJECTIVE>
    Public static User_Photo__c updateUsrPhoto(Id UsrPhtId,Id UserId)
    {
        User_Photo__c ObjUserPhoto = new User_Photo__c();
        ObjUserPhoto.Id = UsrPhtId;
        ObjUserPhoto.User__c = UserId;
        
        update ObjUserPhoto;
        return ObjUserPhoto;
    }
    /// <OBJECTIVE>
    /// Insert a record in ProjectTeamMember object and return.
    /// </OBJECTIVE>
    Public static Project_Team_Member__c insertTeamMember(string ResourceName,Id AccountId, Id ServiceId)
    {
        Project_Team_Member__c ObjTeamMembr = new Project_Team_Member__c();
        ObjTeamMembr.Resource_Name__c  = ResourceName;
        ObjTeamMembr.Account__c = AccountId;
        ObjTeamMembr.ODS_Services__c = ServiceId;
        
        insert ObjTeamMembr;
        return ObjTeamMembr;
    }
    /// <OBJECTIVE>
    /// Insert a record in documents object and return.
    /// </OBJECTIVE>    
    Public static Documents__c InsertDocuments(string docName ,string docType, decimal sprintNumber, string projectName, Id attachmentId, Id accountId, Id serviceId)
    {
        Documents__c documents = new Documents__c();
        documents.Name = docName;          
        documents.Document_Type__c = docType;   
        documents.SprintNumber__c   = sprintNumber;
        documents.Project_Name__c =  projectName;
        documents.Attachment_Id__c = attachmentId;
        documents.Account__c =  accountId;       
        documents.Services__c = serviceId;  
                
        insert documents;
        return documents;  
    }
    /// <OBJECTIVE>
    /// Insert a record in documents object and return.
    /// </OBJECTIVE>    
    Public static Documents__c InsertDocuments(string docName ,string docType, decimal sprintNumber, string projectName, Id attachmentId, Id accountId, Id serviceId,boolean isDeleted)
    {
        Documents__c documents = new Documents__c();
        documents.Name = docName;          
        documents.Document_Type__c = docType;   
        documents.SprintNumber__c   = sprintNumber;
        documents.Project_Name__c =  projectName;
        documents.Attachment_Id__c = attachmentId;
        documents.Account__c =  accountId;       
        documents.Services__c = serviceId;  
        documents.Is_Deleted__c = isDeleted;
        
        insert documents;
        return documents;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Invoice object and return.
    /// </OBJECTIVE>    
    Public static Invoice__c InsertInvoice( Id AccountserviceId,string Month, Decimal Year,string Comments)
    {
        Invoice__c Invoice = new Invoice__c();
                  
        Invoice.Comments__c = Comments;
        Invoice.Month__c = Month;
        Invoice.Year__c =  Year;  
        Invoice.Account_Services__c = AccountserviceId;  
                
        insert Invoice;
        return Invoice;  
    }
        
    /// <OBJECTIVE>
    /// Insert a record in Invoice object and return.
    /// </OBJECTIVE>    
    Public static Invoice__c InsertInvoicewithAttachmnet( Id AccountserviceId,string Month, Decimal Year,string Comments, string AttachmentId)
    {
        Invoice__c Invoice = new Invoice__c();
                  
        Invoice.Comments__c = Comments;
        Invoice.Month__c = Month;
        Invoice.Year__c =  Year;
        Invoice.Attachment_Id__c = AttachmentId;
        Invoice.Account_Services__c = AccountserviceId;  
                
        insert Invoice;
        return Invoice;  
    }
    
     /// <OBJECTIVE>
    /// Insert a record in Attachment object
    /// </OBJECTIVE>    
    Public static Attachment InsertAttachment(string name, string fileContent, string parentId)
    {
        Attachment attach = new Attachment();    
        attach.Name = name;
        Blob bodyBlob = Blob.valueOf(fileContent);
        attach.body = bodyBlob;
        attach.parentId = parentId;
        
        insert attach;        
        return attach;
    }
    
   
    /// <OBJECTIVE>
    /// Insert a record in Attachment object
    /// </OBJECTIVE>    
    Public static Documents__c UpdateAttachment(Id attachmentId, Id docuementId)
    {
        Documents__c documents = new Documents__c (id=docuementId);    
        documents.Attachment_Id__c = attachmentId;  
        update documents;   
        return documents;
    }
    /// <OBJECTIVE>
    /// Insert a record in account service object and return.
    /// </OBJECTIVE>    
    Public static Account_Services__c insertAccountServiceWithRallyDetails(string Accnt,Date startDt,Date endDt,
                            decimal hourlyRate, string srvce, decimal retainerFeeAmt, string retainerFeeType, 
                            string TAM, string userName, string password, string DocumentSuffix)
    {
        Account_Services__c accSrvc = new Account_Services__c();
        accSrvc.Account__c = Accnt;
        accSrvc.Contract_Start_Date__c = startDt;          
        accSrvc.Contract_End_Date__c = endDt;
        accSrvc.ODS_Hourly_Rate_Amount__c = hourlyRate;
        accSrvc.ODS_Services__c = srvce;
        accSrvc.Retainer_Fee_Amount__c = retainerFeeAmt;
        accSrvc.Retainer_Fee_Frequency_Type__c = retainerFeeType;
        accSrvc.Technical_Account_manager__c = TAM;
        accSrvc.Rally_User_Name__c = userName;
        accSrvc.Rally_password__c = password;
        accSrvc.Document_Suffix__c = DocumentSuffix;
        
        insert accSrvc;
        return accSrvc;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact InsertContactEmail(string firstName ,string lastName, Boolean isPortalAccess, Id Accid, boolean documentRequired, string LeadGen, string IfOtherSpecify)
    {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Is_Portal_Access__c = isPortalAccess;
        con.AccountId = Accid;
        con.IsDocMailRequired__c = documentRequired;
        con.Email = 'manojkumar_s@preludesys.com';
        con.Lead_Gen_Name__c=LeadGen;
        con.If_Others_Please_Specify__c=IfOtherSpecify;
        
        
        insert con;
        return con;  
    }
     /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact InsertContactEmailApproval(string firstName ,string lastName, Boolean isPortalAccess,Boolean isApproval, Id Accid, boolean documentRequired, string LeadGen, string IfOtherSpecify)
    {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Is_Portal_Access__c = isPortalAccess;
        con.Is_Approver__c=isApproval;
        con.AccountId = Accid;
        con.IsDocMailRequired__c = documentRequired;
        con.Email = 'manojkumar_s@preludesys.com';
        con.Lead_Gen_Name__c=LeadGen;
        con.If_Others_Please_Specify__c=IfOtherSpecify;
        
        
        insert con;
        return con;  
    }
   
    /// <OBJECTIVE>
    /// Insert a record in user account object and return.
    /// </OBJECTIVE>    
    Public static User_Account__c insertUsrAccntEmail(string Accnt,string Role,string userId,Id SrvId, boolean documentRequired)
    {
        User_Account__c usrAcc = new User_Account__c();
        usrAcc.Account__c = Accnt;
        usrAcc.Role_in_Account__c = Role;          
        usrAcc.User__c = userId;
        usrAcc.ODS_Services__c = SrvId;
        usrAcc.IsDocMailRequired__c =documentRequired;
        //usrAcc.Email = 'manojkumar_s@preludesys.com';
        
        insert usrAcc;
        return usrAcc;
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact_Account_Service__c InsertContactAccountService(String Contact,string Account,string odsService, Boolean isApprover, Boolean IsDocRequired, Boolean StatusReportRequired)
    {
        Contact_Account_Service__c contactAccService = new Contact_Account_Service__c();
        contactAccService.Contact__c = Contact;
        contactAccService.Account__c = Account;
        contactAccService.ODS_Service__c = odsService;
        contactAccService.Is_Approver__c = isApprover;
        contactAccService.Status_Report_Required__c = StatusReportRequired;
        contactAccService.IsDocMailRequired__c = IsDocRequired;
        insert contactAccService;
        return contactAccService;
     }
     
     /// <OBJECTIVE>
    /// Insert a record in document with Upload Date and return.
    /// </OBJECTIVE>    
    Public static Documents__c InsertDocumentDate(string docName , Integer sprintNumber,Date uploaddate,  Id accountId)
    {
        Documents__c documents = new Documents__c();
        documents.Name = docName; 
        documents.SprintNumber__c   = sprintNumber;
        documents.Uploaded_Date__c = uploaddate;
        documents.Account__c =  accountId;
        insert documents;
        return documents;
      }  
      
      /// <OBJECTIVE>
    /// Insert a record in Folder object and return.
    /// </OBJECTIVE>    
    Public static Folder__c InsertFolder(string folderName ,Id accountserviceId)
    {
        Folder__c folders = new Folder__c ();
        folders .Name = folderName ; 
        
        folders .Account_Services__c =  accountserviceId;
        insert folders ;
        return folders ;
      }
      
      Public static Initiatives__c insertIntiatives(string InitiativeName, string AccService, string status)
      { 
          Initiatives__c initiative = new Initiatives__c();
          initiative.Name = InitiativeName;
          initiative.Account_Service__c = AccService;
          initiative.Status__c = Status;
          
          insert initiative;
          return initiative;
      }
      
      Public static Time_Sheet_Details__c insertInitiativeTimesheetdetail(Integer HoursWrd,String resId,String ResName,Id TmeShtId,Date TmeShtDt, string Initiative)
      {
          Time_Sheet_Details__c objTmeShtDtl = new Time_Sheet_Details__c();
          objTmeShtDtl.Hours_Worked__c = HoursWrd;
          objTmeShtDtl.Resource_Id__c = resId;
          objTmeShtDtl.Resource__c = ResName;
          objTmeShtDtl.Timesheet__c = TmeShtId;
          objTmeShtDtl.Timesheet_Date__c = TmeShtDt;
          objTmeShtDtl.Intiative__c = Initiative;
        
          insert objTmeShtDtl;         
          return objTmeShtDtl;     
       
      } 
      
      public static ID exportinitiative(String Name,Decimal ConsumedHours,String BriefDescription,String Comments,Date StartDate,Date EndDate,String Status){
              Initiatives__c init = new Initiatives__c();
              init.Name = Name;
              init.Consumed_Hours__c = ConsumedHours;
              init.Brief_Description__c = BriefDescription;
              init.Comments__c = Comments;
              init.Probable_Start_Date__c = StartDate;
              init.Probable_End_Date__c = EndDate;
              init.Status__c = Status;
              insert init;
              return init.Id;
      }
    
      public static void exportEstimates(Decimal Hours,String InitiativeID,String Phase,String Tasks){
             Estimate__c estimate = new Estimate__c();
             estimate.Hours__c = Hours;
             estimate.Initiative_Lookup__c = InitiativeID;
             estimate.Phase__c = Phase;
             estimate.Task_Components__c = Tasks;
             insert estimate;  
      }
    
      
    /// <OBJECTIVE>
    /// Insert a record in Account object and return.
    /// </OBJECTIVE>    
    
    Public static Account InsertAccountforcreatechilds(string accName, string Sow,Date SowDate,Id CustomerSuccessManager,Integer accAnnualRevenue,
                                                      string phone,string leadGenName, string specifyOthers,boolean isPortalAccess,boolean IsSendWorkOrderEmail)
    {
        Account acc = new Account();
        acc.Name = accName;
        acc.SOW__c = sow;
     // acc.Created_Childs_Automatically__c = CreatedChildsAutomatically;
        acc.SOW_Status_Date__c = SowDate;
        acc.User__c = CustomerSuccessManager;
        acc.AnnualRevenue = accAnnualRevenue;
        acc.Phone = Phone;   
        acc.Lead_Gen_Name__c = leadGenName;
        acc.If_Others_Please_Specify__c = specifyOthers;
        acc.Is_Portal_Access__c = isPortalAccess;
        acc.IsSendWorkOrderEmail__c = IsSendWorkOrderEmail;
        acc.NumberofEmployees = 100;
        acc.Industry = 'Technology';
        
        insert acc;
        return acc;  
    }
    
    /// <OBJECTIVE>
    /// Insert a record in Contact object and return.
    /// </OBJECTIVE>    
    Public static Contact InsertContactforcreatechilds(string firstName, string lastName, string status,Id Accid,String Email)
    {
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Status__c = status;      
        con.AccountId = Accid;
        con.Email = Email;
        insert con;
        return con;  
    }
    
    Public static Account InsertAccountforIntroAndKickoffMail(string accName,Id CustomerSuccessManager, string Sow,Date SowDate,Integer accAnnualRevenue,
                                                              string phone,string leadGenName, string specifyOthers,boolean isPortalAccess,
                                                              String status,Boolean IsSendWorkOrderEmail, Boolean IsIntroEmailSent)
    {
        Account acc = new Account();
        acc.Name = accName;
        acc.SOW__c = Sow;
        acc.User__c = CustomerSuccessManager;
        acc.SOW_Status_Date__c = SowDate;
        acc.AnnualRevenue = accAnnualRevenue;
        acc.Phone = Phone;   
        acc.Lead_Gen_Name__c = leadGenName;
        acc.If_Others_Please_Specify__c = specifyOthers;
        acc.Is_Portal_Access__c = isPortalAccess;
        acc.isSentIntroductionMail__c = IsIntroEmailSent;
        acc.IsSendWorkOrderEmail__c = IsSendWorkOrderEmail;
        //acc.isSentKickoffMail__c = IsKickoffEmailSent;
        acc.Account_Status__c = status;
        
        insert acc;
        return acc;  
    }
    
  
    
  }