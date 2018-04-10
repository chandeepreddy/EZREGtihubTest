/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             05-Oct-2016
 * @Status           Developed
 * @description      This is the class to list the customer.
 */
public class ODS_CustomerController {

    //Properties for Customer List page
    public string currentUserName {get;set;}
    public string currentUserId {get;set;}
    public string portalRole{get;set;}
    public LIST<Account_Services__c> accServceLst{get;set;}
    public LIST<User_Account__c > accLstByRole{get;set;}
    public LIST<Account> allAccLst{get;set;}
    public set<Id> accId{get;set;}
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    public set<Id> userPhotoId{get;set;}
    public List<Attachment> attachedFiles{get;set;} 
    
    //Properties for Customer detail page 
    public string slctdCustId{get;set;}
    public string custSrvce{get;set;}
    public string slctdCustService{get;set;}
    public string contactId{get;set;}
    public string billingAddress{get;set;}
    public string tamName {get;set;}
    public string tamEmail{get;set;}
    public string tamPhone{get;set;}   
    public string AcntMngrName{get;set;}
    public string AcntMngrEmail{get;set;}
    public string AcntMngrPhone{get;set;} 
  
    public Account objAcc{get;set;}
    public List<Contact> objCon{get;set;}
    public Account_Services__c objAccSrvc{get;set;}
    public Boolean isCustomer{get;set;}
    public Boolean isCustomerGrid{get;set;}
    public Boolean isHideService{get;set;}
        
    //Properties for pagination
    public Integer PageSize {get;set;}
    public Integer CurrentPage {get;set;}
    public Boolean ShowPrevious {get;set;}
    public Boolean ShowNext {get;set;}
    public String CurrentPageInfo {get;set;}
    public Integer TotalRecords;
    public Integer PageNumber; 
        
    public ODS_CustomerController()
    {
        currentUserName = UserInfo.getName();
        currentUserId = UserInfo.getUserId();
        accServceLst = new LIST<Account_Services__c>();
        isCustomer = false;
        isCustomerGrid = false;
        CurrentPage = 0; 
        PageSize = integer.valueof(System.Label.PageSize); // No. of rows per page
        PageNumber = 1; 
        ShowPrevious = false; 
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        portalRole = objUser.PortalUserRole__c;
        contactId = objUser.contactId;
        if(portalRole == 'Customer')
        { 
            isCustomer = true;
            isCustomerGrid = true;
        }
    }

    public void GetCustomerByAccountServiceID() {
        
        ODS_Common_Utility.upsertSessionData(AccountId,ServiceId);
        if(portalRole == 'Customer')
        { 
            isCustomer = true;
            isCustomerGrid = true;
            fetchMyAccDetails();
        }
        else
        {
          fetchSearchCustomersList();
        } 
        
    }    
    
    /// <OBJECTIVE>
    /// Fetch My account details.
    /// </OBJECTIVE>
    public void fetchMyAccDetails()
    {
         List<User_Account__c> accountLst = new  List<User_Account__c>();
         List<string> acnts = new  List<string>();
         contact con = ODS_Data_Utility.getAccountByContactId(ContactId);
         if(!string.isEmpty(con.id))
             slctdCustId = con.AccountId;
         List<Account_Services__c> acntSrvcLst = new List<Account_Services__c >();
         acntSrvcLst = ODS_Data_Utility.fetchAccServcesByAcc(slctdCustId);

         if(serviceId == 'All')
             serviceId = acntSrvcLst[0].ODS_Services__c;
         displayCustomerDetails(slctdCustId, serviceId);
    }
    
    
    /// <OBJECTIVE>
    /// Fetch customer list based on the search criteria.
    /// </OBJECTIVE>
    public void fetchSearchCustomersList()
    {
       accServceLst =  fetchCustomersByCriteria(AccountId, ServiceId);
       CurrentPage = 0; 
       PageNumber = 1; 
       ShowPrevious = false;
       if(accServceLst.size()>0)
       {
            TotalRecords = accServceLst.size();  // Total No of records need to display in Grid.      
            if(TotalRecords > PageSize)
                ShowNext = true;
            else
                ShowNext = false;       
            CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
        }
    }
    
   public LIST<Account_Services__c> fetchCustomersByCriteria(string Account, string Service){
    
       Boolean isPortalAccess = true;
       integer count = 0;
       system.debug('AccountId:' +Account);
       string fetchAccQuery = 'SELECT Id, Name, Is_Portal_Access__c FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND '
                                + 'Count_of_Services__c >: count ';
       string fetchCustQuery = 'SELECT Name, User__c, Account__c, Account__r.name, Account__r.Is_Portal_Access__c FROM User_Account__c '+
                                   ' WHERE Account__r.Is_Portal_Access__c =: isPortalAccess ';
       string fetchSrvceQuery = 'SELECT Account__c, Account__r.Name, Contract_End_Date__c, ODS_Services__c, ODS_Services__r.Name__c, '+
                                  ' Technical_Account_manager__r.Name, Technical_Account_manager__c FROM Account_Services__c  ';
       accServceLst = new LIST<Account_Services__c>(); 
       allAccLst = new LIST<Account>(); 
       accId = new set<Id>();
       user objuser = ODS_Data_Utility.fetchUserById(currentUserId);
       
       if(objuser.PortalUserRole__c == 'Practice Head')
       {
           if(Account== 'All')
           {
               allAccLst = new LIST<Account>();
               allAccLst = database.query(fetchAccQuery);
           }
           
           else
           {
               fetchAccQuery += 'AND Id =: Account'; 
               allAccLst = new LIST<Account>();
               allAccLst = database.query(fetchAccQuery);
           }
           if(allAccLst.size()>0)
           {
               for(Account objAccount: allAccLst )
               {
                   string acntId = objAccount.Id;
                   accId.add(acntId);
               }
           }
       }
       
       else
       {
           string portalRole = objuser.PortalUserRole__c;           
           if(Account== 'All')
           {
               fetchCustQuery += ' AND User__c =: currentUserId '; 
               accLstByRole = new LIST<User_Account__c>();
               accLstByRole = database.query(fetchCustQuery);
           }
           
           else
           {
               fetchCustQuery += ' AND User__c =: currentUserId AND Account__c =: Account'; 
               accLstByRole = new LIST<User_Account__c>();
               accLstByRole = database.query(fetchCustQuery);
           }
           if(accLstByRole.size()>0)
           {
               for(User_Account__c  usrObj: accLstByRole )
               {
                   string acntId = usrObj.Account__c;
                   accId.add(acntId);
               }
           }
       }
       if(accId.size()>0)
       {  
           if(Service == 'All')
           {
               fetchSrvceQuery += ' WHERE Account__c IN: accId ';
               accServceLst = database.query(fetchSrvceQuery);
           }
           else
           {
               fetchSrvceQuery += ' WHERE Account__c IN: accId AND ODS_Services__c =: Service ';
               accServceLst = database.query(fetchSrvceQuery);
           }
       }
       return accServceLst; 
    }
    
    /// <OBJECTIVE>
    /// Fetch customer list.
    /// </OBJECTIVE>
    public void fetchCustomersList()
    {
       accServceLst =  fetchCustomersByCriteria('All', 'All');
       CurrentPage = 0; 
       PageNumber = 1; 
       ShowPrevious = false;
       if(accServceLst.size()>0){
            TotalRecords = accServceLst.size();  // Total No of records need to display in Grid.
       
            if(TotalRecords > PageSize)
                ShowNext = true;
            else
                ShowNext = false;       
            CurrentPageInfo = 'Showing Page ' + PageNumber + ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1); 
        }
    }
    /// <OBJECTIVE>
    /// Fetch customer details based on selected customer.
    /// </OBJECTIVE>
    public void passParamToContrler()
    {
       slctdCustId = System.currentPageReference().getParameters().get('custId');
       custSrvce = System.currentPageReference().getParameters().get('custSrvce');
       displayCustomerDetails(slctdCustId, custSrvce);
    }
    /// <OBJECTIVE>
    /// Fetch customer details.
    /// </OBJECTIVE>
    public void displayCustomerDetails(string slctdCustId, string custSrvce)
    {
       getCustomerServices();
       slctdCustService = serviceId;
       List<Account_Services__c> objTAMAccSrvc = new List<Account_Services__c>(); 
       if(!string.isEmpty(custSrvce))
       {
       
           objTAMAccSrvc = ODS_Data_Utility.fetchTAMBySlctdId(slctdCustId, custSrvce);
               system.debug('insideobjTAMAccSrvc '+objTAMAccSrvc );
           if(!objTAMAccSrvc.isEmpty())
           {
               tamName = objTAMAccSrvc[0].Technical_Account_manager__r.Name;
               tamEmail = objTAMAccSrvc[0].Technical_Account_manager__r.Email;
               tamPhone = objTAMAccSrvc[0].Technical_Account_manager__r.Phone;
               
               if(string.isEmpty(tamEmail))
                    tamEmail = 'Not available';
               if(string.isEmpty(tamPhone))
                    tamPhone = 'Not available';    
           }
       }
       try
       {
           User_Account__c  objUserAcc = new User_Account__c();
           objUserAcc = ODS_Data_Utility.fetchAMBySlctdId(slctdCustId);
           if(!string.isEmpty(objUserAcc.id))
           {
               String userId =  objUserAcc.User__c;
               User objuser = ODS_Data_Utility.fetchUserDetailsById(userId);
               if(!string.isEmpty(objuser.id))
               {
                   AcntMngrName= objuser.Name;
                   AcntMngrEmail = objuser.Email;
                   AcntMngrPhone = objuser.Phone;
               } 
           }             
       }
       catch(exception e)
       {
           system.debug(e);
       }
       
       objAcc = ODS_Data_Utility.fetchAccountDetailsById(slctdCustId);
       billingAddress ='';
       if(!string.IsEmpty(objAcc.BillingStreet))
           billingAddress += objAcc.BillingStreet+', '; 
       if(!string.IsEmpty(objAcc.BillingCity))
           billingAddress += objAcc.BillingCity+', ';
       if(!string.IsEmpty(objAcc.BillingState))
           billingAddress += objAcc.BillingState+', ';
       if(!string.IsEmpty(objAcc.BillingCountry))
           billingAddress += objAcc.BillingCountry+', ';
       if(!string.IsEmpty(objAcc.BillingPostalCode ))
           billingAddress += objAcc.BillingPostalCode;   
        
            
       objCon = ODS_Data_Utility.fetchContactDetailsById(slctdCustId);
       objAccSrvc = new Account_Services__c();

       if(!string.isEmpty(custSrvce))
       {
          objAccSrvc = ODS_Data_Utility.fetchServiceDetailsById(slctdCustId, custSrvce);
       }
       isCustomerGrid = true;
    }
  
    /// <OBJECTIVE>
    /// Bind services based on the selected customer.
    /// </OBJECTIVE>
    public List<SelectOption> getCustomerServices()
    {
       List<SelectOption> options = new List<SelectOption>();
       List<Account_Services__c> custSrvceLst = new List<Account_Services__c>();
       custSrvceLst = ODS_Data_Utility.fetchAccServcesByAcc(slctdCustId);
       if(!custSrvceLst.isEmpty())
       {     
           for( Account_Services__c custmrSrvce: custSrvceLst)
           {
              options.add(new SelectOption(custmrSrvce.ODS_Services__c, custmrSrvce.ODS_Services__r.Name__c));
               
           }   
       } 
       return options;
    }
    /// <OBJECTIVE>
    /// Fetch services based on the selected service.
    /// </OBJECTIVE>
    public void fetchServiceById()
    {
        slctdCustService = ServiceID;
        displayCustomerDetails(slctdCustId, slctdCustService);
    }
    /// <OBJECTIVE>
    ///  Enable disable showPrevious button.
    /// </OBJECTIVE>
    public void showPrevious()
    {
        CurrentPage = CurrentPage- PageSize;
        PageNumber--;
        enableDisablePaginationLinks();     
    }
    /// <OBJECTIVE>
    /// Enable disable showNext button
    /// </OBJECTIVE>
    public void showNext()
    {
        CurrentPage = CurrentPage + PageSize;
        PageNumber++;
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable showFirst button
    /// </OBJECTIVE>
    public void showFirst()
    {
        CurrentPage = 0;
        PageNumber = 1;
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable showLast button
    /// </OBJECTIVE>
    public void showLast()
    {
        CurrentPage = (Math.mod(TotalRecords, PageSize) == 0) ? TotalRecords - PageSize : (TotalRecords / PageSize) * PageSize;
        PageNumber = (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
        enableDisablePaginationLinks();
    }
    /// <OBJECTIVE>
    /// Enable disable pagination links
    /// </OBJECTIVE>
    public void enableDisablePaginationLinks()
    {
        if(CurrentPage == 0)
            ShowPrevious = false;
        else    
            ShowPrevious = true; 
        if((TotalRecords - PageSize) <= CurrentPage)
            ShowNext = false;
        else
            ShowNext = true;
        CurrentPageInfo = 'Showing Page ' + PageNumber +   ' of ' + (Math.mod(TotalRecords, PageSize) == 0 ? TotalRecords/PageSize : (TotalRecords/PageSize) + 1);
    }   
}