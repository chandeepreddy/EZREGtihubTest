/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             28-Sep-2016
 * @Status           Developed
 * @description      The main purpose of this class is for performing DML operations in objects 
 */
public class ODS_Data_Utility
{
    
    
    public  ODS_Data_Utility(ODS_Invoicepagecontroller myController){
        
    }


     /// <OBJECTIVE>
    /// fetch the logged in user details and return.
    /// </OBJECTIVE>
    
    Public static User getLoggedUserdetail()
    {
        
        return [Select id,
                       ProfileId,
                       Is_Portal_Access__c,
                       PortalUserRole__c
                        //ProfileId.Name 
                   FROM
                        User
                   WHERE  
                        Id = : Userinfo.getUserId()];
    }
    
    public static  List<User>  getPortalAccessByUserName (string UserName){
    
        return [Select id,
                       Name,
                       Username,
                       ProfileId,
                       Is_Portal_Access__c,
                       PortalUserRole__c
                        
                   FROM
                        User
                   WHERE  
                        Username = :UserName];
    }
    
     /// <OBJECTIVE>
    /// fetch the logged in user details and return.
    /// </OBJECTIVE>
    
    /*Public static Contact getAccountContact(string accIdSet)
    {
        
        return [SELECT id, 
                        AccountId, 
                        Account.Is_Portal_Access__c 
                    from 
                        Contact 
                    where 
                    AccountId =: accIdSet];  
    } */
    /// <OBJECTIVE>
    /// fetch the logged in user details and return.
    /// </OBJECTIVE>
    
    Public static user getuser(string conIdSet)
    {
        
        return [SELECT id,
                       ContactId,
                       Contact.Is_Portal_Access__c 
                    from 
                        User
                    where 
                    ContactId =: conIdSet];  
    }
   
    ///<OBJECTIVE>
    ///Returns Account Service Id based on Account Name and Service Name
    ///</OBJECTIVE>
   /* public static string GetAccountServiceId(string AccountName, string ServiceName)
    {
        return [SELECT id,
                    Account__c,
                    Account__r.Name,
                    ODS_Services__c,
                    ODS_Services__r.Name__c
                FROM
                    Account_Services__c
                WHERE
                    Account__r.Name =: AccountName
                    AND
                    ODS_Services__r.Name__c =: ServiceName
                LIMIT 1].Id;
    }*/
    
    /// <OBJECTIVE>
    /// fetch the timesheet and return.
    /// </OBJECTIVE>    
    /*Public static List<Timesheet__c> GetCustomerTimesheet(string AccountServiceID)
    {
        
        return [SELECT id, 
                        Name, 
                        Account_Services__c,
                        Approver_Name__c,
                        Status__c,
                        Status_Date__c,
                        Week_End_Date__c,
                        Week_Start_Date__c,
                        Approved_Date__c,
                        Total_Hours__c,
                        LastModifiedDate 
                    From 
                        Timesheet__c 
                    WHERE
                        Status__c != 'Saved'
                        AND
                        Account_Services__c =: AccountServiceID];
    }*/
    
    /// <OBJECTIVE>
    /// fetch the timesheet and return.
    /// </OBJECTIVE>    
   /* Public static List<Timesheet__c> GetAdminTimesheet(string AccountServiceID)
    {
        
        return [SELECT id, 
                        Name, 
                        Account_Services__c,
                        Approver_Name__c,
                        Status__c,
                        Status_Date__c,
                        Week_End_Date__c,
                        Week_Start_Date__c,
                        Approved_Date__c,
                        Total_Hours__c                        
                    From 
                        Timesheet__c 
                    WHERE                        
                        Account_Services__c =: AccountServiceID];
    } */
     
      /// <OBJECTIVE>
    /// fetch the timesheet details and return.
    /// </OBJECTIVE>
    
   /* Public static list <Time_Sheet_Details__c> getTimesheetdetail(string TimesheetId)
    {
        
        return [SELECT id, 
                        Name, 
                        Comments__c,
                        Hours_Worked__c,
                        Resource__c,
                        Task_Name__c,
                        Timesheet__c,
                        Timesheet_Date__c
                    From 
                        Time_Sheet_Details__c 
                    where 
                    Timesheet__c =: TimesheetId
                     ];
    }*/
    /// <OBJECTIVE>
    /// fetch the timesheet details with Timesheet status and return.
    /// </OBJECTIVE>
    
   /* Public static list <Time_Sheet_Details__c> getTimesheetdetailWithStatus(string TimesheetId)
    {
        
        return [SELECT id, 
                        Name, 
                        Comments__c,
                        Hours_Worked__c,
                        Resource__c,
                        Task_Name__c,
                        Timesheet__c,
                        Timesheet_Date__c
                    From 
                        Time_Sheet_Details__c 
                    where 
                    Timesheet__c =: TimesheetId
                    and
                    Timesheet__r.Status__c != 'Saved'
                    ];
    }*/
    /// <OBJECTIVE>
    /// fetch the user details.
    /// </OBJECTIVE>
    
    Public static User fetchUserById(string curntUserId)
    {
        return [SELECT 
                    Id, 
                    Name,
                    ContactId,
                    Email,
                    Photo__c,
                    PortalUserRole__c,
                    Contact.Is_Approver__c
                FROM 
                    User 
                WHERE 
                    Id =: curntUserId];
    }
    
    /// <OBJECTIVE>
    /// fetch the Contact Account Service details.
    /// </OBJECTIVE>
    
    Public static List<Contact_Account_Service__c> fetchContactAccountService(ID ContactId, string ServiceId)
    {
        return [Select
                    Contact__c,
                    Email__c,    
                    Is_Approver__c,
                    ODS_Service__c,
                    AccountId__c
                From
                    Contact_Account_Service__c 
                Where
                    Contact__c =:ContactId
                AND
                    ODS_Service__c =: ServiceId 
                AND
                    Is_Approver__c=:True    
                LIMIT 1];
    
    
    }
    
    Public static List<Contact_Account_Service__c> fetchInitiativeContactAccountService(ID ContactId, string ServiceId)
    {
        return [Select
                    Contact__c,
                    Email__c,    
                    Is_initiate_approver__c,
                    ODS_Service__c,
                    AccountId__c
                From
                    Contact_Account_Service__c 
                Where
                    Contact__c =:ContactId
                AND
                    ODS_Service__c =: ServiceId 
                AND
                    Is_initiate_approver__c=:True    
                LIMIT 1];
    
    
    }
    
    Public static List<Contact_Account_Service__c> getContactAccountService( string AccountId, string ServiceId)
    {
        return [Select
                    Contact__c,
                    Email__c,    
                    Is_Approver__c,
                    ODS_Service__c,
                    AccountId__c,
                    Account__c
                From
                    Contact_Account_Service__c 
                Where
                    Account__c =:AccountId
                AND
                    ODS_Service__c =: ServiceId 
                AND
                    Is_Approver__c=:True    
                LIMIT 1];
    
    
    }   
       

    /// <OBJECTIVE>
    /// fetch the Account Services details.
    /// </OBJECTIVE>
    
    Public static List<Account_Services__c > fetchAccServcesByAcc(string selectedAccount)
    {
    return [SELECT Id,
                 Account__c, 
                 ODS_Services__c,
                 ODS_Services__r.Name__c ,
                 Type_of_Engagement__c
             FROM 
                 Account_Services__c 
             WHERE
                 Account__c =: selectedAccount];  
    }
    
    Public static List<Account_Services__c > fetchAccServcesByAccAndSrv(string selectedAccount,string selectedServiceId)
    {
    return [SELECT Id,
                 Account__c, 
                 ODS_Services__c,
                 ODS_Services__r.Name__c ,
                 Type_of_Engagement__c,
                 Agile__c,
                 JIRA_Domain_Name__c
             FROM 
                 Account_Services__c 
             WHERE
                 Account__c =: selectedAccount AND 
                 ODS_Services__c =: selectedServiceId];  
    }

 Public static Account_Services__c  getAccServcesByAccAndSrv(string selectedAccount,string selectedServiceId)
    {
    return [SELECT Id,
                 Account__c, 
                 ODS_Services__c,
                 ODS_Services__r.Name__c ,
                 Type_of_Engagement__c,
                 Agile__c
             FROM 
                 Account_Services__c 
             WHERE
                 Account__c =: selectedAccount AND 
                 ODS_Services__c =: selectedServiceId];  
    }
    
    public static List<Contact_Account_Service__c > FetchAccSerByCont(string selectedAccount)
    {
    Return[Select Id,
             ODS_Service__c,
             ODS_Service__r.Name,
             Contact__c,
             Account__c
             from 
                 Contact_Account_Service__c
             where
                 Account__c =: selectedAccount];
            
    }
    
    /// <OBJECTIVE>
    /// fetch the Account Services details.
    /// </OBJECTIVE>    
    Public static List<Account_Services__c > fetchAccServcesByServiceAccount(string selectedAccount, string selectedService)
    {
    return [SELECT Id,
                 Account__c, 
                 Account__r.Name,
                 ODS_Services__c,
                 ODS_Services__r.Name__c 
             FROM 
                 Account_Services__c 
             WHERE
                 Account__c =: selectedAccount
                 AND
                 ODS_Services__c =: selectedService             
             ORDER BY CreatedDate DESC];  
    }
   
    /// <OBJECTIVE>
    /// fetch the Account Services details using AccountService id.
    /// </OBJECTIVE>    
    Public static List<Account_Services__c > fetchRelatedAccountService(String AccServId)
    {
    return [SELECT Id,
                 Account__c,                 
                 ODS_Services__c
            FROM 
                 Account_Services__c 
            WHERE
                 Id =: AccServId]; 
    }
    /// <OBJECTIVE>
    /// fetch the timesheet and return.
    /// </OBJECTIVE>    
    /*Public static List<Timesheet__c> GetCustomerTimesheetWithSearch(string AccountServiceID, Date WeekStartDate,
                                                Date WeekEndDate, string Status )
    {
        
        return [SELECT id, 
                        Name, 
                        Account_Services__c,
                        Approver_Name__c,
                        Status__c,
                        Status_Date__c,
                        Week_End_Date__c,
                        Week_Start_Date__c,
                        Approved_Date__c,
                        Total_Hours__c,
                        LastModifiedDate
                    From 
                        Timesheet__c 
                    WHERE
                        
                        Account_Services__c =: AccountServiceID
                        OR
                        Week_Start_Date__c =:WeekStartDate
                        OR
                        Week_End_Date__c =: WeekEndDate
                        OR
                        Status__c =: Status ];
    }*/

    /// <OBJECTIVE>
    /// fetch the Services details.
    /// </OBJECTIVE>
    
    Public static List<ODS_Services__c> fetchAccServces()
    {
    return [SELECT
                 id, 
                 Name,
                 Name__c 
             FROM 
                 ODS_Services__c];  
    }
    
    /// <OBJECTIVE>
    /// fetch the Account details.
    /// </OBJECTIVE>    
    Public static List<Account> GetAllAccounts()
    {
        return [SELECT
                 id, 
                 Name 
             FROM 
                 Account];  
    }
    
    /// <OBJECTIVE>
    /// fetch the ODS Service details.
    /// </OBJECTIVE>    
    Public static List<ODS_Services__c> GetAllServices()
    {
        return [SELECT
                 id, 
                 Name,
                 Name__c 
             FROM 
                 ODS_Services__c];  
    }
    
    public static List<Contact_Account_Service__c> GetCustomerAccService(string AccountId, string ContactId)
    {
        return [SELECT
                    AccountId__c,
                    Contact__c,
                    Contact__r.Name,
                    Email__c,
                    Is_Approver__c,
                    ODS_Service__c
                FROM
                    Contact_Account_Service__c
                WHERE 
                    Contact__r.AccountId =: AccountId
                AND
                    Contact__c =:ContactId
                ];
    }
    
    
    
    public static List<Account> GetAccountNameById(string AccountId)
    {
        return [SELECT Id,
                    Name
                FROM
                    Account
                WHERE ID =: AccountId];
    }
    
    public static List<ODS_Services__c> GetServiceNameById(string ServiceId)
    {
        return [SELECT Id,
                    Name,
                    Name__c
                FROM
                    ODS_Services__c
                WHERE ID =: ServiceId];
    }
    
    public static List<Contact> GetApproverName(string AccountId)
    {
        return [SELECT Id,
                    LastName,
                    Is_Approver__c
                FROM
                    Contact
                WHERE 
                    AccountId =: AccountId
                    AND
                    Is_Approver__c = True
                LIMIT 1];
    }
    
    public static List<Contact_Account_Service__c> GetAccServiceApproverName(string AccountId, string ServiceId)
    {
        return [SELECT
                    AccountId__c,
                    Contact__c,
                    Contact__r.Name,
                    Email__c,
                    Is_Approver__c,
                    ODS_Service__c
                FROM
                    Contact_Account_Service__c
                WHERE 
                    Contact__r.AccountId =: AccountId
                AND
                    ODS_Service__c =:ServiceId
                AND
                    Is_Approver__c = True
                LIMIT 1];
    }
    /// <OBJECTIVE>
    /// fetch the customer by ContactId.
    /// </OBJECTIVE>
    Public static List<Contact> FetchAccountIdByCustomer(string contactId)
    {
        return [SELECT Id,
                     Name, 
                     AccountId, 
                     Account.name
              FROM 
                  Contact 
              WHERE 
                  Id =: contactId
              LIMIT 1];
      }
      
    public static List<Contact_Account_Service__c> FetchAccServicebyCustomer(string AccountId, string ServiceId)
    {
        return [SELECT
                    AccountId__c,
                    Contact__c,
                    Contact__r.Name,
                    Email__c,
                    Is_Approver__c,
                    ODS_Service__c,
                    Account__c
                FROM
                    Contact_Account_Service__c
                WHERE 
                    Contact__r.AccountId =: AccountId
                AND
                    ODS_Service__c =:ServiceId
                
                LIMIT 1];
    }
      
      
      public static List<Time_Sheet_Details__c> FetchExistingTimesheetDetail(string TimesheetId)
      {
          return [SELECT Id,
                      Timesheet__c
                  FROM
                      Time_Sheet_Details__c
                  WHERE
                      Timesheet__c =: TimesheetId];
      }
      
      public static List<Time_Sheet_Details__c> FetchExistingTimesheetDetailsforInsert(string TimesheetId)
      {
          return [SELECT Id,
                      Timesheet__c,
                      Hours_Worked__c,
                      Row_No__c,
                      Task_Name__c,
                      Resource_Id__c,
                      Resource__c,
                      Intiative__c,
                      Initiative_Name__c,
                      Timesheet_Date__c                      
                  FROM
                      Time_Sheet_Details__c
                  WHERE
                      Timesheet__c =: TimesheetId];
      }
      
     /// <OBJECTIVE>
    /// Method to insert Status report
    /// </OBJECTIVE>
    
    public static Status_Report__c insertStatusReport(Date dDate, String sWorkfortheDay, String sWorkforNxtDay, 
                                                      String sIssues,String sStatus, Id accntSrvId)
    {
        Status_Report__c objSR = new Status_Report__c();
        //objSr.Name = sName;
        objSr.Status_Date__c = dDate;
        objSr.Work_for_the_day__c = sWorkfortheDay;
        objSr.Work_for_the_Next_Day__c = sWorkforNxtDay;
        objSr.Issues_and_Concerns__c = sIssues;
        objSr.Status__c = sStatus;
        objSr.Account_Services__c = accntSrvId;
        
        insert objSr;
        return objSr;
    }

    /// <OBJECTIVE>
    /// Method to fetch the Account Services details using Account and Service id.
    /// </OBJECTIVE>    
    Public static Account_Services__c fetchAccServcesByAccntAndSrvce(String sAccntId, String sSrvceId)
    {
    return [SELECT 
                 Account__c,
                 Account__r.Name,
                 Id,
                 Contract_End_Date__c, 
                 ODS_Services__c,
                 ODS_Services__r.Name__c, 
                 Technical_Account_manager__c
            FROM 
                 Account_Services__c 
            WHERE
                 Account__c =: sAccntId
            AND
                 ODS_Services__c =: sSrvceId]; 
    }
    
    
    public static List<Time_Sheet_Details__c> FetchTimesheetDetailsbyId(string TimesheetId)
    {
        return [SELECT Id,
                    Row_No__c,
                    Hours_Worked__c,
                    Resource_Id__c,
                    Resource__c,
                    Task_Name__c,
                    Timesheet__c,
                    Timesheet_Date__c,
                    Intiative__c,
                    Intiative__r.Remaining_Hours__c,
                    Initiative_Name__c
                FROM
                    Time_Sheet_Details__c
                WHERE
                    Timesheet__c =: TimesheetId];        
    }
    
     public static List<Estimate__c> FetchInitiativeDetailsbyId(String InitiativeId){
         return [SELECT Id,
                        Name,
                        Hours__c,
                        Phase__c,
                        Assumptions__c,
                        Task_Components__c
                   FROM
                        Estimate__c
                   WHERE
                        Initiative_Lookup__c =: InitiativeId
               ];
     }
    
    public static List<Estimate__c> FetchCustomerInitiativeDetails(String InitiativeId)
    {
          return    [SELECT Id,
                       Name,
                       Hours__c,
                       Phase__c,
                       Assumptions__c,
                       Task_Components__c
                  FROM
                       Estimate__c
                  WHERE
                       Initiative_Lookup__c =: InitiativeId
                       AND
                       Initiative_Lookup__r.Status__c !=: 'Estimation Saved'
               ];
           
    }
    public static List<Time_Sheet_Details__c> FetchCustomerTimesheetDetails(string TimesheetId)
    {
        return [SELECT Id,
                    Row_No__c,
                    Hours_Worked__c,
                    Resource_Id__c,
                    Resource__c,
                    Task_Name__c,
                    Timesheet__c,
                    Timesheet__r.Status__c,
                    //Timesheet__r.Account_Services__r.Account__r.Name,
                    //Timesheet__r.Account_Services__r.ODS_Services__r.Name,
                    Timesheet_Date__c,
                    Intiative__c,
                    Intiative__r.Remaining_Hours__c,
                    Initiative_Name__c
                FROM
                    Time_Sheet_Details__c
                WHERE
                    Timesheet__c =: TimesheetId
                    AND
                    Timesheet__r.Status__c !=: 'Saved'];        
    }
  
    /// <OBJECTIVE>
    /// To fetch the Technical Account Manager details.
    /// </OBJECTIVE>    
    Public static List<Account_Services__c> fetchTAMBySlctdId(String slctdCustId, String slctdCustSrvce)
    {
    return [SELECT 
                Id, 
                Account__c, 
                Account__r.Name, 
                ODS_Services__c,
                ODS_Services__r.Name__c,
                Technical_Account_manager__r.name, 
                Technical_Account_manager__r.Email,
                Technical_Account_manager__r.Phone,
                Technical_Account_manager__r.Photo__c  
            FROM 
                Account_Services__c 
            WHERE 
                Account__c =: slctdCustId
            AND
                ODS_Services__c =: slctdCustSrvce];
    }
    /// <OBJECTIVE>
    /// To fetch the Account Manager details.
    /// </OBJECTIVE>    
    Public static User_Account__c fetchAMBySlctdId(String slctdCustId)
    {
    return [SELECT 
                Id, 
                Role_in_Account__c,
                User__c
            FROM 
                User_Account__c
            WHERE 
                Role_in_Account__c =: 'Account Manager' 
            AND 
                Account__c =: slctdCustId
            LIMIT 1];
    }
    /// <OBJECTIVE>
    /// To fetch the user details.
    /// </OBJECTIVE>    
    Public static User fetchUserDetailsById(String userId)
    {
    return [SELECT
                 Id,
                 Name,
                 Phone, 
                 Email 
             FROM 
                 User
             WHERE 
                 Id =: userId];
    }
    /// <OBJECTIVE>
    /// To fetch the Account details.
    /// </OBJECTIVE>    
    Public static Account fetchAccountDetailsById(String slctdCustId)
    {
    return [SELECT 
                Id,
                Name,
                Website,
                BillingStreet,
                BillingCity,
                BillingState,
                BillingCountry,
                BillingPostalCode 
            FROM 
                Account 
            WHERE 
                Id =: slctdCustId];
    }
    /// <OBJECTIVE>
    /// To fetch the Contact details.
    /// </OBJECTIVE>    
    Public static List<Contact> fetchContactDetailsById(String slctdCustId)
    {
    return [SELECT 
                Id,
                Name,
                MobilePhone,
                Email,
                (SELECT Id, ContentType FROM Attachments WHERE ContentType LIKE '%jpeg%' OR ContentType LIKE '%png%') 
            FROM 
                Contact 
            WHERE 
                AccountId =: slctdCustId];
    }
    /// <OBJECTIVE>
    /// To fetch the Account Services details.
    /// </OBJECTIVE>    
    Public static Account_Services__c fetchServiceDetailsById(String slctdCustId, String slctdCustSrvce)
    {
    return [SELECT 
                Account__c,
                Account__r.Customer_Portal_Demo__c,
                Account__r.Setup_Weekly_Monthly_Meeting__c,
                Account__r.Customer_Portal_Access__c,
                Account__r.Onboarding_Document__c,
                Account__r.Lightning_Readiness_Check__c,
                Contract_End_Date__c,
                Contract_Start_Date__c,
                ODS_Hourly_Rate_Amount__c,
                ODS_Services__c,
                Rally_password__c,
                Rally_Project_Name__c,
                Rally_User_Name__c,
                Retainer_Fee_Amount__c,
                Retainer_Fee_Frequency_Type__c,
                Technical_Account_manager__c
            FROM 
                Account_Services__c 
            WHERE 
                Account__c =: slctdCustId 
            AND 
                ODS_Services__c =: slctdCustSrvce
            LIMIT 1];
    }
    
    public static List<TimeSheet__c> FetchTimesheetRecById(String TimeSheetId)
    {
        return [SELECT Id,
                    Name,
                    Account_Services__c,
                    Account_Services__r.Account__r.Name,
                    Account_Services__r.ODS_Services__r.Name,
                    Account_Services__r.ODS_Service_Name__c,
                    Status__c,
                    Week_Start_Date__c,
                    Week_End_Date__c,
                    Approver_Name__c,
                    Approver_Name__r.Name,
                    Approved_Date__c,
                    Comments__c,
                    Total_Hours__c,
                    ApproverName__c 
                FROM
                    TimeSheet__c
                WHERE
                    Id =: TimeSheetId 
                LIMIT 1];
    }
    
    public static TimeSheet__c FetchTimesheetById(String TimeSheetId)
    {
        return [SELECT Id,
                    Name,
                    Account_Services__c,
                    Account_Services__r.Account__r.Name,
                    Account_Services__r.ODS_Services__r.Name,
                    Account_Services__r.ODS_Service_Name__c,
                    Status__c,
                    Week_Start_Date__c,
                    Week_End_Date__c,
                    Approver_Name__c,
                    Approver_Name__r.Name,
                    Approved_Date__c,
                    Comments__c,
                    Total_Hours__c,
                    ApproverName__c 
                FROM
                    TimeSheet__c
                WHERE
                    Id =: TimeSheetId];
    }
    
    public static Initiatives__c FetchInitiativeByID(String InitativeId)
    {  
             
        return [select ID,
                       Name,
                       Account_Service__c,
                       Account_Service__r.Account__r.Name,
                       Account_Service__r.ODS_Services__r.Name,
                       Account_Service__r.ODS_Service_Name__c,
                       Approved_Date__c,
                       Approver_Name__c,
                       Approver_Name__r.Name,
                       Probable_Start_Date__c,
                       Probable_End_Date__c,
                       Client_side_Contact__c,
                       Client_side_Contact__r.Name,
                       Comments__c,Consumed_Hours__c,
                       Estimated_hours__c,
                       Remaining_Hours__c,
                       Status__c,
                       Utilization__c
                       FROM 
                            Initiatives__c 
                       Where 
                            Id =: InitativeId];
    }
    
    
    public static Initiatives__c FetchExportInitiativeByID(String InitativeId)
    {  
             
        return [select ID,
                       Name,
                       Account_Service__c,
                       Account_Service__r.Account__r.Name,
                       Account_Service__r.ODS_Services__r.Name,
                       Account_Service__r.ODS_Service_Name__c,
                       Approved_Date__c,
                       Approver_Name__c,
                       Approver_Name__r.Name,
                       Probable_Start_Date__c,
                       Probable_End_Date__c,
                       Brief_Description__c,
                       Assumption__c,
                       Client_side_Contact__c,
                       Client_side_Contact__r.Name,
                       Comments__c,Consumed_Hours__c,
                       Estimated_hours__c,
                       Remaining_Hours__c,
                       Status__c,
                       Utilization__c
                       FROM 
                            Initiatives__c 
                       Where 
                            Id =: InitativeId];
    }
    
    
    public static List<Timesheet__c> FetchTimesheetByDate(string AccountServiceId, Date WeekStart, Date WeekEnd)
    {
        return [SELECT Id,
                    Name,
                    Account_Services__c,
                    Week_End_Date__c,
                    Week_Start_Date__c,
                    Status__c
                FROM
                    Timesheet__c
                WHERE
                    Week_Start_Date__c =: WeekStart
                    AND
                    Week_End_Date__c =: WeekEnd
                    AND
                    Account_Services__c =: AccountServiceId
                    AND
                    Account_Services__c != null];
    }
  
    /// <OBJECTIVE>
    /// fetch the Account details.
    /// </OBJECTIVE>    
    /*Public static List<Account> GetActiveAccountByUserId()
    {
        return [SELECT
                     Id, 
                     Name,
                     Is_Portal_Access__c 
                 FROM 
                     Account
                 WHERE
                     Is_Portal_Access__c =: true];  
    }*/
    
     /// <OBJECTIVE>
    /// fetch all the Status Report details .
    /// </OBJECTIVE>
    
    /*public static List<Status_Report__c> fetchStatusReportList()
    {
        
        return [Select id,
                       Account_Services__c,
                       CreatedDate,
                       Issues_and_Concerns__c,
                       LastModifiedDate,
                       LastReferencedDate,
                       Name,Status_Date__c,
                       Work_For_The_Day__c,
                       Work_For_The_Next_Day__c 
                   FROM 
                       Status_Report__c];
    }*/
    
    /// <OBJECTIVE>
    /// fetch the Status Report details for deletion.
    /// </OBJECTIVE>
    
    public static Status_Report__c fetchStatusReportbyID(String sttsRprtId)
    {
        
        return [Select id,
                       Account_Services__c,
                       CreatedDate,
                       Issues_and_Concerns__c,
                       LastModifiedDate,                       
                       Name,
                       Status_Date__c,
                       Work_For_The_Day__c,
                       Work_For_The_Next_Day__c,
                       Status__c,
                       Account_Services__r.ODS_Services__c,
                       Account_Services__r.Account__c 
                   FROM 
                       Status_Report__c 
                   WHERE 
                   ID =: sttsRprtId ];
    }
    /// <OBJECTIVE>
    /// fetch the logged in account details and return.
    /// </OBJECTIVE>
    
    Public static Contact getAccountByContactId(string ContactId)
    {
        
        return [SELECT id, 
                        AccountId, 
                        Account.Is_Portal_Access__c 
                    from 
                        Contact 
                    where 
                    Id =: ContactId];  
    } 
    /// <OBJECTIVE>
    /// fetch the User Account details by account id.
    /// </OBJECTIVE>
    
    Public static List<User_Account__c> fetchUserAccountByAcntId(set<Id> accId)
    {
    return [SELECT 
                User__c,
                User__r.Name,
                Account__c,
                ODS_Services__c,
                ODS_Services__r.name__c
            FROM 
                User_Account__c 
            WHERE 
                Account__c IN:accId]; 
    }
    
    /// <OBJECTIVE>
    /// fetch the User Account details by account id.
    /// </OBJECTIVE>
    
    Public static List<Account_Services__c> fetchAccountServicesById(set<Id> accId)
    {
    return [SELECT 
                ODS_Services__c,
                ODS_Services__r.Name__c, 
                Account__c, 
                Technical_Account_manager__c
            FROM
                Account_Services__c 
            WHERE 
                Account__c IN:accId]; 
    }     
    /// <OBJECTIVE>
    /// fetch the time sheet details for the chart diagram in the dashboard section.
    /// </OBJECTIVE>
    
    Public static AggregateResult[] getTimesheetDetailsByMonthYear(string slctdAccId, string slctdSrvceId)
    {
        
        List<AggregateResult> Check = [SELECT 
                                             sum(Hours_Worked__c) HoursWorked                                                                   
                                       FROM 
                                             Time_Sheet_Details__c 
                                       WHERE 
                                             Timesheet__r.Account_Services__r.Account__c =:slctdAccId 
                                       AND 
                                             Timesheet__r.Account_Services__r.ODS_Services__c =:slctdSrvceId
                                       AND
                                             Timesheet__r.Account_Services__r.Type_of_Engagement__c != 'ODS'];
        
        if(slctdAccId == 'All' && slctdSrvceId == 'All'){
         return  [SELECT 
                    sum(Hours_Worked__c) HoursWorked, 
                    Timesheet_Date__c  TimesheetDate,
                    ChartDate__c,
                    Timesheet__r.Account_Services__r.Account__C Account, 
                    Timesheet__r.Account_Services__r.ODS_Services__c Service
                    FROM 
                         Time_Sheet_Details__c 
                    WHERE 
                          Status__c =: 'Approved'
                     Group by
                        Timesheet_Date__c,
                        ChartDate__c,
                        Timesheet__r.Account_Services__r.Account__C,
                        Timesheet__r.Account_Services__r.ODS_Services__c order by Timesheet_Date__c];
        }
        else if(slctdAccId == 'All' && slctdSrvceId != 'All'){
         return   [SELECT 
                    sum(Hours_Worked__c) HoursWorked, 
                    Timesheet_Date__c  TimesheetDate,
                    ChartDate__c,
                    Timesheet__r.Account_Services__r.Account__C Account, 
                    Timesheet__r.Account_Services__r.ODS_Services__c Service
                FROM 
                    Time_Sheet_Details__c 
                WHERE 
                    Timesheet__r.Account_Services__r.ODS_Services__c =:slctdSrvceId
                AND
                    Status__c =: 'Approved'
                Group by
                     Timesheet_Date__c,
                     ChartDate__c,
                     Timesheet__r.Account_Services__r.Account__C,
                     Timesheet__r.Account_Services__r.ODS_Services__c order by Timesheet_Date__c];
        }
        else if(slctdAccId != 'All' && slctdSrvceId == 'All'){
           return [SELECT 
                    sum(Hours_Worked__c) HoursWorked, 
                    Timesheet_Date__c  TimesheetDate,
                    ChartDate__c,
                    Timesheet__r.Account_Services__r.Account__C Account, 
                    Timesheet__r.Account_Services__r.ODS_Services__c Service
                FROM 
                    Time_Sheet_Details__c 
                WHERE 
                    Timesheet__r.Account_Services__r.Account__C =:slctdAccId 
                
                AND
                    Status__c =: 'Approved'
                Group by
                     Timesheet_Date__c,
                     ChartDate__c,
                     Timesheet__r.Account_Services__r.Account__C,
                     Timesheet__r.Account_Services__r.ODS_Services__c order by Timesheet_Date__c];
        }
      /*  else if( Check.size() > 0 ){
              return [SELECT 
                    sum(Hours_Worked__c) HoursWorked, 
                    Timesheet_Date__c  TimesheetDate,
                    ChartDate__c,
                    Timesheet__r.Account_Services__r.Account__C Account, 
                    Timesheet__r.Account_Services__r.ODS_Services__c Service
                FROM 
                    Time_Sheet_Details__c 
                WHERE 
                    Timesheet__r.Account_Services__r.Account__C =:slctdAccId 
                AND 
                    Timesheet__r.Account_Services__r.ODS_Services__c =:slctdSrvceId
                AND
                    Status__c =: 'Approved'  AND Status__c =: 'Submitted'
                Group by
                     Timesheet_Date__c,
                     ChartDate__c,
                     Timesheet__r.Account_Services__r.Account__C,
                     Timesheet__r.Account_Services__r.ODS_Services__c order by Timesheet_Date__c];     
        }  */
        else{
         
               return [SELECT 
                    sum(Hours_Worked__c) HoursWorked, 
                    Timesheet_Date__c  TimesheetDate,
                    ChartDate__c,
                    Timesheet__r.Account_Services__r.Account__C Account, 
                    Timesheet__r.Account_Services__r.ODS_Services__c Service
                FROM 
                    Time_Sheet_Details__c 
                WHERE 
                    Timesheet__r.Account_Services__r.Account__C =:slctdAccId 
                AND 
                    Timesheet__r.Account_Services__r.ODS_Services__c =:slctdSrvceId
                AND
                    Status__c =: 'Approved'
                Group by
                     Timesheet_Date__c,
                     ChartDate__c,
                     Timesheet__r.Account_Services__r.Account__C,
                     Timesheet__r.Account_Services__r.ODS_Services__c order by Timesheet_Date__c];
                     
          }  
          
                  
    }
    
   
    /// <OBJECTIVE>
    /// Method to insert Client Queries
    /// </OBJECTIVE>
    
    public static ClientQueries__c insertClientQueries(Id accntSrvId, String query, Date queryDate, Id tamId, String tamEmail, 
                                                      String clientEmail, string clientName, string accName, string serviceName)
    {
        ClientQueries__c objQueries = new ClientQueries__c();
    
        objQueries.Account_Services__c = accntSrvId;
        objQueries.Queries__c = query;
        objQueries.Query_Date__c = queryDate;
        objQueries.Technical_Account_Manager__c = tamId;
        objQueries.TAM_Email__c = tamEmail;
        objQueries.Client_Email__c = clientEmail;
        objQueries.Client_Name__c = clientName;
        objQueries.Account_Name__c = accName;
        objQueries.Service_Name__c = serviceName;
        insert objQueries;
        
        return objQueries;
    }
    
    // This method is for fetching all Customers ODS,Regular,Saving Cost. 
    public static List<Decimal>  fetchCurrentAllMthCost(string strAcntId,string strcustSrvceId,string strMonth,string strYear){
        List<Decimal> COSTS = new List<Decimal>();
        Decimal ODS_Cost = 0;
        Decimal Regular_Cost = 0;
        Decimal Saving_Cost = 0;

      //  List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Cost__c FROM Time_Sheet_Cost__c WHERE Month__c =: strMonth  AND Year__c =: strYear AND ODS_Cost__c  != null];
        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Cost__c,Regular_Cost__c,Saving_Cost__c FROM Time_Sheet_Cost__c WHERE Month__c =: strMonth  AND Year__c =: strYear];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Cost__c !=0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost +=  objTme.ODS_Cost__c; 
                         }
                         if(objTme.Regular_Cost__c !=0 && objTme.Regular_Cost__c != null){
                                 Regular_Cost += objTme.Regular_Cost__c;
                         }
                         if(objTme.Saving_Cost__c !=0 && objTme.Saving_Cost__c != null){
                                 Saving_Cost += objTme.Saving_Cost__c;
                         }
            }
        }
        COSTS.add(Saving_Cost);
        COSTS.add(ODS_Cost);
        COSTS.add(Regular_Cost);  
        return COSTS;
    }
    
    public static List<Time_Sheet_Cost__c> fetchCurrentMthCost(string strAcntId,string strcustSrvceId,string strMonth,string strYear)
    {
        //List<Time_Sheet_Cost__c> lstTimeSt = new list<Time_Sheet_Cost__c>();
        return [SELECT 
                     Id,
                     ODS_Cost__c,
                     Regular_Cost__c,
                     Saving_Cost__c 
               FROM Time_Sheet_Cost__c 
               WHERE Account_Services__r.Account__c =: strAcntId 
               AND Account_Services__r.ODS_Services__c =: strcustSrvceId 
               AND Month__c =: strMonth  
               AND Year__c =: strYear];

    }
    
    // This method is for fetching all Customers ODS,Regular,Saving Cost for all accounts.
    public static List<Decimal> fetchCurrentAllMthCostAccounts(string strAcntId,string strcustSrvceId,string strMonth,string strYear){

         List<Decimal> COSTS = new List<Decimal>();
         Decimal ODS_Cost = 0;
         Decimal Regular_Cost = 0;
         Decimal Saving_Cost = 0;
         List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Cost__c,Regular_Cost__c,Saving_Cost__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.ODS_Services__c =: strcustSrvceId AND Month__c =: strMonth  AND Year__c =: strYear];     
         if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Cost__c !=0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost +=  objTme.ODS_Cost__c; 
                         }
                         if(objTme.Regular_Cost__c !=0 && objTme.Regular_Cost__c != null){
                                 Regular_Cost += objTme.Regular_Cost__c;
                         }
                         if(objTme.Saving_Cost__c !=0 && objTme.Saving_Cost__c != null){
                                 Saving_Cost += objTme.Saving_Cost__c;
                         }
            }
        }
        
         
         COSTS.add(Saving_Cost);
         COSTS.add(ODS_Cost);
         COSTS.add(Regular_Cost);        
         return COSTS;   
    }
    
    
    // This method is for fetching all Customers ODS,Regular,Saving Cost for all services.
    public static List<Decimal> fetchCurrentAllMthCostServices(string strAcntId,string strcustSrvceId,string strMonth,string strYear){
         List<Decimal> COSTS = new List<Decimal>();
         
       /*  AggregateResult ODS= [SELECT SUM(ODS_Cost__c) ODS_Cost FROM Time_Sheet_Cost__c WHERE Account_Services__r.Account__c =: strAcntId AND Month__c =: strMonth AND Year__c =: strYear AND ODS_Cost__c != null];
         AggregateResult REGULAR= [SELECT SUM(Regular_Cost__c) Regular_Cost FROM Time_Sheet_Cost__c WHERE Account_Services__r.Account__c =: strAcntId AND Month__c =: strMonth AND Year__c =: strYear AND Regular_Cost__c != null];             
         AggregateResult SAVING = [SELECT SUM(Saving_Cost__c) Saving_Cost FROM Time_Sheet_Cost__c  WHERE Saving_Cost__c !=null AND Account_Services__r.Account__c =: strAcntId AND Month__c =: strMonth  AND Year__c =: strYear];

         if(ODS == null){ COSTS.add(0); } else{ COSTS.add((Decimal)ODS.get('ODS_Cost')); }
        
         if(REGULAR == null){ COSTS.add(0); } else{ COSTS.add((Decimal)REGULAR.get('Regular_Cost')); }

         if(SAVING == null) { COSTS.add(0); } else{ COSTS.add((Decimal)SAVING.get('Saving_Cost')); }
         
         return COSTS; */
         Decimal ODS_Cost = 0;
         Decimal Regular_Cost = 0;
         Decimal Saving_Cost = 0;

         List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Cost__c,Regular_Cost__c,Saving_Cost__c FROM Time_Sheet_Cost__c WHERE  Account_Services__r.Account__c =: strAcntId AND Month__c =: strMonth  AND Year__c =: strYear];     
         if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Cost__c !=0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost +=  objTme.ODS_Cost__c; 
                         }
                         if(objTme.Regular_Cost__c !=0 && objTme.Regular_Cost__c != null){
                                 Regular_Cost += objTme.Regular_Cost__c;
                         }
                         if(objTme.Saving_Cost__c !=0 && objTme.Saving_Cost__c != null){
                                 Saving_Cost += objTme.Saving_Cost__c;
                         }
            }
        }
         COSTS.add(Saving_Cost);
         COSTS.add(ODS_Cost);
         COSTS.add(Regular_Cost);     
         return COSTS;  
    }
    
    
    public static Organization  fetchFiscalYrStartingMonth(Id CurrentUserId)
    {
        return [SELECT FiscalYearStartMonth
                FROM Organization
                WHERE id=: CurrentUserId];
    } 
    
    // This method is for fetching all Customers ODS,Regular,Saving Cost Yearly.
    public static List<Decimal> fetchCurrentAllYearCost(string strAcntId,string strcustSrvceId,Date FYStartDt,Date FYEnddt){
       List<Decimal> COSTS = new List<Decimal>();
       Decimal ODS_Cost = 0;
       Decimal Regular_Cost = 0;

       List<Time_Sheet_Cost__c>  ODS = [SELECT ODS_Cost__c,Regular_Cost__c FROM Time_Sheet_Cost__c];  
       if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.Regular_Cost__c !=0 && objTme.Regular_Cost__c != null){
                                 Regular_Cost += objTme.Regular_Cost__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
       
       COSTS.add(ODS_Cost);
       COSTS.add(Regular_Cost);    
       return COSTS;
    }
    
    
    
    public static List<Decimal> fetchCurrentAllYearCostAccounts(string strAcntId,string strcustSrvceId,Date FYStartDt,Date FYEnddt){
        List<Decimal> COSTS = new List<Decimal>();
        Decimal ODS_Cost = 0;
        Decimal Regular_Cost = 0;
        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Cost__c,Regular_Cost__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.ODS_Services__c =: strcustSrvceId];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.Regular_Cost__c !=0 && objTme.Regular_Cost__c != null){
                                 Regular_Cost += objTme.Regular_Cost__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
        COSTS.add(ODS_Cost);
        COSTS.add(Regular_Cost);
        return COSTS;
    }
    
    public static List<Decimal> fetchCurrentAllYearCostServices(string strAcntId,string strcustSrvceId,Date FYStartDt,Date FYEnddt){
        List<Decimal> COSTS = new List<Decimal>();
        Decimal ODS_Cost = 0;
        Decimal Regular_Cost = 0;

        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Cost__c,Regular_Cost__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.Account__c =: strAcntId];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.Regular_Cost__c !=0 && objTme.Regular_Cost__c != null){
                                 Regular_Cost += objTme.Regular_Cost__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
        
        COSTS.add(ODS_Cost);
        COSTS.add(Regular_Cost);      
        return COSTS;
    }
    
    
    
    public static List<Time_Sheet_Cost__c> fetchCurrentYearCost(string strAcntId,string strcustSrvceId,Date FYStartDt,Date FYEnddt)
    {
        //Time_Sheet_Cost__c lstTmeSht = new Time_Sheet_Cost__c();
        return [SELECT 
                     Id,
                     ODS_Cost__c,
                     Regular_Cost__c,
                     Saving_Cost__c 
               FROM Time_Sheet_Cost__c 
               WHERE Account_Services__r.Account__c =: strAcntId 
               AND Account_Services__r.ODS_Services__c =: strcustSrvceId 
               //AND Start_Date_of_Month__c >=: FYStartDt
               //AND End_Date_of_Month__c <=: FYEnddt
               ];
    }
    
    public static List<Decimal> fetchOdsALLTmeSht(string strAcntId,string strcustSrvceId,string strMonth,string strYear){
       List<Decimal> Costs = new List<Decimal>();
       Decimal ODS_Hours = 0;
       Decimal ODS_Cost = 0;
       List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Hours__c,ODS_Cost__c FROM Time_Sheet_Cost__c WHERE  Month__c =: strMonth AND Year__c =: strYear];
       if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Hours__c !=0  && objTme.ODS_Hours__c != null){
                                 ODS_Hours += objTme.ODS_Hours__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
       
       Costs.add(ODS_Hours);
       Costs.add(ODS_Cost);
       return Costs;
    }
    
    public static List<Decimal> fetchOdsALLTmeShtAccounts(string strAcntId,string strcustSrvceId,string strMonth,string strYear){
        List<Decimal> COSTS = new List<Decimal>();
        Decimal ODS_Hours = 0;
        Decimal ODS_Cost = 0;
        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Hours__c,ODS_Cost__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.ODS_Services__c =: strcustSrvceId AND Month__c =: strMonth AND Year__c =: strYear];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Hours__c !=0 && objTme.ODS_Hours__c != null){
                                 ODS_Hours += objTme.ODS_Hours__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
        Costs.add(ODS_Hours);
        Costs.add(ODS_Cost);
        return COSTS;
    }
    
    public static List<Decimal> fetchOdsALLTmeShtServices(string strAcntId,string strcustSrvceId,string strMonth,string strYear){
        List<Decimal> COSTS = new List<Decimal>();
        Decimal ODS_Hours = 0;
        Decimal ODS_Cost = 0;
        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Hours__c,ODS_Cost__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.Account__c =: strAcntId AND Month__c =: strMonth AND Year__c =: strYear];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Hours__c !=0 && objTme.ODS_Hours__c != null){
                                 ODS_Hours += objTme.ODS_Hours__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
        Costs.add(ODS_Hours);
        Costs.add(ODS_Cost);
        return COSTS;
    }
    
    public static List<Decimal> fetchOdsALLYearTmeShtAccounts(string strAcntId,string strcustSrvceId,Date FYStartDt,Date FYEnddt){
        List<Decimal> COSTS = new List<Decimal>();
        Decimal ODS_Hours = 0;
        Decimal ODS_Cost = 0;
        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Hours__c,ODS_Cost__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.ODS_Services__c =: strcustSrvceId];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Hours__c !=0 && objTme.ODS_Hours__c != null){
                                 ODS_Hours += objTme.ODS_Hours__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
        Costs.add(ODS_Hours);
        Costs.add(ODS_Cost);
        return COSTS;   
    }
    
    public static List<Decimal> fetchOdsALLYearTmeShtServices(string strAcntId,string strcustSrvceId,Date FYStartDt,Date FYEnddt){
        List<Decimal> COSTS = new List<Decimal>();
        Decimal ODS_Hours = 0;
        Decimal ODS_Cost = 0;

        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Hours__c,ODS_Cost__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.Account__c =: strAcntId];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Hours__c !=0 && objTme.ODS_Hours__c != null  ){
                                 ODS_Hours += objTme.ODS_Hours__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
        Costs.add(ODS_Hours);
        Costs.add(ODS_Cost);
        return COSTS; 
    }
    
    public static List<Time_Sheet_Cost__c> fetchOdsTmeSht(string strAcntId,string strcustSrvceId,string strMonth,string strYear)
    {
         if(strAcntId == 'All' && strcustSrvceId == 'All'){
            return [SELECT Id,ODS_Hours__c, Start_Date_of_Month__c,End_Date_of_Month__c,ODS_Cost__c FROM Time_Sheet_Cost__c WHERE Month__c =: strMonth AND Year__c =: strYear];
         }
         else if(strAcntId != 'All' && strcustSrvceId == 'All'){
            return [SELECT Id,ODS_Hours__c, Start_Date_of_Month__c,End_Date_of_Month__c,ODS_Cost__c FROM Time_Sheet_Cost__c 
                    WHERE Account_Services__r.Account__c =: strAcntId AND Month__c =: strMonth AND Year__c =: strYear];
         }
         else if(strAcntId == 'All' && strcustSrvceId != 'All'){
            return [SELECT Id,ODS_Hours__c, Start_Date_of_Month__c,End_Date_of_Month__c,ODS_Cost__c FROM Time_Sheet_Cost__c 
                    WHERE Account_Services__r.ODS_Services__c =: strcustSrvceId AND Month__c =: strMonth AND Year__c =: strYear];
         }
         else{
            return [SELECT Id,ODS_Hours__c, Start_Date_of_Month__c,End_Date_of_Month__c,ODS_Cost__c FROM Time_Sheet_Cost__c 
                    WHERE Account_Services__r.Account__c =: strAcntId AND Account_Services__r.ODS_Services__c =: strcustSrvceId
                    AND Month__c =: strMonth
                    AND Year__c =: strYear];
         }
    }
    public static List<Time_Sheet_Cost__c> fetchOdsTmeShtAllAccountService(string strMonth,string strYear)
    {
         return [SELECT 
                     Id,
                     ODS_Hours__c, 
                     Start_Date_of_Month__c,
                     End_Date_of_Month__c,
                     ODS_Cost__c
                 FROM Time_Sheet_Cost__c 
                 WHERE  Month__c =: strMonth
                 AND Year__c =: strYear];

    }
     
    public static List<Decimal> fetchOdsALLYearTmeSht(){
        List<Decimal> Costs = new List<Decimal>();
        Decimal ODS_Hours = 0;
        Decimal ODS_Cost = 0;

        List<Time_Sheet_Cost__c> ODS = [SELECT ODS_Hours__c,ODS_Cost__c FROM Time_Sheet_Cost__c];
        if(!(ODS.isEmpty())){
            for(Time_Sheet_Cost__c objTme : ODS){
                         if(objTme.ODS_Hours__c !=0 && objTme.ODS_Hours__c != null){
                                 ODS_Hours += objTme.ODS_Hours__c;
                         }
                         if(objTme.ODS_Cost__c != 0 && objTme.ODS_Cost__c != null){
                                 ODS_Cost += objTme.ODS_Cost__c;
                         }
            }
        }
        Costs.add(ODS_Hours);
        Costs.add(ODS_Cost);
        return Costs;
    }
   
    
    public static List<Time_Sheet_Cost__c> fetchOdsYearTmeSht(string strAcntId,string strcustSrvceId,Date FYStartDt,Date FYEnddt)
    {
         if(strAcntId == 'All' && strcustSrvceId == 'All'){
              return [SELECT Id,ODS_Hours__c,ODS_Cost__c,Start_Date_of_Month__c FROM Time_Sheet_Cost__c];
         }
         else if(strAcntId != 'All' && strcustSrvceId == 'All'){
              return [SELECT Id,ODS_Hours__c,ODS_Cost__c,Start_Date_of_Month__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.Account__c =: strAcntId];
         }
         else if(strAcntId == 'All' && strcustSrvceId != 'All'){
              return [SELECT Id,ODS_Hours__c,ODS_Cost__c,Start_Date_of_Month__c FROM Time_Sheet_Cost__c WHERE Account_Services__r.ODS_Services__c =: strcustSrvceId];
         }
         else{
              return [SELECT 
                     Id,
                     ODS_Hours__c,
                     ODS_Cost__c,
                     Start_Date_of_Month__c
                 FROM Time_Sheet_Cost__c 
                 WHERE Account_Services__r.Account__c =: strAcntId
                 AND Account_Services__r.ODS_Services__c =: strcustSrvceId
                 //AND Start_Date_of_Month__c >=: FYStartDt
                 //AND End_Date_of_Month__c <=: FYEnddt
                 ];
         }
    }
    
    
    /*public static List<Timesheet__c> FetchTimesheetDetailsByDate(string AccountServiceId, Date WeekStart, Date WeekEnd)
    {
        return [SELECT Id,                    
                    Name,
                    Account_Services__c,
                    Status__c,
                    Week_Start_Date__c,
                    Week_End_Date__c,
                    Approver_Name__c,
                    Approver_Name__r.Name,
                    Approved_Date__c,
                    Comments__c,
                    Total_Hours__c,
                    (SELECT Id,
                        Row_No__c,
                        Hours_Worked__c,
                        Resource__c,
                        Task_Name__c,
                        Timesheet__c,
                        Timesheet_Date__c
                    FROM
                        Timesheet_Details__r
                    ORDER BY Row_No__c)
                FROM
                    Timesheet__c
                WHERE
                    Week_Start_Date__c =: WeekStart
                    AND
                    Week_End_Date__c =: WeekEnd
                    AND
                    Account_Services__c =: AccountServiceId
                    AND
                    Account_Services__c != null];
    }*/

    public static List<Aggregateresult> GetAggregateTimesheetDetails(string TimesheetId, string AccountServiceId)
    {
        return [SELECT 
                        Row_No_Value__c,
                        Resource__c,
                        Task_Name__c,
                        Initiative_Name__c
                    FROM
                        Time_Sheet_Details__c
                    WHERE
                       
                        Timesheet__r.Account_Services__c =: AccountServiceId
                        
                        AND
                        Timesheet__c =: TimesheetId
                   Group BY
                        Row_No_Value__c,
                        Resource__c,
                        Task_Name__c,
                        Initiative_Name__c
                    
               ];
    }
    /// <OBJECTIVE>
    /// fetch the User Photo by user id.
    /// </OBJECTIVE>
    
    Public static List<User_Photo__c> fetchUserPhotoByUserId(set<Id> userId)
    {
    return [SELECT 
                User__c,
                User__r.Name 
            FROM 
                User_Photo__c 
            WHERE 
                User__c IN:userId]; 
    }
    /// <OBJECTIVE>
    /// fetch the Attachment by User Photo id.
    /// </OBJECTIVE>
    
    Public static List<Attachment> fetchAttachmentByUserPhotoId(string userPhotoId)
    {
    return 
        [SELECT 
            Id 
        FROM 
            Attachment 
        WHERE
            parentId =: userPhotoId
        AND 
            (ContentType LIKE '%jpeg%' OR ContentType LIKE '%png%')];
    }
    /// <OBJECTIVE>
    /// To fetch the attachment of the Contact.
    /// </OBJECTIVE>    
    Public static Contact fetchAttachmentByContactId(string conId)
    {
    return [SELECT 
                Id,
                Name,
                MobilePhone,
                Email,
                (SELECT Id, ContentType FROM Attachments WHERE ContentType LIKE '%jpeg%' OR ContentType LIKE '%png%') 
            FROM 
                Contact
            WHERE 
                Id =: conId];
    }
     /// <OBJECTIVE>
    /// To fetch the User details
    /// </OBJECTIVE> 
    Public static List< User> getUserdetails(string UserName)
    {
        
        return [Select id,
                       Name,
                       Username,
                       ProfileId,
                       Is_Portal_Access__c,
                       PortalUserRole__c
                        
                   FROM
                        User
                   WHERE  
                        Username = :UserName];
    }  
    /// <OBJECTIVE>
    /// fetch the user name for the contact
    /// </OBJECTIVE>
    
    Public static List<user> getContactUserName(set<Id> conNameIdSet)
    {
    
    return [SELECT 
                Id,
                Contact.FirstName,
                Contact.LastName, 
                ContactId 
            FROM 
                User 
            WHERE
                ContactId IN: conNameIdSet];  
    }
    
    /// <OBJECTIVE>
    /// update user name for the contact
    /// </OBJECTIVE>
    
    Public static List<user> updateConUserName(List<User> conUsrNameLst)
    {
        update conUsrNameLst;
        return conUsrNameLst;
    }
    /// <OBJECTIVE>
    /// fetch the resource name for the selected account and service.
    /// </OBJECTIVE>
        
    Public static AggregateResult[] getResourceNameByAccountServiceId(string slctdAccId, string slctdSrvceId)
    {
        return [SELECT 
                    Id ResourceId,
                    Account__c Account, 
                    ODS_Services__c Service, 
                    Resource_Name__c ResourceName 
                FROM 
                    Project_Team_Member__c 
                WHERE 
                    Account__c =: slctdAccId
                AND
                    ODS_Services__c =:slctdSrvceId    
                Group by
                    Id,
                    ODS_Services__c,
                    Account__c,
                    Resource_Name__c
                Order by
                    Resource_Name__c];
   }
  
   Public static AggregateResult[] getInitiativeByAccountServiceId(string slctdAccId, string slctdSrvceId)
    {
        return [SELECT 
                    Id InitiativeId,
                    Account_Service__c AccountService, 
                    Account_Service__r.Account__c Account,
                    Account_Service__r.ODS_Services__c Service,   
                    Name InitiativeName 
                FROM 
                    Initiatives__c
                WHERE 
                    Account_Service__r.Account__c =: slctdAccId
                AND
                    Account_Service__r.ODS_Services__c =: slctdSrvceId
                AND
                    (Status__c = 'Initiative Approved' OR Status__c = 'Active Initiative' OR Status__c= 'Approved after Re-evaluation')
               
                Group by
                    Id,
                    Account_Service__r.ODS_Services__c,
                    Account_Service__r.Account__c,
                    Account_Service__c,
                    Name 
                Order by
                    Name ];
   }
   
      
   Public static List<Initiatives__c> fetchInitiativeByAcntId(set<Id> accId)
   {
   return [SELECT 
                Id,
                    Account_Service__r.ODS_Services__c,
                    Account_Service__r.Account__c,
                    Account_Service__c,
                    Name  
            FROM 
                Initiatives__c
            WHERE 
                Account_Service__r.Account__c IN:accId]; 
    }
    
   /// <OBJECTIVE>
   /// fetch the  Team Member name details by account id.
   /// </OBJECTIVE>  
   Public static List<Project_Team_Member__c> fetchPrjctTeamMembrByAcntId(set<Id> accId)
   {
   return [SELECT 
                Account__c,
                ODS_Services__c,
                ODS_Services__r.name__c,
                Resource_Name__c 
            FROM 
                Project_Team_Member__c 
            WHERE 
                Account__c IN:accId]; 
    }
    
    /// <OBJECTIVE>
    /// fetch Resource Name from timesheet detail object by Resource Id.
    /// </OBJECTIVE>
    
    Public static List<Time_Sheet_Details__c> fetchResourceNameById(set<Id> ResourceId)
    {
    return [SELECT  
                Id,
                Resource_Id__c,
                Resource__c 
            FROM 
                Time_Sheet_Details__c 
            WHERE 
                Resource_Id__c IN: ResourceId]; 
                
    }
    /// <OBJECTIVE>
    /// update Resource Name from timesheet detail object.
    /// </OBJECTIVE>
    Public static List<Time_Sheet_Details__c> updateResourceName(List<Time_Sheet_Details__c> resourceNameLst)
    {
        update resourceNameLst;
        return resourceNameLst;
                
    }
   
    /// <OBJECTIVE>
    /// To hide or show copy button
    /// </OBJECTIVE>
    public static List<Status_Report__c> getPrevStatusRep(Id objAccntSrvcsId,Date SRDate)
    {
        return [SELECT 
                    Id,
                    CreatedDate,
                    Work_for_the_Day__c,
                    Work_for_the_Next_Day__c,
                    Issues_And_Concerns__c,
                    Status_Date__c,
                    Status__c 
                    FROM 
                        Status_Report__c 
                    WHERE 
                        Account_Services__c =: objAccntSrvcsId  AND 
                        Status_date__c <: SRDate 
                        ORDER BY Status_Date__c DESC];
    }
    /// <OBJECTIVE>
    /// Fetch Status Report based on Date
    /// </OBJECTIVE>
    Public static List<Status_Report__c> getSRBsdOnDate(Date SRDate,Id objAccntSrvcsId)
    {
        return[SELECT 
                    Id,
                    Status_Date__c 
                    FROM 
                    Status_Report__c 
                    WHERE Status_Date__c =: SRDate AND 
                    Account_Services__c =: objAccntSrvcsId];
    }
    
    /// <OBJECTIVE>
    /// Fetch submitted Hours
    /// </OBJECTIVE>
    public static List<Timesheet__c> fetchSubmittedHrs(string strAcntSrvId)
    {
        return [SELECT 
                     Id,
                     Total_Hours__c
               FROM Timesheet__c
               WHERE Account_Services__c =: strAcntSrvId
               AND 
               Status__c =: 'Submitted']; 
    }
    
    public static AggregateResult[] fetchHrsWaitingForApprovalALL(List<Account_Services__c > allAccountServiceIds){
        return [SELECT 
                    Sum(Total_Hours__c) WaitingHrs
               FROM Timesheet__c
               WHERE Account_Services__c IN: allAccountServiceIds
               AND 
               Status__c =: 'Submitted' group by Status__c ]; 
       
    }
    
    public static AggregateResult[] fetchHrsWaitingForApproval(string strAcntSrvId)
    {
        return [SELECT 
                    Sum(Total_Hours__c) WaitingHrs
               FROM Timesheet__c
               WHERE Account_Services__c =: strAcntSrvId
               AND 
               Status__c =: 'Submitted' group by Status__c ]; 
    }
    
    ///<OBJECTIVE>
    /// Fetch Account Service record
    ///</OBJECTIVE>
    public static List<Account_Services__c> fetchAllAcntSrv(string strAcntId,string strSrvId)
    {
        List<Account_Services__c> accServList=new List<Account_Services__c>();
        if(strAcntId != 'All' && strSrvId == 'All')
        {       
            accServList=[SELECT Id FROM Account_Services__c WHERE Account__c =: strAcntId];        
        }
        else if(strAcntId == 'All' && strSrvId != 'All')
        {
            accServList=[SELECT Id FROM Account_Services__c WHERE ODS_Services__c =: strSrvId]; 
        }
        else
        {
             accServList=[SELECT Id FROM Account_Services__c];         
        }   
        
        return accServList;      
    }
    
    ///<OBJECTIVE>
    /// Fetch Account Service record
    ///</OBJECTIVE>
    public static Account_Services__c fetchAcntSrv(string strAcntId,string strSrvId)
    {
       if(strAcntId == 'All' || strSrvId == 'All') { return null; } 
       else{  return[SELECT Id 
                  FROM
                  Account_Services__c 
                  WHERE 
                  Account__c =: strAcntId AND
                  ODS_Services__c =: strSrvId]; }
    }
    
    public static List<Status_Report__c> fetchSR(Id objAccntSrvcsId,Date SRDate)
    {
        return[SELECT Id,
                       CreatedDate,
                       Work_for_the_Day__c,
                       Work_for_the_Next_Day__c,
                       Issues_And_Concerns__c,
                       Status_Date__c,
                       Status__c 
                       FROM 
                       Status_Report__c 
                       WHERE 
                       Account_Services__c =: objAccntSrvcsId AND
                       status_date__c =: SRDate];
   }
   // <OBJECTIVE>
   /// Fetch the Rally related details using AccountService id.
   /// </OBJECTIVE>    
   public static Account_Services__c fetchRallyDetailsByAccountServiceId(String AccountId, String ServiceId)
   {
        return [SELECT 
                    Account__c,
                    ODS_Services__c,
                    Rally_password__c,
                    Rally_Project_Name__c,
                    Rally_User_Name__c,
                    Service_Workspace_Id__c,
                    JIRA_Domain_Name__c,
                    Agile__c
                FROM 
                    Account_Services__c 
                WHERE 
                    Account__c =: AccountId 
                AND 
                    ODS_Services__c =: ServiceId
                Limit 1]; 
    }
    // <OBJECTIVE>
    /// Fetch the Documents based on Account and Service Id
    /// </OBJECTIVE>
    public static List<Documents__c> FetchDocuments(string accountId, string serviceId, string fromDate, string toDate, string documentName, string documentType)
    {
        DateTime filterFromDate;
        DateTime filterToDate;
        DateTime addFromDate;
        DateTime addToDate;
        string fromDateFormat = ''; string toDateFormat ='';
        if(fromDate != '' && fromDate !=null)
        {
            filterFromDate = Date.parse(fromDate);
            fromDateFormat =filterFromDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }
        if(toDate!= '' && toDate!=null)
        {
            filterToDate= Date.parse(toDate);
            toDateFormat =filterToDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        }
        
        string accountServiceQuery = 'SELECT CreatedDate, CreatedBy.Name,Name,Account__r.Name,Services__r.Name,Attachment_File__c, Document_Type__c,Project_Name__c, SprintNumber__c,Attachment_Id__c, Id FROM Documents__c Where Is_Deleted__c = true AND';
        
        if(accountId != 'All' && serviceId != 'All')
        {
             accountServiceQuery += ' Account__c =: accountId  AND Services__c =:serviceId AND';
        }  
        else if (accountId == 'All' && serviceId != 'All')
        {
            accountServiceQuery += ' Services__c =: serviceId AND';
        }
        else if (accountId != 'All' && serviceId == 'All')
        {
            accountServiceQuery += ' Account__c =: accountId AND';
        }
         system.debug('-----Filter---');
         //addFromDate = filterFromDate.addDays(1);      
        if (fromDate!= '' && fromDate!= null)
        {
           accountServiceQuery += ' CreatedDate >=: filterFromDate AND'; 
        }
        if (toDate != '' && toDate != null)
        {
            addToDate = filterToDate.addDays(1); 
            accountServiceQuery += ' CreatedDate  <=: addToDate AND'; 
        }
        if (documentName != '' && documentName != null )
        {
            accountServiceQuery += ' Name Like\''+String.escapeSingleQuotes(documentName)+'%\' AND'; 
        }
        if (documentType != '' && documentType != null && documentType != 'Document Type')
        {
            accountServiceQuery += ' Document_Type__c =: documentType  AND'; 
        }
        
        accountServiceQuery = (accountServiceQuery.trim()).removeEnd('Where');

        accountServiceQuery = (accountServiceQuery.trim()).removeEnd('AND');//+' ORDER BY CreatedDate Desc';

        system.debug('-----Query--' + accountServiceQuery + fromDateFormat + toDateFormat);   
            
        List<Documents__c> documentList = new List<Documents__c>();
        documentList = database.query(accountServiceQuery);
        system.debug('-----Query-- Size' + documentList.size());   

        return documentList;
   } 

   public static List<Invoice__c> FetchInvoice(string accountId, string serviceId, string Month, Integer Year, string sortOrder)
    {
       /* DateTime filterFromDate;
        DateTime filterToDate;
        string fromDateFormat = ''; string toDateFormat ='';
        if(fromDate != '' && fromDate !=null)
        {
            filterFromDate = Date.parse(fromDate);
            fromDateFormat =filterFromDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');    
        }
        if(toDate!= '' && toDate!=null)
        {
            filterToDate= Date.parse(toDate);
            toDateFormat =filterToDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        }*/
        string YearString =string.valueof(Year);
        
        string accountServiceQuery = 'SELECT CreatedDate, CreatedById,LastModifiedBy.Name,CreatedBy.Name,LastModifiedDate,Attachment_File__c,Account_Services__r.Account__c,Account_Services__r.ODS_Service_Name__c,Account_Services__r.Account__r.Name,Account_Services__r.ODS_Services__c, Attachment_Id__c,Comments__c, Month__c,Year__c, Id FROM Invoice__c Where ';
        
        if(accountId != 'All' && serviceId != 'All')
        {
             accountServiceQuery += ' Account_Services__r.Account__c =: accountId  AND Account_Services__r.ODS_Services__c =:serviceId AND';
        }  
        else if (accountId == 'All' && serviceId != 'All')
        {
            accountServiceQuery += ' Account_Services__r.ODS_Services__c =: serviceId AND';
        }
        else if (accountId != 'All' && serviceId == 'All')
        {
            accountServiceQuery += ' Account_Services__r.Account__c =: accountId AND';
        }
        if (Month == null || Month == 'Month')
        {
            
        }
        else{
            accountServiceQuery += ' Month__c =: Month AND'; 
        }
        if (Year == null || YearString == 'Year' || Year == 0)
        {
            
        }
        else{
            accountServiceQuery += ' Year__c =:Year AND'; 
        }
        
        accountServiceQuery = (accountServiceQuery.trim()).removeEnd('AND'); //+' ORDER BY LastModifiedDate Desc';
        accountServiceQuery = (accountServiceQuery.trim()).removeEnd('Where'); //+' ORDER BY LastModifiedDate Desc';
        accountServiceQuery+=' ORDER BY '+sortOrder;
        system.debug('-----Query--' + accountServiceQuery + Month + Year); 
        system.debug('&&&&&accountServiceQuery'+accountServiceQuery);   
        system.debug('&&&&&Month'+Month); 
        system.debug('&&&&&Year'+Year); 
        system.debug('&&&&&accountId '+accountId );
        system.debug('&&&&&serviceId '+serviceId );                   
        List<Invoice__C> invoiceList = new List<Invoice__C>();
        invoiceList = database.query(accountServiceQuery);
        system.debug('&&&&&invoiceList '+invoiceList );
        return invoiceList;
    }
   
    ///<OBJECTIVE>
    /// Get Account Service Id
    ///</OBJECTIVE>
    public static string GetAccountServiceDetails(string AccountId,string ServiceId)
    {
        Account_Services__c[] accountServices = [SELECT Id,Account__r.Name,Document_Suffix__c FROM Account_Services__c WHERE Account__c =: AccountId AND ODS_Services__c =: ServiceId];
        
        string accountServiceId = '';
        
        if(accountServices.size() > 0 && accountServices != null)
        {
            accountServiceId = accountServices[0].Document_Suffix__c;
        }
        system.debug('--Accoount Id--' + AccountId+'-------Account Service Id - ' + accountServiceId);
        return accountServiceId;
        
    }
    ///<OBJECTIVE>
    /// Get Account Service Id
    ///</OBJECTIVE>
    public static string GetAccSerDetails(string AccountId,string ServiceId)
    {
        Account_Services__c[] accountServices = [SELECT Id,Account__r.Name,Document_Suffix__c FROM Account_Services__c WHERE Account__c =: AccountId AND ODS_Services__c =: ServiceId];
        
        string accountServiceId = '';
        
        if(accountServices.size() > 0 && accountServices != null)
        {
            accountServiceId = accountServices[0].Id;
        }
        system.debug('--Accoount Id--' + AccountId+'-------Account Service Id - ' + accountServiceId);
        return accountServiceId;
        
    }  
    
    public static string GetAccSerDocumentPrefix(string AccountId,string ServiceId)
    {
        Account_Services__c[] accountServices = [SELECT Id,Account__r.Name,Document_Suffix__c FROM Account_Services__c WHERE Account__c =: AccountId AND ODS_Services__c =: ServiceId];
        
        string accountServiceDocSuffix = '';
        
        if(accountServices.size() > 0 && accountServices != null)
        {
            if(accountServices[0].Document_Suffix__c != null || accountServices[0].Document_Suffix__c != ''){
                accountServiceDocSuffix = accountServices[0].Document_Suffix__c + '_';
            }
        }
        system.debug('--Accoount Id--' + AccountId+'-------Account Service Id - ' + accountServiceDocSuffix );
        return accountServiceDocSuffix;
        
    }
    
    ///<OBJECTIVE>
    /// To Insert the Document Details and Attachment
    ///</OBJECTIVE>
    public static string InsertUpdateDocumentDetailsAttachment(string accountId, string serviceId, string documentType, string name,
                       string projectName, Decimal sprintNumber, Blob fileData, string filename, string documentId, string folderId,string fileExtension)
    {
    
      string attachmentId = '';
      string accountServiceId;
      
    
        system.debug('---InsertMethod---'+ filename);
        system.debug('---folderId---'+ folderId);
        //Insert the Document Details into Document Object
        Documents__c documents = null;
        if(documentId == '' || documentId ==null)
        {
            system.debug('---InsertMethod---'+ accountId + '---'+serviceId+'----'+name);
            documents = new Documents__c();      
            documents.Account__c = accountId;
            documents.Account_Services__c = serviceId;
            documents.Document_Type__c = documentType;
            documents.Name = name;
            documents.Project_Name__c = projectName;
            documents.SprintNumber__c =  sprintNumber;
            documents.Attachment_File__c = filename;
            documents.File_Extension__c =fileExtension;
            if(folderId != null && folderId !='')
            {
                documents.FolderId__c = folderId;
            }
            insert documents ;
            attachmentId = documents.Id;
        }
        else
        {
            system.debug('---UpdateMethod---'+ documentId);
            documents = new Documents__c(id=documentId);
            documents.Document_Type__c = documentType;
            documents.Name = name.trim();
            documents.Project_Name__c = projectName;
            documents.SprintNumber__c =  sprintNumber;
            documents.Attachment_File__c = filename;
            if(fileExtension != null && fileExtension !='')
            {
                documents.File_Extension__c = fileExtension;
            }
            if(folderId != null && folderId !='')
            {
                documents.FolderId__c = folderId;
            }
            else
            {
                documents.FolderId__c = null;

            }
            
            //documents.File_Extension__c =fileExtension;
                
            update documents ;
            attachmentId = documentId;
        }
        
        //Gets the Account Service Id to concate with file name
        //string documentSuffix = GetAccountServiceDetails(accountServiceId);
        Account_Services__c[] accountServices = [SELECT Id,Account__r.Name,Document_Suffix__c FROM Account_Services__c where Id=:serviceId];
        string documentSuffix = accountServices[0].Document_Suffix__c;
       system.debug('---documentSuffix '+documentSuffix  );
        transient blob blobFileDate = fileData;
        
        //Inserts the attachment into Attachment object
        Attachment attachment= null;
        
        if(documentId == '' || documentId == null)
        {
            attachment= new Attachment(); 
            attachment.parentId = documents.Id;
            attachment.body= blobFileDate;
            if(documentSuffix == null)
            {
                attachment.Name = filename;
            }
            else
            {
                attachment.Name = documentSuffix +'_'+ filename;
            }    
            insert attachment;
        }
        else
        {   
            system.debug('---UpdateMethod---Else---FileName'+filename );
            if(blobFileDate != null)
            {    
                system.debug('---UpdateMethod---Else If');
                Documents__c[] documentsData =  [Select Id,Attachment_Id__c from Documents__c where Id=:documentId];  
                attachment= new Attachment(id=documentsData[0].Attachment_Id__c);             
                attachment.body= blobFileDate;
                
               /* integer i = 0; string fileDocumentSuffix = ''; string fullFileName ='';
                //Split the file name with _ and check whether its a same file
                //If its a same file then keep the file name as same else add the suffix
                for(String fileNameSplit: filename.split('_'))
                {
                   if(i == 0)
                   {
                       fileDocumentSuffix = fileNameSplit;  
                        system.debug('------------Full Document Suffix'+fileDocumentSuffix );
                                    
                   }  
                    fullFileName += fullFileName + fileNameSplit;
                   system.debug('------------Full File Name'+fullFileName);       
                   
                     
                   i++;
                }*/
                
                if(filename.contains(documentSuffix))
                {
                integer index= filename.indexOf(documentSuffix);
                if(index== 0)
                {
                    attachment.Name = filename;
                    system.debug('------------Attachment Name'+filename);   
                }                
                
                else
                {
                     attachment.Name = documentSuffix +'_'+ filename;
                }
                }
                
                //system.debug('----Suffix----' + fileDocumentSuffix +'----' + fullFileName);
                
                update attachment;
            }
        }
        
        
        //Updates the attachentid into documents object
        if(documentId == '' || documentId ==null)
        {
            Documents__c queryDocuments= [SELECT Id FROM Documents__c WHERE Id =: documents.Id LIMIT 1];
            queryDocuments.Attachment_Id__c = attachment.Id;
            update queryDocuments;
        }
        
        return attachmentId;
        
       
    } 
    
    
    ///<OBJECTIVE>
    /// To Insert the Invoice Details and Attachment
    ///</OBJECTIVE>
    public static Invoice__c InsertUpdateInvoiceDetailsAttachment(string accountId, string serviceId,string fileName,
                       string Month, Decimal Year, Blob fileData, string Comments, string InvoiceId)
    {
    
      string attachmentId = '';
     
        system.debug('---InsertMethod---'+ filename);
        system.debug('---##InvoiceId##---'+ InvoiceId);
        //Insert the Invoice Details into Invoice Object
        Invoice__c Invoice = null;
        string accountServiceId = GetAccSerDetails(accountId, serviceId);
        if(InvoiceId == '' || InvoiceId == null)
        {
            system.debug('---Inside Insert Method---'+ InvoiceId);
            Invoice = new Invoice__c ();      
            Invoice.Account_Services__c = accountServiceId ;
            Invoice.Month__c = Month; 
            Invoice.Year__c = Year;
            Invoice.Comments__c = Comments;
            Invoice.Attachment_File__c = filename;  
            insert Invoice;
            system.debug('---Invoice---'+ Invoice);
            Invoice__c updateInvoice = new Invoice__c(Id=Invoice.Id);
            updateInvoice.Invoice_ID__c = Invoice.Id;
            update updateInvoice;            
        }
        else
        {
            system.debug('---InvoiceId---'+ InvoiceId);
            system.debug('---##Inside Update Method##---'+ InvoiceId);
            Invoice = new Invoice__c (id=InvoiceId);
            Invoice.Account_Services__c = accountServiceId ;
            Invoice.Month__c=  Month; 
            Invoice.Year__c =  Year;
            if(Invoice.Comments__c == 'undefined')
            {
                Invoice.Comments__c = '';
            }
            else
            {
                Invoice.Comments__c = Comments;
            }
            Invoice.Attachment_File__c = filename;   
            Invoice.Invoice_ID__c = InvoiceId;    
            update Invoice;
            system.debug('---UpdateInvoice---'+ Invoice);
            
        }
        
        //Gets the Account Service Id to concate with file name
        string documentSuffix = GetAccountServiceDetails(accountId, serviceId);
        transient blob blobFileDate = fileData;
        
        //Inserts the attachment into Attachment object
        Attachment attachment= null;
        
        if(InvoiceId == '' || InvoiceId == null)
        {
            attachment= new Attachment(); 
            attachment.parentId = Invoice.Id;
            attachment.body= blobFileDate;
            if(documentSuffix == null)
            {
                attachment.Name = filename;
            }
            else
            {
                attachment.Name = documentSuffix +'_'+ filename;
            }   
            insert attachment;
        }
        else
        {   
            system.debug('---UpdateMethod---Else---FileName'+filename );
            if(blobFileDate != null)
            {    
                system.debug('---UpdateMethod---Else If');
                Invoice__C[] InvoiceData =  [Select Id,Attachment_Id__c from Invoice__c where Id=:InvoiceId];  
                attachment= new Attachment(id=InvoiceData[0].Attachment_Id__c);             
                attachment.body= blobFileDate;
                
                integer i = 0; string fileDocumentSuffix = ''; string fullFileName ='';
                //Split the file name with _ and check whether its a same file
                //If its a same file then keep the file name as same else add the suffix
                for(String fileNameSplit: filename.split('_'))
                {
                   if(i == 0)
                   {
                       fileDocumentSuffix = fileNameSplit;                       
                   }  
                   
                   fullFileName += fullFileName + fileNameSplit;
                     
                   i++;
                }
                
                if(documentSuffix  == fileDocumentSuffix)
                {
                    attachment.Name = filename;                
                }
                else
                {
                     attachment.Name = documentSuffix +'_'+ filename;
                }
                
                system.debug('----Suffix----' + fileDocumentSuffix +'----' + fullFileName);
                
                update attachment;
            }
      }
        
        
        //Updates the attachentid into documents object
        if(InvoiceId == '' || InvoiceId ==null)
        {
            Invoice__c queryInvoice = [SELECT Id FROM Invoice__c WHERE Id =: Invoice.Id LIMIT 1];
            queryInvoice.Attachment_Id__c = attachment.Id;
            update queryInvoice ;
        }
        
        return Invoice;

    } 
   
    ///<OBJECTIVE>
    ///Validate the document Name Exists or not
    ///</OBJECTIVE>
    public static string ValidateDocument(string documentName, string accountId, string serviceId, string fileName, string documentId)
    {  
       Documents__c[] documents = null; 
       if(documentId == '')
       {      
           documents = [SELECT Id FROM Documents__c WHERE Account_Services__c =: serviceId AND Name =: documentName.trim()];
                         system.debug('----ValidateDocument---' + documents  );
                          system.debug('----ValidateDocumentService---' + serviceId);
                          system.debug('----ValidateDocumentName---' + documentName.trim());

       }
       else 
       {
           documents = [SELECT Id, Attachment_Id__c FROM Documents__c WHERE Account_Services__c =: serviceId AND Name =:documentName.trim() and Id !=: documentId];
                         system.debug('----ValidateDocument Else---' + documents );

       }        

       string errorMessage = ''; 
       //if(documents.body.size()>5242880 && documents != null)
       if(documents.size() > 0  && documents != null) 
       {          
          errorMessage = 'Document';
       }   
       system.debug('---fileName '+fileName );
        if(fileName != '')
        {
           string documentSuffix = GetAccountServiceDetails(serviceId);       
           string fileNameServiceId = documentSuffix + '_'+ fileName;
           system.debug('---Edit---FileName---'+fileNameServiceId );
           Attachment [] attachment = null;
           
           if(documentId == '')
           { 
               attachment = [SELECT Id FROM Attachment WHERE Name =: fileNameServiceId];
               system.debug('New File----');
           }
           else
           {     
               Documents__c[] documentsData =  [Select Id,Attachment_Id__c from Documents__c where Id=:documentId];       
               attachment = [SELECT Id FROM Attachment WHERE Name =: fileNameServiceId and Id !=: documentsData[0].Attachment_Id__c];
               system.debug('---Existing File----'); 
               system.debug('--DocumentId--'+documentId+'----AttachmentId---'+ documentsData[0].Attachment_Id__c);            
           }
           
           if(attachment.size() > 0 && attachment != null && fileName != '')
           {
              errorMessage =  errorMessage  + ' File';
           }    
       }     
    
       return errorMessage;    
    }
    ///<OBJECTIVE>
    /// Validate Invoice
    ///</OBJECTIVE>
    
     public static string ValidateInvoice(string accountId, string serviceId, string fileName, string InvoiceId)
    {  
       
       string errorMessage = ''; 
       system.debug('---fileName '+fileName );
        if(fileName != '')
        {
           string accountServiceDocSufix = GetAccSerDocumentPrefix(accountId, serviceId);       
           string fileNameServiceId = accountServiceDocSufix + fileName;
           system.debug('---Edit---FileName---'+fileNameServiceId );
           Attachment [] attachment = null;
           
           if(InvoiceId == '')
           { 
               attachment = [SELECT Id FROM Attachment WHERE Name =: fileNameServiceId];
               system.debug('New File----');
           }
           else
           {     
               Invoice__c[] InvoiceData =  [Select Id,Attachment_Id__c from Invoice__c where Id=:InvoiceId];       
               attachment = [SELECT Id FROM Attachment WHERE Name =: fileNameServiceId and Id !=: InvoiceData[0].Attachment_Id__c];
               system.debug('---Existing File----'); 
               system.debug('--InvoiceId--'+InvoiceId+'----AttachmentId---'+ InvoiceData[0].Attachment_Id__c);            
           }
           
           if(attachment.size() > 0 && attachment != null && fileName != '')
           {
              errorMessage = ' File';
           }    
       }     
    
       return errorMessage;    
    }


    ///<OBJECTIVE>
    ///Get the Document details
    ///</OBJECTIVE>
    public static string GetDocumentAttachment(string documentId,string AccountId,string ServiceId)
    { 
        Documents__c documents = [SELECT Attachment_Id__c,Document_Type__c,Id,Name,Project_Name__c,SprintNumber__c,FolderId__c,FolderId__r.Name FROM Documents__c WHERE Id =: documentId];
        string documentsJSON = Json.serialize( documents);
        system.debug('----AttachmentQuery'+ documents.Attachment_Id__c );
        system.debug('----FolderId__r.Name'+ documents.FolderId__r.Name);
        Attachment attachment = [SELECT Id, Name FROM Attachment WHERE Id =: documents.Attachment_Id__c];
        string attachmentJSON = Json.serialize(attachment);
        
        string accountServiceId;

        List<Folder__c> FolderNames = new List<Folder__c>();
        List<Account_Services__c > accServiceList = new List<Account_Services__c >();
        accServiceList =ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        system.debug('----accServList ----'+ accServiceList );
        
        if(accServiceList.size() > 0)
        {
            accountServiceId= accServiceList [0].Id;
            FolderNames = [SELECT Id,Name from Folder__c Where Account_Services__c =: accountServiceId];
        }
        else
        {
            accountServiceId= '';
        }
        
        
        string folderName = Json.serialize(FolderNames);
        system.debug('---folderName --'+ folderName );
        system.debug('---JSON--'+ attachmentJSON);
        
        return documentsJSON +'$$##'+attachmentJSON +'$$##'+folderName;
    }
    
     ///<OBJECTIVE>
    ///Get the Document details
    ///</OBJECTIVE>
    public static string GetInvoiceAttachment(string InvoiceId)
    { 
        List<Invoice__c> Invoice = new List<Invoice__c>();
        string InvoiceJSON;
        string attachmentJSON;
        Invoice = [SELECT ID,
                        Account_Services__c,
                        Attachment_Id__c,
                        Comments__c,
                        Month__c,
                        Invoice_ID__c,
                        Year__c From Invoice__c WHERE Id =: InvoiceId];
        if(invoice != null){                
            InvoiceJSON = Json.serialize(Invoice);
            system.debug('---InvoiceJSON--'+ InvoiceJSON );
        }
        
        List<Attachment> attachment = new List<Attachment>();
        attachment = [SELECT Id, Name FROM Attachment WHERE Id =: Invoice[0].Attachment_Id__c];
        
        if(attachment != null){
            attachmentJSON = Json.serialize(attachment);
            
            system.debug('---JSON--'+ attachmentJSON);
        }
        return InvoiceJSON +'$$##'+attachmentJSON;
    }
    
   
     ///<OBJECTIVE>
    ///Get the Invoice details
    ///</OBJECTIVE>
    public static void DeleteInvoice(string InvoiceId)
    { 
       
       Invoice__c[]  Invoice = [Select Id from Invoice__c where Id=: InvoiceId];
       delete Invoice;
       
    }
    
    ///<OBJECTIVE>
    ///Get Account Service Name
    ///</OBJECTIVE>
    public static Account_Services__c[] GetAccountServiceName(string accountId, string serviceId)
    { 
       Account_Services__c[]  accountService = [SELECT Account__r.Name,ODS_Services__r.Name, ODS_Service_Name__c, Technical_Account_manager__c, Technical_Account_manager__r.name,
                   Technical_Account_manager__r.Email FROM Account_Services__c where Account__c =: accountId AND ODS_Services__c =: serviceId];
       return accountService;
    }
    
    ///<OBJECTIVE>
    ///Get Account Service Name
    ///</OBJECTIVE>
    public static Documents__c[] GetAttachmentId(string documentId)
    { 
       Documents__c[] documents = [SELECT Attachment_Id__c FROM Documents__c where Id =: documentId];
       return documents;
    }
    
    public static Invoice__c[] GetInvoiceAttachmentId(string InvoiceId)
    { 
       Invoice__c[] Invoice = [SELECT Attachment_Id__c FROM Invoice__c where Id =: InvoiceId];
       return Invoice;
    }
    
     ///<OBJECTIVE>
    ///Get List of contact email ids based on flag field
    ///</OBJECTIVE>
    /*public static List<Contact> GetContactEmailIds(string accountId)
    {
        List<Contact> contacts = new List<Contact>();
        contacts = [Select Id, Email from Contact where AccountId =: accountId AND IsDocMailRequired__c =: true];
        return contacts;    
    }*/
    
    public static List<Contact_Account_Service__c> GetContactEmailIds(string accntId, string srvcId)
    {
        List<Contact_Account_Service__c> contacts = new List<Contact_Account_Service__c>();
        contacts = [SELECT ID,AccountId__c,Contact__r.AccountId,Email__c,Name,ODS_Service__c from Contact_Account_Service__c where  Contact__r.AccountId =: accntId AND ODS_Service__c =:srvcId AND IsDocMailRequired__c =: true];
        return contacts;    
    }
    
    ///<OBJECTIVE>
    ///Get List of User account email ids based on flag field
    ///</OBJECTIVE>
    public static List<User_Account__c> GetUserAccountEmailIds(string accountId, string serviceId)
    {
        List<User_Account__c> userAccounts = new List<User_Account__c>();
        userAccounts = [Select Id, User__r.Email, ODS_Services__c from User_Account__c where Account__c =: accountId
                 AND ODS_Services__c =: serviceId AND IsDocMailRequired__c =: true];
        return userAccounts;    
    }
    
    
     ///<OBJECTIVE>
    ///Get the Technical Account Manager based on account and service id
    ///</OBJECTIVE>
    public static User_Account__c[] GetTechnicalAccountManager(string accountId)
    {
        User_Account__c[] userAccount = [Select Id, name, User__c,User__r.Email,User__r.Name, Account__c, Role_in_Account__c from User_Account__c where Account__c =: accountId AND Role_in_Account__c = 'Technical Account Manager' LIMIT 1 ];        
        return userAccount;
    }
    
     ///<OBJECTIVE>
    ///Get the Technical Account Manager based on account and service id
    ///</OBJECTIVE>
    public static Documents__c[] GetDocumentDetails(string documentId)
    {
        Documents__c[] documents = [SELECT Name, Document_Type__c FROM Documents__c where Id =: documentId];
        return documents;
    }
      ///<OBJECTIVE>
    ///Get the Contact Account Service 
    ///</OBJECTIVE>
   public static List<Contact_Account_Service__c > GetcontactAccSer(string ODSService, string Contact)
    {
        List<Contact_Account_Service__c > contactAccountService = new List<Contact_Account_Service__c >();
        contactAccountService = [Select Id, ODS_Service__c,Contact__c,Status_Report_Required__c,IsDocMailRequired__c,Is_Approver__c from Contact_Account_Service__c where ODS_Service__c =: ODSService AND Contact__c =: Contact];
        return contactAccountService;    
    }
    
    public static List<Contact_Account_Service__c > GetAccServiceByContact(string Contact)
    {
        List<Contact_Account_Service__c > contactAccountService = new List<Contact_Account_Service__c >();
        contactAccountService = [Select Id, Account__c, ODS_Service__c,ODS_Service__r.Name__c,Contact__c from Contact_Account_Service__c where Contact__c =: Contact];
        return contactAccountService;    
    }
    
    
    //Fetch contact acnt service records based on ODS Engagement Type
    public static List<Contact_Account_Service__c > GetAccServiceByContactAndEngmtType(string Contact)
    {
        List<Contact_Account_Service__c > contactAccountService = new List<Contact_Account_Service__c >();
        contactAccountService = [Select Id, Account__c, ODS_Service__c,ODS_Service__r.Name__c,Contact__c from Contact_Account_Service__c where Contact__c =: Contact];
        return contactAccountService;    
    }
    
    /// <OBJECTIVE>
    /// fetch the Notificantion and return.
    /// </OBJECTIVE>    
    Public static List<Notification__c> GetNotification(string AccountServiceID, String CurrentMonth)
    {
        
        return [SELECT id, 
                        Name, 
                        Account_Services__c,
                        Key_data_Points__c,
                        Month__c
                        
                    From 
                        Notification__c
                    WHERE
                        Account_Services__c =: AccountServiceID
                    AND
                        Month__c =: CurrentMonth ORDER By CreatedDate desc];
    }
    
    /// <OBJECTIVE>
    /// fetch the Notificantion and return.
    /// </OBJECTIVE>    
    Public static list<Notification__c> GetPreviousMonthNotification(string AccountServiceID)
    {
        
        return [SELECT id, 
                        Name, 
                        Account_Services__c,
                        Key_data_Points__c,
                        Month__c
                        
                    From 
                        Notification__c
                    WHERE
                        Account_Services__c =: AccountServiceID ORDER By Month__c desc Limit 1
                    ];
        
    }
    
    ///<OBJECTIVE>
    ///Validate the Folder Name
    ///</OBJECTIVE>
    public static string ValidateFolder(string foldername,string accountServiceId)
    {  
       system.debug('----ValidateFolder---');
       Folder__c[] folders; 
       if(foldername != '')
       {  
           system.debug('----FolderName---'+foldername );    
           folders = [SELECT Id, Name FROM Folder__c WHERE Name =: foldername.trim() AND Account_Services__c =:accountServiceId]; 
           system.debug('----Folder---'+folders );          
       } 
       
       string errorMessage = ''; 
       system.debug('----Foldersixe---'+folders.size());
       if(folders.size() > 0  && folders != null)       
       {          
          errorMessage = 'Folder Name Already Exists!'; 
          system.debug('----Error message---in'+errorMessage);         
       } 
       system.debug('----Error message---out'+errorMessage);
                  
       return errorMessage;
    }
    
     ///<OBJECTIVE>
    ///Validate the Folder Name
    ///</OBJECTIVE>
    public static void AddNewFolder(Folder__c folder)
    {  
        system.debug('----AddNewFolder--' + folder);
        insert folder; 
    }
    // <OBJECTIVE>
    /// Fetch the Documents based on Account Id and Service Id
    /// </OBJECTIVE>  
    public static List<Documents__c> FetchDeletedDocuments(string accountId, string serviceId, string ordereedBy)
    {
       
        
        List<Documents__c> documentList = new List<Documents__c>();
        string documentQuery = 'SELECT id,name,Document_Type__c,FolderId__r.name,CreatedBy.name,LastModifiedDate from Documents__c where Is_Deleted__C = True  AND';
        
        if(accountId != 'All' && serviceId != 'All')
        {
             documentQuery += ' Account_Services__r.Account__c =: accountId  AND Account_Services__r.ODS_Services__c =:serviceId';
        }  
        else if (accountId == 'All' && serviceId != 'All')
        {
            documentQuery += ' Account_Services__r.ODS_Services__c =: serviceId';
        }
        else if (accountId != 'All' && serviceId == 'All')
        {
            documentQuery += ' Account_Services__r.Account__c =: accountId';
        }
        
        documentQuery = (documentQuery.trim()).removeEnd('AND');
        documentQuery+=' ORDER BY '+ordereedBy;
        documentList = database.query(documentQuery);
        return documentList;
   } 
   
     ///<OBJECTIVE>
    /// delete the Document details
    ///</OBJECTIVE>
    public static void DeleteDocument(string documentId)
    { 
       if(documentId != null)
       { 
           Documents__c  documents = [Select Id,Is_Deleted__c from Documents__c where Id=: documentId];
           documents.Is_Deleted__c = true;
           update documents;
       }
    }
    ///<OBJECTIVE>
    /// delete the Document details
    ///</OBJECTIVE>
    public static void DeleteTrashDocument(string documentId)
    { 
       if(documentId != null)
       {
           Documents__c  documents = [Select Id,Is_Deleted__c from Documents__c where Id=: documentId];
          
           delete documents;
       }
    }
    // <OBJECTIVE>
    /// Update the documents
    /// </OBJECTIVE>  
    public static void  RestoreDocument(string documentId)
    {              
      if(documentId != null)
       { 
           Documents__c  documents = [Select Id,Is_Deleted__C from Documents__c where Id=: documentId];
           documents.Is_Deleted__c = false;
           
           update documents;
       }
   }
   
    /// <OBJECTIVE>
    /// Fetch the Folders based on Account and Service Id
    /// </OBJECTIVE>  
    public static List<Folder__c> FetchFolders(string accountId, string serviceId)
    {
        string folderQuery = 'SELECT CreatedDate, CreatedBy.Name, Name, Id FROM Folder__c Where';
        
        if(accountId != 'All' && serviceId != 'All')
        {
             folderQuery += ' Account_Services__r.Account__c =: accountId  AND Account_Services__r.ODS_Services__c =:serviceId AND';
        }  
        else if (accountId == 'All' && serviceId != 'All')
        {
            folderQuery += ' Account_Services__r.ODS_Services__c =: serviceId AND';
        }
        else if (accountId != 'All' && serviceId == 'All')
        {
            
            folderQuery += ' Account_Services__r.Account__c =: accountId AND';
        }
         system.debug('-----Filter---');
         
        
        folderQuery = (folderQuery.trim()).removeEnd('Where');

        folderQuery = (folderQuery.trim()).removeEnd('AND');//+;
        folderQuery+=' ORDER BY CreatedDate Desc';

        List<Folder__c> folderList = new List<Folder__c>();
        folderList = database.query(folderQuery);
        system.debug('-----Query-- Size' + folderList.size());   

        return folderList;
    } 
    /// <OBJECTIVE>
    /// To insert the Document record
    /// </OBJECTIVE>  
    public static Documents__c InsertDocument(string docName, string accountServiceId, string accountId, string fileExtensionType, string folderId )
    {
        Documents__c document = new Documents__c(name=docName,
                                                 Account__c=accountId ,
                                                Account_Services__c=accountServiceId,
                                                File_Extension__c=fileExtensionType);
        if(!string.isBlank(folderId))
            document.FolderId__c = folderId;
        insert document;
        return document;
    }
    /// <OBJECTIVE>
    /// To insert the Attachment record
    /// </OBJECTIVE>  
    public static Attachment InsertAttachment(string docId, blob postContent, string fName )
    {
        Attachment a = new Attachment (ParentId = docId,
                                       Body = postContent, 
                                       Name = fName);
        
        try{
        insert a;
        system.debug('%%%'+a.Id);
        }
        
        catch(Exception E)
        {
            system.debug('@@@'+E.getMessage());
        }
        return a;
    }
    /// <OBJECTIVE>
    /// To update the Document record
    /// </OBJECTIVE>  
    public static Documents__c UpdateDocument(string docId,string AttachmentId)
    {
        Documents__c document = new Documents__c(id=docId,
                                                Attachment_Id__c=AttachmentId);
        update document;
        return document;
    }
    ///<OBJECTIVE>
    /// Method to get All Services for customer
    ///</OBJECTIVE>
    public static Set<string> GetAllServicesForCustomer(string AccountId, string ContactId)
    {
        Set<string> serviceIdSet = new Set<string>();
        
        for(Contact_Account_Service__c CustomerAccService : ODS_Data_Utility.GetCustomerAccService(AccountId,ContactId))
        {
            serviceIdSet.add(CustomerAccService.ODS_Service__c);
        }
        system.debug('####serviceIdSet'+ serviceIdSet);
        return serviceIdSet;
        
    }
    
    /// <OBJECTIVE>
    /// Fetch the Documents based on Account and Service Id
    /// </OBJECTIVE>  
    public static List<Documents__c> GetDocuments(string accountId, string serviceId, string folderId, string fromDate, string toDate, string documentName, string orderedBy)
    {
        
        DateTime filterFromDate;
        DateTime filterToDate;
        DateTime addFromDate;
        DateTime addToDate;
        string fromDateFormat = ''; string toDateFormat ='';
        Set<String> allServiceIds = new Set<string>();
        Set<String> allAccountIds = new Set<string>();
        User objUser = fetchUserById(UserInfo.getUserId());
        if(fromDate != '' && fromDate !=null)
        {
            filterFromDate = Date.parse(fromDate);
            fromDateFormat =filterFromDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }
        if(toDate!= '' && toDate!=null)
        {
            filterToDate= Date.parse(toDate);
            toDateFormat =filterToDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        }
        
        string documentQuery = 'SELECT id,UploadedDateText__c,CreatedDate,File_Extension__c ,Image_URL__c,name,Attachment_Id__c,CreatedById,Account__r.name,Uploaded_Date__c,SprintNumber__c,CreatedBy.name from Documents__c where FolderId__c=: folderId  AND Is_Deleted__c = false AND';
        
        if(accountId != 'All' && serviceId != 'All')
        {
             documentQuery += ' Account_Services__r.Account__c =: accountId  AND Account_Services__r.ODS_Services__c =:serviceId AND';
        }  
        else if (accountId == 'All' && serviceId != 'All')
        {
            allAccountIds = GetAllAccountsBasedOnLoggedUser();    
            documentQuery += ' Account_Services__r.Account__c IN: allAccountIds AND Account_Services__r.ODS_Services__c =: serviceId AND';
        }
        else if (accountId != 'All' && serviceId == 'All')
        {
            if(objUser.PortalUserRole__c == 'Customer'){
                allServiceIds = GetAllServicesForCustomer(AccountId,objUser.ContactId); 
                system.debug('####allServiceIds '+ allServiceIds); 
            }
            else{
                for(ODS_Services__c odsService: GetAllServices())
                {
                    allServiceIds.add(odsService.Id);
                }
            }
            documentQuery += ' Account_Services__r.ODS_Services__c IN: allServiceIds AND Account_Services__r.Account__c =: accountId AND';
        }
         system.debug('-----Filter---');
         //addFromDate = filterFromDate.addDays(1);      
        if (fromDate!= '' && fromDate!= null)
        {
           documentQuery += ' CreatedDate >=: filterFromDate AND'; 
        }
        if (toDate != '' && toDate != null)
        {
            addToDate = filterToDate.addDays(1); 
            documentQuery += ' CreatedDate  <=: addToDate AND'; 
        }
        if (documentName != '' && documentName != null )
        {
            documentQuery += ' Name Like \'%'+String.escapeSingleQuotes(documentName)+'%\' AND'; 
        }
        documentQuery = (documentQuery.trim()).removeEnd('Where');

        documentQuery = (documentQuery.trim()).removeEnd('AND');//+
        documentQuery+=' ORDER BY '+orderedby; 

        system.debug('-----Query--' + documentQuery + fromDateFormat + toDateFormat);   
            
        List<Documents__c> documentList = new List<Documents__c>();
        documentList = database.query(documentQuery);
        system.debug('-----Query-- Size' + documentList.size());   

        return documentList; 
        
    }
    
    /// <OBJECTIVE>
    /// Fetch the Documents based on Account and Service Id
    /// </OBJECTIVE>  
    public static List<Folder__c> FetchFolders(string accountId, string serviceId, string fromDate, string toDate, string folderName, string orderrBy)
    {
        DateTime filterFromDate;
        DateTime filterToDate;
        DateTime addFromDate;
        DateTime addToDate;
        string fromDateFormat = ''; string toDateFormat ='';
        Set<String> allServiceIds = new Set<string>();
        Set<String> allAccountIds = new Set<string>();
        User objUser = fetchUserById(UserInfo.getUserId());
        if(fromDate != '' && fromDate !=null)
        {
            filterFromDate = Date.parse(fromDate);
            fromDateFormat =filterFromDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }
        if(toDate!= '' && toDate!=null)
        {
            filterToDate= Date.parse(toDate);
            toDateFormat =filterToDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        } 
        
        
        string folderQuery = 'SELECT CreatedDate, CreatedBy.Name, Name, Id FROM Folder__c Where';
        
        if(accountId != 'All' && serviceId != 'All')
        {
             folderQuery += ' Account_Services__r.Account__c =: accountId  AND Account_Services__r.ODS_Services__c =:serviceId AND';
        }  
        else if (accountId == 'All' && serviceId != 'All')
        {
            allAccountIds = GetAllAccountsBasedOnLoggedUser();    
            folderQuery += ' Account_Services__r.Account__c IN: allAccountIds AND Account_Services__r.ODS_Services__c =: serviceId AND';
        }
        else if (accountId != 'All' && serviceId == 'All')
        {
            if(objUser.PortalUserRole__c == 'Customer'){
                allServiceIds = GetAllServicesForCustomer(AccountId,objUser.ContactId); 
                system.debug('####allServiceIds '+ allServiceIds); 
            }
            else{
                for(ODS_Services__c odsService: GetAllServices())
                {
                    allServiceIds.add(odsService.Id);
                }
            }
            folderQuery += ' Account_Services__r.ODS_Services__c IN: allServiceIds AND Account_Services__r.Account__c =: accountId AND';
        }
         system.debug('-----Filter---');
         if (fromDate!= '' && fromDate!= null)
        {
           folderQuery += ' CreatedDate >=: filterFromDate AND'; 
        }
        if (toDate != '' && toDate != null)
        {
            addToDate = filterToDate.addDays(1); 
            folderQuery += ' CreatedDate  <=: addToDate AND'; 
        }
        if (folderName != '' && folderName != null )
        {
            folderQuery += ' Name Like \'%'+String.escapeSingleQuotes(folderName)+'%\' AND'; 
        }
        
        folderQuery = (folderQuery.trim()).removeEnd('Where');
    
        folderQuery = (folderQuery.trim()).removeEnd('AND');
        folderQuery+=' ORDER BY '+orderrBy;
    
        List<Folder__c> folderList = new List<Folder__c>();
        folderList = database.query(folderQuery);
        system.debug('-----Query-- Size' + folderList.size());   
    
        return folderList;
    } 
    
    ///<OBJECTIVE>
    ///Validate the document Name Exists or not
    ///</OBJECTIVE>
    public static string ValidateDocument(string documentName, string accountId, string serviceId)
    {  
       Documents__c[] documents = null; 
       if(documentName != '')
       {      
           documents = [SELECT Id FROM Documents__c WHERE Account_Services__c =: serviceId AND Name =: documentName.trim()];
                         system.debug('----ValidateDocument---' + documents  );
                          system.debug('----ValidateDocumentService---' + serviceId);
                          system.debug('----ValidateDocumentName---' + documentName.trim());

       }
             

       string errorMessage = ''; 
       //if(documents.body.size()>5242880 && documents != null)
       if(documents.size() > 0  && documents != null) 
       {          
          errorMessage = 'Document';
       }   
       return errorMessage;    
    }
    ///<OBJECTIVE>
    ///Fetch the Attachments
    ///</OBJECTIVE>
    public static List<Attachment> FetchAttachments(String attachmentName){
        return [SELECT Id, Name FROM Attachment where Name =:attachmentName];
    }
    
    ///<OBJECTIVE>
    /// Get Account Service Id for Document Suffix 
    ///</OBJECTIVE>
    public static string GetAccountServiceDetails(string accountServiceId)
    {
        Account_Services__c[] accountServices = [SELECT Id,Account__r.Name,Document_Suffix__c FROM Account_Services__c where Id=:accountServiceId];
        string documentSuffix;
        if(accountServices.size() > 0 && accountServices != null)
        {
            documentSuffix = accountServices[0].Document_Suffix__c;
        }
        system.debug('GetAccountServiceDetails------' + documentSuffix );
        return documentSuffix;
        
    }
    ///<OBJECTIVE>
    /// Method to get All Accounts
    ///</OBJECTIVE>
    public static Set<string> GetAllAccountsBasedOnLoggedUser()
    {
        Set<string> accountIdSet = new Set<string>();
       ODS_Common_Utility obj = new ODS_Common_Utility();
        String[] AccounIDs = obj.getAllAccountIDByLoggedInUser();
        for( String AccID: AccounIDs )
        {
            accountIdSet.add(AccID);
        }
        return accountIdSet;
    }
    /// <OBJECTIVE>
    /// Fetch the Documents based on Account and Service Id
    /// </OBJECTIVE>  
    public static List<Documents__c> GetDocuments(string accountId, string serviceId, set<ID> folderIds, string fromDate, string toDate, string documentName)
    {
        DateTime filterFromDate;
        DateTime filterToDate;
        DateTime addFromDate;
        DateTime addToDate;
        string fromDateFormat = ''; string toDateFormat ='';
        Set<String> allServiceIds = new Set<string>();
        Set<String> allAccountIds = new Set<string>();
        User objUser = fetchUserById(UserInfo.getUserId());
        if(fromDate != '' && fromDate !=null)
        {
            filterFromDate = Date.parse(fromDate);
            fromDateFormat =filterFromDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }
        if(toDate!= '' && toDate!=null)
        {
            filterToDate= Date.parse(toDate);
            toDateFormat =filterToDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        }
        
        string documentQuery = 'SELECT id,CreatedDate,File_Extension__c ,Image_URL__c,name,Attachment_Id__c,CreatedById,Account__r.name,Uploaded_Date__c,SprintNumber__c,CreatedBy.name from Documents__c where FolderId__c IN: folderIds  AND Is_Deleted__c = false AND';
        
        if(accountId != 'All' && serviceId != 'All')
        {
             documentQuery += ' Account_Services__r.Account__c =: accountId  AND Account_Services__r.ODS_Services__c =:serviceId AND';
        }  
        else if (accountId == 'All' && serviceId != 'All')
        {
            allAccountIds = GetAllAccountsBasedOnLoggedUser();    
            documentQuery += ' Account_Services__r.Account__c IN: allAccountIds AND Account_Services__r.ODS_Services__c =: serviceId AND';
        }
        else if (accountId != 'All' && serviceId == 'All')
        {
            if(objUser.PortalUserRole__c == 'Customer'){
                allServiceIds = GetAllServicesForCustomer(AccountId,objUser.ContactId); 
                system.debug('####allServiceIds '+ allServiceIds); 
            }
            else{
                for(ODS_Services__c odsService: GetAllServices())
                {
                    allServiceIds.add(odsService.Id);
                }
            }
            documentQuery += ' Account_Services__r.ODS_Services__c IN: allServiceIds AND Account_Services__r.Account__c =: accountId AND';
        }
         system.debug('-----Filter---');
         //addFromDate = filterFromDate.addDays(1);      
        if (fromDate!= '' && fromDate!= null)
        {
           documentQuery += ' CreatedDate >=: filterFromDate AND'; 
        }
        if (toDate != '' && toDate != null)
        {
            addToDate = filterToDate.addDays(1); 
            documentQuery += ' CreatedDate  <=: addToDate AND'; 
        }
        if (documentName != '' && documentName != null )
        {
            documentQuery += ' Name Like\'%'+String.escapeSingleQuotes(documentName)+'%\' AND'; 
        }
        documentQuery = (documentQuery.trim()).removeEnd('Where');

        documentQuery = (documentQuery.trim()).removeEnd('AND');//+
        documentQuery+=' ORDER BY CreatedDate Desc';

        system.debug('-----Query--' + documentQuery + fromDateFormat + toDateFormat);   
            
        List<Documents__c> documentList = new List<Documents__c>();
        documentList = database.query(documentQuery);
        system.debug('-----Query-- Size' + documentList.size());   

        return documentList; 
        
    } 
    
      ///<OBJECTIVE>
    /// To Insert the Document Details and Attachment
    ///</OBJECTIVE>
    public static string InsertUpdateDocumentDetailsAttachment(string accountId, string serviceId, string documentType, string name,
                       string projectName, Decimal sprintNumber, Blob fileData, string filename, string documentId)
    {
    
      string attachmentId = '';
      string accountServiceId;
      string fileExtension,folderId; 
    
        system.debug('---InsertMethod---'+ filename);
        //Insert the Document Details into Document Object
        Documents__c documents = null;
        if(documentId == '' || documentId ==null)
        {
            system.debug('---InsertMethod---'+ accountId + '---'+serviceId+'----'+name);
            documents = new Documents__c();      
            documents.Account__c = accountId;
            documents.Account_Services__c = serviceId;
            documents.Document_Type__c = documentType;
            documents.Name = name;
            documents.Project_Name__c = projectName;
            documents.SprintNumber__c =  sprintNumber;
            documents.Attachment_File__c = filename;
            documents.File_Extension__c =fileExtension;
            if(folderId != null && folderId !='')
            {
                documents.FolderId__c = folderId;
            }
            insert documents ;
            attachmentId = documents.Id;
        }
        else
        {
            system.debug('---UpdateMethod---'+ documentId);
            documents = new Documents__c(id=documentId);
            documents.Document_Type__c = documentType;
            documents.Name = name.trim();
            documents.Project_Name__c = projectName;
            documents.SprintNumber__c =  sprintNumber;
            documents.Attachment_File__c = filename;
            if(fileExtension != null && fileExtension !='')
            {
                documents.File_Extension__c = fileExtension;
            }
            //documents.File_Extension__c =fileExtension;
                
            update documents ;
            attachmentId = documentId;
        }
        
        //Gets the Account Service Id to concate with file name
        //string documentSuffix = GetAccountServiceDetails(accountServiceId);
        Account_Services__c[] accountServices = [SELECT Id,Account__r.Name,Document_Suffix__c FROM Account_Services__c where Id=:serviceId];
        string documentSuffix = accountServices[0].Document_Suffix__c;
       
        transient blob blobFileDate = fileData;
        
        //Inserts the attachment into Attachment object
        Attachment attachment= null;
        
        if(documentId == '' || documentId == null)
        {
            attachment= new Attachment(); 
            attachment.parentId = documents.Id;
            attachment.body= blobFileDate;
            if(documentSuffix == null)
            {
                attachment.Name = filename;
            }
            else
            {
                attachment.Name = documentSuffix +'_'+ filename;
            }    
            insert attachment;
        }
        else
        {   
            system.debug('---UpdateMethod---Else---FileName'+filename );
            if(blobFileDate != null)
            {    
                system.debug('---UpdateMethod---Else If');
                Documents__c[] documentsData =  [Select Id,Attachment_Id__c from Documents__c where Id=:documentId];  
                attachment= new Attachment(id=documentsData[0].Attachment_Id__c);             
                attachment.body= blobFileDate;
                
                integer i = 0; string fileDocumentSuffix = ''; string fullFileName ='';
                //Split the file name with _ and check whether its a same file
                //If its a same file then keep the file name as same else add the suffix
                for(String fileNameSplit: filename.split('_'))
                {
                   if(i == 0)
                   {
                       
                       fileDocumentSuffix = fileNameSplit;                       
                   }  
                    
                   fullFileName += fullFileName + fileNameSplit;
                     
                   i++;
                }
                
                if(documentSuffix  == fileDocumentSuffix)
                {
                    attachment.Name = filename;                
                }
                else
                {
                     attachment.Name = documentSuffix +'_'+ filename;
                }
                
                system.debug('----Suffix----' + fileDocumentSuffix +'----' + fullFileName);
                
                update attachment;
            }
        }
        
        
        //Updates the attachentid into documents object
        if(documentId == '' || documentId ==null)
        {
            Documents__c queryDocuments= [SELECT Id FROM Documents__c WHERE Id =: documents.Id LIMIT 1];
            queryDocuments.Attachment_Id__c = attachment.Id;
            update queryDocuments;
        }
        
        return attachmentId;
        
       
    } 
    
    Public static List<Account_Services__c > fetchAccServcesByAccAndEngmtType(string selectedAccount)
    {
    return [SELECT Id,
                 Account__c, 
                 ODS_Services__c,
                 ODS_Services__r.Name__c ,
                 Type_of_Engagement__c
             FROM 
                 Account_Services__c 
             WHERE
                 Account__c =: selectedAccount AND 
                 Type_of_Engagement__c = 'ODS'];  
    }
    
    Public static List<Account_Services__c > fetchAccServcesByAccAndEngmtType(string selectedAccount, set<string> servicesSet)
    {
    return [SELECT Id,
                 Account__c, 
                 ODS_Services__c,
                 ODS_Services__r.Name__c ,
                 Type_of_Engagement__c
             FROM 
                 Account_Services__c 
             WHERE
                 Account__c =: selectedAccount AND
                 ODS_Services__c IN: servicesSet AND 
                 Type_of_Engagement__c = 'ODS'];  
    }
    
    /// <OBJECTIVE>
    /// To fetch the Holiday Details
    /// </OBJECTIVE> 
    Public static list<Holiday> getHolidaydetails()
    {
        
        return [Select id,Name,ActivityDate,RecurrenceDayOfMonth,RecurrenceMonthOfYear,RecurrenceStartDate
                    FROM Holiday ORDER BY ActivityDate ASC];
     }
     
    /// <OBJECTIVE>
    /// To fetch the All acconut services
    /// </OBJECTIVE>
    Public static List<Account_Services__c > fetchAllAccServces()
    {
    return [SELECT Id,
                 Account__c, 
                 ODS_Services__c,
                 ODS_Services__r.Name__c ,
                 Type_of_Engagement__c,
                 Agile__c,
                 JIRA_Domain_Name__c
             FROM 
                 Account_Services__c];  
    }
    
    public static List<Initiatives__c> fetchRelatedInitiativeDetails(set<string> InitiativeIds)
    {
        return [SELECT Id,
                    Name, 
                    Remaining_Hours__c,
                    Estimated_hours__c
                FROM
                    Initiatives__c
                WHERE
                    Id IN: InitiativeIds];
    }
    
    public static Account FetchWorkOrderAccount(string AccountId)
    {
        return [SELECT Id,
                    Name,
                    Owner.Name,
                    BillingStreet,
                    BillingCity,
                    BillingState,
                    BillingCountry,
                    BillingPostalCode,
                    Minimum_billable_hours__c,
                    SOW__c,
                    SOW_Status_Date__c,
                    Invoice_Type__c,
                    InvoiceContact__r.Name,
                    InvoiceContact__r.Email,
                    InvoiceContact__r.MailingStreet,
                    InvoiceContact__r.MailingCity,
                    InvoiceContact__r.MailingState,
                    InvoiceContact__r.MailingCountry,
                    InvoiceContact__r.MailingPostalCode,
                    InvoiceContact__r.OtherStreet,
                    Account.ShippingStreet                    
                FROM
                    Account
                WHERE
                    Id =: AccountId];
    }
     
}