/*
* @author           Kiran Babu chandra.
* @version          1.0 
* @date             8/22/2011
* @description      Trigger to get the alert on chatter status change.
* @modifiedBy       Shahida K On 15/03/2016
* @modifiedBy       Hemanth On 16/11/2017
* @description      Trigger functionality to avoid duplicates in account based on website.
*/ 
trigger GoogleAlertToChatterStatusChange on Account (before delete, before insert, before update, after insert, after update) {

// Note: see http://wiki.developerforce.com/index.php/Apex_Code_Best_Practices 
//       for usage of @future and callouts  

  //list to hold all the callout details to execute in the class @future method 
  List<String> methods = new List<String>();
  List<String> endpoints = new List<String>();
  List<String> bodies = new List<String>();

  //if delete, check GA2C Status previous: active = cancel Google Alert
  //EZRE_RecursionCheck rc = new EZRE_RecursionCheck();
  //if(rc.canIRun())    {
   if(EZRE_RecursionCheck.isFutureUpdate != true)
    {
      if (trigger.isDelete) {
        for (Account a : trigger.old) {
          //generate Google Alert remove callout parameters
          methods.add('GET'); //Set HTTPRequest Method 
          endpoints.add(a.Google_Alert_Cancel_URL__c); //Set HTTPRequest Endpoint
          bodies.add(''); //Set the HTTPRequest body    
        } //end delete for loop
      }
      //else if insert|update, check GA2C Status target
      else {
        for (Account a : trigger.new) {
          //if insert or if search terms field is blank, generate it before signing up
          if (a.Google_Alert_Search_Term_s__c == null) {a.Google_Alert_Search_Term_s__c = a.Name; }
          //if GA2C Status target = sign up
          if (a.Google_Alerts_to_Chatter_Status__c == 'Sign Up') {
            //generate Google Alert signup callout parameters
            methods.add('POST'); //Set HTTPRequest Method 
            endpoints.add('www.google.com/alerts/create?hl=en&gl=us');
            bodies.add('q='+a.Google_Alert_Search_Term_s__c.replace(' ','+')+'&t=1'+'&f=0'+'&l=0'+'&e='); //Set HTTPRequest body, add address later 
            //update status -> waiting for confirmation
            a.Google_Alerts_to_Chatter_Status__c = 'Confirming';
          }
          //else if GA2C Status target = cancel
          else if (a.Google_Alerts_to_Chatter_Status__c == 'Cancel') {
            methods.add('GET'); //Set HTTPRequest Method 
            endpoints.add(a.Google_Alert_Cancel_URL__c);
            bodies.add(''); //Set the HTTPRequest body  
            //update status -> inactive
            a.Google_Alerts_to_Chatter_Status__c = 'Inactive';
            a.Google_Alert_Cancel_URL__c = null;
          } // end check status target if
        } // end insert|update for loop
        //Trigger validate account website alredy exist or not .If exist throws error message other wise saves record.
        if(trigger.isbefore)
        {    
             if(Trigger.isInsert)
             {
                 set<String> AccWebSites=new set<String>();          
                  for(Account Acc:Trigger.new)
                  {
                      AccWebSites.add(Acc.Website);
                  }
                  system.debug('Websites@@@'+AccWebSites);
                  List<Account> AccountRec=EZRE_Requirement_DataUtility.fetchAccountBasedOnWebsite(AccWebSites);
                  system.debug('Dup Records@@@'+AccountRec);
                  system.debug('Dup Records size@@@'+AccountRec.Size());
                  if(AccountRec.size()>0)
                  {
                      system.debug('Dup Records size@@@'+AccountRec.Size());
                      for(Account AccRec:Trigger.new)
                      {
                          if(AccRec.Website != null && AccRec.Website != '')
                          {
                              AccRec.Website.AddError('WebSite Already Exist');   
                          }                   
                      }  
                  }               
             }
              //Trigger validate account website alredy exist or not .If exist throws error message other wise updates record
             if(Trigger.isUpdate)
             {
                set<String> AccWebSite=new set<String>();  
                for(Account acc:Trigger.new)    
                {
                    if(Trigger.oldMap.get(acc.id).website!=Trigger.newMap.get(acc.id).website)
                    {
                        AccWebSite.add(acc.website);
                    }   
                    
                }
                list<account> AccountRecords=EZRE_Requirement_DataUtility.fetchAccountBasedOnWebsite(AccWebSite);
                if(AccountRecords.size()>0) 
                {
                    for(Account Acnt:Trigger.new)
                    {           
                          if(Acnt.Website != null && Acnt.Website != '')
                          {        
                           Acnt.website.addError('WebSite Already Exist');                    
                          }  
                    }
                }         
             }
        }
      } //end delete/insert|update if
    
      //call the execute callout method of the GoogleAlertToChatter class
      if (endpoints.size() > 0) {
        GoogleAlertToChatter.executeGoogleAlertsCallouts(methods, endpoints, bodies);
      }
   }
    // Added By Hemanth
    // This functanality will insert and update  records in zoho people
     set<id> accIds = new set<id>();
    if(trigger.isAfter){
        for (Account acc : Trigger.new) {
            if(trigger.isInsert){
                
                accIds.add(acc.Id);
            }
            if(trigger.isUpdate){
                Account oldAccount = Trigger.oldMap.get(acc.Id);
                if(oldAccount.name != acc.name || oldAccount.BillingCity != acc.BillingCity || oldAccount.BillingCountry != acc.BillingCountry|| oldAccount.BillingState != acc.BillingState ) 
                    accIds.add(acc.id);
            }
        }    
        if(accIds != Null && accIds.size() > 0){
            ZohoCallOutHandler.afterInsert(accIds);
        }
    }
    
          if(Trigger.isAfter && Trigger.isupdate){
          if(isRecursive.runOnce()){
            List<Account> Accounttocreatechilds = new List<Account>();
           
                for(Account Acc : Trigger.New)
                {
             //   Account oldAcc = Trigger.oldMap.get(Acc.Id);
                    if(Acc.SOW__c  == 'Fully Executed' && Acc.Created_Childs_Automatically__c == False && Acc.customer_engagement_type__c == 'ODS' && (Acc.Account_Status__c == 'Customer' || Acc.Account_Status__c == 'Active Customer') )
                    {
                   //     string SOWStatus ='Old SOWStatus is ' +oldAcc.SOW__c + ' ; ' + 'New SOWStatus = ' +Acc.SOW__c ;
                  //      System.debug('SOWStatus ==> '+SOWStatus );
                        Accounttocreatechilds.add(Acc);  
                    }
                }
            system.debug('Accounttocreatechilds==='+Accounttocreatechilds);  
            system.debug('Accounttocreatechilds Size==='+Accounttocreatechilds.size());  
            if(Accounttocreatechilds.size() > 0)
                {
                CreateChildswhenSOWisFullyExecuted.createChilds(Accounttocreatechilds);
                }
             }
         }
} // end trigger