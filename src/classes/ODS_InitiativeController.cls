/**
 * @author           Anil Kumar
 * @version          1.0 
 * @date             05-Dec-2017
 * @Status           Developed
 * @description      This is the controller class for Add Initiative Page
 *
 */

global class ODS_InitiativeController
{

    public String WorkDayParam { get; set; }
    public string CurrenTimesheetId {get;set;}
    public string CurrenInitiativeId {get;set;}
    public string CurrenEmailInitiativeId;
    public string PassedInitiaitveJSON {get; set;}
    public string PassedInitiativeEstimateJSON{get;set;}
    public string PassedActiveStatus {get;set;}
    public string PassedTimesheetJSON {get;set;}
    public string currentUserName {get;set;}
    public string ClientContact {get;set;}
    public string PassAccountName {get;set;}
    public string PassServiceName {get;set;}
    public string AccountName {get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public static string Check_duplicate { get; set;} 
    public string ServiceName{get;set;}
    public string CurrentAccServiceId {get;set;}
    public string TimesheetComments {get;set;}
    public boolean IsPortalApprover {get;set;}
    public boolean IsInitiativeApprover {get;set;}
    public string PortalUserRole {get;set;}
    public string TimeshtJSONtoBind {get;set;}
    public string Initiative_JSONtoBind {get;set;}
    public string BriefDescriptionCK { get;set;}
    public string EstimateJSONtoBind {get;set;}
    public string CurrentTimeSheetStatus {get;set;}
    public string InitiativeStatus {get;set;}
    public string CurrentInitiativeStatus {get;set;}
    public string PassedWeekFromDate{get;set;}
    public string PassedWeekToDate{get;set;}
    public boolean isMyAccShow {get;set;}
    public string Initiative_Assumption { get;set;}
    public string Initiative_Description {get; set;}
    public boolean isCustomer {get;set;}
    public Time_Sheet_Cost__c objTimesheetCost;
    
    public string TestDescription { get;set;}
    
    public string  URL {get;set;}
    public Date dtStartDate;
    public Date dtEndDate;
    public String CurrentDate {get; set;}
    public  Time_Sheet_Cost__c  objTimesheetCostforNextMonth;   
    public List<AggregateResult> resourceNameLst{get;set;}
    public List<AggregateResult> InitiativeLst{get;set;}
    public Boolean ShowPDFButton {get;set;} 
    public string resourceNameJSONtoBind {get;set;}
    public string initiativeJSONtoBind {get;set;}
    public List<Contact_Account_Service__c> ContctAccService {get;set;}
    public List<Contact_Account_Service__c> InitiativeContctAccService {get;set;}
    List<selectOption> options = new List<selectOption>();
    public List<Initiatives__c> statusList {get;set;}
    public string jsondata {get;set;}
    
 
    
    public ODS_InitiativeController()
    {
     
        system.debug('@@@ Inside ODS_TimesheetController');
        Datetime currentDateTime = Datetime.now(); // Returns the current Datetime based on a GMT calendar.
        CurrentDate  = currentDateTime.format('MM/dd/YYYY'); // formats the date
        Account_Services__c  acc;      
        objTimesheetCost = new Time_Sheet_Cost__c();
        CurrentAccServiceId = ApexPages.CurrentPage().getParameters().get('AccServiceId');
        CurrenTimesheetId  = ApexPages.CurrentPage().getParameters().get('Id');
        CurrenInitiativeId  = ApexPages.CurrentPage().getParameters().get('CurrenInitiativeId');                                                                          
        system.debug('CurrenInitiativeId============'+CurrenInitiativeId);
        CurrentTimeSheetStatus = ApexPages.CurrentPage().getParameters().get('Status');  
        CurrentInitiativeStatus = ApexPages.CurrentPage().getParameters().get('Status');     
        PassedWeekFromDate = ApexPages.CurrentPage().getParameters().get('WeekStart');
        currentUserName = UserInfo.getName();     
        System.debug('@@@@UserInfo.getUserId()'+UserInfo.getUserId());  
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        system.debug('@@@@@@objUser.ContactId:'+objUser.ContactId);
        System.debug('@@@@@@CurrenInitiativeId  '+CurrenInitiativeId);
        
        String InitiativeUrl = System.Label.ODS_SiteURL;  

        URL = InitiativeUrl+'/apex/InitiativePage?CurrenInitiativeId='+CurrenInitiativeId+'&AccServiceId='+CurrentAccServiceId;
            
        if(CurrentAccServiceId != null){
                    acc = [SELECT Account__r.Name,ODS_Services__r.Name,ODS_Service_Name__c FROM  Account_Services__c WHERE Id =: CurrentAccServiceId]; }
        if(acc != null){
                 PassAccountName = acc.Account__r.Name;
                 PassServiceName = acc.ODS_Service_Name__c ;
        }
        else{
                 PassAccountName = 'None';
                 PassServiceName = 'None';
        }
        
        PortalUserRole = objUser.PortalUserRole__c;
        IsPortalApprover = False;
        
        List<Initiatives__c> initiativeStatusCheck = [select id,Status__c from Initiatives__c  where id =: CurrenInitiativeId];
        if(!(initiativeStatusCheck.isEmpty())){
             InitiativeStatus = initiativeStatusCheck[0].Status__c;
        }
        system.debug('InitiativeStatus==========='+InitiativeStatus);
        IsInitiativeApprover = false;
        if(objUser.ContactId!= null)
        {        
           if(CurrentAccServiceId != null){
               List<Account_Services__c > accServiceById = new List<Account_Services__c >();
               accServiceById = ODS_Data_Utility.fetchRelatedAccountService(CurrentAccServiceId);
               if(accServiceById.size() >0){
                   ContctAccService = new List<Contact_Account_Service__c>();
                   ContctAccService  = ODS_Data_Utility.fetchContactAccountService(objUser.ContactId, accServiceById[0].ODS_Services__c); 
                   system.debug('@@@@@@ContctAccService:'+ContctAccService);        
                   if(ContctAccService.size() >0){
                       IsPortalApprover = ContctAccService[0].Is_Approver__c;
                   }
                   InitiativeContctAccService  = new List<Contact_Account_Service__c>();
                   System.debug('@@@@objUser.ContactId'+objUser.ContactId);
                   System.debug('@@@@accServiceById[0].ODS_Services__c'+accServiceById[0].ODS_Services__c);
                   InitiativeContctAccService  = ODS_Data_Utility.fetchInitiativeContactAccountService(objUser.ContactId, accServiceById[0].ODS_Services__c);
                   System.debug('@@@@InitiativeContctAccService'+InitiativeContctAccService);
                   if(InitiativeContctAccService.size() > 0 ){
                               IsInitiativeApprover = InitiativeContctAccService[0].Is_initiate_approver__c;
                   }
                   else{
                               IsInitiativeApprover = false;
                   } 

               }
           }
           
        }
        
        
        
        if(CurrenInitiativeId  != null){
              System.debug('@@@@@@@@@CurrenInitiativeId'+CurrenInitiativeId);
              GetInitiativeDetails(CurrenInitiativeId);
              Initiatives__c initiativeobj = ODS_Data_Utility.FetchInitiativeByID(CurrenInitiativeId);
              CurrentInitiativeStatus  = initiativeobj.Status__c;
              if(CurrentAccServiceId == null){
                   GetLoggedUserAccountService();
              }
              else{
                   AssignPassedAccountService();
              }
              GetAccountServiceChanges();
              if(objUser.PortalUserRole__c == 'Customer')
              { 
                    isCustomer= true;
              } 
        }
        else
        {
              if(CurrentAccServiceId == null){
                   GetLoggedUserAccountService();
              }
              else{
                   AssignPassedAccountService();
              }
        }
             
    }
               
    
     public String getClientContact(){
          return ClientContact;
     }
    
     public List<selectOption> getContactAccountServices()
     {     
        system.debug('Line No:132==AccountID ==='+AccountID+'===='+ServiceID);
        List<Contact_Account_Service__c> Contacts = [SELECT Contact__r.Name From Contact_Account_Service__c WHERE Account__c =: AccountID AND ODS_Service__c =: ServiceID AND Is_initiate_approver__c   =: true];
        system.debug('==Contacts==='+Contacts);
        for(Contact_Account_Service__c Contact : Contacts ){
             String AllContacts = Contact.Contact__r.Name;
             System.debug('Line No:137 Contact Acc Service '+Contact.Contact__r.Name);
             options.add(new selectOption(AllContacts , AllContacts ));
        }
        system.debug('==options==='+options);
        return options;    
      }
    
    
    public void GetInitiativeDetails(String InitiativeId){
        List<Estimate__c> estimateList = new List<Estimate__c>();
        system.debug('###PortalUserRole :' +PortalUserRole);
        if(PortalUserRole != 'Customer'){
             estimateList = ODS_Data_Utility.FetchInitiativeDetailsbyId(InitiativeId);
        }
        else{
             estimateList = ODS_Data_Utility.FetchCustomerInitiativeDetails(InitiativeId);
        }
        Initiatives__c initiativeobj = ODS_Data_Utility.FetchInitiativeByID(InitiativeId);
        if(initiativeobj != null){
             CurrentInitiativeStatus =initiativeobj.Status__c;
        }
        else{
             CurrentInitiativeStatus ='';
        }
        
        Initiatives__c initiativeList= [select Brief_Description__c,Assumption__c from Initiatives__c  where ID =: InitiativeId];
        Initiative_Description =  initiativeList.Brief_Description__c;
        Initiative_Assumption = initiativeList.Assumption__c;
          
        EstimateJSONtoBind = JSON.serialize(estimateList)+'~'+CurrentInitiativeStatus;
        EstimateJSONtoBind = EstimateJSONtoBind.Replace('\'','$#$');
        
        Initiative_JSONtoBind = JSON.serialize(initiativeobj)+'~'+CurrentInitiativeStatus;
        System.debug('@@@@@Initiative_JSONtoBind'+Initiative_JSONtoBind);
    }
    
        
    public void AssignPassedAccountService()
    {
        List<Account_Services__c > accServiceLst = new List<Account_Services__c >();
        System.debug('@@@@@@Line No:217 CurrentAccServiceId'+CurrentAccServiceId);
        accServiceLst = ODS_Data_Utility.fetchRelatedAccountService(CurrentAccServiceId);
        if(accServiceLst.size() > 0){
            AccountId = accServiceLst[0].Account__c;
            ServiceId = accServiceLst[0].ODS_Services__c;
        }
    }
    
    public void AddRow()
    {
    }
    
    public PageReference GetTimeSheetIdFromAction()
    {
        system.debug('##CurrenTimesheetId:' +CurrenTimesheetId);        
        return null;
    }
    
    public void GetLoggedUserAccountService()
    {
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        if(objUser.PortalUserRole__c == 'Customer')
        {   
            List<Contact> cnt = new List<Contact>();
            cnt = ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId);
            if(cnt.size() > 0){
                AccountId = cnt[0].AccountId;
                System.debug('@@@@@@QAccountId'+AccountId);
            }
            else{
                AccountId = 'All';
            }
            List<Account_Services__c> accService = new List<Account_Services__c>();
            accService = ODS_Data_Utility.fetchAccServcesByAcc(AccountId);
            if(accService.size() > 0){
                ServiceId = accService[0].ODS_Services__c;
            }
            else{
                ServiceId = 'All';
            }
        }
        else
        {
            AccountId = 'All';
            ServiceId = 'All';
        }
    }
    
    public void SetRelatedService()
    {
        if(AccountId == 'All')
        {
            ServiceId = 'All';
        }
        else
        {
            List<Account_Services__c> accServices = new List<Account_Services__c>();
            accServices = ODS_Data_Utility.fetchAccServcesByAcc(AccountId);
            if(accServices.size() > 0)
            {
                ServiceId = accServices[0].ODS_Services__c;
            }
            else
            {
                ServiceId = 'All';
            }
        }
    }
    
    public static List<SelectOption> GetAccountPicklistValues()
    {
      
      List<SelectOption> lstSlctOptn = new list<SelectOption>(); 
        ODS_Common_Utility objUtility = new ODS_Common_Utility();
        //lstSlctOptn = objUtility.getCustomersByLoggedInUser();
        return lstSlctOptn;
    }
    
   
    
    public void GetAccountServiceChanges()
    {
        List<Account> acc = new List<Account>();
        acc = ODS_Data_Utility.GetAccountNameById(AccountId);
        if(acc.size() > 0){
            AccountName = acc[0].Name;
        }
        else{
            AccountName = 'All';
        }
        List<ODS_Services__c> ods = new List<ODS_Services__c>();
        ods = ODS_Data_Utility.GetServiceNameById(ServiceId);
        if(ods.size() > 0){
            ServiceName = ods[0].Name__c;
        }
        else{
            ServiceName = 'All';
        }
        
        List<Account_Services__c > accServList = new List<Account_Services__c >();
        accServList = ODS_Data_Utility.fetchAccServcesByServiceAccount(AccountId, ServiceId);
        if(accServList.size() > 0){
            CurrentAccServiceId = accServList[0].Id;
        }
        else{
            CurrentAccServiceId = '';
        } 
    }
    
   
    
    public class Estimate {
             public String Phase;
             public String TaskName;
             public String Assumption;
             public String Hours;
             public Estimate(string s1, string s2, string s3,string s4){
                     Phase = s1;
                     TaskName = s2;
                     Assumption = s3;
                     Hours = s4;
             }
    }
      
    public class JSONserialize {
            public List<Estimate> Estimate;
            public String InitiativeName;
            public String StartDate;
            public String EndDate;
            public String ContactAccService;
            public String BriefDescription;
            public String Assumption;
            public String Status;
            public String stats;
    }
    
    public static JSONserialize parse(String json) {
            return (JSONserialize) System.JSON.deserialize(json, JSONserialize.class);
    }
    
    public Boolean CheckInitiativeId(String InitiativeName){
        if(CurrentAccServiceId != null || CurrentAccServiceId != ''){          
            List<Initiatives__c> initiatives = [select id,Name from Initiatives__c where Name =: InitiativeName AND Account_Service__c =: CurrentAccServiceId];
            if(initiatives.size() == 0){
                 return true;  
            }
            else{
                 return false;
            }
        }
        else{
                 return false;
        }
    }
    
    public Pagereference SaveInitativeAndEstimate()
    {
          Check_duplicate  = 'false';
          System.debug('Line No:321 ===>PassedInitiativeEstimateJSON '+PassedInitiativeEstimateJSON );
          if(PassedInitiativeEstimateJSON != null){
                       JSONserialize obj = parse(PassedInitiativeEstimateJSON);
                       System.debug(obj);
                       if(CurrenInitiativeId  == null || CurrenInitiativeId  == ''){
                              if(CheckInitiativeId(obj.InitiativeName)){  
                               Initiatives__c  initiativeobject = new Initiatives__c();
                               initiativeobject.Name = obj.InitiativeName;
                               initiativeobject.Probable_Start_Date__c = date.parse(obj.StartDate);
                               initiativeobject.Probable_End_Date__c = date.parse(obj.EndDate);
                               List<Contact_Account_Service__c> Contacts = [SELECT Contact__r.Name,Contact__c,ID From Contact_Account_Service__c WHERE Account__c =: AccountID AND ODS_Service__c =: ServiceID  AND Contact__r.Name =: obj.ContactAccService AND Is_initiate_approver__c = true];
                               if(Contacts.size() > 0){
                                     initiativeobject.Client_side_Contact__c = Contacts[0].Contact__c; 
                               }
                               

                               initiativeobject.Brief_Description__c = obj.BriefDescription;
                               
                               System.debug('@@@@@@BriefDescription'+obj.BriefDescription);
                               TestDescription = obj.BriefDescription;
                               
                               initiativeobject.Assumption__c = obj.Assumption;
                               if(obj.stats == 'Saved') { initiativeobject.Status__c = 'Saved'; }
                               if(obj.stats == 'Submitted') { initiativeobject.Status__c = 'Initiative Submitted';  initiativeobject.Initiative_submitted_date__c = date.today(); }
                             //  initiativeobject.Status__c = obj.Status;
                               initiativeobject.Account_Service__c = CurrentAccServiceId;
                               insert initiativeobject;
                               ID Initiativeid = initiativeobject.ID;
                               CurrenEmailInitiativeId = Initiativeid;
                               String InitiativeUrl = System.Label.ODS_SiteURL;  
                               URL = InitiativeUrl+'/apex/InitiativePage?CurrenInitiativeId='+Initiativeid+'&AccServiceId='+CurrentAccServiceId;
                               String Contact;
                               if(Contacts.size() == 0){
                                    Contact = '';
                               }
                               else{
                                    Contact = Contacts[0].Contact__r.Name;
                               }
                              if(obj.stats == 'Submitted')
                              { sendEmailInitiative(Initiativeid,CurrentAccServiceId,obj.stats,Contact,URL); }
                               for(Estimate est: obj.Estimate){
                                       Estimate__c estimateobject = new Estimate__c();
                                       estimateobject.Phase__c =  est.Phase;
                                       estimateobject.Hours__c = decimal.valueOf(est.Hours);
                                       estimateobject.Task_Components__c = est.TaskName;
                                       estimateobject.Assumptions__c = est.Assumption;
                                       estimateobject.Initiative_Lookup__c = Initiativeid;
                                       insert estimateobject;
                               }
                               return redirectToInitiative();
                               }
                               else{
                                          Check_duplicate  = 'true';
                                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Initiative Name already exists'));
                                          return null;
                               }
                       }
                       else{
                               Initiatives__c  initiativeobject = new Initiatives__c(id=CurrenInitiativeId);
                               if(obj.stats == 'Saved') { initiativeobject.Status__c = 'Saved'; 
                                                          initiativeobject.Name = obj.InitiativeName;
                                                          initiativeobject.Probable_Start_Date__c = date.parse(obj.StartDate);
                                                          initiativeobject.Probable_End_Date__c = date.parse(obj.EndDate);
                                                          initiativeobject.Brief_Description__c = obj.BriefDescription;
                                                          initiativeobject.Assumption__c = obj.Assumption;
                                                          List<Contact_Account_Service__c> Contacts = [SELECT Contact__r.Name,Contact__c,ID From Contact_Account_Service__c WHERE Account__c =: AccountID AND ODS_Service__c =: ServiceID  AND Contact__r.Name =: obj.ContactAccService AND Is_initiate_approver__c = true];
                                                          if(Contacts.size() > 0){
                                                                      initiativeobject.Client_side_Contact__c = Contacts[0].Contact__c; 
                                                          }
                               }
                               if(obj.stats == 'Submitted') { initiativeobject.Status__c = 'Initiative Submitted'; initiativeobject.Initiative_submitted_date__c = date.today(); }
                               update initiativeobject;
                               Initiatives__c initiative = [select Client_side_Contact__r.Name from Initiatives__c where id =: CurrenInitiativeId];
                               if(obj.stats == 'Submitted') { sendEmailInitiative(CurrenInitiativeId,CurrentAccServiceId,obj.stats,initiative.Client_side_Contact__r.Name,URL); }
                               System.debug('@@@@@@@@@CurrenInitiativeId'+CurrenInitiativeId);
                               Deleteallestimates(CurrenInitiativeId);  
                               for(Estimate est: obj.Estimate){
                                       Estimate__c estimateobject = new Estimate__c();
                                       estimateobject.Phase__c =  est.Phase;
                                       estimateobject.Hours__c = decimal.valueOf(est.Hours);
                                       estimateobject.Task_Components__c = est.TaskName;
                                       estimateobject.Assumptions__c = est.Assumption;
                                       estimateobject.Initiative_Lookup__c = CurrenInitiativeId;
                                       insert estimateobject;
                               }    
                               return redirectToInitiative();                      
                       }
          }
          else {  Check_duplicate  = 'true'; return null; }
          
         
    }
    
    public void Deleteallestimates(String InitiativeID){
               List<Estimate__c> estimates = [SELECT ID from Estimate__c WHERE Initiative_Lookup__c =: InitiativeID ];
               delete estimates;
    }
    
    
    public void SaveActiveInitiativeStatus(){
          Initiatives__c initiative = new Initiatives__c(id=CurrenInitiativeId);
          initiative.Status__c  = PassedActiveStatus;
          initiative.Approver_Name__c = UserInfo.GetUserID();
          initiative.Approved_Date__c = Date.Today();
          Update initiative;
    }
                      
    public PageReference ApproveInitiative()
    {
        system.debug('=====ApproveInitiative====');
         Initiatives__c initiative = new Initiatives__c(id=CurrenInitiativeId);
         initiative.Status__c  = 'Initiative Approved';
         initiative.Approver_Name__c = UserInfo.GetUserID();
         initiative.Approved_Date__c = Date.Today();              
         Update initiative;
         Initiatives__c init = [select Client_side_Contact__r.Name from Initiatives__c where id =: CurrenInitiativeId];
         sendEmailInitiative(CurrenInitiativeId,CurrentAccServiceId,'Initiative Approved',init.Client_side_Contact__r.Name,URL);  
         return null;
    }
    
    public PageReference  RejectInitiative()
    {
         Initiatives__c initiative = new Initiatives__c(id=CurrenInitiativeId);
         initiative.Status__c  = 'Re-evaluate';
         initiative.Approver_Name__c = UserInfo.GetUserID();
         initiative.Approved_Date__c = Date.Today();
         initiative.Revised_Approved__c = true;
         Update initiative;
         Initiatives__c init = [select Client_side_Contact__r.Name from Initiatives__c where id =: CurrenInitiativeId];
         sendEmailInitiative(CurrenInitiativeId,CurrentAccServiceId,'Re-evaluate',init.Client_side_Contact__r.Name,URL);   
         return null;
    }
    
        
    /// <OBJECTIVE>
    /// Method to send email once the record is submitted.
    /// </OBJECTIVE>
    @Future(Callout = true)
    public static void sendEmailInitiative(String CurrentID,String AccountServiceID,String Status, String ClientContact,String url){
    system.debug('=====sendEmailInitiative====');
        String AccountId,ServiceId;
        String CurrentAccServiceId = AccountServiceID;
        System.debug('AccountServiceID'+CurrentAccServiceId);
        System.debug('CurrentID in emailinitiative'+CurrentID);

        String CurrenInitiativeId = CurrentID;
        List<Account_Services__c > accServiceLst = new List<Account_Services__c >();
            
        accServiceLst = ODS_Data_Utility.fetchRelatedAccountService(CurrentAccServiceId);
        if(accServiceLst.size() > 0){
           AccountId = accServiceLst[0].Account__c;
           ServiceId = accServiceLst[0].ODS_Services__c;
        }
        system.debug('###AccountId :' +AccountId +'###ServiceId :' +ServiceId);
        List<String> lstToAddress = new List<String>();
        List<String> lstCcAddress = new List<String>();
        String[] bccAddress = new List<String>();
        
        List<Contact_Account_Service__c> Contacts = [SELECT Email__c From Contact_Account_Service__c WHERE Account__c =: AccountID AND ODS_Service__c =: ServiceID AND Is_initiate_approver__c  = true];
        List<Account_Services__c> objAcntSrv = [SELECT Technical_Account_manager__r.Name,Technical_Account_Manager_Email__c from Account_Services__c  WHERE ID =: CurrentAccServiceId ];
        Initiatives__c initiative = [select Comments__c from Initiatives__c where id =: CurrenInitiativeId];
        system.debug('###Contacts to send Email:' +Contacts);
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        if(objUser.PortalUserRole__c == 'Customer' || ((objUser.PortalUserRole__c == 'Technical Account Manager' || objUser.PortalUserRole__c == 'Practice Head') && Status == 'Submitted')){
               System.debug('Loop1');
               for(Contact_Account_Service__c Contact : Contacts ){
                         lstToAddress.add(Contact.Email__c);
               }
        }
        if(((objUser.PortalUserRole__c == 'Technical Account Manager' || objUser.PortalUserRole__c == 'Practice Head') && Status != 'Submitted')){
               System.debug('Loop2');
               for(Account_Services__c Account_contact : objAcntSrv){
                        lstToAddress.add(Account_contact.Technical_Account_Manager_Email__c);
               } 
        }
        
        system.debug('###objAcntSrv as CC Address:' + objAcntSrv);
        if(objUser.PortalUserRole__c == 'Customer' || ((objUser.PortalUserRole__c == 'Technical Account Manager' || objUser.PortalUserRole__c == 'Practice Head') && Status == 'Submitted')){
                 System.debug('Loop3');
                 for(Account_Services__c Account_contact : objAcntSrv){
                        lstCcAddress.add(Account_contact.Technical_Account_Manager_Email__c);
                 } 
        }
        
        String split_emailswithcomma = System.Label.ODS_InitiativeBCC;
        if(split_emailswithcomma != null){
                  List<String> splitted_emails = split_emailswithcomma.split(',');                                        
                  if(splitted_emails.size() > 0  ){   
                           for(String  email : splitted_emails){
                                   bccAddress.add(email);
                           }
                  }
                  else { bccAddress.add(split_emailswithcomma); }
        }
        
        

        
        PageReference pdf = Page.ODS_ExportInitiativeExcel;
        pdf.getParameters().put('InitiativeId',CurrenInitiativeId);  
        Blob body;
        try {        
        // returns the output of the page as a Excel
        body = pdf.getContent();
        System.debug('@@@@@@@@@body ------------'+body );
          
        } catch (VisualforceException e) {
        System.debug('====exception==='+e.getmessage());
        body = Blob.valueOf('Initiative');
        }
        
        Initiatives__c getInitiaitive = [select id,Name,Status__c,Account_Service__r.ODS_Account_Name__c , Account_Service__r.ODS_Service_Name__c FROM Initiatives__c where id =: CurrenInitiativeId];
        system.debug('##getInitiaitive in mail:' +getInitiaitive);
        Messaging.EmailFileAttachment attachement = new Messaging.EmailFileAttachment();
        attachement.setContentType('application/vnd.ms-excel');
        attachement.setFileName(getInitiaitive.Name + '_' + getInitiaitive.Account_Service__r.ODS_Account_Name__c + '_' + getInitiaitive.Account_Service__r.ODS_Service_Name__c +'.xls');
        attachement.setInline(false);
        pdf.setRedirect(true);
        attachement.Body = body; 
        
        system.debug('##attachement in mail:' +attachement);
        Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
        if(lstToAddress.size() > 0){
              mail.setToAddresses(lstToAddress);
        }
        mail.setSenderDisplayName('DemandBlue - ODS');
        if(lstCcAddress.size() > 0){
              mail.setCcAddresses(lstCcAddress);
        }
        if(bccAddress.size() > 0){
              mail.setBccAddresses(bccAddress);
        }
        String strHtmlBody = ''; 
        if(Status == 'Submitted'){           
                 system.debug('Inside Submitted');
                 String subject = getInitiaitive.Name+'– Initiative Submitted'; 
                 mail.setSubject(subject);
                  strHtmlBody = '<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2"> <font face="Calibri " size="3">Hi '+ ClientContact +','+ '<br/><br/>Please find the finalized estimates for '+ '<a href='+url+'>'+ getInitiaitive.Name+'.</a>'+ '<br/><br/>Please '+'<a href='+url+'>Click here </a>'+'to approve the estimate or to provide additional feedback.<br/><br/>Thanks,<br/><br/>'+objAcntSrv[0].Technical_Account_manager__r.Name+'<br/>';
                  strHtmlBody += '<table style="border:none; width:624px; border-collapse: collapse;"><tbody><tr><td style="border-top:2px solid #000; padding-bottom:15px;"></td></tr><tr><td><table><tbody><tr><td valign="top" width="283" style="width:285px; margin:0; padding:25px;vertical-align:top; background-color:#07080A;"><a href="https://www.demandblue.com/" target="_blank"><img src="https://www.demandblue.com/image-assets/signature/demandblue-logo-signature.jpg" alt="DemandBlue" width="285" style="border:none;width:285px;display:block; margin:25px 0;"></a></td><td width="5" style="width:5px;min-width:5px;max-width:5px;margin:0;padding:0;">&nbsp;</td><td style="background-color:#4fc9f3; padding:26px; width:276px;"><table><tbody><tr><td><table><tbody><tr><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">Customer Success Manager</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">:</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#000;">'+objAcntSrv[0].Technical_Account_manager__r.Name+'</span></p></td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td style="border-bottom:2px solid #4fc9f3; padding-top:15px;"></td></tr><tr><td width="624" valign="top" style="width:283px;border:none;padding:10px 0"><p style="text-align:justify;"><span style="font-size:11px; font-family:calibri; color:#ff0000; font-weight: bold;">CONFIDENTIALITY STATEMENT:</span> <span style="font-size:11px; font-family:Arial, Sans-Serif, Times New Roman; color:#a6a6a6;">The information contained in this communication is confidential and intended only for the use of the recipient named above, and may be legally privileged and exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please resend it to the sender and delete the original message and any copy of it from your computer system</span></p></td></tr></tbody></table>';
                 system.debug('Inside Submitted strHtmlBody : '+strHtmlBody);              
        }
        System.debug('@@@@@Status'+Status);
        if(Status == 'Initiative Approved' || Status == 'Approved after Re-evaluation'){
            system.debug('Inside Approved');
                String subject = getInitiaitive.Name +'– Initiative Approved';
                mail.setSubject(subject);
                strHtmlBody += '<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2"><font face="Calibri " size="3"> Hi '+ objAcntSrv[0].Technical_Account_manager__r.Name +','
                + '<br/><br/>';
                strHtmlBody += 'We have approved the estimated efforts for '+ '<a href='+url+'>'+ getInitiaitive.Name  +'.</a>'
                + '<br/><br/>';
                Initiatives__c init = [select Comments__c from Initiatives__c where id =: CurrenInitiativeId];
                if(initiative.Comments__c  != null){
                      strHtmlBody +=  'Comments : '+init.Comments__c+'<br/><br/>';
                }
                
                strHtmlBody += 'Thanks,'
                + '<br/><br/>';
                  strHtmlBody += ClientContact+ '<br/><br/> </font></td></tr>'; 
   
                system.debug('Inside Approved strHtmlBody:'+ strHtmlBody );
        }
        
        if(Status == 'Re-evaluate'){
            system.debug('Inside Reevaluate');
               String subject = getInitiaitive.Name +'– Initiative Rejected ';
               mail.setSubject(subject);
               strHtmlBody += '<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2"><font face="Calibri " size="3"> <hr width="100%" color="#68c9ff" size="20" align="left"> Hi '+ objAcntSrv[0].Technical_Account_manager__r.Name +','
                + '<br/><br/>';
               strHtmlBody += 'Please re-evaluate the efforts required for the Initiative '+ '<a href='+url+'>'+getInitiaitive.Name+'.</a>'
               + '<br/><br/>';
               Initiatives__c init = [select Comments__c from Initiatives__c where id =: CurrenInitiativeId];
               if(initiative.Comments__c  != null){
                      strHtmlBody += 'Comments : '+init.Comments__c+'<br/><br/>';
               }
               
               strHtmlBody += 'Thanks,'
               + '<br/><br/>';
               strHtmlBody += ClientContact+ '<br/><br/> </font></td></tr>'; 
 
               system.debug('Inside Reevaluate strHtmlBody:'+ strHtmlBody );
        }
        
       system.debug('##strHtmlBody:' +strHtmlBody);
        mail.setHtmlBody(strHtmlBody);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachement});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
    
     /// <OBJECTIVE>
    /// Method to redirect to Initiative page
    /// </OBJECTIVE> 
     
    public pagereference redirectToInitiative()
    {
         //String url = '/apex/ViewInitiative';
         Pagereference pgRef = new PageReference('/apex/ViewInitiative');
         pgRef.setRedirect(true);
         return pgRef ;
    }
    /// <OBJECTIVE>
    /// To get resource name for the selected account and service.
    /// </OBJECTIVE>
    public void getResourceNameByAccountServiceId(String AccountId, String ServiceId) 
    {  
        try {
            resourceNameLst = new  List<AggregateResult>();
            resourceNameLst = ODS_Data_Utility.getResourceNameByAccountServiceId(AccountId, ServiceId);
            resourceNameJSONtoBind = JSON.serialize(resourceNameLst);
        }
        catch(Exception e)  {
            system.debug('AddTimesheet-getResourceNameByAccountServiceId: '+e);
        }
    } 
    
    public void getInitiativeByAccountServiceId(String AccountId, String ServiceId) 
    {  
        try {
            InitiativeLst = new  List<AggregateResult>();
            InitiativeLst = ODS_Data_Utility.getInitiativeByAccountServiceId(AccountId, ServiceId);
            initiativeJSONtoBind = JSON.serialize(InitiativeLst);
        }
        catch(Exception e)  {
            system.debug('AddInitiative-getInitiativeByAccountServiceId: '+e);
        }
    }
    
    Public pagereference exportAsExcel()
    {
        PageReference pdf = Page.ODS_ExportInitiativeExcel;
        System.debug('CurrenInitiativeID:'+CurrenInitiativeId);
        pdf.getParameters().put('InitiativeId',CurrenInitiativeId);
        System.debug('@@@@@@@@@656CurrenInitiativeId------------'+CurrenInitiativeId);
        pdf.setRedirect(true);
        return pdf;
    }
   @RemoteAction
    global static  decimal initiativeStatus(string curntId){
         decimal utilizedHrs;
       
         for(Initiatives__c i : [select Id, name, CreatedDate,Consumed_Hours__c,Utilization__c FROM Initiatives__c where id =: curntId]){
            utilizedHrs = i.Utilization__c;
         }
        system.debug('utilizedHrs========'+utilizedHrs);
          return utilizedHrs;
    }
}