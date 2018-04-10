/**
 * @author           Indhu
 * @version          1.0 
 * @date             12/17/2014
 * @Status           Developed
 * @description      Email Message class for sending Hot List Report to users in mail.
 *
 */
public class EmailMessage
{  
    public List<Candidate__c> candidatelist{get; set;}
    public Messaging.SingleEmailMessage mail {get; set;}
    public EZRE_HotListUsers__c objHotListUsers {get;set;}
    
    public void SendEmail()
    {
        candidatelist = new List<Candidate__C> ([Select Id,Name,Last_Name__c,Skills__c,Location__c,Relocation__c,                                            Availability__c,bench__c from Candidate__c where bench__c = true limit 20]);
        EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Hotlist Report'];
        objHotListUsers = EZRE_HotListUsers__c.getValues('HotListReportMail');
        
        if(candidatelist != null)
        {            
            for (Candidate__c c :candidatelist)
            {
                mail = new Messaging.SingleEmailMessage();  
                String[] strToAddress = (objHotListUsers.HotList_toUsers__c).split(',');
                mail.setToAddresses(strToAddress);
                OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'ezre@preludesys.com' limit 1];
                mail.setOrgWideEmailAddressId(owea.Id); 
                User user = [Select Id from User where IsActive = true limit 1];
                System.Debug('UserID: ' + user.id);
                mail.setTemplateId(et.id);
                String[] strCCAddress = (objHotListUsers.HotList_CCUsers__c).split(',');
                mail.setCcAddresses(strCCAddress);
                mail.saveAsActivity = false;
                mail.setTargetObjectId(user.Id);
            }
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[] { mail });
            System.debug('Email Sent: '+results.get(0).isSuccess() );
        }
    }
}