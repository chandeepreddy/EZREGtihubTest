/**
 * @author           Kirankumar 
 * @version          1.0 
 * @date             26/04/2017
 * @Status           Developed
 * @description      Controller class for to add work allocation object records.
 */
 
public class EZRE_ContactDailyCallListAllocation
{
    public void execute()
    {
     String accountQry;
     String contactQry;
     Account_Call_List_Allocation__c AcntcallListDetails;
     integer dailyLimit;
    
     String repNames;
     String accountStatus;
     List<Account> acntLst = new List<Account>();
     List<Contact> cntLst = new List<Contact>();
     String AcntFieldApiName;
     String ISRFldApiName;
     List<String> accountStatusLst  = new List<String>();
     Integer anualRevenueLimit;
     List<String> allrepNames  = new List<String>(); 
     List<String> allrepNameslst  = new List<String>(); 
     string AcntStatusAPI;
    
     List <String> repNamesSet = new List<String>();
     Set<String> accountStatusSet  = new Set<String>();
    
     string contactNumberValidation;
     string contactstatus;
     List<string> contactStatusList = new List<string> ();
     List<string> contactNoValidationList  = new List<string> ();
     string contactStatusFieldApiName;
     string campaignNamefrmCstmStng;

    
     Map<string,List<Contact>> mapofISRsWithContacts = new Map<string,List<Contact>>();
     Map<Id,string> mapofAccountIdWithRepName = new Map<Id,string>();
     Map<string,string> mapofRepNameWithCampgnName = new Map<string,string>();
     set<id> accountIds = new set<Id>();
     Map<string,List<string>> mapofCampaignNameWithAssignedReps = new Map<string,List<string>>();
     List < Work_Allocation__c > workAllocations = new List < Work_Allocation__c > ();
        
     //Fetch Account filter values from Custom settings
     Map <String,Account_Call_List_Allocation__c> callAcntAllocationMap = Account_Call_List_Allocation__c.getAll();
     system.debug('callAcntAllocationMap==='+callAcntAllocationMap);
        
        for(String AcntCamp : callAcntAllocationMap.Keyset())
        {
            allrepNameslst.clear();
            accountIds.clear();
            AcntcallListDetails = callAcntAllocationMap.get(Acntcamp); 
            system.debug('AcntcallListDetails==='+AcntcallListDetails );
            
            campaignNamefrmCstmStng = AcntcallListDetails.Name;
            
            repNames = AcntcallListDetails.Account_ISR_Name__c;
            ISRFldApiName = AcntcallListDetails.ISR_Field_API_Name__c;
            system.debug('repNames ==='+repNames );
            
            AcntFieldApiName = AcntcallListDetails.Account_Campaign_Name__c;
            system.debug('AcntFieldApiName ==='+AcntFieldApiName );
           
            AcntStatusAPI = AcntcallListDetails.Status_Field_API_Name__c;
            system.debug('AcntStatusAPI ==='+AcntStatusAPI  );
            
            dailyLimit = integer.valueof(AcntcallListDetails.Daily_Limit__c);
            
            //Fetching contact filter conditions from custom settings
            contactNumberValidation = AcntcallListDetails.Contact_NumberValidation__c;
            contactStatus = AcntcallListDetails.Contact_Status__c;
            contactStatusFieldApiName = AcntcallListDetails.Contact_Status_Field_API_Name__c;
            
            //getting contact status list
            if(!string.isBlank(contactStatus))
                contactStatusList = contactStatus.split(',');
            
            
            //Custom setting Rep Names List
            if(!String.isBlank(repNames))
                allrepNames=repNames.split(',');
                system.debug('allrepNames==='+allrepNames);
           
            for(String strRep:allrepNames)     
            {
                system.debug('strRep==='+strRep);
                if((strRep!=null)&&(strRep!=' '))
                {
                      allrepNameslst.add(strRep);    
                }
                system.debug('allrepNameslst==='+allrepNameslst);
            }
            
             
            //Custom setting Account Status 
            accountStatus=AcntcallListDetails.Account_Status__c;
            if(!String.isBlank(accountStatus))
                accountStatusLst=accountStatus.split(',');
            system.debug('accountStatusLst==='+accountStatusLst);
            
            
            //Fetch Number validation from Custom settings
            if(!String.isBlank(contactNumberValidation))
            {
                contactNoValidationList = contactNumberValidation.split(',');
                contactNoValidationList.add('');
            }
            system.debug('contactNoValidationList==='+contactNoValidationList);
            
            
            
            anualRevenueLimit = Integer.valueOf(AcntcallListDetails.Account_Annual_Revenue__c);
            
            for(string reps : allrepNameslst)
            {
                if(mapofCampaignNameWithAssignedReps.containsKey(campaignNamefrmCstmStng ))
                    mapofCampaignNameWithAssignedReps.get(campaignNamefrmCstmStng ).add(reps);
                else
                    mapofCampaignNameWithAssignedReps.put(campaignNamefrmCstmStng ,new List<string> {reps});
                    
            }
            system.debug('$$mapofCampaignNameWithAssignedReps'+mapofCampaignNameWithAssignedReps);
            
            //for loop to assign values to map
            for(string reps : allrepNameslst)
            {
                    mapofRepNameWithCampgnName.put(reps,campaignNamefrmCstmStng);
            }
            system.debug('$$mapofRepNameWithCampgnName'+mapofRepNameWithCampgnName);
            
            if(allrepNameslst.size() > 0)
            {
                accountQry = 'SELECT ID,Inside_SalesRep__c,ODS_AWS_Inside_SalesRep__c,Force_com_Account_Status__c,ODS_AWS_Account_Status__c  from Account WHERE AnnualRevenue >=: anualRevenueLimit AND ' + AcntFieldApiName + ' = true AND ' + ISRFldApiName + ' IN: allrepNameslst AND ' + AcntStatusAPI + ' IN: accountStatusLst';  
            }
            system.debug('accountQry***'+accountQry );
            
            // fetch account records
            acntLst = database.query(accountQry );
            system.debug('acntLst ==='+acntLst );
            
            string repNameforAcntId;

            for(Account account : acntLst)
            {
                repNameforAcntId = (string)account.get(ISRFldApiName);
                accountIds.add(account.Id);
                mapofAccountIdWithRepName.put(account.Id,repNameforAcntId );
            }
            
            system.debug('accountIds**==='+accountIds);
            system.debug('mapofAccountIdWithRepName**==='+mapofAccountIdWithRepName);
            
          // contactQry = 'SELECT Id,Name,Email,Phone,Timezone__c,Status__c,Account.Id,Activity_Created_Date__c,Force_com__c ,ODS_AWS__c,Account.Inside_SalesRep__c , Account.ODS_AWS_Inside_SalesRep__c,ODS_AWS_Status__c,Account.Force_com_Account_Status__c,Account.ODS_AWS_Account_Status__c  from Contact WHERE ' + AcntFieldApiName + ' = true AND ' + contactStatusFieldApiName + ' IN: contactStatusList AND Number_Validation__c IN: contactNoValidationList AND AccountID IN: accountIds Order by LastActivityDate'; 
            
           contactQry = 'SELECT Id,Name,Email,Phone,Timezone__c,Status__c,Account.Id,Activity_Created_Date__c,Force_com__c ,ODS_AWS__c,Account.Inside_SalesRep__c , Account.ODS_AWS_Inside_SalesRep__c,ODS_AWS_Status__c,Account.Force_com_Account_Status__c,Account.ODS_AWS_Account_Status__c from Contact WHERE '+'('+ AcntFieldApiName + ' = true AND ' + contactStatusFieldApiName + ' IN: contactStatusList AND AccountID '+' IN: accountIds'+')'+' AND '+'('+'Number_Validation__c IN: contactNoValidationList OR email '+'!=null '+')'+'Order by LastActivityDate';
            // fetch contact records
            cntLst = database.query(contactQry );
            system.debug('cntLst **==='+cntLst.size());
            
            
            List<Contact> contactsLst = new List<Contact>();
        
            if(cntLst.size() > 0)
            {
                for(Contact contact : cntLst)
                {
                    
                    string repName = (string)contact.getSobject('Account').get(ISRFldApiName);
                    string acntStatus = (string)contact.getSobject('Account').get(AcntStatusAPI);
                    string conctStatus = (string)contact.get(contactStatusFieldApiName );
                    system.debug('repName **==='+repName );
                    system.debug('contact **==='+contact );
                   
                    if(repName != '' && repName != null)
                    {
                        if(mapofISRsWithContacts.containsKey(repName))
                        {
                            if(mapofISRsWithContacts.get(repName).size() < dailyLimit)
                            {
                                  mapofISRsWithContacts.get(repName).add(contact);
                                
                                 
                                  Work_Allocation__c objwork = new Work_Allocation__c();
                                  objwork.Contact__c = contact.Id;
                                  objwork.Email__c = contact.Email;  
                                  objwork.Phone__c = contact.Phone;
                                  objwork.TimeZone__c = contact.Timezone__c;
                                  objwork.Account_Name__c = contact.Account.Id;
                                  objwork.Is_Daily_CallList__c = true;
                                  objwork.Campaign__c = mapofRepNameWithCampgnName.get(repName);
                                  objwork.name = repName;
                                  objwork.Assigned_Account_Status__c = acntStatus;
                                  objwork.Assigned_Contact_Status__c = conctStatus ;
                                  workAllocations.add(objwork);    
                            }                       
                        }
                        else
                        {
                            mapofISRsWithContacts.put(repName ,new List<Contact> {contact});
                            system.debug('mapofISRsWithContacts**put==='+mapofISRsWithContacts);
                            Work_Allocation__c objwork = new Work_Allocation__c();
                            objwork.Contact__c = contact.Id;
                            objwork.Email__c = contact.Email;  
                            objwork.Phone__c = contact.Phone;
                            objwork.TimeZone__c = contact.Timezone__c;
                            objwork.Account_Name__c = contact.Account.Id;
                            objwork.Is_Daily_CallList__c = true;
                            objwork.Campaign__c = mapofRepNameWithCampgnName.get(repName);
                            objwork.name = repName;
                            objwork.Assigned_Account_Status__c = acntStatus;
                            objwork.Assigned_Contact_Status__c = conctStatus ;
                            workAllocations.add(objwork);
                        }
                    }
                    
                }
            }
             system.debug('mapofISRsWithContactsKey**==='+mapofISRsWithContacts.keyset());
             system.debug('%%mapofISRsWithContacts**==='+mapofISRsWithContacts);
             system.debug('%%workAllocations**==='+workAllocations.size());
     }
     
     
             EZRE_Data_Utility.insertWorkAllocationList(workAllocations);

    }
    
}