public class PreludeDBITSController
{
    public string strSelectedAccount{get;set;}
    
    public PreludeDBITSController()
    {
    }
    
    public void SendEmailToDBITS()
    {
        List<Contact> lstContacts = new List<Contact>(); 
        set<id> setConIds = new Set<Id>();    
        lstContacts = getContactEmail();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'sandrews@preludesys.com'];		
        EmailTemplate objEmailTemp = [select Id,body from EmailTemplate where name = 'Prelude DBITS Vendor Mail'];
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
        for(Contact Contact: lstContacts)
        {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTemplateId(objEmailTemp.id);
            msg.setOrgWideEmailAddressId(owea.get(0).Id);
            //msg.setReplyTo('sandrews@preludesys.com');
            //msg.setSenderDisplayName('Sunil Andrews');        
            msg.setTargetObjectId(Contact.Id);            
            msg.setSaveAsActivity(false);
            system.debug('####Mail:'+msg);
            setConIds.add(Contact.Id);
            lstMails.add(msg);           
        }
        Messaging.sendEmail(lstMails);
        List<Contact> lstCon = new List<Contact>();
        for(Id ConId : setConIds)
        {
            Contact objCon = new Contact(id=ConId);
            objCon.Mail_Sent__c = True;
            lstCon.add(objCon);
        }
        update lstCon;
        /*List<Messaging.SendEmailResult> results =  new List<Messaging.SendEmailResult>();
        try
        {
            results = Messaging.sendEmail(lstMails);
        }
        catch(Exception ex)
        {
            Set<ID> targetIdsFailed = new Set<ID>();
            for(Messaging.SendEmailResult emailRslt: results)
            {
                System.debug('Email result ' + emailRslt.IsSuccess());
        
                if(!emailRslt.IsSuccess())
                  {
                     Messaging.SendEmailError[] errArr = emailRslt.getErrors();   
                     targetIdsFailed.add(errArr[0].getTargetObjectId()); 
                  }
            } 
            setConIds.removeAll(targetIdsFailed);
        }*/
        pagereference p = apexpages.Currentpage();            
        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Mail Sent to 100 contacts successfully');
        apexpages.addmessage(msg);
    }
    
    public List<selectoption> getAccountPicklist()
    {
        List<selectoption> lstAccSelect = new List<selectoption>();
        List<Account> lstAccs = new List<Account>();
        lstAccs = [Select id, Name from Account where Name = 'State of Ohio'];
        for(Account objAcc: lstAccs)
        {
            lstAccSelect.add(new SelectOption(objAcc.Id, objAcc.Name));
        }
        return lstAccSelect;        
    }
    
    public List<Contact> getContactEmail()
    {
        List<Contact> lstCon = new List<Contact>();
        List<Account> lstAcc = new List<Account>();
        system.debug('###strSelectedAccount:' +strSelectedAccount);
        lstAcc = [SELECT Id,parentId FROM Account WHERE ParentId =: strSelectedAccount AND isActive__c = True];        
        set<Id> setAccIds = new Set<Id>();
        for(Account Acc: lstAcc)
        {
            setAccIds.add(Acc.id);
        }
        lstCon = [SELECT id,AccountId,Email, Mail_Sent__c FROM Contact where AccountId IN: setAccIds and Email != '' AND Mail_Sent__c = False LIMIT 100];
        return lstCon;
    }
}