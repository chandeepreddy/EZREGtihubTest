trigger trig_HotList on Candidate__c (After update)
{
    Candidate__c c = Trigger.new[0];  
    if(trigger.isUpdate)
    {
         Map<Id,Candidate__c> newContactMap = Trigger.newMap;  
         Map<Id,Candidate__c> oldContactMap = Trigger.oldMap;      
         
          for(Id contactId:newContactMap.keySet())    
          {     
                Candidate__c myNewContact = newContactMap.get(contactId);  
                Candidate__c myOldContact = oldContactMap.get(contactId);
                //User user = [Select Id from User limit 1];    
                    
                System.Debug('Candidate__c myNewContact :' + myNewContact);  
                System.Debug('Candidate__c myOldContact :' + myOldContact);   
                
                  List<Candidate__c> candidatelist = new List<Candidate__C> ([Select Id,Name,Last_Name__c,Skills__c,Location__c,Relocation__c,Availability__c,bench__c from Candidate__c where bench__c = true limit 20]);
                
                  if (myNewContact.Bench__c <> myOldContact.Bench__c)  
                  {              
                       if(candidatelist != null)
                           {
                               Messaging.SingleEmailMessage mail;
                               for (Candidate__c cc :candidatelist)
                               {
                                  mail = new Messaging.SingleEmailMessage();
                                   
                                   EmailTemplate et = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Hotlist Report'];    
                                   System.Debug('EmailTemplate Id: ' + et.id);
                                   System.Debug('et : ' + et);
                                   mail.setSenderDisplayName('sriram');
                                   
                                   String[] address = new String[]{'vburns@preludesys.com','ayoshikawa@preludesys.com','eburrell@preludesys.com','sandrews@preludesys.com','manjeet@preludesys.com','sr@preludesys.com','sriram@preludesys.com','kiran@preludesys.com'};
                                    mail.setToAddresses(address);
                                   
                                    String plainBody = et.Body;
                                    
                                    User user = [Select Id from User where IsActive = true limit 1];
                                    System.Debug('UserID: ' + user.id);
                                    
                                    mail.setTemplateId(et.id);
                                    String[] address1 = new String[]{'manoj@preludesys.com','ramjee@preludesys.com','ralexander@preludesys.com','vijay@preludesys.com','jai_vijayan@preludesys.com','chandramohan@preludesys.com'};
                                    
                                    mail.setCcAddresses(address1);
                                    
                                    String[] bccaddress = new String[]{'abinaya_s@preludesys.com','thangaprabu_n@preludesys.com'};
                                    
                                    mail.setBccAddresses(bccaddress);
    
                                    mail.saveAsActivity = false;
                                    mail.setTargetObjectId(user.Id);
                                       
                               }
                             List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[] { mail });
                                       System.debug('Email Sent: '+results.get(0).isSuccess() );
                           }
                  }
          }

    }

}