public class ODS_Common_Utility
{
    public string portalRole{get;set;}
    public string currentUserName {get;set;}
    public string currentUserId {get;set;}
    
    public  list<SelectOption> getCustomersByLoggedInUser()
    {
        return getCustomersByLoggedInUser('');
    }
    public  list<SelectOption> getCustomersByLoggedInUser(String PageName)
    {
        currentUserName = UserInfo.getName();
        currentUserId = UserInfo.getUserId();
               
        List<SelectOption> lstSlctOptn = new list<SelectOption>(); 
        Boolean isPortalAccess = true;
        integer count = 0;
        integer EngmtTypeCount = 0;
        string accQuery = 'SELECT Name, User__c, Account__c,Account__r.Count_of_ODS_Engagement_Type__c,  Account__r.name, Account__r.Count_of_Services__c '+
                'FROM User_Account__c WHERE Account__r.Is_Portal_Access__c =: isPortalAccess AND Account__r.Count_of_Services__c >: count ';        
       
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        portalRole = objUser.PortalUserRole__c;
        
       if(objUser.PortalUserRole__c == 'Customer')
        {               
            lstSlctOptn.add(new SelectOption('All', 'All Customers')); 
            for(Contact cnt: ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId))
            {
                lstSlctOptn.add(new SelectOption(cnt.accountId, cnt.account.Name)); 
            }    
           lstSlctOptn.remove(0); 
        }     
       else if(portalRole == 'Practice Head' )
        {
            if(PageName != 'Dashboard' && PageName != 'viewTimesheet')
            {
                 lstSlctOptn.add(new SelectOption('All', 'All Customers')); 
                 accQuery = 'SELECT id, Name, Is_Portal_Access__c,Count_of_ODS_Engagement_Type__c,Count_of_Services__c   '+
                    'FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND Count_of_Services__c >: count ORDER BY Name ASC ';        
         
                for(Account acc : database.query(accQuery))
                    { 
                        lstSlctOptn.add(new SelectOption(acc.id, acc.Name)); 
                    }  
            } 
            if(PageName == 'Dashboard')
            {
                 lstSlctOptn.add(new SelectOption('All', 'All Customers')); 
                 accQuery = 'SELECT id, Name, Is_Portal_Access__c,Count_of_ODS_Engagement_Type__c,Count_of_Services__c   '+
                    'FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND Count_of_Services__c >: count ORDER BY Name ASC ';        
         
                for(Account acc : database.query(accQuery))
                    { 
                        lstSlctOptn.add(new SelectOption(acc.id, acc.Name)); 
                    }  
            } 
            
            else if (PageName == 'viewTimesheet')
            {
                lstSlctOptn.add(new SelectOption('All', 'All Customers')); 
                 accQuery = 'SELECT id, Name, Is_Portal_Access__c,Count_of_ODS_Engagement_Type__c,Count_of_Services__c   '+
                    'FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND Count_of_Services__c >: count AND Count_of_ODS_Engagement_Type__c >: EngmtTypeCount ORDER BY Name ASC ';        
         
                for(Account acc : database.query(accQuery))
                    { 
                        lstSlctOptn.add(new SelectOption(acc.id, acc.Name)); 
                    } 
            }
            
            else
            {
                
                accQuery = 'SELECT id, Name, Is_Portal_Access__c,Count_of_ODS_Engagement_Type__c,Count_of_Services__c   '+
                'FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND Count_of_Services__c >: count ORDER BY Name ASC ';        
     
                for(Account acc : database.query(accQuery))
                    { 
                        lstSlctOptn.add(new SelectOption(acc.id, acc.Name)); 
                    }  
            }
        }
        else
        {
           if(PageName != 'Dashboard')
           {
            lstSlctOptn.add(new SelectOption('All', 'All Customers')); 
       
            accQuery += 'AND User__c =: currentUserId ORDER BY Account__r.Name ASC ';
            for(User_Account__c acc : database.query(accQuery))
                { 
                    lstSlctOptn.add(new SelectOption(acc.Account__C, acc.Account__r.Name)); 
                }  
            } 
            
            else if (PageName == 'viewTimesheet')
            {
                lstSlctOptn.add(new SelectOption('All', 'All Customers')); 
                 accQuery = 'SELECT id, Name, Is_Portal_Access__c,Count_of_ODS_Engagement_Type__c,Count_of_Services__c   '+
                    'FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND Count_of_Services__c >: count AND Count_of_ODS_Engagement_Type__c >: EngmtTypeCount ORDER BY Name ASC ';        
         
                for(Account acc : database.query(accQuery))
                    { 
                        lstSlctOptn.add(new SelectOption(acc.id, acc.Name)); 
                    } 
            }
            
            else
            {
                accQuery += 'AND User__c =: currentUserId ORDER BY Account__r.Name ASC ';
                for(User_Account__c acc : database.query(accQuery))
                { 
                    lstSlctOptn.add(new SelectOption(acc.Account__C, acc.Account__r.Name)); 
                } 
            }
        }
    return lstSlctOptn;
    }
    
        public string getCustomersQueryByLoggedInUser()
    {
         string currentUserId = UserInfo.getUserId();
         user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
         portalRole = objUser.PortalUserRole__c;
         Boolean isPortalAccess = true;
         integer count = 0;
         integer EngmtTypeCount = 0;
         string contactId;
         
         List<Contact> cnt = ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId);
         if(cnt.size() != 0)
         {
             contactId = cnt[0].Id;
         }
        
         string UserAccQuery = 'SELECT Name, User__c, Account__c,Account__r.Count_of_ODS_Engagement_Type__c,  Account__r.name, Account__r.Count_of_Services__c '+
                'FROM User_Account__c WHERE Account__r.Is_Portal_Access__c =: isPortalAccess AND Account__r.Count_of_Services__c >: count ';
                
         string accQuery = 'SELECT id, Name, Is_Portal_Access__c,Count_of_ODS_Engagement_Type__c,Count_of_Services__c   '+
                    'FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND Count_of_Services__c >: count  ORDER BY Name ASC ';
         
         //string cntQuery = 'SELECT Id,Name, AccountId, Account.name FROM Contact WHERE Id =: contactId LIMIT 1 ' ;
         string cntQuery = 'SELECT Id,Name, AccountId, Account.name FROM Contact ' ;

         string rtnQuery;   
            
            if(portalRole == 'Practice Head' )
            {
                 rtnQuery  = accQuery;
            }
            
            else if(portalRole == 'Customer')
            {     
                rtnQuery = cntQuery;
            }
            
            else
            {
                //UserAccQuery += 'AND User__c =: currentUserId ORDER BY Account__r.Name ASC ';
                rtnQuery = UserAccQuery;
            }
            
            return rtnQuery ;
            
    }
    
    public  List<String> getAllAccountIDByLoggedInUser()
    {    
        currentUserName = UserInfo.getName();
        currentUserId = UserInfo.getUserId();
               
        List<String> lstAccountIDs= new list<String>(); 
        Boolean isPortalAccess = true;
        integer count = 0;
        string accQuery = 'SELECT Name, User__c, Account__c,  Account__r.name, Account__r.Count_of_ODS_Engagement_Type__c ,Account__r.Count_of_Services__c '+
                'FROM User_Account__c WHERE Account__r.Is_Portal_Access__c =: isPortalAccess AND Account__r.Count_of_Services__c >: count ';        
       
        user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
        portalRole = objUser.PortalUserRole__c;
        
       if(objUser.PortalUserRole__c == 'Customer')
        {               
            for(Contact cnt: ODS_Data_Utility.FetchAccountIdByCustomer(objUser.ContactId))
            {
                lstAccountIDs.add(cnt.accountId); 
            }            
        }     
       else if(portalRole == 'Practice Head' )
        {
             accQuery = 'SELECT id, Name, Is_Portal_Access__c,Count_of_ODS_Engagement_Type__c ,Count_of_Services__c   '+
                'FROM Account WHERE Is_Portal_Access__c =: isPortalAccess AND Count_of_Services__c >: count ORDER BY Name ASC ';        
     
            for(Account acc : database.query(accQuery))
            { 
                lstAccountIDs.add(acc.id); 
                
            }   
        }
        else
        {
            accQuery += 'AND User__c =: currentUserId ORDER BY Account__r.Name ASC ';
            for(User_Account__c acc : database.query(accQuery))
            { 
               lstAccountIDs.add(acc.Account__C); 
            }   
        }
    return lstAccountIDs;
    }
    
    /// <OBJECTIVE>
    /// Method to upsert Session data Customsetting
    /// </OBJECTIVE>
    public static void upsertSessionData(string accountId, string serviceid)
    {
        list<ODS_SessionData__c> getSessionData =  fetchSessionData(UserInfo.getUserId());
        ODS_SessionData__c objSessiondata;
        if(getSessionData.size()!= 0)
        {
            String sessionID;
            sessionID = getSessionData[0].id;
            objSessiondata = new  ODS_SessionData__c (Id = sessionID);
            objSessiondata.Current_user_Id__c = UserInfo.getUserId(); 
            objSessiondata.Account_Id__c = accountId;
            objSessiondata.Service_Id__c = serviceid;  
            Update objSessiondata;
        }
        else
        {
            objSessiondata = new  ODS_SessionData__c ();
            objSessiondata.Name = UserInfo.getUserId();
            objSessiondata.Current_user_Id__c = UserInfo.getUserId(); 
            objSessiondata.Account_Id__c = accountId;
            objSessiondata.Service_Id__c = serviceid;  
            insert objSessiondata;
        }
       // return objSessiondata;
    }
    /// <OBJECTIVE>
    /// Method to fetch the Custom setting session data.
    /// </OBJECTIVE>    
    Public static list<ODS_SessionData__c> fetchSessionData(string userID)
    {
        return [SELECT
                    Current_user_Id__c,
                    Account_Id__c,
                    Service_Id__c
                FROM
                    ODS_SessionData__c
                WHERE
                    Current_user_Id__c =: userID];     
     } 
}