public class ODS_DashboardRedirect
{
     public string AccountId
    {
        get;set;
    }
    public string ServiceId
    {
        get;set;
    }

    public string currentUserName
    {
        get;set;
    }
    public string currentUserId;
    List<Account_Services__c> accService = new  List<Account_Services__c>();

        
    public PageReference RedirectDashboardPage()
    {
        
        
        currentUserName = UserInfo.getName();
        currentUserId = UserInfo.getUserId();
        
         user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
         List<ODS_SessionData__c> sessiondata = ODS_Common_Utility.fetchSessionData(UserInfo.getUserId());
         system.debug('###sessiondata: '+ sessiondata);
         
         AccountId = sessiondata[0].Account_Id__c;
         ServiceId = sessiondata[0].Service_Id__c;  
         PageReference PgRef;
         
         ODS_CustomLandingController CstmLandingPage = new ODS_CustomLandingController();
         
         if(AccountId != 'All' && ServiceId != 'All')
         {
             system.debug('---AccountId'+AccountId);
             system.debug('---ServiceId'+ServiceId);
             
              accService = ODS_Data_Utility.fetchAccServcesByAccAndSrv(AccountId,ServiceId);
              
              system.debug('---accService '+accService );
            
            system.debug('Test Demo');
            
            
            if(accService[0].Type_of_Engagement__c == 'ODS')
            {
                PgRef = new PageReference('/apex/Dashboard');  
                system.debug('@@@PageReference'+PgRef );
                system.debug('ODS Type');
            }
            else
            {
                PgRef = new PageReference('/apex/Dashboard_TM');  
                system.debug('@@@PageReference'+PgRef );
    
                system.debug('SOW/TM Type');
            }
        }
        
        else if ((AccountId == 'All' && ServiceId == 'All') || (AccountId == 'All' && ServiceId != 'All') || (AccountId != 'All' && ServiceId == 'All'))
            {
            
                currentUserId = UserInfo.getUserId();
                String portalRole = CstmLandingPage.getLoggedUserPortalRole();
                Boolean isPortalAccess = true;
                integer count = 0;
                integer EngmtTypeCount = 0;
                
                List<Contact> cnt = ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId);
                
                ODS_Common_Utility CmnUtility = new ODS_Common_Utility();
                string query = CmnUtility.getCustomersQueryByLoggedInUser();
                system.debug('&&&query '+query);
                string contactId;
                if(portalRole == 'Customer')
                {
                    contactId = cnt[0].Id;
                    query += ' WHERE Id =: contactId LIMIT 1 ';
                    system.debug('&&&query '+query);
                }
                
                if(portalRole == 'Technical Account Manager' || portalRole == 'Account Manager' || portalRole == 'Account Partner' || portalRole == 'Execution Partner')
                {
                    query += 'AND User__c =: currentUserId ORDER BY Account__r.Name ASC ';
                    system.debug('&&&query '+query);
                }

                
                List<sobject> sObjectsRecrds =  database.query(query);
                system.debug('&&&sObjectsRecrds '+sObjectsRecrds );
                String AccountIdSobj;
                string EngType;
                
                
                                
                if(portalRole == 'Practice Head' )
                {
                     AccountIdSobj = String.valueOf( sObjectsRecrds[0].get('Id') );
                     accountId = AccountIdSobj;
                     EngType = CstmLandingPage.getServiceId(accountId);
                     
                     if(EngType != '')
                     {
                         if(EngType == 'ODS')
                         {
                             pgRef = new PageReference('/apex/Dashboard'); 
                         }
                         else
                         {
                             pgRef = new PageReference('/apex/Dashboard_TM');
                         }
                     }
                }
                
                else if(portalRole == 'Customer')
                {
                    AccountIdSobj = String.valueOf( sObjectsRecrds[0].get('AccountId') );
                    accountId = AccountIdSobj;
                    system.debug('###'+accountId);
                    EngType = CstmLandingPage.getServiceId(accountId);
                    system.debug('###'+EngType);
                    if(EngType != '')
                     {
                         if(EngType == 'ODS')
                         {
                             pgRef = new PageReference('/apex/Dashboard'); 
                         }
                         else
                         {
                             pgRef = new PageReference('/apex/Dashboard_TM');
                         }
                     }
                }
                
                else
                {
                    AccountIdSobj= String.valueOf( sObjectsRecrds[0].get('Account__c') );
                    accountId = AccountIdSobj;
                    EngType = CstmLandingPage.getServiceId(accountId);
                    
                    if(EngType != '')
                     {
                         if(EngType == 'ODS')
                         {
                             pgRef = new PageReference('/apex/Dashboard'); 
                         }
                         else
                         {
                             pgRef = new PageReference('/apex/Dashboard_TM');
                         }
                     }
                }
                
                
                
            
            
            }
        
         PgRef.SetRedirect(true);

        return PgRef;
    }
    

    
    
}