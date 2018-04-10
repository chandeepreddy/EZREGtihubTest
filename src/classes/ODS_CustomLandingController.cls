/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             28-Sep-2016
 * @Status           Developed
 * @description      The main purpose of this class is for Landing page 
 */

public class ODS_CustomLandingController
{
    public string AccountId {get;set;}
    public string ServiceId {get;set;}
    List<Account_Services__c> accService = new  List<Account_Services__c>();
    PageReference pgRef;
    List<User_Account__c > UsrAccService = new  List<User_Account__c >();
    string currentUserId = UserInfo.getUserId();
    List<Account_Services__c > lstfetchAccServcesByAcc  = new List<Account_Services__c >();
    
    public ODS_CustomLandingController()
    {        
    }
    
    public PageReference PageRedirect()
    {
        system.debug('$$$Login');
        
        List<ODS_SessionData__c> sessiondata = ODS_Common_Utility.fetchSessionData(UserInfo.getUserId());
        system.debug('###sessiondata: '+ sessiondata);
        if(sessiondata.size() != 0)
        {
            AccountId = sessiondata[0].Account_Id__c;
            ServiceId = sessiondata[0].Service_Id__c;  
            system.debug('---AccountId'+AccountId);
            system.debug('---ServiceId'+ServiceId);
            accService = ODS_Data_Utility.fetchAccServcesByAccAndSrv(AccountId,ServiceId);
            system.debug('---accService '+accService );
            if(AccountId != 'All' && ServiceId != 'All')
            {
                Boolean portalAccess = getLoggedUserPortalAccess();
                String portalRole = getLoggedUserPortalRole();
                if(portalAccess == True){
                    pgRef = new PageReference('/apex/Dashboard'); 
                }
                
                //Commented by Indhu to identify account change critical issue 03-Aug-2017
                /*if(portalAccess == True && portalRole != 'Customer' )
                {
                    if(accService[0].Type_of_Engagement__c == 'ODS')
                    {
                        pgRef = new PageReference('/apex/Dashboard'); 
                    } 
                    else
                    {
                        pgRef = new PageReference('/apex/Dashboard_TM');
                    }
                }
                else if(portalAccess == True && portalRole == 'Customer')
                {
                    if(accService[0].Type_of_Engagement__c == 'ODS')
                    {
                        pgRef = new PageReference('/apex/Dashboard'); 
                    } 
                    else
                    {
                        pgRef = new PageReference('/apex/Dashboard_TM');
                    }
                } */
            }            
            else if ((AccountId == 'All' && ServiceId == 'All') || (AccountId == 'All' && ServiceId != 'All') || (AccountId != 'All' && ServiceId == 'All'))
            {
                String portalRole = getLoggedUserPortalRole();
                Boolean isPortalAccess = true;
                integer count = 0;
                integer EngmtTypeCount = 0;
                currentUserId = UserInfo.getUserId();
                user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
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
                    pgRef = new PageReference('/apex/Dashboard'); 
                    
                    //Commented by Indhu to identify account change critical issue 03-Aug-2017
                    /*EngType = getServiceId(accountId);
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
                    }*/
                }
                else if(portalRole == 'Customer')
                {
                    AccountIdSobj = String.valueOf( sObjectsRecrds[0].get('AccountId') );
                    accountId = AccountIdSobj;
                    pgRef = new PageReference('/apex/Dashboard'); 
                    
                    //Commented by Indhu to identify account change critical issue 03-Aug-2017
                    /*EngType = getServiceId(accountId);
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
                    }*/
                }
                else
                {
                    AccountIdSobj= String.valueOf( sObjectsRecrds[0].get('Account__c') );
                    accountId = AccountIdSobj;
                    pgRef = new PageReference('/apex/Dashboard'); 
                    
                    //Commented by Indhu to identify account change critical issue 03-Aug-2017
                    /*EngType = getServiceId(accountId);
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
                    }*/
                }
            }
        }
        else
        {
            String portalRole = getLoggedUserPortalRole();
            Boolean isPortalAccess = true;
            integer count = 0;
            integer EngmtTypeCount = 0;
            currentUserId = UserInfo.getUserId();
            user objUser = ODS_Data_Utility.fetchUserById(UserInfo.getUserId());
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
                pgRef = new PageReference('/apex/Dashboard'); 
                    
                //Commented by Indhu to identify account change critical issue 03-Aug-2017
                /*EngType = getServiceId(accountId);
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
                }*/
            }
            else if(portalRole == 'Customer')
            {
                AccountIdSobj = String.valueOf( sObjectsRecrds[0].get('AccountId') );
                accountId = AccountIdSobj;
                pgRef = new PageReference('/apex/Dashboard'); 
                    
                //Commented by Indhu to identify account change critical issue 03-Aug-2017
                /*EngType = getServiceId(accountId);
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
                }*/
            }
            else
            {
                AccountIdSobj= String.valueOf( sObjectsRecrds[0].get('Account__c') );
                accountId = AccountIdSobj;
                pgRef = new PageReference('/apex/Dashboard'); 
                    
                //Commented by Indhu to identify account change critical issue 03-Aug-2017
                /*EngType = getServiceId(accountId);
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
                }*/
            }
        }
        pgRef.SetRedirect(true);
        return pgRef;    
    }
    
    public string getServiceId(string AccountId)
    {
        string serviceType;
        lstfetchAccServcesByAcc = ODS_Data_Utility.fetchAccServcesByAcc(accountId);
        system.debug('###'+lstfetchAccServcesByAcc );        
        if(lstfetchAccServcesByAcc.size() != 0)
        {
            serviceType = lstfetchAccServcesByAcc[0].Type_of_Engagement__c;
        }
        return serviceType ;
    }
    
    Public boolean getLoggedUserPortalAccess()
    {
        User usr = ODS_Data_Utility.getLoggedUserdetail();
        return usr.Is_Portal_Access__c;
    }
    Public string getLoggedUserPortalRole()
    {
        User usr = ODS_Data_Utility.getLoggedUserdetail();
        return usr.PortalUserRole__c;
    }
}