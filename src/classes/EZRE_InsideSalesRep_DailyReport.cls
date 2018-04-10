/*
 * @author           Shahida K
 * @version          1.0 
 * @date             23/03/2016
 * @description      Controller for Inside Sales Rep Report Email Alert (Daily)
 */  
Public class EZRE_InsideSalesRep_DailyReport
{

public string  strFilterValue{get;set;}
public List<summary> SummaryRep{get;set;}
public DateTime dttimefromDate{get;set;}
public DateTime dttimeToDate{get;set;}

public List<user> userList;      
public List<account> accountRec;
public List<Contact> contactList;
public List<Contact> AppointmentsList;
public Set<Id> userIdSet;
public Set<Id> accIdSet;
public Set<Id> contIdSet;
public Set<Id> conNewIdSet;
public Map<string,List<account>> accMap;
public Map<string,set<Id>> contMap;
public Map<string,string> TaskMap;
public Map<string,set<Id>> conStatusMap;
public  Map<string,set<Id>> activityMap;
public  list<Task> TaskList;
public string customLabelValue;
public string htmltable;
public integer totalAccounts;
public integer totalContacts;
public integer totalAppointments;

    ///<Objective>
    ///Method is fetch accounts,contacts and Task to prepare report 
    ///</Objective>    
    public void RunReport()
    {
        htmltable='';   
        String greetings='Dear Team,</br></br>';
        date dt=date.today();
        //From DateTime
        dttimefromDate=DateTime.newInstance(dt.year(),dt.month(),dt.day());  
        system.debug('------------------FromDateTime'+dttimefromDate);    
        date dtTommorow=date.today().addDays(1);          
        //To DateTime
        dttimeToDate=DateTime.newInstance(dtTommorow.year(),dtTommorow.month(),dtTommorow.day());   
        system.debug('-------------------ToDateTime'+dttimeToDate);
        userList = new List<User>();
        UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];
        userList = [select id,name,UserRoleId,userrole.name from user where UserRoleId =:UserRole.Id AND isActive=true];
        system.debug('@@@@@@@@@RepuserList '+userList);
        userIdSet = new Set<Id>();
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
        customLabelValue=system.Label.EZRE_InsideSalRepReportCampaign;
        list<string> filterValueList=customLabelValue.split(',');
        
        for(string Filtervalue:filterValueList)
        {
          
             String htmlBody='';
             totalAccounts=0;
             totalContacts=0;
             totalAppointments=0;
            strFilterValue=Filtervalue;
            system.debug('-------------------strFilterValue'+strFilterValue);
            accountRec=new List<account>();
            contactList  = new List<Contact>();
            AppointmentsList  = new List<Contact>();
            accIdSet = new Set<Id>();
            contIdSet = new Set<Id>();
            conNewIdSet = new Set<Id>();
            accMap = new Map<string,List<account>>();
            contMap = new Map<string,set<Id>>();
            TaskMap=new Map<String,string>();
            conStatusMap = new Map<string,set<Id>>();
            activityMap = new Map<string,set<Id>>();
            TaskList=new list<Task>();
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
            contactList =EZRE_Requirement_DataUtility.fetchContacts(accIdSet);
            
            
            system.debug('@@@@@@@@@@@@@@contactList '+contactList ); 
            system.debug('@@@@@@@@@@@@@@contactList size'+contactList.size());  
            for(Contact con: contactList )
            { 
                    contIdSet.add(con.Id);   
            } 
                        
                
            TaskList=EZRE_Requirement_DataUtility.fetchContactTasks(dttimefromDate,dttimeToDate,userIdSet,contIdSet);
            System.debug('################ Today Task List '+TaskList);
            System.debug('################Today Task List size'+TaskList.size());

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
            string contactStatus='3: Meeting Set';    
            AppointmentsList =EZRE_Requirement_DataUtility.fetchContactToCountAppointments(dttimefromDate,dttimeToDate,contactStatus);
            
            system.debug('list of appointments'+AppointmentsList);
            
               
                for(contact cont: AppointmentsList)
                {                
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
            
            Integer noofAccounts;
            Integer noofContacts;
            Integer noofAppointements;
            for(String RepName :RepNamesSet)
            {  
                noofAccounts=0;
                noofContacts=0;
                noofAppointements=0;
                
                system.debug('------------RepName'+RepName);
                if(activityMap.ContainsKey(RepName))
                {
                    noofAccounts = activityMap.get(RepName).size();
                    system.debug('###########noofAccounts'+noofAccounts);
                }    
                if(contMap.ContainsKey(RepName))
                {
                     noofContacts = contMap.get(RepName).size();
                    system.debug('###########noofcontacts'+noofContacts);
                }                
                if(conStatusMap.ContainsKey(RepName))
                {
                    noofAppointements = conStatusMap.get(RepName).size();
                    system.debug('###########noofAppiontments'+noofAppointements);
                }
            SummaryRep.add(New summary(RepName,noofAccounts,noofContacts,noofAppointements));
            totalAccounts=totalAccounts+noofAccounts;
            totalContacts=totalContacts+noofContacts;
            totalAppointments=totalAppointments+noofAppointements;
            }   
            SummaryRep.add(New summary('Grand Total',totalAccounts,totalContacts,totalAppointments)); 
            system.debug('-----SummaryRep'+SummaryRep);   
            String htmlHeader='';     
            String strLink='apex/EZRE_InsideSalesRepReport?FromDate='+dt+'&ToDate='+dt+'&Filter='+strFilterValue+'&ContactFilter='+'None'+'';
            htmlHeader=greetings+'Please find the below Inside Sales Rep Daily Report for '+'<b>'+strFilterValue+'</b>'+' Campaign'+'</br></br> <table border="1"> '+
            '<tr bgcolor="#c4d9ed">'+ 
            '<th>Inside Sales Rep Name</th>' +
            '<th>No.of Accounts</th>' +
            '<th>No.of Contacts</th>' +    
            '<th>No.of Appointments Fixed</th>' +       
            '</tr>';
            system.debug('----------------html header'+htmlHeader);
        
           for(summary sumry:SummaryRep)
           { 
                if(sumry.salesRepName=='Grand Total')
                { 
                    if(htmlBody!='')
                    {   
                        htmlBody+='<b>'+'<tr bgcolor="#c4d9ed">'+
                       '<td>'+sumry.salesRepName+'</td>'+
                       '<td>'+sumry.noOfAccts+'</td>'+
                       '<td>'+sumry.noOfContacts+'</td>'+
                       '<td>'+sumry.noOfAppointments+'</td>'+          
                       +'</tr>'+'</b>';
                   
                    }
                    else
                    {
                       htmlBody='<b>'+'<tr bgcolor="#c4d9ed">'+
                       '<td>'+sumry.salesRepName+'</td>'+
                       '<td>'+sumry.noOfAccts+'</td>'+
                       '<td>'+sumry.noOfContacts+'</td>'+
                       '<td>'+sumry.noOfAppointments+'</td>'+          
                       +'</tr>'+'</b>';
                    }
                }
                else
                {
                  if(htmlBody!='')
                    {   
                        htmlBody+='<tr>'+
                       '<td>'+sumry.salesRepName+'</td>'+
                       '<td>'+sumry.noOfAccts+'</td>'+
                       '<td>'+sumry.noOfContacts+'</td>'+
                       '<td>'+sumry.noOfAppointments+'</td>'+          
                       +'</tr>';
                   
                    }
                    else
                    {
                       htmlBody='<tr>'+
                       '<td>'+sumry.salesRepName+'</td>'+
                       '<td>'+sumry.noOfAccts+'</td>'+
                       '<td>'+sumry.noOfContacts+'</td>'+
                       '<td>'+sumry.noOfAppointments+'</td>'+          
                       +'</tr>';
                    }
                }               
           }
          
            htmltable+=htmlHeader+htmlBody+'</table></br> Please '+'<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+strLink+'">'+ 'Click Here ' +'</a>'+' to get the details of the Inside Sales Rep Report. </br></br>';
            
             
           system.debug('--------------'+htmltable);
           greetings='';
        }
        sendMailAlert(htmltable);
    }
     public void sendMailAlert(String htmltable)
    {
        
        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage(); 
        String ToAddress = System.Label.EZRE_InsideSalRepReprtToAddress;    
        list<string> toAddressList=ToAddress.split(',');  
        email.setToAddresses(toAddressList);       
        system.debug('@@@@@@@@@@@@To Email For Inside Sales Rep Report'+ToAddress);
        OrgWideEmailAddress owea = EZRE_OppActReport_DataUtility.getOrgWideAddress();  
        email.setOrgWideEmailAddressId(owea.Id);                        
        email.setSubject('Inside Sales Rep Daily Report');
        email.setHtmlBody(htmltable+'</br> Regards, </br> EZRE Team');       
        //To Send mail                
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
      
    
    
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