/**
* @author           Aarthy
* @version          1.0 
* @date             27-DEC-2017
* @Status           Developed
* @description      This controller is for sending kick off mail and welcome aboard email.
* @ModifiedBy       Anil..
*/

public with sharing class AccountHandler
{       
    /*  This method is for sending welcome_onboard_template and kickoff_template */
    public static void sendEmail(List<Account> List_Accounts, Map<String,OrgWideEmailAddress> Org_wideaddressMap, Map<Id,user> ownerEmailMap, 
                                                                Map<Id,user> CSMMap, Map<Id,Contact> PrimarycontactsMap)
    {
        List<account> accountlist = new List<account>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> toAddress = new List<String>();
        List<String> practice_HeadsAddress = new List<String>();
        List<User> users = [SELECT Email FROM User WHERE PortalUserRole__c = 'Practice Head' AND Email != null AND Management__c = 'Practice Head'];
        
        /*  This loop is for adding all the user_emails to ccAddress whose PortalUserRole= 'Practice Head'*/
        for(User obj_user: users)
        {
            if(obj_user.email != null){
                practice_HeadsAddress.add(obj_user.email);
            }
        }     
        
        for(Account acc: List_Accounts)
        {
            if(acc.SOW__c == 'Fully Executed' && acc.Primary_Customer_Contact__c != null
               && acc.CheckIntroDuplicate__c == false
               && acc.User__c != null
               && acc.isSentIntroductionMail__c == false
               && acc.TriggerKickoffMail__c == false
               && (acc.Account_Status__c == 'Customer' ||
                   acc.Account_Status__c == 'Active Customer'))
            { 
                accountlist.add(acc);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.templateId = Label.welcome_onboard_template;
                
                if(acc.Primary_Customer_Contact__c != null){ 
                    mail.targetObjectId = acc.Primary_Customer_Contact__c;
                }
                
                /* Add the account owner as from address to the mail whose account owner email is not null. */
                if(ownerEmailMap.containsKey(acc.ownerId))
                {
                    user owner = ownerEmailMap.get(acc.ownerId);
                    if(Org_wideaddressMap.containskey(owner.Email) && Org_wideaddressMap.get(owner.Email) != null)
                    {
                        OrgWideEmailAddress owaAddress=Org_wideaddressMap.get(owner.Email);                        
                        mail.setOrgWideEmailAddressId(owaAddress.id);                                              
                    }  
                }
                
                
                /* Add Primary customer contact as to address whose email is not null and the
                   Customer Success Manager mail as ccAddress whose email is not null . */
                if(PrimarycontactsMap.containsKey(acc.Primary_Customer_Contact__c)&& PrimarycontactsMap.get(acc.Primary_Customer_Contact__c).email!=null)
                {
                    toAddress.add(PrimarycontactsMap.get(acc.Primary_Customer_Contact__c).email);                     
                    mail.toAddresses = toAddress;
                    mail.setBccSender(false);
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setWhatId(acc.id);
                    mail.setSaveAsActivity(true);  
                    List<String> ccAddress = new List<String>();
                    if(CSMMap.get(acc.User__c).Email != null)
                    {
                        ccAddress.add(CSMMap.get(acc.User__c).Email);  
                    }
                    if(practice_HeadsAddress.size() > 0)
                    {
                        ccAddress.addAll(practice_HeadsAddress);
                        mail.ccAddresses = ccAddress;
                    }
                    mails.add(mail);
                }
            }
        }
        
        System.debug('Total outbound emails: '+mails.size());
        if(mails.size() > 0)
        {
              Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(mails);
              for(Account acc:accountlist){
                   acc.Introduction_Email__c = 'Completed';
                   acc.isSentIntroductionMail__c = true;
              }
        }
        
        mails.clear();
        accountlist.clear();
        toAddress.clear();
        
        for(Account acc: List_Accounts)
        {
            if(acc.SOW__c == 'Fully Executed'
                   && acc.Primary_Customer_Contact__c != null
                   && acc.User__c != null
                   && acc.isSentIntroductionMail__c == true
                   && acc.TriggerKickoffMail__c == true
                    && acc.CheckIntroDuplicate__c == false
                   && (acc.Account_Status__c == 'Customer' ||
                       acc.Account_Status__c == 'Active Customer')
              ){
                    accountlist.add(acc);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.templateId = Label.kickoff_template; 
                    
                    if(acc.Primary_Customer_Contact__c != null){
                        mail.targetObjectId = acc.Primary_Customer_Contact__c;
                    }
                    
                    /* Add CSM email address as from address whose email is not null */
                    if(CSMMap.containsKey(acc.user__c))
                    {
                        user CSM = CSMMap.get(acc.user__c);
                        if(CSM.Email != null)
                        {                  
                            if(Org_wideaddressMap.containskey(CSM.Email))
                            {
                               OrgWideEmailAddress owaAddress=Org_wideaddressMap.get(CSM.Email);                     
                               mail.setOrgWideEmailAddressId(owaAddress.id);                                           
                            }
                        }  
                    }
                    
                    /* Add Primary customer contact as to address whose email is not null and 
                       the owner email in ccAddress whose email is not null. */
                    if(PrimarycontactsMap.containsKey(acc.Primary_Customer_Contact__c)&& PrimarycontactsMap.get(acc.Primary_Customer_Contact__c).email!=null)
                    {
                        toAddress.add(PrimarycontactsMap.get(acc.Primary_Customer_Contact__c).email);  
                        mail.toAddresses = toAddress;
                        mail.setBccSender(false);
                        mail.setTreatTargetObjectAsRecipient(false);
                        mail.setWhatId(acc.id);
                        mail.setSaveAsActivity(true);
                        List<String> ccAddress = new List<String>();
                        if(ownerEmailMap.containsKey(acc.ownerId)&&ownerEmailMap.get(acc.ownerId).email != null)
                        {
                            ccAddress.add(ownerEmailMap.get(acc.ownerId).email);  
                        }                       
                        if(practice_HeadsAddress.size() > 0)
                        {
                            ccAddress.addAll(practice_HeadsAddress);
                        
                            mail.ccAddresses = ccAddress;
                        }                   
                        mails.add(mail);               
                    }
                }          
        }
      
      
        
      if(mails.size() > 0)
      {
          Messaging.SendEmailResult[] mailResult = Messaging.sendEmail(mails);
      }       
      for(account acc:accountlist){
           acc.Kickoff__c = 'Email Sent';
           acc.CheckIntroDuplicate__c = true;
      }   
    
  }


    public static void SendEnvironmentAccessEmail(List<Account> acctsToSendEmail, Map<String,OrgWideEmailAddress> Org_wideaddressMap, Map<Id,user> ownerEmailMap, 
                                                                Map<Id,user> CSMMap, Map<Id,Contact> PrimarycontactsMap)
    {
        List<account> acclist = new List<account>();
        System.debug('Executing email loop');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> toAddr = new List<String>();
        List<String> ccAddr = new List<String>();
             
        for(User u:[SELECT Email FROM User WHERE PortalUserRole__c = 'Practice Head' AND Email != null AND Management__c = 'Practice Head'])
        {
            system.debug('ccAddr 1'+u.email);
            
            ccAddr.add(u.email);
        }      
        for(Account a: acctsToSendEmail)
        {       
            acclist.add(a);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.templateId = Label.EnvironmentAccess_Template; 
            mail.targetObjectId = a.Primary_Customer_Contact__c;
            if(CSMMap.containsKey(a.user__c))
            {
                user CSM = CSMMap.get(a.user__c);
                system.debug('CSM' +CSM.Email);                   
                if(Org_wideaddressMap.containskey(CSM.Email))
                {
                   system.debug('CSM' +CSM.Email);                        
                   OrgWideEmailAddress owaAddress=Org_wideaddressMap.get(CSM.Email);                     
                   mail.setOrgWideEmailAddressId(owaAddress.id);                                           
                }  
            }
            toAddr = new List<String>();
            if(PrimarycontactsMap.containsKey(a.Primary_Customer_Contact__c)&& PrimarycontactsMap.get(a.Primary_Customer_Contact__c).email!=null)
            {
                toAddr.add(PrimarycontactsMap.get(a.Primary_Customer_Contact__c).email);  
                system.debug('toAddr123'+toAddr);
                mail.toAddresses = toAddr;
                mail.setBccSender(false);
                mail.setTreatTargetObjectAsRecipient(false);
                mail.setSaveAsActivity(false);
                List<String> ccAddress = new List<String>();
                if(ownerEmailMap.containsKey(a.ownerId)&&ownerEmailMap.get(a.ownerId).email != null)
                {
                    ccAddress.add(ownerEmailMap.get(a.ownerId).email);  
                }                       
                if(ccAddr.size() > 0)
                {
                    ccAddress.addAll(ccAddr);           
                    mail.ccAddresses = ccAddress;
                }                   
                mails.add(mail);               
            }
        }   
        if(mails.size() > 0)
        {
            Messaging.SendEmailResult[] mailResult = Messaging.sendEmail(mails);
        }
        List<account> acctsToUpdate = new List<account>();
        for(account ac:acclist){
           Account acctToUpdt = new Account(Id=ac.Id);
           acctToUpdt.IsEnvironmentAccessEmail__c = True;
           acctsToUpdate.add(acctToUpdt);
        } 
        update acctsToUpdate;
    }
}