public class CreateChildswhenSOWisFullyExecuted {
    public static void createChilds(List<Account> acc){
        List<Account_Services__c> objAccountService = new List<Account_Services__c>();
        List<Contact_Account_Service__c> objAcontactAccountService = new List<Contact_Account_Service__c>();
        List<User_Account__c> objUserAccount = new List<User_Account__c>();
        List<Account> UpdateAccount = new List<Account>();
        List<sObject> records = new List<sObject>();
        ODS_Services__c serviceName = [Select Name__c From ODS_Services__c where Name__c = 'Salesforce' limit 1];
        Map<Id, Map<Id,String>> AccountWithUserIds = new Map<Id, Map<Id,String>>();
        Map<Id,String> userMap = new Map<Id,String>();
                 
        for(Account accnt : acc)
        {
            userMap.put(accnt.User__c,'');
            AccountWithUserIds.put(accnt.Id,userMap);
        }
        
        for(user usr : [select Id,PortalUserRole__c from user where Id in: userMap.Keyset()])
        {
            for(Id accId : AccountWithUserIds.keySet())
            {
                If(AccountWithUserIds.get(accId).containsKey(usr.Id))
                {
                    AccountWithUserIds.get(accId).put(usr.Id,usr.PortalUserRole__c);
                }
            }
        }

        for(Account objAccount : acc){
               if(objAccount.SOW__c=='Fully Executed' && objAccount.Primary_Customer_Contact__c !=null || objAccount.Primary_Customer_Contact__c !=''){
                Account_Services__c objServiceAccount = new Account_Services__c();
                Contact_Account_Service__c objContactAccount = new Contact_Account_Service__c();
                User_Account__c objAccountUser = new User_Account__c();
                String AccName = objAccount.Name;
                String AccountName = '';
                If( AccName.length() > 5 )
                    {
                        AccountName = AccName.substring(0,3) + AccName.right(2); 
                    } 
                else
                AccountName = Accname;   
                objAccountUser.Account__c = objAccount.Id;
                if(AccountWithUserIds.containsKey(objAccount.Id))
                {
                    if(AccountWithUserIds.get(objAccount.Id).containsKey(objAccount.User__c))
                    {
                        String portalUserValue = AccountWithUserIds.get(objAccount.Id).get(objAccount.User__c);
                        if(portalUserValue == 'Technical Account Manager' || portalUserValue == 'Practice Head' || portalUserValue == 'Account Manager')
                        {
                            AccountWithUserIds.get(objAccount.Id).put(objAccount.User__c,portalUserValue);
                            objAccountUser.User__c = objAccount.User__c;                      }
                        }
                        else
                        {
                            objAccountUser.addError('The customer success manager role should be either Technical Account Manager, Practice Head or Account Manager');
                        }
                }
                objAccountUser.ODS_Services__c = serviceName.Id;               
                objAccountUser.Role_in_Account__c = 'Technical Account Manager'; 
                               
                objServiceAccount.Account__c = objAccount.Id;               
                objServiceAccount.ODS_Services__c = serviceName.Id;               
                Date dt = objAccount.SOW_Status_Date__c;
                if(dt ==null)
                    dt = Date.today();
                objServiceAccount.Contract_Start_Date__c = dt;
                objServiceAccount.Contract_End_Date__c = dt.addYears(1);
                objServiceAccount.Retainer_Fee_Frequency_Type__c = 'Monthly';
                objServiceAccount.Timesheet_Start_Date__c = dt;
                objServiceAccount.Document_Suffix__c = '_'+AccountName;              
                objServiceAccount.Technical_Account_manager__c = objAccount.User__c;
                objServiceAccount.Retainer_Fee_Amount__c = 0;
                objServiceAccount.ODS_Hourly_Rate_Amount__c = 90;
                
                objContactAccount.Contact__c = objAccount.Primary_Customer_Contact__c;                
                objContactAccount.ODS_Service__c = serviceName.Id;
                objContactAccount.Status_Report_Required__c = true;
                objContactAccount.Is_Approver__c = true;               
                objContactAccount.Account__c = objAccount.Id;
                objContactAccount.Is_initiate_approver__c = true;
                
                objUserAccount.add(objAccountUser);
                objAccountService.add(objServiceAccount);
                objAcontactAccountService.add(objContactAccount);
                }
        }
        insert objUserAccount;
        insert objAcontactAccountService;
        insert objAccountService;
        
        for(Account ac:acc)
        {
            Account a = new Account(id = ac.id);
            a.Created_Childs_Automatically__c = True ; 
            UpdateAccount.add(a); 
        } 
        Update UpdateAccount;
           
            }
    
}