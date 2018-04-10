global class ODS_HeaderController
{
    public string AccountId
    {
        get;set;
    }
    public string currentUserName
    {
        get;set;
    }
    
    public Boolean isCustomer
    {
        get;set;
    }
    
    public string PortalUserRole
    {
        get;set;
    }
    public Boolean IsPortalApprover
    {
        get;set;
    }
    
    public  Contact objContact 
    {
        get;set;
    }
    
    public string PageName{get;set;}

    
    public ODS_HeaderController()
    {
        //PageName = ApexPages.currentPage().GetURL().substringBefore('?').substringafter('/').substringafter('/');
        currentUserName = UserInfo.getName();
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        
        if(objUser.PortalUserRole__c == 'Customer'){
            isCustomer = true;
        }
        else{
            isCustomer = false;
        }
        List<ODS_SessionData__c> sessiondata = ODS_Common_Utility.fetchSessionData(UserInfo.getUserId());
        string PageName = ApexPages.currentPage().GetURL().substringBefore('?').substringafter('/').substringafter('/');
        system.debug('@@@PageName : '+ PageName );
        system.debug('###sessiondata: '+ sessiondata);
        if(PageName != 'Dashboard'){
            if(sessiondata.size() == 0){
                AccountId = 'ALL';
                ServiceId = 'All';
                    
            }
            else{
                AccountId = sessiondata[0].Account_Id__c;
                ServiceId = sessiondata[0].Service_Id__c;  
                system.debug('---AccountId'+AccountId);
                system.debug('---ServiceId'+ServiceId);  
            } 
        }
        else{        
            //Else loop for dashboard page. 
            List<SelectOption> lstSlctOptn = new  list<SelectOption>();
            ODS_Common_Utility objUtility = new  ODS_Common_Utility();
            lstSlctOptn = objUtility.getCustomersByLoggedInUser(PageName);          
            if(sessiondata.size() == 0){ // Checks if session data is not saved. 
                if(lstSlctOptn.size() > 0){
                    SelectOption objoption = lstSlctOptn[0];
                    AccountId = objoption.getValue();                
                }
            }
            else{
                if(sessiondata[0].Account_Id__c =='All'){ //if saved then check for account id is all.             
                    if(lstSlctOptn.size() > 0){
                        SelectOption objoption = lstSlctOptn[0];
                        AccountId = objoption.getValue();                                         
                    }              
                }else{             
                    AccountId = sessiondata[0].Account_Id__c;
                    ServiceId = sessiondata[0].Service_Id__c;  
                }
            }            
        }               
    }
       
     
    public void GetLoggedUserAccountService()
    {
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        PortalUserRole = objUser.PortalUserRole__c;
        IsPortalApprover = objUser.Contact.Is_Approver__c;
        if(PortalUserRole == 'Customer')
        {
            List<Contact> cnt = new  List<Contact>();
            cnt = ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId);
            system.debug('###cnt'+cnt);
            if(cnt.size() > 0)
            {
                AccountId = cnt[0].AccountId;
            }
            else
            {
                AccountId = 'All';
            }
             system.debug('###AccountId '+AccountId );
            List<Account_Services__c> accService = new  List<Account_Services__c>();
            accService = ODS_Data_Utility.fetchAccServcesByAcc(AccountId);
            List<Contact_Account_Service__c> contactService = new list<Contact_Account_Service__c >();
            contactService = ODS_Data_Utility.GetAccServiceByContact(objUser.ContactId);
            if(accService.size() > 0)
            {
                ServiceId = accService[0].ODS_Services__c;
            }
            else
            {
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
        system.debug('Acnt$$$'+AccountId );
        PageName = ApexPages.currentPage().GetURL().substringBefore('?').substringafter('/').substringafter('/');
        system.debug('^^^'+PageName);
    }
    
    public string ServiceId
    {
        get;set;
    }
    
    public List<SelectOption> GetAccountPicklistValues()
    {
        List<SelectOption> lstSlctOptn = new  list<SelectOption>();
        ODS_Common_Utility objUtility = new  ODS_Common_Utility();
        string PageName = ApexPages.currentPage().GetURL().substringBefore('?').substringafter('/').substringafter('/');
        lstSlctOptn = objUtility.getCustomersByLoggedInUser(PageName);
        set<SelectOption> setSlctOptn = new  set<SelectOption>();
        setSlctOptn.addAll(lstSlctOptn);
        List<SelectOption> lstSlctOptn2 = new  list<SelectOption>();
        lstSlctOptn2.addAll(setSlctOptn);
        return lstSlctOptn2;        
    }
    
    public List<SelectOption> getServiceDropdownValues()
    {
        string PageName = ApexPages.currentPage().GetURL().substringBefore('?').substringafter('/').substringafter('/');
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        string  portalRole = objUser.PortalUserRole__c;
        IsPortalApprover = objUser.Contact.Is_Approver__c;
        List<SelectOption> lstSlctOptn = new  list<SelectOption>();
        List<Account_Services__c > lstfetchAccServcesByAcc = new List<Account_Services__c >();
        
        if(PageName == 'Dashboard' && portalRole == 'Practice Head')
        {
            lstSlctOptn.add(new  SelectOption('All', 'All Services'));
        }

        if(PageName != 'Dashboard' && PageName != 'viewTimesheet')
        {
            lstSlctOptn.add(new  SelectOption('All', 'All Services'));
        }
        if(PortalRole != 'Customer' && PageName == 'viewTimesheet')
        {
            lstSlctOptn.add(new  SelectOption('All', 'All Services'));
            lstfetchAccServcesByAcc = ODS_Data_Utility.fetchAccServcesByAccAndEngmtType(AccountId);
            if(lstfetchAccServcesByAcc.size()!=0)
            {
                for(Account_Services__c odsAccService: lstfetchAccServcesByAcc)
                {
                    lstSlctOptn.add(new  SelectOption(odsAccService.ODS_Services__c, odsAccService.ODS_Services__r.Name__c));
                }
            }        
        }
        if(AccountId != 'All')
        {
            system.debug('@@@PortalUserRole '+PortalUserRole);
            if(portalRole == 'Customer')
            {
                if(PageName != 'viewTimesheet')
                {
                    system.debug('@@@PortalUserRole '+PortalUserRole);
                    List<Contact_Account_Service__c> contactService = new list<Contact_Account_Service__c >();
                    contactService = ODS_Data_Utility.GetAccServiceByContact(objUser.ContactId);
                    if(contactService.size() > 0)
                    {
                        for(Contact_Account_Service__c odsAccService: contactService)
                        {
                            lstSlctOptn.add(new  SelectOption(odsAccService.ODS_Service__c, odsAccService.ODS_Service__r.Name__c));
                        }
                    }  
                } 
                else
                {
                    system.debug('@@@PortalUserRole '+PortalUserRole);
                    List<Contact_Account_Service__c> contactService = new list<Contact_Account_Service__c >();
                    contactService = ODS_Data_Utility.GetAccServiceByContact(objUser.ContactId);
                    if(contactService.size() > 0)
                    {   
                        set<string> serviceIdSet = new set<string>();
                        for(Contact_Account_Service__c conServ :contactService){
                            serviceIdSet.add(conServ.ODS_Service__c);
                        }
                        for(Account_Services__c odsAccService: ODS_Data_Utility.fetchAccServcesByAccAndEngmtType(contactService[0].Account__c, serviceIdSet))
                        {
                            lstSlctOptn.add(new  SelectOption(odsAccService.ODS_Services__c, odsAccService.ODS_Services__r.Name__c));
                        }
                    }  
                } 
            }
            else
            {
                if(PageName != 'viewTimesheet')
                {
                    lstfetchAccServcesByAcc = ODS_Data_Utility.fetchAccServcesByAcc(AccountId);
                    if(lstfetchAccServcesByAcc.size()!=0)
                    {
                        for(Account_Services__c odsAccService: lstfetchAccServcesByAcc)
                        {
                            lstSlctOptn.add(new  SelectOption(odsAccService.ODS_Services__c, odsAccService.ODS_Services__r.Name__c));
                        }
                    }
                }
            }
        }
        else {
            List<ODS_Services__c> servceLst = new List<ODS_Services__c >();
            servceLst = ODS_Data_Utility.fetchAccServces(); 
            if(servceLst.size()!=0)
            {
                for( ODS_Services__c odsServces: servceLst)
                {
                    lstSlctOptn.add(new SelectOption(odsServces.id, odsServces.Name__c));
                }  
            } 
        }
        return lstSlctOptn;
    }
    

    
    @RemoteAction
    global static string RedirectDashboardPage(string DashboardAcntId, string DashboardSrvId)
    {
        
        system.debug('--#######-DashboardAcntId'+DashboardAcntId);
        system.debug('-##########--DashboardSrvId'+DashboardSrvId);
        List<Account_Services__c> accService = new  List<Account_Services__c>();
        string EngagementType;
        string AgileType;
        accService = ODS_Data_Utility.fetchAccServcesByAccAndSrv(DashboardAcntId,DashboardSrvId);
        system.debug('---accService '+accService );
        if(accService[0].Type_of_Engagement__c == 'ODS')
        {
            EngagementType = 'ODS';
        }
        else if (accService[0].Type_of_Engagement__c == 'SOW' || accService[0].Type_of_Engagement__c == 'T&M')
        {
            EngagementType = 'Other';
        }
        AgileType = accService[0].Agile__c;
        return EngagementType+'$$##'+AgileType ;
        
        
    }
     
    public String getUserPhoto()
    {
          if(isCustomer){
            return getCustomerPhoto();
          }else{
            return getPhoto();
          }
    }   
    /// <OBJECTIVE>
    /// To get photo for the user.
    /// </OBJECTIVE>
    public String getPhoto()
    {
        String Photo = '';
        List<User_Photo__c> userPhotoLst = new List<User_Photo__c>();
        set<Id> userId = new set<Id>();
        userId.add(UserInfo.getUserId());
        try
        {
            userPhotoLst = ODS_Data_Utility.fetchUserPhotoByUserId(userId);
            
            List<Attachment> attachedFiles = new List<Attachment>();
            if(userPhotoLst.size()>0)
                attachedFiles = ODS_Data_Utility.fetchAttachmentByUserPhotoId(userPhotoLst[0].Id);
            if(attachedFiles.size()>0)         
                Photo = attachedFiles[0].Id;
        }
        catch(Exception e)
        {
            system.debug('No rows found');
        }
        return Photo;    
    }
    
    /// <OBJECTIVE>
    /// To get photo for the customer.
    /// </OBJECTIVE>
    public String getCustomerPhoto()
    {
        String Photo = '';
        User objuser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        string conId = objuser.ContactId;
        objContact = ODS_Data_Utility.fetchAttachmentByContactId(conId);
        if(objContact.attachments.size() > 0){
            Photo = objContact.attachments[0].Id;
        }
        return Photo;
    }
}