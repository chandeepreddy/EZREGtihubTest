/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             07-OCT-2016
 * @Status           Developed
 * @description      This is the controller class for Add Status report Page
 *
 */

global class ODS_AddStatusReportController
{

    public Boolean isCustomer { get; set; }

    public String CkEditorParam{get;set;}    
    public string AccountName {get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public string ServiceName{get;set;}
    public string AccountServiceID {get;set;} 
    public string currentUserName {get;set;}    
    public static Status_Report__c objStsRprt {get;set;}
    public string WorkDayParam{get;set;}
    public string WorkNextDayParam{get;set;}
    public string IssuesConcernsParam{get;set;}
    public string selectedAccountId{get;set;}
    public string selectedServiceId{get;set;}
    //public Date srDate{get;set;}
    public String srId {get;set;}
    public Account_Services__c objAccntSrvcs{get;set;}
    public Status_Report__c srToInsert{get;set;}
    public Status_Report__c srToUpdate{get;set;}
    public Date SRDate{get;set;}
    public string CurrentDate{get;set;}
    public String statusDate{get;set;}
    public Boolean isMyAccShow{get;set;}
    public User objUser{get;set;}
    public string Errormsg{get;set;}
    public boolean blShowCopyButton{get;set;}
    public boolean blPgErrorMsg{get;set;}
    public boolean blShowSaveBtn{get;set;}
    public boolean blShowSubmitBtn{get;set;}
    public String SRStatus{get;set;} 
    public String minDate{get;set;}
       
    public string WorkDayParam1{get;set;}
    public string WorkNextDayParam1{get;set;}
    public string IssuesConcernsParam1{get;set;}
  
    /// <OBJECTIVE>
    /// Constructor.
    /// </OBJECTIVE>
    public ODS_AddStatusReportController() 
    {
        
        SRDate = System.Today();
        Datetime currentDateTime = Datetime.now(); // Returns the current Datetime based on a GMT calendar.
        CurrentDate  = currentDateTime.format('MM/dd/YYYY'); // formats the date
        DateTime minDateTime =currentDateTime.addDays(-7);
        minDate = minDateTime.format('MM/dd/YYYY') ;
        
        Date stDate = date.parse(CurrentDate);
        statusDate = SRDate.format();
        objUser = new User();
        objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId()); 
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        objStsRprt = new Status_Report__c();
        currentUserName = UserInfo.getName();
          system.debug('***Constructor called');
        AccountId = ApexPages.currentPage().getParameters().get('accntId');
        ServiceId = ApexPages.currentPage().getParameters().get('srvcId');
        srId = ApexPages.currentPage().getParameters().get('srId');
        if(srId != null)
        {
            try
            {
                objStsRprt = ODS_Data_Utility.fetchStatusReportbyID(srId);
                system.debug('**1'+objStsRprt );
            }
            catch(Exception ex)
            {
                System.debug('ex in getting status report-------'+ex);
            }
            
            
        }
        
        if(objStsRprt.Id !=  null)
        {
            SRStatus = objStsRprt.Status__c;
            if(objStsRprt.Status__c == 'Submitted')
            {
                system.debug('***2'+objStsRprt.Status__c);
                blShowCopyButton = false;
                blShowSaveBtn = false;
                blShowSubmitBtn = false;
            }
            else
            {
                blShowCopyButton = true;
                blShowSaveBtn = true;
                blShowSubmitBtn = true;
            }
            WorkDayParam = objStsRprt.Work_for_the_Day__c;
            WorkNextDayParam = objStsRprt.Work_for_the_Next_Day__c;
            IssuesConcernsParam = objStsRprt.Issues_And_Concerns__c;
            //statusDate = objStsRprt.Status_Date__c.format();
            SRDate = objStsRprt.Status_Date__c;
            //srDate = FormatStringToDate(sDate);
        }
        else
        {
            //statusDate = System.today().format();
            if(objStsRprt.Status__c != 'Submitted')
            {
            SRStatus = 'None';
            system.debug('***1--Else');
            blShowCopyButton = true;
            blShowSaveBtn = true;
            blShowSubmitBtn = true;
            }
            statusDate = SRDate.format();
            system.debug('*Status'+statusDate);
        }
        
        
        
        if(AccountId != null && ServiceId != null)
        {
            
            try
            {
                objAccntSrvcs = ODS_Data_Utility.fetchAccServcesByAccntAndSrvce(AccountId,ServiceId);
                if(objAccntSrvcs.Id != null)
                {
                    AccountName = objAccntSrvcs.Account__r.Name;
                    ServiceName = objAccntSrvcs.ODS_Services__r.Name__c;
                    
                }
            }
            catch(Exception ex)
            {
                System.debug('ex in getting account service-------'+ex);
            
            
            } 
        }

        else
        {
            AccountName = 'All';
            ServiceName = 'All';
        
        }    
        
        system.debug('**Sys2'+objAccntSrvcs);
        system.debug('**Sys3'+SRDate);
        //AcntSrvId = objAccntSrvcs.Id;
        //system.debug('+++'+AcntSrvId );
        //To hide or show copy button
        List<Status_Report__c> getPrevStatusRep = ODS_Data_Utility.getPrevStatusRep(objAccntSrvcs.Id,SRDate);
        system.debug('**-'+getPrevStatusRep); 
        if(getPrevStatusRep.size() == 0)
        {
            if(objStsRprt.Id !=  null)
            {
                SRStatus = objStsRprt.Status__c;
                blShowCopyButton = false;
                
            }
            else
            {
                blShowCopyButton = false;
            }
            
        }
    }
    
    
    /// <OBJECTIVE>
    /// Method to fetch related service.
    /// </OBJECTIVE>   
   
    public void SetRelatedService()
    {
        if(AccountId == 'All')
        {
            ServiceId = 'All';
        }
        else
        {
            //ServiceId = ODS_Data_Utility.fetchAccServcesByAcc(AccountId)[0].ODS_Services__c;
            ServiceId = 'All';
        }
    }
    
    
    
    /// <OBJECTIVE>
    /// Method to fetch all accounts
    /// </OBJECTIVE>   
    public Set<string> GetAllAccounts()
    {
        Set<string> accountIdSet = new Set<string>();
        for(Account account: ODS_Data_Utility.GetAllAccounts())
        {
            accountIdSet.add(account.Id);
        }
        return accountIdSet;
    }
    
    /// <OBJECTIVE>
    /// Method to fetch all service.
    /// </OBJECTIVE>   
    public Set<string> GetAllServices()
    {
        Set<string> serviceIdSet = new Set<string>();
        for(ODS_Services__c odsService: ODS_Data_Utility.GetAllServices())
        {
            serviceIdSet.add(odsService.Id);
        }
        return serviceIdSet;
    }
    
    
    
    /// <OBJECTIVE>
    /// Method to format string to date.
    /// </OBJECTIVE>   
    public Date FormatStringToDate(string dateString)
    {
        string[] dateArr = dateString.split('-');
        return date.Parse(dateArr[1]+'/'+dateArr[0]+'/'+dateArr[2]);
    }
    
    /// <OBJECTIVE>
    /// Method to fetch all account picklist.
    /// </OBJECTIVE>   
    public static List<SelectOption> GetAccountPicklistValues()
    {
        List<SelectOption> lstSlctOptn = new list<SelectOption>(); 
        ODS_Common_Utility objUtility = new ODS_Common_Utility();
        lstSlctOptn = objUtility.getCustomersByLoggedInUser();
        return lstSlctOptn;
    }
    
    /// <OBJECTIVE>
    /// Method to fetch all service picklist.
    /// </OBJECTIVE>  
    /*public static List<SelectOption> GetServicePicklistValues()
    {
        List<SelectOption> lstSlctOptn = new list<SelectOption>();      
        lstSlctOptn.add(new SelectOption('All', 'All')); 
        for(ODS_Services__c odsService: ODS_Data_Utility.GetAllServices())
        { 
            lstSlctOptn.add(new SelectOption(odsService.Id, odsService.Name)); 
        }
        return lstSlctOptn;
    }*/
    
     public List<SelectOption> GetServicePicklistValues()
    {
        List<SelectOption> lstSlctOptn = new list<SelectOption>();      
        lstSlctOptn.add(new SelectOption('All', 'All Services'));
        if(ODS_Data_Utility.fetchAccServcesByAcc(AccountId).size() >= 0)
        {
            for(Account_Services__c odsAccService: ODS_Data_Utility.fetchAccServcesByAcc(AccountId))
            { 
                lstSlctOptn.add(new SelectOption(odsAccService.ODS_Services__c, odsAccService.ODS_Services__r.Name__c)); 
            }
        } 
        
        return lstSlctOptn;
        
                
    }
    
    
    /// <OBJECTIVE>
    /// Fetch the Status values dynamically and returns.
    /// </OBJECTIVE>
    public static List<SelectOption> GetStatusPicklistValues()
    {
        List<SelectOption> lstSlctOptn = new list<SelectOption>();        
        Schema.sObjectType objType = Timesheet__c.getSObjectType();         
        Schema.DescribeSObjectResult objDscrb = objType.getDescribe(); 
        map<String, Schema.SObjectField> mapFld = objDscrb.fields.getMap(); 
        List<Schema.PicklistEntry> lstPckLstVls = mapFld.get('status__c').getDescribe().getPickListValues();        
        lstSlctOptn.add(new SelectOption('None', '--None--')); 
        for (Schema.PicklistEntry picklistVal : lstPckLstVls)
        { 
            lstSlctOptn.add(new SelectOption(picklistVal.getLabel(), picklistVal.getValue())); 
        }
        return lstSlctOptn;        
    }
    
    
    
    /// <OBJECTIVE>
    /// Method to save Status Report.
    /// </OBJECTIVE>  
    
    public pagereference saveStatusReport()
    {
        system.debug('***Save');
        PageReference pr = new PageReference('/apex/StatusReport?accntId='+AccountId+'&srvcId='+serviceId);
        srToInsert = new Status_Report__c();
        srToUpdate = new Status_Report__c();
        
        List<Status_Report__c> lstObjStRprt = new List<Status_Report__c>();
        //lstObjStRprt = [SELECT Id,Status_Date__c from Status_Report__c WHERE Status_Date__c =: SRDate AND Account_Services__c =: objAccntSrvcs.Id];
        lstObjStRprt = ODS_Data_Utility.getSRBsdOnDate(SRDate,objAccntSrvcs.Id);
        system.debug('***SRDate'+SRDate);
        
        /*string StatusRpDate = string.valueOf(SRDate);
        system.debug('_*_'+StatusRpDate);
        srId = StatusRpDate;
        system.debug('_*_'+srId);
        objStsRprt = ODS_Data_Utility.fetchStatusReportbyID(srId);*/
        
        if(lstObjStRprt.size() != 0)
        {
        
            system.debug('***lstObjStRprt[0].Id'+lstObjStRprt[0].Id);
            srToUpdate.Id = lstObjStRprt[0].Id;
            srToUpdate.Status__c = 'Saved';
            srToUpdate.Work_for_the_Day__c = WorkDayParam;
             system.debug('***Work_for_the_Day__c '+WorkDayParam);
            srToUpdate.Work_for_the_Next_Day__c = WorkNextDayParam;
                  system.debug('***WorkNextDayParam'+WorkNextDayParam);
            srToUpdate.Issues_And_Concerns__c = IssuesConcernsParam;
             system.debug('***Issues_And_Concerns__c '+IssuesConcernsParam);
           // srToUpdate.Status_Date__c = lstObjStRprt[0].Status_Date__c;
             srToUpdate.Status_Date__c =SRDate;
            try
            {
                if(WorkDayParam != '')
                {
                    update srToUpdate;
                    //PageReference pr = new PageReference('/apex/StatusReport?accntId='+AccountId+'&srvcId='+serviceId);
                    pr.setRedirect(true);
                    return pr;
                }
                else
                {
                    blPgErrorMsg = true;
                    Apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Work Performed Today is mandatory'));
                }
            }
            catch(Exception ex)
            {
                System.debug('exception while updating in save method------------'+ex);
            }
            
        }
        else
        {
            Date frmtdDate = Date.parse(statusDate);
            system.debug('*frmtdDate'+frmtdDate);
            system.debug('*WorkDayParam '+WorkDayParam );
            try
            {
                if(WorkDayParam != '')
                {
                    blPgErrorMsg = false;
                    srToInsert = ODS_Data_Utility.insertStatusReport(SRDate,WorkDayParam,WorkNextDayParam,IssuesConcernsParam,'Saved',objAccntSrvcs.Id);
                    //PageReference pr = new PageReference('/apex/StatusReport?accntId='+AccountId+'&srvcId='+serviceId);
                    pr.setRedirect(true);
                    return pr;
                }
                else
                {
                    blPgErrorMsg = true;
                    Apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Work Performed Today is mandatory'));
                }
            }
            catch(Exception ex)
            {
                System.debug('exception while inserting in save method------------'+ex);
            }
        }
        return null;
      }
    /*public PageReference PgeRedirect()
    {
        system.debug('***PageRef');
        PageReference pr = new PageReference('/apex/StatusReport?accntId='+AccountId+'&srvcId='+serviceId);
        pr.setRedirect(true);
        return pr;
    }*/
        
    /// <OBJECTIVE>
    /// Method to submit Status Report
    /// </OBJECTIVE>  
    public pagereference submitStatusReport()
    {
        PageReference pr = new PageReference('/apex/StatusReport?accntId='+AccountId+'&srvcId='+serviceId);
        srToInsert = new Status_Report__c();
        srToUpdate = new Status_Report__c();
        String sRprtName = '';
        List<Status_Report__c> lstObjStRprt = new List<Status_Report__c>();
        //lstObjStRprt = [SELECT Id,Status_Date__c from Status_Report__c WHERE Status_Date__c =: SRDate AND Account_Services__c =: objAccntSrvcs.Id];
        lstObjStRprt = ODS_Data_Utility.getSRBsdOnDate(SRDate,objAccntSrvcs.Id);
        system.debug('***'+lstObjStRprt);
        
        if(lstObjStRprt.size() != 0)
        {
            srToUpdate.Id = lstObjStRprt[0].Id;
            srToUpdate.Status__c = 'Submitted';
            srToUpdate.Work_for_the_Day__c = WorkDayParam;
            srToUpdate.Work_for_the_Next_Day__c = WorkNextDayParam;
            srToUpdate.Issues_And_Concerns__c = IssuesConcernsParam;
            srToUpdate.Status_Date__c = lstObjStRprt[0].Status_Date__c;
            try
            {
                if(WorkDayParam != '')
                {
                    update srToUpdate;
                    sendEmail(srToUpdate);
                    pr.setRedirect(true);
                    return pr;
                }
            }
            catch(Exception ex)
            {
                System.debug('exception while updating in submit method------------'+ex);
            }
            
        }
        else
        {
            
            if(AccountId != null && ServiceId != null)
            {
                try
                {
                    objAccntSrvcs = ODS_Data_Utility.fetchAccServcesByAccntAndSrvce(AccountId,ServiceId);
                }
                catch(Exception ex)
                {
                    System.debug('ex----------'+ex);
                }
            
                
            }
            try
            {
                if(WorkDayParam != '')
                {
                    blPgErrorMsg = false;
                    Date frmtdDate = Date.parse(statusDate);
                    //date.valueOf(statusDate)
                    srToInsert = ODS_Data_Utility.insertStatusReport(SRDate ,WorkDayParam,WorkNextDayParam,IssuesConcernsParam,'Submitted',objAccntSrvcs.Id);
                    System.debug('srToInsert-------------'+srToInsert);
                    sendEmail(srToInsert);
                    pr.setRedirect(true);
                    return pr;
                }
                else
                {
                    blPgErrorMsg = true;
                    Apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Work Performed Today is mandatory'));
                }
            }
            catch(Exception ex)
            {
                System.debug('exception while inserting in submit method------------'+ex);
            }
        }
        
        //PageReference pr = new PageReference('/apex/StatusReport?accntId='+AccountId+'&srvcId='+serviceId);
        //pr.setRedirect(true);
        return null;
        
         
    }
    
    
    /// <OBJECTIVE>
    /// Method to cancel Status Report.
    /// </OBJECTIVE>  
    public pagereference cancelStatusReport()
    {
        PageReference pr = new PageReference('/apex/StatusReport');
        pr.setRedirect(true);
        return pr;

    }
    
    ///<OBJECTIVE>
    /// Method to Copy status report
    ///</OBJECTIVE>
    
    public pagereference fetchStatusReportByDate()
    {
        //List<Status_Report__c> getPrevStatusRep = [SELECT Id,CreatedDate,Work_for_the_Day__c,Work_for_the_Next_Day__c,Issues_And_Concerns__c,Status_Date__c,Status__c FROM Status_Report__c WHERE Account_Services__c =: objAccntSrvcs.Id AND Status_date__c <: SRDate ORDER BY Status_Date__c DESC];
        List<Status_Report__c> getPrevStatusRep = ODS_Data_Utility.getPrevStatusRep(objAccntSrvcs.Id,SRDate);
        if(getPrevStatusRep.size() != 0)
        {
                     
            WorkDayParam = getPrevStatusRep[0].Work_for_the_Day__c;
            WorkNextDayParam = getPrevStatusRep[0].Work_for_the_Next_Day__c;
            IssuesConcernsParam = getPrevStatusRep[0].Issues_And_Concerns__c;
        }
        return null;
    }
    
    ///<OBJECTIVE>
    /// Method to Fetch custom date Status Report
    /// </OBJECTIVE>
    public pageReference fetchCustomDateSR()
    {
        //List<Status_Report__c> getPrevStatusRep = [SELECT Id,CreatedDate,Work_for_the_Day__c,Work_for_the_Next_Day__c,Issues_And_Concerns__c,Status_Date__c FROM Status_Report__c WHERE Account_Services__c =: objAccntSrvcs.Id AND Status_date__c <: SRDate ORDER BY Status_Date__c DESC];
        List<Status_Report__c> getPrevStatusRep = ODS_Data_Utility.getPrevStatusRep(objAccntSrvcs.Id,SRDate);
        system.debug('***&'+getPrevStatusRep);
        if(getPrevStatusRep.size() == 0)
        {
            blShowCopyButton = false;
        }
        else
        {
            blShowCopyButton = true;
        }
        
        List<Status_Report__c> getCustomStatusRep = ODS_Data_Utility.fetchSR(objAccntSrvcs.Id,SRDate);
        if(getCustomStatusRep.size() != 0)
        {
            SRStatus = getCustomStatusRep[0].Status__c;
            system.debug('(**'+SRStatus);
            if(getCustomStatusRep[0].Status__c == 'Submitted')
            {
                blShowCopyButton = false;
                blShowSaveBtn = false;
                blShowSubmitBtn = false;
            }
            else
            {
                if(getPrevStatusRep.size() != 0)
                {
                    blShowCopyButton = true;
                    blShowSaveBtn = true;
                    blShowSubmitBtn = true;
                }
                else
                {
                    blShowCopyButton = false;
                    blShowSaveBtn = true;
                    blShowSubmitBtn = true;
                }
            }
            
            /*if(getCustomStatusRep[0].Work_for_the_Day__c != null)
            {
                getCustomStatusRep[0].Work_for_the_Day__c = getCustomStatusRep[0].Work_for_the_Day__c.replaceAll('\\<.*?\\>', '');
            }
            
            if(getCustomStatusRep[0].Work_for_the_Next_Day__c != null)
            {
                getCustomStatusRep[0].Work_for_the_Next_Day__c = getCustomStatusRep[0].Work_for_the_Next_Day__c.replaceAll('\\<.*?\\>', '');
            }
            
            if(getCustomStatusRep[0].Issues_And_Concerns__c != null)
            {
                getCustomStatusRep[0].Issues_And_Concerns__c = getCustomStatusRep[0].Issues_And_Concerns__c.replaceAll('\\<.*?\\>', '');
            }*/
            
            WorkDayParam = getCustomStatusRep[0].Work_for_the_Day__c;
            WorkNextDayParam = getCustomStatusRep[0].Work_for_the_Next_Day__c;
            IssuesConcernsParam = getCustomStatusRep[0].Issues_And_Concerns__c;
        }
        else
        {
            SRStatus = 'None';
            blShowSaveBtn = true;
            blShowSubmitBtn = true;
            WorkDayParam = '';
            WorkNextDayParam = '';
            IssuesConcernsParam = '';
        }
        return null;
        
        
    }
    
    /// <OBJECTIVE>
    /// Method to send email once the record is submitted.
    /// </OBJECTIVE> 
    public void sendEmail(Status_Report__c objStatusRprt)
    {
        List<String> lstToAddress = new List<String>();
        List<String> lstCcAddress = new List<String>();
        Set<String> setToAddress = new Set<String>();
        Set<String> setCcAddress = new Set<String>();
        
        Status_Report__c srTosendEmail = new Status_Report__c();
        srTosendEmail = [Select Id, Name, Status_Date__c,Work_For_The_Day__c,Work_For_The_Next_Day__c,Account_Services__r.ODS_Services__C,Issues_and_Concerns__c,Account_Services__c, Account_Services__r.Technical_Account_manager__r.Name,Account_Services__r.Account__c,Account_Services__r.ODS_Services__r.Name,Account_Services__r.ODS_Service_Name__c,Status__c,Account_Services__r.Account__r.Name, Owner.Name, Owner.phone from Status_Report__c where Id=:objStatusRprt.Id];
        System.debug('srTosendEmail------------'+srTosendEmail.Account_Services__c);
        
        
        String accntId = srTosendEmail.Account_Services__r.Account__c;
        String srvcId = srTosendEmail.Account_Services__r.ODS_Services__C;
        System.debug('accntId------------'+accntId); 
        System.debug('srvcId------------'+srvcId);       
        //List of contact who opt for status report
        /*List<Contact> lstCntcs = new List<Contact>();
        lstCntcs =[Select Id, Name, Status_Report_Required__c, email, AccountId from Contact where AccountId =: accntId and Status_Report_Required__c = True ];*/
        List<Contact_Account_Service__c > lstCntcs = new List<Contact_Account_Service__c >();
        lstCntcs =[SELECT ID,AccountId__c,Contact__r.AccountId,Email__c,Name,ODS_Service__c FROM Contact_Account_Service__c WHERE Contact__r.AccountId =: accntId AND ODS_Service__c =:srvcId AND Status_Report_Required__c = True];
        System.debug('lstCntcs------------'+lstCntcs);
        //List of User Accounts associated
        List<User_Account__c> lstUsrAccnts = new List<User_Account__c>();
        lstUsrAccnts = [Select Id, name, User__c,User__r.Email, Account__c, Role_in_Account__c from User_Account__c where Account__c =: accntId];
        System.debug('lstUsrAccnts------------'+lstUsrAccnts);
        //get list of to address
        if(lstCntcs.size() >0)
        {
            for(Contact_Account_Service__c objCntct: lstCntcs)
            {               
                setToAddress.add(objCntct.Email__c);
                
            }
            lstToAddress.addAll(setToAddress);
            
        }
        System.debug('lstToAddress------------'+lstToAddress);
        
        //get list of Cc address
        if(lstUsrAccnts.size() >0)
        {
            for(User_Account__c objUsrAccnt: lstUsrAccnts)
            {
                setCcAddress.add(objUsrAccnt.User__r.Email);
                
            }   
            lstCcAddress.addAll(setCcAddress);          
            
        }
        System.debug('lstCcAddress------------'+lstCcAddress);
        
        Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();        
        mail.setToAddresses(lstToAddress); 
        String sccntMngr = UserInfo.getName(); //srTosendEmail.Account_Services__r.Technical_Account_manager__r.Name;     
        mail.setSenderDisplayName(sccntMngr);
        mail.setCcAddresses(lstCcAddress);
        String subject = srTosendEmail.Account_Services__r.Account__r.Name + '-'+ srTosendEmail.Account_Services__r.ODS_Service_Name__c +' : Daily Status Report - ' +srTosendEmail.Status_Date__c.format();
        mail.setSubject(subject);
        string TAMPhoneNumber = '';
        if(!string.isEmpty(srTosendEmail.Owner.phone)) 
            TAMPhoneNumber = srTosendEmail.Owner.phone;
        
        String strHtmlBody = '' ;       
        strHtmlBody = '<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="2"> <font face="Calibri " size="3">  Hi Team, <br/><br/> Here is your Daily ODS Status Report:    <br/><br/></head><body><ul><li><strong> Work Performed Today </strong> '+ srTosendEmail.Work_for_the_Day__c +'';
        strHtmlBody += '</li></ul><ul> <li> <strong>Work To be Performed Next Working Day </strong> '+srTosendEmail.Work_for_the_Next_Day__c +'</li></ul><ul> <li><strong> Issues/Concerns/Road blocks/Questions </strong>'+srTosendEmail.Issues_And_Concerns__c +' </li></ul></ul> <br/> Please contact me for any additional inputs. <br/>  <br/> <table style="border:none; width:624px; border-collapse: collapse;"><tbody><tr><td style="border-top:2px solid #000; padding-bottom:15px;"></td></tr> <tr><td>Thanks,</td></tr><tr><td>'+UserInfo.getName()+'<tr><td><table><tbody><tr><td valign="top" width="283" style="width:285px; margin:0; padding:25px;vertical-align:top; background-color:#07080A;"><a href="https://www.demandblue.com/" target="_blank"><img src="https://www.demandblue.com/image-assets/signature/demandblue-logo-signature.jpg" alt="DemandBlue" width="285" style="border:none;width:285px;display:block; margin:25px 0;"></a></td><td width="5" style="width:5px;min-width:5px;max-width:5px;margin:0;padding:0;">&nbsp;</td><td style="background-color:#4fc9f3; padding:26px; width:276px;"><table><tbody><tr><td><table><tbody><tr><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">Customer Success Manager</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">:</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#000;">'+UserInfo.getName()+'</span></p></td></tr><tr><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">Phone</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#fff;">:</span></p></td><td><p style="margin:0px;"><span style="font-size:11px; font-family:Arial,sans-serif; color:#000;">'+TAMPhoneNumber+'</span></p></td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td style="border-bottom:2px solid #4fc9f3; padding-top:15px;"></td></tr><tr><td width="624" valign="top" style="width:283px;border:none;padding:10px 0"><p style="text-align:justify;"><span style="font-size:11px; font-family:calibri; color:#ff0000; font-weight: bold;">CONFIDENTIALITY STATEMENT:</span> <span style="font-size:11px; font-family:Arial, Sans-Serif, Times New Roman; color:#a6a6a6;">The information contained in this communication is confidential and intended only for the use of the recipient named above, and may be legally privileged and exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please resend it to the sender and delete the original message and any copy of it from your computer system</span></p></td></tr></tbody></table>';
        mail.setHtmlBody(strHtmlBody);
        if(lstToAddress.size() >0)
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }       
    }
    
    public pagereference redirectToStatusPage()
    {
        String url = '/apex/StatusReport?accntId='+AccountId+'&srvcId='+serviceId;
        Pagereference pgRef = new PageReference(url);
        return pgRef ;
    }
    
    public pagereference redirectToTimeSheet()
    {
        
        String url = '/apex/ViewTimesheet?accntId='+AccountId+'&srvcId='+serviceId;        
        Pagereference pgRef = new PageReference(url);
        return pgRef ;
    
    }
    
    
    
}