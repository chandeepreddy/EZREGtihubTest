/*
 * @author           Gangadhar R
 * @version          1.0 
 * @date             24/02/2016
 * @description      Controller for EZRE_InsideSalesRepReport
 */  
Public class EZRE_InsideSalesRep_Report
{
public date dtFromDate{get;set;}
public date dtToDate{get;set;}
public string  strFilterValue{get;set;}
public string strContactFilterValue{get;set;}
public date dtNextFromDate{get;set;}
public date dtNextToDate{get;set;}
public List<summary> SummaryRep{get;set;}
public boolean isShowTable{get;set;}
public string ContentType{get;set;}

public String  urlFromDate{get;set;}
public String  urlToDate{get;set;}
public String  urlFilterValue{get;set;}
public String  urlContactFilterValue{get;set;}

 /// <OBJECTIVE>
/// Constructor
/// </OBJECTIVE>   
public EZRE_InsideSalesRep_Report()
{
    //isShowTable = false;
    //isMessage = false;
     urlFromDate = apexpages.CurrentPage().GetParameters().get('FromDate');
     urlToDate = apexpages.CurrentPage().GetParameters().get('ToDate');
     urlFilterValue = apexpages.CurrentPage().GetParameters().get('Filter');
     urlContactFilterValue = apexpages.CurrentPage().GetParameters().get('ContactFilter');
     system.debug('---------------urlContactFilterValue'+urlContactFilterValue);
     system.debug('---------------urlFromDate'+urlFromDate);
     system.debug('---------------urlToDate'+urlToDate);
     system.debug('---------------urlFilterValue'+urlFilterValue);
     
     if((dtFromDate!=null)&&(dtToDate!=null))
    {
        dtNextFromDate = dtFromDate;
        dtNextToDate = dtToDate;
        system.debug('if condition'+dtNextFromDate);
        system.debug('if condition'+dtNextToDate);
    }
    else
    {
        if(urlFromDate!=null)
        {
            dtNextFromDate=Date.valueOf(urlFromDate);
            dtFromDate=Date.valueOf(urlFromDate);
        }
        if(urlToDate!=null)
        {       
            dtNextToDate=Date.valueOf(urlToDate);
            dtToDate=Date.valueOf(urlToDate);
        }
        strFilterValue=urlFilterValue;
        strContactFilterValue=urlContactFilterValue;
        system.debug('else condition dtFromDate '+dtNextFromDate);
        system.debug('else condition dtFromDate '+dtToDate);
        system.debug('else conditiondtNextFromDate'+dtNextFromDate);
        system.debug('else conditiodtNextToDate '+dtNextToDate);
        system.debug('else condition filter'+strFilterValue);
        if((urlFromDate!=null)&&(urlToDate!=null))
        {
            RunReport();
        }
    }
}
///<Objective>
///Method to populate Filter Criteria values for Account
///</Objective>
public LIST<SelectOption> getFilterValues() 
{
   
    LIST<SelectOption> lstFilterValues = new LIST<SelectOption>();     
    lstFilterValues.add(new selectOption('SFDC','Force.com'));
    lstFilterValues.add(new selectOption('DataStax','DataStax'));
    lstFilterValues.add(new selectOption('ODSDotNet','ODS DotNet'));
    return lstFilterValues;
}
///<Objective>
///Method to populate Filter Criteria values for contact
///</Objective>
public LIST<SelectOption> getContactFilterValues() 
{
   
    LIST<SelectOption> lstConFilterValues = new LIST<SelectOption>();     
    lstConFilterValues.add(new selectOption('SFDC','Force.com'));
    lstConFilterValues.add(new selectOption('DataStax','DataStax'));
    lstConFilterValues.add(new selectOption('ODSDotNet','ODS DotNet'));
    return lstConFilterValues;
}

///<Objective>
///Method is the command button action in the controller
///</Objective>    
    public pageReference RunReport()
    {
        isShowTable = true;
        dtNextFromDate =dtFromDate;
        dtNextToDate =dtToDate;
        List<user> userList = new List<User>();
        List<account> accList = new List<account>();
        List<account> accountRec=new List<account>();
        List<Contact> contactList  = new List<Contact>();
        List<Contact> AppointmentsList  = new List<Contact>();
        Set<Id> userIdSet = new Set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> contIdSet = new Set<Id>();
        Set<Id> conNewIdSet = new Set<Id>();
        Map<string,List<account>> accMap = new Map<string,List<account>>();
        Map<string,set<Id>> contMap = new Map<string,set<Id>>();
        Map<string,string> TaskMap=new Map<String,string>();
        Map<string,set<Id>> conStatusMap = new Map<string,set<Id>>();
        Map<string,set<Id>> activityMap = new Map<string,set<Id>>();
        list<Task> TaskList=new list<Task>();
        
       // Map<string,List<Task>> taskSubjMap= new Map<string,List<Task>>();
       UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];
        userList = [select id,name,UserRoleId,userrole.name from user where UserRoleId =:UserRole.Id AND isActive=true];
        system.debug('@@@@@@@@@RepuserList '+userList);
        for(user usr:userList)
        {
            userIdSet.add(usr.Id);
        }
         Set<string> RepNamesSet = new Set<string>();
        
           Schema.DescribeFieldResult fieldResult =
           Account.Inside_SalesRep__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
              RepNamesSet.add(f.getValue());
           }       
            DateTime dttimeToDate;
            DateTime dttimefromDate = datetime.newInstance(dtFromDate.year(), dtFromDate.month(),dtFromDate.day());
            
            if(strFilterValue == 'SFDC' )
            {
                 accountRec=EZRE_Requirement_DataUtility.fetchSFDCCampignAccounts(RepNamesSet);                                         
                 system.debug('***************accList sfdc'+accountRec);  
                system.debug('****************accList accList sfdc size'+accountRec.size());                     
            }
            else if(strFilterValue == 'DataStax')
            {
                 accountRec=EZRE_Requirement_DataUtility.fetchDataStaxCampignAccounts(RepNamesSet);                                       
                         system.debug('**********accList datastax'+accountRec);  
                         system.debug('**********accList size for datastax'+accountRec.size());                               
                         
            }
            else if(strFilterValue == 'ODSDotNet')
            {
                 accountRec=EZRE_Requirement_DataUtility.fetchODSDotNetCampignAccounts(RepNamesSet);                                       
                         system.debug('**********accList datastax'+accountRec);  
                         system.debug('**********accList size for datastax'+accountRec.size());                               
                         
            }                   
           
            for(Account acc:accountRec)
            {
               accIdSet.add(acc.Id);  
            } 
            system.debug('@@@@@@@@@@@@@@@@@@Account ids'+accIdSet);
            if(strContactFilterValue== 'SFDC')
            {
                contactList = EZRE_Requirement_DataUtility.fetchSFDCCampaignContacts(accIdSet);
                system.debug('############Contacts with Force.com'+contactList );
            }
            else if(strContactFilterValue=='DataStax')
            {
                contactList = EZRE_Requirement_DataUtility.fetchDataStaxCampaignContacts(accIdSet);
                system.debug('############Contacts with Data stax'+contactList );
            }
            else if(strContactFilterValue=='ODSDotNet')
            {
                contactList = EZRE_Requirement_DataUtility.fetchODSDotNetCampaignContacts(accIdSet);
                system.debug('############Contacts with ODS .net'+contactList );
            }
            else if(strContactFilterValue=='None')
            {
                contactList = EZRE_Requirement_DataUtility.fetchContacts(accIdSet);
                system.debug('############Contacts with ODS .net'+contactList );
            }

            system.debug('@@@@@@@@@@@@@@contactList '+contactList ); 
            system.debug('@@@@@@@@@@@@@@contactList size'+contactList.size());  
            for(Contact con: contactList )
            { 
                    contIdSet.add(con.Id);   
            } 
                    
            system.debug('@@@@@@@@@@@@@@contactId'+ contIdSet);  
            system.debug('@@@@@@@@@@@@@@contactId'+ contIdSet.size());  
            if(dtToDate == date.Today())
            {   
                system.debug('#################dttimefromDate '+dttimefromDate );        
                dttimeToDate = datetime.now();              
                system.debug('################dttimeToDate'+dttimeToDate);
                TaskList=[select id,whoid,subject,AccountId,createdby.name from Task where  (CreatedDate >: dttimefromDate and CreatedDate <: dttimeToDate)  AND createdby.Id IN: userIdSet AND WhoId IN: contIdSet];
                System.debug('################Task List when Todate is today'+TaskList);
                System.debug('################Task List when Todate is today'+TaskList.size());   
            }               
            else
            {
                dttimeToDate= datetime.newInstance(dtToDate.year(), dtToDate.month(),dtToDate.day());
                System.debug('to date-------else@@@----'+dttimeToDate);
                System.debug('from date-------else@@@----'+dttimefromDate);
                dttimeToDate =dttimeToDate.addHours(23);
                System.debug('to date-------else@@@----'+dttimeToDate);
                dttimeToDate =dttimeToDate.addMinutes(59);
                System.debug('to date-------@@@----'+dttimeToDate);
                dttimeToDate =dttimeToDate.addSeconds(59);
                System.debug('to date-------else@@@----'+dttimeToDate);
                TaskList=[select id,whoid,subject,AccountId,createdby.name from Task where  (CreatedDate >: dttimefromDate and CreatedDate <: dttimeToDate)  AND createdby.Id IN: userIdSet AND WhoId IN: contIdSet];
                System.debug('################Task List when Todate is Not today'+TaskList);
                 System.debug('################Task List when Todate is Not today'+TaskList.size());
            }
            
            system.debug('%%%%%%%%%%%%%%%%%%Task List'+TaskList);
            for(Task tsk: TaskList)
            {               
               if(activityMap.ContainsKey(tsk.createdby.name))
               {
                   activityMap.get(tsk.createdby.name).add(tsk.AccountId);
               }
               else
               {
                   activityMap.Put(tsk.createdby.name,new set<Id>{tsk.AccountId});
               }
               if(contMap.ContainsKey(tsk.createdby.name))
               {
                   contMap.get(tsk.createdby.name).add(tsk.whoId);
               }
               else
               {
                   contMap.Put(tsk.createdby.name,new set<Id>{tsk.whoId});
               }
                TaskMap.put(tsk.whoId,tsk.createdby.name);
                conNewIdSet.add(tsk.whoId);
                
                system.debug('#################contactId and Created by Of task map'+TaskMap);
                system.debug('contact id to get appointment list'+conNewIdSet);
                system.debug('task created by name'+tsk.createdby.name);
                system.debug('account map'+activityMap);   
                system.debug('contact map'+contMap);
            }
            if(dtToDate == date.Today())
            {   
                system.debug('#################dttimefromDate '+dttimefromDate );        
                dttimeToDate = datetime.now();              
                system.debug('################dttimeToDate'+dttimeToDate);
                 AppointmentsList =[select id,lastname,status__C,account.Inside_SalesRep__c  from contact where (Meeting_Set_Date__c >: dttimefromDate and Meeting_Set_Date__c <: dttimeToDate) AND status__C = '3: Meeting Set'];  
            }               
            else
            {
                dttimeToDate= datetime.newInstance(dtToDate.year(), dtToDate.month(),dtToDate.day());
                System.debug('to date-------else@@@----'+dttimeToDate);
                System.debug('from date-------else@@@----'+dttimefromDate);
                dttimeToDate =dttimeToDate.addHours(23);
                System.debug('to date-------else@@@----'+dttimeToDate);
                dttimeToDate =dttimeToDate.addMinutes(59);
                System.debug('to date-------@@@----'+dttimeToDate);
                dttimeToDate =dttimeToDate.addSeconds(59);
                System.debug('to date-------else@@@----'+dttimeToDate);
                 AppointmentsList =[select id,lastname,status__C,account.Inside_SalesRep__c  from contact where (Meeting_Set_Date__c >: dttimefromDate and Meeting_Set_Date__c <: dttimeToDate) AND status__C = '3: Meeting Set'];
            }
           
            system.debug('list of appointments'+AppointmentsList);
            
               
                for(contact cont: AppointmentsList)
                {
                     //String  contactRep=TaskMap.get(cont.Id);
                     //system.debug('-------------contactRepName'+contactRep);
                    if(conStatusMap.ContainsKey(cont.account.Inside_SalesRep__c))
                    {
                       conStatusMap.get(cont.account.Inside_SalesRep__c).add(cont.Id);
                    }
                   else
                    {
                       conStatusMap.Put(cont.account.Inside_SalesRep__c,new set<Id>{cont.Id});
                    }
                   system.debug('inside sales rep name of contact account'+cont.account.Inside_SalesRep__c);
                }
            
            
            system.debug('Task REps'+conStatusMap);
             SummaryRep = new List<summary>();    
            for(string RepName: RepNamesSet)
            {
                Integer noofAccounts = 0; 
                Integer noofContacts = 0;
                Integer noofAppointements = 0;
                if(activityMap.ContainsKey(RepName))
                {
                    noofAccounts = activityMap.get(RepName).size();
                    system.debug('###########noofAccounts'+noofAccounts );
                }    
                if(contMap.ContainsKey(RepName))
                {
                     noofContacts = contMap.get(RepName).size();
                     system.debug('###########noofcontacts'+noofContacts);
                }                
                if(conStatusMap.ContainsKey(RepName))
                {
                    noofAppointements = conStatusMap.get(RepName).size();
                    system.debug('###########noofAppiontments'+noofAppointements );
                }
            SummaryRep.add(New summary(RepName,noofAccounts,noofContacts,noofAppointements));
            }
            dtFromDate = null;
            dtToDate   = null;
  
       return  null;
       
    }
    public void hidetable()
    {
        dtFromDate = null;
        dtToDate   = null;
        isShowTable = false;
    }
    
    public pageReference ExportAsCSV()
    {
        system.debug('@@@@Nextpage'+dtNextFromDate);
        system.debug('@@@@Nextpage'+dtNextToDate);
        pagereference pg = new pagereference('/apex/EZRE_InsideSalesRepReportAsCsv?FromDate='+dtNextFromDate+'&ToDate='+dtNextToDate+'&Filter='+strFilterValue+'&ContactFilter='+strContactFilterValue);
        //pg.SetRedirect(True);
        system.debug('@@@@Nextpage'+SummaryRep);
        return pg;
    }
///<Objective>
///This is a wrapper class.
///</Objective>
    public class summary
    {
        public string   salesRepName{get;set;}
        public integer  noOfAccts{get;set;}
        public integer  noOfContacts{get;set;}
        public integer  noOfAppointments{get;set;}
        
        public summary(string repName,integer noOfAcc,integer noOfContacts,integer noOfAppointments)
        {
            this.salesRepName =repName;
            this.noOfAccts =noOfAcc;
            this.noOfContacts =noOfContacts;
            this.noOfAppointments =noOfAppointments;
        }
    }
}